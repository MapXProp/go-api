package handlers

import (
	"context"
	"crypto/rand"
	"database/sql"
	"encoding/hex"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"time"

	"github.com/gofiber/fiber/v2"
)

const maxListingImageBytes = 8 * 1024 * 1024

var listingImageExtensions = map[string]string{
	"image/jpeg": ".jpg",
	"image/png":  ".png",
	"image/webp": ".webp",
}

func UploadListingMedia(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, _, cancel, authenticated := authenticatedListingMediaRequest(c, db)
		if cancel != nil {
			defer cancel()
		}
		if !authenticated {
			return nil
		}

		header, err := c.FormFile("file")
		if err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "image file is required"})
		}
		if header.Size <= 0 || header.Size > maxListingImageBytes {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "image must be 8 MB or smaller"})
		}

		file, err := header.Open()
		if err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "cannot read image"})
		}
		defer file.Close()

		data, err := io.ReadAll(io.LimitReader(file, maxListingImageBytes+1))
		if err != nil || len(data) == 0 || len(data) > maxListingImageBytes {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "cannot read image"})
		}
		mimeType := http.DetectContentType(data)
		extension, ok := listingImageExtensions[mimeType]
		if !ok {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "only JPG, PNG, and WebP images are supported"})
		}

		userDir := filepath.Join(listingMediaRoot(), strconv.FormatInt(claims.UID, 10))
		if err := os.MkdirAll(userDir, 0o750); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot prepare image storage"})
		}
		filename := randomListingMediaName() + extension
		if err := os.WriteFile(filepath.Join(userDir, filename), data, 0o640); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot save image"})
		}

		url := fmt.Sprintf("/apix/listing-media/files/%d/%s", claims.UID, filename)
		return c.Status(fiber.StatusCreated).JSON(fiber.Map{
			"success":   true,
			"url":       url,
			"mime_type": mimeType,
			"size":      len(data),
		})
	}
}

func ServeListingMedia(c *fiber.Ctx) error {
	userID, err := strconv.ParseInt(c.Params("userID"), 10, 64)
	if err != nil || userID <= 0 {
		return c.SendStatus(fiber.StatusNotFound)
	}
	filename := filepath.Base(strings.TrimSpace(c.Params("filename")))
	if filename == "" || filename == "." || filename != c.Params("filename") {
		return c.SendStatus(fiber.StatusNotFound)
	}
	path := filepath.Join(listingMediaRoot(), strconv.FormatInt(userID, 10), filename)
	if _, err := os.Stat(path); err != nil {
		return c.SendStatus(fiber.StatusNotFound)
	}
	c.Set(fiber.HeaderCacheControl, "public, max-age=31536000, immutable")
	return c.SendFile(path)
}

func authenticatedListingMediaRequest(c *fiber.Ctx, db *sql.DB) (*accessTokenClaims, context.Context, context.CancelFunc, bool) {
	token := accessTokenFromRequest(c)
	if token == "" {
		_ = c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "missing authorization token"})
		return nil, nil, nil, false
	}
	claims, err := validateAccessToken(token)
	if err != nil {
		_ = c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "invalid or expired token"})
		return nil, nil, nil, false
	}
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	if err := verifyActiveSession(ctx, db, claims); err != nil {
		cancel()
		_ = c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "session revoked or expired"})
		return nil, nil, nil, false
	}
	return claims, ctx, cancel, true
}

func listingMediaRoot() string {
	if value := strings.TrimSpace(os.Getenv("LISTING_MEDIA_DIR")); value != "" {
		return value
	}
	return filepath.Join("uploads", "listings")
}

func randomListingMediaName() string {
	value := make([]byte, 16)
	if _, err := rand.Read(value); err == nil {
		return hex.EncodeToString(value)
	}
	return fmt.Sprintf("%d", time.Now().UnixNano())
}
