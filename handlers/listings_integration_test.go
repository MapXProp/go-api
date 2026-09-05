package handlers

import (
	"bytes"
	"context"
	"database/sql"
	"encoding/json"
	"estate-map-api/database"
	"fmt"
	"mime/multipart"
	"net/http/httptest"
	"net/url"
	"os"
	"path/filepath"
	"reflect"
	"strconv"
	"testing"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
	"github.com/joho/godotenv"
)

type listingCategoryIntegrationCase struct {
	propertyType               string
	expectedPropertyType       string
	expectedAccommodationModel string
	propertyGroup              string
	discoveryChannel           string
	listingScope               string
	useCases                   []string
	offerTypes                 []string
	usageType                  string
	listingType                string
	spaceTypes                 []string
}

var selectableListingCategoryCases = []listingCategoryIntegrationCase{
	{propertyType: "detached_house", propertyGroup: "residential", discoveryChannel: "homes", listingScope: "whole_property", useCases: []string{"residential"}, offerTypes: []string{"rent"}, usageType: "residence", listingType: "rent"},
	{propertyType: "semi_detached_house", propertyGroup: "residential", discoveryChannel: "homes", listingScope: "whole_property", useCases: []string{"residential"}, offerTypes: []string{"rent"}, usageType: "residence", listingType: "rent"},
	{propertyType: "townhouse", propertyGroup: "residential", discoveryChannel: "homes", listingScope: "whole_property", useCases: []string{"residential"}, offerTypes: []string{"rent"}, usageType: "residence", listingType: "rent"},
	{propertyType: "condo", propertyGroup: "residential", discoveryChannel: "homes", listingScope: "single_unit", useCases: []string{"residential"}, offerTypes: []string{"sale", "rent"}, usageType: "residence", listingType: "sale_and_rent"},
	{propertyType: "shophouse", propertyGroup: "mixed_use", discoveryChannel: "homes", listingScope: "whole_property", useCases: []string{"residential", "retail"}, offerTypes: []string{"rent"}, usageType: "mixed", listingType: "rent"},
	{propertyType: "home_office", propertyGroup: "mixed_use", discoveryChannel: "homes", listingScope: "whole_property", useCases: []string{"residential", "office"}, offerTypes: []string{"rent"}, usageType: "mixed", listingType: "rent"},
	{propertyType: "land", propertyGroup: "land", discoveryChannel: "homes", listingScope: "land_plot", useCases: []string{"residential"}, offerTypes: []string{"sale"}, usageType: "residence", listingType: "sale"},
	{propertyType: "rental_room", propertyGroup: "residential", discoveryChannel: "rooms", listingScope: "single_unit", useCases: []string{"residential"}, offerTypes: []string{"rent"}, usageType: "residence", listingType: "rent"},
	{propertyType: "apartment", expectedPropertyType: "apartment", expectedAccommodationModel: "standard", propertyGroup: "residential", discoveryChannel: "rooms", listingScope: "single_unit", useCases: []string{"residential"}, offerTypes: []string{"rent"}, usageType: "residence", listingType: "rent"},
	{propertyType: "dormitory", propertyGroup: "residential", discoveryChannel: "rooms", listingScope: "multi_unit", useCases: []string{"residential"}, offerTypes: []string{"rent"}, usageType: "residence", listingType: "rent"},
	{propertyType: "flat", propertyGroup: "residential", discoveryChannel: "rooms", listingScope: "single_unit", useCases: []string{"residential"}, offerTypes: []string{"rent"}, usageType: "residence", listingType: "rent"},
	{propertyType: "serviced_apartment", expectedPropertyType: "apartment", expectedAccommodationModel: "serviced", propertyGroup: "residential", discoveryChannel: "rooms", listingScope: "single_unit", useCases: []string{"residential", "hospitality"}, offerTypes: []string{"rent"}, usageType: "mixed", listingType: "rent"},
	{propertyType: "monthly_hotel", propertyGroup: "residential", discoveryChannel: "rooms", listingScope: "single_unit", useCases: []string{"hospitality"}, offerTypes: []string{"rent"}, usageType: "business", listingType: "rent"},
	{propertyType: "office", propertyGroup: "commercial", discoveryChannel: "business", listingScope: "single_unit", useCases: []string{"office"}, offerTypes: []string{"rent"}, usageType: "business", listingType: "rent"},
	{propertyType: "retail_space", propertyGroup: "commercial", discoveryChannel: "business", listingScope: "space_slot", useCases: []string{"retail", "food_service"}, offerTypes: []string{"rent"}, usageType: "business", listingType: "rent", spaceTypes: []string{"market_stall", "event_booth"}},
	{propertyType: "warehouse", propertyGroup: "commercial", discoveryChannel: "business", listingScope: "whole_property", useCases: []string{"storage"}, offerTypes: []string{"rent"}, usageType: "business", listingType: "rent"},
	{propertyType: "factory", propertyGroup: "commercial", discoveryChannel: "business", listingScope: "whole_property", useCases: []string{"industrial"}, offerTypes: []string{"rent"}, usageType: "business", listingType: "rent"},
	{propertyType: "hotel_resort", propertyGroup: "commercial", discoveryChannel: "business", listingScope: "whole_property", useCases: []string{"hospitality"}, offerTypes: []string{"sale", "business_transfer"}, usageType: "business", listingType: "sale_and_rent"},
	{propertyType: "shophouse", propertyGroup: "mixed_use", discoveryChannel: "business", listingScope: "whole_property", useCases: []string{"retail", "food_service"}, offerTypes: []string{"rent", "business_transfer"}, usageType: "mixed", listingType: "rent"},
	{propertyType: "home_office", propertyGroup: "mixed_use", discoveryChannel: "business", listingScope: "whole_property", useCases: []string{"office"}, offerTypes: []string{"rent"}, usageType: "mixed", listingType: "rent"},
	{propertyType: "land", propertyGroup: "land", discoveryChannel: "business", listingScope: "land_plot", useCases: []string{"retail", "industrial"}, offerTypes: []string{"sale"}, usageType: "business", listingType: "sale"},
	{propertyType: "condo", propertyGroup: "residential", discoveryChannel: "rooms", listingScope: "single_unit", useCases: []string{"residential"}, offerTypes: []string{"rent"}, usageType: "residence", listingType: "rent"},
}

func TestCreateListingPersistsAllSelectableCategories(t *testing.T) {
	if os.Getenv("MAPXPROP_DB_INTEGRATION") != "1" {
		t.Skip("set MAPXPROP_DB_INTEGRATION=1 to run the database integration test")
	}
	if err := godotenv.Load("../.env"); err != nil {
		t.Fatal("load integration database environment:", err)
	}
	requireSafeIntegrationDatabase(t)
	if len(selectableListingCategoryCases) != 22 {
		t.Fatalf("integration matrix must cover 18 property types and every selectable discovery-channel route, got %d", len(selectableListingCategoryCases))
	}

	db := database.ConnectDB()
	defer db.Close()
	if err := database.RunMigrations(db); err != nil {
		t.Fatal("run integration database migrations:", err)
	}
	assertRoomTaxonomySearch(t, db)
	if err := cleanupStaleListingMatrixRows(db); err != nil {
		t.Fatal(err)
	}

	publicUserID := uuid.NewString()
	email := fmt.Sprintf("codex-listing-matrix-%s@example.invalid", uuid.NewString())
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

	mediaDirectory := filepath.Join(listingMediaRoot(), strconv.FormatInt(userID, 10))
	cleanupComplete := false
	cleanup := func() error {
		if _, err := db.Exec(`DELETE FROM public.listings WHERE user_id = $1`, userID); err != nil {
			return fmt.Errorf("delete integration listings: %w", err)
		}
		if _, err := db.Exec(`DELETE FROM public.auth_users WHERE id = $1 AND email = $2`, userID, email); err != nil {
			return fmt.Errorf("delete integration user: %w", err)
		}
		if err := os.RemoveAll(mediaDirectory); err != nil {
			return fmt.Errorf("delete integration media: %w", err)
		}

		var users, listings int
		if err := db.QueryRow(`SELECT count(*) FROM public.auth_users WHERE id = $1 OR email = $2`, userID, email).Scan(&users); err != nil {
			return fmt.Errorf("verify integration user cleanup: %w", err)
		}
		if err := db.QueryRow(`SELECT count(*) FROM public.listings WHERE user_id = $1`, userID).Scan(&listings); err != nil {
			return fmt.Errorf("verify integration listing cleanup: %w", err)
		}
		if users != 0 || listings != 0 {
			return fmt.Errorf("integration rows remain after cleanup: users=%d listings=%d", users, listings)
		}
		if _, err := os.Stat(mediaDirectory); !os.IsNotExist(err) {
			return fmt.Errorf("integration media directory remains after cleanup: %s", mediaDirectory)
		}
		return nil
	}
	defer func() {
		if !cleanupComplete {
			if err := cleanup(); err != nil {
				t.Errorf("cleanup integration data: %v", err)
			}
		}
	}()

	tokenID := uuid.NewString()
	expiresAt := time.Now().UTC().Add(10 * time.Minute)
	if _, err := db.Exec(`
		INSERT INTO public.auth_sessions (user_id, token_id, expires_at)
		VALUES ($1, $2, $3)
	`, userID, tokenID, expiresAt); err != nil {
		t.Fatal(err)
	}
	accessToken, err := createAccessToken(userID, publicUserID, email, tokenID, expiresAt)
	if err != nil {
		t.Fatal(err)
	}

	app := fiber.New()
	app.Post("/listing-media", UploadListingMedia(db))
	app.Post("/listings", CreateListing(db))
	app.Get("/listings/:slug", GetListingBySlug(db))
	app.Get("/me/listings", GetMyListings(db))
	app.Get("/me/listings/:publicListingID/edit", GetMyListingEditDraft(db))
	app.Delete("/me/listings/:publicListingID", DeleteMyListing(db))
	app.Get("/search/suggestions", PropertySearchSuggestions(db))
	app.Get("/properties/search", SearchProperties(db))
	assertIntegrationCondoSuggestion(t, app)

	var (
		softDeleteListingID      int64
		softDeleteListingPayload createListingRequest
	)
	for index, category := range selectableListingCategoryCases {
		category := category
		t.Run(fmt.Sprintf("%02d_%s", index+1, category.propertyType), func(t *testing.T) {
			imageURL := uploadIntegrationMedia(
				t,
				app,
				accessToken,
				"image",
				category.propertyType+"-cover.png",
				[]byte{0x89, 'P', 'N', 'G', '\r', '\n', 0x1a, '\n', 0, 0, 0, 0, 'I', 'H', 'D', 'R'},
			)
			videoURL := uploadIntegrationMedia(
				t,
				app,
				accessToken,
				"video",
				category.propertyType+"-tour.mp4",
				[]byte{0, 0, 0, 24, 'f', 't', 'y', 'p', 'i', 's', 'o', 'm', 0, 0, 0, 0, 'i', 's', 'o', 'm', 'm', 'p', '4', '1'},
			)
			panoramaURL := uploadIntegrationMedia(
				t,
				app,
				accessToken,
				"360",
				category.propertyType+"-panorama.png",
				[]byte{0x89, 'P', 'N', 'G', '\r', '\n', 0x1a, '\n', 0, 0, 0, 0, 'I', 'H', 'D', 'R'},
			)

			payload := integrationListingPayload(category, imageURL, videoURL, panoramaURL)
			listingID := int64(0)
			if index == 0 {
				missingKeyPayload := payload
				missingKeyPayload.SubmissionKey = ""
				assertIntegrationListingRejected(
					t,
					app,
					accessToken,
					missingKeyPayload,
					"submission key is required",
				)
				listingID = createIntegrationListingConcurrently(t, app, db, accessToken, payload, 8)
			} else {
				listingID = createIntegrationListing(t, app, accessToken, payload)
			}
			if index == 0 {
				payload.Title += " (updated safely)"
				retriedListingID := createIntegrationListing(t, app, accessToken, payload)
				if retriedListingID != listingID {
					t.Fatalf("idempotent submission created duplicate listings: first=%d retry=%d", listingID, retriedListingID)
				}

				var publicListingID string
				if err := db.QueryRow(`
					SELECT public_listing_id::text
					FROM public.listings
					WHERE id = $1
				`, listingID).Scan(&publicListingID); err != nil {
					t.Fatal(err)
				}
				payload.EditingPublicListingID = publicListingID
				payload.SubmissionKey = uuid.NewString()
				payload.Title += " (edited by listing ID)"
				replacementImageURL := uploadIntegrationMedia(
					t,
					app,
					accessToken,
					"image",
					"replacement-cover.png",
					[]byte{0x89, 'P', 'N', 'G', '\r', '\n', 0x1a, '\n', 1, 1, 1, 1, 'I', 'H', 'D', 'R'},
				)
				replacementVideoURL := uploadIntegrationMedia(
					t,
					app,
					accessToken,
					"video",
					"replacement-tour.mp4",
					[]byte{0, 0, 0, 24, 'f', 't', 'y', 'p', 'i', 's', 'o', 'm', 1, 1, 1, 1, 'i', 's', 'o', 'm', 'm', 'p', '4', '1'},
				)
				replacementPanoramaURL := uploadIntegrationMedia(
					t,
					app,
					accessToken,
					"360",
					"replacement-panorama.png",
					[]byte{0x89, 'P', 'N', 'G', '\r', '\n', 0x1a, '\n', 2, 2, 2, 2, 'I', 'H', 'D', 'R'},
				)
				replacementMedia := []listingMediaInput{
					{URL: replacementImageURL, MediaType: "image"},
					{URL: replacementVideoURL, MediaType: "video"},
					{URL: replacementPanoramaURL, MediaType: "360"},
				}
				payload.ReplaceMedia = true
				payload.MediaItems = replacementMedia
				payload.MediaURLs = []string{replacementImageURL}
				editedListingID := createIntegrationListing(t, app, accessToken, payload)
				if editedListingID != listingID {
					t.Fatalf("explicit edit created duplicate listings: first=%d edit=%d", listingID, editedListingID)
				}
				assertIntegrationListingMediaURLs(t, db, listingID, replacementMedia)

				payload.ReplaceMedia = false
				payload.MediaItems = nil
				payload.MediaURLs = nil
				payload.Title += " (media protected)"
				protectedListingID := createIntegrationListing(t, app, accessToken, payload)
				if protectedListingID != listingID {
					t.Fatalf("protected edit created duplicate listings: first=%d edit=%d", listingID, protectedListingID)
				}
				var protectedMediaCount int
				if err := db.QueryRow(`
					SELECT count(*) FROM public.listing_media WHERE listing_id = $1
				`, listingID).Scan(&protectedMediaCount); err != nil {
					t.Fatal(err)
				}
				if protectedMediaCount != 3 {
					t.Fatalf("edit without loaded media removed existing files: got=%d want=3", protectedMediaCount)
				}
				assertIntegrationListingMediaURLs(t, db, listingID, replacementMedia)

				payload.ReplaceMedia = true
				payload.Title += " (media cleared intentionally)"
				clearedListingID := createIntegrationListing(t, app, accessToken, payload)
				if clearedListingID != listingID {
					t.Fatalf("media removal created duplicate listings: first=%d edit=%d", listingID, clearedListingID)
				}
				assertIntegrationListingMediaURLs(t, db, listingID, nil)

				payload.Title += " (media restored)"
				payload.MediaItems = replacementMedia
				payload.MediaURLs = []string{replacementImageURL}
				restoredListingID := createIntegrationListing(t, app, accessToken, payload)
				if restoredListingID != listingID {
					t.Fatalf("media restore created duplicate listings: first=%d edit=%d", listingID, restoredListingID)
				}
				assertIntegrationListingMediaURLs(t, db, listingID, replacementMedia)
				assertIntegrationOwnerListingPrimaryImage(t, app, accessToken, publicListingID, replacementImageURL)
			}
			assertIntegrationListingPersisted(t, db, listingID, userID, category, payload)
			assertIntegrationListingImmediatelyPublished(t, db, listingID)
			assertIntegrationListingDetailReadable(t, app, db, listingID, userID, category, payload)
			assertIntegrationListingEditDraftReadable(t, app, db, accessToken, listingID, payload)
			if inSet("event_booth", category.spaceTypes...) {
				var publicListingID string
				if err := db.QueryRow(`SELECT public_listing_id::text FROM public.listings WHERE id = $1`, listingID).Scan(&publicListingID); err != nil {
					t.Fatal(err)
				}
				fixedPricePayload := payload
				fixedPricePayload.EditingPublicListingID = publicListingID
				fixedPricePayload.SubmissionKey = uuid.NewString()
				fixedPricePayload.PriceOnRequest = false
				fixedPricePayload.PriceNegotiable = false
				fixedPricePayload.RentPriceMonthly = ""
				fixedPricePayload.ServiceFeeMonthly = "750"
				fixedPricePayload.MinimumLeaseMonths = "3"
				fixedPricePayload.DepositAmount = "10000"
				fixedPricePayload.AdvanceRentAmount = "5000"
				fixedPricePayload.PriceUnit = "event_period"
				fixedPricePayload.RetailRentPrice = "5000"
				fixedPricePayload.TemporarySpacePrice = ""
				fixedPricePayload.TemporarySpaceDays = ""
				fixedPriceListingID := createIntegrationListing(t, app, accessToken, fixedPricePayload)
				if fixedPriceListingID != listingID {
					t.Fatalf("temporary-space pricing edit created a duplicate listing: first=%d edit=%d", listingID, fixedPriceListingID)
				}
				assertIntegrationListingPersisted(t, db, listingID, userID, category, fixedPricePayload)
				assertIntegrationListingImmediatelyPublished(t, db, listingID)
				assertIntegrationListingDetailReadable(t, app, db, listingID, userID, category, fixedPricePayload)
				assertIntegrationListingEditDraftReadable(t, app, db, accessToken, listingID, fixedPricePayload)
			}
			if index == 0 {
				softDeleteListingID = listingID
				softDeleteListingPayload = payload
			}
		})
	}
	assertIntegrationContactRoleCoverage(t, db, userID)
	assertIntegrationOwnerListingsReadable(t, app, accessToken)
	assertIntegrationListingSoftDelete(t, app, db, accessToken, userID, softDeleteListingID, softDeleteListingPayload)

	if err := cleanup(); err != nil {
		t.Fatal(err)
	}
	cleanupComplete = true
}

