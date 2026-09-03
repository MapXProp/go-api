package handlers

import (
	"context"
	"database/sql"
	"encoding/json"
	"strings"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/lib/pq"
)

type listingMediaResponse struct {
	ID           int64  `json:"id"`
	MediaType    string `json:"media_type"`
	RoleCode     string `json:"role_code"`
	Title        string `json:"title"`
	AltText      string `json:"alt_text"`
	URL          string `json:"url"`
	ThumbnailURL string `json:"thumbnail_url,omitempty"`
	Width        *int   `json:"width,omitempty"`
	Height       *int   `json:"height,omitempty"`
	IsPrimary    bool   `json:"is_primary"`
}

// listingContentBlockResponse keeps presentation copy in PostgreSQL instead of
// coupling a page component to one particular listing.  The JSON content is
// deliberately flexible: a card list, a bullet list, or future rich content
// can share the same transport shape.
type listingContentBlockResponse struct {
	Code      string          `json:"code"`
	Type      string          `json:"type"`
	HeadingTH string          `json:"heading_th"`
	HeadingEN string          `json:"heading_en"`
	BodyTH    string          `json:"body_th"`
	BodyEN    string          `json:"body_en"`
	Content   json.RawMessage `json:"content"`
	SortOrder int             `json:"sort_order"`
}

type listingNearbyPlaceResponse struct {
	NameTH            string `json:"name_th"`
	NameEN            string `json:"name_en"`
	PlaceTypeCode     string `json:"place_type_code"`
	DistanceMeters    *int   `json:"distance_meters,omitempty"`
	TravelTimeMinutes *int   `json:"travel_time_minutes,omitempty"`
	SortOrder         int    `json:"sort_order"`
}

type listingTransactionTermResponse struct {
	Code         string   `json:"code"`
	LabelTH      string   `json:"label_th"`
	LabelEN      string   `json:"label_en"`
	ValueTH      string   `json:"value_th"`
	ValueEN      string   `json:"value_en"`
	PayerCode    string   `json:"payer_code"`
	NumericValue *float64 `json:"numeric_value,omitempty"`
	UnitCode     string   `json:"unit_code"`
	SortOrder    int      `json:"sort_order"`
}

type listingEventRoundResponse struct {
	ID                 int64    `json:"id"`
	Label              string   `json:"label"`
	StartsOn           string   `json:"starts_on"`
	EndsOn             string   `json:"ends_on"`
	AvailabilityStatus string   `json:"availability_status"`
	SpacesRemaining    *int     `json:"spaces_remaining,omitempty"`
	PriceAmount        *float64 `json:"price_amount,omitempty"`
	PriceUnit          string   `json:"price_unit"`
	Notes              string   `json:"notes"`
}

type listingEventResponse struct {
	Name                        string                      `json:"name"`
	OrganizerName               string                      `json:"organizer_name"`
	OrganizerWebsiteURL         string                      `json:"organizer_website_url"`
	OrganizerVerificationStatus string                      `json:"organizer_verification_status"`
	VenueName                   string                      `json:"venue_name"`
	VenueFloorLabel             string                      `json:"venue_floor_label"`
	AudienceSegments            []string                    `json:"audience_segments"`
	AcceptedProductCategories   []string                    `json:"accepted_product_categories"`
	ApplicationInstructions     string                      `json:"application_instructions"`
	FloorPlanURL                string                      `json:"floor_plan_url"`
	PriceOnRequest              bool                        `json:"price_on_request"`
	BoothSizeOnRequest          bool                        `json:"booth_size_on_request"`
	SourcePublishedAt           *time.Time                  `json:"source_published_at,omitempty"`
	Rounds                      []listingEventRoundResponse `json:"rounds"`
}

