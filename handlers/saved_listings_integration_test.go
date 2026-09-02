package handlers

import (
	"bytes"
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

func TestSavedListingsPersistMergeAndRespectVisibility(t *testing.T) {
	if os.Getenv("MAPXPROP_DB_INTEGRATION") != "1" {
		t.Skip("set MAPXPROP_DB_INTEGRATION=1 to run the database integration test")
	}
	if err := godotenv.Load("../.env"); err != nil {
		t.Fatal("load saved-listings integration database environment:", err)
	}
	requireSafeIntegrationDatabase(t)

	db := database.ConnectDB()
	defer db.Close()
	if err := database.RunMigrations(db); err != nil {
		t.Fatal("run saved-listings migrations:", err)
	}

	publicUserID := uuid.NewString()
	email := fmt.Sprintf("codex-saved-listings-%s@example.invalid", uuid.NewString())
	var userID int64
	if err := db.QueryRow(`
		INSERT INTO public.auth_users (
			public_user_id, email, password_hash, provider, is_active, is_verified,
			password_changed_at, last_login_at, updated_at
		) VALUES ($1, $2, 'integration-test-only', 'email', true, true, now(), now(), now())
		RETURNING id
	`, publicUserID, email).Scan(&userID); err != nil {
		t.Fatal(err)
	}
	defer func() {
		if _, err := db.Exec(`DELETE FROM public.listings WHERE user_id = $1`, userID); err != nil {
			t.Errorf("delete saved-listings fixtures: %v", err)
		}
		if _, err := db.Exec(`DELETE FROM public.auth_users WHERE id = $1 AND email = $2`, userID, email); err != nil {
			t.Errorf("delete saved-listings user: %v", err)
		}
	}()

	tokenID := uuid.NewString()
	expiresAt := time.Now().UTC().Add(10 * time.Minute)
	if _, err := db.Exec(`INSERT INTO public.auth_sessions (user_id, token_id, expires_at) VALUES ($1, $2, $3)`, userID, tokenID, expiresAt); err != nil {
		t.Fatal(err)
	}
	accessToken, err := createAccessToken(userID, publicUserID, email, tokenID, expiresAt)
	if err != nil {
		t.Fatal(err)
	}

	app := fiber.New()
	app.Post("/listings", CreateListing(db))
	app.Get("/me/saved-listings", GetMySavedListings(db))
	app.Post("/me/saved-listings/merge", MergeMySavedListings(db))
	app.Put("/me/saved-listings/:identifier", SaveMyListing(db))
	app.Delete("/me/saved-listings/:identifier", UnsaveMyListing(db))

	payload := integrationListingPayload(selectableListingCategoryCases[0], "", "", "")
	payload.MediaItems = nil
	payload.Title = "Saved listing integration " + uuid.NewString()
	payload.ContactEmail = email
	listingID := createIntegrationListing(t, app, accessToken, payload)

	var slug, publicListingID string
	if err := db.QueryRow(`SELECT slug, public_listing_id::text FROM public.listings WHERE id = $1`, listingID).Scan(&slug, &publicListingID); err != nil {
		t.Fatal(err)
	}

	savedListingTestRequest(t, app, "PUT", "/me/saved-listings/"+slug, accessToken, nil, fiber.StatusOK)
	savedListingTestRequest(t, app, "PUT", "/me/saved-listings/"+slug, accessToken, nil, fiber.StatusOK)
	assertSavedListingResponse(t, savedListingTestRequest(t, app, "GET", "/me/saved-listings", accessToken, nil, fiber.StatusOK), publicListingID, 1)

	savedListingTestRequest(t, app, "DELETE", "/me/saved-listings/"+slug, accessToken, nil, fiber.StatusOK)
	assertSavedListingResponse(t, savedListingTestRequest(t, app, "GET", "/me/saved-listings", accessToken, nil, fiber.StatusOK), "", 0)

	mergeBody := mergeSavedListingsRequest{ListingIdentifiers: []string{publicListingID, publicListingID, slug}}
	assertSavedListingResponse(t, savedListingTestRequest(t, app, "POST", "/me/saved-listings/merge", accessToken, mergeBody, fiber.StatusOK), publicListingID, 1)

	var relationCount int
	if err := db.QueryRow(`SELECT count(*) FROM public.user_saved_listings WHERE user_id = $1 AND listing_id = $2`, userID, listingID).Scan(&relationCount); err != nil {
		t.Fatal(err)
	}
	if relationCount != 1 {
		t.Fatalf("saved relationship count=%d, want 1", relationCount)
	}

	if _, err := db.Exec(`UPDATE public.listings SET moderation_status = 'rejected' WHERE id = $1`, listingID); err != nil {
		t.Fatal(err)
	}
	assertSavedListingResponse(t, savedListingTestRequest(t, app, "GET", "/me/saved-listings", accessToken, nil, fiber.StatusOK), "", 0)
	if err := db.QueryRow(`SELECT count(*) FROM public.user_saved_listings WHERE user_id = $1 AND listing_id = $2`, userID, listingID).Scan(&relationCount); err != nil {
		t.Fatal(err)
	}
	if relationCount != 1 {
		t.Fatal("hidden listing lost its saved relationship")
	}

	if _, err := db.Exec(`UPDATE public.listings SET moderation_status = 'approved' WHERE id = $1`, listingID); err != nil {
		t.Fatal(err)
	}
	assertSavedListingResponse(t, savedListingTestRequest(t, app, "GET", "/me/saved-listings", accessToken, nil, fiber.StatusOK), publicListingID, 1)
}

func savedListingTestRequest(t *testing.T, app *fiber.App, method, path, accessToken string, body any, expectedStatus int) []byte {
	t.Helper()
	var requestBody *bytes.Reader
	if body == nil {
		requestBody = bytes.NewReader(nil)
	} else {
		encoded, err := json.Marshal(body)
		if err != nil {
			t.Fatal(err)
		}
		requestBody = bytes.NewReader(encoded)
	}
	request := httptest.NewRequest(method, path, requestBody)
	request.Header.Set("Authorization", "Bearer "+accessToken)
	request.Header.Set("Content-Type", "application/json")
	response, err := app.Test(request, -1)
	if err != nil {
		t.Fatal(err)
	}
	defer response.Body.Close()
	var result json.RawMessage
	if err := json.NewDecoder(response.Body).Decode(&result); err != nil {
		t.Fatal(err)
	}
	if response.StatusCode != expectedStatus {
		t.Fatalf("%s %s status=%d body=%s", method, path, response.StatusCode, string(result))
	}
	return result
}

func assertSavedListingResponse(t *testing.T, body []byte, expectedPublicListingID string, expectedTotal int) {
	t.Helper()
	var result struct {
		Listings   []searchListing         `json:"listings"`
		References []savedListingReference `json:"references"`
		Total      int                     `json:"total"`
	}
	if err := json.Unmarshal(body, &result); err != nil {
		t.Fatal(err)
	}
	if result.Total != expectedTotal || len(result.Listings) != expectedTotal || len(result.References) != expectedTotal {
		t.Fatalf("saved response counts mismatch: %#v", result)
	}
	if expectedTotal == 1 && (result.References[0].PublicListingID != expectedPublicListingID || result.Listings[0].PublicListingID != expectedPublicListingID) {
		t.Fatalf("saved listing mismatch: %#v", result)
	}
}
