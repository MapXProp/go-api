package handlers

import (
	"context"
	"database/sql"
	"strings"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/lib/pq"
)

type listingMediaResponse struct {
	ID        int64  `json:"id"`
	MediaType string `json:"media_type"`
	RoleCode  string `json:"role_code"`
	Title     string `json:"title"`
	AltText   string `json:"alt_text"`
	URL       string `json:"url"`
	Width     *int   `json:"width,omitempty"`
	Height    *int   `json:"height,omitempty"`
	IsPrimary bool   `json:"is_primary"`
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
	ID               int64                  `json:"id"`
	PublicListingID  string                 `json:"public_listing_id"`
	Slug             string                 `json:"slug"`
	Title            string                 `json:"title"`
	Description      string                 `json:"description"`
	PropertyTypeCode string                 `json:"property_type_code"`
	UsageType        string                 `json:"usage_type"`
	ListingType      string                 `json:"listing_type"`
	ListingScope     string                 `json:"listing_scope"`
	SpaceTypeCode    string                 `json:"space_type_code"`
	ProjectName      string                 `json:"project_name"`
	BuildingName     string                 `json:"building_name"`
	Address          string                 `json:"address"`
	Province         string                 `json:"province"`
	District         string                 `json:"district"`
	Subdistrict      string                 `json:"subdistrict"`
	PostalCode       string                 `json:"postal_code"`
	Latitude         *float64               `json:"latitude,omitempty"`
	Longitude        *float64               `json:"longitude,omitempty"`
	ContactName      string                 `json:"contact_name"`
	ContactPhone     string                 `json:"contact_phone"`
	LineID           string                 `json:"line_id"`
	OfferType        string                 `json:"offer_type"`
	OfferAmount      *float64               `json:"offer_amount,omitempty"`
	PriceUnit        string                 `json:"price_unit"`
	PublishedAt      *time.Time             `json:"published_at,omitempty"`
	ExpiresAt        *time.Time             `json:"expires_at,omitempty"`
	IsVerified       bool                   `json:"is_verified"`
	Media            []listingMediaResponse `json:"media"`
	Event            *listingEventResponse  `json:"event,omitempty"`
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
		var latitude, longitude, amount sql.NullFloat64
		var publishedAt, expiresAt, sourcePublishedAt sql.NullTime
		var eventName, organizerName, organizerWebsiteURL, organizerVerificationStatus, venueName, venueFloor, applicationInstructions, floorPlanURL sql.NullString
		var audienceSegments, acceptedProducts pq.StringArray
		var priceOnRequest, boothSizeOnRequest sql.NullBool

		err := db.QueryRowContext(ctx, `
			SELECT
				l.id, l.public_listing_id::text, COALESCE(l.slug, ''), l.title,
				COALESCE(l.description, ''), l.property_type_code, l.usage_type,
				l.listing_type, l.listing_scope, COALESCE(l.space_type_code, ''),
				COALESCE(l.custom_project_name, ''), COALESCE(l.custom_building_name, ''),
				trim(concat_ws(' ', l.address_line1, l.address_line2)),
				COALESCE(l.province_name, ''), COALESCE(l.district_name, ''),
				COALESCE(l.subdistrict_name, ''), COALESCE(l.postal_code, ''),
				l.latitude, l.longitude,
				COALESCE(l.contact_name, ''), COALESCE(l.contact_phone, ''), COALESCE(l.line_id, ''),
				COALESCE(lo.offer_type, ''), lo.amount, COALESCE(lo.price_unit, l.price_unit, ''),
				l.published_at, l.expires_at, l.is_verified,
				led.event_name, led.organizer_name,
				organizer.website_url, organizer.verification_status,
				led.venue_name, led.venue_floor_label,
				led.audience_segments, led.accepted_product_categories,
				led.application_instructions, led.floor_plan_url,
				COALESCE((lcd.details->>'price_on_request')::boolean, led.price_on_request),
				led.booth_size_on_request, led.source_published_at
			FROM public.listings l
			LEFT JOIN public.listing_category_details lcd ON lcd.listing_id = l.id
			LEFT JOIN LATERAL (
				SELECT offer_type, amount, price_unit
				FROM public.listing_offers
				WHERE listing_id = l.id
				ORDER BY CASE offer_type WHEN 'event_booking' THEN 0 WHEN 'rent' THEN 1 ELSE 2 END, id
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
			&item.Description, &item.PropertyTypeCode, &item.UsageType,
			&item.ListingType, &item.ListingScope, &item.SpaceTypeCode,
			&item.ProjectName, &item.BuildingName, &item.Address,
			&item.Province, &item.District, &item.Subdistrict, &item.PostalCode,
			&latitude, &longitude, &item.ContactName, &item.ContactPhone, &item.LineID,
			&item.OfferType, &amount, &item.PriceUnit,
			&publishedAt, &expiresAt, &item.IsVerified,
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
		if amount.Valid {
			item.OfferAmount = &amount.Float64
		}
		if publishedAt.Valid {
			item.PublishedAt = &publishedAt.Time
		}
		if expiresAt.Valid {
			item.ExpiresAt = &expiresAt.Time
		}

		item.Media = make([]listingMediaResponse, 0)
		mediaRows, err := db.QueryContext(ctx, `
			SELECT id, media_type, role_code, COALESCE(title, ''), COALESCE(alt_text, ''),
				COALESCE(NULLIF(large_url, ''), NULLIF(medium_url, ''), NULLIF(file_url, ''), NULLIF(original_url, ''), ''),
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
			if err := mediaRows.Scan(&media.ID, &media.MediaType, &media.RoleCode, &media.Title, &media.AltText, &media.URL, &width, &height, &media.IsPrimary); err != nil {
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
