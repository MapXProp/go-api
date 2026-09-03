package handlers

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"strconv"
	"strings"
	"time"

	"github.com/gofiber/fiber/v2"
)

// GetMyListingEditDraft returns the owner's listing in the same field shape
// used by the add-listing form. It deliberately requires an authenticated
// owner and also works for listings that are not publicly visible.
func GetMyListingEditDraft(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, err := authenticatedAccountRequest(c, db)
		if err != nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": err.Error()})
		}
		defer cancel()

		publicListingID := strings.TrimSpace(c.Params("publicListingID"))
		if publicListingID == "" || len(publicListingID) > 128 {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid listing ID"})
		}

		var (
			listingID         int64
			req               createListingRequest
			rawDetails        []byte
			priceOnRequest    bool
			contactRole       string
			contactAuthority  string
			contactOrg        string
			contactOrgNo      string
			submissionKey     string
			propertyGroupCode string
		)

		err = db.QueryRowContext(ctx, `
			SELECT
				l.id,
				COALESCE(l.submission_key, ''),
				COALESCE(pt.group_code, 'residential'),
				l.property_type_code,
				COALESCE(l.accommodation_model, ''),
				l.listing_scope,
				l.usage_type,
				l.listing_type,
				l.title,
				COALESCE(l.description, ''),
				COALESCE(l.custom_project_name, ''),
				COALESCE(l.custom_unit_number, ''),
				COALESCE(l.sale_price::text, ''),
				COALESCE(l.rent_price_monthly::text, ''),
				COALESCE(l.rent_price_daily::text, ''),
				l.price_negotiable,
				COALESCE(l.usable_area_sqm::text, ''),
				COALESCE(l.land_area_sqm::text, ''),
				COALESCE(l.bedroom_count::text, ''),
				COALESCE(l.bathroom_count::text, ''),
				COALESCE(l.parking_count::text, ''),
				COALESCE(l.max_occupants::text, ''),
				COALESCE(l.floor_no::text, ''),
				COALESCE(l.total_floors::text, ''),
				COALESCE(l.furnishing_status, ''),
				COALESCE(l.property_condition, ''),
				COALESCE(l.occupancy_status, ''),
				COALESCE(l.minimum_lease_months::text, ''),
				l.pet_allowed,
				COALESCE(l.pet_policy_code, ''),
				l.utilities_included,
				COALESCE(l.contact_name, ''),
				COALESCE(l.contact_phone, ''),
				COALESCE(l.contact_phone_secondary, ''),
				COALESCE(l.contact_email, ''),
				COALESCE(l.line_id, ''),
				COALESCE(l.instagram_handle, ''),
				COALESCE(lcp.role_code, ''),
				COALESCE(lcp.authority_source_code, ''),
				COALESCE(lcp.organization_name, ''),
				COALESCE(lcp.organization_registration_no, ''),
				COALESCE(l.address_line1, ''),
				COALESCE(l.address_line2, ''),
				COALESCE(l.road, ''),
				COALESCE(l.province_name, ''),
				COALESCE(l.district_name, ''),
				COALESCE(l.subdistrict_name, ''),
				COALESCE(l.postal_code, ''),
				COALESCE(l.latitude::text, ''),
				COALESCE(l.longitude::text, ''),
				COALESCE(l.business_type_code, ''),
				COALESCE(l.space_type_code, ''),
				COALESCE(l.target_tenant_type, ''),
				COALESCE(l.price_unit, ''),
				COALESCE(l.key_money_amount::text, ''),
				COALESCE(l.service_fee_monthly::text, ''),
				COALESCE(lcd.details, '{}'::jsonb),
				COALESCE((lcd.details->>'price_on_request')::boolean, false)
			FROM public.listings l
			LEFT JOIN public.property_types pt ON pt.code = l.property_type_code
			LEFT JOIN public.listing_category_details lcd ON lcd.listing_id = l.id
			LEFT JOIN public.listing_contact_profiles lcp ON lcp.listing_id = l.id
			WHERE l.public_listing_id::text = $1
				AND l.user_id = $2
				AND l.deleted_at IS NULL
			LIMIT 1
		`, publicListingID, claims.UID).Scan(
			&listingID,
			&submissionKey,
			&propertyGroupCode,
			&req.PropertyTypeCode,
			&req.AccommodationModel,
			&req.ListingScope,
			&req.UsageType,
			&req.ListingType,
			&req.Title,
			&req.Description,
			&req.CustomProjectName,
			&req.CustomUnitNumber,
			&req.SalePrice,
			&req.RentPriceMonthly,
			&req.RentPriceDaily,
			&req.PriceNegotiable,
			&req.UsableAreaSqm,
			&req.LandAreaSqm,
			&req.BedroomCount,
			&req.BathroomCount,
			&req.ParkingCount,
			&req.MaxOccupants,
			&req.FloorNo,
			&req.TotalFloors,
			&req.FurnishingStatus,
			&req.PropertyCondition,
			&req.OccupancyStatus,
			&req.MinimumLeaseMonths,
			&req.PetAllowed,
			&req.PetPolicyCode,
			&req.UtilitiesIncluded,
			&req.ContactName,
			&req.ContactPhone,
			&req.ContactPhoneSecondary,
			&req.ContactEmail,
			&req.LineID,
			&req.InstagramHandle,
			&contactRole,
			&contactAuthority,
			&contactOrg,
			&contactOrgNo,
			&req.AddressLine1,
			&req.AddressLine2,
			&req.Road,
			&req.ProvinceName,
			&req.DistrictName,
			&req.SubdistrictName,
			&req.PostalCode,
			&req.Latitude,
			&req.Longitude,
			&req.BusinessTypeCode,
			&req.SpaceTypeCode,
			&req.TargetTenantType,
			&req.PriceUnit,
			&req.KeyMoneyAmount,
			&req.ServiceFeeMonthly,
			&rawDetails,
			&priceOnRequest,
		)
		if err == sql.ErrNoRows {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{"error": "listing not found"})
		}
		if err != nil {
			fmt.Println("Read listing edit draft error:", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot load listing for editing"})
		}

		draft := make(map[string]any)
		putDraftText(draft, "editingPublicListingId", publicListingID)
		putDraftText(draft, "submissionKey", submissionKey)
		putDraftText(draft, "draftOwnerPublicUserId", claims.Sub)
		putDraftText(draft, "property_group_code", propertyGroupCode)
		putDraftText(draft, "property_type_code", req.PropertyTypeCode)
		putDraftText(draft, "accommodation_model", req.AccommodationModel)
		putDraftText(draft, "listing_scope", req.ListingScope)
		putDraftText(draft, "usage_type", req.UsageType)
		putDraftText(draft, "listing_type", req.ListingType)
		putDraftText(draft, "listingTitle", req.Title)
		putDraftText(draft, "listingDescription", req.Description)
		putDraftText(draft, "placeName", req.CustomProjectName)
		putDraftText(draft, "room-number", req.CustomUnitNumber)
		putDraftText(draft, "salePrice", req.SalePrice)
		putDraftText(draft, "rentPriceMonthly", req.RentPriceMonthly)
		putDraftText(draft, "rentPriceDaily", req.RentPriceDaily)
		putDraftBool(draft, "priceNegotiable", req.PriceNegotiable)
		putDraftBool(draft, "priceOnRequest", priceOnRequest)
		putDraftText(draft, "usableAreaSqm", req.UsableAreaSqm)
		putDraftText(draft, "landAreaSqm", req.LandAreaSqm)
		putDraftText(draft, "Bedroom", req.BedroomCount)
		putDraftText(draft, "Bathroom", req.BathroomCount)
		putDraftText(draft, "Parking", req.ParkingCount)
		putDraftText(draft, "Guests", req.MaxOccupants)
		putDraftText(draft, "floorNo", req.FloorNo)
		putDraftText(draft, "totalFloors", req.TotalFloors)
		putDraftText(draft, "furnishingStatus", req.FurnishingStatus)
		putDraftText(draft, "propertyCondition", req.PropertyCondition)
		putDraftText(draft, "occupancyStatus", req.OccupancyStatus)
		putDraftText(draft, "minimumLeaseMonths", req.MinimumLeaseMonths)
		putDraftText(draft, "Pets", req.PetPolicyCode)
		putDraftBool(draft, "utilitiesIncluded", req.UtilitiesIncluded)
		putDraftText(draft, "contactName", req.ContactName)
		putDraftText(draft, "contactPhone", req.ContactPhone)
		putDraftText(draft, "contactPhoneSecondary", req.ContactPhoneSecondary)
		putDraftText(draft, "contactEmail", req.ContactEmail)
		putDraftText(draft, "lineId", req.LineID)
		putDraftText(draft, "instagramHandle", req.InstagramHandle)
		putDraftText(draft, "contactRoleCode", contactRole)
		putDraftText(draft, "contactAuthorityCode", contactAuthority)
		putDraftText(draft, "contactOrganizationName", contactOrg)
		putDraftText(draft, "contactOrganizationRegistrationNo", contactOrgNo)
		putDraftText(draft, "Street", req.AddressLine1)
		putDraftText(draft, "subdistrict", req.SubdistrictName)
		putDraftText(draft, "city", req.DistrictName)
		putDraftText(draft, "state", req.ProvinceName)
		putDraftText(draft, "Postal", req.PostalCode)
		putDraftText(draft, "latMapPosition", req.Latitude)
		putDraftText(draft, "lngMapPosition", req.Longitude)
		putDraftText(draft, "business_type_code", req.BusinessTypeCode)
		putDraftText(draft, "space_type_code", req.SpaceTypeCode)
		putDraftText(draft, "targetTenantType", req.TargetTenantType)
		putDraftText(draft, "price_unit", req.PriceUnit)
		putDraftText(draft, "keyMoneyAmount", req.KeyMoneyAmount)
		putDraftText(draft, "serviceFeeMonthly", req.ServiceFeeMonthly)

		if len(rawDetails) > 0 {
			var details map[string]any
			if err := json.Unmarshal(rawDetails, &details); err != nil {
				return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot load listing details"})
			}
			copyCategoryDetailsToDraft(draft, details)
		}

		discoveryChannels, err := listingEditStrings(ctx, db, `
			SELECT channel_code FROM public.listing_discovery_channels
			WHERE listing_id = $1 ORDER BY is_featured DESC, channel_code
		`, listingID)
		if err != nil {
			return listingEditReadError(c, err)
		}
		if len(discoveryChannels) > 0 {
			putDraftText(draft, "discovery_channel_code", discoveryChannels[0])
		}

		useCases, err := listingEditStrings(ctx, db, `
			SELECT use_case_code FROM public.listing_use_cases
			WHERE listing_id = $1 ORDER BY use_case_code
		`, listingID)
		if err != nil {
			return listingEditReadError(c, err)
		}
		putDraftStrings(draft, "useCaseCodes[]", useCases)

		spaceTypes, err := listingEditStrings(ctx, db, `
			SELECT space_type_code FROM public.listing_space_types
			WHERE listing_id = $1 ORDER BY is_primary DESC, sort_order, space_type_code
		`, listingID)
		if err != nil {
			return listingEditReadError(c, err)
		}
		putDraftStrings(draft, "spaceTypeCodes[]", spaceTypes)

		amenities, err := listingEditStrings(ctx, db, `
			SELECT amenity_code FROM public.listing_amenities
			WHERE listing_id = $1 ORDER BY amenity_code
		`, listingID)
		if err != nil {
			return listingEditReadError(c, err)
		}
		putDraftStrings(draft, "amenities[]", amenities)

		allowedBusinessTypes, err := listingEditStrings(ctx, db, `
			SELECT unnest(allowed_business_types) FROM public.listing_business_details
			WHERE listing_id = $1
		`, listingID)
		if err != nil {
			return listingEditReadError(c, err)
		}
		putDraftStrings(draft, "allowedBusinessTypes[]", allowedBusinessTypes)

		if err := loadListingOffersIntoDraft(ctx, db, listingID, draft); err != nil {
			return listingEditReadError(c, err)
		}
		if err := loadListingMediaIntoDraft(ctx, db, listingID, draft); err != nil {
			return listingEditReadError(c, err)
		}

		now := time.Now().UTC()
		draft["lastStep"] = "3"
		draft["resumeStep"] = "1"
		draft["updatedAt"] = now.Format(time.RFC3339Nano)
		draft["draftExpiresAt"] = now.Add(48 * time.Hour).Format(time.RFC3339Nano)

		return c.JSON(fiber.Map{"draft": draft})
	}
}