func assertIntegrationListingSoftDelete(
	t *testing.T,
	app *fiber.App,
	db *sql.DB,
	accessToken string,
	userID int64,
	listingID int64,
	payload createListingRequest,
) {
	t.Helper()
	if listingID == 0 {
		t.Fatal("soft-delete integration listing was not captured")
	}

	var publicListingID, slug, storedTitle, storedSubmissionKey, listingStatus, moderationStatus string
	var isActive bool
	var publishedAt sql.NullTime
	if err := db.QueryRow(`
		SELECT public_listing_id::text, slug, title, COALESCE(submission_key, ''),
		       listing_status, moderation_status, is_active, published_at
		FROM public.listings
		WHERE id = $1 AND user_id = $2 AND deleted_at IS NULL
	`, listingID, userID).Scan(
		&publicListingID,
		&slug,
		&storedTitle,
		&storedSubmissionKey,
		&listingStatus,
		&moderationStatus,
		&isActive,
		&publishedAt,
	); err != nil {
		t.Fatal("load listing before soft delete:", err)
	}
	retainedBefore := integrationListingRelationCounts(t, db, listingID)
	assertIntegrationSearchContainsListing(t, app, publicListingID, true)
	if _, err := db.Exec(`
		INSERT INTO public.listing_drafts (user_id, data, current_step, expires_at)
		VALUES ($1, jsonb_build_object('editingPublicListingId', $2::text), 3, now() + interval '48 hours')
		ON CONFLICT (user_id) DO UPDATE SET
			data = EXCLUDED.data,
			current_step = EXCLUDED.current_step,
			updated_at = now(),
			expires_at = EXCLUDED.expires_at
	`, userID, publicListingID); err != nil {
		t.Fatal("create stale edit draft before soft delete:", err)
	}

	unauthorizedRequest := httptest.NewRequest("DELETE", "/me/listings/"+url.PathEscape(publicListingID), nil)
	unauthorizedResponse, err := app.Test(unauthorizedRequest, -1)
	if err != nil {
		t.Fatal(err)
	}
	unauthorizedResponse.Body.Close()
	if unauthorizedResponse.StatusCode != fiber.StatusUnauthorized {
		t.Fatalf("unauthorized soft delete status=%d want=%d", unauthorizedResponse.StatusCode, fiber.StatusUnauthorized)
	}

	deleteResult := deleteIntegrationListing(t, app, accessToken, publicListingID)
	if !deleteResult.Success || deleteResult.AlreadyDeleted {
		t.Fatalf("first soft delete response mismatch: %#v", deleteResult)
	}

	var (
		deletedAt              sql.NullTime
		storedListingStatus    string
		storedModerationStatus string
		storedIsActive         bool
		storedPublishedAt      sql.NullTime
	)
	if err := db.QueryRow(`
		SELECT deleted_at, listing_status, moderation_status, is_active, published_at
		FROM public.listings
		WHERE id = $1 AND user_id = $2
	`, listingID, userID).Scan(
		&deletedAt,
		&storedListingStatus,
		&storedModerationStatus,
		&storedIsActive,
		&storedPublishedAt,
	); err != nil {
		t.Fatal("load listing after soft delete:", err)
	}
	if !deletedAt.Valid {
		t.Fatal("soft delete did not set listings.deleted_at")
	}
	if storedListingStatus != listingStatus || storedModerationStatus != moderationStatus || storedIsActive != isActive || storedPublishedAt.Valid != publishedAt.Valid {
		t.Fatalf(
			"soft delete changed restorable listing state: status=%q/%q moderation=%q/%q active=%v/%v published=%v/%v",
			storedListingStatus,
			listingStatus,
			storedModerationStatus,
			moderationStatus,
			storedIsActive,
			isActive,
			storedPublishedAt.Valid,
			publishedAt.Valid,
		)
	}
	retainedAfter := integrationListingRelationCounts(t, db, listingID)
	if !reflect.DeepEqual(retainedAfter, retainedBefore) {
		t.Fatalf("soft delete removed related listing data: before=%v after=%v", retainedBefore, retainedAfter)
	}
	var matchingDrafts int
	if err := db.QueryRow(`
		SELECT count(*) FROM public.listing_drafts
		WHERE user_id = $1 AND data->>'editingPublicListingId' = $2
	`, userID, publicListingID).Scan(&matchingDrafts); err != nil {
		t.Fatal("count stale edit drafts after soft delete:", err)
	}
	if matchingDrafts != 0 {
		t.Fatalf("soft delete left %d stale edit drafts", matchingDrafts)
	}

	assertIntegrationOwnerListingsExclude(t, app, accessToken, publicListingID, len(selectableListingCategoryCases)-1)
	assertIntegrationSearchContainsListing(t, app, publicListingID, false)

	detailRequest := httptest.NewRequest("GET", "/listings/"+url.PathEscape(slug), nil)
	detailResponse, err := app.Test(detailRequest, -1)
	if err != nil {
		t.Fatal(err)
	}
	detailResponse.Body.Close()
	if detailResponse.StatusCode != fiber.StatusNotFound {
		t.Fatalf("soft-deleted public listing detail status=%d want=%d", detailResponse.StatusCode, fiber.StatusNotFound)
	}

	editRequest := httptest.NewRequest("GET", "/me/listings/"+url.PathEscape(publicListingID)+"/edit", nil)
	editRequest.Header.Set("Authorization", "Bearer "+accessToken)
	editResponse, err := app.Test(editRequest, -1)
	if err != nil {
		t.Fatal(err)
	}
	editResponse.Body.Close()
	if editResponse.StatusCode != fiber.StatusNotFound {
		t.Fatalf("soft-deleted listing edit status=%d want=%d", editResponse.StatusCode, fiber.StatusNotFound)
	}

	payload.EditingPublicListingID = publicListingID
	payload.SubmissionKey = uuid.NewString()
	payload.Title = storedTitle + " (must stay deleted)"
	payloadBody, err := json.Marshal(payload)
	if err != nil {
		t.Fatal(err)
	}
	updateRequest := httptest.NewRequest("POST", "/listings", bytes.NewReader(payloadBody))
	updateRequest.Header.Set("Content-Type", "application/json")
	updateRequest.Header.Set("Authorization", "Bearer "+accessToken)
	updateResponse, err := app.Test(updateRequest, -1)
	if err != nil {
		t.Fatal(err)
	}
	updateResponse.Body.Close()
	if updateResponse.StatusCode != fiber.StatusNotFound {
		t.Fatalf("soft-deleted listing update status=%d want=%d", updateResponse.StatusCode, fiber.StatusNotFound)
	}
	var titleAfterRejectedUpdate string
	if err := db.QueryRow(`SELECT title FROM public.listings WHERE id = $1 AND deleted_at IS NOT NULL`, listingID).Scan(&titleAfterRejectedUpdate); err != nil {
		t.Fatal("verify rejected soft-deleted listing update:", err)
	}
	if titleAfterRejectedUpdate != storedTitle {
		t.Fatalf("soft-deleted listing was modified: got=%q want=%q", titleAfterRejectedUpdate, storedTitle)
	}

	delayedPayload := payload
	delayedPayload.EditingPublicListingID = ""
	delayedPayload.SubmissionKey = storedSubmissionKey
	delayedPayload.Title = storedTitle + " (delayed retry must not modify)"
	delayedBody, err := json.Marshal(delayedPayload)
	if err != nil {
		t.Fatal(err)
	}
	delayedRequest := httptest.NewRequest("POST", "/listings", bytes.NewReader(delayedBody))
	delayedRequest.Header.Set("Content-Type", "application/json")
	delayedRequest.Header.Set("Authorization", "Bearer "+accessToken)
	delayedResponse, err := app.Test(delayedRequest, -1)
	if err != nil {
		t.Fatal(err)
	}
	delayedResponse.Body.Close()
	if delayedResponse.StatusCode != fiber.StatusConflict {
		t.Fatalf("delayed retry after soft delete status=%d want=%d", delayedResponse.StatusCode, fiber.StatusConflict)
	}
	if err := db.QueryRow(`SELECT title FROM public.listings WHERE id = $1 AND deleted_at IS NOT NULL`, listingID).Scan(&titleAfterRejectedUpdate); err != nil {
		t.Fatal("verify rejected delayed retry:", err)
	}
	if titleAfterRejectedUpdate != storedTitle {
		t.Fatalf("delayed retry modified soft-deleted listing: got=%q want=%q", titleAfterRejectedUpdate, storedTitle)
	}

	unrelatedDraftListingID := uuid.NewString()
	if _, err := db.Exec(`
		INSERT INTO public.listing_drafts (user_id, data, current_step, expires_at)
		VALUES ($1, jsonb_build_object('editingPublicListingId', $2::text), 2, now() + interval '48 hours')
		ON CONFLICT (user_id) DO UPDATE SET
			data = EXCLUDED.data,
			current_step = EXCLUDED.current_step,
			updated_at = now(),
			expires_at = EXCLUDED.expires_at
	`, userID, unrelatedDraftListingID); err != nil {
		t.Fatal("create unrelated listing draft:", err)
	}
	repeatedResult := deleteIntegrationListing(t, app, accessToken, publicListingID)
	if !repeatedResult.Success || !repeatedResult.AlreadyDeleted {
		t.Fatalf("repeated soft delete was not idempotent: %#v", repeatedResult)
	}
	var unrelatedDrafts int
	if err := db.QueryRow(`
		SELECT count(*) FROM public.listing_drafts
		WHERE user_id = $1 AND data->>'editingPublicListingId' = $2
	`, userID, unrelatedDraftListingID).Scan(&unrelatedDrafts); err != nil {
		t.Fatal("count unrelated listing drafts:", err)
	}
	if unrelatedDrafts != 1 {
		t.Fatalf("soft delete removed an unrelated draft: got=%d want=1", unrelatedDrafts)
	}

	missingResultRequest := httptest.NewRequest("DELETE", "/me/listings/"+uuid.NewString(), nil)
	missingResultRequest.Header.Set("Authorization", "Bearer "+accessToken)
	missingResultResponse, err := app.Test(missingResultRequest, -1)
	if err != nil {
		t.Fatal(err)
	}
	missingResultResponse.Body.Close()
	if missingResultResponse.StatusCode != fiber.StatusNotFound {
		t.Fatalf("non-owned listing soft delete status=%d want=%d", missingResultResponse.StatusCode, fiber.StatusNotFound)
	}

}

type integrationDeleteListingResponse struct {
	Success         bool   `json:"success"`
	AlreadyDeleted  bool   `json:"already_deleted"`
	PublicListingID string `json:"public_listing_id"`
}

