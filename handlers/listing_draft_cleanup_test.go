package handlers

import (
	"os"
	"path/filepath"
	"testing"
	"time"
)

func TestCollectListingMediaURLs(t *testing.T) {
	protected := map[string]struct{}{}
	collectListingMediaURLs(map[string]any{
		"listingPhotoUrls[]": []any{
			"/apix/listing-media/files/12/photo.jpg",
			"https://example.com/external.jpg",
		},
		"nested": map[string]any{
			"video": "/apix/listing-media/files/12/tour.mp4",
		},
	}, protected)

	for _, mediaURL := range []string{
		"/apix/listing-media/files/12/photo.jpg",
		"/apix/listing-media/files/12/tour.mp4",
	} {
		if _, ok := protected[mediaURL]; !ok {
			t.Fatalf("expected %s to be collected", mediaURL)
		}
	}
	if _, ok := protected["https://example.com/external.jpg"]; ok {
		t.Fatal("external URL must not be treated as a managed listing upload")
	}
}

func TestCleanupUnreferencedListingMedia(t *testing.T) {
	root := t.TempDir()
	userDir := filepath.Join(root, "12")
	if err := os.MkdirAll(userDir, 0o750); err != nil {
		t.Fatal(err)
	}

	now := time.Now().UTC()
	oldTime := now.Add(-49 * time.Hour)
	writeMediaTestFile(t, filepath.Join(userDir, "orphan.jpg"), oldTime, "orphan")
	writeMediaTestFile(t, filepath.Join(userDir, "draft.jpg"), oldTime, "draft")
	writeMediaTestFile(t, filepath.Join(userDir, "published.mp4"), oldTime, "published")
	writeMediaTestFile(t, filepath.Join(userDir, "fresh.jpg"), now.Add(-2*time.Hour), "fresh")

	protected := map[string]struct{}{
		"/apix/listing-media/files/12/draft.jpg":     {},
		"/apix/listing-media/files/12/published.mp4": {},
	}
	removedFiles, removedBytes, err := cleanupUnreferencedListingMedia(root, protected, now.Add(-listingDraftTTL))
	if err != nil {
		t.Fatal(err)
	}
	if removedFiles != 1 || removedBytes != int64(len("orphan")) {
		t.Fatalf("unexpected cleanup stats: files=%d bytes=%d", removedFiles, removedBytes)
	}
	if _, err := os.Stat(filepath.Join(userDir, "orphan.jpg")); !os.IsNotExist(err) {
		t.Fatal("old unreferenced file should be removed")
	}
	for _, filename := range []string{"draft.jpg", "published.mp4", "fresh.jpg"} {
		if _, err := os.Stat(filepath.Join(userDir, filename)); err != nil {
			t.Fatalf("expected %s to remain: %v", filename, err)
		}
	}
}

func writeMediaTestFile(t *testing.T, path string, modifiedAt time.Time, content string) {
	t.Helper()
	if err := os.WriteFile(path, []byte(content), 0o640); err != nil {
		t.Fatal(err)
	}
	if err := os.Chtimes(path, modifiedAt, modifiedAt); err != nil {
		t.Fatal(err)
	}
}
