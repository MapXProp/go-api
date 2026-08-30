package handlers

import (
	"context"
	"database/sql"
	"fmt"
	"strings"
	"time"
	"unicode"

	"estate-map-api/models"

	"github.com/gofiber/fiber/v2"
	"golang.org/x/crypto/bcrypt"
)

type updateMyProfileRequest struct {
	Name    string `json:"name"`
	Surname string `json:"surname"`
}

type changeMyPasswordRequest struct {
	CurrentPassword string `json:"current_password"`
	NewPassword     string `json:"new_password"`
}

type myListingResponse struct {
	ID                 int64      `json:"id"`
	PublicListingID    string     `json:"public_listing_id"`
	Slug               string     `json:"slug"`
	Title              string     `json:"title"`
	PropertyTypeCode   string     `json:"property_type_code"`
	AccommodationModel string     `json:"accommodation_model"`
	ListingType        string     `json:"listing_type"`
	ListingStatus      string     `json:"listing_status"`
	ModerationStatus   string     `json:"moderation_status"`
	Address            string     `json:"address"`
	Price              *float64   `json:"price,omitempty"`
	PriceUnit          string     `json:"price_unit"`
	Currency           string     `json:"currency"`
	PrimaryImageURL    string     `json:"primary_image_url"`
	CreatedAt          time.Time  `json:"created_at"`
	UpdatedAt          time.Time  `json:"updated_at"`
	PublishedAt        *time.Time `json:"published_at,omitempty"`
}

func authenticatedAccountRequest(c *fiber.Ctx, db *sql.DB) (*accessTokenClaims, context.Context, context.CancelFunc, error) {
	token := accessTokenFromRequest(c)
	if token == "" {
		return nil, nil, nil, fmt.Errorf("missing authorization token")
	}

	claims, err := validateAccessToken(token)
	if err != nil {
		return nil, nil, nil, fmt.Errorf("invalid or expired token")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	if err := verifyActiveSession(ctx, db, claims); err != nil {
		cancel()
		return nil, nil, nil, fmt.Errorf("session revoked or expired")
	}

	return claims, ctx, cancel, nil
}

// UpdateMyProfile lets a signed-in user update only their public display name.
// Email changes intentionally use a separate verified-email flow.
func UpdateMyProfile(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, err := authenticatedAccountRequest(c, db)
		if err != nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": err.Error()})
		}
		defer cancel()

		var req updateMyProfileRequest
		if err := c.BodyParser(&req); err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid profile payload"})
		}
		req.Name = strings.TrimSpace(req.Name)
		req.Surname = strings.TrimSpace(req.Surname)
		if err := validateProfileName(req.Name, "name"); err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": err.Error()})
		}
		if err := validateProfileName(req.Surname, "surname"); err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": err.Error()})
		}

		var user models.UserPublic
		err = db.QueryRowContext(ctx, `
			UPDATE public.auth_users
			SET name = NULLIF($1, ''),
			    surname = NULLIF($2, ''),
			    updated_at = now()
			WHERE id = $3
			  AND public_user_id::text = $4
			  AND deleted_at IS NULL
			RETURNING public_user_id::text, COALESCE(name, ''), COALESCE(surname, ''), email
		`, req.Name, req.Surname, claims.UID, claims.Sub).Scan(
			&user.PublicUserID,
			&user.Name,
			&user.Surname,
			&user.Email,
		)
		if err == sql.ErrNoRows {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "user not found"})
		}
		if err != nil {
			fmt.Println("Update profile error:", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot update profile"})
		}

		return c.JSON(fiber.Map{"success": true, "user": user})
	}
}

func ChangeMyPassword(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, err := authenticatedAccountRequest(c, db)
		if err != nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": err.Error()})
		}
		defer cancel()

		var req changeMyPasswordRequest
		if err := c.BodyParser(&req); err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid password payload"})
		}
		if strings.TrimSpace(req.CurrentPassword) == "" {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "current password is required"})
		}
		if err := validateAccountPassword(req.NewPassword); err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": err.Error()})
		}
		if req.CurrentPassword == req.NewPassword {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "new password must be different"})
		}

		var passwordHash sql.NullString
		err = db.QueryRowContext(ctx, `
			SELECT password_hash
			FROM public.auth_users
			WHERE id = $1
			  AND public_user_id::text = $2
			  AND deleted_at IS NULL
			LIMIT 1
		`, claims.UID, claims.Sub).Scan(&passwordHash)
		if err == sql.ErrNoRows {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "user not found"})
		}
		if err != nil {
			fmt.Println("Read password error:", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot change password"})
		}
		if !passwordHash.Valid || passwordHash.String == "" {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "this account has no password to change"})
		}
		if err := bcrypt.CompareHashAndPassword([]byte(passwordHash.String), []byte(req.CurrentPassword)); err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "current password is incorrect"})
		}

		nextHash, err := bcrypt.GenerateFromPassword([]byte(req.NewPassword), bcrypt.DefaultCost)
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot change password"})
		}

		tx, err := db.BeginTx(ctx, nil)
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot change password"})
		}
		defer tx.Rollback()

		if _, err := tx.ExecContext(ctx, `
			UPDATE public.auth_users
			SET password_hash = $1,
			    password_changed_at = now(),
			    updated_at = now()
			WHERE id = $2
		`, string(nextHash), claims.UID); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot change password"})
		}
		if _, err := tx.ExecContext(ctx, `
			UPDATE public.auth_sessions
			SET revoked_at = now(), updated_at = now()
			WHERE user_id = $1
			  AND token_id <> $2
			  AND revoked_at IS NULL
		`, claims.UID, claims.JTI); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot secure existing sessions"})
		}
		if err := tx.Commit(); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot change password"})
		}

		return c.JSON(fiber.Map{"success": true})
	}
}

