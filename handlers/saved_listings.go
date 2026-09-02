package handlers

import (
	"context"
	"database/sql"
	"strings"

	"github.com/gofiber/fiber/v2"
	"github.com/lib/pq"
)

const maxSavedListingMergeItems = 100

type savedListingReference struct {
	PublicListingID string `json:"public_listing_id"`
	Slug            string `json:"slug"`
}

type mergeSavedListingsRequest struct {
	ListingIdentifiers []string `json:"listing_identifiers"`
}

func GetMySavedListings(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, err := authenticatedAccountRequest(c, db)
		if err != nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": err.Error()})
		}
		defer cancel()

		listings, references, err := loadSavedListings(ctx, db, claims.UID)
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot load saved listings"})
		}
		return c.JSON(fiber.Map{
			"listings":   listings,
			"references": references,
			"total":      len(listings),
		})
	}
}

func SaveMyListing(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, err := authenticatedAccountRequest(c, db)
		if err != nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": err.Error()})
		}
		defer cancel()

		identifier := cleanSavedListingIdentifier(c.Params("identifier"))
		if identifier == "" {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid listing identifier"})
		}

		var listingID int64
		var reference savedListingReference
		err = db.QueryRowContext(ctx, `
			SELECT id, public_listing_id::text, COALESCE(slug, '')
			FROM public.listings
			WHERE (slug = $1 OR public_listing_id::text = $1)
			  AND published_at IS NOT NULL
			  AND deleted_at IS NULL
			  AND is_active = true
			  AND listing_status = 'active'
			  AND moderation_status = 'approved'
			LIMIT 1
		`, identifier).Scan(&listingID, &reference.PublicListingID, &reference.Slug)
		if err == sql.ErrNoRows {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{"error": "listing not found"})
		}
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot save listing"})
		}

		if _, err := db.ExecContext(ctx, `
			INSERT INTO public.user_saved_listings (user_id, listing_id)
			VALUES ($1, $2)
			ON CONFLICT (user_id, listing_id) DO NOTHING
		`, claims.UID, listingID); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot save listing"})
		}

		return c.JSON(fiber.Map{"saved": true, "listing": reference})
	}
}

func UnsaveMyListing(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, err := authenticatedAccountRequest(c, db)
		if err != nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": err.Error()})
		}
		defer cancel()

		identifier := cleanSavedListingIdentifier(c.Params("identifier"))
		if identifier == "" {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid listing identifier"})
		}

		result, err := db.ExecContext(ctx, `
			DELETE FROM public.user_saved_listings saved
			USING public.listings listing
			WHERE saved.user_id = $1
			  AND saved.listing_id = listing.id
			  AND (listing.slug = $2 OR listing.public_listing_id::text = $2)
		`, claims.UID, identifier)
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot remove saved listing"})
		}
		removed, _ := result.RowsAffected()
		return c.JSON(fiber.Map{"saved": false, "removed": removed > 0})
	}
}

func MergeMySavedListings(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, err := authenticatedAccountRequest(c, db)
		if err != nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": err.Error()})
		}
		defer cancel()

		var req mergeSavedListingsRequest
		if err := c.BodyParser(&req); err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid saved listings"})
		}
		identifiers := cleanSavedListingIdentifiers(req.ListingIdentifiers)
		if len(identifiers) > maxSavedListingMergeItems {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "too many saved listings"})
		}

		if len(identifiers) > 0 {
			if _, err := db.ExecContext(ctx, `
				INSERT INTO public.user_saved_listings (user_id, listing_id)
				SELECT $1, listing.id
				FROM public.listings listing
				WHERE (listing.slug = ANY($2::text[]) OR listing.public_listing_id::text = ANY($2::text[]))
				  AND listing.published_at IS NOT NULL
				  AND listing.deleted_at IS NULL
				  AND listing.is_active = true
				  AND listing.listing_status = 'active'
				  AND listing.moderation_status = 'approved'
				ON CONFLICT (user_id, listing_id) DO NOTHING
			`, claims.UID, pq.Array(identifiers)); err != nil {
				return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot merge saved listings"})
			}
		}

		listings, references, err := loadSavedListings(ctx, db, claims.UID)
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot load saved listings"})
		}
		return c.JSON(fiber.Map{
			"listings":   listings,
			"references": references,
			"total":      len(listings),
			"merged":     len(identifiers),
		})
	}
}

