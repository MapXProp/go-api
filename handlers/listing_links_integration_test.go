package handlers

import (
	"database/sql"
	"encoding/json"
	"net/http/httptest"
	"net/url"
	"os"
	"strings"
	"testing"

	"github.com/gofiber/fiber/v2"
	"github.com/joho/godotenv"
)

// This regression test only reads existing listings. It never runs migrations
// or seeds test data, and PostgreSQL rejects writes on every connection.
func TestListingPermalinksResolveOutsideCataloguePage(t *testing.T) {
	if os.Getenv("MAPXPROP_DB_READONLY_TEST") != "1" {
		t.Skip("set MAPXPROP_DB_READONLY_TEST=1 to check existing listings read-only")
	}
	env, err := godotenv.Read("../.env")
	if err != nil {
		t.Fatal(err)
	}
	u := &url.URL{Scheme: "postgres", Host: env["DB_HOST"] + ":" + env["DB_PORT"], Path: "/" + env["DB_NAME"], User: url.UserPassword(env["DB_USER"], env["DB_PASS"])}
	u.RawQuery = url.Values{"sslmode": {"disable"}, "connect_timeout": {"8"}, "options": {"-c default_transaction_read_only=on -c statement_timeout=8000"}}.Encode()
	db, err := sql.Open("postgres", u.String())
	if err != nil {
		t.Fatal("open read-only database")
	}
	defer db.Close()
	db.SetMaxOpenConns(2)
	var readOnly string
	if err := db.QueryRow("SHOW transaction_read_only").Scan(&readOnly); err != nil || readOnly != "on" {
		t.Fatal("read-only database guard failed")
	}

	type reference struct {
		ID     int64  `json:"id"`
		Slug   string `json:"slug"`
		Public string `json:"public_listing_id"`
	}
	var oldest reference
	if err := db.QueryRow(`SELECT id, slug, public_listing_id::text FROM listings
		WHERE published_at IS NOT NULL AND deleted_at IS NULL AND is_active
		AND listing_status='active' AND moderation_status='approved'
		AND (expires_at IS NULL OR expires_at>now())
		ORDER BY published_at, id LIMIT 1`).Scan(&oldest.ID, &oldest.Slug, &oldest.Public); err != nil {
		t.Fatal("read oldest public listing:", err)
	}
	app := fiber.New()
	app.Get("/search", SearchProperties(db))
	app.Get("/listings/:slug", GetListingBySlug(db))
	readResponse := func(path string, wantStatus int, target any) {
		t.Helper()
		response, err := app.Test(httptest.NewRequest("GET", path, nil), 15000)
		if err != nil {
			t.Fatal(err)
		}
		defer response.Body.Close()
		if response.StatusCode != wantStatus {
			t.Fatalf("%s: status %d, want %d", path, response.StatusCode, wantStatus)
		}
		if target != nil {
			if err := json.NewDecoder(response.Body).Decode(target); err != nil {
				t.Fatal(err)
			}
		}
	}
	type searchResponse struct {
		Listings []reference `json:"listings"`
		Total    int         `json:"total"`
	}
	var catalogue searchResponse
	readResponse("/search?limit=1", 200, &catalogue)
	if catalogue.Total < 2 || len(catalogue.Listings) != 1 || catalogue.Listings[0].ID == oldest.ID {
		t.Fatal("regression fixture needs an older listing outside the first catalogue page")
	}
	for _, ref := range []reference{oldest, catalogue.Listings[0]} {
		for _, identifier := range []string{ref.Slug, ref.Public, strings.ToUpper(ref.Public)} {
			var found searchResponse
			readResponse("/search?limit=1&identifier="+url.QueryEscape(identifier), 200, &found)
			if found.Total != 1 || len(found.Listings) != 1 || found.Listings[0].ID != ref.ID {
				t.Fatalf("permalink %s did not resolve its exact listing", identifier)
			}
			var detail reference
			readResponse("/listings/"+url.PathEscape(identifier), 200, &detail)
			if detail.ID != ref.ID {
				t.Fatalf("detail %s resolved another listing", identifier)
			}
		}
	}
	// Unknown links must not fall back to the newest property; a blank supplied
	// identifier must not accidentally become an unfiltered catalogue request.
	var missing searchResponse
	readResponse("/search?identifier=nonexistent-permalink-regression-check&limit=1", 200, &missing)
	if missing.Total != 0 || len(missing.Listings) != 0 {
		t.Fatal("unknown permalink returned another listing")
	}
	readResponse("/search?identifier=", 400, nil)
	readResponse("/listings/nonexistent-permalink-regression-check", 404, nil)
	var hidden string
	err = db.QueryRow(`SELECT slug FROM listings WHERE slug IS NOT NULL
		AND (deleted_at IS NOT NULL OR NOT is_active OR listing_status<>'active'
		OR moderation_status<>'approved' OR published_at IS NULL OR expires_at<=now()) LIMIT 1`).Scan(&hidden)
	if err == nil {
		var result searchResponse
		readResponse("/search?identifier="+url.QueryEscape(hidden), 200, &result)
		if result.Total != 0 || len(result.Listings) != 0 {
			t.Fatal("nonpublic listing was exposed by permalink")
		}
		readResponse("/listings/"+url.PathEscape(hidden), 404, nil)
	} else if err != sql.ErrNoRows {
		t.Fatal(err)
	}
}
