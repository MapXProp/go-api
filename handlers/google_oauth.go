package handlers

import (
	"context"
	"crypto/hmac"
	"database/sql"
	"errors"
	"fmt"
	"net/url"
	"os"
	"strings"
	"time"

	"github.com/coreos/go-oidc/v3/oidc"
	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
	"golang.org/x/oauth2"
)

const (
	googleProvider          = "google"
	oauthStateCookieName    = "mapxprop_oauth_state"
	oauthReturnToCookieName = "mapxprop_oauth_return_to"
	oauthStateTTL           = 10 * time.Minute
)

type googleIDClaims struct {
	Subject       string `json:"sub"`
	Email         string `json:"email"`
	EmailVerified bool   `json:"email_verified"`
	Name          string `json:"name"`
	GivenName     string `json:"given_name"`
	FamilyName    string `json:"family_name"`
	Picture       string `json:"picture"`
	Nonce         string `json:"nonce"`
}

type oauthUser struct {
	ID           int64
	PublicUserID string
	Email        string
	Name         sql.NullString
	Surname      sql.NullString
	IsActive     bool
}

func GoogleLoginStart() fiber.Handler {
	return func(c *fiber.Ctx) error {
		config, err := googleOAuthConfig()
		if err != nil {
			fmt.Println("Google OAuth Config Error:", err)
			return redirectOAuthError(c, "google_config")
		}

		state, err := createOpaqueToken()
		if err != nil {
			fmt.Println("Google OAuth State Error:", err)
			return redirectOAuthError(c, "google_state")
		}

		returnTo := safeReturnPath(c.Query("redirect"))
		if returnTo == "" {
			returnTo = "/account?login=success"
		}

		setOAuthCookie(c, oauthStateCookieName, state, time.Now().UTC().Add(oauthStateTTL))
		setOAuthCookie(c, oauthReturnToCookieName, returnTo, time.Now().UTC().Add(oauthStateTTL))

		authURL := config.AuthCodeURL(
			state,
			oauth2.SetAuthURLParam("nonce", state),
			oauth2.SetAuthURLParam("include_granted_scopes", "true"),
			oauth2.SetAuthURLParam("prompt", "select_account"),
		)

		return c.Redirect(authURL, fiber.StatusFound)
	}
}

func GoogleLoginCallback(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		if errMessage := strings.TrimSpace(c.Query("error")); errMessage != "" {
			fmt.Println("Google OAuth Error:", errMessage)
			clearOAuthCookies(c)
			return redirectOAuthError(c, "google_denied")
		}

		state := strings.TrimSpace(c.Query("state"))
		code := strings.TrimSpace(c.Query("code"))
		expectedState := strings.TrimSpace(c.Cookies(oauthStateCookieName))
		returnTo := strings.TrimSpace(c.Cookies(oauthReturnToCookieName))
		clearOAuthCookies(c)

		if state == "" || code == "" || expectedState == "" || !constantTimeEqual(state, expectedState) {
			fmt.Println("Google OAuth State Mismatch")
			return redirectOAuthError(c, "google_state")
		}
		if safeReturnPath(returnTo) == "" {
			returnTo = "/account?login=success"
		}

		config, err := googleOAuthConfig()
		if err != nil {
			fmt.Println("Google OAuth Config Error:", err)
			return redirectOAuthError(c, "google_config")
		}

		ctx, cancel := context.WithTimeout(context.Background(), 12*time.Second)
		defer cancel()

		token, err := config.Exchange(ctx, code)
		if err != nil {
			fmt.Println("Google OAuth Token Exchange Error:", err)
			return redirectOAuthError(c, "google_token")
		}

		rawIDToken, ok := token.Extra("id_token").(string)
		if !ok || rawIDToken == "" {
			fmt.Println("Google OAuth Missing ID Token")
			return redirectOAuthError(c, "google_token")
		}

		claims, err := verifyGoogleIDToken(ctx, rawIDToken, config.ClientID, state)
		if err != nil {
			fmt.Println("Google ID Token Error:", err)
			return redirectOAuthError(c, "google_token")
		}

		user, err := findOrCreateOAuthUser(ctx, db, claims)
		if err != nil {
			fmt.Println("Google User Link Error:", err)
			return redirectOAuthError(c, "google_account")
		}
		if !user.IsActive {
			return redirectOAuthError(c, "inactive_account")
		}

		if err := issueSessionCookies(ctx, db, c, user.ID, user.PublicUserID, user.Email); err != nil {
			fmt.Println("Google Session Error:", err)
			return redirectOAuthError(c, "google_session")
		}

		return c.Redirect(frontendRedirectURL(returnTo), fiber.StatusFound)
	}
}

