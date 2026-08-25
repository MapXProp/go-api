package handlers

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"path/filepath"
	"strconv"
	"strings"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/lib/pq"
)

type createListingRequest struct {
	DiscoveryChannelCode    string         `json:"discovery_channel_code"`
	PropertyGroupCode       string         `json:"property_group_code"`
	PropertyTypeCode        string         `json:"property_type_code"`
	ListingScope            string         `json:"listing_scope"`
	UseCaseCodes            []string       `json:"use_case_codes"`
	OfferTypes              []string       `json:"offer_types"`
	UsageType               string         `json:"usage_type"`
	ListingType             string         `json:"listing_type"`
	Title                   string         `json:"title"`
	Description             string         `json:"description"`
	CustomProjectName       string         `json:"custom_project_name"`
	CustomUnitNumber        string         `json:"custom_unit_number"`
	SalePrice               string         `json:"sale_price"`
	RentPriceMonthly        string         `json:"rent_price_monthly"`
	RentPriceDaily          string         `json:"rent_price_daily"`
	PriceNegotiable         bool           `json:"price_negotiable"`
	UsableAreaSqm           string         `json:"usable_area_sqm"`
	LandAreaSqm             string         `json:"land_area_sqm"`
	BedroomCount            string         `json:"bedroom_count"`
	BathroomCount           string         `json:"bathroom_count"`
	ParkingCount            string         `json:"parking_count"`
	MaxOccupants            string         `json:"max_occupants"`
	FloorNo                 string         `json:"floor_no"`
	TotalFloors             string         `json:"total_floors"`
	FurnishingStatus        string         `json:"furnishing_status"`
	PropertyCondition       string         `json:"property_condition"`
	OccupancyStatus         string         `json:"occupancy_status"`
	MinimumLeaseMonths      string         `json:"minimum_lease_months"`
	PetAllowed              bool           `json:"pet_allowed"`
	PetPolicyCode           string         `json:"pet_policy_code"`
	ContactName             string         `json:"contact_name"`
	ContactPhone            string         `json:"contact_phone"`
	ContactEmail            string         `json:"contact_email"`
	LineID                  string         `json:"line_id"`
	AddressLine1            string         `json:"address_line1"`
	AddressLine2            string         `json:"address_line2"`
	PostalCode              string         `json:"postal_code"`
	Latitude                string         `json:"latitude"`
	Longitude               string         `json:"longitude"`
	BusinessTypeCode        string         `json:"business_type_code"`
	SpaceTypeCode           string         `json:"space_type_code"`
	TargetTenantType        string         `json:"target_tenant_type"`
	PriceUnit               string         `json:"price_unit"`
	KeyMoneyAmount          string         `json:"key_money_amount"`
	ServiceFeeMonthly       string         `json:"service_fee_monthly"`
	UtilitiesIncluded       bool           `json:"utilities_included"`
	IsSublease              bool           `json:"is_sublease"`
	OwnerPermissionRequired bool           `json:"owner_permission_required"`
	AllowedBusinessTypes    []string       `json:"allowed_business_types"`
	Amenities               []string       `json:"amenities"`
	EventBookingPrice       string         `json:"event_booking_price"`
	PriceOnRequest          bool           `json:"price_on_request"`
	CategoryDetails         map[string]any `json:"category_details"`
	MediaURLs               []string       `json:"media_urls"`
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
				is_sublease, owner_permission_required, source_channel, listing_scope
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
				$43, $44, 'web', $45
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

		for index, mediaURL := range req.MediaURLs {
			if _, err := tx.ExecContext(ctx, `
				INSERT INTO public.listing_media (
					listing_id, media_type, source_type, role_code, title, alt_text,
					original_url, file_url, mime_type, sort_order, is_primary, is_active
				) VALUES ($1, 'image', 'user_upload', $2, $3, $4, $5, $5, $6, $7, $8, true)
			`,
				listingID,
				map[bool]string{true: "cover", false: "gallery"}[index == 0],
				req.Title,
				req.Title,
				mediaURL,
				listingMediaMimeType(mediaURL),
				(index+1)*10,
				index == 0,
			); err != nil {
				fmt.Println("Create Listing Media Error:", err)
				return c.Status(500).JSON(fiber.Map{"error": "cannot attach listing images"})
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
					listing_id, offer_type, amount, price_unit,
					minimum_contract_months, service_fee_monthly, is_negotiable
				) VALUES ($1, $2, $3, $4, $5, $6, $7)
				ON CONFLICT (listing_id, offer_type) DO UPDATE SET
					amount = EXCLUDED.amount,
					price_unit = EXCLUDED.price_unit,
					minimum_contract_months = EXCLUDED.minimum_contract_months,
					service_fee_monthly = EXCLUDED.service_fee_monthly,
					is_negotiable = EXCLUDED.is_negotiable,
					updated_at = now()
			`,
				listingID,
				offerType,
				amount,
				priceUnit,
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

func (req *createListingRequest) normalize() {
	req.DiscoveryChannelCode = cleanCode(req.DiscoveryChannelCode, "")
	req.PropertyGroupCode = cleanCode(req.PropertyGroupCode, "residential")
	req.PropertyTypeCode = cleanCode(req.PropertyTypeCode, "condo")
	req.ListingScope = cleanCode(req.ListingScope, "whole_property")
	req.UseCaseCodes = cleanStringSlice(req.UseCaseCodes)
	req.OfferTypes = cleanStringSlice(req.OfferTypes)
	req.UsageType = cleanCode(req.UsageType, "residence")
	req.ListingType = cleanCode(req.ListingType, "rent")
	req.SpaceTypeCode = cleanCode(req.SpaceTypeCode, "")
	req.BusinessTypeCode = cleanCode(req.BusinessTypeCode, "")
	req.PriceUnit = cleanCode(req.PriceUnit, "")
	req.Title = strings.TrimSpace(req.Title)
	req.Description = strings.TrimSpace(req.Description)
	req.CustomProjectName = strings.TrimSpace(req.CustomProjectName)
	req.CustomUnitNumber = strings.TrimSpace(req.CustomUnitNumber)
	req.AddressLine1 = strings.TrimSpace(req.AddressLine1)
	req.AddressLine2 = strings.TrimSpace(req.AddressLine2)
	req.ContactName = strings.TrimSpace(req.ContactName)
	req.ContactPhone = strings.TrimSpace(req.ContactPhone)
	req.ContactEmail = strings.TrimSpace(req.ContactEmail)
	req.LineID = strings.TrimSpace(req.LineID)
	req.FurnishingStatus = cleanCode(req.FurnishingStatus, "")
	req.PropertyCondition = cleanCode(req.PropertyCondition, "")
	req.OccupancyStatus = cleanCode(req.OccupancyStatus, "")
	req.PetPolicyCode = cleanCode(req.PetPolicyCode, "")
	req.TargetTenantType = cleanCode(req.TargetTenantType, "")
	req.AllowedBusinessTypes = cleanStringSlice(req.AllowedBusinessTypes)
	req.Amenities = cleanStringSlice(req.Amenities)
	req.MediaURLs = cleanListingMediaURLs(req.MediaURLs)
	if req.CategoryDetails == nil {
		req.CategoryDetails = map[string]any{}
	}
	req.CategoryDetails["price_on_request"] = req.PriceOnRequest
	req.CategoryDetails["submission_mode"] = "minimum"

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
	if !inSet(req.PropertyTypeCode, "condo", "house", "detached_house", "semi_detached_house", "townhouse", "shophouse", "home_office", "apartment", "dormitory", "rental_room", "flat", "serviced_apartment", "monthly_hotel", "office", "retail_space", "warehouse", "factory", "land") {
		return fmt.Errorf("invalid property type")
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
	return nil
}

func (req createListingRequest) businessAllowsCooking() any {
	for _, item := range req.AllowedBusinessTypes {
		if item == "restaurant" || item == "cafe" || item == "food" || item == "food_service" {
			return true
		}
	}
	return nil
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

func listingMediaMimeType(value string) string {
	switch strings.ToLower(filepath.Ext(value)) {
	case ".png":
		return "image/png"
	case ".webp":
		return "image/webp"
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
