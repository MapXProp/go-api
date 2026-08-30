package handlers

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/lib/pq"
)

type createListingRequest struct {
	DiscoveryChannelCode    string              `json:"discovery_channel_code"`
	PropertyGroupCode       string              `json:"property_group_code"`
	PropertyTypeCode        string              `json:"property_type_code"`
	AccommodationModel      string              `json:"accommodation_model"`
	ListingScope            string              `json:"listing_scope"`
	UseCaseCodes            []string            `json:"use_case_codes"`
	OfferTypes              []string            `json:"offer_types"`
	UsageType               string              `json:"usage_type"`
	ListingType             string              `json:"listing_type"`
	Title                   string              `json:"title"`
	Description             string              `json:"description"`
	CustomProjectName       string              `json:"custom_project_name"`
	CustomUnitNumber        string              `json:"custom_unit_number"`
	SalePrice               string              `json:"sale_price"`
	RentPriceMonthly        string              `json:"rent_price_monthly"`
	RentPriceDaily          string              `json:"rent_price_daily"`
	PriceNegotiable         bool                `json:"price_negotiable"`
	UsableAreaSqm           string              `json:"usable_area_sqm"`
	LandAreaSqm             string              `json:"land_area_sqm"`
	BedroomCount            string              `json:"bedroom_count"`
	BathroomCount           string              `json:"bathroom_count"`
	ParkingCount            string              `json:"parking_count"`
	MaxOccupants            string              `json:"max_occupants"`
	FloorNo                 string              `json:"floor_no"`
	TotalFloors             string              `json:"total_floors"`
	FurnishingStatus        string              `json:"furnishing_status"`
	PropertyCondition       string              `json:"property_condition"`
	OccupancyStatus         string              `json:"occupancy_status"`
	MinimumLeaseMonths      string              `json:"minimum_lease_months"`
	PetAllowed              bool                `json:"pet_allowed"`
	PetPolicyCode           string              `json:"pet_policy_code"`
	ContactName             string              `json:"contact_name"`
	ContactPhone            string              `json:"contact_phone"`
	ContactPhoneSecondary   string              `json:"contact_phone_secondary"`
	ContactEmail            string              `json:"contact_email"`
	LineID                  string              `json:"line_id"`
	InstagramHandle         string              `json:"instagram_handle"`
	AddressLine1            string              `json:"address_line1"`
	AddressLine2            string              `json:"address_line2"`
	Road                    string              `json:"road"`
	ProvinceName            string              `json:"province_name"`
	DistrictName            string              `json:"district_name"`
	SubdistrictName         string              `json:"subdistrict_name"`
	PostalCode              string              `json:"postal_code"`
	Latitude                string              `json:"latitude"`
	Longitude               string              `json:"longitude"`
	BusinessTypeCode        string              `json:"business_type_code"`
	SpaceTypeCode           string              `json:"space_type_code"`
	SpaceTypeCodes          []string            `json:"space_type_codes"`
	TargetTenantType        string              `json:"target_tenant_type"`
	PriceUnit               string              `json:"price_unit"`
	KeyMoneyAmount          string              `json:"key_money_amount"`
	ServiceFeeMonthly       string              `json:"service_fee_monthly"`
	UtilitiesIncluded       bool                `json:"utilities_included"`
	IsSublease              bool                `json:"is_sublease"`
	OwnerPermissionRequired bool                `json:"owner_permission_required"`
	AllowedBusinessTypes    []string            `json:"allowed_business_types"`
	Amenities               []string            `json:"amenities"`
	EventBookingPrice       string              `json:"event_booking_price"`
	PriceOnRequest          bool                `json:"price_on_request"`
	Currency                string              `json:"currency"`
	CategoryDetails         map[string]any      `json:"category_details"`
	MediaURLs               []string            `json:"media_urls"`
	MediaItems              []listingMediaInput `json:"media_items"`
}

type listingMediaInput struct {
	URL       string `json:"url"`
	MediaType string `json:"media_type"`
}

