package handlers

import (
	"context"
	"database/sql"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"net/url"
	"os"
	"strings"
	"time"

	"github.com/gofiber/fiber/v2"
	"golang.org/x/oauth2"
)

const (
	lineProvider         = "line"
	lineStateCookieName  = "mapxprop_line_oauth_state"
	lineReturnCookieName = "mapxprop_line_oauth_return_to"
	lineOAuthStateTTL    = 10 * time.Minute
)

type lineOAuthSettings struct {
	Config *oauth2.Config
}

type lineIDTokenVerifyResponse struct {
	Issuer           string          `json:"iss"`
	Subject          string          `json:"sub"`
	Audience         json.RawMessage `json:"aud"`
	ExpiresAt        int64           `json:"exp"`
	IssuedAt         int64           `json:"iat"`
	Nonce            string          `json:"nonce"`
	Name             string          `json:"name"`
	Picture          string          `json:"picture"`
	Email            string          `json:"email"`
	Error            string          `json:"error"`
	ErrorDescription string          `json:"error_description"`
}

func LineLoginStart() fiber.Handler {
	return func(c *fiber.Ctx) error {
		settings, err := lineOAuthConfig()
		if err != nil {
			fmt.Println("LINE OAuth Config Error:", err)
			return redirectOAuthError(c, "line_config")
		}

		state, err := createOpaqueToken()
		if err != nil {
			fmt.Println("LINE OAuth State Error:", err)
			return redirectOAuthError(c, "line_state")
		}

		returnTo := safeReturnPath(c.Query("redirect"))
		if returnTo == "" {
			returnTo = "/account?login=success"
		}

		setOAuthCookie(c, lineStateCookieName, state, time.Now().UTC().Add(lineOAuthStateTTL))
		setOAuthCookie(c, lineReturnCookieName, returnTo, time.Now().UTC().Add(lineOAuthStateTTL))

		authURL := settings.Config.AuthCodeURL(
			state,
			oauth2.SetAuthURLParam("nonce", state),
		)

		return c.Redirect(authURL, fiber.StatusFound)
	}
}

func LineLoginCallback(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		if errMessage := strings.TrimSpace(c.Query("error")); errMessage != "" {
			fmt.Println("LINE OAuth Error:", errMessage)
			clearNamedOAuthCookies(c, lineStateCookieName, lineReturnCookieName)
			return redirectOAuthError(c, "line_denied")
		}

		state := strings.TrimSpace(c.Query("state"))
		code := strings.TrimSpace(c.Query("code"))
		expectedState := strings.TrimSpace(c.Cookies(lineStateCookieName))
		returnTo := strings.TrimSpace(c.Cookies(lineReturnCookieName))
		clearNamedOAuthCookies(c, lineStateCookieName, lineReturnCookieName)

		if state == "" || code == "" || expectedState == "" || !constantTimeEqual(state, expectedState) {
			fmt.Println("LINE OAuth State Mismatch")
			return redirectOAuthError(c, "line_state")
		}
		if safeReturnPath(returnTo) == "" {
			returnTo = "/account?login=success"
		}

		settings, err := lineOAuthConfig()
		if err != nil {
			fmt.Println("LINE OAuth Config Error:", err)
			return redirectOAuthError(c, "line_config")
		}

		ctx, cancel := context.WithTimeout(context.Background(), 12*time.Second)
		defer cancel()

		token, err := settings.Config.Exchange(ctx, code)
		if err != nil {
			fmt.Println("LINE OAuth Token Exchange Error:", err)
			return redirectOAuthError(c, "line_token")
		}

		rawIDToken, ok := token.Extra("id_token").(string)
		if !ok || strings.TrimSpace(rawIDToken) == "" {
			fmt.Println("LINE OAuth Missing ID Token")
			return redirectOAuthError(c, "line_token")
		}

		profile, err := verifyLineIDToken(ctx, rawIDToken, settings.Config.ClientID, state)
		if err != nil {
			fmt.Println("LINE ID Token Error:", err)
			return redirectOAuthError(c, "line_account")
		}

		user, err := findOrCreateOAuthUser(ctx, db, profile)
		if err != nil {
			fmt.Println("LINE User Link Error:", err)
			return redirectOAuthError(c, "line_account")
		}
		if !user.IsActive {
			return redirectOAuthError(c, "inactive_account")
		}

		if err := issueSessionCookies(ctx, db, c, user.ID, user.PublicUserID, user.Email); err != nil {
			fmt.Println("LINE Session Error:", err)
			return redirectOAuthError(c, "line_session")
		}

		return c.Redirect(frontendRedirectURL(returnTo), fiber.StatusFound)
	}
}

