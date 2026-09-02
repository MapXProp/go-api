package handlers

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"strings"
	"time"

	"github.com/gofiber/fiber/v2"
)

type adminReviewListingResponse struct {
	PublicListingID       string                     `json:"public_listing_id"`
	Slug                  string                     `json:"slug"`
	Title                 string                     `json:"title"`
	Description           string                     `json:"description"`
	PropertyTypeCode      string                     `json:"property_type_code"`
	PropertyTypeNameTH    string                     `json:"property_type_name_th"`
	PropertyTypeNameEN    string                     `json:"property_type_name_en"`
	ListingType           string                     `json:"listing_type"`
	ListingStatus         string                     `json:"listing_status"`
	ModerationStatus      string                     `json:"moderation_status"`
	ModerationNote        string                     `json:"moderation_note"`
	Address               string                     `json:"address"`
	Price                 *float64                   `json:"price,omitempty"`
	PriceUnit             string                     `json:"price_unit"`
	Currency              string                     `json:"currency"`
	PrimaryImageURL       string                     `json:"primary_image_url"`
	ImageCount            int                        `json:"image_count"`
	VideoCount            int                        `json:"video_count"`
	PanoramaCount         int                        `json:"panorama_count"`
	OwnerPublicUserID     string                     `json:"owner_public_user_id"`
	OwnerName             string                     `json:"owner_name"`
	OwnerEmail            string                     `json:"owner_email"`
	ContactName           string                     `json:"contact_name"`
	ContactPhone          string                     `json:"contact_phone"`
	ContactEmail          string                     `json:"contact_email"`
	CustomProjectName     string                     `json:"custom_project_name"`
	UsableAreaSqm         *float64                   `json:"usable_area_sqm,omitempty"`
	LandAreaSqm           *float64                   `json:"land_area_sqm,omitempty"`
	BedroomCount          *int                       `json:"bedroom_count,omitempty"`
	BathroomCount         *int                       `json:"bathroom_count,omitempty"`
	ParkingCount          *int                       `json:"parking_count,omitempty"`
	CategoryDetails       json.RawMessage            `json:"category_details"`
	CreatedAt             time.Time                  `json:"created_at"`
	UpdatedAt             time.Time                  `json:"updated_at"`
	ModerationSubmittedAt *time.Time                 `json:"moderation_submitted_at,omitempty"`
	ModeratedAt           *time.Time                 `json:"moderated_at,omitempty"`
	PublishedAt           *time.Time                 `json:"published_at,omitempty"`
	Media                 []adminReviewMediaResponse `json:"media,omitempty"`
	Offers                []adminReviewOfferResponse `json:"offers,omitempty"`
}

type adminReviewMediaResponse struct {
	ID        int64  `json:"id"`
	MediaType string `json:"media_type"`
	URL       string `json:"url"`
	IsPrimary bool   `json:"is_primary"`
	SortOrder int    `json:"sort_order"`
}

type adminReviewOfferResponse struct {
	OfferType string   `json:"offer_type"`
	Amount    *float64 `json:"amount,omitempty"`
	PriceUnit string   `json:"price_unit"`
	Currency  string   `json:"currency"`
}

type updateListingModerationRequest struct {
	Action string `json:"action"`
	Note   string `json:"note"`
}

