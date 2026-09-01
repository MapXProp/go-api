package handlers

import (
	"context"
	"database/sql"
	"encoding/json"
	"errors"
	"fmt"
	"io/fs"
	"log"
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"time"
)

const (
	listingDraftTTL             = 48 * time.Hour
	listingDraftCleanupInterval = 15 * time.Minute
)

type listingDraftCleanupStats struct {
	ExpiredDrafts int64
	RemovedFiles  int
	RemovedBytes  int64
}

// StartListingDraftCleanup removes expired drafts and unreferenced uploads in
// the background. Published listing media is always protected.
func StartListingDraftCleanup(db *sql.DB) context.CancelFunc {
	ctx, cancel := context.WithCancel(context.Background())
	go func() {
		run := func() {
			cleanupCtx, cleanupCancel := context.WithTimeout(ctx, 10*time.Minute)
			defer cleanupCancel()

			stats, err := cleanupExpiredListingDrafts(cleanupCtx, db, time.Now().UTC())
			if err != nil {
				if !errors.Is(err, context.Canceled) {
					log.Printf("Listing draft cleanup error: %v", err)
				}
				return
			}
			if stats.ExpiredDrafts > 0 || stats.RemovedFiles > 0 {
				log.Printf(
					"Listing draft cleanup: expired_drafts=%d removed_files=%d removed_bytes=%d",
					stats.ExpiredDrafts,
					stats.RemovedFiles,
					stats.RemovedBytes,
				)
			}
		}

		run()
		ticker := time.NewTicker(listingDraftCleanupInterval)
		defer ticker.Stop()
		for {
			select {
			case <-ctx.Done():
				return
			case <-ticker.C:
				run()
			}
		}
	}()
	return cancel
}

func cleanupExpiredListingDrafts(ctx context.Context, db *sql.DB, now time.Time) (listingDraftCleanupStats, error) {
	var stats listingDraftCleanupStats
	result, err := db.ExecContext(ctx, `
		DELETE FROM public.listing_drafts
		WHERE expires_at <= $1
	`, now)
	if err != nil {
		return stats, fmt.Errorf("delete expired listing drafts: %w", err)
	}
	stats.ExpiredDrafts, _ = result.RowsAffected()

	protectedURLs, err := loadProtectedListingMediaURLs(ctx, db, now)
	if err != nil {
		return stats, err
	}

	removedFiles, removedBytes, err := cleanupUnreferencedListingMedia(
		listingMediaRoot(),
		protectedURLs,
		now.Add(-listingDraftTTL),
	)
	stats.RemovedFiles = removedFiles
	stats.RemovedBytes = removedBytes
	if err != nil {
		return stats, err
	}
	return stats, nil
}

func loadProtectedListingMediaURLs(ctx context.Context, db *sql.DB, now time.Time) (map[string]struct{}, error) {
	protected := make(map[string]struct{})

	mediaRows, err := db.QueryContext(ctx, `
		SELECT file_url FROM public.listing_media
		WHERE file_url LIKE '/apix/listing-media/files/%'
		UNION
		SELECT original_url FROM public.listing_media
		WHERE original_url LIKE '/apix/listing-media/files/%'
	`)
	if err != nil {
		return nil, fmt.Errorf("load published listing media: %w", err)
	}
	for mediaRows.Next() {
		var mediaURL string
		if err := mediaRows.Scan(&mediaURL); err != nil {
			mediaRows.Close()
			return nil, fmt.Errorf("scan published listing media: %w", err)
		}
		protected[mediaURL] = struct{}{}
	}
	if err := mediaRows.Err(); err != nil {
		mediaRows.Close()
		return nil, fmt.Errorf("read published listing media: %w", err)
	}
	mediaRows.Close()

	draftRows, err := db.QueryContext(ctx, `
		SELECT data FROM public.listing_drafts
		WHERE expires_at > $1
	`, now)
	if err != nil {
		return nil, fmt.Errorf("load active listing draft media: %w", err)
	}
	defer draftRows.Close()
	for draftRows.Next() {
		var encoded []byte
		if err := draftRows.Scan(&encoded); err != nil {
			return nil, fmt.Errorf("scan active listing draft media: %w", err)
		}
		var data any
		if err := json.Unmarshal(encoded, &data); err != nil {
			return nil, fmt.Errorf("decode active listing draft media: %w", err)
		}
		collectListingMediaURLs(data, protected)
	}
	if err := draftRows.Err(); err != nil {
		return nil, fmt.Errorf("read active listing draft media: %w", err)
	}
	return protected, nil
}

