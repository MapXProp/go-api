package handlers

import (
	"bytes"
	"image"
	"image/color"
	"image/png"
	"net/http/httptest"
	"testing"

	"github.com/gofiber/fiber/v2"
)

func avatarTestPNG(t *testing.T) []byte {
	t.Helper()
	img := image.NewRGBA(image.Rect(0, 0, 800, 600))
	for y := 0; y < 600; y++ {
		for x := 0; x < 800; x++ {
			img.Set(x, y, color.RGBA{35, 120, 80, 255})
		}
	}
	var data bytes.Buffer
	if err := png.Encode(&data, img); err != nil {
		t.Fatal(err)
	}
	return data.Bytes()
}

func TestAccountAvatarProcessing(t *testing.T) {
	encoded, err := prepareAccountAvatar(avatarTestPNG(t))
	if err != nil {
		t.Fatal(err)
	}
	config, format, err := image.DecodeConfig(bytes.NewReader(encoded))
	if err != nil || format != "jpeg" || config.Width != 512 || config.Height != 512 {
		t.Fatalf("invalid normalized avatar: %+v %s %v", config, format, err)
	}
	for _, data := range [][]byte{nil, []byte("<svg onload='alert(1)'/>"), []byte("not an image"), make([]byte, maxAvatarBytes+1)} {
		if _, err := prepareAccountAvatar(data); err == nil {
			t.Fatal("invalid image accepted")
		}
	}
}

func TestAccountAvatarRequiresAuthentication(t *testing.T) {
	app := fiber.New()
	app.Put("/me/avatar", UpdateMyAvatar(nil))
	app.Delete("/me/avatar", DeleteMyAvatar(nil))
	for _, method := range []string{"PUT", "DELETE"} {
		response, err := app.Test(httptest.NewRequest(method, "/me/avatar", nil))
		if err != nil {
			t.Fatal(err)
		}
		response.Body.Close()
		if response.StatusCode != 401 {
			t.Fatalf("%s status=%d", method, response.StatusCode)
		}
	}
}