func loadListingOffersIntoDraft(ctx context.Context, db *sql.DB, listingID int64, draft map[string]any) error {
	rows, err := db.QueryContext(ctx, `
		SELECT offer_type, amount, price_unit, currency_code,
			minimum_contract_months, service_fee_monthly, is_negotiable
		FROM public.listing_offers
		WHERE listing_id = $1
		ORDER BY id
	`, listingID)
	if err != nil {
		return err
	}
	defer rows.Close()

	offerTypes := make([]string, 0, 3)
	for rows.Next() {
		var offerType, priceUnit, currency string
		var amount, serviceFee sql.NullFloat64
		var minimumMonths sql.NullInt64
		var negotiable bool
		if err := rows.Scan(&offerType, &amount, &priceUnit, &currency, &minimumMonths, &serviceFee, &negotiable); err != nil {
			return err
		}
		offerTypes = append(offerTypes, offerType)
		putDraftText(draft, "price_unit", priceUnit)
		putDraftText(draft, "currency", currency)
		putDraftBool(draft, "priceNegotiable", negotiable)
		if minimumMonths.Valid {
			putDraftText(draft, "minimumLeaseMonths", strconv.FormatInt(minimumMonths.Int64, 10))
		}
		if serviceFee.Valid {
			putDraftText(draft, "serviceFeeMonthly", formatListingEditFloat(serviceFee.Float64))
		}
		if !amount.Valid {
			continue
		}
		amountText := formatListingEditFloat(amount.Float64)
		switch offerType {
		case "sale":
			putDraftText(draft, "salePrice", amountText)
		case "rent", "sublease":
			if priceUnit == "event_period" {
				putDraftText(draft, "temporarySpacePrice", amountText)
			} else {
				putDraftText(draft, "rentPriceMonthly", amountText)
			}
		case "business_transfer":
			putDraftText(draft, "keyMoneyAmount", amountText)
		}
	}
	if err := rows.Err(); err != nil {
		return err
	}
	putDraftStrings(draft, "offerTypes[]", offerTypes)
	return nil
}

