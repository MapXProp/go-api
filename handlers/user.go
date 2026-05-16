package handlers

import (
	"context"
	"crypto/hmac"
	"crypto/rand"
	"crypto/sha256"
	"database/sql"
	"encoding/base64"
	"encoding/json"
	"estate-map-api/models" // เรียกใช้ Model
	"fmt"
	"net/mail"
	"os"
	"strings"
	"time"
	"unicode"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
	"github.com/lib/pq"
	"golang.org/x/crypto/bcrypt"
)

const (
	accessCookieName  = "mapxprop_access"
	refreshCookieName = "mapxprop_refresh"
	accessTokenTTL    = 15 * time.Minute
	refreshTokenTTL   = 30 * 24 * time.Hour
)

// Register เป็นฟังก์ชันสำหรับลงทะเบียนผู้ใช้ใหม่
func UserRegister(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		var registerData models.UserRegisterStruct

		// 1. รับข้อมูล JSON จาก Next.js
		if err := c.BodyParser(&registerData); err != nil {
			return c.Status(400).JSON(fiber.Map{"error": "ข้อมูลไม่ถูกต้อง"})
		}

		// 2. Validation ขั้นพื้นฐาน
		registerData.Email = strings.TrimSpace(strings.ToLower(registerData.Email))
		if _, err := mail.ParseAddress(registerData.Email); err != nil {
			return c.Status(400).JSON(fiber.Map{"error": "รูปแบบ Email ไม่ถูกต้อง"})
		}
		if len(registerData.Password) < 8 {
			return c.Status(400).JSON(fiber.Map{"error": "รหัสผ่านต้องมีความยาวอย่างน้อย 8 ตัวอักษร"})
		}

		// ตรวจสอบความซับซ้อนของรหัสผ่าน (เพิ่มตัวอักษรพิเศษ)
		var (
			hasUpper   bool
			hasLower   bool
			hasNumber  bool
			hasSpecial bool
		)
		for _, char := range registerData.Password {
			switch {
			case unicode.IsUpper(char):
				hasUpper = true
			case unicode.IsLower(char):
				hasLower = true
			case unicode.IsDigit(char):
				hasNumber = true
			case unicode.IsPunct(char) || unicode.IsSymbol(char): // ตรวจสอบอักขระพิเศษ
				hasSpecial = true
			}
		}
		if !hasUpper || !hasLower || !hasNumber || !hasSpecial {
			return c.Status(400).JSON(fiber.Map{"error": "รหัสผ่านต้องมีตัวอักษรพิมพ์ใหญ่ พิมพ์เล็ก ตัวเลข และอักขระพิเศษ"})
		}

		// 3. Hash Password
		hashedPassword, err := bcrypt.GenerateFromPassword([]byte(registerData.Password), bcrypt.DefaultCost)
		if err != nil {
			return c.Status(500).JSON(fiber.Map{"error": "ไม่สามารถเข้ารหัสผ่านได้"})
		}

		// 4. สร้าง UUID สำหรับ Public User ID (ปลอดภัยและไม่ซ้ำแน่นอน)
		publicID := uuid.New().String()

		// 5. บันทึกลง Database (เพิ่ม Timeout 7 วินาทีเพื่อความปลอดภัย)
		ctx, cancel := context.WithTimeout(context.Background(), 7*time.Second)
		defer cancel()

		var (
			id              int64
			createdPublicID string
			email           string
			name            sql.NullString
			surname         sql.NullString
		)

		query := `
			INSERT INTO public.auth_users (
				public_user_id, email, password_hash, provider, is_active, is_verified,
				password_changed_at, last_login_at, updated_at
			)
			VALUES ($1, $2, $3, 'email', true, false, now(), now(), now())
			RETURNING id, public_user_id::text, email, name, surname`
		err = db.QueryRowContext(ctx, query, publicID, registerData.Email, string(hashedPassword)).Scan(
			&id,
			&createdPublicID,
			&email,
			&name,
			&surname,
		)

		if err != nil {
			fmt.Println("Database Error:", err) // พิมพ์ Error ออกมาดูที่หน้าจอ Terminal
			if pgErr, ok := err.(*pq.Error); ok && pgErr.Code == "23505" {
				// แยกแยะว่าอะไรซ้ำ (ดูจากชื่อ Constraint ใน DB)
				if strings.Contains(pgErr.Constraint, "email") {
					return c.Status(409).JSON(fiber.Map{"error": "Email นี้ถูกใช้งานไปแล้ว"})
				}
				if strings.Contains(pgErr.Constraint, "public_user_id") {
					return c.Status(500).JSON(fiber.Map{"error": "เกิดข้อผิดพลาดภายในระบบ (ID collision) กรุณาลองใหม่"})
				}
			}
			return c.Status(500).JSON(fiber.Map{"error": "ไม่สามารถลงทะเบียนได้ในขณะนี้"})
		}

		// 6. ส่งข้อมูลกลับ
		if err := issueSessionCookies(ctx, db, c, id, createdPublicID, email); err != nil {
			fmt.Println("Register Session Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "cannot create signup session"})
		}

		verifyCtx, verifyCancel := context.WithTimeout(context.Background(), 10*time.Second)
		defer verifyCancel()
		if err := issueEmailVerification(verifyCtx, db, id, email, c.Get("User-Agent"), c.IP()); err != nil {
			fmt.Println("Register Email Verification Error:", err)
		}

		return c.Status(201).JSON(models.UserLoginResponse{
			TokenType:    "Cookie",
			ExpiresIn:    int64(accessTokenTTL.Seconds()),
			PublicUserID: createdPublicID,
			Name:         name.String,
			Surname:      surname.String,
			Email:        email,
		})
	}
}

