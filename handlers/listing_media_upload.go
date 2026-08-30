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

type listingMediaUploadRule struct {
	maxBytes   int64
	extensions map[string]string
}

var listingMediaUploadRules = map[string]listingMediaUploadRule{
	"image": {
		maxBytes: 8 * 1024 * 1024,
		extensions: map[string]string{
			"image/jpeg": ".jpg",
			"image/png":  ".png",
			"image/webp": ".webp",
		},
	},
	"360": {
		maxBytes: 15 * 1024 * 1024,
		extensions: map[string]string{
			"image/jpeg": ".jpg",
			"image/png":  ".png",
			"image/webp": ".webp",
		},
	},
	"video": {
		maxBytes: 50 * 1024 * 1024,
		extensions: map[string]string{
			"video/mp4":       ".mp4",
			"video/webm":      ".webm",
			"video/quicktime": ".mov",
		},
	},
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

		mediaType := cleanCode(c.FormValue("media_type"), "image")
		rule, supported := listingMediaUploadRules[mediaType]
		if !supported {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "unsupported listing media type"})
		}

		header, err := c.FormFile("file")
		if err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "media file is required"})
		}
		if header.Size <= 0 || header.Size > rule.maxBytes {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"error": fmt.Sprintf("%s file is too large", mediaType),
			})
		}

		file, err := header.Open()
		if err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "cannot read media file"})
		}
		defer file.Close()

		sample := make([]byte, 512)
		sampleSize, err := io.ReadFull(file, sample)
		if err != nil && err != io.EOF && err != io.ErrUnexpectedEOF {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "cannot read media file"})
		}
		if sampleSize == 0 {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "media file is empty"})
		}
		mimeType := http.DetectContentType(sample[:sampleSize])
		extension, ok := rule.extensions[mimeType]
		if !ok {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "unsupported media file format"})
		}
		if _, err := file.Seek(0, io.SeekStart); err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "cannot read media file"})
		}

		userDir := filepath.Join(listingMediaRoot(), strconv.FormatInt(claims.UID, 10))
		if err := os.MkdirAll(userDir, 0o750); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot prepare media storage"})
		}
		filename := randomListingMediaName() + extension
		filePath := filepath.Join(userDir, filename)
		destination, err := os.OpenFile(filePath, os.O_CREATE|os.O_EXCL|os.O_WRONLY, 0o640)
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot save media file"})
		}
		written, copyErr := io.CopyN(destination, file, rule.maxBytes+1)
		closeErr := destination.Close()
		if copyErr != nil && copyErr != io.EOF {
			_ = os.Remove(filePath)
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "cannot read media file"})
		}
		if written <= 0 || written > rule.maxBytes || closeErr != nil {
			_ = os.Remove(filePath)
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "media file is too large or invalid"})
		}

		url := fmt.Sprintf("/apix/listing-media/files/%d/%s", claims.UID, filename)
		return c.Status(fiber.StatusCreated).JSON(fiber.Map{
			"success":    true,
			"url":        url,
			"media_type": mediaType,
			"mime_type":  mimeType,
			"size":       written,
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
