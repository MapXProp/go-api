package handlers

import (
	"bytes"
	"context"
	"database/sql"
	"fmt"
	"image"
	"image/color"
	"image/jpeg"
	_ "image/png"
	"io"
	"os"
	"path/filepath"
	"strconv"

	"estate-map-api/models"
	"github.com/gofiber/fiber/v2"
)

const maxAvatarBytes = 5 * 1024 * 1024

// Decode and re-encode the image instead of serving the uploaded bytes. This
// also removes EXIF/location metadata and bounds the stored image dimensions.
func prepareAccountAvatar(data []byte) ([]byte, error) {
	if len(data) == 0 || len(data) > maxAvatarBytes {
		return nil, fmt.Errorf("avatar is too large")
	}
	config, format, err := image.DecodeConfig(bytes.NewReader(data))
	if err != nil || (format != "jpeg" && format != "png") {
		return nil, fmt.Errorf("invalid avatar image")
	}
	if config.Width <= 0 || config.Height <= 0 || int64(config.Width)*int64(config.Height) > 24000000 {
		return nil, fmt.Errorf("avatar dimensions are too large")
	}
	source, _, err := image.Decode(bytes.NewReader(data))
	if err != nil {
		return nil, fmt.Errorf("invalid avatar image")
	}
	bounds := source.Bounds()
	side := min(bounds.Dx(), bounds.Dy())
	size := min(side, 512)
	left, top := bounds.Min.X+(bounds.Dx()-side)/2, bounds.Min.Y+(bounds.Dy()-side)/2
	result := image.NewRGBA(image.Rect(0, 0, size, size))
	for y := 0; y < size; y++ {
		for x := 0; x < size; x++ {
			r, g, b, a := source.At(left+x*side/size, top+y*side/size).RGBA()
			result.SetRGBA(x, y, color.RGBA{uint8((r + 65535 - a) >> 8), uint8((g + 65535 - a) >> 8), uint8((b + 65535 - a) >> 8), 255})
		}
	}
	var encoded bytes.Buffer
	if err := jpeg.Encode(&encoded, result, &jpeg.Options{Quality: 88}); err != nil {
		return nil, err
	}
	return encoded.Bytes(), nil
}

func writeAccountAvatar(ctx context.Context, db *sql.DB, claims *accessTokenClaims, url string) (models.UserPublic, error) {
	var user models.UserPublic
	err := db.QueryRowContext(ctx, `
		UPDATE public.auth_users SET avatar_url = NULLIF($1, ''), updated_at = now()
		WHERE id = $2 AND public_user_id::text = $3 AND deleted_at IS NULL
		RETURNING public_user_id::text, COALESCE(name, ''), COALESCE(surname, ''), email, role_code, COALESCE(avatar_url, '')
	`, url, claims.UID, claims.Sub).Scan(&user.PublicUserID, &user.Name, &user.Surname, &user.Email, &user.RoleCode, &user.AvatarURL)
	return user, err
}

func UpdateMyAvatar(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, err := authenticatedAccountRequest(c, db)
		if err != nil {
			return c.Status(401).JSON(fiber.Map{"error": err.Error()})
		}
		defer cancel()
		header, err := c.FormFile("file")
		if err != nil || header.Size <= 0 || header.Size > maxAvatarBytes {
			return c.Status(400).JSON(fiber.Map{"error": "invalid avatar file size"})
		}
		file, err := header.Open()
		if err != nil {
			return c.Status(400).JSON(fiber.Map{"error": "cannot read avatar"})
		}
		defer file.Close()
		data, err := io.ReadAll(io.LimitReader(file, maxAvatarBytes+1))
		if err != nil {
			return c.Status(400).JSON(fiber.Map{"error": "cannot read avatar"})
		}
		encoded, err := prepareAccountAvatar(data)
		if err != nil {
			return c.Status(400).JSON(fiber.Map{"error": err.Error()})
		}
		userDir := filepath.Join(listingMediaRoot(), strconv.FormatInt(claims.UID, 10))
		if err := os.MkdirAll(userDir, 0o750); err != nil {
			return c.Status(500).JSON(fiber.Map{"error": "cannot save avatar"})
		}
		filename := "avatar-" + randomListingMediaName() + ".jpg"
		path := filepath.Join(userDir, filename)
		if err := os.WriteFile(path, encoded, 0o640); err != nil {
			return c.Status(500).JSON(fiber.Map{"error": "cannot save avatar"})
		}
		url := fmt.Sprintf("/apix/listing-media/files/%d/%s", claims.UID, filename)
		user, err := writeAccountAvatar(ctx, db, claims, url)
		if err != nil {
			_ = os.Remove(path)
			return c.Status(500).JSON(fiber.Map{"error": "cannot save avatar"})
		}
		return c.JSON(fiber.Map{"success": true, "user": user})
	}
}

func DeleteMyAvatar(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, err := authenticatedAccountRequest(c, db)
		if err != nil {
			return c.Status(401).JSON(fiber.Map{"error": err.Error()})
		}
		defer cancel()
		user, err := writeAccountAvatar(ctx, db, claims, "")
		if err != nil {
			return c.Status(500).JSON(fiber.Map{"error": "cannot remove avatar"})
		}
		return c.JSON(fiber.Map{"success": true, "user": user})
	}
}
