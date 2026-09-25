package handlers

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http/httptest"
	"net/url"
	"os"
	"reflect"
	"strings"
	"testing"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/joho/godotenv"
	"github.com/lib/pq"
)

func TestListingKeywordPatterns(t *testing.T) {
	for _, tc := range []struct {
		query string
		want  []string
	}{
		{"  The CITY city  ", []string{"%the%", "%city%"}},
		{"๓๔,๙๔๖,๐๐๐ 23 ตร.ว. Wi-Fi", []string{"%34946000%", "%23%", "%ตรว%", "%wifi%"}},
		{"BTS\u200bอารีย์", []string{"%btsอารีย์%"}},
		{"% _ \\ !!!", []string{}},
	} {
		if got := listingKeywordPatterns(tc.query); !reflect.DeepEqual(got, tc.want) {
			t.Errorf("%q: got %v, want %v", tc.query, got, tc.want)
		}
	}
	app := fiber.New()
	app.Get("/search", SearchProperties(nil))
	response, err := app.Test(httptest.NewRequest("GET", "/search?search_mode=keyword&q="+strings.Repeat("a", 301), nil))
	if err != nil {
		t.Fatal(err)
	}
	defer response.Body.Close()
	if response.StatusCode != 400 {
		t.Fatal("unbounded keyword accepted")
	}
}

