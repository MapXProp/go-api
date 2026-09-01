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

func TestListingContactProfilePersistsChannelsAcrossRoleChanges(t *testing.T) {
	if os.Getenv("MAPXPROP_DB_INTEGRATION") != "1" {
		t.Skip("set MAPXPROP_DB_INTEGRATION=1 to run the database integration test")
	}
	_ = godotenv.Load("../.env")

	db := database.ConnectDB()
	defer db.Close()
	if err := database.RunMigrations(db); err != nil {
		t.Fatal(err)
	}

	publicUserID := uuid.NewString()
	email := fmt.Sprintf("codex-contact-profile-%s@example.invalid", uuid.NewString())
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
		if _, err := db.Exec(`DELETE FROM public.auth_users WHERE id = $1 AND email = $2`, userID, email); err != nil {
			t.Errorf("cleanup integration user: %v", err)
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
	app.Get("/me/listing-contact", GetMyListingContactProfile(db))
	app.Put("/me/listing-contact", UpsertMyListingContactProfile(db))

	profile := listingContactProfileRequest{
		ContactName:           "Mapx Agent",
		ContactPhone:          "081-234-5678",
		ContactPhoneSecondary: "089-876-5432",
		ContactEmail:          "agent@example.com",
		LineID:                "mapx-agent",
		InstagramHandle:       "@mapx.agent",
		RoleCode:              "agency_broker",
		AuthoritySourceCode:   "brokerage_company",
		OrganizationName:      "Mapx Brokerage",
	}
	putListingContactProfile(t, app, accessToken, profile)

	profile.RoleCode = "owner_representative"
	profile.AuthoritySourceCode = "property_owner"
	profile.OrganizationName = ""
	putListingContactProfile(t, app, accessToken, profile)

	request := httptest.NewRequest("GET", "/me/listing-contact", nil)
	request.Header.Set("Authorization", "Bearer "+accessToken)
	response, err := app.Test(request, -1)
	if err != nil {
		t.Fatal(err)
	}
	defer response.Body.Close()
	if response.StatusCode != fiber.StatusOK {
		t.Fatalf("get contact profile status=%d", response.StatusCode)
	}
	var result struct {
		Profile listingContactProfileResponse `json:"profile"`
	}
	if err := json.NewDecoder(response.Body).Decode(&result); err != nil {
		t.Fatal(err)
	}
	if result.Profile.ContactName != profile.ContactName || result.Profile.ContactPhone != profile.ContactPhone {
		t.Fatalf("contact channels were not preserved: %+v", result.Profile)
	}
	if result.Profile.RoleCode != "owner_representative" || result.Profile.AuthoritySourceCode != "property_owner" {
		t.Fatalf("role change was not persisted: %+v", result.Profile)
	}
}

func putListingContactProfile(
	t *testing.T,
	app *fiber.App,
	accessToken string,
	profile listingContactProfileRequest,
) {
	t.Helper()
	body, err := json.Marshal(profile)
	if err != nil {
		t.Fatal(err)
	}
	request := httptest.NewRequest("PUT", "/me/listing-contact", bytes.NewReader(body))
	request.Header.Set("Authorization", "Bearer "+accessToken)
	request.Header.Set("Content-Type", "application/json")
	response, err := app.Test(request, -1)
	if err != nil {
		t.Fatal(err)
	}
	defer response.Body.Close()
	if response.StatusCode != fiber.StatusOK {
		var errorBody map[string]any
		_ = json.NewDecoder(response.Body).Decode(&errorBody)
		t.Fatalf("put contact profile status=%d body=%v", response.StatusCode, errorBody)
	}
}
