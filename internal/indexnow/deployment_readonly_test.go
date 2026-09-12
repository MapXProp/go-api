package indexnow

import (
	"database/sql"
	"net/url"
	"os"
	"testing"

	"github.com/joho/godotenv"
	_ "github.com/lib/pq"
)

// Explicitly opt-in, PostgreSQL-enforced read-only. Never migrates or seeds data.
func TestDeploymentReadOnly(t *testing.T) {
	if os.Getenv("INDEXNOW_READONLY_TEST") != "1" {
		t.Skip("set INDEXNOW_READONLY_TEST=1 for read-only deployment verification")
	}
	env, err := godotenv.Read("../../.env")
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
	db.SetMaxOpenConns(1)
	var readOnly string
	if err := db.QueryRow("SHOW transaction_read_only").Scan(&readOnly); err != nil || readOnly != "on" {
		t.Fatal("read-only database guard failed")
	}
	for _, table := range []string{"listings", "listing_offers", "listing_media", "listing_category_details", "listing_contact_profiles", "listing_space_types", "listing_amenities", "listing_use_cases", "listing_business_details", "listing_event_details", "listing_event_rounds"} {
		var found sql.NullString
		if err := db.QueryRow("SELECT to_regclass($1)::text", "public."+table).Scan(&found); err != nil || !found.Valid {
			t.Fatalf("required table unavailable: %s", table)
		}
	}
	var available sql.NullString
	if err := db.QueryRow("SELECT to_regclass('public.indexnow_outbox')::text").Scan(&available); err != nil {
		t.Fatal(err)
	}
	if !available.Valid {
		if os.Getenv("INDEXNOW_REQUIRE_ACCEPTED") == "1" {
			t.Fatal("migration not deployed")
		}
		t.Log("preflight: all 11 source tables exist; IndexNow migration not deployed yet")
		return
	}
	var triggers int
	if err := db.QueryRow("SELECT count(*) FROM pg_trigger WHERE tgname IN ('indexnow_listing_changed','indexnow_public_detail_changed') AND NOT tgisinternal").Scan(&triggers); err != nil || triggers != 11 {
		t.Fatalf("expected 11 lifecycle triggers, got %d (%v)", triggers, err)
	}
	rows, err := db.Query(`SELECT path,revision,delivered_revision,COALESCE(last_status,0),
		COALESCE(accepted_at::text,''),COALESCE(last_error,'') FROM indexnow_outbox ORDER BY path`)
	if err != nil {
		t.Fatal(err)
	}
	defer rows.Close()
	accepted := 0
	for rows.Next() {
		var path, acceptedAt, lastError string
		var revision, delivered int64
		var status int
		if err := rows.Scan(&path, &revision, &delivered, &status, &acceptedAt, &lastError); err != nil {
			t.Fatal(err)
		}
		t.Logf("%s revision=%d delivered=%d HTTP=%d accepted=%s error=%s", path, revision, delivered, status, acceptedAt, lastError)
		if (path == "/homes" || path == "/real-estate-categories/all") && delivered >= 1 && (status == 200 || status == 202) {
			accepted++
		}
	}
	if err := rows.Err(); err != nil {
		t.Fatal(err)
	}
	if os.Getenv("INDEXNOW_REQUIRE_ACCEPTED") == "1" && accepted != 2 {
		t.Fatalf("bootstrap acknowledgements: %d/2", accepted)
	}
}