func loadSavedListings(ctx context.Context, db *sql.DB, userID int64) ([]searchListing, []savedListingReference, error) {
	rows, err := db.QueryContext(ctx, `
		SELECT
			listing.id, listing.public_listing_id::text, COALESCE(listing.slug, ''), listing.title,
			COALESCE(listing.description, ''), listing.property_type_code,
			COALESCE(listing.accommodation_model, ''), listing.listing_type,
			COALESCE(listing.custom_project_name, ''),
			trim(concat_ws(' ', listing.address_line1, listing.address_line2)),
			COALESCE(listing.province_name, ''), COALESCE(listing.district_name, ''),
			listing.sale_price, listing.rent_price_monthly, listing.bedroom_count, listing.bathroom_count,
			listing.usable_area_sqm, listing.land_area_sqm, listing.pet_allowed,
			listing.latitude, listing.longitude, listing.published_at,
			COALESCE(listing.space_type_code, ''),
			COALESCE(space_types.space_type_codes,
				CASE WHEN NULLIF(listing.space_type_code, '') IS NULL THEN ARRAY[]::text[] ELSE ARRAY[listing.space_type_code] END),
			COALESCE(primary_media.media_url, ''),
			COALESCE(event_details.event_name, ''), COALESCE(event_details.venue_floor_label, ''),
			COALESCE(event_rounds.round_count, 0), event_rounds.starts_on, event_rounds.ends_on,
			COALESCE((category_details.details->>'price_on_request')::boolean, event_details.price_on_request, false),
			listing.is_verified, COALESCE(source.source_type, '')
		FROM public.user_saved_listings saved
		JOIN public.listings listing ON listing.id = saved.listing_id
		LEFT JOIN public.listing_category_details category_details ON category_details.listing_id = listing.id
		LEFT JOIN public.listing_event_details event_details ON event_details.listing_id = listing.id
		LEFT JOIN LATERAL (
			SELECT array_agg(space_type_code ORDER BY is_primary DESC, sort_order, space_type_code) AS space_type_codes
			FROM public.listing_space_types
			WHERE listing_id = listing.id
		) space_types ON true
		LEFT JOIN LATERAL (
			SELECT count(*)::integer AS round_count, min(starts_on) AS starts_on, max(ends_on) AS ends_on
			FROM public.listing_event_rounds
			WHERE listing_id = listing.id AND availability_status IN ('open', 'limited', 'waitlist')
		) event_rounds ON true
		LEFT JOIN LATERAL (
			SELECT COALESCE(NULLIF(large_url, ''), NULLIF(medium_url, ''), NULLIF(file_url, ''), NULLIF(original_url, ''), '') AS media_url
			FROM public.listing_media
			WHERE listing_id = listing.id AND is_active = true AND deleted_at IS NULL AND media_type = 'image'
			ORDER BY is_primary DESC, sort_order, id
			LIMIT 1
		) primary_media ON true
		LEFT JOIN LATERAL (
			SELECT source_type
			FROM public.listing_sources
			WHERE listing_id = listing.id
			ORDER BY CASE source_type WHEN 'owner' THEN 0 ELSE 1 END, id
			LIMIT 1
		) source ON true
		WHERE saved.user_id = $1
		  AND listing.published_at IS NOT NULL
		  AND listing.deleted_at IS NULL
		  AND listing.is_active = true
		  AND listing.listing_status = 'active'
		  AND listing.moderation_status = 'approved'
		ORDER BY saved.created_at DESC, listing.id DESC
	`, userID)
	if err != nil {
		return nil, nil, err
	}
	defer rows.Close()

	listings := make([]searchListing, 0)
	references := make([]savedListingReference, 0)
	for rows.Next() {
		var item searchListing
		var sale, rent, area, landArea, latitude, longitude sql.NullFloat64
		var bedrooms, bathrooms sql.NullInt64
		var publishedAt, eventStartsOn, eventEndsOn sql.NullTime
		if err := rows.Scan(
			&item.ID, &item.PublicListingID, &item.Slug, &item.Title,
			&item.Description, &item.PropertyTypeCode, &item.AccommodationModel, &item.ListingType,
			&item.ProjectName, &item.Address, &item.Province, &item.District,
			&sale, &rent, &bedrooms, &bathrooms, &area, &landArea, &item.PetAllowed,
			&latitude, &longitude, &publishedAt, &item.SpaceTypeCode, pq.Array(&item.SpaceTypeCodes),
			&item.PrimaryImageURL, &item.EventName, &item.EventFloorLabel, &item.EventRoundCount,
			&eventStartsOn, &eventEndsOn, &item.PriceOnRequest, &item.IsVerified, &item.SourceType,
		); err != nil {
			return nil, nil, err
		}
		if sale.Valid {
			item.SalePrice = &sale.Float64
		}
		if rent.Valid {
			item.RentPriceMonthly = &rent.Float64
		}
		if bedrooms.Valid {
			value := int(bedrooms.Int64)
			item.BedroomCount = &value
		}
		if bathrooms.Valid {
			value := int(bathrooms.Int64)
			item.BathroomCount = &value
		}
		if area.Valid {
			item.UsableAreaSqm = &area.Float64
		}
		if landArea.Valid {
			item.LandAreaSqm = &landArea.Float64
		}
		if latitude.Valid {
			item.Latitude = &latitude.Float64
		}
		if longitude.Valid {
			item.Longitude = &longitude.Float64
		}
		if publishedAt.Valid {
			item.PublishedAt = &publishedAt.Time
		}
		if eventStartsOn.Valid {
			item.EventStartsOn = &eventStartsOn.Time
		}
		if eventEndsOn.Valid {
			item.EventEndsOn = &eventEndsOn.Time
		}
		listings = append(listings, item)
		references = append(references, savedListingReference{PublicListingID: item.PublicListingID, Slug: item.Slug})
	}
	if err := rows.Err(); err != nil {
		return nil, nil, err
	}
	return listings, references, nil
}

func cleanSavedListingIdentifier(value string) string {
	value = strings.TrimSpace(value)
	if value == "" || len(value) > 160 || strings.Contains(value, "/") {
		return ""
	}
	return value
}

func cleanSavedListingIdentifiers(values []string) []string {
	cleaned := make([]string, 0, len(values))
	seen := make(map[string]bool, len(values))
	for _, value := range values {
		identifier := cleanSavedListingIdentifier(value)
		if identifier == "" || seen[identifier] {
			continue
		}
		seen[identifier] = true
		cleaned = append(cleaned, identifier)
	}
	return cleaned
}