func GetAdminReviewListings(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		_, ctx, cancel, status, err := requireSuperAdmin(c, db)
		if err != nil {
			return platformRoleAuthError(c, status, err)
		}
		defer cancel()

		moderationStatus := strings.ToLower(strings.TrimSpace(c.Query("status", "pending")))
		if !inSet(moderationStatus, "pending", "approved", "rejected", "all") {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid moderation status"})
		}
		query := strings.TrimSpace(c.Query("q"))
		if len([]rune(query)) > 120 {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "search query is too long"})
		}
		limit := c.QueryInt("limit", 30)
		if limit < 1 || limit > 100 {
			limit = 30
		}
		offset := c.QueryInt("offset", 0)
		if offset < 0 {
			offset = 0
		}

		rows, err := db.QueryContext(ctx, adminReviewListingSelect+`
			WHERE l.deleted_at IS NULL
			  AND ($1 = 'all' OR l.moderation_status = $1)
			  AND (
				$2 = ''
				OR l.title ILIKE '%' || $2 || '%'
				OR u.email ILIKE '%' || $2 || '%'
				OR COALESCE(l.custom_project_name, '') ILIKE '%' || $2 || '%'
			  )
			ORDER BY
				CASE WHEN $1 = 'pending' THEN COALESCE(l.moderation_submitted_at, l.updated_at) END ASC,
				CASE WHEN $1 <> 'pending' THEN COALESCE(l.moderated_at, l.published_at, l.updated_at) END DESC,
				l.id DESC
			LIMIT $3 OFFSET $4
		`, moderationStatus, query, limit, offset)
		if err != nil {
			fmt.Println("Read listing review queue error:", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot load listing review queue"})
		}
		defer rows.Close()

		listings := make([]adminReviewListingResponse, 0, limit)
		total := 0
		for rows.Next() {
			var listing adminReviewListingResponse
			if err := scanAdminReviewListing(rows, &listing, &total); err != nil {
				fmt.Println("Scan listing review queue error:", err)
				return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read listing review queue"})
			}
			listings = append(listings, listing)
		}
		if err := rows.Err(); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read listing review queue"})
		}

		var pendingCount, approvedCount, rejectedCount int
		if err := db.QueryRowContext(ctx, `
			SELECT
				count(*) FILTER (WHERE moderation_status = 'pending'),
				count(*) FILTER (WHERE moderation_status = 'approved'),
				count(*) FILTER (WHERE moderation_status = 'rejected')
			FROM public.listings
			WHERE deleted_at IS NULL
		`).Scan(&pendingCount, &approvedCount, &rejectedCount); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read listing review counts"})
		}

		return c.JSON(fiber.Map{
			"listings": listings,
			"total":    total,
			"limit":    limit,
			"offset":   offset,
			"counts": fiber.Map{
				"pending":  pendingCount,
				"approved": approvedCount,
				"rejected": rejectedCount,
			},
		})
	}
}

func GetAdminReviewListing(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		_, ctx, cancel, status, err := requireSuperAdmin(c, db)
		if err != nil {
			return platformRoleAuthError(c, status, err)
		}
		defer cancel()

		publicListingID := strings.TrimSpace(c.Params("publicListingID"))
		if publicListingID == "" || len(publicListingID) > 128 {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid listing ID"})
		}

		row := db.QueryRowContext(ctx, adminReviewListingSelect+`
			WHERE l.public_listing_id::text = $1
			  AND l.deleted_at IS NULL
			LIMIT 1
		`, publicListingID)
		var listing adminReviewListingResponse
		var ignoredTotal int
		if err := scanAdminReviewListing(row, &listing, &ignoredTotal); err == sql.ErrNoRows {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{"error": "listing not found"})
		} else if err != nil {
			fmt.Println("Read listing review detail error:", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot load listing review details"})
		}

		listing.Media, err = loadAdminReviewMedia(ctx, db, publicListingID)
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot load listing media"})
		}
		listing.Offers, err = loadAdminReviewOffers(ctx, db, publicListingID)
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot load listing offers"})
		}

		return c.JSON(fiber.Map{"listing": listing})
	}
}