func lineOAuthConfig() (*lineOAuthSettings, error) {
	clientID := strings.TrimSpace(os.Getenv("LINE_CLIENT_ID"))
	clientSecret := strings.TrimSpace(os.Getenv("LINE_CLIENT_SECRET"))
	redirectURI := strings.TrimSpace(os.Getenv("LINE_REDIRECT_URI"))
	if clientID == "" || clientSecret == "" || redirectURI == "" {
		return nil, errors.New("missing LINE_CLIENT_ID, LINE_CLIENT_SECRET, or LINE_REDIRECT_URI")
	}

	return &lineOAuthSettings{
		Config: &oauth2.Config{
			ClientID:     clientID,
			ClientSecret: clientSecret,
			RedirectURL:  redirectURI,
			Scopes:       []string{"profile", "openid", "email"},
			Endpoint: oauth2.Endpoint{
				AuthURL:  "https://access.line.me/oauth2/v2.1/authorize",
				TokenURL: "https://api.line.me/oauth2/v2.1/token",
			},
		},
	}, nil
}

func verifyLineIDToken(ctx context.Context, rawIDToken string, clientID string, expectedNonce string) (*socialAuthProfile, error) {
	form := url.Values{}
	form.Set("id_token", rawIDToken)
	form.Set("client_id", clientID)
	form.Set("nonce", expectedNonce)

	req, err := http.NewRequestWithContext(ctx, http.MethodPost, "https://api.line.me/oauth2/v2.1/verify", strings.NewReader(form.Encode()))
	if err != nil {
		return nil, err
	}
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
	req.Header.Set("Accept", "application/json")

	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	var claims lineIDTokenVerifyResponse
	if err := json.NewDecoder(resp.Body).Decode(&claims); err != nil {
		return nil, err
	}
	if resp.StatusCode < http.StatusOK || resp.StatusCode >= http.StatusMultipleChoices {
		if claims.ErrorDescription != "" {
			return nil, errors.New(claims.ErrorDescription)
		}
		return nil, fmt.Errorf("line id token verify failed: %s", resp.Status)
	}
	if claims.Error != "" {
		return nil, errors.New(claims.Error)
	}
	if claims.Subject == "" {
		return nil, errors.New("missing line subject")
	}
	if !lineAudienceMatches(claims.Audience, clientID) {
		return nil, errors.New("line audience mismatch")
	}
	if claims.Nonce != "" && !constantTimeEqual(claims.Nonce, expectedNonce) {
		return nil, errors.New("line nonce mismatch")
	}
	if claims.ExpiresAt > 0 && time.Now().UTC().Unix() >= claims.ExpiresAt {
		return nil, errors.New("line id token expired")
	}
	if strings.TrimSpace(claims.Email) == "" {
		return nil, errors.New("line account has no email permission")
	}

	name, surname := splitDisplayName(claims.Name)
	return &socialAuthProfile{
		Provider:       lineProvider,
		ProviderUserID: claims.Subject,
		Email:          claims.Email,
		EmailVerified:  true,
		DisplayName:    claims.Name,
		GivenName:      name,
		FamilyName:     surname,
		AvatarURL:      claims.Picture,
	}, nil
}

func lineAudienceMatches(rawAudience json.RawMessage, clientID string) bool {
	var audience string
	if err := json.Unmarshal(rawAudience, &audience); err == nil {
		return audience == clientID
	}

	var audiences []string
	if err := json.Unmarshal(rawAudience, &audiences); err != nil {
		return false
	}
	for _, value := range audiences {
		if value == clientID {
			return true
		}
	}
	return false
}
