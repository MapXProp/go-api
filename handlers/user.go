package handlers

import (
	"context"
	"crypto/hmac"
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

		query := `INSERT INTO public.auth_users (public_user_id, email, password_hash) 
		          VALUES ($1, $2, $3)`
		_, err = db.ExecContext(ctx, query, publicID, registerData.Email, string(hashedPassword))

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
		response := models.UserPublic{
			PublicUserID: publicID,
			Email:        registerData.Email,
		}
		return c.Status(201).JSON(response)
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

		expiresIn := int64((24 * time.Hour).Seconds())
		token, err := createAccessToken(id, publicUserID, email, expiresIn)
		if err != nil {
			fmt.Println("Token Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "ไม่สามารถสร้าง token ได้"})
		}

		return c.JSON(models.UserLoginResponse{
			Token:        token,
			TokenType:    "Bearer",
			ExpiresIn:    expiresIn,
			PublicUserID: publicUserID,
			Name:         name.String,
			Surname:      surname.String,
			Email:        email,
		})
	}
}

func createAccessToken(userID int64, publicUserID string, email string, expiresIn int64) (string, error) {
	now := time.Now().UTC()
	header := map[string]string{
		"alg": "HS256",
		"typ": "JWT",
	}
	claims := map[string]any{
		"sub":   publicUserID,
		"uid":   userID,
		"email": email,
		"iat":   now.Unix(),
		"exp":   now.Add(time.Duration(expiresIn) * time.Second).Unix(),
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
