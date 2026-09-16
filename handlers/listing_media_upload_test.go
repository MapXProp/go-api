package handlers

import (
	"encoding/binary"
	"net/http/httptest"
	"path/filepath"
	"testing"

	"github.com/gofiber/fiber/v2"
)

func TestDetectListingVideoContainers(t *testing.T) {
	ftyp := func(brand string) []byte {
		data := make([]byte, 24)
		binary.BigEndian.PutUint32(data[:4], 24)
		copy(data[4:8], "ftyp")
		copy(data[8:12], brand)
		copy(data[16:20], brand)
		return data
	}
	for _, tc := range []struct{ brand, mime, extension string }{
		{"qt  ", "video/quicktime", ".mov"},
		{"M4V ", "video/mp4", ".mp4"},
		{"M4VH", "video/mp4", ".mp4"},
		{"M4VP", "video/mp4", ".mp4"},
		{"isom", "video/mp4", ".mp4"},
		{"mp42", "video/mp4", ".mp4"},
	} {
		t.Run(tc.brand, func(t *testing.T) {
			mime := detectListingMediaContentType(ftyp(tc.brand))
			if mime != tc.mime || listingMediaUploadRules["video"].extensions[mime] != tc.extension {
				t.Fatalf("got %q (%q), want %q (%q)", mime, listingMediaUploadRules["video"].extensions[mime], tc.mime, tc.extension)
			}
		})
	}
	invalidSize := ftyp("qt  ")
	binary.BigEndian.PutUint32(invalidSize[:4], 5000)
	for _, data := range [][]byte{ftyp("qt  ")[:12], invalidSize, ftyp("heic"), ftyp("avif"), ftyp("M4A "), []byte("<script>alert('renamed.mp4')</script>")} {
		mime := detectListingMediaContentType(data)
		if _, ok := listingMediaUploadRules["video"].extensions[mime]; ok {
			t.Fatalf("unexpected video detection for %q: %s", data, mime)
		}
	}
	for _, data := range [][]byte{[]byte("\xff\xd8\xff\xe0"), []byte("\x89PNG\r\n\x1a\n")} {
		mime := detectListingMediaContentType(data)
		if _, ok := listingMediaUploadRules["image"].extensions[mime]; !ok {
			t.Fatalf("existing photo format was lost: %s", mime)
		}
	}
}

func TestUploadListingMediaRequiresAuthentication(t *testing.T) {
	app := fiber.New()
	app.Post("/listing-media", UploadListingMedia(nil))

	response, err := app.Test(httptest.NewRequest("POST", "/listing-media", nil))
	if err != nil {
		t.Fatalf("request failed: %v", err)
	}
	if response.StatusCode != fiber.StatusUnauthorized {
		t.Fatalf("expected status %d, got %d", fiber.StatusUnauthorized, response.StatusCode)
	}
}

func TestEnsureListingMediaStorageCreatesWritableDirectory(t *testing.T) {
	root := filepath.Join(t.TempDir(), "nested", "listing-media")
	t.Setenv("LISTING_MEDIA_DIR", root)

	if err := EnsureListingMediaStorage(); err != nil {
		t.Fatalf("expected writable listing media storage: %v", err)
	}
}