// UserLogin handles email/password login.
func UserLogin(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		var loginData models.UserLoginStruct

		if err := c.BodyParser(&loginData); err != nil {
			return c.Status(400).JSON(fiber.Map{"error": "ข้อมูลไม่ถูกต้อง"})
		}

		loginData.Email = strings.TrimSpace(strings.ToLower(loginData.Email))
		if _, err := mail.ParseAddress(loginData.Email); err != nil {
			return c.Status(400).JSON(fiber.Map{"error": "รูปแบบ Email ไม่ถูกต้อง"})
		}
		if loginData.Password == "" {
			return c.Status(400).JSON(fiber.Map{"error": "กรุณากรอกรหัสผ่าน"})
		}

		ctx, cancel := context.WithTimeout(context.Background(), 7*time.Second)
		defer cancel()

		var (
			id           int64
			publicUserID string
			email        string
			passwordHash string
			isActive     bool
			name         sql.NullString
			surname      sql.NullString
			lockedUntil  sql.NullTime
		)

		err := db.QueryRowContext(ctx, `
			SELECT id, public_user_id::text, email, password_hash, COALESCE(is_active, true),
			       name, surname, locked_until
			FROM public.auth_users
			WHERE lower(email) = $1
			  AND deleted_at IS NULL
			LIMIT 1
		`, loginData.Email).Scan(
			&id,
			&publicUserID,
			&email,
			&passwordHash,
			&isActive,
			&name,
			&surname,
			&lockedUntil,
		)
		if err == sql.ErrNoRows {
			return c.Status(401).JSON(fiber.Map{"error": "Email หรือรหัสผ่านไม่ถูกต้อง"})
		}
		if err != nil {
			fmt.Println("Database Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "ไม่สามารถเข้าสู่ระบบได้ในขณะนี้"})
		}

		if !isActive {
			return c.Status(403).JSON(fiber.Map{"error": "บัญชีนี้ถูกปิดใช้งาน"})
		}
		if lockedUntil.Valid && lockedUntil.Time.After(time.Now()) {
			return c.Status(423).JSON(fiber.Map{"error": "บัญชีถูกล็อกชั่วคราว กรุณาลองใหม่ภายหลัง"})
		}

		if err := bcrypt.CompareHashAndPassword([]byte(passwordHash), []byte(loginData.Password)); err != nil {
			_, updateErr := db.ExecContext(ctx, `
				UPDATE public.auth_users
				SET failed_attempts = COALESCE(failed_attempts, 0) + 1,
				    last_failed_login_at = now(),
				    locked_until = CASE
				      WHEN COALESCE(failed_attempts, 0) + 1 >= 5 THEN now() + interval '15 minutes'
				      ELSE locked_until
				    END,
				    updated_at = now()
				WHERE id = $1
			`, id)
			if updateErr != nil {
				fmt.Println("Database Error:", updateErr)
			}
			return c.Status(401).JSON(fiber.Map{"error": "Email หรือรหัสผ่านไม่ถูกต้อง"})
		}

		_, err = db.ExecContext(ctx, `
			UPDATE public.auth_users
			SET last_login_at = now(),
			    failed_attempts = 0,
			    locked_until = NULL,
			    updated_at = now()
			WHERE id = $1
		`, id)
		if err != nil {
			fmt.Println("Database Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "ไม่สามารถเข้าสู่ระบบได้ในขณะนี้"})
		}

		expiresIn := int64(accessTokenTTL.Seconds())
		tokenID := uuid.New().String()
		expiresAt := time.Now().UTC().Add(accessTokenTTL)
		refreshExpiresAt := time.Now().UTC().Add(refreshTokenTTL)
		refreshToken, err := createOpaqueToken()
		if err != nil {
			fmt.Println("Refresh Token Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "cannot create login session"})
		}

		_, err = db.ExecContext(ctx, `
			INSERT INTO public.auth_sessions (
				user_id, token_id, user_agent, ip_address, expires_at, refresh_token_hash, refresh_expires_at, last_seen_at
			)
			VALUES ($1, $2, $3, $4, $5, $6, $7, now())
		`, id, tokenID, c.Get("User-Agent"), c.IP(), expiresAt, hashRefreshToken(refreshToken), refreshExpiresAt)
		if err != nil {
			fmt.Println("Session Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "cannot create login session"})
		}

		token, err := createAccessToken(id, publicUserID, email, tokenID, expiresAt)
		if err != nil {
			fmt.Println("Token Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "ไม่สามารถสร้าง token ได้"})
		}

		setAuthCookies(c, token, refreshToken, expiresAt, refreshExpiresAt)

		return c.JSON(models.UserLoginResponse{
			TokenType:    "Cookie",
			ExpiresIn:    expiresIn,
			PublicUserID: publicUserID,
			Name:         name.String,
			Surname:      surname.String,
			Email:        email,
		})
	}
}

func createAccessToken(userID int64, publicUserID string, email string, tokenID string, expiresAt time.Time) (string, error) {
	now := time.Now().UTC()
	header := map[string]string{
		"alg": "HS256",
		"typ": "JWT",
	}
	claims := map[string]any{
		"sub":   publicUserID,
		"uid":   userID,
		"email": email,
		"jti":   tokenID,
		"iat":   now.Unix(),
		"exp":   expiresAt.Unix(),
	}

	encodedHeader, err := encodeJWTPart(header)
	if err != nil {
		return "", err
	}
	encodedClaims, err := encodeJWTPart(claims)
	if err != nil {
		return "", err
	}

	signingInput := encodedHeader + "." + encodedClaims
	mac := hmac.New(sha256.New, []byte(tokenSecret()))
	_, _ = mac.Write([]byte(signingInput))
	signature := base64.RawURLEncoding.EncodeToString(mac.Sum(nil))

	return signingInput + "." + signature, nil
}

func encodeJWTPart(value any) (string, error) {
	payload, err := json.Marshal(value)
	if err != nil {
		return "", err
	}
	return base64.RawURLEncoding.EncodeToString(payload), nil
}

func tokenSecret() string {
	if secret := os.Getenv("JWT_SECRET"); secret != "" {
		return secret
	}
	if secret := os.Getenv("AUTH_TOKEN_SECRET"); secret != "" {
		return secret
	}
	if secret := os.Getenv("DB_PASS"); secret != "" {
		return secret
	}
	return "mapxprop-local-development-secret"
}

// GetUsers เป็นฟังก์ชันสำหรับดึงข้อมูล User ทั้งหมด
func refreshTokenSecret() string {
	if secret := os.Getenv("REFRESH_TOKEN_SECRET"); secret != "" {
		return secret
	}
	return tokenSecret()
}

func createOpaqueToken() (string, error) {
	value := make([]byte, 32)
	if _, err := rand.Read(value); err != nil {
		return "", err
	}
	return base64.RawURLEncoding.EncodeToString(value), nil
}

func hashRefreshToken(token string) string {
	mac := hmac.New(sha256.New, []byte(refreshTokenSecret()))
	_, _ = mac.Write([]byte(token))
	return base64.RawURLEncoding.EncodeToString(mac.Sum(nil))
}

func secureAuthCookies() bool {
	cookieSecure := strings.TrimSpace(os.Getenv("COOKIE_SECURE"))
	if cookieSecure != "" {
		return strings.EqualFold(cookieSecure, "true")
	}
	return strings.EqualFold(os.Getenv("APP_ENV"), "production") ||
		strings.EqualFold(os.Getenv("GO_ENV"), "production")
}

func setAuthCookies(c *fiber.Ctx, accessToken string, refreshToken string, accessExpiresAt time.Time, refreshExpiresAt time.Time) {
	secure := secureAuthCookies()
	c.Cookie(&fiber.Cookie{
		Name:     accessCookieName,
		Value:    accessToken,
		Path:     "/",
		Expires:  accessExpiresAt,
		HTTPOnly: true,
		Secure:   secure,
		SameSite: "Lax",
	})
	c.Cookie(&fiber.Cookie{
		Name:     refreshCookieName,
		Value:    refreshToken,
		Path:     "/",
		Expires:  refreshExpiresAt,
		HTTPOnly: true,
		Secure:   secure,
		SameSite: "Lax",
	})
}

func clearAuthCookies(c *fiber.Ctx) {
	expiredAt := time.Now().UTC().Add(-time.Hour)
	secure := secureAuthCookies()
	for _, name := range []string{accessCookieName, refreshCookieName} {
		c.Cookie(&fiber.Cookie{
			Name:     name,
			Value:    "",
			Path:     "/",
			Expires:  expiredAt,
			MaxAge:   -1,
			HTTPOnly: true,
			Secure:   secure,
			SameSite: "Lax",
		})
	}
}

type accessTokenClaims struct {
	Sub   string `json:"sub"`
	UID   int64  `json:"uid"`
	Email string `json:"email"`
	JTI   string `json:"jti"`
	IAT   int64  `json:"iat"`
	Exp   int64  `json:"exp"`
}

func validateAccessToken(token string) (*accessTokenClaims, error) {
	parts := strings.Split(token, ".")
	if len(parts) != 3 {
		return nil, fmt.Errorf("invalid token format")
	}

	signingInput := parts[0] + "." + parts[1]
	mac := hmac.New(sha256.New, []byte(tokenSecret()))
	_, _ = mac.Write([]byte(signingInput))

	signature, err := base64.RawURLEncoding.DecodeString(parts[2])
	if err != nil {
		return nil, fmt.Errorf("invalid token signature")
	}
	if !hmac.Equal(signature, mac.Sum(nil)) {
		return nil, fmt.Errorf("invalid token signature")
	}

	payload, err := base64.RawURLEncoding.DecodeString(parts[1])
	if err != nil {
		return nil, fmt.Errorf("invalid token payload")
	}

	var claims accessTokenClaims
	if err := json.Unmarshal(payload, &claims); err != nil {
		return nil, fmt.Errorf("invalid token claims")
	}
	if claims.Sub == "" || claims.UID == 0 || claims.JTI == "" || claims.Exp == 0 {
		return nil, fmt.Errorf("missing token claims")
	}
	if time.Now().UTC().Unix() >= claims.Exp {
		return nil, fmt.Errorf("token expired")
	}

	return &claims, nil
}

func bearerToken(c *fiber.Ctx) string {
	authHeader := strings.TrimSpace(c.Get("Authorization"))
	if authHeader == "" {
		return ""
	}
	if strings.HasPrefix(strings.ToLower(authHeader), "bearer ") {
		return strings.TrimSpace(authHeader[7:])
	}
	return authHeader
}

func accessTokenFromRequest(c *fiber.Ctx) string {
	if token := bearerToken(c); token != "" {
		return token
	}
	return strings.TrimSpace(c.Cookies(accessCookieName))
}

func verifyActiveSession(ctx context.Context, db *sql.DB, claims *accessTokenClaims) error {
	var exists bool
	err := db.QueryRowContext(ctx, `
		SELECT EXISTS (
			SELECT 1
			FROM public.auth_sessions
			WHERE token_id = $1
			  AND user_id = $2
			  AND revoked_at IS NULL
			  AND expires_at > now()
		)
	`, claims.JTI, claims.UID).Scan(&exists)
	if err != nil {
		return err
	}
	if !exists {
		return fmt.Errorf("session inactive")
	}
	return nil
}

func UserRefresh(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		refreshToken := strings.TrimSpace(c.Cookies(refreshCookieName))
		if refreshToken == "" {
			clearAuthCookies(c)
			return c.Status(401).JSON(fiber.Map{"error": "missing refresh session"})
		}

		ctx, cancel := context.WithTimeout(context.Background(), 7*time.Second)
		defer cancel()

		var (
			sessionID    int64
			id           int64
			publicUserID string
			email        string
			name         sql.NullString
			surname      sql.NullString
			isActive     bool
		)

		err := db.QueryRowContext(ctx, `
			SELECT s.id, u.id, u.public_user_id::text, u.email, u.name, u.surname, COALESCE(u.is_active, true)
			FROM public.auth_sessions s
			JOIN public.auth_users u ON u.id = s.user_id
			WHERE s.refresh_token_hash = $1
			  AND s.revoked_at IS NULL
			  AND s.refresh_expires_at > now()
			  AND u.deleted_at IS NULL
			LIMIT 1
		`, hashRefreshToken(refreshToken)).Scan(
			&sessionID,
			&id,
			&publicUserID,
			&email,
			&name,
			&surname,
			&isActive,
		)
		if err == sql.ErrNoRows {
			clearAuthCookies(c)
			return c.Status(401).JSON(fiber.Map{"error": "refresh session expired"})
		}
		if err != nil {
			fmt.Println("Refresh Session Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "cannot refresh session"})
		}
		if !isActive {
			clearAuthCookies(c)
			return c.Status(403).JSON(fiber.Map{"error": "user account is inactive"})
		}

		tokenID := uuid.New().String()
		expiresAt := time.Now().UTC().Add(accessTokenTTL)
		refreshExpiresAt := time.Now().UTC().Add(refreshTokenTTL)
		nextRefreshToken, err := createOpaqueToken()
		if err != nil {
			fmt.Println("Refresh Token Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "cannot refresh session"})
		}

		_, err = db.ExecContext(ctx, `
			UPDATE public.auth_sessions
			SET token_id = $1,
			    expires_at = $2,
			    refresh_token_hash = $3,
			    refresh_expires_at = $4,
			    last_seen_at = now(),
			    updated_at = now()
			WHERE id = $5
			  AND revoked_at IS NULL
		`, tokenID, expiresAt, hashRefreshToken(nextRefreshToken), refreshExpiresAt, sessionID)
		if err != nil {
			fmt.Println("Refresh Update Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "cannot refresh session"})
		}

		accessToken, err := createAccessToken(id, publicUserID, email, tokenID, expiresAt)
		if err != nil {
			fmt.Println("Token Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "cannot refresh session"})
		}

		setAuthCookies(c, accessToken, nextRefreshToken, expiresAt, refreshExpiresAt)

		return c.JSON(models.UserMeResponse{
			Authenticated: true,
			User: models.UserPublic{
				PublicUserID: publicUserID,
				Name:         name.String,
				Surname:      surname.String,
				Email:        email,
			},
		})
	}
}

func UserLogout(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		ctx, cancel := context.WithTimeout(context.Background(), 7*time.Second)
		defer cancel()

		token := accessTokenFromRequest(c)
		if token != "" {
			if claims, err := validateAccessToken(token); err == nil {
				if _, err := db.ExecContext(ctx, `
					UPDATE public.auth_sessions
					SET revoked_at = now(),
					    updated_at = now()
					WHERE token_id = $1
					  AND user_id = $2
					  AND revoked_at IS NULL
				`, claims.JTI, claims.UID); err != nil {
					fmt.Println("Logout Session Error:", err)
					clearAuthCookies(c)
					return c.Status(500).JSON(fiber.Map{"error": "cannot logout session"})
				}
			}
		}

		refreshToken := strings.TrimSpace(c.Cookies(refreshCookieName))
		if refreshToken != "" {
			if _, err := db.ExecContext(ctx, `
				UPDATE public.auth_sessions
				SET revoked_at = now(),
				    updated_at = now()
				WHERE refresh_token_hash = $1
				  AND revoked_at IS NULL
			`, hashRefreshToken(refreshToken)); err != nil {
				fmt.Println("Logout Refresh Session Error:", err)
				clearAuthCookies(c)
				return c.Status(500).JSON(fiber.Map{"error": "cannot logout session"})
			}
		}

		clearAuthCookies(c)
		return c.JSON(models.UserLogoutResponse{Success: true})
	}
}

func GetMe(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		token := accessTokenFromRequest(c)
		if token == "" {
			return c.Status(401).JSON(fiber.Map{"error": "missing authorization token"})
		}

		claims, err := validateAccessToken(token)
		if err != nil {
			return c.Status(401).JSON(fiber.Map{"error": "invalid or expired token"})
		}

		ctx, cancel := context.WithTimeout(context.Background(), 7*time.Second)
		defer cancel()

		if err := verifyActiveSession(ctx, db, claims); err != nil {
			return c.Status(401).JSON(fiber.Map{"error": "session revoked or expired"})
		}

		var (
			id           int64
			publicUserID string
			email        string
			name         sql.NullString
			surname      sql.NullString
			isActive     bool
		)

		err = db.QueryRowContext(ctx, `
			SELECT id, public_user_id::text, email, name, surname, COALESCE(is_active, true)
			FROM public.auth_users
			WHERE id = $1
			  AND public_user_id::text = $2
			  AND deleted_at IS NULL
			LIMIT 1
		`, claims.UID, claims.Sub).Scan(
			&id,
			&publicUserID,
			&email,
			&name,
			&surname,
			&isActive,
		)
		if err == sql.ErrNoRows {
			return c.Status(401).JSON(fiber.Map{"error": "user not found"})
		}
		if err != nil {
			fmt.Println("Database Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "cannot verify login status"})
		}
		if !isActive {
			return c.Status(403).JSON(fiber.Map{"error": "user account is inactive"})
		}

		return c.JSON(models.UserMeResponse{
			Authenticated: true,
			User: models.UserPublic{
				PublicUserID: publicUserID,
				Name:         name.String,
				Surname:      surname.String,
				Email:        email,
			},
		})
	}
}

func GetUsers(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		rows, err := db.Query("SELECT id, public_user_id, name, surname,email FROM public.auth_users")
		if err != nil {
			return c.Status(500).SendString("ดึงข้อมูลพลาด!")
		}
		defer rows.Close()

		var users []models.UserStruct
		for rows.Next() {
			var u models.UserStruct
			if err := rows.Scan(&u.ID, &u.PublicUserID, &u.Name, &u.Surname, &u.Email); err != nil {
				fmt.Println("Database Error:", err) // พิมพ์ Error ออกมาดูที่หน้าจอ Terminal
				return c.Status(500).SendString("Scan ข้อมูลพลาด!")
			}
			users = append(users, u)
		}

		return c.JSON(users)
	}
}