func CreateListing(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		token := accessTokenFromRequest(c)
		if token == "" {
			return c.Status(401).JSON(fiber.Map{"error": "missing authorization token"})
		}

		claims, err := validateAccessToken(token)
		if err != nil {
			return c.Status(401).JSON(fiber.Map{"error": "invalid or expired token"})
		}

		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()

		if err := verifyActiveSession(ctx, db, claims); err != nil {
			return c.Status(401).JSON(fiber.Map{"error": "session revoked or expired"})
		}

		var req createListingRequest
		if err := c.BodyParser(&req); err != nil {
			return c.Status(400).JSON(fiber.Map{"error": "invalid listing payload"})
		}

		req.normalize()
		if err := req.validate(); err != nil {
			return c.Status(400).JSON(fiber.Map{"error": err.Error()})
		}
		if err := req.validateMediaOwnership(claims.UID); err != nil {
			return c.Status(400).JSON(fiber.Map{"error": err.Error()})
		}

		tx, err := db.BeginTx(ctx, nil)
		if err != nil {
			return c.Status(500).JSON(fiber.Map{"error": "cannot start listing transaction"})
		}
		defer tx.Rollback()

		var (
			listingID       int64
			publicListingID string
		)

		err = tx.QueryRowContext(ctx, `
			INSERT INTO public.listings (
				user_id, property_type_code, usage_type, listing_type,
				custom_project_name, custom_unit_number, title, description,
				sale_price, rent_price_monthly, rent_price_daily, price_negotiable,
				usable_area_sqm, land_area_sqm, bedroom_count, bathroom_count,
				parking_count, max_occupants, floor_no, total_floors,
				furnishing_status, property_condition, occupancy_status,
				minimum_lease_months, pet_allowed, pet_policy_code,
				contact_name, contact_phone, contact_email, line_id,
				address_line1, address_line2, postal_code, latitude, longitude,
				listing_status, moderation_status, published_at,
				business_type_code, space_type_code, target_tenant_type, price_unit,
				key_money_amount, service_fee_monthly, utilities_included,
				is_sublease, owner_permission_required, source_channel, listing_scope, accommodation_model,
				contact_phone_secondary, instagram_handle,
				road, province_name, district_name, subdistrict_name
			) VALUES (
				$1, $2, $3, $4,
				$5, $6, $7, $8,
				$9, $10, $11, $12,
				$13, $14, $15, $16,
				$17, $18, $19, $20,
				$21, $22, $23,
				$24, $25, $26,
				$27, $28, $29, $30,
				$31, $32, $33, $34, $35,
				'pending', 'pending', NULL,
				$36, $37, $38, $39,
				$40, $41, $42,
				$43, $44, 'web', $45, $46,
				$47, $48,
				$49, $50, $51, $52
			)
			RETURNING id, public_listing_id::text
		`,
			claims.UID,
			req.PropertyTypeCode,
			req.UsageType,
			req.ListingType,
			listingNullString(req.CustomProjectName),
			listingNullString(req.CustomUnitNumber),
			req.Title,
			listingNullString(req.Description),
			listingNullFloat(req.SalePrice),
			listingNullFloat(req.RentPriceMonthly),
			listingNullFloat(req.RentPriceDaily),
			req.PriceNegotiable,
			listingNullFloat(req.UsableAreaSqm),
			listingNullFloat(req.LandAreaSqm),
			listingNullInt(req.BedroomCount),
			listingNullInt(req.BathroomCount),
			listingNullInt(req.ParkingCount),
			listingNullInt(req.MaxOccupants),
			listingNullInt(req.FloorNo),
			listingNullInt(req.TotalFloors),
			listingNullString(req.FurnishingStatus),
			listingNullString(req.PropertyCondition),
			listingNullString(req.OccupancyStatus),
			listingNullInt(req.MinimumLeaseMonths),
			req.PetAllowed,
			listingNullString(req.PetPolicyCode),
			listingNullString(req.ContactName),
			listingNullString(req.ContactPhone),
			listingNullString(req.ContactEmail),
			listingNullString(req.LineID),
			listingNullString(req.AddressLine1),
			listingNullString(req.AddressLine2),
			listingNullString(req.PostalCode),
			listingNullFloat(req.Latitude),
			listingNullFloat(req.Longitude),
			listingNullString(req.BusinessTypeCode),
			listingNullString(req.SpaceTypeCode),
			listingNullString(req.TargetTenantType),
			listingNullString(req.PriceUnit),
			listingNullFloat(req.KeyMoneyAmount),
			listingNullFloat(req.ServiceFeeMonthly),
			req.UtilitiesIncluded,
			req.IsSublease,
			req.OwnerPermissionRequired,
			req.ListingScope,
			listingNullString(req.AccommodationModel),
			listingNullString(req.ContactPhoneSecondary),
			listingNullString(req.InstagramHandle),
			listingNullString(req.Road),
			listingNullString(req.ProvinceName),
			listingNullString(req.DistrictName),
			listingNullString(req.SubdistrictName),
		).Scan(&listingID, &publicListingID)
		if err != nil {
			fmt.Println("Create Listing Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "cannot create listing"})
		}

		slug := fmt.Sprintf("listing-%d", listingID)
		if _, err := tx.ExecContext(ctx, `
			UPDATE public.listings
			SET slug = $1, updated_at = now()
			WHERE id = $2
		`, slug, listingID); err != nil {
			fmt.Println("Create Listing Slug Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "cannot create listing slug"})
		}

		categoryDetails, err := json.Marshal(req.CategoryDetails)
		if err != nil {
			return c.Status(400).JSON(fiber.Map{"error": "invalid category details"})
		}
		if _, err := tx.ExecContext(ctx, `
			INSERT INTO public.listing_category_details (
				listing_id, category_code, schema_version, details, is_minimum_submission
			) VALUES ($1, $2, 1, $3::jsonb, true)
			ON CONFLICT (listing_id) DO UPDATE SET
				category_code = EXCLUDED.category_code,
				schema_version = EXCLUDED.schema_version,
				details = EXCLUDED.details,
				is_minimum_submission = EXCLUDED.is_minimum_submission,
				updated_at = now()
		`, listingID, req.PropertyTypeCode, string(categoryDetails)); err != nil {
			fmt.Println("Create Listing Category Detail Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "cannot create category details"})
		}

		for index, spaceTypeCode := range req.SpaceTypeCodes {
			if _, err := tx.ExecContext(ctx, `
				INSERT INTO public.listing_space_types (
					listing_id, space_type_code, is_primary, sort_order
				) VALUES ($1, $2, $3, $4)
				ON CONFLICT (listing_id, space_type_code) DO UPDATE SET
					is_primary = EXCLUDED.is_primary,
					sort_order = EXCLUDED.sort_order,
					updated_at = now()
			`, listingID, spaceTypeCode, index == 0, index); err != nil {
				fmt.Println("Create Listing Space Type Error:", err)
				return c.Status(500).JSON(fiber.Map{"error": "cannot create listing space types"})
			}
		}

		for _, amenityCode := range req.Amenities {
			if _, err := tx.ExecContext(ctx, `
				INSERT INTO public.listing_amenities (listing_id, amenity_code)
				VALUES ($1, $2)
				ON CONFLICT (listing_id, amenity_code) DO NOTHING
			`, listingID, amenityCode); err != nil {
				fmt.Println("Create Listing Amenity Error:", err)
				return c.Status(500).JSON(fiber.Map{"error": "cannot create listing amenities"})
			}
		}

		imageIndex := 0
		for index, media := range req.MediaItems {
			roleCode := listingMediaRole(media.MediaType, imageIndex)
			if media.MediaType == "image" {
				imageIndex++
			}
			if _, err := tx.ExecContext(ctx, `
				INSERT INTO public.listing_media (
					listing_id, media_type, source_type, role_code, title, alt_text,
					original_url, file_url, mime_type, sort_order, is_primary, is_active
				) VALUES ($1, $2, 'user_upload', $3, $4, $5, $6, $6, $7, $8, $9, true)
			`,
				listingID,
				media.MediaType,
				roleCode,
				req.Title,
				req.Title,
				media.URL,
				listingMediaMimeType(media.URL),
				(index+1)*10,
				media.MediaType == "image" && roleCode == "cover",
			); err != nil {
				fmt.Println("Create Listing Media Error:", err)
				return c.Status(500).JSON(fiber.Map{"error": "cannot attach listing media"})
			}
		}

		for _, useCaseCode := range req.UseCaseCodes {
			if _, err := tx.ExecContext(ctx, `
				INSERT INTO public.listing_use_cases (listing_id, use_case_code)
				VALUES ($1, $2)
				ON CONFLICT (listing_id, use_case_code) DO NOTHING
			`, listingID, useCaseCode); err != nil {
				fmt.Println("Create Listing Use Case Error:", err)
				return c.Status(500).JSON(fiber.Map{"error": "cannot create listing use cases"})
			}
		}

		for _, offerType := range req.OfferTypes {
			amount, priceUnit := req.offerAmount(offerType)
			if _, err := tx.ExecContext(ctx, `
				INSERT INTO public.listing_offers (
					listing_id, offer_type, amount, price_unit, currency_code,
					minimum_contract_months, service_fee_monthly, is_negotiable
				) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
				ON CONFLICT (listing_id, offer_type) DO UPDATE SET
					amount = EXCLUDED.amount,
					price_unit = EXCLUDED.price_unit,
					currency_code = EXCLUDED.currency_code,
					minimum_contract_months = EXCLUDED.minimum_contract_months,
					service_fee_monthly = EXCLUDED.service_fee_monthly,
					is_negotiable = EXCLUDED.is_negotiable,
					updated_at = now()
			`,
				listingID,
				offerType,
				amount,
				priceUnit,
				req.Currency,
				listingNullInt(req.MinimumLeaseMonths),
				listingNullFloat(req.ServiceFeeMonthly),
				req.PriceNegotiable,
			); err != nil {
				fmt.Println("Create Listing Offer Error:", err)
				return c.Status(500).JSON(fiber.Map{"error": "cannot create listing offers"})
			}
		}

		if _, err := tx.ExecContext(ctx, `
			INSERT INTO public.listing_discovery_channels (listing_id, channel_code, source)
			SELECT
				$1,
				dcpt.channel_code,
				CASE WHEN dcpt.channel_code = $4 THEN 'manual' ELSE 'derived' END
			FROM public.discovery_channel_property_types dcpt
			WHERE dcpt.property_type_code = $2
			  AND (
				cardinality(dcpt.allowed_offer_types) = 0
				OR dcpt.allowed_offer_types && $3::text[]
			  )
			ON CONFLICT (listing_id, channel_code) DO UPDATE SET
				source = CASE
					WHEN public.listing_discovery_channels.source = 'editorial' THEN 'editorial'
					WHEN EXCLUDED.source = 'manual' THEN 'manual'
					ELSE public.listing_discovery_channels.source
				END,
				updated_at = now()
		`, listingID, req.PropertyTypeCode, pq.Array(req.OfferTypes), req.DiscoveryChannelCode); err != nil {
			fmt.Println("Create Listing Discovery Channel Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "cannot assign listing discovery channels"})
		}

		if req.UsageType != "residence" || req.SpaceTypeCode != "" || len(req.AllowedBusinessTypes) > 0 {
			if _, err := tx.ExecContext(ctx, `
				INSERT INTO public.listing_business_details (
					listing_id, venue_type_code, allowed_business_types,
					cooking_allowed, key_money_amount, service_fee_monthly,
					minimum_contract_months, deposit_amount, advance_rent_amount
				) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
				ON CONFLICT (listing_id) DO UPDATE SET
					venue_type_code = EXCLUDED.venue_type_code,
					allowed_business_types = EXCLUDED.allowed_business_types,
					cooking_allowed = EXCLUDED.cooking_allowed,
					key_money_amount = EXCLUDED.key_money_amount,
					service_fee_monthly = EXCLUDED.service_fee_monthly,
					minimum_contract_months = EXCLUDED.minimum_contract_months,
					deposit_amount = EXCLUDED.deposit_amount,
					advance_rent_amount = EXCLUDED.advance_rent_amount
			`,
				listingID,
				listingNullString(req.SpaceTypeCode),
				pq.Array(req.AllowedBusinessTypes),
				req.businessAllowsCooking(),
				listingNullFloat(req.KeyMoneyAmount),
				listingNullFloat(req.ServiceFeeMonthly),
				listingNullInt(req.MinimumLeaseMonths),
				nil,
				nil,
			); err != nil {
				fmt.Println("Create Listing Business Detail Error:", err)
				return c.Status(500).JSON(fiber.Map{"error": "cannot create business details"})
			}
		}

		if err := verifyCreatedListing(ctx, tx, listingID, req); err != nil {
			fmt.Println("Create Listing Verification Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "cannot verify saved listing"})
		}

		if err := tx.Commit(); err != nil {
			return c.Status(500).JSON(fiber.Map{"error": "cannot finish listing transaction"})
		}

		return c.Status(201).JSON(fiber.Map{
			"success":           true,
			"id":                listingID,
			"public_listing_id": publicListingID,
			"slug":              slug,
			"status":            "pending",
		})
	}
}

func verifyCreatedListing(ctx context.Context, tx *sql.Tx, listingID int64, req createListingRequest) error {
	var (
		secondaryPhone string
		instagram      string
		province       string
		district       string
		subdistrict    string
		mediaCount     int
		spaceTypeCount int
		amenityCount   int
		currencyCount  int
		accommodation  string
		hasLatitude    bool
		hasLongitude   bool
	)
	err := tx.QueryRowContext(ctx, `
		SELECT
			COALESCE(contact_phone_secondary, ''),
			COALESCE(instagram_handle, ''),
			COALESCE(province_name, ''),
			COALESCE(district_name, ''),
			COALESCE(subdistrict_name, ''),
			COALESCE(accommodation_model, ''),
			latitude IS NOT NULL,
			longitude IS NOT NULL,
			(SELECT count(*) FROM public.listing_media WHERE listing_id = $1 AND is_active = true),
			(SELECT count(*) FROM public.listing_space_types WHERE listing_id = $1),
			(SELECT count(*) FROM public.listing_amenities WHERE listing_id = $1),
			(SELECT count(*) FROM public.listing_offers WHERE listing_id = $1 AND currency_code = $2)
		FROM public.listings
		WHERE id = $1
	`, listingID, req.Currency).Scan(
		&secondaryPhone,
		&instagram,
		&province,
		&district,
		&subdistrict,
		&accommodation,
		&hasLatitude,
		&hasLongitude,
		&mediaCount,
		&spaceTypeCount,
		&amenityCount,
		&currencyCount,
	)
	if err != nil {
		return err
	}
	if secondaryPhone != req.ContactPhoneSecondary || instagram != req.InstagramHandle {
		return fmt.Errorf("contact channels were not persisted")
	}
	if province != req.ProvinceName || district != req.DistrictName || subdistrict != req.SubdistrictName {
		return fmt.Errorf("structured address was not persisted")
	}
	if accommodation != req.AccommodationModel {
		return fmt.Errorf("accommodation model was not persisted")
	}
	if mediaCount != len(req.MediaItems) {
		return fmt.Errorf("media count mismatch: got %d want %d", mediaCount, len(req.MediaItems))
	}
	if spaceTypeCount != len(req.SpaceTypeCodes) {
		return fmt.Errorf("space type count mismatch: got %d want %d", spaceTypeCount, len(req.SpaceTypeCodes))
	}
	if amenityCount != len(req.Amenities) {
		return fmt.Errorf("amenity count mismatch: got %d want %d", amenityCount, len(req.Amenities))
	}
	if currencyCount != len(req.OfferTypes) {
		return fmt.Errorf("offer currency count mismatch: got %d want %d", currencyCount, len(req.OfferTypes))
	}
	if hasLatitude != (strings.TrimSpace(req.Latitude) != "") || hasLongitude != (strings.TrimSpace(req.Longitude) != "") {
		return fmt.Errorf("listing coordinates were not persisted")
	}
	return nil
}

func (req *createListingRequest) normalize() {
	req.DiscoveryChannelCode = cleanCode(req.DiscoveryChannelCode, "")
	req.PropertyGroupCode = cleanCode(req.PropertyGroupCode, "residential")
	req.PropertyTypeCode = cleanCode(req.PropertyTypeCode, "condo")
	req.AccommodationModel = cleanCode(req.AccommodationModel, "")
	switch req.PropertyTypeCode {
	case "serviced_apartment":
		req.PropertyTypeCode = "apartment"
		req.AccommodationModel = "serviced"
	}
	if req.PropertyTypeCode == "apartment" {
		if req.AccommodationModel == "" {
			req.AccommodationModel = "standard"
		}
	} else {
		req.AccommodationModel = ""
	}
	req.ListingScope = cleanCode(req.ListingScope, "whole_property")
	req.UseCaseCodes = cleanStringSlice(req.UseCaseCodes)
	req.OfferTypes = cleanStringSlice(req.OfferTypes)
	req.UsageType = cleanCode(req.UsageType, "residence")
	req.ListingType = cleanCode(req.ListingType, "rent")
	req.SpaceTypeCode = cleanCode(req.SpaceTypeCode, "")
	req.SpaceTypeCodes = cleanStringSlice(req.SpaceTypeCodes)
	if req.SpaceTypeCode == "" && len(req.SpaceTypeCodes) > 0 {
		req.SpaceTypeCode = req.SpaceTypeCodes[0]
	}
	if req.SpaceTypeCode != "" {
		orderedSpaceTypes := []string{req.SpaceTypeCode}
		for _, spaceTypeCode := range req.SpaceTypeCodes {
			if spaceTypeCode != req.SpaceTypeCode {
				orderedSpaceTypes = append(orderedSpaceTypes, spaceTypeCode)
			}
		}
		req.SpaceTypeCodes = orderedSpaceTypes
	}
	req.BusinessTypeCode = cleanCode(req.BusinessTypeCode, "")
	req.PriceUnit = cleanCode(req.PriceUnit, "")
	req.Title = strings.TrimSpace(req.Title)
	req.Description = strings.TrimSpace(req.Description)
	req.CustomProjectName = strings.TrimSpace(req.CustomProjectName)
	req.CustomUnitNumber = strings.TrimSpace(req.CustomUnitNumber)
	req.AddressLine1 = strings.TrimSpace(req.AddressLine1)
	req.AddressLine2 = strings.TrimSpace(req.AddressLine2)
	req.Road = strings.TrimSpace(req.Road)
	req.ProvinceName = strings.TrimSpace(req.ProvinceName)
	req.DistrictName = strings.TrimSpace(req.DistrictName)
	req.SubdistrictName = strings.TrimSpace(req.SubdistrictName)
	req.ContactName = strings.TrimSpace(req.ContactName)
	req.ContactPhone = strings.TrimSpace(req.ContactPhone)
	req.ContactPhoneSecondary = strings.TrimSpace(req.ContactPhoneSecondary)
	req.ContactEmail = strings.TrimSpace(req.ContactEmail)
	req.LineID = strings.TrimSpace(req.LineID)
	req.InstagramHandle = normalizeInstagramHandle(req.InstagramHandle)
	req.FurnishingStatus = cleanCode(req.FurnishingStatus, "")
	req.PropertyCondition = cleanCode(req.PropertyCondition, "")
	req.OccupancyStatus = cleanCode(req.OccupancyStatus, "")
	req.PetPolicyCode = cleanCode(req.PetPolicyCode, "")
	req.TargetTenantType = cleanCode(req.TargetTenantType, "")
	req.AllowedBusinessTypes = cleanStringSlice(req.AllowedBusinessTypes)
	req.Amenities = cleanStringSlice(req.Amenities)
	req.Currency = normalizeListingCurrency(req.Currency)
	req.MediaURLs = cleanListingMediaURLs(req.MediaURLs)
	req.MediaItems = cleanListingMediaItems(req.MediaItems)
	if len(req.MediaItems) == 0 {
		for _, mediaURL := range req.MediaURLs {
			req.MediaItems = append(req.MediaItems, listingMediaInput{URL: mediaURL, MediaType: "image"})
		}
	}
	if req.CategoryDetails == nil {
		req.CategoryDetails = map[string]any{}
	}
	req.CategoryDetails["price_on_request"] = req.PriceOnRequest
	req.CategoryDetails["submission_mode"] = "minimum"
	if req.PropertyTypeCode == "apartment" {
		req.CategoryDetails["accommodation_model"] = req.AccommodationModel
	} else {
		delete(req.CategoryDetails, "accommodation_model")
	}

	if len(req.UseCaseCodes) == 0 {
		switch req.UsageType {
		case "business":
			req.UseCaseCodes = []string{"office"}
		case "mixed":
			req.UseCaseCodes = []string{"residential", "office"}
		default:
			req.UseCaseCodes = []string{"residential"}
		}
	}
	if len(req.OfferTypes) == 0 {
		if req.ListingType == "sale_and_rent" {
			req.OfferTypes = []string{"sale", "rent"}
		} else {
			req.OfferTypes = []string{req.ListingType}
		}
	}
}

func (req createListingRequest) validate() error {
	if req.Title == "" {
		return fmt.Errorf("listing title is required")
	}
	if !inSet(req.PropertyGroupCode, "residential", "mixed_use", "commercial", "land") {
		return fmt.Errorf("invalid property group")
	}
	if req.DiscoveryChannelCode != "" && !inSet(req.DiscoveryChannelCode, "homes", "rooms", "business") {
		return fmt.Errorf("invalid discovery channel")
	}
	if !inSet(req.PropertyTypeCode, "condo", "house", "detached_house", "semi_detached_house", "townhouse", "shophouse", "home_office", "apartment", "dormitory", "rental_room", "flat", "monthly_hotel", "office", "retail_space", "warehouse", "factory", "land") {
		return fmt.Errorf("invalid property type")
	}
	if req.PropertyTypeCode == "apartment" && req.AccommodationModel != "" && !inSet(req.AccommodationModel, "standard", "serviced") {
		return fmt.Errorf("invalid accommodation model")
	}
	if req.PropertyTypeCode != "apartment" && req.AccommodationModel != "" {
		return fmt.Errorf("accommodation model is only valid for apartment listings")
	}
	if !inSet(req.ListingScope, "single_unit", "whole_property", "multi_unit", "land_plot", "space_slot") {
		return fmt.Errorf("invalid listing scope")
	}
	if !inSet(req.UsageType, "residence", "business", "mixed") {
		return fmt.Errorf("invalid usage type")
	}
	if !inSet(req.ListingType, "sale", "rent", "sale_and_rent", "lease", "sublease", "business_transfer", "event_booking") {
		return fmt.Errorf("invalid listing type")
	}
	for _, useCaseCode := range req.UseCaseCodes {
		if !inSet(useCaseCode, "residential", "office", "retail", "food_service", "storage", "industrial", "hospitality", "agriculture") {
			return fmt.Errorf("invalid use case")
		}
	}
	for _, offerType := range req.OfferTypes {
		if !inSet(offerType, "sale", "rent", "sublease", "business_transfer", "event_booking") {
			return fmt.Errorf("invalid offer type")
		}
	}
	if req.Currency != "" && !validListingCurrency(req.Currency) {
		return fmt.Errorf("invalid currency")
	}
	for _, amenityCode := range req.Amenities {
		if !inSet(
			amenityCode,
			"air_conditioning",
			"parking",
			"elevator",
			"security",
			"swimming_pool",
			"fitness",
			"wifi",
			"pet_friendly",
		) {
			return fmt.Errorf("invalid amenity")
		}
	}
	if len(req.SpaceTypeCodes) > 2 {
		return fmt.Errorf("a listing can have at most two space types")
	}
	for _, spaceTypeCode := range req.SpaceTypeCodes {
		if !inSet(
			spaceTypeCode,
			"standalone_shop",
			"market_stall",
			"mall_kiosk",
			"mall_shop",
			"food_court_counter",
			"school_canteen",
			"office_canteen",
			"dormitory_shop",
			"street_food_space",
			"shophouse_ground_floor",
			"event_booth",
		) {
			return fmt.Errorf("invalid space type")
		}
	}
	if len(req.SpaceTypeCodes) > 0 && req.PropertyTypeCode != "retail_space" {
		return fmt.Errorf("space types are only valid for retail space listings")
	}
	if req.ProvinceName == "" {
		return fmt.Errorf("province is required")
	}
	if !validListingCoordinates(req.Latitude, req.Longitude) {
		return fmt.Errorf("valid latitude and longitude are required")
	}
	if req.InstagramHandle != "" && !isValidInstagramHandle(req.InstagramHandle) {
		return fmt.Errorf("invalid Instagram username")
	}
	mediaCounts := map[string]int{}
	for _, media := range req.MediaItems {
		mediaCounts[media.MediaType]++
	}
	if mediaCounts["image"] > 12 || mediaCounts["video"] > 4 || mediaCounts["360"] > 4 {
		return fmt.Errorf("listing media limit exceeded")
	}
	return nil
}

func (req createListingRequest) validateMediaOwnership(userID int64) error {
	ownedPrefix := fmt.Sprintf("/apix/listing-media/files/%d/", userID)
	for _, media := range req.MediaItems {
		if !strings.HasPrefix(media.URL, ownedPrefix) {
			return fmt.Errorf("listing media must belong to the authenticated user")
		}
		filename := strings.TrimPrefix(media.URL, ownedPrefix)
		if filename == "" || filepath.Base(filename) != filename {
			return fmt.Errorf("invalid listing media URL")
		}
		if _, err := os.Stat(filepath.Join(listingMediaRoot(), strconv.FormatInt(userID, 10), filename)); err != nil {
			return fmt.Errorf("uploaded listing media was not found")
		}
		extension := strings.ToLower(filepath.Ext(media.URL))
		validExtension := false
		switch media.MediaType {
		case "image", "360":
			validExtension = inSet(extension, ".jpg", ".png", ".webp")
		case "video":
			validExtension = inSet(extension, ".mp4", ".webm", ".mov")
		}
		if !validExtension {
			return fmt.Errorf("listing media type does not match its uploaded file")
		}
	}
	return nil
}

func (req createListingRequest) businessAllowsCooking() bool {
	for _, item := range req.AllowedBusinessTypes {
		if item == "restaurant" || item == "cafe" || item == "food" || item == "food_service" {
			return true
		}
	}
	return false
}

func (req createListingRequest) offerAmount(offerType string) (any, string) {
	switch offerType {
	case "sale":
		return listingNullFloat(req.SalePrice), "total"
	case "rent", "sublease":
		return listingNullFloat(req.RentPriceMonthly), "month"
	case "business_transfer":
		return listingNullFloat(req.KeyMoneyAmount), "total"
	case "event_booking":
		priceUnit := req.PriceUnit
		if priceUnit == "" {
			priceUnit = "event_round"
		}
		return listingNullFloat(req.EventBookingPrice), priceUnit
	default:
		return nil, "total"
	}
}

func cleanCode(value string, fallback string) string {
	value = strings.ToLower(strings.TrimSpace(value))
	value = strings.ReplaceAll(value, " ", "_")
	value = strings.ReplaceAll(value, "-", "_")
	if value == "" {
		return fallback
	}
	return value
}

func cleanStringSlice(values []string) []string {
	cleaned := make([]string, 0, len(values))
	seen := map[string]bool{}
	for _, value := range values {
		value = cleanCode(value, "")
		if value == "" || seen[value] {
			continue
		}
		seen[value] = true
		cleaned = append(cleaned, value)
	}
	return cleaned
}

func cleanListingMediaURLs(values []string) []string {
	cleaned := make([]string, 0, len(values))
	seen := map[string]bool{}
	for _, value := range values {
		value = strings.TrimSpace(value)
		if !strings.HasPrefix(value, "/apix/listing-media/files/") || seen[value] {
			continue
		}
		seen[value] = true
		cleaned = append(cleaned, value)
		if len(cleaned) == 12 {
			break
		}
	}
	return cleaned
}

func cleanListingMediaItems(values []listingMediaInput) []listingMediaInput {
	cleaned := make([]listingMediaInput, 0, len(values))
	seen := map[string]bool{}
	for _, value := range values {
		mediaURL := strings.TrimSpace(value.URL)
		mediaType := cleanCode(value.MediaType, "")
		if !strings.HasPrefix(mediaURL, "/apix/listing-media/files/") || seen[mediaURL] {
			continue
		}
		if !inSet(mediaType, "image", "video", "360") {
			continue
		}
		seen[mediaURL] = true
		cleaned = append(cleaned, listingMediaInput{URL: mediaURL, MediaType: mediaType})
	}
	return cleaned
}

func normalizeInstagramHandle(value string) string {
	value = strings.TrimSpace(value)
	value = strings.TrimPrefix(value, "@")
	value = strings.TrimPrefix(value, "https://www.instagram.com/")
	value = strings.TrimPrefix(value, "https://instagram.com/")
	value = strings.Trim(value, "/")
	return strings.ToLower(value)
}

func isValidInstagramHandle(value string) bool {
	if len(value) > 30 {
		return false
	}
	for _, character := range value {
		if (character >= 'a' && character <= 'z') || (character >= '0' && character <= '9') || character == '.' || character == '_' {
			continue
		}
		return false
	}
	return value != ""
}

func normalizeListingCurrency(value string) string {
	value = strings.ToUpper(strings.TrimSpace(value))
	if value == "" {
		return "THB"
	}
	return value
}

func validListingCurrency(value string) bool {
	if len(value) != 3 {
		return false
	}
	for _, character := range value {
		if character < 'A' || character > 'Z' {
			return false
		}
	}
	return true
}

func validListingCoordinates(latitudeValue string, longitudeValue string) bool {
	latitude, latitudeErr := strconv.ParseFloat(strings.TrimSpace(latitudeValue), 64)
	longitude, longitudeErr := strconv.ParseFloat(strings.TrimSpace(longitudeValue), 64)
	return latitudeErr == nil && longitudeErr == nil && latitude >= -90 && latitude <= 90 && longitude >= -180 && longitude <= 180
}

func listingMediaRole(mediaType string, index int) string {
	switch mediaType {
	case "video":
		return "property_video"
	case "360":
		return "panorama"
	default:
		if index == 0 {
			return "cover"
		}
		return "gallery"
	}
}

func listingMediaMimeType(value string) string {
	switch strings.ToLower(filepath.Ext(value)) {
	case ".png":
		return "image/png"
	case ".webp":
		return "image/webp"
	case ".mp4":
		return "video/mp4"
	case ".webm":
		return "video/webm"
	case ".mov":
		return "video/quicktime"
	default:
		return "image/jpeg"
	}
}

func inSet(value string, allowed ...string) bool {
	for _, item := range allowed {
		if value == item {
			return true
		}
	}
	return false
}

func listingNullString(value string) any {
	value = strings.TrimSpace(value)
	if value == "" {
		return nil
	}
	return value
}

func listingNullFloat(value string) any {
	value = strings.TrimSpace(strings.ReplaceAll(value, ",", ""))
	if value == "" {
		return nil
	}
	parsed, err := strconv.ParseFloat(value, 64)
	if err != nil {
		return nil
	}
	return parsed
}

func listingNullInt(value string) any {
	value = strings.TrimSpace(strings.ReplaceAll(value, ",", ""))
	if value == "" {
		return nil
	}
	parsed, err := strconv.Atoi(value)
	if err != nil {
		return nil
	}
	return parsed
}