func deleteIntegrationListing(t *testing.T, app *fiber.App, accessToken, publicListingID string) integrationDeleteListingResponse {
	t.Helper()
	request := httptest.NewRequest("DELETE", "/me/listings/"+url.PathEscape(publicListingID), nil)
	request.Header.Set("Authorization", "Bearer "+accessToken)
	response, err := app.Test(request, -1)
	if err != nil {
		t.Fatal(err)
	}
	defer response.Body.Close()
	if response.StatusCode != fiber.StatusOK {
		var errorBody map[string]any
		_ = json.NewDecoder(response.Body).Decode(&errorBody)
		t.Fatalf("soft delete listing status=%d body=%v", response.StatusCode, errorBody)
	}
	var result integrationDeleteListingResponse
	if err := json.NewDecoder(response.Body).Decode(&result); err != nil {
		t.Fatal(err)
	}
	if result.PublicListingID != publicListingID {
		t.Fatalf("soft delete listing ID mismatch: got=%q want=%q", result.PublicListingID, publicListingID)
	}
	return result
}

func integrationListingRelationCounts(t *testing.T, db *sql.DB, listingID int64) []int {
	t.Helper()
	counts := make([]int, 9)
	if err := db.QueryRow(`
		SELECT
			(SELECT count(*) FROM public.listing_media WHERE listing_id = $1),
			(SELECT count(*) FROM public.listing_category_details WHERE listing_id = $1),
			(SELECT count(*) FROM public.listing_offers WHERE listing_id = $1),
			(SELECT count(*) FROM public.listing_contact_profiles WHERE listing_id = $1),
			(SELECT count(*) FROM public.listing_space_types WHERE listing_id = $1),
			(SELECT count(*) FROM public.listing_amenities WHERE listing_id = $1),
			(SELECT count(*) FROM public.listing_use_cases WHERE listing_id = $1),
			(SELECT count(*) FROM public.listing_discovery_channels WHERE listing_id = $1),
			(SELECT count(*) FROM public.listing_business_details WHERE listing_id = $1)
	`, listingID).Scan(
		&counts[0],
		&counts[1],
		&counts[2],
		&counts[3],
		&counts[4],
		&counts[5],
		&counts[6],
		&counts[7],
		&counts[8],
	); err != nil {
		t.Fatal("count listing relations:", err)
	}
	return counts
}

func assertIntegrationOwnerListingsExclude(
	t *testing.T,
	app *fiber.App,
	accessToken string,
	publicListingID string,
	expectedCount int,
) {
	t.Helper()
	request := httptest.NewRequest("GET", "/me/listings", nil)
	request.Header.Set("Authorization", "Bearer "+accessToken)
	response, err := app.Test(request, -1)
	if err != nil {
		t.Fatal(err)
	}
	defer response.Body.Close()
	if response.StatusCode != fiber.StatusOK {
		t.Fatalf("owner listings after soft delete status=%d", response.StatusCode)
	}
	var result struct {
		Listings []myListingResponse `json:"listings"`
	}
	if err := json.NewDecoder(response.Body).Decode(&result); err != nil {
		t.Fatal(err)
	}
	if len(result.Listings) != expectedCount {
		t.Fatalf("owner listing count after soft delete: got=%d want=%d", len(result.Listings), expectedCount)
	}
	for _, listing := range result.Listings {
		if listing.PublicListingID == publicListingID {
			t.Fatalf("soft-deleted listing %s remained in owner listings", publicListingID)
		}
	}
}

func assertIntegrationSearchContainsListing(t *testing.T, app *fiber.App, publicListingID string, expected bool) {
	t.Helper()
	found := false
	for offset := 0; ; offset += 60 {
		request := httptest.NewRequest("GET", fmt.Sprintf("/properties/search?limit=60&offset=%d", offset), nil)
		response, err := app.Test(request, -1)
		if err != nil {
			t.Fatal(err)
		}
		if response.StatusCode != fiber.StatusOK {
			var errorBody map[string]any
			_ = json.NewDecoder(response.Body).Decode(&errorBody)
			response.Body.Close()
			t.Fatalf("search listings status=%d body=%v", response.StatusCode, errorBody)
		}
		var result struct {
			Listings []searchListing `json:"listings"`
			Total    int             `json:"total"`
		}
		if err := json.NewDecoder(response.Body).Decode(&result); err != nil {
			response.Body.Close()
			t.Fatal(err)
		}
		response.Body.Close()
		for _, listing := range result.Listings {
			if listing.PublicListingID == publicListingID {
				found = true
				break
			}
		}
		if found || offset+len(result.Listings) >= result.Total || len(result.Listings) == 0 {
			break
		}
	}
	if found != expected {
		t.Fatalf("search visibility for listing %s: got=%v want=%v", publicListingID, found, expected)
	}
}

func assertIntegrationListingEditDraftReadable(
	t *testing.T,
	app *fiber.App,
	db *sql.DB,
	accessToken string,
	listingID int64,
	payload createListingRequest,
) {
	t.Helper()

	var publicListingID string
	if err := db.QueryRow(`
		SELECT public_listing_id::text
		FROM public.listings
		WHERE id = $1
	`, listingID).Scan(&publicListingID); err != nil {
		t.Fatal(err)
	}

	request := httptest.NewRequest("GET", "/me/listings/"+url.PathEscape(publicListingID)+"/edit", nil)
	request.Header.Set("Authorization", "Bearer "+accessToken)
	response, err := app.Test(request, -1)
	if err != nil {
		t.Fatal(err)
	}
	defer response.Body.Close()
	if response.StatusCode != 200 {
		var errorBody map[string]any
		_ = json.NewDecoder(response.Body).Decode(&errorBody)
		t.Fatalf("load listing edit draft status=%d body=%v", response.StatusCode, errorBody)
	}

	var result struct {
		Draft map[string]any `json:"draft"`
	}
	if err := json.NewDecoder(response.Body).Decode(&result); err != nil {
		t.Fatal(err)
	}
	assertDraftText := func(key, expected string) {
		t.Helper()
		if expected == "" {
			return
		}
		actual, _ := result.Draft[key].(string)
		if actual != expected {
			t.Fatalf("edit draft %s mismatch: got=%q want=%q", key, actual, expected)
		}
	}
	assertDraftCount := func(key string, expected int) {
		t.Helper()
		values, _ := result.Draft[key].([]any)
		if len(values) != expected {
			t.Fatalf("edit draft %s count mismatch: got=%d want=%d value=%#v", key, len(values), expected, result.Draft[key])
		}
	}

	assertDraftText("editingPublicListingId", publicListingID)
	assertDraftText("listingMediaLoaded", "yes")
	expectedPropertyType := payload.PropertyTypeCode
	if payload.PropertyTypeCode == "serviced_apartment" {
		expectedPropertyType = "apartment"
	}
	assertDraftText("property_type_code", expectedPropertyType)
	assertDraftText("listingTitle", payload.Title)
	assertDraftText("listingDescription", payload.Description)
	assertDraftText("contactName", payload.ContactName)
	assertDraftText("contactPhone", payload.ContactPhone)
	assertDraftText("contactRoleCode", payload.ContactRoleCode)
	assertDraftText("contactAuthorityCode", payload.ContactAuthorityCode)
	assertDraftText("integrationCategory", payload.PropertyTypeCode)
	if payload.PropertyTypeCode == "retail_space" && !payload.PriceOnRequest && (inSet("rent", payload.OfferTypes...) || inSet("sublease", payload.OfferTypes...)) {
		expectedRetailPrice := payload.RetailRentPrice
		if expectedRetailPrice == "" {
			expectedRetailPrice = payload.RentPriceMonthly
			if inSet("event_booth", payload.SpaceTypeCodes...) {
				expectedRetailPrice = payload.TemporarySpacePrice
			}
		}
		assertDraftText("retailRentPrice", expectedRetailPrice)
		assertDraftText("retailPriceUnit", payload.PriceUnit)
		assertDraftText("depositAmount", payload.DepositAmount)
		assertDraftText("advanceRentAmount", payload.AdvanceRentAmount)
		assertDraftText("minimumLeaseMonths", payload.MinimumLeaseMonths)
		assertDraftText("serviceFeeMonthly", payload.ServiceFeeMonthly)
	}
	if inSet("event_booth", payload.SpaceTypeCodes...) {
		assertDraftText("eventName", payload.EventName)
		assertDraftText("eventVenueName", payload.EventVenueName)
		assertDraftText("eventVenueFloor", payload.EventVenueFloorLabel)
		assertDraftText("eventFloorPlanUrl", payload.EventFloorPlanURL)
		assertDraftCount("eventRoundStarts[]", len(payload.EventRounds))
		assertDraftCount("eventRoundEnds[]", len(payload.EventRounds))
	}
	assertDraftCount("listingPhotoUrls[]", 1)
	assertDraftCount("listingVideoUrls[]", 1)
	assertDraftCount("listingPanoramaUrls[]", 1)
	assertIntegrationEditDraftMediaURLs(t, result.Draft, payload.MediaItems)
}

func assertIntegrationEditDraftMediaURLs(t *testing.T, draft map[string]any, expected []listingMediaInput) {
	t.Helper()

	actual := map[string][]string{"image": {}, "video": {}, "360": {}}
	for mediaType, key := range map[string]string{
		"image": "listingPhotoUrls[]",
		"video": "listingVideoUrls[]",
		"360":   "listingPanoramaUrls[]",
	} {
		values, _ := draft[key].([]any)
		for _, value := range values {
			if mediaURL, ok := value.(string); ok {
				actual[mediaType] = append(actual[mediaType], mediaURL)
			}
		}
	}
	expectedByType := map[string][]string{"image": {}, "video": {}, "360": {}}
	for _, media := range expected {
		expectedByType[media.MediaType] = append(expectedByType[media.MediaType], media.URL)
	}
	if !reflect.DeepEqual(actual, expectedByType) {
		t.Fatalf("edit draft media URLs mismatch: got=%#v want=%#v", actual, expectedByType)
	}
}

func assertRoomTaxonomySearch(t *testing.T, db *sql.DB) {
	t.Helper()
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	var condoNameTH string
	if err := db.QueryRowContext(ctx, `SELECT name_th FROM public.property_types WHERE code = 'condo'`).Scan(&condoNameTH); err != nil {
		t.Fatal("load concise condo label:", err)
	}
	if condoNameTH != "คอนโด" {
		t.Fatalf("condo Thai label mismatch: got=%q want=%q", condoNameTH, "คอนโด")
	}
	condominiumIntent, err := parseIntentFromDB(ctx, db, "คอนโดมิเนียม")
	if err != nil {
		t.Fatal("parse legacy condominium search alias:", err)
	}
	if !inSet("condo", condominiumIntent.PropertyTypes...) {
		t.Fatalf("legacy condominium alias no longer finds condo: types=%v", condominiumIntent.PropertyTypes)
	}

	servicedIntent, err := parseIntentFromDB(ctx, db, "เซอร์วิสอพาร์ตเมนต์")
	if err != nil {
		t.Fatal("parse serviced apartment search:", err)
	}
	if !inSet("apartment", servicedIntent.PropertyTypes...) || !inSet("serviced", servicedIntent.Features...) {
		t.Fatalf("serviced apartment search mismatch: types=%v features=%v", servicedIntent.PropertyTypes, servicedIntent.Features)
	}

	flatIntent, err := parseIntentFromDB(ctx, db, "แฟลต")
	if err != nil {
		t.Fatal("parse flat search:", err)
	}
	if !inSet("flat", flatIntent.PropertyTypes...) || inSet("apartment", flatIntent.PropertyTypes...) {
		t.Fatalf("flat search compatibility mismatch: types=%v", flatIntent.PropertyTypes)
	}

	courtIntent, err := parseIntentFromDB(ctx, db, "Ari Court")
	if err != nil {
		t.Fatal("parse Court apartment search:", err)
	}
	if !inSet("apartment", courtIntent.PropertyTypes...) {
		t.Fatalf("Court apartment search mismatch: types=%v", courtIntent.PropertyTypes)
	}
}

func assertIntegrationCondoSuggestion(t *testing.T, app *fiber.App) {
	t.Helper()
	request := httptest.NewRequest("GET", "/search/suggestions?q="+url.QueryEscape("คอนโดมิเนียม"), nil)
	response, err := app.Test(request, -1)
	if err != nil {
		t.Fatal(err)
	}
	defer response.Body.Close()
	if response.StatusCode != 200 {
		t.Fatalf("condo suggestion status=%d", response.StatusCode)
	}
	var body struct {
		Suggestions []struct {
			Type  string `json:"type"`
			Label string `json:"label"`
		} `json:"suggestions"`
	}
	if err := json.NewDecoder(response.Body).Decode(&body); err != nil {
		t.Fatal(err)
	}
	for _, suggestion := range body.Suggestions {
		if suggestion.Type == "property_type" && suggestion.Label == "คอนโด" {
			return
		}
	}
	t.Fatalf("concise condo suggestion was not returned: %#v", body.Suggestions)
}

func cleanupStaleListingMatrixRows(db *sql.DB) error {
	const predicate = `
		title LIKE 'DB matrix check: %'
		AND contact_email = 'listing-test@example.invalid'
		AND description LIKE 'Complete integration submission for %'
	`
	var count int
	if err := db.QueryRow(`SELECT count(*) FROM public.listings WHERE ` + predicate).Scan(&count); err != nil {
		return fmt.Errorf("count stale integration listings: %w", err)
	}
	if count > len(selectableListingCategoryCases) {
		return fmt.Errorf("refusing broad stale integration cleanup: found %d rows", count)
	}
	if count == 0 {
		return nil
	}
	result, err := db.Exec(`DELETE FROM public.listings WHERE ` + predicate)
	if err != nil {
		return fmt.Errorf("delete stale integration listings: %w", err)
	}
	deleted, err := result.RowsAffected()
	if err != nil {
		return fmt.Errorf("count deleted stale integration listings: %w", err)
	}
	if deleted != int64(count) {
		return fmt.Errorf("stale integration cleanup mismatch: found=%d deleted=%d", count, deleted)
	}
	return nil
}

