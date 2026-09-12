// Package indexnow delivers committed public listing changes outside HTTP requests.
package indexnow

import (
	"bytes"
	"context"
	"database/sql"
	"database/sql/driver"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"net/url"
	"os"
	"strconv"
	"strings"
	"time"
)

const (
	Origin = "https://mapxprop.com"
	// Public ownership proof, deliberately identical to the frontend's text file.
	Key                = "9faa8422215849b28109b5310833d1b3"
	endpoint           = "https://api.indexnow.org/indexnow"
	batchSize          = 100
	advisoryLock int64 = 6815043021
)

func enabled(getenv func(string) string) bool {
	if strings.EqualFold(getenv("INDEXNOW_ENABLED"), "false") || getenv("INDEXNOW_ENABLED") == "0" {
		return false
	}
	// A local checkout points at localhost and must never notify production.
	return strings.TrimRight(getenv("FRONTEND_URL"), "/") == Origin
}

// Start returns immediately. DB triggers retain queued changes across restarts
// and outages. The canonical frontend origin is the explicit deployment gate.
func Start(db *sql.DB) func() {
	if !enabled(os.Getenv) {
		log.Print("[indexnow] disabled (requires production FRONTEND_URL; INDEXNOW_ENABLED=false disables)")
		return func() {}
	}
	ctx, cancel := context.WithCancel(context.Background())
	w := &worker{db: db, client: &http.Client{Timeout: 20 * time.Second,
		CheckRedirect: func(*http.Request, []*http.Request) error { return http.ErrUseLastResponse }}, endpoint: endpoint,
		keyURL: Origin + "/" + Key + ".txt"}
	go func() {
		log.Print("[indexnow] durable notification worker started")
		ticker := time.NewTicker(time.Minute)
		defer ticker.Stop()
		for {
			runCtx, done := context.WithTimeout(ctx, 50*time.Second)
			if err := w.run(runCtx); err != nil && ctx.Err() == nil {
				log.Printf("[indexnow] delivery postponed: %v", err)
			}
			done()
			select {
			case <-ctx.Done():
				return
			case <-ticker.C:
			}
		}
	}()
	return cancel
}

type worker struct {
	db               *sql.DB
	client           *http.Client
	endpoint         string
	keyURL           string
	keyVerifiedUntil time.Time
	keyRetryAfter    time.Time
}

type queuedURL struct {
	path     string
	revision int64
	attempts int
}

type payload struct {
	Host        string   `json:"host"`
	Key         string   `json:"key"`
	KeyLocation string   `json:"keyLocation"`
	URLList     []string `json:"urlList"`
}

// Only canonical, public page routes can leave the queue. No query strings,
// alternate hosts, map state, private drafts or contact payloads are submitted.
func canonicalURL(path string) (string, error) {
	if path != "/homes" && path != "/real-estate-categories/all" {
		const prefix = "/real-estate-listings/"
		if !strings.HasPrefix(path, prefix) {
			return "", fmt.Errorf("non-public route")
		}
		slug := strings.TrimPrefix(path, prefix)
		if slug == "" || slug == "." || slug == ".." || strings.ContainsAny(slug, "/\\?#%\r\n\x00") {
			return "", fmt.Errorf("invalid listing path")
		}
	}
	u := url.URL{Scheme: "https", Host: "mapxprop.com", Path: path}
	return u.String(), nil
}

func (w *worker) verifyKey(ctx context.Context) error {
	if time.Now().Before(w.keyVerifiedUntil) {
		return nil
	}
	if time.Now().Before(w.keyRetryAfter) {
		return fmt.Errorf("ownership proof retry scheduled")
	}
	w.keyRetryAfter = time.Now().Add(5 * time.Minute)
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, w.keyURL, nil)
	if err != nil {
		return err
	}
	response, err := w.client.Do(req)
	if err != nil {
		return fmt.Errorf("ownership proof unavailable: %w", err)
	}
	defer response.Body.Close()
	proof, err := io.ReadAll(io.LimitReader(response.Body, 256))
	if err != nil || response.StatusCode != http.StatusOK || strings.TrimSpace(string(proof)) != Key {
		return fmt.Errorf("ownership proof not published (HTTP %d)", response.StatusCode)
	}
	w.keyVerifiedUntil = time.Now().Add(time.Hour)
	return nil
}

func (w *worker) send(ctx context.Context, urls []string) (int, time.Duration, error) {
	if len(urls) == 0 || len(urls) > batchSize {
		return 0, 0, fmt.Errorf("invalid batch size")
	}
	body, err := json.Marshal(payload{Host: "mapxprop.com", Key: Key, KeyLocation: w.keyURL, URLList: urls})
	if err != nil {
		return 0, 0, err
	}
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, w.endpoint, bytes.NewReader(body))
	if err != nil {
		return 0, 0, err
	}
	req.Header.Set("Content-Type", "application/json; charset=utf-8")
	req.Header.Set("User-Agent", "MapxProp-IndexNow/1.0")
	response, err := w.client.Do(req)
	if err != nil {
		return 0, 0, fmt.Errorf("IndexNow network request failed: %w", err)
	}
	defer response.Body.Close()
	_, _ = io.Copy(io.Discard, io.LimitReader(response.Body, 4096))
	retry := retryAfter(response.Header.Get("Retry-After"), time.Now())
	if response.StatusCode != http.StatusOK && response.StatusCode != http.StatusAccepted {
		return response.StatusCode, retry, fmt.Errorf("IndexNow HTTP %d", response.StatusCode)
	}
	return response.StatusCode, 0, nil
}

