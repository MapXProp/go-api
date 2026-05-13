package handlers

import (
	"context"
	"crypto/hmac"
	"crypto/sha256"
	"database/sql"
	"encoding/hex"
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
	facebookProvider          = "facebook"
	facebookStateCookieName   = "mapxprop_facebook_oauth_state"
	facebookReturnCookieName  = "mapxprop_facebook_oauth_return_to"
	facebookOAuthStateTTL     = 10 * time.Minute
	defaultFacebookAPIVersion = "v22.0"
)

type facebookOAuthSettings struct {
	Config       *oauth2.Config
	ClientSecret string
	GraphVersion string
}

type facebookProfileResponse struct {
	ID        string `json:"id"`
	Email     string `json:"email"`
	Name      string `json:"name"`
	FirstName string `json:"first_name"`
	LastName  string `json:"last_name"`
	Picture   struct {
		Data struct {
			URL          string `json:"url"`
			IsSilhouette bool   `json:"is_silhouette"`
		} `json:"data"`
	} `json:"picture"`
	Error *facebookGraphError `json:"error"`
}

type facebookDebugTokenResponse struct {
	Data struct {
		AppID     string `json:"app_id"`
		Type      string `json:"type"`
		App       string `json:"app"`
		IsValid   bool   `json:"is_valid"`
		UserID    string `json:"user_id"`
		ExpiresAt int64  `json:"expires_at"`
	} `json:"data"`
	Error *facebookGraphError `json:"error"`
}

type facebookGraphError struct {
	Message     string `json:"message"`
	Type        string `json:"type"`
	Code        int    `json:"code"`
	Subcode     int    `json:"error_subcode"`
	TraceID     string `json:"fbtrace_id"`
	IsTransient bool   `json:"is_transient"`
}

func FacebookLoginStart() fiber.Handler {
	return func(c *fiber.Ctx) error {
		settings, err := facebookOAuthConfig()
		if err != nil {
			fmt.Println("Facebook OAuth Config Error:", err)
			return redirectOAuthError(c, "facebook_config")
		}

		state, err := createOpaqueToken()
		if err != nil {
			fmt.Println("Facebook OAuth State Error:", err)
			return redirectOAuthError(c, "facebook_state")
		}

		returnTo := safeReturnPath(c.Query("redirect"))
		if returnTo == "" {
			returnTo = "/account?login=success"
		}

		setOAuthCookie(c, facebookStateCookieName, state, time.Now().UTC().Add(facebookOAuthStateTTL))
		setOAuthCookie(c, facebookReturnCookieName, returnTo, time.Now().UTC().Add(facebookOAuthStateTTL))

		authURL := settings.Config.AuthCodeURL(
			state,
			oauth2.SetAuthURLParam("auth_type", "rerequest"),
		)

		return c.Redirect(authURL, fiber.StatusFound)
	}
}

func FacebookLoginCallback(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		if errMessage := strings.TrimSpace(c.Query("error")); errMessage != "" {
			fmt.Println("Facebook OAuth Error:", errMessage)
			clearNamedOAuthCookies(c, facebookStateCookieName, facebookReturnCookieName)
			return redirectOAuthError(c, "facebook_denied")
		}

		state := strings.TrimSpace(c.Query("state"))
		code := strings.TrimSpace(c.Query("code"))
		expectedState := strings.TrimSpace(c.Cookies(facebookStateCookieName))
		returnTo := strings.TrimSpace(c.Cookies(facebookReturnCookieName))
		clearNamedOAuthCookies(c, facebookStateCookieName, facebookReturnCookieName)

		if state == "" || code == "" || expectedState == "" || !constantTimeEqual(state, expectedState) {
			fmt.Println("Facebook OAuth State Mismatch")
			return redirectOAuthError(c, "facebook_state")
		}
		if safeReturnPath(returnTo) == "" {
			returnTo = "/account?login=success"
		}

		settings, err := facebookOAuthConfig()
		if err != nil {
			fmt.Println("Facebook OAuth Config Error:", err)
			return redirectOAuthError(c, "facebook_config")
		}

		ctx, cancel := context.WithTimeout(context.Background(), 12*time.Second)
		defer cancel()

		token, err := settings.Config.Exchange(ctx, code)
		if err != nil {
			fmt.Println("Facebook OAuth Token Exchange Error:", err)
			return redirectOAuthError(c, "facebook_token")
		}
		if strings.TrimSpace(token.AccessToken) == "" {
			fmt.Println("Facebook OAuth Missing Access Token")
			return redirectOAuthError(c, "facebook_token")
		}

		profile, err := fetchFacebookProfile(ctx, settings, token.AccessToken)
		if err != nil {
			fmt.Println("Facebook Profile Error:", err)
			return redirectOAuthError(c, "facebook_account")
		}

		user, err := findOrCreateOAuthUser(ctx, db, profile)
		if err != nil {
			fmt.Println("Facebook User Link Error:", err)
			return redirectOAuthError(c, "facebook_account")
		}
		if !user.IsActive {
			return redirectOAuthError(c, "inactive_account")
		}

		if err := issueSessionCookies(ctx, db, c, user.ID, user.PublicUserID, user.Email); err != nil {
			fmt.Println("Facebook Session Error:", err)
			return redirectOAuthError(c, "facebook_session")
		}

		return c.Redirect(frontendRedirectURL(returnTo), fiber.StatusFound)
	}
}