func integrationListingPayload(
	category listingCategoryIntegrationCase,
	imageURL string,
	videoURL string,
	panoramaURL string,
) createListingRequest {
	spaceTypeCode := ""
	allowedBusinessTypes := []string(nil)
	if len(category.spaceTypes) > 0 {
		spaceTypeCode = category.spaceTypes[0]
		allowedBusinessTypes = []string{"retail", "food_service"}
	}
	if category.discoveryChannel == "business" && category.propertyType == "shophouse" {
		allowedBusinessTypes = []string{"retail", "food_service"}
	}
	categoryDetails := integrationCategoryDetails(category)
	currency := "THB"
	if category.discoveryChannel == "business" && category.propertyType == "retail_space" {
		currency = "USD"
	}
	contactRole, contactAuthority, contactOrganization, contactOrganizationNo := integrationContactProfile(category)
	payload := createListingRequest{
		SubmissionKey:           uuid.NewString(),
		ReplaceMedia:            true,
		DiscoveryChannelCode:    category.discoveryChannel,
		PropertyGroupCode:       category.propertyGroup,
		PropertyTypeCode:        category.propertyType,
		AccommodationModel:      category.expectedAccommodationModel,
		ListingScope:            category.listingScope,
		UseCaseCodes:            category.useCases,
		OfferTypes:              category.offerTypes,
		UsageType:               category.usageType,
		ListingType:             category.listingType,
		Title:                   "DB matrix check: " + category.propertyType,
		Description:             "Complete integration submission for " + category.propertyType,
		CustomProjectName:       "MapXProp Integration Project",
		CustomUnitNumber:        "TEST-17",
		PriceNegotiable:         true,
		UsableAreaSqm:           "85.5",
		LandAreaSqm:             "160",
		BedroomCount:            "2",
		BathroomCount:           "2",
		ParkingCount:            "1",
		MaxOccupants:            "4",
		FloorNo:                 "5",
		TotalFloors:             "20",
		FurnishingStatus:        "fully_furnished",
		PropertyCondition:       "good",
		OccupancyStatus:         "vacant",
		MinimumLeaseMonths:      "12",
		PetAllowed:              true,
		PetPolicyCode:           "allowed",
		UtilitiesIncluded:       category.discoveryChannel == "rooms",
		ContactName:             "MapXProp DB Test",
		ContactPhone:            "0800000000",
		ContactPhoneSecondary:   "0811111111",
		ContactEmail:            "listing-test@example.invalid",
		LineID:                  "mapxprop-test",
		InstagramHandle:         "@mapxprop.test",
		ContactRoleCode:         contactRole,
		ContactAuthorityCode:    contactAuthority,
		ContactOrganizationName: contactOrganization,
		ContactOrganizationNo:   contactOrganizationNo,
		AddressLine1:            "99 Test Road",
		AddressLine2:            "Khlong Tan, Khlong Toei, Bangkok",
		Road:                    "Test Road",
		ProvinceName:            "Bangkok",
		DistrictName:            "Khlong Toei",
		SubdistrictName:         "Khlong Tan",
		PostalCode:              "10110",
		Latitude:                "13.7300000",
		Longitude:               "100.5700000",
		SpaceTypeCode:           spaceTypeCode,
		SpaceTypeCodes:          category.spaceTypes,
		AllowedBusinessTypes:    allowedBusinessTypes,
		Amenities:               []string{"air_conditioning", "parking"},
		PriceOnRequest:          false,
		Currency:                currency,
		CategoryDetails:         categoryDetails,
		MediaItems: []listingMediaInput{
			{URL: imageURL, MediaType: "image"},
			{URL: videoURL, MediaType: "video"},
			{URL: panoramaURL, MediaType: "360"},
		},
	}
	for _, offerType := range category.offerTypes {
		switch offerType {
		case "sale":
			payload.SalePrice = "9250000"
		case "rent", "sublease":
			payload.RentPriceMonthly = "25000"
			payload.ServiceFeeMonthly = "1500"
		case "business_transfer":
			payload.KeyMoneyAmount = "1250000"
			if payload.RentPriceMonthly == "" {
				payload.RentPriceMonthly = "25000"
				payload.ServiceFeeMonthly = "1500"
			}
		}
	}
	if inSet("event_booth", category.spaceTypes...) {
		payload.PriceOnRequest = true
		payload.EventName = "MapXProp Integration Market"
		payload.EventVenueName = "MapXProp Integration Hall"
		payload.EventVenueFloorLabel = "Floor G"
		payload.EventFloorPlanURL = imageURL
		payload.EventRounds = []listingEventRoundInput{
			{StartsOn: "2099-09-11", EndsOn: "2099-09-14"},
			{StartsOn: "2099-09-20", EndsOn: "2099-09-25"},
		}
	}
	if category.propertyType == "monthly_hotel" {
		payload.RentPriceDaily = "2000"
	}
	// Prove that a price-on-request submission clears stale amounts and the
	// negotiable flag in PostgreSQL instead of accidentally publishing them.
	if category.discoveryChannel == "rooms" && category.propertyType == "flat" {
		payload.PriceOnRequest = true
	}
	if category.discoveryChannel == "homes" || category.discoveryChannel == "business" {
		switch category.propertyType {
		case "land":
			payload.UsableAreaSqm = ""
			payload.BedroomCount = ""
			payload.BathroomCount = ""
			payload.ParkingCount = ""
			payload.FloorNo = ""
			payload.TotalFloors = ""
			payload.FurnishingStatus = ""
			payload.PropertyCondition = ""
			payload.OccupancyStatus = ""
			payload.Amenities = nil
		case "condo":
			payload.LandAreaSqm = ""
		}
		if category.discoveryChannel == "business" && category.propertyGroup == "commercial" {
			payload.BedroomCount = ""
			if category.propertyType == "office" || category.propertyType == "retail_space" {
				payload.LandAreaSqm = ""
			}
		}
	} else if category.discoveryChannel == "rooms" {
		payload.LandAreaSqm = ""
		if category.listingScope == "multi_unit" {
			payload.BedroomCount = ""
			payload.BathroomCount = ""
		}
	}
	if category.propertyType != "land" && category.listingScope != "single_unit" && category.listingScope != "space_slot" {
		payload.FloorNo = ""
	}
	if category.discoveryChannel == "business" {
		if category.propertyType == "hotel_resort" {
			payload.BathroomCount = ""
		}
		if category.propertyType != "shophouse" && category.propertyType != "home_office" && category.propertyType != "office" {
			payload.FurnishingStatus = ""
		}
	}
	return payload
}

func integrationContactProfile(category listingCategoryIntegrationCase) (role string, authority string, organization string, registrationNo string) {
	switch {
	case category.discoveryChannel == "homes":
		return "owner", "self", "", ""
	case category.discoveryChannel == "rooms":
		return "owner_representative", "property_owner", "", ""
	case category.propertyType == "office":
		return "independent_broker", "property_owner", "", ""
	case category.propertyType == "retail_space":
		return "agency_broker", "brokerage_company", "MapXProp Realty Co., Ltd.", "0105569999999"
	case category.propertyType == "warehouse":
		return "developer_investor_representative", "developer_project", "MapXProp Development Co., Ltd.", "0105570000001"
	case category.propertyType == "factory":
		return "property_manager", "property_management_company", "MapXProp Property Management", "0105570000002"
	case category.propertyType == "hotel_resort":
		return "developer_investor_representative", "investor_asset_holder", "MapXProp Hospitality Fund", "0105570000003"
	case category.propertyType == "home_office":
		return "independent_broker", "co_broker", "", ""
	default:
		return "agency_broker", "brokerage_company", "MapXProp Realty Co., Ltd.", "0105569999999"
	}
}

func integrationCategoryDetails(category listingCategoryIntegrationCase) map[string]any {
	details := map[string]any{
		"integration_category":    category.propertyType,
		"can_complete_later":      true,
		"discovery_channel_code":  category.discoveryChannel,
		"selected_photo_count":    "1",
		"selected_video_count":    "1",
		"selected_panorama_count": "1",
	}
	if category.discoveryChannel == "homes" {
		details["details_status"] = "structured"
		if category.propertyType != "land" {
			details["available_from"] = "2026-09-15"
			details["year_built"] = "2565"
			details["renovated_year"] = "2568"
			details["tenure_type"] = "freehold"
			details["facing_direction"] = "east"
		}

		switch category.propertyType {
		case "detached_house":
			addIntegrationHouseDetails(details)
			details["house_style_code"] = "pool_villa"
		case "semi_detached_house":
			addIntegrationHouseDetails(details)
			details["unit_position"] = "end"
		case "townhouse":
			addIntegrationHouseDetails(details)
			details["unit_position"] = "corner"
		case "condo":
			details["condo_unit_type"] = "duplex"
			details["building_tower"] = "Tower A"
			details["balcony_direction"] = "north"
			details["view_type"] = "city"
			details["ownership_quota"] = "thai"
			details["common_fee_monthly"] = "3200"
			details["sinking_fund_per_sqm"] = "500"
			details["has_balcony"] = "yes"
		case "shophouse":
			addIntegrationBuildingDimensions(details)
			details["unit_position"] = "middle"
			details["has_mezzanine"] = "yes"
			details["has_elevator"] = "no"
			details["signage_space"] = "yes"
			details["three_phase_power"] = "yes"
		case "home_office":
			addIntegrationBuildingDimensions(details)
			details["unit_position"] = "standalone"
			details["office_room_count"] = "4"
			details["meeting_room_count"] = "2"
			details["has_pantry"] = "yes"
			details["has_elevator"] = "yes"
			details["project_common_fee_monthly"] = "4500"
		case "land":
			details["land_area_rai"] = "1"
			details["land_area_ngan"] = "2"
			details["land_area_sq_wah"] = "25.5"
			details["title_deed_type"] = "chanote"
			details["land_shape"] = "rectangular"
			details["land_width_m"] = "32"
			details["land_depth_m"] = "50"
			details["frontage_m"] = "30"
			details["road_width_m"] = "8"
			details["access_type"] = "public_road"
			details["road_surface"] = "concrete"
			details["land_fill_status"] = "filled"
			details["electricity_available"] = "yes"
			details["water_available"] = "yes"
			details["drainage_available"] = "no"
			details["zoning_color"] = "yellow_y4"
			details["current_land_use"] = "vacant_land"
			details["existing_structures"] = "small storage shed"
		}
		return details
	}
	if category.discoveryChannel == "business" {
		details["details_status"] = "structured"
		if category.propertyType != "land" {
			details["available_from"] = "2026-09-15"
			details["year_built"] = "2563"
			details["renovated_year"] = "2568"
			details["tenure_type"] = "freehold"
			details["commercial_use_allowed"] = "yes"
			details["handover_condition"] = "partly_fitted"
			details["operating_hours"] = "06:00-22:00"
		}

		switch category.propertyType {
		case "shophouse":
			addIntegrationBuildingDimensions(details)
			details["unit_position"] = "corner"
			details["has_mezzanine"] = "yes"
			details["has_elevator"] = "no"
			details["signage_space"] = "yes"
			details["three_phase_power"] = "yes"
			details["separate_entrance"] = "yes"
			details["cooking_allowed"] = "yes"
			details["exhaust_duct_available"] = "yes"
			details["grease_trap_available"] = "yes"
		case "home_office":
			addIntegrationBuildingDimensions(details)
			details["unit_position"] = "standalone"
			details["office_room_count"] = "4"
			details["meeting_room_count"] = "2"
			details["workstation_capacity"] = "24"
			details["reception_area"] = "yes"
			details["has_pantry"] = "yes"
			details["server_room"] = "yes"
			details["separate_entrance"] = "yes"
			details["has_elevator"] = "yes"
			details["three_phase_power"] = "yes"
			details["project_common_fee_monthly"] = "4500"
		case "office":
			details["office_grade"] = "a"
			details["office_layout"] = "partitioned"
			details["workstation_capacity"] = "80"
			details["office_room_count"] = "8"
			details["meeting_room_count"] = "4"
			details["ceiling_height_m"] = "2.8"
			details["central_air_conditioning"] = "yes"
			details["air_conditioning_hours"] = "08:00-18:00"
			details["raised_floor"] = "yes"
			details["access_control"] = "yes"
			details["backup_generator"] = "yes"
			details["freight_elevator"] = "yes"
			details["has_pantry"] = "yes"
		case "retail_space":
			details["frontage_m"] = "8"
			details["ceiling_height_m"] = "3.5"
			details["water_connection"] = "yes"
			details["drainage_available"] = "yes"
			details["three_phase_power"] = "yes"
			details["signage_space"] = "yes"
			// Keep this deliberately different from the food_service business type
			// so the integration test verifies that the explicit answer wins.
			details["cooking_allowed"] = "no"
			details["exhaust_duct_available"] = "yes"
			details["grease_trap_available"] = "yes"
			details["foot_traffic_notes"] = "Busy lunch and evening periods"
		case "warehouse":
			details["warehouse_type"] = "distribution"
			details["clear_height_m"] = "10"
			details["floor_load_kg_sqm"] = "3000"
			details["office_area_sqm"] = "180"
			details["yard_area_sqm"] = "1200"
			details["loading_dock_count"] = "6"
			details["drive_in_door_count"] = "2"
			details["max_truck_size"] = "trailer"
			details["three_phase_power"] = "yes"
			details["fire_sprinkler"] = "yes"
			details["temperature_controlled"] = "yes"
			details["warehouse_license_info"] = "Licensed for general goods storage"
		case "factory":
			details["factory_license_status"] = "valid"
			details["factory_license_number"] = "RNG4-TEST-001"
			details["industrial_estate_name"] = "MapX Industrial Estate"
			details["production_area_sqm"] = "2400"
			details["warehouse_area_sqm"] = "800"
			details["office_area_sqm"] = "250"
			details["clear_height_m"] = "12"
			details["floor_load_kg_sqm"] = "5000"
			details["power_capacity_kva"] = "2000"
			details["crane_capacity_ton"] = "20"
			details["max_truck_size"] = "trailer"
			details["three_phase_power"] = "yes"
			details["fire_sprinkler"] = "yes"
			details["wastewater_treatment"] = "yes"
			details["air_emission_system"] = "yes"
			details["hazardous_materials_allowed"] = "no"
		case "hotel_resort":
			details["hospitality_property_type"] = "resort"
			details["star_rating"] = "4"
			details["current_operation_status"] = "operating"
			details["total_units"] = "72"
			details["operational_room_count"] = "68"
			details["average_occupancy_percent"] = "74.5"
			details["average_daily_rate"] = "3200"
			details["restaurant_count"] = "2"
			details["meeting_capacity"] = "180"
			details["hotel_license_status"] = "valid"
			details["hotel_license_number"] = "HOTEL-TEST-001"
			details["management_contract_status"] = "none"
			details["room_type_summary"] = "52 Deluxe, 16 Suite, 4 Villa"
			details["hotel_facilities"] = []any{"restaurant", "meeting_room", "swimming_pool", "spa"}
		case "land":
			details["land_area_rai"] = "5"
			details["land_area_ngan"] = "1"
			details["land_area_sq_wah"] = "20"
			details["title_deed_type"] = "chanote"
			details["land_shape"] = "rectangular"
			details["land_width_m"] = "80"
			details["land_depth_m"] = "110"
			details["frontage_m"] = "75"
			details["road_width_m"] = "12"
			details["far_ratio"] = "4"
			details["osr_ratio"] = "6.5"
			details["access_type"] = "public_road"
			details["road_surface"] = "asphalt"
			details["land_fill_status"] = "filled"
			details["electricity_available"] = "yes"
			details["water_available"] = "yes"
			details["drainage_available"] = "yes"
			details["zoning_color"] = "purple"
			details["current_land_use"] = "industrial yard"
			details["existing_structures"] = "Small office and guardhouse"
		}
		return details
	}
	if category.discoveryChannel != "rooms" {
		return details
	}

	details["details_status"] = "structured"
	details["room_type_code"] = "studio"
	details["available_from"] = "2026-09-15"
	details["available_room_count"] = "2"
	details["bathroom_type"] = "private"
	details["security_deposit_amount"] = "25000"
	details["advance_rent_months"] = "1"
	details["water_billing_type"] = "per_unit"
	details["electricity_billing_type"] = "government_rate"
	details["visitor_policy"] = "Register visitors at reception"

	switch category.propertyType {
	case "rental_room":
		details["shared_facilities"] = []string{"kitchen", "entrance"}
		details["owner_lives_on_site"] = "yes"
	case "apartment":
		details["room_inventory_details"] = "Studio 24 sqm, 2 rooms available"
	case "dormitory":
		details["resident_groups"] = []string{"students", "workers"}
		details["curfew_time"] = "24-hour access"
	case "flat":
		details["managing_agency"] = "National Housing Authority"
		details["occupancy_right_type"] = "rent"
	case "serviced_apartment":
		details["services_included"] = []string{"housekeeping", "linen_change", "reception"}
		details["housekeeping_frequency"] = "twice a week"
	case "monthly_hotel":
		details["services_included"] = []string{"housekeeping", "reception", "internet"}
		details["cancellation_policy"] = "Seven days notice"
	case "condo":
		details["common_fee_included"] = "yes"
		details["juristic_rules"] = "Register every resident"
	}
	return details
}

