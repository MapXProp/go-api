package handlers

import (
	"context"
	"database/sql"
	"strings"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
)

type listingViewRequest struct {
	EventID string `json:"event_id"`
	Source  string `json:"source"`
}

func isAutomatedListingView(userAgent string) bool {
	ua := strings.ToLower(strings.TrimSpace(userAgent))
	if ua == "" {
		return true
	}
	for _, marker := range []string{"bot", "crawler", "spider", "headless", "preview", "lighthouse", "curl/", "wget/", "python-", "go-http-client"} {
		if strings.Contains(ua, marker) {
			return true
		}
	}
	return false
}

// This is a client-confirmed opening, never a side effect of a GET/prefetch.
// An event ID deduplicates transport retries; every new opening counts again.
func RecordListingView(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		c.Set("Cache-Control", "no-store")
		if isAutomatedListingView(c.Get("User-Agent")) {
			return c.SendStatus(fiber.StatusNoContent)
		}
		if c.Get("Sec-Fetch-Site") == "cross-site" {
			return c.SendStatus(fiber.StatusForbidden)
		}
		if !strings.HasPrefix(strings.ToLower(c.Get("Content-Type")), "application/json") || len(c.Body()) > 512 {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid view payload"})
		}
		listingID, err := uuid.Parse(c.Params("publicListingID"))
		if err != nil || listingID == uuid.Nil {
			return c.SendStatus(fiber.StatusBadRequest)
		}
		var payload listingViewRequest
		if err := c.BodyParser(&payload); err != nil {
			return c.SendStatus(fiber.StatusBadRequest)
		}
		eventID, err := uuid.Parse(payload.EventID)
		if err != nil || eventID == uuid.Nil {
			return c.SendStatus(fiber.StatusBadRequest)
		}
		switch payload.Source {
		case "listing_page", "map_preview", "map_modal":
		default:
			return c.SendStatus(fiber.StatusBadRequest)
		}
		ctx, cancel := context.WithTimeout(context.Background(), 3*time.Second)
		defer cancel()
		var count int64
		var counted bool
		err = db.QueryRowContext(ctx, `SELECT view_count, counted FROM public.record_listing_view($1, $2, $3)`,
			listingID.String(), eventID.String(), payload.Source).Scan(&count, &counted)
		if err == sql.ErrNoRows {
			return c.SendStatus(fiber.StatusNotFound)
		}
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot record listing view"})
		}
		return c.JSON(fiber.Map{"view_count": count, "counted": counted})
	}
}