func UpdateListingModeration(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, status, err := requireSuperAdmin(c, db)
		if err != nil {
			return platformRoleAuthError(c, status, err)
		}
		defer cancel()

		publicListingID := strings.TrimSpace(c.Params("publicListingID"))
		if publicListingID == "" || len(publicListingID) > 128 {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid listing ID"})
		}
		var req updateListingModerationRequest
		if err := c.BodyParser(&req); err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid moderation payload"})
		}
		req.Action = strings.ToLower(strings.TrimSpace(req.Action))
		req.Note = strings.TrimSpace(req.Note)
		if !inSet(req.Action, "approve", "request_changes", "unapprove") {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid moderation action"})
		}
		if req.Action != "approve" && req.Note == "" {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "a reason is required when unapproving a listing"})
		}
		if len([]rune(req.Note)) > 1000 {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "moderation note is too long"})
		}

		tx, err := db.BeginTx(ctx, nil)
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot update listing moderation"})
		}
		defer tx.Rollback()

		var listingID, ownerUserID int64
		var title, slug, previousStatus string
		err = tx.QueryRowContext(ctx, `
			SELECT id, user_id, title, COALESCE(NULLIF(slug, ''), 'listing-' || id::text), moderation_status
			FROM public.listings
			WHERE public_listing_id::text = $1
			  AND deleted_at IS NULL
			FOR UPDATE
		`, publicListingID).Scan(&listingID, &ownerUserID, &title, &slug, &previousStatus)
		if err == sql.ErrNoRows {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{"error": "listing not found"})
		}
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot load listing moderation state"})
		}

		newStatus := "approved"
		auditAction := "approved"
		notificationType := "listing_published"
		titleTH := "ประกาศของคุณเผยแพร่แล้ว"
		titleEN := "Your listing is now live"
		bodyTH := fmt.Sprintf("ประกาศ “%s” ผ่านการตรวจสอบและเผยแพร่บน MapXProp แล้ว", title)
		bodyEN := fmt.Sprintf("Your listing “%s” was approved and is now live on MapXProp.", title)
		actionURL := "/real-estate-listings/" + slug
		if req.Action != "approve" {
			newStatus = "rejected"
			auditAction = "changes_requested"
			notificationType = "listing_changes_requested"
			titleTH = "ประกาศถูกซ่อนและต้องแก้ไข"
			titleEN = "Your listing was hidden and needs changes"
			bodyTH = fmt.Sprintf("ประกาศ “%s” ถูกซ่อนจากหน้าเผยแพร่: %s", title, req.Note)
			bodyEN = fmt.Sprintf("Your listing “%s” was hidden from public pages: %s", title, req.Note)
			actionURL = "/account-listings"
		}

		if previousStatus == newStatus {
			return c.JSON(fiber.Map{
				"success":           true,
				"unchanged":         true,
				"moderation_status": newStatus,
			})
		}

		if req.Action == "approve" {
			_, err = tx.ExecContext(ctx, `
				UPDATE public.listings
				SET listing_status = 'active',
				    moderation_status = 'approved',
				    is_active = true,
				    published_at = now(),
				    moderated_at = now(),
				    moderated_by_user_id = $1,
				    moderation_note = NULL,
				    updated_at = now()
				WHERE id = $2
			`, claims.UID, listingID)
		} else {
			_, err = tx.ExecContext(ctx, `
				UPDATE public.listings
				SET moderation_status = 'rejected',
				    published_at = NULL,
				    moderated_at = now(),
				    moderated_by_user_id = $1,
				    moderation_note = $2,
				    updated_at = now()
				WHERE id = $3
			`, claims.UID, req.Note, listingID)
		}
		if err != nil {
			fmt.Println("Update listing moderation error:", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot update listing moderation"})
		}

		if _, err := tx.ExecContext(ctx, `
			INSERT INTO public.listing_moderation_audit (
				listing_id, previous_status, new_status, action, note, moderated_by_user_id
			) VALUES ($1, $2, $3, $4, $5, $6)
		`, listingID, previousStatus, newStatus, auditAction, listingNullString(req.Note), claims.UID); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot record listing moderation"})
		}

		if _, err := tx.ExecContext(ctx, `
			INSERT INTO public.user_notifications (
				user_id, notification_type, title_th, title_en, body_th, body_en, action_url, listing_id
			) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
		`, ownerUserID, notificationType, titleTH, titleEN, bodyTH, bodyEN, actionURL, listingID); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot notify listing owner"})
		}

		if err := tx.Commit(); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot finish listing moderation"})
		}

		return c.JSON(fiber.Map{
			"success":           true,
			"unchanged":         false,
			"moderation_status": newStatus,
			"published":         newStatus == "approved",
		})
	}
}