func googleOAuthConfig() (*oauth2.Config, error) {
	clientID := strings.TrimSpace(os.Getenv("GOOGLE_CLIENT_ID"))
	clientSecret := strings.TrimSpace(os.Getenv("GOOGLE_CLIENT_SECRET"))
	redirectURI := strings.TrimSpace(os.Getenv("GOOGLE_REDIRECT_URI"))
	if clientID == "" || clientSecret == "" || redirectURI == "" {
		return nil, errors.New("missing GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET, or GOOGLE_REDIRECT_URI")
	}

	return &oauth2.Config{
		ClientID:     clientID,
		ClientSecret: clientSecret,
		RedirectURL:  redirectURI,
		Scopes:       []string{oidc.ScopeOpenID, "email", "profile"},
		Endpoint: oauth2.Endpoint{
			AuthURL:  "https://accounts.google.com/o/oauth2/v2/auth",
			TokenURL: "https://oauth2.googleapis.com/token",
		},
	}, nil
}

func verifyGoogleIDToken(ctx context.Context, rawIDToken string, clientID string, expectedNonce string) (*googleIDClaims, error) {
	provider, err := oidc.NewProvider(ctx, "https://accounts.google.com")
	if err != nil {
		return nil, err
	}

	idToken, err := provider.Verifier(&oidc.Config{ClientID: clientID}).Verify(ctx, rawIDToken)
	if err != nil {
		return nil, err
	}

	var claims googleIDClaims
	if err := idToken.Claims(&claims); err != nil {
		return nil, err
	}
	if claims.Subject == "" {
		return nil, errors.New("missing subject")
	}
	if claims.Email == "" || !claims.EmailVerified {
		return nil, errors.New("google email is missing or unverified")
	}
	if claims.Nonce != "" && !constantTimeEqual(claims.Nonce, expectedNonce) {
		return nil, errors.New("nonce mismatch")
	}

	claims.Email = strings.TrimSpace(strings.ToLower(claims.Email))
	return &claims, nil
}

func findOrCreateOAuthUser(ctx context.Context, db *sql.DB, claims *googleIDClaims) (*oauthUser, error) {
	tx, err := db.BeginTx(ctx, nil)
	if err != nil {
		return nil, err
	}
	defer func() {
		if err != nil {
			_ = tx.Rollback()
		}
	}()

	user, err := findOAuthUserByProvider(ctx, tx, googleProvider, claims.Subject)
	if err == nil {
		err = updateOAuthLogin(ctx, tx, user.ID, googleProvider, claims)
		if err != nil {
			return nil, err
		}
		return user, tx.Commit()
	}
	if !errors.Is(err, sql.ErrNoRows) {
		return nil, err
	}

	user, err = findOAuthUserByEmail(ctx, tx, claims.Email)
	if err == nil {
		err = linkOAuthAccount(ctx, tx, user.ID, googleProvider, claims)
		if err != nil {
			return nil, err
		}
		return user, tx.Commit()
	}
	if !errors.Is(err, sql.ErrNoRows) {
		return nil, err
	}

	user, err = createOAuthUser(ctx, tx, googleProvider, claims)
	if err != nil {
		return nil, err
	}
	if err = linkOAuthAccount(ctx, tx, user.ID, googleProvider, claims); err != nil {
		return nil, err
	}

	return user, tx.Commit()
}

func findOAuthUserByProvider(ctx context.Context, tx *sql.Tx, provider string, providerUserID string) (*oauthUser, error) {
	var user oauthUser
	err := tx.QueryRowContext(ctx, `
		SELECT u.id, u.public_user_id::text, u.email, u.name, u.surname, COALESCE(u.is_active, true)
		FROM public.auth_social_accounts s
		JOIN public.auth_users u ON u.id = s.user_id
		WHERE s.provider = $1
		  AND s.provider_user_id = $2
		  AND u.deleted_at IS NULL
		LIMIT 1
	`, provider, providerUserID).Scan(
		&user.ID,
		&user.PublicUserID,
		&user.Email,
		&user.Name,
		&user.Surname,
		&user.IsActive,
	)
	return &user, err
}

func findOAuthUserByEmail(ctx context.Context, tx *sql.Tx, email string) (*oauthUser, error) {
	var user oauthUser
	err := tx.QueryRowContext(ctx, `
		SELECT id, public_user_id::text, email, name, surname, COALESCE(is_active, true)
		FROM public.auth_users
		WHERE lower(email) = $1
		  AND deleted_at IS NULL
		LIMIT 1
	`, strings.ToLower(email)).Scan(
		&user.ID,
		&user.PublicUserID,
		&user.Email,
		&user.Name,
		&user.Surname,
		&user.IsActive,
	)
	return &user, err
}

func createOAuthUser(ctx context.Context, tx *sql.Tx, provider string, claims *googleIDClaims) (*oauthUser, error) {
	publicUserID := uuid.New().String()
	name := strings.TrimSpace(claims.GivenName)
	surname := strings.TrimSpace(claims.FamilyName)
	if name == "" && surname == "" {
		name, surname = splitDisplayName(claims.Name)
	}

	var user oauthUser
	err := tx.QueryRowContext(ctx, `
		INSERT INTO public.auth_users (
			public_user_id, email, name, surname, is_active, is_verified,
			provider, provider_id, email_verified_at, last_login_at, updated_at
		)
		VALUES ($1, $2, $3, $4, true, $5, $6, $7, now(), now(), now())
		RETURNING id, public_user_id::text, email, name, surname, COALESCE(is_active, true)
	`, publicUserID, claims.Email, nullString(name), nullString(surname), claims.EmailVerified, provider, claims.Subject).Scan(
		&user.ID,
		&user.PublicUserID,
		&user.Email,
		&user.Name,
		&user.Surname,
		&user.IsActive,
	)
	return &user, err
}