// Optional integration coverage uses existing schemas and READ ONLY connections.
// Synthetic rows below are SELECT/CTE values: no inserts, updates or migrations.
func TestCatalogueKeywordSearchReadOnly(t *testing.T) {
	if os.Getenv("MAPXPROP_DB_READONLY_TEST") != "1" {
		t.Skip("set MAPXPROP_DB_READONLY_TEST=1 for guarded read-only checks")
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
	var mode string
	if err = db.QueryRow("SHOW transaction_read_only").Scan(&mode); err != nil || mode != "on" {
		t.Fatal("read-only database guard failed")
	}

	t.Run("public-fields-and-private-exclusions", func(t *testing.T) {
		fixture := map[string]string{
			"listings":                  `[{"id":1,"title":"บ้านริมคลอง","slug":"asset-unique-123","public_listing_id":"00000000-0000-0000-0000-000000000001","description":"เหมาะเปิดคาเฟ่ติดสวน","custom_building_name":"River Villa","road":"ถนนตัวอย่าง","contact_name":"คุณสายลม","furnishing_status":"fully_furnished","bedroom_count":3,"sale_price":34946000,"land_area_sqm":92}]`,
			"property_types":            `[]`,
			"listing_translations":      `[{"listing_id":1,"language_code":"en","translation_status":"published","title":"Canal villa"},{"listing_id":1,"language_code":"zh","translation_status":"draft","title":"hiddenTranslation"}]`,
			"property_projects":         `[{"id":2,"name_th":"โครงการสายรุ้ง","name_en":"Rainbow Project"}]`,
			"property_project_aliases":  `[{"project_id":2,"alias_name":"เรนโบว์","is_searchable":true},{"project_id":2,"alias_name":"hiddenAlias","is_searchable":false}]`,
			"listing_category_details":  `[{"listing_id":1,"details":{"landmark":"ตลาดชุมชน","three_phase_power":"yes","electricity_available":true,"has_elevator":"no","hotel_facilities":["swimming_pool"],"nested":{"note":"หน้ากว้างพิเศษ"},"data_provenance":{"note":"hiddenProvenance"},"source_url":"hiddenSource"}}]`,
			"listing_content_blocks":    `[{"listing_id":1,"is_visible":true,"heading_th":"ข้อควรทราบ","body_th":"ใกล้สวนสาธารณะ","content":{"note":"ทางเข้ากว้าง"}},{"listing_id":1,"is_visible":false,"body_th":"hiddenBlock"}]`,
			"listing_nearby_places":     `[{"listing_id":1,"place_name_th":"BTS อารีย์","is_highlight":true},{"listing_id":1,"place_name_th":"hiddenPlace","is_highlight":false}]`,
			"listing_transaction_terms": `[{"listing_id":1,"label_th":"เงื่อนไข","value_th":"สัญญาระยะยาว"}]`,
			"listing_media":             `[{"listing_id":1,"is_active":true,"title":"ห้องสมุด"},{"listing_id":1,"is_active":false,"title":"hiddenMedia"}]`,
			"listing_offers":            `[{"listing_id":1,"offer_type":"sale","amount":34946000,"is_negotiable":true}]`,
			"listing_business_details":  `[{"listing_id":1,"allowed_business_types":["clinic"]}]`,
			"listing_amenities":         `[{"listing_id":1,"amenity_code":"wifi"}]`,
			"listing_contact_profiles":  `[{"listing_id":1,"organization_name":"บริษัทบ้านดี","role_code":"owner","verification_note":"hiddenVerification"}]`,
			"listing_event_details":     `[{"listing_id":1,"event_name":"ตลาดสุดสัปดาห์","venue_name":"ฮอลล์กลางเมือง"}]`,
			"listing_event_rounds":      `[{"listing_id":1,"round_label":"รอบฤดูหนาว","notes":"รับร้านขนม"}]`,
		}
		tables := []string{"listings", "listing_translations", "property_types", "property_projects", "property_project_aliases", "listing_category_details", "listing_content_blocks", "listing_nearby_places", "listing_transaction_terms", "listing_media", "listing_offers", "listing_space_types", "business_space_types", "listing_use_cases", "use_cases", "listing_business_details", "listing_amenities", "listing_contact_profiles", "organizations", "listing_event_details", "listing_organizers", "listing_event_rounds"}
		expression := listingKeywordDocumentSQL
		ctes := []string{}
		args := []any{}
		for _, table := range tables {
			rows := fixture[table]
			if rows == "" {
				rows = "[]"
			}
			args = append(args, rows)
			ctes = append(ctes, fmt.Sprintf("kw_%s AS (SELECT * FROM jsonb_populate_recordset(NULL::public.%s,$%d::jsonb))", table, table, len(args)))
			expression = strings.ReplaceAll(expression, "public."+table+" ", "kw_"+table+" ")
		}
		statement := "WITH " + strings.Join(ctes, ",") + " SELECT " + expression + " FROM kw_listings l LEFT JOIN kw_property_projects project ON true LEFT JOIN kw_listing_category_details lcd ON lcd.listing_id=l.id LEFT JOIN kw_listing_event_details led ON led.listing_id=l.id"
		var document string
		if err := db.QueryRow(statement, args...).Scan(&document); err != nil {
			t.Fatal("keyword public document:", err)
		}
		for _, q := range []string{"ริมคลอง", "คาเฟ่", "river villa", "โครงการสายรุ้ง", "เรนโบว์", "Canal villa", "ถนนตัวอย่าง", "คุณสายลม", "เฟอร์นิเจอร์ครบ", "3 ห้องนอน", "๓๔,๙๔๖,๐๐๐", "23", "ตลาดชุมชน", "ไฟฟ้า 3 เฟส", "มีไฟฟ้า", "สระว่ายน้ำ", "หน้ากว้างพิเศษ", "สวนสาธารณะ", "ทางเข้ากว้าง", "BTS อารีย์", "สัญญาระยะยาว", "ห้องสมุด", "ต่อรองได้", "คลินิก", "Wi-Fi", "บริษัทบ้านดี", "เจ้าของทรัพย์", "ฮอลล์กลางเมือง", "รับร้านขนม", "ริมคลอง อารีย์ คลินิก"} {
			var matched bool
			if err := db.QueryRow("SELECT $1::text LIKE ALL($2::text[])", document, pq.Array(listingKeywordPatterns(q))).Scan(&matched); err != nil {
				t.Fatal(err)
			}
			if !matched {
				t.Errorf("public detail did not match: %q", q)
			}
		}
		for _, q := range []string{"hiddenTranslation", "hiddenAlias", "hiddenProvenance", "hiddenSource", "hiddenBlock", "hiddenPlace", "hiddenMedia", "hiddenVerification", "มีลิฟต์"} {
			if strings.Contains(document, strings.Trim(listingKeywordPatterns(q)[0], "%")) {
				t.Errorf("nonpublic/absent feature matched: %q", q)
			}
		}
	})

	t.Run("real-listings-and-explicit-filters", func(t *testing.T) {
		var id int64
		var slug, title, propertyType string
		err := db.QueryRow(`SELECT id,slug,title,property_type_code FROM listings WHERE published_at IS NOT NULL AND deleted_at IS NULL AND is_active AND listing_status='active' AND moderation_status='approved' AND (expires_at IS NULL OR expires_at>now()) AND length(title)>20 ORDER BY id LIMIT 1`).Scan(&id, &slug, &title, &propertyType)
		if err != nil {
			t.Fatal(err)
		}
		app := fiber.New()
		app.Get("/search", SearchProperties(db))
		started := time.Now()
		response, err := app.Test(httptest.NewRequest("GET", "/search?view=map&search_mode=keyword&q="+url.QueryEscape(title), nil), 15000)
		if err != nil {
			t.Fatal(err)
		}
		var catalogue struct {
			Listings []struct {
				ID int64 `json:"id"`
			} `json:"listings"`
		}
		if err := json.NewDecoder(response.Body).Decode(&catalogue); err != nil {
			t.Fatal(err)
		}
		response.Body.Close()
		found := false
		for _, row := range catalogue.Listings {
			if row.ID == id {
				found = true
			}
		}
		if response.StatusCode != 200 || !found {
			t.Fatal("whole-catalogue title search missed the listing")
		}
		t.Logf("Full catalogue keyword search completed in %s", time.Since(started).Round(time.Millisecond))
		search := func(q, extra string, want bool) {
			t.Helper()
			path := "/search?view=map&search_mode=keyword&q=" + url.QueryEscape(q) + "&identifier=" + url.QueryEscape(slug) + extra
			response, err := app.Test(httptest.NewRequest("GET", path, nil), 15000)
			if err != nil {
				t.Fatal(err)
			}
			defer response.Body.Close()
			var result struct {
				Listings []struct {
					ID int64 `json:"id"`
				} `json:"listings"`
				Total int    `json:"total"`
				Error string `json:"error"`
			}
			if err = json.NewDecoder(response.Body).Decode(&result); err != nil {
				t.Fatal(err)
			}
			if response.StatusCode != 200 {
				t.Fatalf("API status %d: %s", response.StatusCode, result.Error)
			}
			found := len(result.Listings) == 1 && result.Listings[0].ID == id
			if found != want {
				t.Errorf("query %q filters %q: found %v want %v", q, extra, found, want)
			}
		}
		search(title, "", true)
		search(slug, "", true)
		search(title, "&property_type="+propertyType, true)
		other := "condo"
		if propertyType == other {
			other = "land"
		}
		search(title, "&property_type="+other, false)
		search("zzzzNoSuchPublicListingKeywordzzzz", "", false)
		search("% _ !!!", "", false)
		t.Logf("Full title, asset code and explicit filters checked for listing %d", id)
	})
}