type listingDetailResponse struct {
	ID                    int64                            `json:"id"`
	PublicListingID       string                           `json:"public_listing_id"`
	Slug                  string                           `json:"slug"`
	Title                 string                           `json:"title"`
	Description           string                           `json:"description"`
	PropertyTypeCode      string                           `json:"property_type_code"`
	AccommodationModel    string                           `json:"accommodation_model"`
	UsageType             string                           `json:"usage_type"`
	ListingType           string                           `json:"listing_type"`
	ListingScope          string                           `json:"listing_scope"`
	SpaceTypeCode         string                           `json:"space_type_code"`
	SpaceTypeCodes        []string                         `json:"space_type_codes"`
	AllowedBusinessTypes  []string                         `json:"allowed_business_types"`
	ProjectName           string                           `json:"project_name"`
	BuildingName          string                           `json:"building_name"`
	Address               string                           `json:"address"`
	Province              string                           `json:"province"`
	District              string                           `json:"district"`
	Subdistrict           string                           `json:"subdistrict"`
	PostalCode            string                           `json:"postal_code"`
	Road                  string                           `json:"road"`
	UsableAreaSqm         *float64                         `json:"usable_area_sqm,omitempty"`
	LandAreaSqm           *float64                         `json:"land_area_sqm,omitempty"`
	BedroomCount          *int                             `json:"bedroom_count,omitempty"`
	BathroomCount         *int                             `json:"bathroom_count,omitempty"`
	ParkingCount          *int                             `json:"parking_count,omitempty"`
	FloorNo               *int                             `json:"floor_no,omitempty"`
	TotalFloors           *int                             `json:"total_floors,omitempty"`
	FurnishingStatus      string                           `json:"furnishing_status"`
	PropertyCondition     string                           `json:"property_condition"`
	OccupancyStatus       string                           `json:"occupancy_status"`
	Latitude              *float64                         `json:"latitude,omitempty"`
	Longitude             *float64                         `json:"longitude,omitempty"`
	ContactName           string                           `json:"contact_name"`
	ContactPhone          string                           `json:"contact_phone"`
	ContactPhoneSecondary string                           `json:"contact_phone_secondary"`
	ContactEmail          string                           `json:"contact_email"`
	LineID                string                           `json:"line_id"`
	InstagramHandle       string                           `json:"instagram_handle"`
	ContactRoleCode       string                           `json:"contact_role_code"`
	ContactAuthorityCode  string                           `json:"contact_authority_code"`
	ContactOrganization   string                           `json:"contact_organization_name"`
	ContactVerification   string                           `json:"contact_verification_status"`
	OfferType             string                           `json:"offer_type"`
	OfferAmount           *float64                         `json:"offer_amount,omitempty"`
	PriceUnit             string                           `json:"price_unit"`
	Currency              string                           `json:"currency"`
	Amenities             []string                         `json:"amenities"`
	PublishedAt           *time.Time                       `json:"published_at,omitempty"`
	ExpiresAt             *time.Time                       `json:"expires_at,omitempty"`
	IsVerified            bool                             `json:"is_verified"`
	CategoryDetails       map[string]any                   `json:"category_details"`
	Media                 []listingMediaResponse           `json:"media"`
	ContentBlocks         []listingContentBlockResponse    `json:"content_blocks"`
	NearbyPlaces          []listingNearbyPlaceResponse     `json:"nearby_places"`
	TransactionTerms      []listingTransactionTermResponse `json:"transaction_terms"`
	Event                 *listingEventResponse            `json:"event,omitempty"`
}