func collectListingMediaURLs(value any, target map[string]struct{}) {
	switch typed := value.(type) {
	case string:
		if strings.HasPrefix(typed, "/apix/listing-media/files/") {
			target[typed] = struct{}{}
		}
	case []any:
		for _, item := range typed {
			collectListingMediaURLs(item, target)
		}
	case map[string]any:
		for _, item := range typed {
			collectListingMediaURLs(item, target)
		}
	}
}

func cleanupUnreferencedListingMedia(root string, protected map[string]struct{}, cutoff time.Time) (int, int64, error) {
	entries, err := os.ReadDir(root)
	if errors.Is(err, os.ErrNotExist) {
		return 0, 0, nil
	}
	if err != nil {
		return 0, 0, fmt.Errorf("read listing media root: %w", err)
	}

	var removedFiles int
	var removedBytes int64
	for _, userEntry := range entries {
		if !userEntry.IsDir() {
			continue
		}
		userID := userEntry.Name()
		if parsed, err := strconv.ParseInt(userID, 10, 64); err != nil || parsed <= 0 {
			continue
		}

		userDir := filepath.Join(root, userID)
		files, err := os.ReadDir(userDir)
		if err != nil {
			return removedFiles, removedBytes, fmt.Errorf("read listing media user directory: %w", err)
		}
		for _, entry := range files {
			if entry.IsDir() || entry.Type()&fs.ModeSymlink != 0 {
				continue
			}
			info, err := entry.Info()
			if err != nil {
				return removedFiles, removedBytes, fmt.Errorf("read listing media file info: %w", err)
			}
			if !info.Mode().IsRegular() || info.ModTime().After(cutoff) {
				continue
			}

			mediaURL := fmt.Sprintf("/apix/listing-media/files/%s/%s", userID, entry.Name())
			if _, keep := protected[mediaURL]; keep {
				continue
			}
			if err := os.Remove(filepath.Join(userDir, entry.Name())); err != nil {
				return removedFiles, removedBytes, fmt.Errorf("remove unreferenced listing media: %w", err)
			}
			removedFiles++
			removedBytes += info.Size()
		}
		_ = os.Remove(userDir) // Only succeeds when the directory is empty.
	}
	return removedFiles, removedBytes, nil
}

func deleteListingDraftForUser(ctx context.Context, db *sql.DB, userID int64) (bool, error) {
	var encoded []byte
	err := db.QueryRowContext(ctx, `
		DELETE FROM public.listing_drafts
		WHERE user_id = $1
		RETURNING data
	`, userID).Scan(&encoded)
	if errors.Is(err, sql.ErrNoRows) {
		return false, nil
	}
	if err != nil {
		return false, err
	}

	var data any
	if err := json.Unmarshal(encoded, &data); err != nil {
		return true, nil
	}
	mediaURLs := make(map[string]struct{})
	collectListingMediaURLs(data, mediaURLs)
	if err := deleteUnreferencedDraftMedia(ctx, db, userID, mediaURLs); err != nil {
		// The draft is already deleted. Leave files for the periodic safe cleanup.
		log.Printf("Listing draft media cleanup error for user %d: %v", userID, err)
	}
	return true, nil
}

func deleteUnreferencedDraftMedia(ctx context.Context, db *sql.DB, userID int64, mediaURLs map[string]struct{}) error {
	prefix := fmt.Sprintf("/apix/listing-media/files/%d/", userID)
	for mediaURL := range mediaURLs {
		if !strings.HasPrefix(mediaURL, prefix) {
			continue
		}
		filename := strings.TrimPrefix(mediaURL, prefix)
		if filename == "" || filepath.Base(filename) != filename {
			continue
		}

		var published bool
		if err := db.QueryRowContext(ctx, `
			SELECT EXISTS (
				SELECT 1 FROM public.listing_media
				WHERE file_url = $1 OR original_url = $1
			)
		`, mediaURL).Scan(&published); err != nil {
			return err
		}
		if published {
			continue
		}
		if err := os.Remove(filepath.Join(listingMediaRoot(), strconv.FormatInt(userID, 10), filename)); err != nil && !errors.Is(err, os.ErrNotExist) {
			return err
		}
	}
	_ = os.Remove(filepath.Join(listingMediaRoot(), strconv.FormatInt(userID, 10)))
	return nil
}
