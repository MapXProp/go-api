package handlers

import (
	"database/sql"
	"fmt"
	"strings"
	"time"

	"github.com/gofiber/fiber/v2"
)

type userNotificationResponse struct {
	ID               int64      `json:"id"`
	NotificationType string     `json:"notification_type"`
	TitleTH          string     `json:"title_th"`
	TitleEN          string     `json:"title_en"`
	BodyTH           string     `json:"body_th"`
	BodyEN           string     `json:"body_en"`
	ActionURL        string     `json:"action_url"`
	PublicListingID  string     `json:"public_listing_id,omitempty"`
	ListingTitle     string     `json:"listing_title,omitempty"`
	ReadAt           *time.Time `json:"read_at,omitempty"`
	CreatedAt        time.Time  `json:"created_at"`
}

func GetMyNotifications(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, err := authenticatedAccountRequest(c, db)
		if err != nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": err.Error()})
		}
		defer cancel()

		limit := c.QueryInt("limit", 30)
		if limit < 1 || limit > 100 {
			limit = 30
		}
		rows, err := db.QueryContext(ctx, `
			SELECT
				n.id,
				n.notification_type,
				n.title_th,
				n.title_en,
				n.body_th,
				n.body_en,
				COALESCE(n.action_url, ''),
				COALESCE(l.public_listing_id::text, ''),
				COALESCE(l.title, ''),
				n.read_at,
				n.created_at,
				count(*) FILTER (WHERE n.read_at IS NULL) OVER()
			FROM public.user_notifications n
			LEFT JOIN public.listings l ON l.id = n.listing_id
			WHERE n.user_id = $1
			ORDER BY n.created_at DESC, n.id DESC
			LIMIT $2
		`, claims.UID, limit)
		if err != nil {
			fmt.Println("Read notifications error:", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot load notifications"})
		}
		defer rows.Close()

		notifications := make([]userNotificationResponse, 0, limit)
		unreadCount := 0
		for rows.Next() {
			var item userNotificationResponse
			var readAt sql.NullTime
			if err := rows.Scan(
				&item.ID,
				&item.NotificationType,
				&item.TitleTH,
				&item.TitleEN,
				&item.BodyTH,
				&item.BodyEN,
				&item.ActionURL,
				&item.PublicListingID,
				&item.ListingTitle,
				&readAt,
				&item.CreatedAt,
				&unreadCount,
			); err != nil {
				return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read notifications"})
			}
			if readAt.Valid {
				item.ReadAt = &readAt.Time
			}
			notifications = append(notifications, item)
		}
		if err := rows.Err(); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read notifications"})
		}

		return c.JSON(fiber.Map{
			"notifications": notifications,
			"unread_count":  unreadCount,
		})
	}
}

func MarkMyNotificationRead(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, err := authenticatedAccountRequest(c, db)
		if err != nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": err.Error()})
		}
		defer cancel()

		notificationID := strings.TrimSpace(c.Params("notificationID"))
		if notificationID == "" || len(notificationID) > 32 {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid notification ID"})
		}
		result, err := db.ExecContext(ctx, `
			UPDATE public.user_notifications
			SET read_at = COALESCE(read_at, now())
			WHERE id::text = $1 AND user_id = $2
		`, notificationID, claims.UID)
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot update notification"})
		}
		rowsAffected, _ := result.RowsAffected()
		if rowsAffected == 0 {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{"error": "notification not found"})
		}
		return c.JSON(fiber.Map{"success": true})
	}
}

func MarkAllMyNotificationsRead(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, err := authenticatedAccountRequest(c, db)
		if err != nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": err.Error()})
		}
		defer cancel()

		result, err := db.ExecContext(ctx, `
			UPDATE public.user_notifications
			SET read_at = now()
			WHERE user_id = $1 AND read_at IS NULL
		`, claims.UID)
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot update notifications"})
		}
		rowsAffected, _ := result.RowsAffected()
		return c.JSON(fiber.Map{"success": true, "updated": rowsAffected})
	}
}