func addIntegrationHouseDetails(details map[string]any) {
	details["land_width_m"] = "16.5"
	details["land_depth_m"] = "28"
	details["frontage_m"] = "16"
	details["road_width_m"] = "10"
	details["gated_community"] = "yes"
	details["project_common_fee_monthly"] = "2200"
	details["kitchen_type"] = "thai_kitchen"
	details["maid_room_count"] = "1"
	details["private_garden"] = "yes"
	details["private_pool"] = "no"
}

func addIntegrationBuildingDimensions(details map[string]any) {
	details["building_width_m"] = "5.5"
	details["building_depth_m"] = "18"
	details["frontage_m"] = "5.5"
	details["road_width_m"] = "12"
}

func createIntegrationListing(t *testing.T, app *fiber.App, accessToken string, payload createListingRequest) int64 {
	t.Helper()
	body, err := json.Marshal(payload)
	if err != nil {
		t.Fatal(err)
	}

	request := httptest.NewRequest("POST", "/listings", bytes.NewReader(body))
	request.Header.Set("Content-Type", "application/json")
	request.Header.Set("Authorization", "Bearer "+accessToken)
	response, err := app.Test(request, -1)
	if err != nil {
		t.Fatal(err)
	}
	defer response.Body.Close()
	if response.StatusCode != 201 {
		var errorBody map[string]any
		_ = json.NewDecoder(response.Body).Decode(&errorBody)
		t.Fatalf("create listing status=%d body=%v", response.StatusCode, errorBody)
	}

	var result struct {
		ID int64 `json:"id"`
	}
	if err := json.NewDecoder(response.Body).Decode(&result); err != nil {
		t.Fatal(err)
	}
	if result.ID == 0 {
		t.Fatal("create listing returned no database ID")
	}
	return result.ID
}

func assertIntegrationListingRejected(
	t *testing.T,
	app *fiber.App,
	accessToken string,
	payload createListingRequest,
	expectedError string,
) {
	t.Helper()
	body, err := json.Marshal(payload)
	if err != nil {
		t.Fatal(err)
	}
	request := httptest.NewRequest("POST", "/listings", bytes.NewReader(body))
	request.Header.Set("Content-Type", "application/json")
	request.Header.Set("Authorization", "Bearer "+accessToken)
	response, err := app.Test(request, -1)
	if err != nil {
		t.Fatal(err)
	}
	defer response.Body.Close()
	var result struct {
		Error string `json:"error"`
	}
	if err := json.NewDecoder(response.Body).Decode(&result); err != nil {
		t.Fatal(err)
	}
	if response.StatusCode != 400 || result.Error != expectedError {
		t.Fatalf("rejected listing mismatch: status=%d error=%q want=%q", response.StatusCode, result.Error, expectedError)
	}
}

func createIntegrationListingConcurrently(
	t *testing.T,
	app *fiber.App,
	db *sql.DB,
	accessToken string,
	payload createListingRequest,
	attempts int,
) int64 {
	t.Helper()
	body, err := json.Marshal(payload)
	if err != nil {
		t.Fatal(err)
	}
	type requestResult struct {
		id     int64
		status int
		err    error
	}
	results := make(chan requestResult, attempts)
	start := make(chan struct{})
	for attempt := 0; attempt < attempts; attempt++ {
		go func() {
			<-start
			request := httptest.NewRequest("POST", "/listings", bytes.NewReader(body))
			request.Header.Set("Content-Type", "application/json")
			request.Header.Set("Authorization", "Bearer "+accessToken)
			response, requestErr := app.Test(request, -1)
			if requestErr != nil {
				results <- requestResult{err: requestErr}
				return
			}
			defer response.Body.Close()
			var decoded struct {
				ID    int64  `json:"id"`
				Error string `json:"error"`
			}
			decodeErr := json.NewDecoder(response.Body).Decode(&decoded)
			if decodeErr != nil {
				results <- requestResult{status: response.StatusCode, err: decodeErr}
				return
			}
			if response.StatusCode != 201 {
				results <- requestResult{status: response.StatusCode, err: fmt.Errorf("%s", decoded.Error)}
				return
			}
			results <- requestResult{id: decoded.ID, status: response.StatusCode}
		}()
	}
	close(start)

	var listingID int64
	for attempt := 0; attempt < attempts; attempt++ {
		result := <-results
		if result.err != nil || result.status != 201 || result.id == 0 {
			t.Fatalf("concurrent listing request failed: status=%d id=%d error=%v", result.status, result.id, result.err)
		}
		if listingID == 0 {
			listingID = result.id
			continue
		}
		if result.id != listingID {
			t.Fatalf("concurrent submissions created different listings: first=%d got=%d", listingID, result.id)
		}
	}

	var rowsWithSubmissionKey int
	if err := db.QueryRow(`
		SELECT count(*) FROM public.listings WHERE submission_key = $1
	`, payload.SubmissionKey).Scan(&rowsWithSubmissionKey); err != nil {
		t.Fatal(err)
	}
	if rowsWithSubmissionKey != 1 {
		t.Fatalf("concurrent submissions created duplicate rows: got=%d want=1", rowsWithSubmissionKey)
	}
	return listingID
}

func assertIntegrationListingMediaURLs(t *testing.T, db *sql.DB, listingID int64, expected []listingMediaInput) {
	t.Helper()

	rows, err := db.Query(`
		SELECT media_type, COALESCE(NULLIF(original_url, ''), NULLIF(file_url, ''), '')
		FROM public.listing_media
		WHERE listing_id = $1 AND is_active = true AND deleted_at IS NULL
		ORDER BY media_type, sort_order, id
	`, listingID)
	if err != nil {
		t.Fatal(err)
	}
	defer rows.Close()

	actualByType := map[string][]string{"image": {}, "video": {}, "360": {}}
	for rows.Next() {
		var mediaType, mediaURL string
		if err := rows.Scan(&mediaType, &mediaURL); err != nil {
			t.Fatal(err)
		}
		actualByType[mediaType] = append(actualByType[mediaType], mediaURL)
	}
	if err := rows.Err(); err != nil {
		t.Fatal(err)
	}

	expectedByType := map[string][]string{"image": {}, "video": {}, "360": {}}
	for _, media := range expected {
		expectedByType[media.MediaType] = append(expectedByType[media.MediaType], media.URL)
	}
	if !reflect.DeepEqual(actualByType, expectedByType) {
		t.Fatalf("listing media URLs mismatch: got=%#v want=%#v", actualByType, expectedByType)
	}
}

func assertIntegrationListingImmediatelyPublished(t *testing.T, db *sql.DB, listingID int64) {
	t.Helper()
	var listingStatus, moderationStatus string
	var publishedAt sql.NullTime
	if err := db.QueryRow(`
		SELECT listing_status, moderation_status, published_at
		FROM public.listings
		WHERE id = $1
	`, listingID).Scan(&listingStatus, &moderationStatus, &publishedAt); err != nil {
		t.Fatal(err)
	}
	if listingStatus != "active" || moderationStatus != "approved" || !publishedAt.Valid {
		t.Fatalf(
			"listing was not published immediately: listing_status=%q moderation_status=%q published_at=%v",
			listingStatus,
			moderationStatus,
			publishedAt,
		)
	}
}

