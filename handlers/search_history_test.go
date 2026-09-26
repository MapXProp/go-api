package handlers

import (
	"bytes"
	"encoding/json"
	"estate-map-api/database"
	"fmt"
	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
	"net/http/httptest"
	"os"
	"strings"
	"testing"
	"time"
)

func historyFixture() searchHistoryEvent {
	return searchHistoryEvent{uuid.NewString(), "บางนา", "บางนา", "/properties/map?search=location&place=บางนา&category=homes:condo&offer_type=rent&price_max=20000", "map", time.Now().UnixMilli()}
}
func TestSearchHistoryValidationAndPreferences(t *testing.T) {
	event := historyFixture()
	clean, err := cleanSearchHistoryEvent(event, time.Now())
	if err != nil {
		t.Fatal(err)
	}
	for _, target := range []string{"https://evil.test", "//evil.test", "/account?token=abc", "/properties/map#secret"} {
		bad := event
		bad.URL = target
		if _, err := cleanSearchHistoryEvent(bad, time.Now()); err == nil {
			t.Fatal("accepted invalid URL", target)
		}
	}
	for _, modify := range []func(*searchHistoryEvent){func(e *searchHistoryEvent) { e.ID = "x" }, func(e *searchHistoryEvent) { e.Label = "" }, func(e *searchHistoryEvent) { e.Source = "keystroke" }, func(e *searchHistoryEvent) { e.SearchedAt = time.Now().AddDate(0, 0, -31).UnixMilli() }} {
		bad := event
		modify(&bad)
		if _, err := cleanSearchHistoryEvent(bad, time.Now()); err == nil {
			t.Fatal("accepted invalid event")
		}
	}
	withoutSecret, err := cleanSearchHistoryURL(event.URL + "&access_token=secret")
	if err != nil || strings.Contains(withoutSecret, "secret") {
		t.Fatal("unknown parameters retained")
	}
	prefs := summarizeSearchHistory([]searchHistoryEvent{clean, clean})
	if prefs.SampleSize != 2 || prefs.Locations[0].Count != 2 || prefs.Categories[0].Value != "homes:condo" || prefs.Offers[0].Value != "rent" || prefs.Budgets[0].Value != "rent:THB:-20000" {
		t.Fatalf("unexpected preferences %+v", prefs)
	}
	filterOnly := event
	filterOnly.Query = ""
	filterOnly.Label = "ค้นหาทุกทำเล"
	if _, err := cleanSearchHistoryEvent(filterOnly, time.Now()); err != nil {
		t.Fatal(err)
	}
	filtered := summarizeSearchHistory([]searchHistoryEvent{filterOnly})
	if len(filtered.Queries) != 0 || len(filtered.Budgets) != 1 {
		t.Fatal("filter-only search should describe filters, not an invented query")
	}
	broad := event
	broad.URL = "/properties/map?offer_type=sale&offer_type=rent&category=a&category=b&category=c&category=d&category=e"
	p := summarizeSearchHistory([]searchHistoryEvent{broad})
	if len(p.Offers) > 0 || len(p.Categories) > 0 {
		t.Fatal("default all-filters became preferences")
	}
	app := fiber.New()
	app.All("/history", MySearchHistory(nil))
	response, err := app.Test(httptest.NewRequest("GET", "/history", nil))
	if err != nil || response.StatusCode != 401 {
		t.Fatal("anonymous request must be rejected")
	}
}

