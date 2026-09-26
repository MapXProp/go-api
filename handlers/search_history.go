package handlers

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"net/url"
	"sort"
	"strconv"
	"strings"
	"time"
	"unicode/utf8"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
)

const maxSearchHistory = 100

type searchHistoryEvent struct {
	ID         string `json:"id"`
	Query      string `json:"query"`
	Label      string `json:"label"`
	URL        string `json:"url"`
	Source     string `json:"source"`
	SearchedAt int64  `json:"searchedAt"`
}
type searchHistoryRequest struct {
	Owner    string               `json:"owner"`
	Revision int64                `json:"revision"`
	Events   []searchHistoryEvent `json:"events"`
}
type searchInterest struct {
	Value string `json:"value"`
	Count int    `json:"count"`
}
type searchPreferences struct {
	SampleSize int              `json:"sampleSize"`
	Queries    []searchInterest `json:"queries"`
	Locations  []searchInterest `json:"locations"`
	Categories []searchInterest `json:"categories"`
	Offers     []searchInterest `json:"offers"`
	Budgets    []searchInterest `json:"budgets"`
}

var historyURLKeys = map[string]bool{}

func init() {
	for _, key := range strings.Fields("q search place lat lon zoom station project map_mode project_category channel category property_type space_type offer_type price_min price_max bedrooms bathrooms area_min feature sort") {
		historyURLKeys[key] = true
	}
}

func cleanSearchHistoryURL(raw string) (string, error) {
	if len(raw) > 4000 || !strings.HasPrefix(raw, "/") || strings.HasPrefix(raw, "//") {
		return "", fmt.Errorf("invalid search destination")
	}
	parsed, err := url.Parse(raw)
	if err != nil || parsed.Host != "" || parsed.Scheme != "" || parsed.Fragment != "" || (parsed.Path != "/properties/map" && parsed.Path != "/real-estate-categories/all") {
		return "", fmt.Errorf("invalid search destination")
	}
	params := parsed.Query()
	for key, values := range params {
		if !historyURLKeys[key] {
			params.Del(key)
			continue
		}
		if len(values) > 40 {
			return "", fmt.Errorf("too many search filters")
		}
		sort.Strings(values)
		for _, value := range values {
			if utf8.RuneCountInString(value) > 200 {
				return "", fmt.Errorf("search filter too long")
			}
		}
	}
	parsed.RawQuery = params.Encode()
	return parsed.String(), nil
}

func cleanSearchHistoryEvent(event searchHistoryEvent, now time.Time) (searchHistoryEvent, error) {
	parsed, err := uuid.Parse(event.ID)
	if err != nil || parsed == uuid.Nil {
		return event, fmt.Errorf("invalid search id")
	}
	event.ID = parsed.String()
	event.Query = strings.Join(strings.Fields(event.Query), " ")
	event.Label = strings.Join(strings.Fields(event.Label), " ")
	if utf8.RuneCountInString(event.Query) > 200 || event.Label == "" || utf8.RuneCountInString(event.Label) > 200 {
		return event, fmt.Errorf("invalid search text")
	}
	if event.Source != "hero" && event.Source != "header" && event.Source != "sheet" && event.Source != "map" && event.Source != "catalogue" {
		return event, fmt.Errorf("invalid search source")
	}
	event.URL, err = cleanSearchHistoryURL(event.URL)
	if err != nil {
		return event, err
	}
	if event.SearchedAt < now.AddDate(0, 0, -30).UnixMilli() || event.SearchedAt > now.Add(time.Minute).UnixMilli() {
		return event, fmt.Errorf("invalid search time")
	}
	return event, nil
}

func summarizeSearchHistory(events []searchHistoryEvent) searchPreferences {
	buckets := make([]map[string]int, 5)
	for i := range buckets {
		buckets[i] = map[string]int{}
	}
	for _, event := range events {
		if event.Query != "" {
			buckets[0][event.Query]++
		}
		parsed, err := url.Parse(event.URL)
		if err != nil {
			continue
		}
		q := parsed.Query()
		if label := q.Get("place"); label != "" {
			buckets[1][label]++
		} else if label := q.Get("station"); label != "" {
			buckets[1]["station:"+label]++
		} else if label := q.Get("project"); label != "" {
			buckets[1]["project:"+label]++
		}
		// Broad default groups are not an intentional preference for every subtype.
		categories := q["category"]
		if len(categories) > 0 && len(categories) <= 4 {
			for _, v := range categories {
				buckets[2][v]++
			}
		}
		offers := q["offer_type"]
		if len(offers) == 1 {
			buckets[3][offers[0]]++
		}
		min, max := q.Get("price_min"), q.Get("price_max")
		if min != "" || max != "" {
			buckets[4][strings.Join(offers, ",")+":THB:"+min+"-"+max]++
		}
	}
	ranked := func(values map[string]int) []searchInterest {
		rows := []searchInterest{}
		for value, count := range values {
			rows = append(rows, searchInterest{value, count})
		}
		sort.Slice(rows, func(i, j int) bool {
			if rows[i].Count == rows[j].Count {
				return rows[i].Value < rows[j].Value
			}
			return rows[i].Count > rows[j].Count
		})
		if len(rows) > 10 {
			rows = rows[:10]
		}
		return rows
	}
	return searchPreferences{len(events), ranked(buckets[0]), ranked(buckets[1]), ranked(buckets[2]), ranked(buckets[3]), ranked(buckets[4])}
}

type historyQuerier interface {
	QueryContext(context.Context, string, ...any) (*sql.Rows, error)
}