func facebookOAuthConfig() (*facebookOAuthSettings, error) {
	clientID := strings.TrimSpace(os.Getenv("FACEBOOK_CLIENT_ID"))
	clientSecret := strings.TrimSpace(os.Getenv("FACEBOOK_CLIENT_SECRET"))
	redirectURI := strings.TrimSpace(os.Getenv("FACEBOOK_REDIRECT_URI"))
	if clientID == "" || clientSecret == "" || redirectURI == "" {
		return nil, errors.New("missing FACEBOOK_CLIENT_ID, FACEBOOK_CLIENT_SECRET, or FACEBOOK_REDIRECT_URI")
	}

	version := strings.TrimSpace(os.Getenv("FACEBOOK_GRAPH_VERSION"))
	if version == "" {
		version = defaultFacebookAPIVersion
	}
	version = strings.Trim(version, "/")

	return &facebookOAuthSettings{
		ClientSecret: clientSecret,
		GraphVersion: version,
		Config: &oauth2.Config{
			ClientID:     clientID,
			ClientSecret: clientSecret,
			RedirectURL:  redirectURI,
			Scopes:       []string{"public_profile", "email"},
			Endpoint: oauth2.Endpoint{
				AuthURL:  "https://www.facebook.com/" + version + "/dialog/oauth",
				TokenURL: "https://graph.facebook.com/" + version + "/oauth/access_token",
			},
		},
	}, nil
}

func fetchFacebookProfile(ctx context.Context, settings *facebookOAuthSettings, accessToken string) (*socialAuthProfile, error) {
	debug, err := debugFacebookToken(ctx, settings, accessToken)
	if err != nil {
		return nil, err
	}
	if !debug.Data.IsValid || debug.Data.AppID != settings.Config.ClientID || debug.Data.UserID == "" {
		return nil, errors.New("facebook access token is invalid")
	}

	meURL, err := url.Parse("https://graph.facebook.com/" + settings.GraphVersion + "/me")
	if err != nil {
		return nil, err
	}
	query := meURL.Query()
	query.Set("fields", "id,name,first_name,last_name,email,picture.type(large)")
	query.Set("access_token", accessToken)
	query.Set("appsecret_proof", facebookAppSecretProof(accessToken, settings.ClientSecret))
	meURL.RawQuery = query.Encode()

	var profile facebookProfileResponse
	if err := getFacebookJSON(ctx, meURL.String(), &profile); err != nil {
		return nil, err
	}
	if profile.Error != nil {
		return nil, profile.Error
	}
	if profile.ID == "" || profile.ID != debug.Data.UserID {
		return nil, errors.New("facebook user id mismatch")
	}
	if strings.TrimSpace(profile.Email) == "" {
		return nil, errors.New("facebook account has no email permission")
	}

	return &socialAuthProfile{
		Provider:       facebookProvider,
		ProviderUserID: profile.ID,
		Email:          profile.Email,
		EmailVerified:  true,
		DisplayName:    profile.Name,
		GivenName:      profile.FirstName,
		FamilyName:     profile.LastName,
		AvatarURL:      profile.Picture.Data.URL,
	}, nil
}

func debugFacebookToken(ctx context.Context, settings *facebookOAuthSettings, accessToken string) (*facebookDebugTokenResponse, error) {
	debugURL, err := url.Parse("https://graph.facebook.com/" + settings.GraphVersion + "/debug_token")
	if err != nil {
		return nil, err
	}
	query := debugURL.Query()
	query.Set("input_token", accessToken)
	query.Set("access_token", settings.Config.ClientID+"|"+settings.ClientSecret)
	debugURL.RawQuery = query.Encode()

	var debug facebookDebugTokenResponse
	if err := getFacebookJSON(ctx, debugURL.String(), &debug); err != nil {
		return nil, err
	}
	if debug.Error != nil {
		return nil, debug.Error
	}
	return &debug, nil
}

func getFacebookJSON(ctx context.Context, requestURL string, target any) error {
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, requestURL, nil)
	if err != nil {
		return err
	}
	req.Header.Set("Accept", "application/json")

	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(target); err != nil {
		return err
	}
	if resp.StatusCode < http.StatusOK || resp.StatusCode >= http.StatusMultipleChoices {
		return fmt.Errorf("facebook graph request failed: %s", resp.Status)
	}
	return nil
}

func (err *facebookGraphError) Error() string {
	if err == nil {
		return "facebook graph error"
	}
	if err.Message == "" {
		return fmt.Sprintf("facebook graph error code %d", err.Code)
	}
	return err.Message
}

func facebookAppSecretProof(accessToken string, clientSecret string) string {
	mac := hmac.New(sha256.New, []byte(clientSecret))
	_, _ = mac.Write([]byte(accessToken))
	return hex.EncodeToString(mac.Sum(nil))
}