func TestSearchHistoryDatabaseIsolationRetentionAndDeletion(t *testing.T) {
	if os.Getenv("MAPXPROP_SEARCH_HISTORY_TEST") != "1" {
		t.Skip("isolated search-history database test")
	}
	if os.Getenv("DB_HOST") != "127.0.0.1" || os.Getenv("DB_PORT") != "55438" || os.Getenv("DB_NAME") != "mapxprop_launch_test" {
		t.Fatal("requires dedicated local test database")
	}
	db := database.ConnectDB()
	t.Cleanup(func() { db.Close() })
	var exists bool
	if err := db.QueryRow(`SELECT to_regclass('public.user_search_history') IS NOT NULL`).Scan(&exists); err != nil {
		t.Fatal(err)
	}
	if !exists {
		migration, err := os.ReadFile("../database/migrations/0176_user_search_history.sql")
		if err != nil {
			t.Fatal(err)
		}
		if _, err = db.Exec(string(migration)); err != nil {
			t.Fatal(err)
		}
	}
	type actor struct {
		id           int64
		owner, token string
	}
	create := func() actor {
		a := actor{owner: uuid.NewString()}
		email := "history-" + a.owner + "@example.invalid"
		if err := db.QueryRow(`INSERT INTO public.auth_users(public_user_id,email,password_hash,provider,is_active,is_verified,password_changed_at,last_login_at,updated_at) VALUES($1,$2,'local-only','email',true,true,now(),now(),now()) RETURNING id`, a.owner, email).Scan(&a.id); err != nil {
			t.Fatal(err)
		}
		t.Cleanup(func() { db.Exec(`DELETE FROM public.auth_users WHERE id=$1 AND public_user_id=$2`, a.id, a.owner) })
		jti := uuid.NewString()
		expires := time.Now().Add(10 * time.Minute)
		if _, err := db.Exec(`INSERT INTO public.auth_sessions(user_id,token_id,expires_at) VALUES($1,$2,$3)`, a.id, jti, expires); err != nil {
			t.Fatal(err)
		}
		var err error
		a.token, err = createAccessToken(a.id, a.owner, email, jti, expires)
		if err != nil {
			t.Fatal(err)
		}
		return a
	}
	a, b := create(), create()
	app := fiber.New()
	app.All("/history", MySearchHistory(db))
	call := func(who actor, method string, body any, want int) map[string]json.RawMessage {
		raw, _ := json.Marshal(body)
		req := httptest.NewRequest(method, "/history?owner="+who.owner, bytes.NewReader(raw))
		req.Header.Set("Content-Type", "application/json")
		req.Header.Set("Authorization", "Bearer "+who.token)
		res, err := app.Test(req, 20000)
		if err != nil {
			t.Fatal(err)
		}
		defer res.Body.Close()
		out := map[string]json.RawMessage{}
		json.NewDecoder(res.Body).Decode(&out)
		if res.StatusCode != want {
			t.Fatalf("%s status=%d want=%d body=%v", method, res.StatusCode, want, out)
		}
		return out
	}
	read := func(who actor) (int64, []searchHistoryEvent, searchPreferences) {
		out := call(who, "GET", nil, 200)
		var revision int64
		var events []searchHistoryEvent
		var p searchPreferences
		json.Unmarshal(out["revision"], &revision)
		json.Unmarshal(out["events"], &events)
		json.Unmarshal(out["preferences"], &p)
		return revision, events, p
	}
	first := historyFixture()
	call(a, "POST", searchHistoryRequest{a.owner, 0, []searchHistoryEvent{first}}, 200)
	call(a, "POST", searchHistoryRequest{a.owner, 0, []searchHistoryEvent{first}}, 200)
	_, events, p := read(a)
	if len(events) != 1 || p.SampleSize != 1 {
		t.Fatal("retry duplicated preference counts")
	}
	_, events, _ = read(b)
	if len(events) != 0 {
		t.Fatal("account data leaked")
	}
	call(b, "POST", searchHistoryRequest{a.owner, 0, []searchHistoryEvent{first}}, 409)
	for batch := 0; batch < 2; batch++ {
		events := []searchHistoryEvent{}
		for i := 0; i < 60; i++ {
			e := historyFixture()
			e.Query = fmt.Sprintf("place-%d-%d", batch, i)
			events = append(events, e)
		}
		call(a, "POST", searchHistoryRequest{a.owner, 0, events}, 200)
	}
	_, events, p = read(a)
	if len(events) != 100 || p.SampleSize != 100 {
		t.Fatal("history retention not bounded")
	}
	call(a, "DELETE", searchHistoryRequest{Owner: a.owner, Revision: 0}, 200)
	revision, events, p := read(a)
	if revision != 1 || len(events) != 0 || p.SampleSize != 0 || len(p.Locations) != 0 {
		t.Fatal("clearing did not reset history and preferences")
	}
	call(a, "POST", searchHistoryRequest{a.owner, 0, []searchHistoryEvent{first}}, 409)
	call(a, "POST", searchHistoryRequest{a.owner, 1, []searchHistoryEvent{historyFixture()}}, 200)
	_, events, _ = read(a)
	if len(events) != 1 {
		t.Fatal("new search after clearing failed")
	}
}
