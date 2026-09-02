package handlers

import (
	"bytes"
	"database/sql"
	"encoding/json"
	"estate-map-api/database"
	"fmt"
	"net/http/httptest"
	"os"
	"testing"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
	"github.com/joho/godotenv"
)

func TestListingAutoPublishesThenSuperAdminCanUnapprove(t *testing.T) {
	if os.Getenv("MAPXPROP_DB_INTEGRATION") != "1" {
		t.Skip("set MAPXPROP_DB_INTEGRATION=1 to run the database integration test")
	}
	if err := godotenv.Load("../.env"); err != nil {
		t.Fatal("load moderation integration database environment:", err)
	}

	db := database.ConnectDB()
	defer db.Close()
	if err := database.RunMigrations(db); err != nil {
		t.Fatal("run moderation migrations:", err)
	}

	var adminID int64
	var adminPublicUserID, adminEmail string
	if err := db.QueryRow(`
		SELECT id, public_user_id::text, email
		FROM public.auth_users
		WHERE lower(email) = $1 AND role_code = 'super_admin' AND deleted_at IS NULL
	`, primarySuperAdminEmail).Scan(&adminID, &adminPublicUserID, &adminEmail); err != nil {
		t.Fatal("load primary super admin:", err)
	}

	ownerPublicUserID := uuid.NewString()
	ownerEmail := fmt.Sprintf("codex-moderation-%s@example.invalid", uuid.NewString())
	var ownerID int64
	if err := db.QueryRow(`
		INSERT INTO public.auth_users (
			public_user_id, email, password_hash, provider, is_active, is_verified,
			password_changed_at, last_login_at, updated_at
		) VALUES ($1, $2, 'integration-test-only', 'email', true, true, now(), now(), now())
		RETURNING id
	`, ownerPublicUserID, ownerEmail).Scan(&ownerID); err != nil {
		t.Fatal("create moderation owner:", err)
	}

	adminTokenID := uuid.NewString()
	ownerTokenID := uuid.NewString()
	expiresAt := time.Now().UTC().Add(10 * time.Minute)
	if _, err := db.Exec(`
		INSERT INTO public.auth_sessions (user_id, token_id, expires_at)
		VALUES ($1, $2, $5), ($3, $4, $5)
	`, adminID, adminTokenID, ownerID, ownerTokenID, expiresAt); err != nil {
		t.Fatal("create moderation sessions:", err)
	}
	defer func() {
		if _, err := db.Exec(`DELETE FROM public.auth_sessions WHERE token_id = $1`, adminTokenID); err != nil {
			t.Errorf("delete admin moderation session: %v", err)
		}
		if _, err := db.Exec(`DELETE FROM public.auth_users WHERE id = $1 AND email = $2`, ownerID, ownerEmail); err != nil {
			t.Errorf("delete moderation owner: %v", err)
		}
	}()

	adminToken, err := createAccessToken(adminID, adminPublicUserID, adminEmail, adminTokenID, expiresAt)
	if err != nil {
		t.Fatal(err)
	}
	ownerToken, err := createAccessToken(ownerID, ownerPublicUserID, ownerEmail, ownerTokenID, expiresAt)
	if err != nil {
		t.Fatal(err)
	}

	app := fiber.New()
	app.Post("/listings", CreateListing(db))
	app.Get("/listings/:slug", GetListingBySlug(db))
	app.Get("/admin/listings/review", GetAdminReviewListings(db))
	app.Get("/admin/listings/:publicListingID/review", GetAdminReviewListing(db))
	app.Patch("/admin/listings/:publicListingID/moderation", UpdateListingModeration(db))
	app.Get("/me/notifications", GetMyNotifications(db))
	app.Patch("/me/notifications/:notificationID/read", MarkMyNotificationRead(db))

	payload := integrationListingPayload(selectableListingCategoryCases[0], "", "", "")
	payload.MediaItems = nil
	payload.Title = "Moderation integration " + uuid.NewString()
	payload.ContactEmail = ownerEmail
	createdBody := moderationRequest(t, app, "POST", "/listings", ownerToken, payload, fiber.StatusCreated)
	var created struct {
		PublicListingID string `json:"public_listing_id"`
		Slug            string `json:"slug"`
		Status          string `json:"status"`
		Moderation      string `json:"moderation_status"`
	}
	if err := json.Unmarshal(createdBody, &created); err != nil {
		t.Fatal(err)
	}
	if created.PublicListingID == "" || created.Slug == "" || created.Status != "active" || created.Moderation != "approved" {
		t.Fatalf("listing was not automatically approved: %#v", created)
	}

	// Auto-approved listings are public and appear in the super-admin published list.
	moderationRequest(t, app, "GET", "/listings/"+created.Slug, "", nil, fiber.StatusOK)
	moderationRequest(t, app, "GET", "/admin/listings/review", "", nil, fiber.StatusUnauthorized)
	moderationRequest(t, app, "GET", "/admin/listings/review", ownerToken, nil, fiber.StatusForbidden)
	queueBody := moderationRequest(t, app, "GET", "/admin/listings/review?status=approved&q="+ownerEmail, adminToken, nil, fiber.StatusOK)
	var queue struct {
		Listings []adminReviewListingResponse `json:"listings"`
	}
	if err := json.Unmarshal(queueBody, &queue); err != nil {
		t.Fatal(err)
	}
	if len(queue.Listings) != 1 || queue.Listings[0].PublicListingID != created.PublicListingID {
		t.Fatalf("published moderation list mismatch: %#v", queue.Listings)
	}

	// Creation sends one deduplicated published notification, including on request retry.
	notifications := readModerationNotifications(t, app, ownerToken)
	if notifications.UnreadCount != 1 || len(notifications.Notifications) != 1 || notifications.Notifications[0].NotificationType != "listing_published" {
		t.Fatalf("automatic publish notification mismatch: %#v", notifications)
	}
	retryBody := moderationRequest(t, app, "POST", "/listings", ownerToken, payload, fiber.StatusCreated)
	var retryCreated struct {
		PublicListingID string `json:"public_listing_id"`
	}
	if err := json.Unmarshal(retryBody, &retryCreated); err != nil || retryCreated.PublicListingID != created.PublicListingID {
		t.Fatalf("idempotent retry mismatch: body=%s err=%v", retryBody, err)
	}
	notifications = readModerationNotifications(t, app, ownerToken)
	if len(notifications.Notifications) != 1 {
		t.Fatalf("retry created duplicate publish notification: %#v", notifications)
	}

	// A reason is mandatory before hiding a listing.
	moderationRequest(t, app, "PATCH", "/admin/listings/"+created.PublicListingID+"/moderation", adminToken, updateListingModerationRequest{Action: "unapprove"}, fiber.StatusBadRequest)
	unapproveBody := moderationRequest(t, app, "PATCH", "/admin/listings/"+created.PublicListingID+"/moderation", adminToken, updateListingModerationRequest{Action: "unapprove", Note: "Images do not match the property"}, fiber.StatusOK)
	var unapproveResult struct {
		Success   bool `json:"success"`
		Published bool `json:"published"`
		Unchanged bool `json:"unchanged"`
	}
	if err := json.Unmarshal(unapproveBody, &unapproveResult); err != nil || !unapproveResult.Success || unapproveResult.Published || unapproveResult.Unchanged {
		t.Fatalf("unapproval response mismatch: body=%s err=%v", unapproveBody, err)
	}

	var listingID int64
	var moderationStatus, moderationNote string
	var publishedAt sql.NullTime
	var moderatedBy sql.NullInt64
	if err := db.QueryRow(`
		SELECT id, moderation_status, COALESCE(moderation_note, ''), published_at, moderated_by_user_id
		FROM public.listings WHERE public_listing_id::text = $1
	`, created.PublicListingID).Scan(&listingID, &moderationStatus, &moderationNote, &publishedAt, &moderatedBy); err != nil {
		t.Fatal(err)
	}
	if moderationStatus != "rejected" || moderationNote != "Images do not match the property" || publishedAt.Valid || !moderatedBy.Valid || moderatedBy.Int64 != adminID {
		t.Fatalf("stored unapproval mismatch: status=%q note=%q published=%v by=%v", moderationStatus, moderationNote, publishedAt, moderatedBy)
	}
	moderationRequest(t, app, "GET", "/listings/"+created.Slug, "", nil, fiber.StatusNotFound)
	notifications = readModerationNotifications(t, app, ownerToken)
	if len(notifications.Notifications) != 2 || notifications.Notifications[0].NotificationType != "listing_changes_requested" {
		t.Fatalf("unapproval notification mismatch: %#v", notifications)
	}

	// Repeating the action does not create another audit or notification.
	repeatBody := moderationRequest(t, app, "PATCH", "/admin/listings/"+created.PublicListingID+"/moderation", adminToken, updateListingModerationRequest{Action: "unapprove", Note: "Images do not match the property"}, fiber.StatusOK)
	var repeat struct {
		Unchanged bool `json:"unchanged"`
	}
	if err := json.Unmarshal(repeatBody, &repeat); err != nil || !repeat.Unchanged {
		t.Fatalf("repeated unapproval was not idempotent: body=%s err=%v", repeatBody, err)
	}
	if count := moderationNotificationCount(t, db, listingID); count != 2 {
		t.Fatalf("repeated unapproval created duplicate notifications: %d", count)
	}

	// Super admin can approve it again; publication and owner notification return atomically.
	moderationRequest(t, app, "PATCH", "/admin/listings/"+created.PublicListingID+"/moderation", adminToken, updateListingModerationRequest{Action: "approve"}, fiber.StatusOK)
	moderationRequest(t, app, "GET", "/listings/"+created.Slug, "", nil, fiber.StatusOK)
	if count := moderationNotificationCount(t, db, listingID); count != 3 {
		t.Fatalf("reapproval notification missing: %d", count)
	}
	var approvedAudit, hiddenAudit int
	if err := db.QueryRow(`SELECT count(*) FILTER (WHERE action = 'approved'), count(*) FILTER (WHERE action = 'changes_requested') FROM public.listing_moderation_audit WHERE listing_id = $1`, listingID).Scan(&approvedAudit, &hiddenAudit); err != nil {
		t.Fatal(err)
	}
	if approvedAudit != 1 || hiddenAudit != 1 {
		t.Fatalf("moderation audit mismatch: approved=%d hidden=%d", approvedAudit, hiddenAudit)
	}

	// Editing keeps the listing approved/public and does not duplicate the initial publish notification.
	payload.EditingPublicListingID = created.PublicListingID
	payload.Title += " edited"
	moderationRequest(t, app, "POST", "/listings", ownerToken, payload, fiber.StatusCreated)
	moderationRequest(t, app, "GET", "/listings/"+created.Slug, "", nil, fiber.StatusOK)
	if count := moderationNotificationCount(t, db, listingID); count != 3 {
		t.Fatalf("editing created an unexpected notification: %d", count)
	}
}

