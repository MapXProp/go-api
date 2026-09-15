package handlers

import (
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/gofiber/fiber/v2"
)

func TestListingViewsRejectNonOpeningsBeforeDatabase(t *testing.T) {
	const id = "098e13da-d87b-4203-9375-8f34d162cd9f"
	const validBody = `{"event_id":"cf9cfda7-91fb-4ef5-a410-64f0c312e4a7","source":"map_preview"}`
	for _, tc := range []struct {
		name, id, body, agent, site, contentType string
		status                                   int
	}{
		{"bot", id, validBody, "Googlebot", "same-origin", "application/json", 204},
		{"headless", id, validBody, "HeadlessChrome", "same-origin", "application/json", 204},
		{"missing agent", id, validBody, "", "same-origin", "application/json", 204},
		{"cross site", id, validBody, "Mozilla/5.0", "cross-site", "application/json", 403},
		{"invalid listing", "not-a-listing", validBody, "Mozilla/5.0", "same-origin", "application/json", 400},
		{"invalid event", id, `{"event_id":"bad","source":"map_preview"}`, "Mozilla/5.0", "same-origin", "application/json", 400},
		{"card impression", id, `{"event_id":"cf9cfda7-91fb-4ef5-a410-64f0c312e4a7","source":"card"}`, "Mozilla/5.0", "same-origin", "application/json", 400},
		{"bad JSON", id, `{`, "Mozilla/5.0", "same-origin", "application/json", 400},
		{"plain text", id, validBody, "Mozilla/5.0", "same-origin", "text/plain", 400},
		{"oversized body", id, strings.Repeat("x", 513), "Mozilla/5.0", "same-origin", "application/json", 400},
	} {
		t.Run(tc.name, func(t *testing.T) {
			app := fiber.New()
			app.Post("/listings/:publicListingID/views", RecordListingView(nil))
			req := httptest.NewRequest("POST", "/listings/"+tc.id+"/views", strings.NewReader(tc.body))
			req.Header.Set("User-Agent", tc.agent)
			req.Header.Set("Sec-Fetch-Site", tc.site)
			req.Header.Set("Content-Type", tc.contentType)
			res, err := app.Test(req)
			if err != nil {
				t.Fatal(err)
			}
			defer res.Body.Close()
			if res.StatusCode != tc.status {
				t.Fatalf("status = %d, want %d", res.StatusCode, tc.status)
			}
			if res.Header.Get("Cache-Control") != "no-store" {
				t.Fatal("view responses must not be cached")
			}
		})
	}
}
