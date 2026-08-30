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
	"os"
	"path/filepath"
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
	{propertyType: "retail_space", propertyGroup: "commercial", discoveryChannel: "business", listingScope: "space_slot", useCases: []string{"retail", "food_service"}, offerTypes: []string{"rent"}, usageType: "business", listingType: "rent", spaceTypes: []string{"mall_kiosk", "event_booth"}},
	{propertyType: "warehouse", propertyGroup: "commercial", discoveryChannel: "business", listingScope: "whole_property", useCases: []string{"storage"}, offerTypes: []string{"rent"}, usageType: "business", listingType: "rent"},
	{propertyType: "factory", propertyGroup: "commercial", discoveryChannel: "business", listingScope: "whole_property", useCases: []string{"industrial"}, offerTypes: []string{"rent"}, usageType: "business", listingType: "rent"},
	{propertyType: "condo", propertyGroup: "residential", discoveryChannel: "rooms", listingScope: "single_unit", useCases: []string{"residential"}, offerTypes: []string{"rent"}, usageType: "residence", listingType: "rent"},
}

func TestCreateListingPersistsAllSelectableCategories(t *testing.T) {
	if os.Getenv("MAPXPROP_DB_INTEGRATION") != "1" {
		t.Skip("set MAPXPROP_DB_INTEGRATION=1 to run the database integration test")
	}
	if err := godotenv.Load("../.env"); err != nil {
		t.Fatal("load integration database environment:", err)
	}
	if len(selectableListingCategoryCases) != 18 {
		t.Fatalf("integration matrix must cover 17 property types plus the monthly-condo route, got %d", len(selectableListingCategoryCases))
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
			listingID := createIntegrationListing(t, app, accessToken, payload)
			assertIntegrationListingPersisted(t, db, listingID, userID, category, payload)
			if index == 0 || category.discoveryChannel == "rooms" {
				assertIntegrationListingDetailReadable(t, app, db, listingID, userID, category)
			}
		})
	}
	assertIntegrationOwnerListingsReadable(t, app, accessToken)

	if err := cleanup(); err != nil {
		t.Fatal(err)
	}
	cleanupComplete = true
}

func assertRoomTaxonomySearch(t *testing.T, db *sql.DB) {
	t.Helper()
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

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
	categoryDetails := integrationCategoryDetails(category)
	return createListingRequest{
		DiscoveryChannelCode:  category.discoveryChannel,
		PropertyGroupCode:     category.propertyGroup,
		PropertyTypeCode:      category.propertyType,
		AccommodationModel:    category.expectedAccommodationModel,
		ListingScope:          category.listingScope,
		UseCaseCodes:          category.useCases,
		OfferTypes:            category.offerTypes,
		UsageType:             category.usageType,
		ListingType:           category.listingType,
		Title:                 "DB matrix check: " + category.propertyType,
		Description:           "Complete integration submission for " + category.propertyType,
		CustomProjectName:     "MapXProp Integration Project",
		CustomUnitNumber:      "TEST-17",
		SalePrice:             "9250000",
		RentPriceMonthly:      "25000",
		RentPriceDaily:        "2000",
		PriceNegotiable:       true,
		UsableAreaSqm:         "85.5",
		LandAreaSqm:           "160",
		BedroomCount:          "2",
		BathroomCount:         "2",
		ParkingCount:          "1",
		MaxOccupants:          "4",
		FloorNo:               "5",
		TotalFloors:           "20",
		FurnishingStatus:      "fully_furnished",
		PropertyCondition:     "good",
		OccupancyStatus:       "vacant",
		MinimumLeaseMonths:    "12",
		PetAllowed:            true,
		PetPolicyCode:         "allowed",
		UtilitiesIncluded:     category.discoveryChannel == "rooms",
		ContactName:           "MapXProp DB Test",
		ContactPhone:          "0800000000",
		ContactPhoneSecondary: "0811111111",
		ContactEmail:          "listing-test@example.invalid",
		LineID:                "mapxprop-test",
		InstagramHandle:       "@mapxprop.test",
		AddressLine1:          "99 Test Road",
		AddressLine2:          "Khlong Tan, Khlong Toei, Bangkok",
		Road:                  "Test Road",
		ProvinceName:          "Bangkok",
		DistrictName:          "Khlong Toei",
		SubdistrictName:       "Khlong Tan",
		PostalCode:            "10110",
		Latitude:              "13.7300000",
		Longitude:             "100.5700000",
		SpaceTypeCode:         spaceTypeCode,
		SpaceTypeCodes:        category.spaceTypes,
		AllowedBusinessTypes:  allowedBusinessTypes,
		Amenities:             []string{"air_conditioning", "parking"},
		PriceOnRequest:        false,
		Currency:              "THB",
		CategoryDetails:       categoryDetails,
		MediaItems: []listingMediaInput{
			{URL: imageURL, MediaType: "image"},
			{URL: videoURL, MediaType: "video"},
			{URL: panoramaURL, MediaType: "360"},
		},
	}
}