func assertIntegrationListingPersisted(
	t *testing.T,
	db *sql.DB,
	listingID int64,
	userID int64,
	category listingCategoryIntegrationCase,
	payload createListingRequest,
) {
	t.Helper()
	var (
		propertyType, listingScope, usageType, listingType  string
		title, description, secondaryPhone, instagram       string
		province, district, subdistrict, road, postalCode   string
		categoryCode, categoryMarker, submissionMode        string
		accommodationModel, categoryAccommodationModel      string
		latitude, longitude                                 float64
		usableArea, landArea                                float64
		images, videos, panoramas, primaryImages            int
		videoRoles, panoramaRoles, spaceTypes, amenities    int
		useCases, offers, exactOfferTerms                   int
		discoveryChannels, businessDetails, contactProfiles int
		priceOnRequest                                      bool
		rawCategoryDetails                                  []byte
		maxOccupants, minimumLeaseMonths                    int
		bedroomCount, bathroomCount, parkingCount           int
		floorNo, totalFloors                                int
		furnishingStatus, propertyCondition                 string
		occupancyStatus, petPolicyCode                      string
		utilitiesIncluded                                   bool
	)
	err := db.QueryRow(`
		SELECT
			l.property_type_code,
			COALESCE(l.accommodation_model, ''),
			l.listing_scope,
			l.usage_type,
			l.listing_type,
			l.title,
			COALESCE(l.description, ''),
			COALESCE(l.contact_phone_secondary, ''),
			COALESCE(l.instagram_handle, ''),
			COALESCE(l.province_name, ''),
			COALESCE(l.district_name, ''),
			COALESCE(l.subdistrict_name, ''),
			COALESCE(l.road, ''),
			COALESCE(l.postal_code, ''),
			COALESCE(l.usable_area_sqm, 0),
			COALESCE(l.land_area_sqm, 0),
			COALESCE(l.bedroom_count, 0),
			COALESCE(l.bathroom_count, 0),
			COALESCE(l.parking_count, 0),
			COALESCE(l.floor_no, 0),
			COALESCE(l.total_floors, 0),
			COALESCE(l.property_condition, ''),
			COALESCE(l.occupancy_status, ''),
			COALESCE(l.max_occupants, 0),
			COALESCE(l.minimum_lease_months, 0),
			COALESCE(l.furnishing_status, ''),
			COALESCE(l.pet_policy_code, ''),
			l.utilities_included,
			l.latitude,
			l.longitude,
			COALESCE(lcd.category_code, ''),
			COALESCE(lcd.details->>'integration_category', ''),
			COALESCE(lcd.details->>'submission_mode', ''),
			COALESCE(lcd.details->>'accommodation_model', ''),
			COALESCE((lcd.details->>'price_on_request')::boolean, false),
			COALESCE(lcd.details, '{}'::jsonb),
			(SELECT count(*) FROM public.listing_media WHERE listing_id = l.id AND media_type = 'image'),
			(SELECT count(*) FROM public.listing_media WHERE listing_id = l.id AND media_type = 'video'),
			(SELECT count(*) FROM public.listing_media WHERE listing_id = l.id AND media_type = '360'),
			(SELECT count(*) FROM public.listing_media WHERE listing_id = l.id AND role_code = 'cover' AND is_primary = true),
			(SELECT count(*) FROM public.listing_media WHERE listing_id = l.id AND role_code = 'property_video'),
			(SELECT count(*) FROM public.listing_media WHERE listing_id = l.id AND role_code = 'panorama'),
			(SELECT count(*) FROM public.listing_space_types WHERE listing_id = l.id),
			(SELECT count(*) FROM public.listing_amenities WHERE listing_id = l.id),
			(SELECT count(*) FROM public.listing_use_cases WHERE listing_id = l.id),
			(SELECT count(*) FROM public.listing_offers WHERE listing_id = l.id),
			(SELECT count(*) FROM public.listing_offers
			 WHERE listing_id = l.id
			   AND currency_code = $4
			   AND (
				($9 = false AND is_negotiable = true AND (
					(offer_type = 'sale' AND amount = 9250000 AND price_unit = 'total' AND minimum_contract_months IS NULL AND service_fee_monthly IS NULL)
					OR (offer_type IN ('rent', 'sublease') AND amount = 25000 AND price_unit = 'month' AND minimum_contract_months = 12 AND service_fee_monthly = 1500)
					OR (offer_type = 'business_transfer' AND amount = 1250000 AND price_unit = 'total' AND minimum_contract_months IS NULL AND service_fee_monthly IS NULL)
				))
				OR ($9 = false AND is_negotiable = false AND
					offer_type IN ('rent', 'sublease') AND amount = 5000 AND price_unit = 'event_period'
					AND deposit_amount = 10000 AND advance_amount = 5000
					AND minimum_contract_months = 3 AND service_fee_monthly = 750)
				OR ($9 = true AND (
					(offer_type = 'rent' AND amount IS NULL AND price_unit = 'month'
						AND minimum_contract_months = 12 AND service_fee_monthly IS NULL AND is_negotiable = false)
					OR (offer_type = 'rent' AND amount IS NULL AND price_unit = 'event_period'
						AND minimum_contract_months IS NULL AND service_fee_monthly IS NULL AND is_negotiable = false)
				))
			   )),
			(SELECT count(*) FROM public.listing_discovery_channels WHERE listing_id = l.id AND channel_code = $3 AND source = 'manual'),
			(SELECT count(*) FROM public.listing_business_details WHERE listing_id = l.id),
			(SELECT count(*) FROM public.listing_contact_profiles
			  WHERE listing_id = l.id
			    AND role_code = $5
			    AND authority_source_code = $6
			    AND COALESCE(organization_name, '') = $7
			    AND COALESCE(organization_registration_no, '') = $8
			    AND verification_status = 'unverified')
		FROM public.listings l
		LEFT JOIN public.listing_category_details lcd ON lcd.listing_id = l.id
		WHERE l.id = $1 AND l.user_id = $2
	`, listingID, userID, category.discoveryChannel, payload.Currency, payload.ContactRoleCode, payload.ContactAuthorityCode, payload.ContactOrganizationName, payload.ContactOrganizationNo, payload.PriceOnRequest).Scan(
		&propertyType,
		&accommodationModel,
		&listingScope,
		&usageType,
		&listingType,
		&title,
		&description,
		&secondaryPhone,
		&instagram,
		&province,
		&district,
		&subdistrict,
		&road,
		&postalCode,
		&usableArea,
		&landArea,
		&bedroomCount,
		&bathroomCount,
		&parkingCount,
		&floorNo,
		&totalFloors,
		&propertyCondition,
		&occupancyStatus,
		&maxOccupants,
		&minimumLeaseMonths,
		&furnishingStatus,
		&petPolicyCode,
		&utilitiesIncluded,
		&latitude,
		&longitude,
		&categoryCode,
		&categoryMarker,
		&submissionMode,
		&categoryAccommodationModel,
		&priceOnRequest,
		&rawCategoryDetails,
		&images,
		&videos,
		&panoramas,
		&primaryImages,
		&videoRoles,
		&panoramaRoles,
		&spaceTypes,
		&amenities,
		&useCases,
		&offers,
		&exactOfferTerms,
		&discoveryChannels,
		&businessDetails,
		&contactProfiles,
	)
	if err != nil {
		t.Fatal(err)
	}

	expectedPropertyType := category.propertyType
	if category.expectedPropertyType != "" {
		expectedPropertyType = category.expectedPropertyType
	}
	if propertyType != expectedPropertyType || accommodationModel != category.expectedAccommodationModel || listingScope != category.listingScope || usageType != category.usageType || listingType != category.listingType {
		t.Fatalf("classification mismatch: type=%q accommodation=%q scope=%q usage=%q listing=%q", propertyType, accommodationModel, listingScope, usageType, listingType)
	}
	if title != payload.Title || description != payload.Description {
		t.Fatalf("content mismatch: title=%q description=%q", title, description)
	}
	if secondaryPhone != payload.ContactPhoneSecondary || instagram != "mapxprop.test" {
		t.Fatalf("contact mismatch: secondary=%q instagram=%q", secondaryPhone, instagram)
	}
	if province != payload.ProvinceName || district != payload.DistrictName || subdistrict != payload.SubdistrictName || road != payload.Road || postalCode != payload.PostalCode {
		t.Fatalf("address mismatch: province=%q district=%q subdistrict=%q road=%q postal=%q", province, district, subdistrict, road, postalCode)
	}
	if latitude != 13.73 || longitude != 100.57 {
		t.Fatalf("coordinate mismatch: %f,%f", latitude, longitude)
	}
	if categoryCode != expectedPropertyType || categoryMarker != category.propertyType || categoryAccommodationModel != category.expectedAccommodationModel || submissionMode != "minimum" || priceOnRequest != payload.PriceOnRequest {
		t.Fatalf("category details mismatch: code=%q marker=%q accommodation=%q mode=%q priceOnRequest=%v", categoryCode, categoryMarker, categoryAccommodationModel, submissionMode, priceOnRequest)
	}
	if category.discoveryChannel == "rooms" {
		expectedBedrooms := 2
		expectedBathrooms := 2
		if category.listingScope == "multi_unit" {
			expectedBedrooms = 0
			expectedBathrooms = 0
		}
		expectedFloorNo := 0
		if category.listingScope == "single_unit" || category.listingScope == "space_slot" {
			expectedFloorNo = 5
		}
		if usableArea != 85.5 || landArea != 0 || bedroomCount != expectedBedrooms || bathroomCount != expectedBathrooms || parkingCount != 1 || floorNo != expectedFloorNo || totalFloors != 20 || maxOccupants != 4 || minimumLeaseMonths != 12 || furnishingStatus != "fully_furnished" || propertyCondition != "good" || occupancyStatus != "vacant" || petPolicyCode != "allowed" || !utilitiesIncluded {
			t.Fatalf("monthly-stay core fields mismatch for %s: usable=%v land=%v beds=%d baths=%d parking=%d floor=%d totalFloors=%d occupants=%d lease=%d furnishing=%q condition=%q occupancy=%q pets=%q utilities=%v", category.propertyType, usableArea, landArea, bedroomCount, bathroomCount, parkingCount, floorNo, totalFloors, maxOccupants, minimumLeaseMonths, furnishingStatus, propertyCondition, occupancyStatus, petPolicyCode, utilitiesIncluded)
		}
		assertMonthlyStayDetailsPersisted(t, rawCategoryDetails, category.propertyType)
	}
	if category.discoveryChannel == "homes" {
		if category.propertyType == "land" {
			if usableArea != 0 || bedroomCount != 0 || bathroomCount != 0 || parkingCount != 0 || floorNo != 0 || totalFloors != 0 || furnishingStatus != "" || propertyCondition != "" || occupancyStatus != "" {
				t.Fatalf("land core fields contain unrelated home data: usable=%v beds=%d baths=%d parking=%d floor=%d totalFloors=%d furnishing=%q condition=%q occupancy=%q", usableArea, bedroomCount, bathroomCount, parkingCount, floorNo, totalFloors, furnishingStatus, propertyCondition, occupancyStatus)
			}
			if landArea != 160 {
				t.Fatalf("land area was not persisted: got=%v want=160", landArea)
			}
		} else {
			expectedFloorNo := 0
			if category.listingScope == "single_unit" || category.listingScope == "space_slot" {
				expectedFloorNo = 5
			}
			if usableArea != 85.5 || bedroomCount != 2 || bathroomCount != 2 || parkingCount != 1 || floorNo != expectedFloorNo || totalFloors != 20 || furnishingStatus != "fully_furnished" || propertyCondition != "good" || occupancyStatus != "vacant" {
				t.Fatalf("home core fields mismatch: usable=%v beds=%d baths=%d parking=%d floor=%d totalFloors=%d furnishing=%q condition=%q occupancy=%q", usableArea, bedroomCount, bathroomCount, parkingCount, floorNo, totalFloors, furnishingStatus, propertyCondition, occupancyStatus)
			}
			expectedLandArea := 160.0
			if category.propertyType == "condo" {
				expectedLandArea = 0
			}
			if landArea != expectedLandArea {
				t.Fatalf("home land area mismatch for %s: got=%v want=%v", category.propertyType, landArea, expectedLandArea)
			}
		}
		assertStructuredCategoryDetailsPersisted(t, rawCategoryDetails, payload.CategoryDetails, category.propertyType, payload.PriceOnRequest, inSet("event_booth", category.spaceTypes...))
	}
	if category.discoveryChannel == "business" {
		if category.propertyType == "land" {
			if usableArea != 0 || bedroomCount != 0 || bathroomCount != 0 || parkingCount != 0 || floorNo != 0 || totalFloors != 0 || furnishingStatus != "" || propertyCondition != "" || occupancyStatus != "" {
				t.Fatalf("business land contains unrelated building data: usable=%v beds=%d baths=%d parking=%d floor=%d totalFloors=%d furnishing=%q condition=%q occupancy=%q", usableArea, bedroomCount, bathroomCount, parkingCount, floorNo, totalFloors, furnishingStatus, propertyCondition, occupancyStatus)
			}
			if landArea != 160 {
				t.Fatalf("business land area was not persisted: got=%v want=160", landArea)
			}
		} else {
			expectedBedrooms := 0
			if category.propertyGroup == "mixed_use" {
				expectedBedrooms = 2
			}
			expectedBathrooms := 2
			if category.propertyType == "hotel_resort" {
				expectedBathrooms = 0
			}
			expectedFloorNo := 0
			if category.listingScope == "single_unit" || category.listingScope == "space_slot" {
				expectedFloorNo = 5
			}
			expectedFurnishing := ""
			if category.propertyType == "shophouse" || category.propertyType == "home_office" || category.propertyType == "office" {
				expectedFurnishing = "fully_furnished"
			}
			if usableArea != 85.5 || bedroomCount != expectedBedrooms || bathroomCount != expectedBathrooms || parkingCount != 1 || floorNo != expectedFloorNo || totalFloors != 20 || furnishingStatus != expectedFurnishing || propertyCondition != "good" || occupancyStatus != "vacant" {
				t.Fatalf("business core fields mismatch for %s: usable=%v beds=%d baths=%d parking=%d floor=%d totalFloors=%d furnishing=%q condition=%q occupancy=%q", category.propertyType, usableArea, bedroomCount, bathroomCount, parkingCount, floorNo, totalFloors, furnishingStatus, propertyCondition, occupancyStatus)
			}
			expectedLandArea := 160.0
			if category.propertyType == "office" || category.propertyType == "retail_space" {
				expectedLandArea = 0
			}
			if landArea != expectedLandArea {
				t.Fatalf("business land area mismatch for %s: got=%v want=%v", category.propertyType, landArea, expectedLandArea)
			}
		}
		assertStructuredCategoryDetailsPersisted(t, rawCategoryDetails, payload.CategoryDetails, category.propertyType, payload.PriceOnRequest, inSet("event_booth", category.spaceTypes...))
	}
	if images != 1 || videos != 1 || panoramas != 1 || primaryImages != 1 || videoRoles != 1 || panoramaRoles != 1 {
		t.Fatalf("media mismatch: images=%d videos=%d panoramas=%d primary=%d videoRoles=%d panoramaRoles=%d", images, videos, panoramas, primaryImages, videoRoles, panoramaRoles)
	}
	if spaceTypes != len(category.spaceTypes) || amenities != len(payload.Amenities) || useCases != len(category.useCases) || offers != len(category.offerTypes) || exactOfferTerms != offers || discoveryChannels != 1 {
		t.Fatalf("relation count mismatch: spaces=%d amenities=%d useCases=%d offers=%d exactOfferTerms=%d requestedChannel=%d", spaceTypes, amenities, useCases, offers, exactOfferTerms, discoveryChannels)
	}
	expectedBusinessDetails := 0
	if category.usageType != "residence" || len(category.spaceTypes) > 0 {
		expectedBusinessDetails = 1
	}
	if businessDetails != expectedBusinessDetails {
		t.Fatalf("business details mismatch: got=%d want=%d", businessDetails, expectedBusinessDetails)
	}
	if contactProfiles != 1 {
		t.Fatalf("contact profile mismatch: got=%d role=%q authority=%q", contactProfiles, payload.ContactRoleCode, payload.ContactAuthorityCode)
	}
	assertIntegrationPricingPersisted(t, db, listingID, payload)
	if expectedBusinessDetails == 1 {
		var (
			allowedBusinessTypeCount int
			cookingAllowed           bool
		)
		if err := db.QueryRow(`
			SELECT COALESCE(cardinality(allowed_business_types), 0), cooking_allowed
			FROM public.listing_business_details
			WHERE listing_id = $1
		`, listingID).Scan(&allowedBusinessTypeCount, &cookingAllowed); err != nil {
			t.Fatal(err)
		}
		if allowedBusinessTypeCount != len(payload.AllowedBusinessTypes) {
			t.Fatalf("allowed business type count mismatch: got=%d want=%d", allowedBusinessTypeCount, len(payload.AllowedBusinessTypes))
		}
		for _, businessType := range payload.AllowedBusinessTypes {
			assertIntegrationRelation(t, db, `SELECT count(*) FROM public.listing_business_details WHERE listing_id = $1 AND $2 = ANY(allowed_business_types)`, listingID, businessType)
		}
		if submittedValue, exists := payload.CategoryDetails["cooking_allowed"]; exists {
			expectedValue, valid := listingBooleanValue(submittedValue)
			if !valid {
				t.Fatalf("integration cooking_allowed value is invalid: %#v", submittedValue)
			}
			if cookingAllowed != expectedValue {
				t.Fatalf("cooking allowed mismatch: got=%v want=%v submitted=%#v", cookingAllowed, expectedValue, submittedValue)
			}
		}
	}
	assertIntegrationEventPersisted(t, db, listingID, payload)

	for _, useCase := range category.useCases {
		assertIntegrationRelation(t, db, `SELECT count(*) FROM public.listing_use_cases WHERE listing_id = $1 AND use_case_code = $2`, listingID, useCase)
	}
	for _, offerType := range category.offerTypes {
		assertIntegrationRelation(t, db, `SELECT count(*) FROM public.listing_offers WHERE listing_id = $1 AND offer_type = $2`, listingID, offerType)
	}
	for index, spaceType := range category.spaceTypes {
		assertIntegrationRelation(t, db, `SELECT count(*) FROM public.listing_space_types WHERE listing_id = $1 AND space_type_code = $2`, listingID, spaceType)
		var isPrimary bool
		var sortOrder int
		if err := db.QueryRow(`
			SELECT is_primary, sort_order
			FROM public.listing_space_types
			WHERE listing_id = $1 AND space_type_code = $2
		`, listingID, spaceType).Scan(&isPrimary, &sortOrder); err != nil {
			t.Fatal(err)
		}
		if isPrimary != (index == 0) || sortOrder != index {
			t.Fatalf("space type order mismatch for %s: primary=%v sort=%d wantPrimary=%v wantSort=%d", spaceType, isPrimary, sortOrder, index == 0, index)
		}
	}
	for _, amenityCode := range payload.Amenities {
		assertIntegrationRelation(t, db, `SELECT count(*) FROM public.listing_amenities WHERE listing_id = $1 AND amenity_code = $2`, listingID, amenityCode)
	}
}