const adminReviewListingSelect = `
	SELECT
		l.public_listing_id::text,
		COALESCE(NULLIF(l.slug, ''), 'listing-' || l.id::text),
		l.title,
		COALESCE(l.description, ''),
		l.property_type_code,
		COALESCE(pt.name_th, l.property_type_code),
		COALESCE(pt.name_en, l.property_type_code),
		l.listing_type,
		l.listing_status,
		l.moderation_status,
		COALESCE(l.moderation_note, ''),
		concat_ws(', ',
			NULLIF(l.custom_project_name, ''), NULLIF(l.address_line1, ''), NULLIF(l.road, ''),
			NULLIF(l.subdistrict_name, ''), NULLIF(l.district_name, ''), NULLIF(l.province_name, '')
		),
		COALESCE(offer.amount, l.rent_price_monthly, l.sale_price, l.rent_price_daily),
		COALESCE(offer.price_unit, l.price_unit, ''),
		COALESCE(offer.currency_code, 'THB'),
		COALESCE(media.primary_url, ''),
		COALESCE(media.image_count, 0),
		COALESCE(media.video_count, 0),
		COALESCE(media.panorama_count, 0),
		u.public_user_id::text,
		trim(concat_ws(' ', NULLIF(u.name, ''), NULLIF(u.surname, ''))),
		u.email,
		COALESCE(l.contact_name, ''),
		COALESCE(l.contact_phone, ''),
		COALESCE(l.contact_email, ''),
		COALESCE(l.custom_project_name, ''),
		l.usable_area_sqm,
		l.land_area_sqm,
		l.bedroom_count,
		l.bathroom_count,
		l.parking_count,
		COALESCE(lcd.details, '{}'::jsonb),
		l.created_at,
		l.updated_at,
		l.moderation_submitted_at,
		l.moderated_at,
		l.published_at,
		count(*) OVER()
	FROM public.listings l
	JOIN public.auth_users u ON u.id = l.user_id
	LEFT JOIN public.property_types pt ON pt.code = l.property_type_code
	LEFT JOIN public.listing_category_details lcd ON lcd.listing_id = l.id
	LEFT JOIN LATERAL (
		SELECT amount, price_unit, currency_code
		FROM public.listing_offers
		WHERE listing_id = l.id
		ORDER BY CASE offer_type WHEN 'rent' THEN 0 WHEN 'sale' THEN 1 ELSE 2 END, id
		LIMIT 1
	) offer ON true
	LEFT JOIN LATERAL (
		SELECT
			max(COALESCE(NULLIF(thumbnail_url, ''), NULLIF(thumb_url, ''), NULLIF(medium_url, ''), NULLIF(file_url, ''), NULLIF(original_url, ''))) FILTER (WHERE is_primary) AS primary_url,
			count(*) FILTER (WHERE media_type = 'image') AS image_count,
			count(*) FILTER (WHERE media_type = 'video') AS video_count,
			count(*) FILTER (WHERE media_type IN ('360', 'panorama')) AS panorama_count
		FROM public.listing_media
		WHERE listing_id = l.id AND is_active = true AND deleted_at IS NULL
	) media ON true
`

type adminReviewListingScanner interface {
	Scan(dest ...any) error
}

