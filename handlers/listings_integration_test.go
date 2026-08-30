package handlers

import (
	"bytes"
	"encoding/json"
	"estate-map-api/database"
	"fmt"
	"mime/multipart"
	"net/http/httptest"
	"os"
	"path/filepath"
	"strconv"
	"testing"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
	"github.com/joho/godotenv"
)

func TestCreateListingPersistsCompleteSubmission(t *testing.T) {
	if os.Getenv("MAPXPROP_DB_INTEGRATION") != "1" {
		t.Skip("set MAPXPROP_DB_INTEGRATION=1 to run the database integration test")
	}
	if err := godotenv.Load("../.env"); err != nil {
		t.Fatal("load integration database environment:", err)
	}

	db := database.ConnectDB()
	defer db.Close()

	publicUserID := uuid.NewString()
	email := fmt.Sprintf("codex-listing-check-%s@example.invalid", uuid.NewString())
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
		mediaDirectory := filepath.Join(listingMediaRoot(), strconv.FormatInt(userID, 10))
		if err := os.RemoveAll(mediaDirectory); err != nil {
			t.Errorf("cleanup integration media: %v", err)
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
	imageURL := uploadIntegrationMedia(
		t,
		app,
		accessToken,
		"image",
		"cover.png",
		[]byte{0x89, 'P', 'N', 'G', '\r', '\n', 0x1a, '\n', 0, 0, 0, 0, 'I', 'H', 'D', 'R'},
	)
	videoURL := uploadIntegrationMedia(
		t,
		app,
		accessToken,
		"video",
		"tour.mp4",
		[]byte{0, 0, 0, 24, 'f', 't', 'y', 'p', 'i', 's', 'o', 'm', 0, 0, 0, 0, 'i', 's', 'o', 'm', 'm', 'p', '4', '1'},
	)
	panoramaURL := uploadIntegrationMedia(
		t,
		app,
		accessToken,
		"360",
		"panorama.png",
		[]byte{0x89, 'P', 'N', 'G', '\r', '\n', 0x1a, '\n', 0, 0, 0, 0, 'I', 'H', 'D', 'R'},
	)

	payload := createListingRequest{
		DiscoveryChannelCode:  "business",
		PropertyGroupCode:     "commercial",
		PropertyTypeCode:      "retail_space",
		ListingScope:          "space_slot",
		UseCaseCodes:          []string{"retail"},
		OfferTypes:            []string{"rent"},
		UsageType:             "business",
		ListingType:           "rent",
		Title:                 "Integration listing persistence check",
		RentPriceMonthly:      "25000",
		ContactName:           "MapXProp Test",
		ContactPhone:          "0800000000",
		ContactPhoneSecondary: "0811111111",
		InstagramHandle:       "@mapxprop.test",
		AddressLine1:          "99 Test Road",
		Road:                  "Test Road",
		ProvinceName:          "กรุงเทพมหานคร",
		DistrictName:          "คลองเตย",
		SubdistrictName:       "คลองตัน",
		PostalCode:            "10110",
		Latitude:              "13.7300000",
		Longitude:             "100.5700000",
		SpaceTypeCode:         "mall_kiosk",
		SpaceTypeCodes:        []string{"mall_kiosk", "event_booth"},
		MediaItems: []listingMediaInput{
			{URL: imageURL, MediaType: "image"},
			{URL: videoURL, MediaType: "video"},
			{URL: panoramaURL, MediaType: "360"},
		},
	}
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

	var secondaryPhone, instagram, province string
	var latitude, longitude float64
	var images, videos, panoramas, spaceTypes int
	if err := db.QueryRow(`
		SELECT
			COALESCE(l.contact_phone_secondary, ''),
			COALESCE(l.instagram_handle, ''),
			COALESCE(l.province_name, ''),
			l.latitude,
			l.longitude,
			(SELECT count(*) FROM public.listing_media WHERE listing_id = l.id AND media_type = 'image'),
			(SELECT count(*) FROM public.listing_media WHERE listing_id = l.id AND media_type = 'video'),
			(SELECT count(*) FROM public.listing_media WHERE listing_id = l.id AND media_type = '360'),
			(SELECT count(*) FROM public.listing_space_types WHERE listing_id = l.id)
		FROM public.listings l
		WHERE l.id = $1 AND l.user_id = $2
	`, result.ID, userID).Scan(
		&secondaryPhone,
		&instagram,
		&province,
		&latitude,
		&longitude,
		&images,
		&videos,
		&panoramas,
		&spaceTypes,
	); err != nil {
		t.Fatal(err)
	}

	if secondaryPhone != "0811111111" || instagram != "mapxprop.test" || province != "กรุงเทพมหานคร" {
		t.Fatalf("contact/location mismatch: %q %q %q", secondaryPhone, instagram, province)
	}
	if latitude != 13.73 || longitude != 100.57 {
		t.Fatalf("coordinate mismatch: %f,%f", latitude, longitude)
	}
	if images != 1 || videos != 1 || panoramas != 1 || spaceTypes != 2 {
		t.Fatalf("related data mismatch: images=%d videos=%d panoramas=%d spaceTypes=%d", images, videos, panoramas, spaceTypes)
	}
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