func assertIntegrationEventPersisted(t *testing.T, db *sql.DB, listingID int64, payload createListingRequest) {
	t.Helper()
	isEvent := inSet("event_booth", payload.SpaceTypeCodes...)
	if !isEvent {
		var count int
		if err := db.QueryRow(`SELECT count(*) FROM public.listing_event_details WHERE listing_id = $1`, listingID).Scan(&count); err != nil {
			t.Fatal(err)
		}
		if count != 0 {
			t.Fatalf("non-event listing %d retained event details", listingID)
		}
		return
	}

	organizerName := payload.ContactOrganizationName
	if organizerName == "" {
		organizerName = payload.ContactName
	}
	var eventDetailCount int
	if err := db.QueryRow(`
		SELECT count(*)
		FROM public.listing_event_details
		WHERE listing_id = $1
		  AND event_name = $2
		  AND COALESCE(organizer_name, '') = $3
		  AND venue_name = $4
		  AND COALESCE(venue_floor_label, '') = $5
		  AND COALESCE(floor_plan_url, '') = $6
		  AND price_on_request = $7
	`, listingID, payload.EventName, organizerName, payload.EventVenueName, payload.EventVenueFloorLabel, payload.EventFloorPlanURL, payload.PriceOnRequest).Scan(&eventDetailCount); err != nil {
		t.Fatal(err)
	}
	if eventDetailCount != 1 {
		t.Fatalf("event details were not persisted exactly for listing %d", listingID)
	}

	var roundCount int
	if err := db.QueryRow(`SELECT count(*) FROM public.listing_event_rounds WHERE listing_id = $1`, listingID).Scan(&roundCount); err != nil {
		t.Fatal(err)
	}
	if roundCount != len(payload.EventRounds) {
		t.Fatalf("event round count mismatch: got=%d want=%d", roundCount, len(payload.EventRounds))
	}
	for index, round := range payload.EventRounds {
		var (
			matching    int
			priceAmount sql.NullFloat64
			priceUnit   string
		)
		if err := db.QueryRow(`
			SELECT count(*), max(price_amount), max(price_unit)
			FROM public.listing_event_rounds
			WHERE listing_id = $1
			  AND round_label = $2
			  AND starts_on = $3::date
			  AND ends_on = $4::date
			  AND availability_status = 'open'
			  AND sort_order = $5
		`, listingID, fmt.Sprintf("รอบที่ %d", index+1), round.StartsOn, round.EndsOn, (index+1)*10).Scan(&matching, &priceAmount, &priceUnit); err != nil {
			t.Fatal(err)
		}
		if matching != 1 {
			t.Fatalf("event round %d was not persisted exactly: %#v", index+1, round)
		}
		if payload.PriceOnRequest {
			if priceAmount.Valid || priceUnit != "event_round" {
				t.Fatalf("price-on-request round %d retained pricing: amount=%v unit=%q", index+1, priceAmount, priceUnit)
			}
		} else {
			wantPrice, err := strconv.ParseFloat(payload.RetailRentPrice, 64)
			if err != nil {
				t.Fatal(err)
			}
			if !priceAmount.Valid || priceAmount.Float64 != wantPrice || priceUnit != payload.PriceUnit {
				t.Fatalf("fixed-price round %d pricing mismatch: amount=%v unit=%q", index+1, priceAmount, priceUnit)
			}
		}
	}

	latestEnd := payload.EventRounds[0].EndsOn
	for _, round := range payload.EventRounds[1:] {
		if round.EndsOn > latestEnd {
			latestEnd = round.EndsOn
		}
	}
	var expiryMatches bool
	if err := db.QueryRow(`
		SELECT (expires_at AT TIME ZONE 'Asia/Bangkok')::date = ($2::date + 1)
		FROM public.listings
		WHERE id = $1
	`, listingID, latestEnd).Scan(&expiryMatches); err != nil {
		t.Fatal(err)
	}
	if !expiryMatches {
		t.Fatalf("event listing expiry does not follow the final round ending %s", latestEnd)
	}
}

func assertStructuredCategoryDetailsPersisted(t *testing.T, rawDetails []byte, submitted map[string]any, propertyType string, priceOnRequest bool, isTemporarySpace bool) {
	t.Helper()
	var details map[string]any
	if err := json.Unmarshal(rawDetails, &details); err != nil {
		t.Fatal("decode structured category details:", err)
	}
	assertStructuredCategoryDetailsMap(t, details, submitted, propertyType, priceOnRequest, isTemporarySpace)
}

func assertStructuredCategoryDetailsMap(t *testing.T, details map[string]any, submitted map[string]any, propertyType string, priceOnRequest bool, isTemporarySpace bool) {
	t.Helper()
	expected := make(map[string]any, len(submitted)+2)
	for key, value := range submitted {
		expected[key] = value
	}
	expected["price_on_request"] = priceOnRequest
	expected["submission_mode"] = "minimum"
	if isTemporarySpace {
		if priceOnRequest {
			expected["temporary_space_pricing_mode"] = "contact_organizer"
		} else {
			expected["temporary_space_pricing_mode"] = "fixed"
		}
	}

	if len(details) != len(expected) {
		t.Fatalf("structured detail count mismatch for %s: got=%d want=%d details=%#v", propertyType, len(details), len(expected), details)
	}
	for key, want := range expected {
		got, ok := details[key]
		if !ok {
			t.Fatalf("structured detail %q is missing from database for %s: %#v", key, propertyType, details)
		}
		if !reflect.DeepEqual(got, want) {
			t.Fatalf("structured detail %q changed for %s: got=%#v want=%#v", key, propertyType, got, want)
		}
	}
}

func assertMonthlyStayDetailsPersisted(t *testing.T, rawDetails []byte, propertyType string) {
	t.Helper()
	var details map[string]any
	if err := json.Unmarshal(rawDetails, &details); err != nil {
		t.Fatal("decode monthly-stay category details:", err)
	}
	required := []string{
		"details_status",
		"room_type_code",
		"available_from",
		"available_room_count",
		"bathroom_type",
		"security_deposit_amount",
		"advance_rent_months",
		"water_billing_type",
		"electricity_billing_type",
		"visitor_policy",
	}
	switch propertyType {
	case "rental_room":
		required = append(required, "shared_facilities", "owner_lives_on_site")
	case "apartment":
		required = append(required, "room_inventory_details")
	case "dormitory":
		required = append(required, "resident_groups", "curfew_time")
	case "flat":
		required = append(required, "managing_agency", "occupancy_right_type")
	case "serviced_apartment":
		required = append(required, "services_included", "housekeeping_frequency")
	case "monthly_hotel":
		required = append(required, "services_included", "cancellation_policy")
	case "condo":
		required = append(required, "common_fee_included", "juristic_rules")
	}
	for _, key := range required {
		if value, ok := details[key]; !ok || value == nil || value == "" {
			t.Fatalf("monthly-stay detail %q was not persisted for %s: %#v", key, propertyType, details)
		}
	}
}

func assertIntegrationRelation(t *testing.T, db *sql.DB, query string, listingID int64, code string) {
	t.Helper()
	var count int
	if err := db.QueryRow(query, listingID, code).Scan(&count); err != nil {
		t.Fatal(err)
	}
	if count != 1 {
		t.Fatalf("relation %q was not persisted exactly once", code)
	}
}

func assertIntegrationPricingPersisted(t *testing.T, db *sql.DB, listingID int64, payload createListingRequest) {
	t.Helper()
	var salePrice, rentMonthly, rentDaily, keyMoney, serviceFee sql.NullFloat64
	var negotiable bool
	if err := db.QueryRow(`
		SELECT sale_price, rent_price_monthly, rent_price_daily,
			price_negotiable, key_money_amount, service_fee_monthly
		FROM public.listings
		WHERE id = $1
	`, listingID).Scan(&salePrice, &rentMonthly, &rentDaily, &negotiable, &keyMoney, &serviceFee); err != nil {
		t.Fatal(err)
	}

	if payload.PriceOnRequest {
		if salePrice.Valid || rentMonthly.Valid || rentDaily.Valid || keyMoney.Valid || serviceFee.Valid || negotiable {
			t.Fatalf("price-on-request leaked stale pricing: sale=%v rentMonthly=%v rentDaily=%v keyMoney=%v serviceFee=%v negotiable=%v", salePrice, rentMonthly, rentDaily, keyMoney, serviceFee, negotiable)
		}
		return
	}

	assertIntegrationOptionalAmount(t, "sale price", salePrice, payload.SalePrice)
	assertIntegrationOptionalAmount(t, "monthly rent", rentMonthly, payload.RentPriceMonthly)
	assertIntegrationOptionalAmount(t, "daily rent", rentDaily, payload.RentPriceDaily)
	assertIntegrationOptionalAmount(t, "key money", keyMoney, payload.KeyMoneyAmount)
	assertIntegrationOptionalAmount(t, "service fee", serviceFee, payload.ServiceFeeMonthly)
	if negotiable != payload.PriceNegotiable {
		t.Fatalf("negotiable mismatch: got=%v want=%v", negotiable, payload.PriceNegotiable)
	}
}

func assertIntegrationOptionalAmount(t *testing.T, label string, got sql.NullFloat64, submitted string) {
	t.Helper()
	if submitted == "" {
		if got.Valid {
			t.Fatalf("%s should be null, got=%v", label, got.Float64)
		}
		return
	}
	want, err := strconv.ParseFloat(submitted, 64)
	if err != nil {
		t.Fatalf("invalid expected %s %q: %v", label, submitted, err)
	}
	if !got.Valid || got.Float64 != want {
		t.Fatalf("%s mismatch: got=%v want=%v", label, got, want)
	}
}

func assertIntegrationContactRoleCoverage(t *testing.T, db *sql.DB, userID int64) {
	t.Helper()
	var roles, authorities, verifiedClaims int
	if err := db.QueryRow(`
		SELECT
			count(DISTINCT lcp.role_code),
			count(DISTINCT lcp.authority_source_code),
			count(*) FILTER (WHERE lcp.verification_status <> 'unverified')
		FROM public.listing_contact_profiles lcp
		JOIN public.listings l ON l.id = lcp.listing_id
		WHERE l.user_id = $1
	`, userID).Scan(&roles, &authorities, &verifiedClaims); err != nil {
		t.Fatal(err)
	}
	if roles != 6 || authorities != 7 || verifiedClaims != 0 {
		t.Fatalf("contact profile coverage mismatch: roles=%d/6 authorities=%d/7 verifiedClaims=%d", roles, authorities, verifiedClaims)
	}
}