func integrationCategoryDetails(category listingCategoryIntegrationCase) map[string]any {
	details := map[string]any{
		"integration_category":    category.propertyType,
		"selected_photo_count":    "1",
		"selected_video_count":    "1",
		"selected_panorama_count": "1",
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
		propertyType, listingScope, usageType, listingType string
		title, description, secondaryPhone, instagram      string
		province, district, subdistrict, road, postalCode  string
		categoryCode, categoryMarker, submissionMode       string
		accommodationModel, categoryAccommodationModel     string
		latitude, longitude                                float64
		images, videos, panoramas, primaryImages           int
		videoRoles, panoramaRoles, spaceTypes, amenities   int
		useCases, offers, currencyOffers                   int
		discoveryChannels, businessDetails                 int
		priceOnRequest                                     bool
		rawCategoryDetails                                 []byte
		maxOccupants, minimumLeaseMonths                   int
		furnishingStatus, petPolicyCode                    string
		utilitiesIncluded                                  bool
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
			(SELECT count(*) FROM public.listing_offers WHERE listing_id = l.id AND currency_code = 'THB'),
			(SELECT count(*) FROM public.listing_discovery_channels WHERE listing_id = l.id AND channel_code = $3 AND source = 'manual'),
			(SELECT count(*) FROM public.listing_business_details WHERE listing_id = l.id)
		FROM public.listings l
		LEFT JOIN public.listing_category_details lcd ON lcd.listing_id = l.id
		WHERE l.id = $1 AND l.user_id = $2
	`, listingID, userID, category.discoveryChannel).Scan(
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
		&currencyOffers,
		&discoveryChannels,
		&businessDetails,
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
	if categoryCode != expectedPropertyType || categoryMarker != category.propertyType || categoryAccommodationModel != category.expectedAccommodationModel || submissionMode != "minimum" || priceOnRequest {
		t.Fatalf("category details mismatch: code=%q marker=%q accommodation=%q mode=%q priceOnRequest=%v", categoryCode, categoryMarker, categoryAccommodationModel, submissionMode, priceOnRequest)
	}
	if category.discoveryChannel == "rooms" {
		if maxOccupants != 4 || minimumLeaseMonths != 12 || furnishingStatus != "fully_furnished" || petPolicyCode != "allowed" || !utilitiesIncluded {
			t.Fatalf("monthly-stay core fields mismatch: occupants=%d lease=%d furnishing=%q pets=%q utilities=%v", maxOccupants, minimumLeaseMonths, furnishingStatus, petPolicyCode, utilitiesIncluded)
		}
		assertMonthlyStayDetailsPersisted(t, rawCategoryDetails, category.propertyType)
	}
	if images != 1 || videos != 1 || panoramas != 1 || primaryImages != 1 || videoRoles != 1 || panoramaRoles != 1 {
		t.Fatalf("media mismatch: images=%d videos=%d panoramas=%d primary=%d videoRoles=%d panoramaRoles=%d", images, videos, panoramas, primaryImages, videoRoles, panoramaRoles)
	}
	if spaceTypes != len(category.spaceTypes) || amenities != len(payload.Amenities) || useCases != len(category.useCases) || offers != len(category.offerTypes) || currencyOffers != offers || discoveryChannels != 1 {
		t.Fatalf("relation count mismatch: spaces=%d amenities=%d useCases=%d offers=%d currencyOffers=%d requestedChannel=%d", spaceTypes, amenities, useCases, offers, currencyOffers, discoveryChannels)
	}
	expectedBusinessDetails := 0
	if category.usageType != "residence" || len(category.spaceTypes) > 0 {
		expectedBusinessDetails = 1
	}
	if businessDetails != expectedBusinessDetails {
		t.Fatalf("business details mismatch: got=%d want=%d", businessDetails, expectedBusinessDetails)
	}

	for _, useCase := range category.useCases {
		assertIntegrationRelation(t, db, `SELECT count(*) FROM public.listing_use_cases WHERE listing_id = $1 AND use_case_code = $2`, listingID, useCase)
	}
	for _, offerType := range category.offerTypes {
		assertIntegrationRelation(t, db, `SELECT count(*) FROM public.listing_offers WHERE listing_id = $1 AND offer_type = $2`, listingID, offerType)
	}
	for _, spaceType := range category.spaceTypes {
		assertIntegrationRelation(t, db, `SELECT count(*) FROM public.listing_space_types WHERE listing_id = $1 AND space_type_code = $2`, listingID, spaceType)
	}
	for _, amenityCode := range payload.Amenities {
		assertIntegrationRelation(t, db, `SELECT count(*) FROM public.listing_amenities WHERE listing_id = $1 AND amenity_code = $2`, listingID, amenityCode)
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

func assertIntegrationListingDetailReadable(
	t *testing.T,
	app *fiber.App,
	db *sql.DB,
	listingID int64,
	userID int64,
	category listingCategoryIntegrationCase,
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
	if detail.PropertyTypeCode != expectedPropertyType || detail.Currency != "THB" {
		t.Fatalf("listing detail classification/currency mismatch: type=%q currency=%q", detail.PropertyTypeCode, detail.Currency)
	}
	if category.discoveryChannel == "rooms" {
		if marker, ok := detail.CategoryDetails["integration_category"].(string); !ok || marker != category.propertyType {
			t.Fatalf("listing detail category data mismatch: %#v", detail.CategoryDetails)
		}
	}
	if len(detail.Amenities) != 2 || detail.Amenities[0] != "air_conditioning" || detail.Amenities[1] != "parking" {
		t.Fatalf("listing detail amenities mismatch: %#v", detail.Amenities)
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
		if listing.Currency != "THB" {
			t.Fatalf("owner listing %d currency mismatch: %q", listing.ID, listing.Currency)
		}
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