func scanAdminReviewListing(scanner adminReviewListingScanner, listing *adminReviewListingResponse, total *int) error {
	var price, usableArea, landArea sql.NullFloat64
	var bedroom, bathroom, parking sql.NullInt64
	var submittedAt, moderatedAt, publishedAt sql.NullTime
	var rawDetails []byte
	if err := scanner.Scan(
		&listing.PublicListingID, &listing.Slug, &listing.Title, &listing.Description,
		&listing.PropertyTypeCode, &listing.PropertyTypeNameTH, &listing.PropertyTypeNameEN,
		&listing.ListingType, &listing.ListingStatus, &listing.ModerationStatus, &listing.ModerationNote,
		&listing.Address, &price, &listing.PriceUnit, &listing.Currency, &listing.PrimaryImageURL,
		&listing.ImageCount, &listing.VideoCount, &listing.PanoramaCount,
		&listing.OwnerPublicUserID, &listing.OwnerName, &listing.OwnerEmail,
		&listing.ContactName, &listing.ContactPhone, &listing.ContactEmail, &listing.CustomProjectName,
		&usableArea, &landArea, &bedroom, &bathroom, &parking, &rawDetails,
		&listing.CreatedAt, &listing.UpdatedAt, &submittedAt, &moderatedAt, &publishedAt, total,
	); err != nil {
		return err
	}
	listing.CategoryDetails = json.RawMessage(rawDetails)
	if price.Valid {
		listing.Price = &price.Float64
	}
	if usableArea.Valid {
		listing.UsableAreaSqm = &usableArea.Float64
	}
	if landArea.Valid {
		listing.LandAreaSqm = &landArea.Float64
	}
	if bedroom.Valid {
		value := int(bedroom.Int64)
		listing.BedroomCount = &value
	}
	if bathroom.Valid {
		value := int(bathroom.Int64)
		listing.BathroomCount = &value
	}
	if parking.Valid {
		value := int(parking.Int64)
		listing.ParkingCount = &value
	}
	if submittedAt.Valid {
		listing.ModerationSubmittedAt = &submittedAt.Time
	}
	if moderatedAt.Valid {
		listing.ModeratedAt = &moderatedAt.Time
	}
	if publishedAt.Valid {
		listing.PublishedAt = &publishedAt.Time
	}
	return nil
}

func loadAdminReviewMedia(ctx context.Context, db *sql.DB, publicListingID string) ([]adminReviewMediaResponse, error) {
	rows, err := db.QueryContext(ctx, `
		SELECT m.id, m.media_type,
			COALESCE(NULLIF(m.original_url, ''), NULLIF(m.file_url, ''), NULLIF(m.large_url, ''), ''),
			m.is_primary, m.sort_order
		FROM public.listing_media m
		JOIN public.listings l ON l.id = m.listing_id
		WHERE l.public_listing_id::text = $1
		  AND l.deleted_at IS NULL
		  AND m.is_active = true
		  AND m.deleted_at IS NULL
		ORDER BY m.is_primary DESC, m.sort_order, m.id
	`, publicListingID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	media := make([]adminReviewMediaResponse, 0)
	for rows.Next() {
		var item adminReviewMediaResponse
		if err := rows.Scan(&item.ID, &item.MediaType, &item.URL, &item.IsPrimary, &item.SortOrder); err != nil {
			return nil, err
		}
		media = append(media, item)
	}
	return media, rows.Err()
}

func loadAdminReviewOffers(ctx context.Context, db *sql.DB, publicListingID string) ([]adminReviewOfferResponse, error) {
	rows, err := db.QueryContext(ctx, `
		SELECT o.offer_type, o.amount, o.price_unit, COALESCE(o.currency_code, 'THB')
		FROM public.listing_offers o
		JOIN public.listings l ON l.id = o.listing_id
		WHERE l.public_listing_id::text = $1 AND l.deleted_at IS NULL
		ORDER BY o.id
	`, publicListingID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	offers := make([]adminReviewOfferResponse, 0)
	for rows.Next() {
		var item adminReviewOfferResponse
		var amount sql.NullFloat64
		if err := rows.Scan(&item.OfferType, &amount, &item.PriceUnit, &item.Currency); err != nil {
			return nil, err
		}
		if amount.Valid {
			item.Amount = &amount.Float64
		}
		offers = append(offers, item)
	}
	return offers, rows.Err()
}
