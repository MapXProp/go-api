package handlers

import (
	"database/sql"
	"fmt"
	"strings"

	"github.com/gofiber/fiber/v2"
)

// DeleteMyListing hides an owner's listing without removing the listing row,
// its category data, or any attached media. Keeping the original state intact
// makes a future audited restore possible by clearing deleted_at.
func DeleteMyListing(db *sql.DB) fiber.Handler {
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

		tx, err := db.BeginTx(ctx, nil)
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot delete listing"})
		}
		defer tx.Rollback()

		var (
			listingID int64
			deletedAt sql.NullTime
		)
		err = tx.QueryRowContext(ctx, `
			SELECT id, deleted_at
			FROM public.listings
			WHERE public_listing_id::text = $1
			  AND user_id = $2
			FOR UPDATE
		`, publicListingID, claims.UID).Scan(&listingID, &deletedAt)
		if err == sql.ErrNoRows {
			// Deliberately do not reveal whether a listing belongs to somebody else.
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{"error": "listing not found"})
		}
		if err != nil {
			fmt.Println("Read listing for soft delete error:", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot delete listing"})
		}

		alreadyDeleted := deletedAt.Valid
		if !alreadyDeleted {
			result, err := tx.ExecContext(ctx, `
				UPDATE public.listings
				SET deleted_at = now(), updated_at = now()
				WHERE id = $1
				  AND user_id = $2
				  AND deleted_at IS NULL
			`, listingID, claims.UID)
			if err != nil {
				fmt.Println("Soft delete listing error:", err)
				return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot delete listing"})
			}
			rowsAffected, err := result.RowsAffected()
			if err != nil || rowsAffected != 1 {
				return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot delete listing"})
			}
		}

		// A user may have navigated away from an edit form before deleting the
		// listing. Remove only that stale edit draft; unrelated/new drafts remain.
		if _, err := tx.ExecContext(ctx, `
			DELETE FROM public.listing_drafts
			WHERE user_id = $1
			  AND data->>'editingPublicListingId' = $2
		`, claims.UID, publicListingID); err != nil {
			fmt.Println("Clear deleted listing edit draft error:", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot delete listing"})
		}

		if err := tx.Commit(); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot delete listing"})
		}

		return c.JSON(fiber.Map{
			"success":           true,
			"public_listing_id": publicListingID,
			"already_deleted":   alreadyDeleted,
		})
	}
}