type moderationNotificationsBody struct {
	Notifications []userNotificationResponse `json:"notifications"`
	UnreadCount   int                        `json:"unread_count"`
}

func readModerationNotifications(t *testing.T, app *fiber.App, ownerToken string) moderationNotificationsBody {
	t.Helper()
	body := moderationRequest(t, app, "GET", "/me/notifications", ownerToken, nil, fiber.StatusOK)
	var result moderationNotificationsBody
	if err := json.Unmarshal(body, &result); err != nil {
		t.Fatal(err)
	}
	return result
}

func moderationNotificationCount(t *testing.T, db *sql.DB, listingID int64) int {
	t.Helper()
	var count int
	if err := db.QueryRow(`SELECT count(*) FROM public.user_notifications WHERE listing_id = $1`, listingID).Scan(&count); err != nil {
		t.Fatal(err)
	}
	return count
}

func moderationRequest(t *testing.T, app *fiber.App, method, path, token string, body any, wantStatus int) []byte {
	t.Helper()
	var payload []byte
	if body != nil {
		var err error
		payload, err = json.Marshal(body)
		if err != nil {
			t.Fatal(err)
		}
	}
	request := httptest.NewRequest(method, path, bytes.NewReader(payload))
	if body != nil {
		request.Header.Set("Content-Type", "application/json")
	}
	if token != "" {
		request.Header.Set("Authorization", "Bearer "+token)
	}
	response, err := app.Test(request, -1)
	if err != nil {
		t.Fatal(err)
	}
	defer response.Body.Close()
	var responseBody bytes.Buffer
	if _, err := responseBody.ReadFrom(response.Body); err != nil {
		t.Fatal(err)
	}
	if response.StatusCode != wantStatus {
		t.Fatalf("%s %s status=%d want=%d body=%s", method, path, response.StatusCode, wantStatus, responseBody.String())
	}
	return responseBody.Bytes()
}
