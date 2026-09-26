package handlers

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"mime/multipart"
	"net/http/httptest"
	"os"
	"strings"
	"testing"
	"time"

	"estate-map-api/database"
	"estate-map-api/models"
	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
)

func TestAccountProfileAvatarAndReusableContact(t *testing.T) {
	if os.Getenv("MAPXPROP_ACCOUNT_PROFILE_TEST") != "1" {
		t.Skip("enable isolated account profile integration")
	}
	if os.Getenv("DB_HOST") != "127.0.0.1" || os.Getenv("DB_PORT") != "55438" || os.Getenv("DB_NAME") != "mapxprop_launch_test" {
		t.Fatal("requires isolated local test database")
	}
	requireSafeIntegrationDatabase(t)
	t.Setenv("LISTING_MEDIA_DIR", t.TempDir())
	db := database.ConnectDB()
	defer db.Close()
	if err := database.RunMigrations(db); err != nil {
		t.Fatal(err)
	}
	var ids []int64
	defer func() {
		for _, id := range ids {
			if _, err := db.Exec(`DELETE FROM public.auth_users WHERE id=$1`, id); err != nil {
				t.Error(err)
			}
		}
	}()
	type fixture struct {
		id                       int64
		publicID, token, refresh string
	}
	newUser := func() fixture {
		u := fixture{publicID: uuid.NewString(), refresh: uuid.NewString()}
		email := "profile-" + u.publicID + "@example.invalid"
		if err := db.QueryRow(`INSERT INTO public.auth_users(public_user_id,email,name,password_hash,provider,is_active,is_verified,password_changed_at) VALUES ($1,$2,'Account Name','test-only','email',true,true,now()) RETURNING id`, u.publicID, email).Scan(&u.id); err != nil {
			t.Fatal(err)
		}
		ids = append(ids, u.id)
		jti := uuid.NewString()
		expiry := time.Now().UTC().Add(time.Hour)
		if _, err := db.Exec(`INSERT INTO public.auth_sessions(user_id,token_id,expires_at,refresh_token_hash,refresh_expires_at) VALUES ($1,$2,$3,$4,$3)`, u.id, jti, expiry, hashRefreshToken(u.refresh)); err != nil {
			t.Fatal(err)
		}
		var err error
		u.token, err = createAccessToken(u.id, u.publicID, email, jti, expiry)
		if err != nil {
			t.Fatal(err)
		}
		return u
	}
	one, two := newUser(), newUser()
	app := fiber.New(fiber.Config{BodyLimit: 8 * 1024 * 1024})
	app.Get("/me", GetMe(db))
	app.Patch("/me", UpdateMyProfile(db))
	app.Put("/me/avatar", UpdateMyAvatar(db))
	app.Delete("/me/avatar", DeleteMyAvatar(db))
	app.Get("/me/listing-contact", GetMyListingContactProfile(db))
	app.Put("/me/listing-contact", UpsertMyListingContactProfile(db))
	app.Post("/refresh", UserRefresh(db))
	app.Get("/listings/:slug", GetListingBySlug(db))
	request := func(method, path, token, contentType string, body io.Reader) []byte {
		req := httptest.NewRequest(method, path, body)
		if token != "" {
			req.Header.Set("Authorization", "Bearer "+token)
		}
		if contentType != "" {
			req.Header.Set("Content-Type", contentType)
		}
		res, err := app.Test(req, -1)
		if err != nil {
			t.Fatal(err)
		}
		defer res.Body.Close()
		data, _ := io.ReadAll(res.Body)
		if res.StatusCode != 200 {
			t.Fatalf("%s %s status=%d body=%s", method, path, res.StatusCode, data)
		}
		return data
	}
	readUser := func(token string) models.UserPublic {
		var value models.UserMeResponse
		if err := json.Unmarshal(request("GET", "/me", token, "", nil), &value); err != nil {
			t.Fatal(err)
		}
		return value.User
	}
	var upload bytes.Buffer
	writer := multipart.NewWriter(&upload)
	part, _ := writer.CreateFormFile("file", "avatar.png")
	part.Write(avatarTestPNG(t))
	writer.Close()
	request("PUT", "/me/avatar", one.token, writer.FormDataContentType(), &upload)
	avatar := readUser(one.token).AvatarURL
	if !strings.HasPrefix(avatar, fmt.Sprintf("/apix/listing-media/files/%d/avatar-", one.id)) {
		t.Fatal("avatar not saved on owner")
	}
	if readUser(two.token).AvatarURL != "" {
		t.Fatal("avatar leaked to another account")
	}
	request("PATCH", "/me", one.token, "application/json", strings.NewReader(`{"name":"Updated name","surname":"Example","avatar_url":"https://invalid.example/other.jpg"}`))
	if readUser(one.token).AvatarURL != avatar {
		t.Fatal("name update replaced avatar")
	}
	// Reusable defaults must not update any published listing's contact details.
	contactDigest := func() string {
		var digest string
		err := db.QueryRow(`SELECT md5(COALESCE(string_agg(concat_ws('|',id::text,contact_name,contact_phone,contact_email,line_id),'~' ORDER BY id),'')) FROM public.listings`).Scan(&digest)
		if err != nil {
			t.Fatal(err)
		}
		return digest
	}
	before := contactDigest()
	profile := listingContactProfileRequest{ContactName: "Different contact", ContactPhone: "0812345678", ContactPhoneSecondary: "0898765432", ContactEmail: "contact@example.invalid", LineID: "@contact", InstagramHandle: "contact.profile", RoleCode: "agency_broker", AuthoritySourceCode: "brokerage_company", OrganizationName: "Example agency"}
	putListingContactProfile(t, app, one.token, profile)
	var contact struct {
		Profile *listingContactProfileResponse `json:"profile"`
	}
	json.Unmarshal(request("GET", "/me/listing-contact", one.token, "", nil), &contact)
	if contact.Profile == nil || contact.Profile.ContactName != profile.ContactName || contact.Profile.LineID != profile.LineID {
		t.Fatal("contact defaults not persisted")
	}
	json.Unmarshal(request("GET", "/me/listing-contact", two.token, "", nil), &contact)
	if contact.Profile != nil {
		t.Fatal("contact defaults leaked to another account")
	}
	if contactDigest() != before {
		t.Fatal("saving defaults changed existing listings")
	}
	// Exercise the public listing SELECT after adding the photo joins.
	var slug string
	if err := db.QueryRow(`SELECT slug FROM public.listings WHERE published_at IS NOT NULL AND is_active=true AND deleted_at IS NULL AND listing_status='active' AND moderation_status='approved' AND (expires_at IS NULL OR expires_at>now()) AND slug IS NOT NULL LIMIT 1`).Scan(&slug); err != nil {
		t.Fatal(err)
	}
	request("GET", "/listings/"+slug, "", "", nil)
	// Refresh must keep the photo, too; it rotates this account's token.
	req := httptest.NewRequest("POST", "/refresh", nil)
	req.Header.Set("Cookie", refreshCookieName+"="+one.refresh)
	res, err := app.Test(req, -1)
	if err != nil {
		t.Fatal(err)
	}
	var refreshed models.UserMeResponse
	json.NewDecoder(res.Body).Decode(&refreshed)
	res.Body.Close()
	if res.StatusCode != 200 || refreshed.User.AvatarURL != avatar {
		t.Fatal("refresh lost avatar")
	}
	// Removal only affects the active account.
	request("DELETE", "/me/avatar", two.token, "", nil)
	var stored string
	if err := db.QueryRow(`SELECT avatar_url FROM public.auth_users WHERE id=$1`, one.id).Scan(&stored); err != nil || stored != avatar {
		t.Fatal("removal changed another account")
	}
	// Delete using the newly rotated access cookie.
	var rotated string
	for _, cookie := range res.Cookies() {
		if cookie.Name == accessCookieName {
			rotated = cookie.Value
		}
	}
	if rotated == "" {
		t.Fatal("missing rotated access cookie")
	}
	request("DELETE", "/me/avatar", rotated, "", nil)
	if readUser(rotated).AvatarURL != "" {
		t.Fatal("avatar removal not persisted")
	}
}
