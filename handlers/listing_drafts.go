package handlers

import (
	"context"
	"database/sql"
	"encoding/json"
	"time"

	"github.com/gofiber/fiber/v2"
)

type listingDraftRequest struct {
	Data        map[string]any `json:"data"`
	CurrentStep int            `json:"current_step"`
}

func GetListingDraft(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, err := authenticatedListingDraftRequest(c, db)
		if cancel != nil {
			defer cancel()
		}
		if err != nil {
			return c.Status(401).JSON(fiber.Map{"error": err.Error()})
		}

		var data []byte
		var currentStep int
		var updatedAt, expiresAt time.Time
		now := time.Now().UTC()
		var expired bool
		err = db.QueryRowContext(ctx, `
			SELECT EXISTS (
				SELECT 1 FROM public.listing_drafts
				WHERE user_id = $1 AND expires_at <= $2
			)
		`, claims.UID, now).Scan(&expired)
		if err != nil {
			return c.Status(500).JSON(fiber.Map{"error": "cannot check listing draft"})
		}
		if expired {
			if _, err := deleteListingDraftForUser(ctx, db, claims.UID); err != nil {
				return c.Status(500).JSON(fiber.Map{"error": "cannot expire listing draft"})
			}
			return c.JSON(fiber.Map{"draft": nil, "expired": true})
		}

		err = db.QueryRowContext(ctx, `
			SELECT data, current_step, updated_at, expires_at
			FROM public.listing_drafts
			WHERE user_id = $1 AND expires_at > $2
		`, claims.UID, now).Scan(&data, &currentStep, &updatedAt, &expiresAt)
		if err == sql.ErrNoRows {
			return c.JSON(fiber.Map{"draft": nil})
		}
		if err != nil {
			return c.Status(500).JSON(fiber.Map{"error": "cannot load listing draft"})
		}

		var draftData map[string]any
		if err := json.Unmarshal(data, &draftData); err != nil {
			return c.Status(500).JSON(fiber.Map{"error": "invalid saved listing draft"})
		}

		return c.JSON(fiber.Map{"draft": fiber.Map{
			"data":         draftData,
			"current_step": currentStep,
			"updated_at":   updatedAt,
			"expires_at":   expiresAt,
		}})
	}
}

func UpsertListingDraft(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, err := authenticatedListingDraftRequest(c, db)
		if cancel != nil {
			defer cancel()
		}
		if err != nil {
			return c.Status(401).JSON(fiber.Map{"error": err.Error()})
		}

		var req listingDraftRequest
		if err := c.BodyParser(&req); err != nil || req.Data == nil {
			return c.Status(400).JSON(fiber.Map{"error": "invalid listing draft"})
		}
		if req.CurrentStep < 1 || req.CurrentStep > 4 {
			return c.Status(400).JSON(fiber.Map{"error": "invalid listing draft step"})
		}

		encoded, err := json.Marshal(req.Data)
		if err != nil || len(encoded) > 512*1024 {
			return c.Status(400).JSON(fiber.Map{"error": "listing draft is too large"})
		}

		var updatedAt, expiresAt time.Time
		err = db.QueryRowContext(ctx, `
			INSERT INTO public.listing_drafts (user_id, data, current_step, expires_at)
			VALUES ($1, $2::jsonb, $3, now() + interval '48 hours')
			ON CONFLICT (user_id) DO UPDATE SET
				data = EXCLUDED.data,
				current_step = EXCLUDED.current_step,
				updated_at = now(),
				expires_at = now() + interval '48 hours'
			RETURNING updated_at, expires_at
		`, claims.UID, encoded, req.CurrentStep).Scan(&updatedAt, &expiresAt)
		if err != nil {
			return c.Status(500).JSON(fiber.Map{"error": "cannot save listing draft"})
		}

		return c.JSON(fiber.Map{"success": true, "updated_at": updatedAt, "expires_at": expiresAt})
	}
}

func DeleteListingDraft(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, err := authenticatedListingDraftRequest(c, db)
		if cancel != nil {
			defer cancel()
		}
		if err != nil {
			return c.Status(401).JSON(fiber.Map{"error": err.Error()})
		}

		if _, err := deleteListingDraftForUser(ctx, db, claims.UID); err != nil {
			return c.Status(500).JSON(fiber.Map{"error": "cannot clear listing draft"})
		}
		return c.SendStatus(fiber.StatusNoContent)
	}
}

func authenticatedListingDraftRequest(c *fiber.Ctx, db *sql.DB) (*accessTokenClaims, context.Context, context.CancelFunc, error) {
	token := accessTokenFromRequest(c)
	if token == "" {
		return nil, nil, nil, fiber.ErrUnauthorized
	}

	claims, err := validateAccessToken(token)
	if err != nil {
		return nil, nil, nil, fiber.ErrUnauthorized
	}

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	if err := verifyActiveSession(ctx, db, claims); err != nil {
		cancel()
		return nil, nil, nil, fiber.ErrUnauthorized
	}
	return claims, ctx, cancel, nil
}
