package indexnow

import (
	"context"
	"encoding/json"
	"io"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
	"time"
)

func TestProductionGate(t *testing.T) {
	for _, tc := range []struct {
		origin, override string
		want             bool
	}{
		{"", "", false}, {"http://localhost:3000", "true", false},
		{"https://preview.mapxprop.com", "", false}, {Origin, "", true},
		{Origin + "/", "", true}, {Origin, "false", false}, {Origin, "0", false},
	} {
		get := func(key string) string {
			if key == "FRONTEND_URL" {
				return tc.origin
			}
			return tc.override
		}
		if got := enabled(get); got != tc.want {
			t.Errorf("origin %q override %q: %v", tc.origin, tc.override, got)
		}
	}
}

func TestOnlyCanonicalPublicURLs(t *testing.T) {
	for _, path := range []string{"/homes", "/real-estate-categories/all", "/real-estate-listings/house-123", "/real-estate-listings/บ้าน-123"} {
		got, err := canonicalURL(path)
		if err != nil || !strings.HasPrefix(got, Origin+"/") || strings.Contains(got, "บ้าน") {
			t.Errorf("%s: %s %v", path, got, err)
		}
	}
	for _, path := range []string{"//evil.example/test", "https://evil.example", "/admin", "/listing-drafts/1", "/properties/map?foo=bar", "/real-estate-listings/", "/real-estate-listings/../admin", "/real-estate-listings/..", "/real-estate-listings/%2Fadmin", "/real-estate-listings/house?secret=1", "/real-estate-listings/house#x", "/real-estate-listings/house\n"} {
		if got, err := canonicalURL(path); err == nil {
			t.Errorf("unsafe route accepted: %s => %s", path, got)
		}
	}
}

func TestProtocolResponses(t *testing.T) {
	for _, status := range []int{200, 202, 400, 403, 422, 429, 500} {
		t.Run(http.StatusText(status), func(t *testing.T) {
			server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
				if r.Method != "POST" || !strings.HasPrefix(r.Header.Get("Content-Type"), "application/json") {
					t.Error("invalid request headers")
				}
				var got payload
				if err := json.NewDecoder(r.Body).Decode(&got); err != nil {
					t.Error(err)
				}
				if got.Host != "mapxprop.com" || got.Key != Key || got.KeyLocation != Origin+"/"+Key+".txt" || len(got.URLList) != 2 || got.URLList[1] != Origin+"/real-estate-listings/house-123" {
					t.Errorf("unexpected public notification: %+v", got)
				}
				w.Header().Set("Retry-After", "900")
				w.WriteHeader(status)
			}))
			defer server.Close()
			w := worker{client: server.Client(), endpoint: server.URL, keyURL: Origin + "/" + Key + ".txt"}
			code, retry, err := w.send(context.Background(), []string{Origin + "/homes", Origin + "/real-estate-listings/house-123"})
			if code != status || (err == nil) != (status == 200 || status == 202) {
				t.Fatalf("status %d: code=%d err=%v", status, code, err)
			}
			if err != nil && retry != 15*time.Minute {
				t.Errorf("Retry-After not preserved: %v", retry)
			}
		})
	}
}

func TestOwnershipProofAndDeploymentRace(t *testing.T) {
	for _, tc := range []struct {
		status int
		body   string
		ok     bool
	}{
		{200, Key, true}, {200, Key + "\n", true}, {200, "<html>fallback</html>", false}, {404, Key, false}, {200, "different-key", false},
	} {
		server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			w.WriteHeader(tc.status)
			_, _ = io.WriteString(w, tc.body)
		}))
		w := worker{client: server.Client(), keyURL: server.URL}
		err := w.verifyKey(context.Background())
		if (err == nil) != tc.ok {
			t.Errorf("status %d body %q err=%v", tc.status, tc.body, err)
		}
		if !tc.ok && w.keyRetryAfter.Before(time.Now()) {
			t.Error("missing key retry delay")
		}
		server.Close()
	}
}

func TestCancelledRequestAndRetryBackoff(t *testing.T) {
	ctx, cancel := context.WithCancel(context.Background())
	cancel()
	w := worker{client: &http.Client{}, endpoint: "https://api.indexnow.org/indexnow", keyURL: Origin + "/" + Key + ".txt"}
	if status, _, err := w.send(ctx, []string{Origin + "/homes"}); status != 0 || err == nil {
		t.Error("cancelled delivery should stay retryable")
	}
	for _, tc := range []struct {
		attempts, status int
		requested, want  time.Duration
	}{
		{0, 500, 0, 5 * time.Minute}, {1, 429, 0, 10 * time.Minute}, {2, 0, 0, 20 * time.Minute},
		{100, 500, 0, 24 * time.Hour}, {0, 403, 0, 24 * time.Hour}, {0, 422, 0, 24 * time.Hour},
		{0, 429, 48 * time.Hour, 48 * time.Hour},
	} {
		if got := retryDelay(tc.attempts, tc.status, tc.requested); got != tc.want {
			t.Errorf("retry=%v want %v", got, tc.want)
		}
	}
	now := time.Now().UTC().Truncate(time.Second)
	if got := retryAfter(now.Add(time.Hour).Format(http.TimeFormat), now); got != time.Hour {
		t.Errorf("date retry: %v", got)
	}
	for _, invalid := range []string{"-3", "nonsense", "999999999999999999999999999"} {
		if retryAfter(invalid, now) != 0 {
			t.Error("invalid Retry-After")
		}
	}
}