func retryAfter(header string, now time.Time) time.Duration {
	if seconds, err := strconv.ParseInt(header, 10, 32); err == nil && seconds > 0 {
		return time.Duration(seconds) * time.Second
	}
	if date, err := http.ParseTime(header); err == nil && date.After(now) {
		return date.Sub(now)
	}
	return 0
}

func retryDelay(attempts, status int, requested time.Duration) time.Duration {
	delay := 5 * time.Minute * time.Duration(1<<min(max(attempts, 0), 9))
	if delay > 24*time.Hour {
		delay = 24 * time.Hour
	}
	// Format/key errors require operator attention, never a rapid retry loop.
	if status == 400 || status == 403 || status == 422 {
		delay = 24 * time.Hour
	}
	if requested > delay {
		delay = requested
	}
	return delay
}

func (w *worker) run(ctx context.Context) error {
	conn, err := w.db.Conn(ctx)
	if err != nil {
		return err
	}
	defer conn.Close()
	var locked bool
	if err := conn.QueryRowContext(ctx, "SELECT pg_try_advisory_lock($1)", advisoryLock).Scan(&locked); err != nil {
		return err
	}
	if !locked {
		return nil
	}
	defer func() {
		unlockCtx, cancel := context.WithTimeout(context.Background(), 3*time.Second)
		defer cancel()
		if _, err := conn.ExecContext(unlockCtx, "SELECT pg_advisory_unlock($1)", advisoryLock); err != nil {
			// Never return a session with a held advisory lock to the pool.
			_ = conn.Raw(func(any) error { return driver.ErrBadConn })
		}
	}()

	// Claim due expirations and enqueue in one transaction; a concurrent extension
	// or withdrawal cannot lose a notification between those two operations.
	if _, err := conn.ExecContext(ctx, `WITH due AS (
		DELETE FROM public.indexnow_expirations WHERE expires_at <= now() RETURNING path
	) SELECT public.indexnow_enqueue(path) FROM due`); err != nil {
		return err
	}
	rows, err := conn.QueryContext(ctx, `SELECT path, revision, attempts FROM public.indexnow_outbox
		WHERE revision > delivered_revision AND next_attempt_at <= now()
		AND (last_attempt_at IS NULL OR last_attempt_at <= now() - interval '5 minutes')
		ORDER BY next_attempt_at, path LIMIT $1`, batchSize)
	if err != nil {
		return err
	}
	var entries []queuedURL
	for rows.Next() {
		var item queuedURL
		if err := rows.Scan(&item.path, &item.revision, &item.attempts); err != nil {
			rows.Close()
			return err
		}
		entries = append(entries, item)
	}
	err = rows.Err()
	rows.Close()
	if err != nil || len(entries) == 0 {
		return err
	}
	if err := w.verifyKey(ctx); err != nil {
		return err
	}
	var valid []queuedURL
	var urls []string
	for _, item := range entries {
		u, err := canonicalURL(item.path)
		if err != nil {
			if _, dbErr := conn.ExecContext(ctx, `UPDATE public.indexnow_outbox SET
				next_attempt_at=now()+interval '24 hours', last_error='invalid public URL path', last_status=400
				WHERE path=$1`, item.path); dbErr != nil {
				return dbErr
			}
			log.Print("[indexnow] invalid public URL retained for review")
			continue
		}
		// Persist attempt time before the network call: a crash can cause a safe
		// retry after five minutes, without dropping work or holding row locks.
		if _, err := conn.ExecContext(ctx, `UPDATE public.indexnow_outbox
			SET last_attempt_at=now() WHERE path=$1`, item.path); err != nil {
			return err
		}
		valid = append(valid, item)
		urls = append(urls, u)
	}
	if len(valid) == 0 {
		return nil
	}
	status, requested, sendErr := w.send(ctx, urls)
	for _, item := range valid {
		if sendErr == nil {
			// Ack the captured revision only. An edit committed during POST remains pending.
			_, err = conn.ExecContext(ctx, `UPDATE public.indexnow_outbox SET
				delivered_revision=GREATEST(delivered_revision,$2), accepted_at=now(),
				attempts=0, last_status=$3, last_error=NULL, next_attempt_at=now()+interval '5 minutes'
				WHERE path=$1`, item.path, item.revision, status)
		} else {
			_, err = conn.ExecContext(ctx, `UPDATE public.indexnow_outbox SET
				attempts=attempts+1, last_status=$2, last_error=$3,
				next_attempt_at=now()+($4 * interval '1 second') WHERE path=$1`,
				item.path, status, sendErr.Error(), retryDelay(item.attempts, status, requested).Seconds())
		}
		if err != nil {
			return err
		}
	}
	if status == http.StatusForbidden {
		w.keyVerifiedUntil = time.Time{}
	}
	if sendErr != nil {
		return sendErr
	}
	log.Printf("[indexnow] accepted %d public URLs (HTTP %d; not an indexing guarantee)", len(valid), status)
	return nil
}