func assertIntegrationListingDetailReadable(
	t *testing.T,
	app *fiber.App,
	db *sql.DB,
	listingID int64,
	userID int64,
	category listingCategoryIntegrationCase,
	payload createListingRequest,
) {
	t.Helper()
	var slug string
	if err := db.QueryRow(`
		UPDATE public.listings
		SET listing_status = 'active', moderation_status = 'approved', published_at = now()
		WHERE id = $1 AND user_id = $2
		RETURNING slug
	`, listingID, userID).Scan(&slug); err != nil {
		t.Fatal(err)
	}

	request := httptest.NewRequest("GET", "/listings/"+slug, nil)
	response, err := app.Test(request, -1)
	if err != nil {
		t.Fatal(err)
	}
	defer response.Body.Close()
	if response.StatusCode != 200 {
		var errorBody map[string]any
		_ = json.NewDecoder(response.Body).Decode(&errorBody)
		t.Fatalf("read listing detail status=%d body=%v", response.StatusCode, errorBody)
	}
	var detail listingDetailResponse
	if err := json.NewDecoder(response.Body).Decode(&detail); err != nil {
		t.Fatal(err)
	}
	expectedPropertyType := category.propertyType
	if category.expectedPropertyType != "" {
		expectedPropertyType = category.expectedPropertyType
	}
	if detail.PropertyTypeCode != expectedPropertyType || detail.Currency != payload.Currency {
		t.Fatalf("listing detail classification/currency mismatch: type=%q currency=%q", detail.PropertyTypeCode, detail.Currency)
	}
	if detail.ContactRoleCode != payload.ContactRoleCode || detail.ContactAuthorityCode != payload.ContactAuthorityCode || detail.ContactOrganization != payload.ContactOrganizationName || detail.ContactVerification != "unverified" {
		t.Fatalf("public contact profile mismatch: role=%q authority=%q organization=%q verification=%q", detail.ContactRoleCode, detail.ContactAuthorityCode, detail.ContactOrganization, detail.ContactVerification)
	}
	assertIntegrationPublicOffer(t, detail, category, payload)
	if marker, ok := detail.CategoryDetails["integration_category"].(string); !ok || marker != category.propertyType {
		t.Fatalf("listing detail category data mismatch: %#v", detail.CategoryDetails)
	}
	if publicPriceOnRequest, ok := detail.CategoryDetails["price_on_request"].(bool); !ok || publicPriceOnRequest != payload.PriceOnRequest {
		t.Fatalf("public price-on-request mismatch: got=%#v want=%v", detail.CategoryDetails["price_on_request"], payload.PriceOnRequest)
	}
	if category.discoveryChannel == "homes" {
		if category.propertyType == "land" {
			if detail.LandAreaSqm == nil || *detail.LandAreaSqm != 160 || detail.UsableAreaSqm != nil || detail.BedroomCount != nil || detail.PropertyCondition != "" {
				t.Fatalf("public land detail core fields mismatch: %#v", detail)
			}
		} else {
			if detail.UsableAreaSqm == nil || *detail.UsableAreaSqm != 85.5 || detail.BedroomCount == nil || *detail.BedroomCount != 2 || detail.BathroomCount == nil || *detail.BathroomCount != 2 || detail.ParkingCount == nil || *detail.ParkingCount != 1 || detail.TotalFloors == nil || *detail.TotalFloors != 20 || detail.FurnishingStatus != "fully_furnished" || detail.PropertyCondition != "good" || detail.OccupancyStatus != "vacant" {
				t.Fatalf("public home detail core fields mismatch for %s: %#v", category.propertyType, detail)
			}
			expectsFloorNumber := category.listingScope == "single_unit" || category.listingScope == "space_slot"
			if expectsFloorNumber && (detail.FloorNo == nil || *detail.FloorNo != 5) {
				t.Fatalf("public home floor number mismatch for %s: %#v", category.propertyType, detail.FloorNo)
			}
			if !expectsFloorNumber && detail.FloorNo != nil {
				t.Fatalf("public whole-property home should not contain a floor number for %s: %#v", category.propertyType, detail.FloorNo)
			}
			if category.propertyType == "condo" && detail.LandAreaSqm != nil {
				t.Fatalf("public condo detail should not contain land area: %#v", detail.LandAreaSqm)
			}
			if category.propertyType != "condo" && (detail.LandAreaSqm == nil || *detail.LandAreaSqm != 160) {
				t.Fatalf("public house detail land area mismatch for %s: %#v", category.propertyType, detail.LandAreaSqm)
			}
		}
		assertStructuredCategoryDetailsMap(t, detail.CategoryDetails, integrationCategoryDetails(category), category.propertyType, payload.PriceOnRequest, inSet("event_booth", category.spaceTypes...))
	}
	if category.discoveryChannel == "rooms" {
		if detail.LandAreaSqm != nil || detail.UsableAreaSqm == nil || *detail.UsableAreaSqm != 85.5 || detail.ParkingCount == nil || *detail.ParkingCount != 1 || detail.TotalFloors == nil || *detail.TotalFloors != 20 || detail.FurnishingStatus != "fully_furnished" || detail.PropertyCondition != "good" || detail.OccupancyStatus != "vacant" {
			t.Fatalf("public monthly-stay core fields mismatch for %s: %#v", category.propertyType, detail)
		}
		if category.listingScope == "multi_unit" {
			if detail.BedroomCount != nil || detail.BathroomCount != nil {
				t.Fatalf("public multi-unit monthly stay should use inventory fields instead of generic room counts for %s: beds=%#v baths=%#v", category.propertyType, detail.BedroomCount, detail.BathroomCount)
			}
		} else if detail.BedroomCount == nil || *detail.BedroomCount != 2 || detail.BathroomCount == nil || *detail.BathroomCount != 2 {
			t.Fatalf("public single-unit monthly-stay room counts mismatch for %s: beds=%#v baths=%#v", category.propertyType, detail.BedroomCount, detail.BathroomCount)
		}
		expectsFloorNumber := category.listingScope == "single_unit" || category.listingScope == "space_slot"
		if expectsFloorNumber && (detail.FloorNo == nil || *detail.FloorNo != 5) {
			t.Fatalf("public monthly-stay floor number mismatch for %s: %#v", category.propertyType, detail.FloorNo)
		}
		if !expectsFloorNumber && detail.FloorNo != nil {
			t.Fatalf("public whole-building monthly stay should not contain a floor number for %s: %#v", category.propertyType, detail.FloorNo)
		}
	}
	if category.discoveryChannel == "business" {
		if category.propertyType == "land" {
			if detail.LandAreaSqm == nil || *detail.LandAreaSqm != 160 || detail.UsableAreaSqm != nil || detail.BedroomCount != nil || detail.PropertyCondition != "" {
				t.Fatalf("public business-land core fields mismatch: %#v", detail)
			}
		} else {
			if detail.UsableAreaSqm == nil || *detail.UsableAreaSqm != 85.5 || detail.ParkingCount == nil || *detail.ParkingCount != 1 || detail.TotalFloors == nil || *detail.TotalFloors != 20 || detail.PropertyCondition != "good" || detail.OccupancyStatus != "vacant" {
				t.Fatalf("public business core fields mismatch for %s: %#v", category.propertyType, detail)
			}
			expectsBathrooms := category.propertyType != "hotel_resort"
			if expectsBathrooms && (detail.BathroomCount == nil || *detail.BathroomCount != 2) {
				t.Fatalf("public business restroom count mismatch for %s: %#v", category.propertyType, detail.BathroomCount)
			}
			if !expectsBathrooms && detail.BathroomCount != nil {
				t.Fatalf("public hotel detail should not contain a generic bathroom count: %#v", detail.BathroomCount)
			}
			expectsFloorNumber := category.listingScope == "single_unit" || category.listingScope == "space_slot"
			if expectsFloorNumber && (detail.FloorNo == nil || *detail.FloorNo != 5) {
				t.Fatalf("public business floor number mismatch for %s: %#v", category.propertyType, detail.FloorNo)
			}
			if !expectsFloorNumber && detail.FloorNo != nil {
				t.Fatalf("public whole-property business should not contain a floor number for %s: %#v", category.propertyType, detail.FloorNo)
			}
			expectedFurnishing := ""
			if category.propertyType == "shophouse" || category.propertyType == "home_office" || category.propertyType == "office" {
				expectedFurnishing = "fully_furnished"
			}
			if detail.FurnishingStatus != expectedFurnishing {
				t.Fatalf("public business furnishing mismatch for %s: got=%q want=%q", category.propertyType, detail.FurnishingStatus, expectedFurnishing)
			}
			if category.propertyGroup == "mixed_use" {
				if detail.BedroomCount == nil || *detail.BedroomCount != 2 {
					t.Fatalf("public mixed-use bedroom data mismatch for %s: %#v", category.propertyType, detail.BedroomCount)
				}
			} else if detail.BedroomCount != nil {
				t.Fatalf("public commercial detail should not contain bedroom data for %s: %#v", category.propertyType, detail.BedroomCount)
			}
			expectsLandArea := category.propertyType != "office" && category.propertyType != "retail_space"
			if expectsLandArea && (detail.LandAreaSqm == nil || *detail.LandAreaSqm != 160) {
				t.Fatalf("public business land area mismatch for %s: %#v", category.propertyType, detail.LandAreaSqm)
			}
			if !expectsLandArea && detail.LandAreaSqm != nil {
				t.Fatalf("public business unit should not contain land area for %s: %#v", category.propertyType, detail.LandAreaSqm)
			}
		}
		assertStructuredCategoryDetailsMap(t, detail.CategoryDetails, integrationCategoryDetails(category), category.propertyType, payload.PriceOnRequest, inSet("event_booth", category.spaceTypes...))
	}
	expectedAmenities := []string{"air_conditioning", "parking"}
	if category.propertyType == "land" {
		expectedAmenities = []string{}
	}
	if !reflect.DeepEqual(detail.Amenities, expectedAmenities) {
		t.Fatalf("listing detail amenities mismatch: got=%#v want=%#v", detail.Amenities, expectedAmenities)
	}
	expectedAllowedBusinessTypes := payload.AllowedBusinessTypes
	if expectedAllowedBusinessTypes == nil {
		expectedAllowedBusinessTypes = []string{}
	}
	if !reflect.DeepEqual(detail.AllowedBusinessTypes, expectedAllowedBusinessTypes) {
		t.Fatalf("listing detail allowed business types mismatch: got=%#v want=%#v", detail.AllowedBusinessTypes, expectedAllowedBusinessTypes)
	}
	if inSet("event_booth", payload.SpaceTypeCodes...) {
		if detail.Event == nil {
			t.Fatal("event listing detail did not include event data")
		}
		if detail.Event.Name != payload.EventName || detail.Event.VenueName != payload.EventVenueName || detail.Event.VenueFloorLabel != payload.EventVenueFloorLabel || detail.Event.FloorPlanURL != payload.EventFloorPlanURL {
			t.Fatalf("public event details mismatch: got=%#v payload=%#v", detail.Event, payload)
		}
		if len(detail.Event.Rounds) != len(payload.EventRounds) {
			t.Fatalf("public event rounds mismatch: got=%d want=%d", len(detail.Event.Rounds), len(payload.EventRounds))
		}
		for index, round := range detail.Event.Rounds {
			if round.StartsOn != payload.EventRounds[index].StartsOn || round.EndsOn != payload.EventRounds[index].EndsOn {
				t.Fatalf("public event round %d mismatch: got=%#v want=%#v", index+1, round, payload.EventRounds[index])
			}
		}
	} else if detail.Event != nil {
		t.Fatalf("non-event listing returned event data: %#v", detail.Event)
	}
}

func assertIntegrationPublicOffer(t *testing.T, detail listingDetailResponse, category listingCategoryIntegrationCase, payload createListingRequest) {
	t.Helper()
	expectedType := category.offerTypes[0]
	if inSet("rent", category.offerTypes...) {
		expectedType = "rent"
	} else if inSet("sublease", category.offerTypes...) {
		expectedType = "sublease"
	}
	expectedUnit := "total"
	expectedAmount := ""
	switch expectedType {
	case "sale":
		expectedAmount = payload.SalePrice
	case "rent", "sublease":
		if category.propertyType == "retail_space" {
			expectedAmount = payload.RetailRentPrice
			if expectedAmount == "" {
				expectedAmount = payload.RentPriceMonthly
				if inSet("event_booth", category.spaceTypes...) {
					expectedAmount = payload.TemporarySpacePrice
				}
			}
			expectedUnit = payload.PriceUnit
			if expectedUnit == "" {
				if inSet("event_booth", category.spaceTypes...) {
					expectedUnit = "event_period"
				} else {
					expectedUnit = "month"
				}
			}
		} else {
			expectedAmount = payload.RentPriceMonthly
			expectedUnit = "month"
		}
	case "business_transfer":
		expectedAmount = payload.KeyMoneyAmount
	}
	if detail.OfferType != expectedType || detail.PriceUnit != expectedUnit || detail.Currency != payload.Currency {
		t.Fatalf("public offer mismatch: type=%q/%q unit=%q/%q currency=%q/%q", detail.OfferType, expectedType, detail.PriceUnit, expectedUnit, detail.Currency, payload.Currency)
	}
	expectedNegotiable := !payload.PriceOnRequest && payload.PriceNegotiable
	if detail.PriceNegotiable != expectedNegotiable {
		t.Fatalf("public negotiable mismatch: got=%v want=%v", detail.PriceNegotiable, expectedNegotiable)
	}
	if payload.PriceOnRequest || expectedAmount == "" {
		if detail.OfferAmount != nil {
			t.Fatalf("public offer amount should be omitted, got=%v", *detail.OfferAmount)
		}
		if category.propertyType == "retail_space" && (detail.DepositAmount != nil || detail.AdvanceRentAmount != nil || detail.MinimumContractMonths != nil || detail.ServiceFeeMonthly != nil) {
			t.Fatalf("price-on-request retail terms should be omitted: deposit=%v advance=%v minimum=%v service=%v", detail.DepositAmount, detail.AdvanceRentAmount, detail.MinimumContractMonths, detail.ServiceFeeMonthly)
		}
		return
	}
	want, err := strconv.ParseFloat(expectedAmount, 64)
	if err != nil {
		t.Fatal(err)
	}
	if detail.OfferAmount == nil || *detail.OfferAmount != want {
		t.Fatalf("public offer amount mismatch: got=%v want=%v", detail.OfferAmount, want)
	}
	if category.propertyType == "retail_space" && (expectedType == "rent" || expectedType == "sublease") {
		assertIntegrationOptionalFloat(t, "deposit", detail.DepositAmount, payload.DepositAmount)
		assertIntegrationOptionalFloat(t, "advance rent", detail.AdvanceRentAmount, payload.AdvanceRentAmount)
		assertIntegrationOptionalFloat(t, "service fee", detail.ServiceFeeMonthly, payload.ServiceFeeMonthly)
		if payload.MinimumLeaseMonths == "" {
			if detail.MinimumContractMonths != nil {
				t.Fatalf("minimum contract should be omitted, got=%d", *detail.MinimumContractMonths)
			}
		} else {
			minimumMonths, err := strconv.Atoi(payload.MinimumLeaseMonths)
			if err != nil {
				t.Fatal(err)
			}
			if detail.MinimumContractMonths == nil || *detail.MinimumContractMonths != minimumMonths {
				t.Fatalf("minimum contract mismatch: got=%v want=%d", detail.MinimumContractMonths, minimumMonths)
			}
		}
	}
}

func assertIntegrationOptionalFloat(t *testing.T, label string, actual *float64, expected string) {
	t.Helper()
	if expected == "" {
		if actual != nil {
			t.Fatalf("%s should be omitted, got=%v", label, *actual)
		}
		return
	}
	want, err := strconv.ParseFloat(expected, 64)
	if err != nil {
		t.Fatal(err)
	}
	if actual == nil || *actual != want {
		t.Fatalf("%s mismatch: got=%v want=%v", label, actual, want)
	}
}

func assertIntegrationOwnerListingsReadable(t *testing.T, app *fiber.App, accessToken string) {
	t.Helper()
	request := httptest.NewRequest("GET", "/me/listings", nil)
	request.Header.Set("Authorization", "Bearer "+accessToken)
	response, err := app.Test(request, -1)
	if err != nil {
		t.Fatal(err)
	}
	defer response.Body.Close()
	if response.StatusCode != 200 {
		var errorBody map[string]any
		_ = json.NewDecoder(response.Body).Decode(&errorBody)
		t.Fatalf("read owner listings status=%d body=%v", response.StatusCode, errorBody)
	}
	var result struct {
		Listings []myListingResponse `json:"listings"`
	}
	if err := json.NewDecoder(response.Body).Decode(&result); err != nil {
		t.Fatal(err)
	}
	if len(result.Listings) != len(selectableListingCategoryCases) {
		t.Fatalf("owner listing count mismatch: got=%d want=%d", len(result.Listings), len(selectableListingCategoryCases))
	}
	for _, listing := range result.Listings {
		expectedCurrency := "THB"
		if listing.PropertyTypeCode == "retail_space" {
			expectedCurrency = "USD"
		}
		if listing.Currency != expectedCurrency {
			t.Fatalf("owner listing %d currency mismatch: got=%q want=%q", listing.ID, listing.Currency, expectedCurrency)
		}
	}
}

func assertIntegrationOwnerListingPrimaryImage(
	t *testing.T,
	app *fiber.App,
	accessToken string,
	publicListingID string,
	expectedURL string,
) {
	t.Helper()
	request := httptest.NewRequest("GET", "/me/listings", nil)
	request.Header.Set("Authorization", "Bearer "+accessToken)
	response, err := app.Test(request, -1)
	if err != nil {
		t.Fatal(err)
	}
	defer response.Body.Close()
	if response.StatusCode != 200 {
		t.Fatalf("read owner listing after media edit status=%d", response.StatusCode)
	}
	var result struct {
		Listings []myListingResponse `json:"listings"`
	}
	if err := json.NewDecoder(response.Body).Decode(&result); err != nil {
		t.Fatal(err)
	}
	for _, listing := range result.Listings {
		if listing.PublicListingID != publicListingID {
			continue
		}
		if listing.PrimaryImageURL != expectedURL {
			t.Fatalf("owner listing primary image mismatch: got=%q want=%q", listing.PrimaryImageURL, expectedURL)
		}
		return
	}
	t.Fatalf("edited listing %s was missing from owner listings", publicListingID)
}

func uploadIntegrationMedia(
	t *testing.T,
	app *fiber.App,
	accessToken string,
	mediaType string,
	filename string,
	contents []byte,
) string {
	t.Helper()
	var body bytes.Buffer
	writer := multipart.NewWriter(&body)
	if err := writer.WriteField("media_type", mediaType); err != nil {
		t.Fatal(err)
	}
	filePart, err := writer.CreateFormFile("file", filename)
	if err != nil {
		t.Fatal(err)
	}
	if _, err := filePart.Write(contents); err != nil {
		t.Fatal(err)
	}
	if err := writer.Close(); err != nil {
		t.Fatal(err)
	}

	request := httptest.NewRequest("POST", "/listing-media", &body)
	request.Header.Set("Content-Type", writer.FormDataContentType())
	request.Header.Set("Authorization", "Bearer "+accessToken)
	response, err := app.Test(request, -1)
	if err != nil {
		t.Fatal(err)
	}
	defer response.Body.Close()
	if response.StatusCode != 201 {
		var errorBody map[string]any
		_ = json.NewDecoder(response.Body).Decode(&errorBody)
		t.Fatalf("upload %s status=%d body=%v", mediaType, response.StatusCode, errorBody)
	}
	var result struct {
		URL string `json:"url"`
	}
	if err := json.NewDecoder(response.Body).Decode(&result); err != nil {
		t.Fatal(err)
	}
	if result.URL == "" {
		t.Fatalf("upload %s returned no URL", mediaType)
	}
	return result.URL
}
