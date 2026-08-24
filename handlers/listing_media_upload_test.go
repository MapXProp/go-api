package handlers

import (
	"net/http/httptest"
	"testing"

	"github.com/gofiber/fiber/v2"
)

func TestUploadListingMediaRequiresAuthentication(t *testing.T) {
	app := fiber.New()
	app.Post("/listing-media", UploadListingMedia(nil))

	response, err := app.Test(httptest.NewRequest("POST", "/listing-media", nil))
	if err != nil {
		t.Fatalf("request failed: %v", err)
	}
	if response.StatusCode != fiber.StatusUnauthorized {
		t.Fatalf("expected status %d, got %d", fiber.StatusUnauthorized, response.StatusCode)
	}
}