func loadListingMediaIntoDraft(ctx context.Context, db *sql.DB, listingID int64, draft map[string]any) error {
	rows, err := db.QueryContext(ctx, `
		SELECT media_type,
			COALESCE(NULLIF(original_url, ''), NULLIF(file_url, ''), NULLIF(large_url, ''), '')
		FROM public.listing_media
		WHERE listing_id = $1 AND is_active = true AND deleted_at IS NULL
		ORDER BY is_primary DESC, sort_order, id
	`, listingID)
	if err != nil {
		return err
	}
	defer rows.Close()

	photos := make([]string, 0, maxListingImages)
	videos := make([]string, 0, maxListingVideos)
	panoramas := make([]string, 0, maxListingPanoramas)
	for rows.Next() {
		var mediaType, url string
		if err := rows.Scan(&mediaType, &url); err != nil {
			return err
		}
		if url == "" {
			continue
		}
		switch mediaType {
		case "image":
			photos = append(photos, url)
		case "video":
			videos = append(videos, url)
		case "360", "panorama":
			panoramas = append(panoramas, url)
		}
	}
	if err := rows.Err(); err != nil {
		return err
	}
	putDraftStrings(draft, "listingPhotoUrls[]", photos)
	putDraftStrings(draft, "listingVideoUrls[]", videos)
	putDraftStrings(draft, "listingPanoramaUrls[]", panoramas)
	draft["listingMediaLoaded"] = "yes"
	draft["selectedPhotoCount"] = strconv.Itoa(len(photos))
	draft["selectedVideoCount"] = strconv.Itoa(len(videos))
	draft["selectedPanoramaCount"] = strconv.Itoa(len(panoramas))
	return nil
}