func linkOAuthAccount(ctx context.Context, tx *sql.Tx, userID int64, provider string, claims *googleIDClaims) error {
	_, err := tx.ExecContext(ctx, `
		INSERT INTO public.auth_social_accounts (
			user_id, provider, provider_user_id, email, email_verified, display_name, avatar_url, last_login_at
		)
		VALUES ($1, $2, $3, $4, $5, $6, $7, now())
		ON CONFLICT (provider, provider_user_id)
		DO UPDATE SET
			user_id = EXCLUDED.user_id,
			email = EXCLUDED.email,
			email_verified = EXCLUDED.email_verified,
			display_name = EXCLUDED.display_name,
			avatar_url = EXCLUDED.avatar_url,
			last_login_at = now(),
			updated_at = now()
	`, userID, provider, claims.Subject, claims.Email, claims.EmailVerified, claims.Name, claims.Picture)
	if err != nil {
		return err
	}

	_, err = tx.ExecContext(ctx, `
		UPDATE public.auth_users
		SET last_login_at = now(),
		    email_verified_at = COALESCE(email_verified_at, now()),
		    is_verified = true,
		    updated_at = now()
		WHERE id = $1
	`, userID)
	return err
}

func updateOAuthLogin(ctx context.Context, tx *sql.Tx, userID int64, provider string, claims *googleIDClaims) error {
	if err := linkOAuthAccount(ctx, tx, userID, provider, claims); err != nil {
		return err
	}
	return nil
}

func issueSessionCookies(ctx context.Context, db *sql.DB, c *fiber.Ctx, userID int64, publicUserID string, email string) error {
	tokenID := uuid.New().String()
	expiresAt := time.Now().UTC().Add(accessTokenTTL)
	refreshExpiresAt := time.Now().UTC().Add(refreshTokenTTL)
	refreshToken, err := createOpaqueToken()
	if err != nil {
		return err
	}

	_, err = db.ExecContext(ctx, `
		INSERT INTO public.auth_sessions (
			user_id, token_id, user_agent, ip_address, expires_at, refresh_token_hash, refresh_expires_at, last_seen_at
		)
		VALUES ($1, $2, $3, $4, $5, $6, $7, now())
	`, userID, tokenID, c.Get("User-Agent"), c.IP(), expiresAt, hashRefreshToken(refreshToken), refreshExpiresAt)
	if err != nil {
		return err
	}

	accessToken, err := createAccessToken(userID, publicUserID, email, tokenID, expiresAt)
	if err != nil {
		return err
	}

	setAuthCookies(c, accessToken, refreshToken, expiresAt, refreshExpiresAt)
	return nil
}

func setOAuthCookie(c *fiber.Ctx, name string, value string, expiresAt time.Time) {
	c.Cookie(&fiber.Cookie{
		Name:     name,
		Value:    value,
		Path:     "/",
		Expires:  expiresAt,
		HTTPOnly: true,
		Secure:   secureAuthCookies(),
		SameSite: "Lax",
	})
}

func clearOAuthCookies(c *fiber.Ctx) {
	expiredAt := time.Now().UTC().Add(-time.Hour)
	for _, name := range []string{oauthStateCookieName, oauthReturnToCookieName} {
		c.Cookie(&fiber.Cookie{
			Name:     name,
			Value:    "",
			Path:     "/",
			Expires:  expiredAt,
			MaxAge:   -1,
			HTTPOnly: true,
			Secure:   secureAuthCookies(),
			SameSite: "Lax",
		})
	}
}

func redirectOAuthError(c *fiber.Ctx, reason string) error {
	return c.Redirect(frontendRedirectURL("/login?error="+url.QueryEscape(reason)), fiber.StatusFound)
}

func frontendRedirectURL(path string) string {
	base := strings.TrimRight(strings.TrimSpace(os.Getenv("FRONTEND_URL")), "/")
	if base == "" {
		base = "http://localhost:3000"
	}
	if safeReturnPath(path) == "" {
		path = "/"
	}
	return base + path
}

func safeReturnPath(path string) string {
	path = strings.TrimSpace(path)
	if path == "" || !strings.HasPrefix(path, "/") || strings.HasPrefix(path, "//") {
		return ""
	}
	return path
}

func constantTimeEqual(a string, b string) bool {
	return hmac.Equal([]byte(a), []byte(b))
}

func nullString(value string) sql.NullString {
	value = strings.TrimSpace(value)
	return sql.NullString{String: value, Valid: value != ""}
}

func splitDisplayName(displayName string) (string, string) {
	parts := strings.Fields(displayName)
	if len(parts) == 0 {
		return "", ""
	}
	if len(parts) == 1 {
		return parts[0], ""
	}
	return parts[0], strings.Join(parts[1:], " ")
}