func readSearchHistory(ctx context.Context, db historyQuerier, userID int64) ([]searchHistoryEvent, error) {
	rows, err := db.QueryContext(ctx, `SELECT event FROM public.user_search_history WHERE user_id=$1 ORDER BY searched_at DESC,event_id DESC LIMIT 100`, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	events := []searchHistoryEvent{}
	for rows.Next() {
		var raw []byte
		var event searchHistoryEvent
		if err = rows.Scan(&raw); err != nil {
			return nil, err
		}
		if err = json.Unmarshal(raw, &event); err != nil {
			return nil, err
		}
		events = append(events, event)
	}
	return events, rows.Err()
}
func historyResponse(events []searchHistoryEvent, revision int64) fiber.Map {
	return fiber.Map{"events": events, "revision": revision, "preferences": summarizeSearchHistory(events), "limit": maxSearchHistory}
}

// Owner is a session-change guard, never a user-selectable data scope. Every
// read and mutation is scoped to the verified access token's internal user ID.
func MySearchHistory(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		c.Set("Cache-Control", "private, no-store")
		claims, ctx, cancel, err := authenticatedAccountRequest(c, db)
		if err != nil {
			return c.Status(401).JSON(fiber.Map{"error": "authentication required"})
		}
		defer cancel()
		if c.Method() == fiber.MethodGet {
			if c.Query("owner") != claims.Sub {
				return c.Status(409).JSON(fiber.Map{"error": "account changed"})
			}
			// One transaction keeps events and deletion revision from different reads
			// from being mixed during concurrent clear/sync requests.
			tx, err := db.BeginTx(ctx, &sql.TxOptions{Isolation: sql.LevelRepeatableRead, ReadOnly: true})
			if err != nil {
				return c.SendStatus(500)
			}
			defer tx.Rollback()
			var revision int64
			err = tx.QueryRowContext(ctx, `SELECT revision FROM public.user_search_history_state WHERE user_id=$1`, claims.UID).Scan(&revision)
			if err != nil && err != sql.ErrNoRows {
				return c.SendStatus(500)
			}
			events, err := readSearchHistory(ctx, tx, claims.UID)
			if err != nil {
				return c.SendStatus(500)
			}
			if err = tx.Commit(); err != nil {
				return c.SendStatus(500)
			}
			return c.JSON(historyResponse(events, revision))
		}
		if len(c.Body()) > 131072 {
			return c.SendStatus(413)
		}
		var req searchHistoryRequest
		if c.BodyParser(&req) != nil || req.Revision < 0 || len(req.Events) > maxSearchHistory {
			return c.Status(400).JSON(fiber.Map{"error": "invalid search history"})
		}
		if req.Owner != claims.Sub {
			return c.Status(409).JSON(fiber.Map{"error": "account changed"})
		}
		if c.Method() == fiber.MethodPost {
			now := time.Now()
			for i, event := range req.Events {
				clean, err := cleanSearchHistoryEvent(event, now)
				if err != nil {
					return c.Status(400).JSON(fiber.Map{"error": err.Error()})
				}
				req.Events[i] = clean
			}
		}
		tx, err := db.BeginTx(ctx, nil)
		if err != nil {
			return c.SendStatus(500)
		}
		defer tx.Rollback()
		if _, err = tx.ExecContext(ctx, `INSERT INTO public.user_search_history_state(user_id) VALUES($1) ON CONFLICT DO NOTHING`, claims.UID); err != nil {
			return c.SendStatus(500)
		}
		var revision int64
		if err = tx.QueryRowContext(ctx, `SELECT revision FROM public.user_search_history_state WHERE user_id=$1 FOR UPDATE`, claims.UID).Scan(&revision); err != nil {
			return c.SendStatus(500)
		}
		if revision != req.Revision {
			return c.Status(409).JSON(fiber.Map{"error": "history changed; reload before syncing"})
		}
		if c.Method() == fiber.MethodDelete {
			if _, err = tx.ExecContext(ctx, `DELETE FROM public.user_search_history WHERE user_id=$1`, claims.UID); err != nil {
				return c.SendStatus(500)
			}
			revision++
			if _, err = tx.ExecContext(ctx, `UPDATE public.user_search_history_state SET revision=$2 WHERE user_id=$1`, claims.UID, revision); err != nil {
				return c.SendStatus(500)
			}
		} else {
			for _, event := range req.Events {
				raw, _ := json.Marshal(event)
				if _, err = tx.ExecContext(ctx, `INSERT INTO public.user_search_history(user_id,event_id,event,searched_at) VALUES($1,$2,$3,$4) ON CONFLICT(user_id,event_id) DO NOTHING`, claims.UID, event.ID, string(raw), time.UnixMilli(event.SearchedAt)); err != nil {
					return c.SendStatus(500)
				}
			}
			if _, err = tx.ExecContext(ctx, `DELETE FROM public.user_search_history WHERE user_id=$1 AND event_id NOT IN (SELECT event_id FROM public.user_search_history WHERE user_id=$1 ORDER BY searched_at DESC,event_id DESC LIMIT 100)`, claims.UID); err != nil {
				return c.SendStatus(500)
			}
		}
		events, err := readSearchHistory(ctx, tx, claims.UID)
		if err != nil {
			return c.SendStatus(500)
		}
		if err = tx.Commit(); err != nil {
			return c.SendStatus(500)
		}
		c.Set("X-History-Revision", strconv.FormatInt(revision, 10))
		return c.JSON(historyResponse(events, revision))
	}
}