func GetListingBySlug(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		slug := strings.TrimSpace(c.Params("slug"))
		if slug == "" {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "listing slug is required"})
		}

		ctx, cancel := context.WithTimeout(context.Background(), 8*time.Second)
		defer cancel()

		var item listingDetailResponse
		var latitude, longitude, amount, usableAreaSqm, landAreaSqm sql.NullFloat64
		var bedroomCount, bathroomCount, parkingCount, floorNo, totalFloors sql.NullInt64
		var publishedAt, expiresAt, sourcePublishedAt sql.NullTime
		var rawCategoryDetails []byte
		var eventName, organizerName, organizerWebsiteURL, organizerVerificationStatus, venueName, venueFloor, applicationInstructions, floorPlanURL sql.NullString
		var audienceSegments, acceptedProducts pq.StringArray
		var priceOnRequest, boothSizeOnRequest sql.NullBool

		err := db.QueryRowContext(ctx, `
			SELECT
				l.id, l.public_listing_id::text, COALESCE(l.slug, ''), l.title,
				COALESCE(l.description, ''), l.property_type_code, COALESCE(l.accommodation_model, ''), l.usage_type,
				l.listing_type, l.listing_scope, COALESCE(l.space_type_code, ''),
				COALESCE(l.custom_project_name, ''), COALESCE(l.custom_building_name, ''),
				trim(concat_ws(' ', l.address_line1, l.address_line2)),
				COALESCE(l.province_name, ''), COALESCE(l.district_name, ''),
				COALESCE(l.subdistrict_name, ''), COALESCE(l.postal_code, ''),
				COALESCE(l.road, ''), l.usable_area_sqm, l.land_area_sqm,
				l.bedroom_count, l.bathroom_count, l.parking_count, l.floor_no, l.total_floors,
				COALESCE(l.furnishing_status, ''), COALESCE(l.property_condition, ''), COALESCE(l.occupancy_status, ''),
				l.latitude, l.longitude,
				COALESCE(l.contact_name, ''), COALESCE(l.contact_phone, ''), COALESCE(l.contact_phone_secondary, ''),
				COALESCE(l.contact_email, ''), COALESCE(l.line_id, ''), COALESCE(l.instagram_handle, ''),
				COALESCE(lcp.role_code, ''), COALESCE(lcp.authority_source_code, ''),
				COALESCE(lcp.organization_name, ''), COALESCE(lcp.verification_status, 'unverified'),
				COALESCE(lo.offer_type, ''), lo.amount, COALESCE(lo.price_unit, l.price_unit, ''),
				COALESCE(lo.currency_code, 'THB'),
				l.published_at, l.expires_at, l.is_verified, COALESCE(lcd.details, '{}'::jsonb),
				led.event_name, led.organizer_name,
				organizer.website_url, organizer.verification_status,
				led.venue_name, led.venue_floor_label,
				led.audience_segments, led.accepted_product_categories,
				led.application_instructions, led.floor_plan_url,
				COALESCE((lcd.details->>'price_on_request')::boolean, led.price_on_request),
				led.booth_size_on_request, led.source_published_at
			FROM public.listings l
			LEFT JOIN public.listing_category_details lcd ON lcd.listing_id = l.id
			LEFT JOIN public.listing_contact_profiles lcp ON lcp.listing_id = l.id
			LEFT JOIN LATERAL (
				SELECT offer_type, amount, price_unit, currency_code
				FROM public.listing_offers
				WHERE listing_id = l.id
				ORDER BY CASE offer_type WHEN 'contact_organizer' THEN 0 WHEN 'rent' THEN 1 ELSE 2 END, id
				LIMIT 1
			) lo ON true
			LEFT JOIN public.listing_event_details led ON led.listing_id = l.id
			LEFT JOIN public.listing_organizers organizer ON organizer.id = led.organizer_id
			WHERE l.slug = $1
			  AND l.is_active = true
			  AND l.deleted_at IS NULL
			  AND l.listing_status = 'active'
			  AND l.moderation_status = 'approved'
			LIMIT 1
		`, slug).Scan(
			&item.ID, &item.PublicListingID, &item.Slug, &item.Title,
			&item.Description, &item.PropertyTypeCode, &item.AccommodationModel, &item.UsageType,
			&item.ListingType, &item.ListingScope, &item.SpaceTypeCode,
			&item.ProjectName, &item.BuildingName, &item.Address,
			&item.Province, &item.District, &item.Subdistrict, &item.PostalCode,
			&item.Road, &usableAreaSqm, &landAreaSqm,
			&bedroomCount, &bathroomCount, &parkingCount, &floorNo, &totalFloors,
			&item.FurnishingStatus, &item.PropertyCondition, &item.OccupancyStatus,
			&latitude, &longitude, &item.ContactName, &item.ContactPhone,
			&item.ContactPhoneSecondary, &item.ContactEmail, &item.LineID, &item.InstagramHandle,
			&item.ContactRoleCode, &item.ContactAuthorityCode, &item.ContactOrganization, &item.ContactVerification,
			&item.OfferType, &amount, &item.PriceUnit, &item.Currency,
			&publishedAt, &expiresAt, &item.IsVerified, &rawCategoryDetails,
			&eventName, &organizerName, &organizerWebsiteURL, &organizerVerificationStatus, &venueName, &venueFloor,
			&audienceSegments, &acceptedProducts, &applicationInstructions, &floorPlanURL,
			&priceOnRequest, &boothSizeOnRequest, &sourcePublishedAt,
		)
		if err == sql.ErrNoRows {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{"error": "listing not found"})
		}
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read listing"})
		}

		if latitude.Valid {
			item.Latitude = &latitude.Float64
		}
		if longitude.Valid {
			item.Longitude = &longitude.Float64
		}
		if landAreaSqm.Valid {
			item.LandAreaSqm = &landAreaSqm.Float64
		}
		if usableAreaSqm.Valid {
			item.UsableAreaSqm = &usableAreaSqm.Float64
		}
		if bedroomCount.Valid {
			value := int(bedroomCount.Int64)
			item.BedroomCount = &value
		}
		if bathroomCount.Valid {
			value := int(bathroomCount.Int64)
			item.BathroomCount = &value
		}
		if parkingCount.Valid {
			value := int(parkingCount.Int64)
			item.ParkingCount = &value
		}
		if floorNo.Valid {
			value := int(floorNo.Int64)
			item.FloorNo = &value
		}
		if totalFloors.Valid {
			value := int(totalFloors.Int64)
			item.TotalFloors = &value
		}
		item.CategoryDetails = make(map[string]any)
		if len(rawCategoryDetails) > 0 {
			if err := json.Unmarshal(rawCategoryDetails, &item.CategoryDetails); err != nil {
				return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read listing details"})
			}
		}
		if amount.Valid {
			item.OfferAmount = &amount.Float64
		}
		if publishedAt.Valid {
			item.PublishedAt = &publishedAt.Time
		}
		if expiresAt.Valid {
			item.ExpiresAt = &expiresAt.Time
		}

		item.SpaceTypeCodes = make([]string, 0, 3)
		spaceTypeRows, err := db.QueryContext(ctx, `
			SELECT space_type_code
			FROM public.listing_space_types
			WHERE listing_id = $1
			ORDER BY is_primary DESC, sort_order, space_type_code
		`, item.ID)
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read listing space types"})
		}
		for spaceTypeRows.Next() {
			var spaceTypeCode string
			if err := spaceTypeRows.Scan(&spaceTypeCode); err != nil {
				spaceTypeRows.Close()
				return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read listing space types"})
			}
			item.SpaceTypeCodes = append(item.SpaceTypeCodes, spaceTypeCode)
		}
		if err := spaceTypeRows.Err(); err != nil {
			spaceTypeRows.Close()
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read listing space types"})
		}
		if err := spaceTypeRows.Close(); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot finish reading listing space types"})
		}

		item.Amenities = make([]string, 0)
		amenityRows, err := db.QueryContext(ctx, `
			SELECT amenity_code
			FROM public.listing_amenities
			WHERE listing_id = $1
			ORDER BY amenity_code
		`, item.ID)
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read listing amenities"})
		}
		for amenityRows.Next() {
			var amenityCode string
			if err := amenityRows.Scan(&amenityCode); err != nil {
				amenityRows.Close()
				return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read listing amenities"})
			}
			item.Amenities = append(item.Amenities, amenityCode)
		}
		if err := amenityRows.Err(); err != nil {
			amenityRows.Close()
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read listing amenities"})
		}
		if err := amenityRows.Close(); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot finish reading listing amenities"})
		}
		if len(item.SpaceTypeCodes) == 0 && item.SpaceTypeCode != "" {
			item.SpaceTypeCodes = append(item.SpaceTypeCodes, item.SpaceTypeCode)
		}

		item.AllowedBusinessTypes = make([]string, 0)
		var allowedBusinessTypes pq.StringArray
		err = db.QueryRowContext(ctx, `
			SELECT COALESCE(allowed_business_types, '{}'::text[])
			FROM public.listing_business_details
			WHERE listing_id = $1
		`, item.ID).Scan(&allowedBusinessTypes)
		if err != nil && err != sql.ErrNoRows {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read allowed business types"})
		}
		if err == nil {
			item.AllowedBusinessTypes = []string(allowedBusinessTypes)
		}

		item.Media = make([]listingMediaResponse, 0)
		mediaRows, err := db.QueryContext(ctx, `
			SELECT id, media_type, role_code, COALESCE(title, ''), COALESCE(alt_text, ''),
				COALESCE(NULLIF(large_url, ''), NULLIF(medium_url, ''), NULLIF(file_url, ''), NULLIF(original_url, ''), ''),
				COALESCE(NULLIF(thumbnail_url, ''), NULLIF(thumb_url, ''), NULLIF(medium_url, ''), NULLIF(file_url, ''), ''),
				width, height, is_primary
			FROM public.listing_media
			WHERE listing_id = $1 AND is_active = true AND deleted_at IS NULL
			ORDER BY is_primary DESC, sort_order, id
		`, item.ID)
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read listing media"})
		}
		defer mediaRows.Close()
		for mediaRows.Next() {
			var media listingMediaResponse
			var width, height sql.NullInt64
			if err := mediaRows.Scan(&media.ID, &media.MediaType, &media.RoleCode, &media.Title, &media.AltText, &media.URL, &media.ThumbnailURL, &width, &height, &media.IsPrimary); err != nil {
				return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read listing media"})
			}
			if width.Valid {
				value := int(width.Int64)
				media.Width = &value
			}
			if height.Valid {
				value := int(height.Int64)
				media.Height = &value
			}
			item.Media = append(item.Media, media)
		}
		if err := mediaRows.Err(); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read listing media"})
		}

		item.ContentBlocks = make([]listingContentBlockResponse, 0)
		contentRows, err := db.QueryContext(ctx, `
			SELECT block_code, block_type, heading_th, heading_en, body_th, body_en, content, sort_order
			FROM public.listing_content_blocks
			WHERE listing_id = $1 AND is_visible = true
			ORDER BY sort_order, id
		`, item.ID)
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read listing content"})
		}
		defer contentRows.Close()
		for contentRows.Next() {
			var block listingContentBlockResponse
			if err := contentRows.Scan(
				&block.Code, &block.Type, &block.HeadingTH, &block.HeadingEN,
				&block.BodyTH, &block.BodyEN, &block.Content, &block.SortOrder,
			); err != nil {
				return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read listing content"})
			}
			item.ContentBlocks = append(item.ContentBlocks, block)
		}
		if err := contentRows.Err(); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read listing content"})
		}

		item.NearbyPlaces = make([]listingNearbyPlaceResponse, 0)
		nearbyRows, err := db.QueryContext(ctx, `
			SELECT place_name_th, place_name_en, place_type_code, distance_meters, travel_time_minutes, sort_order
			FROM public.listing_nearby_places
			WHERE listing_id = $1 AND is_highlight = true
			ORDER BY sort_order, id
		`, item.ID)
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read nearby places"})
		}
		defer nearbyRows.Close()
		for nearbyRows.Next() {
			var place listingNearbyPlaceResponse
			var distanceMeters, travelTimeMinutes sql.NullInt64
			if err := nearbyRows.Scan(
				&place.NameTH, &place.NameEN, &place.PlaceTypeCode,
				&distanceMeters, &travelTimeMinutes, &place.SortOrder,
			); err != nil {
				return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read nearby places"})
			}
			if distanceMeters.Valid {
				value := int(distanceMeters.Int64)
				place.DistanceMeters = &value
			}
			if travelTimeMinutes.Valid {
				value := int(travelTimeMinutes.Int64)
				place.TravelTimeMinutes = &value
			}
			item.NearbyPlaces = append(item.NearbyPlaces, place)
		}
		if err := nearbyRows.Err(); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read nearby places"})
		}

		item.TransactionTerms = make([]listingTransactionTermResponse, 0)
		termRows, err := db.QueryContext(ctx, `
			SELECT term_code, label_th, label_en, value_th, value_en, payer_code, numeric_value, unit_code, sort_order
			FROM public.listing_transaction_terms
			WHERE listing_id = $1
			ORDER BY sort_order, id
		`, item.ID)
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read transaction terms"})
		}
		defer termRows.Close()
		for termRows.Next() {
			var term listingTransactionTermResponse
			var numericValue sql.NullFloat64
			if err := termRows.Scan(
				&term.Code, &term.LabelTH, &term.LabelEN, &term.ValueTH, &term.ValueEN,
				&term.PayerCode, &numericValue, &term.UnitCode, &term.SortOrder,
			); err != nil {
				return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read transaction terms"})
			}
			if numericValue.Valid {
				term.NumericValue = &numericValue.Float64
			}
			item.TransactionTerms = append(item.TransactionTerms, term)
		}
		if err := termRows.Err(); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read transaction terms"})
		}

		if eventName.Valid {
			event := &listingEventResponse{
				Name:                        eventName.String,
				OrganizerName:               organizerName.String,
				OrganizerWebsiteURL:         organizerWebsiteURL.String,
				OrganizerVerificationStatus: organizerVerificationStatus.String,
				VenueName:                   venueName.String,
				VenueFloorLabel:             venueFloor.String,
				AudienceSegments:            []string(audienceSegments),
				AcceptedProductCategories:   []string(acceptedProducts),
				ApplicationInstructions:     applicationInstructions.String,
				FloorPlanURL:                floorPlanURL.String,
				PriceOnRequest:              priceOnRequest.Valid && priceOnRequest.Bool,
				BoothSizeOnRequest:          boothSizeOnRequest.Valid && boothSizeOnRequest.Bool,
				Rounds:                      make([]listingEventRoundResponse, 0),
			}
			if sourcePublishedAt.Valid {
				event.SourcePublishedAt = &sourcePublishedAt.Time
			}

			roundRows, err := db.QueryContext(ctx, `
				SELECT id, COALESCE(round_label, ''), starts_on, ends_on, availability_status,
					spaces_remaining, price_amount, price_unit, COALESCE(notes, '')
				FROM public.listing_event_rounds
				WHERE listing_id = $1
				ORDER BY sort_order, starts_on, id
			`, item.ID)
			if err != nil {
				return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read event rounds"})
			}
			defer roundRows.Close()
			for roundRows.Next() {
				var round listingEventRoundResponse
				var startsOn, endsOn time.Time
				var spacesRemaining sql.NullInt64
				var priceAmount sql.NullFloat64
				if err := roundRows.Scan(&round.ID, &round.Label, &startsOn, &endsOn, &round.AvailabilityStatus, &spacesRemaining, &priceAmount, &round.PriceUnit, &round.Notes); err != nil {
					return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read event rounds"})
				}
				round.StartsOn = startsOn.Format("2006-01-02")
				round.EndsOn = endsOn.Format("2006-01-02")
				if spacesRemaining.Valid {
					value := int(spacesRemaining.Int64)
					round.SpacesRemaining = &value
				}
				if priceAmount.Valid {
					round.PriceAmount = &priceAmount.Float64
				}
				event.Rounds = append(event.Rounds, round)
			}
			item.Event = event
		}

		return c.JSON(item)
	}
}