func listingEditStrings(ctx context.Context, db *sql.DB, query string, listingID int64) ([]string, error) {
	rows, err := db.QueryContext(ctx, query, listingID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	values := make([]string, 0)
	for rows.Next() {
		var value string
		if err := rows.Scan(&value); err != nil {
			return nil, err
		}
		if value != "" {
			values = append(values, value)
		}
	}
	return values, rows.Err()
}

func copyCategoryDetailsToDraft(draft map[string]any, details map[string]any) {
	arrayKeys := map[string]string{
		"shared_facilities": "sharedFacilities[]",
		"services_included": "servicesIncluded[]",
		"resident_groups":   "residentGroups[]",
		"hotel_facilities":  "hotelFacilities[]",
	}
	ignored := map[string]bool{
		"details_status": true, "can_complete_later": true, "submission_mode": true,
		"discovery_channel_code": true, "accommodation_model": true,
		"selected_photo_count": true, "selected_video_count": true, "selected_panorama_count": true,
		"price_on_request": true,
	}
	for key, value := range details {
		if ignored[key] {
			continue
		}
		draftKey := arrayKeys[key]
		if draftKey == "" {
			draftKey = snakeToLowerCamel(key)
		}
		switch typed := value.(type) {
		case string:
			putDraftText(draft, draftKey, typed)
		case bool:
			putDraftBool(draft, draftKey, typed)
		case float64:
			putDraftText(draft, draftKey, formatListingEditFloat(typed))
		case []any:
			items := make([]string, 0, len(typed))
			for _, item := range typed {
				if text, ok := item.(string); ok && text != "" {
					items = append(items, text)
				}
			}
			putDraftStrings(draft, draftKey, items)
		}
	}
}

func snakeToLowerCamel(value string) string {
	parts := strings.Split(value, "_")
	for index := 1; index < len(parts); index++ {
		if parts[index] != "" {
			parts[index] = strings.ToUpper(parts[index][:1]) + parts[index][1:]
		}
	}
	return strings.Join(parts, "")
}

func putDraftText(draft map[string]any, key, value string) {
	if strings.TrimSpace(value) != "" {
		draft[key] = value
	}
}

func putDraftBool(draft map[string]any, key string, value bool) {
	if value {
		draft[key] = "yes"
	}
}

func putDraftStrings(draft map[string]any, key string, values []string) {
	if len(values) > 0 {
		draft[key] = values
	}
}

func formatListingEditFloat(value float64) string {
	return strconv.FormatFloat(value, 'f', -1, 64)
}

func listingEditReadError(c *fiber.Ctx, err error) error {
	fmt.Println("Read listing edit details error:", err)
	return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot load listing for editing"})
}