// GetMyListings gives an owner a complete view of their own listings,
// including pending moderation items that are deliberately hidden from public search.
func GetMyListings(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, err := authenticatedAccountRequest(c, db)
		if err != nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": err.Error()})
		}
		defer cancel()

		rows, err := db.QueryContext(ctx, `
			SELECT
				l.id,
				l.public_listing_id::text,
				COALESCE(NULLIF(l.slug, ''), 'listing-' || l.id::text),
				l.title,
				l.property_type_code,
				COALESCE(l.accommodation_model, ''),
				l.listing_type,
				l.listing_status,
				l.moderation_status,
				concat_ws(', ',
					NULLIF(l.custom_project_name, ''),
					NULLIF(l.address_line1, ''),
					NULLIF(l.address_line2, ''),
					NULLIF(l.province_name, ''),
					NULLIF(l.district_name, ''),
					NULLIF(l.subdistrict_name, '')
				),
				COALESCE(offer.amount, l.rent_price_monthly, l.sale_price, l.rent_price_daily),
				COALESCE(offer.price_unit, l.price_unit, ''),
				COALESCE(offer.currency_code, 'THB'),
				COALESCE(media.url, ''),
				l.created_at,
				l.updated_at,
				l.published_at
			FROM public.listings l
			LEFT JOIN LATERAL (
				SELECT amount, price_unit, currency_code
				FROM public.listing_offers
				WHERE listing_id = l.id
				ORDER BY CASE offer_type
					WHEN 'rent' THEN 0
					WHEN 'sale' THEN 1
					WHEN 'sublease' THEN 2
					ELSE 3
				END, id
				LIMIT 1
			) offer ON true
			LEFT JOIN LATERAL (
				SELECT COALESCE(
					NULLIF(thumbnail_url, ''),
					NULLIF(thumb_url, ''),
					NULLIF(medium_url, ''),
					NULLIF(file_url, ''),
					NULLIF(original_url, ''),
					''
				) AS url
				FROM public.listing_media
				WHERE listing_id = l.id
				  AND is_active = true
				  AND deleted_at IS NULL
				ORDER BY is_primary DESC, sort_order, id
				LIMIT 1
			) media ON true
			WHERE l.user_id = $1
			  AND l.deleted_at IS NULL
			ORDER BY l.updated_at DESC, l.id DESC
			LIMIT 200
		`, claims.UID)
		if err != nil {
			fmt.Println("Read my listings error:", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read your listings"})
		}
		defer rows.Close()

		listings := make([]myListingResponse, 0)
		for rows.Next() {
			var item myListingResponse
			var price sql.NullFloat64
			var publishedAt sql.NullTime
			if err := rows.Scan(
				&item.ID,
				&item.PublicListingID,
				&item.Slug,
				&item.Title,
				&item.PropertyTypeCode,
				&item.AccommodationModel,
				&item.ListingType,
				&item.ListingStatus,
				&item.ModerationStatus,
				&item.Address,
				&price,
				&item.PriceUnit,
				&item.Currency,
				&item.PrimaryImageURL,
				&item.CreatedAt,
				&item.UpdatedAt,
				&publishedAt,
			); err != nil {
				fmt.Println("Scan my listing error:", err)
				return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read your listings"})
			}
			if price.Valid {
				item.Price = &price.Float64
			}
			if publishedAt.Valid {
				item.PublishedAt = &publishedAt.Time
			}
			listings = append(listings, item)
		}
		if err := rows.Err(); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read your listings"})
		}

		return c.JSON(fiber.Map{"listings": listings})
	}
}

func validateProfileName(value, field string) error {
	if len([]rune(value)) > 120 {
		return fmt.Errorf("%s must be 120 characters or fewer", field)
	}
	return nil
}

func validateAccountPassword(value string) error {
	if len(value) < 8 {
		return fmt.Errorf("new password must be at least 8 characters")
	}

	var hasUpper, hasLower, hasNumber, hasSpecial bool
	for _, char := range value {
		switch {
		case unicode.IsUpper(char):
			hasUpper = true
		case unicode.IsLower(char):
			hasLower = true
		case unicode.IsDigit(char):
			hasNumber = true
		case unicode.IsPunct(char) || unicode.IsSymbol(char):
			hasSpecial = true
		}
	}
	if !hasUpper || !hasLower || !hasNumber || !hasSpecial {
		return fmt.Errorf("new password must include uppercase, lowercase, number, and special character")
	}
	return nil
}
