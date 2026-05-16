package handlers

import (
	"context"
	"crypto/hmac"
	"crypto/sha256"
	"database/sql"
	"encoding/base64"
	"fmt"
	"html"
	"net/mail"
	"os"
	"strings"
	"time"
	"unicode"

	"github.com/gofiber/fiber/v2"
	"golang.org/x/crypto/bcrypt"
)

const passwordResetTTL = 30 * time.Minute

type passwordResetRequest struct {
	Email string `json:"email"`
}

type passwordResetConfirmRequest struct {
	Token    string `json:"token"`
	Password string `json:"password"`
}

func RequestPasswordReset(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		var payload passwordResetRequest
		if err := c.BodyParser(&payload); err != nil {
			return c.Status(400).JSON(fiber.Map{"error": "Invalid request"})
		}

		email := strings.TrimSpace(strings.ToLower(payload.Email))
		if _, err := mail.ParseAddress(email); err != nil {
			return c.Status(400).JSON(fiber.Map{"error": "Invalid email address"})
		}

		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()

		var (
			userID   int64
			dbEmail  string
			isActive bool
		)

		err := db.QueryRowContext(ctx, `
			SELECT id, email, COALESCE(is_active, true)
			FROM public.auth_users
			WHERE lower(email) = $1
			  AND deleted_at IS NULL
			LIMIT 1
		`, email).Scan(&userID, &dbEmail, &isActive)
		if err == sql.ErrNoRows || !isActive {
			return passwordResetAccepted(c)
		}
		if err != nil {
			fmt.Println("Password Reset Lookup Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "Cannot request password reset right now"})
		}

		token, err := createOpaqueToken()
		if err != nil {
			fmt.Println("Password Reset Token Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "Cannot request password reset right now"})
		}

		expiresAt := time.Now().UTC().Add(passwordResetTTL)
		tokenHash := hashPasswordResetToken(token)

		tx, err := db.BeginTx(ctx, nil)
		if err != nil {
			fmt.Println("Password Reset Tx Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "Cannot request password reset right now"})
		}
		defer tx.Rollback()

		if _, err := tx.ExecContext(ctx, `
			UPDATE public.auth_password_resets
			SET used_at = COALESCE(used_at, now())
			WHERE user_id = $1
			  AND used_at IS NULL
		`, userID); err != nil {
			fmt.Println("Password Reset Expire Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "Cannot request password reset right now"})
		}

		if _, err := tx.ExecContext(ctx, `
			INSERT INTO public.auth_password_resets (
				user_id, token_hash, requested_email, user_agent, ip_address, expires_at
			)
			VALUES ($1, $2, $3, $4, $5, $6)
		`, userID, tokenHash, dbEmail, c.Get("User-Agent"), c.IP(), expiresAt); err != nil {
			fmt.Println("Password Reset Insert Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "Cannot request password reset right now"})
		}

		if err := tx.Commit(); err != nil {
			fmt.Println("Password Reset Commit Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "Cannot request password reset right now"})
		}

		if err := sendPasswordResetEmail(ctx, dbEmail, token); err != nil {
			fmt.Println("Password Reset Email Error:", err)
			if _, cleanupErr := db.ExecContext(ctx, `
				UPDATE public.auth_password_resets
				SET used_at = now()
				WHERE token_hash = $1
				  AND used_at IS NULL
			`, tokenHash); cleanupErr != nil {
				fmt.Println("Password Reset Cleanup Error:", cleanupErr)
			}
			return c.Status(500).JSON(fiber.Map{"error": "Cannot send password reset email right now"})
		}

		return passwordResetAccepted(c)
	}
}

func ConfirmPasswordReset(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		var payload passwordResetConfirmRequest
		if err := c.BodyParser(&payload); err != nil {
			return c.Status(400).JSON(fiber.Map{"error": "Invalid request"})
		}

		token := strings.TrimSpace(payload.Token)
		if token == "" {
			return c.Status(400).JSON(fiber.Map{"error": "Reset link is invalid or expired"})
		}
		if err := validatePasswordStrength(payload.Password); err != nil {
			return c.Status(400).JSON(fiber.Map{"error": err.Error()})
		}

		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()

		tokenHash := hashPasswordResetToken(token)

		var (
			resetID  int64
			userID   int64
			isActive bool
		)

		err := db.QueryRowContext(ctx, `
			SELECT r.id, u.id, COALESCE(u.is_active, true)
			FROM public.auth_password_resets r
			JOIN public.auth_users u ON u.id = r.user_id
			WHERE r.token_hash = $1
			  AND r.used_at IS NULL
			  AND r.expires_at > now()
			  AND u.deleted_at IS NULL
			LIMIT 1
		`, tokenHash).Scan(&resetID, &userID, &isActive)
		if err == sql.ErrNoRows {
			return c.Status(400).JSON(fiber.Map{"error": "Reset link is invalid or expired"})
		}
		if err != nil {
			fmt.Println("Password Reset Confirm Lookup Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "Cannot reset password right now"})
		}
		if !isActive {
			return c.Status(403).JSON(fiber.Map{"error": "User account is inactive"})
		}

		hashedPassword, err := bcrypt.GenerateFromPassword([]byte(payload.Password), bcrypt.DefaultCost)
		if err != nil {
			fmt.Println("Password Hash Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "Cannot reset password right now"})
		}

		tx, err := db.BeginTx(ctx, nil)
		if err != nil {
			fmt.Println("Password Reset Confirm Tx Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "Cannot reset password right now"})
		}
		defer tx.Rollback()

		if _, err := tx.ExecContext(ctx, `
			UPDATE public.auth_users
			SET password_hash = $1,
			    password_changed_at = now(),
			    failed_attempts = 0,
			    locked_until = NULL,
			    updated_at = now()
			WHERE id = $2
		`, string(hashedPassword), userID); err != nil {
			fmt.Println("Password Reset User Update Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "Cannot reset password right now"})
		}

		if _, err := tx.ExecContext(ctx, `
			UPDATE public.auth_password_resets
			SET used_at = now()
			WHERE id = $1
			  AND used_at IS NULL
		`, resetID); err != nil {
			fmt.Println("Password Reset Mark Used Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "Cannot reset password right now"})
		}

		if _, err := tx.ExecContext(ctx, `
			UPDATE public.auth_sessions
			SET revoked_at = now(),
			    updated_at = now()
			WHERE user_id = $1
			  AND revoked_at IS NULL
		`, userID); err != nil {
			fmt.Println("Password Reset Revoke Sessions Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "Cannot reset password right now"})
		}

		if err := tx.Commit(); err != nil {
			fmt.Println("Password Reset Confirm Commit Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "Cannot reset password right now"})
		}

		clearAuthCookies(c)
		return c.JSON(fiber.Map{"success": true})
	}
}

func passwordResetAccepted(c *fiber.Ctx) error {
	return c.JSON(fiber.Map{
		"success": true,
		"message": "If an account exists for this email, a password reset link has been sent.",
	})
}

func validatePasswordStrength(password string) error {
	if len(password) < 8 {
		return fmt.Errorf("Password must be at least 8 characters")
	}

	var hasUpper, hasLower, hasNumber, hasSpecial bool
	for _, char := range password {
		switch {
		case unicode.IsUpper(char):
			hasUpper = true
		case unicode.IsLower(char):
			hasLower = true
		case unicode.IsDigit(char):
			hasNumber = true
		case unicode.IsPunct(char) || unicode.IsSymbol(char):
			hasSpecial = true
		}
	}
	if !hasUpper || !hasLower || !hasNumber || !hasSpecial {
		return fmt.Errorf("Password must include uppercase, lowercase, number, and special character")
	}
	return nil
}

func hashPasswordResetToken(token string) string {
	mac := hmac.New(sha256.New, []byte(passwordResetSecret()))
	_, _ = mac.Write([]byte(token))
	return base64.RawURLEncoding.EncodeToString(mac.Sum(nil))
}

func passwordResetSecret() string {
	if secret := os.Getenv("PASSWORD_RESET_SECRET"); secret != "" {
		return secret
	}
	return refreshTokenSecret()
}

func sendPasswordResetEmail(ctx context.Context, recipient string, token string) error {
	resetURL := frontendURL() + "/reset-password?token=" + token
	escapedResetURL := html.EscapeString(resetURL)

	htmlBody := fmt.Sprintf(`
		<div style="margin:0;padding:32px 16px;background:#f6f8fb;font-family:Arial,sans-serif;color:#111827;">
			<div style="max-width:560px;margin:0 auto;">
				<div style="text-align:center;margin-bottom:18px;font-size:28px;font-weight:800;letter-spacing:0;">
					<span style="color:#e1843b;">Map</span><span style="color:#111827;">x</span><span style="color:#2563eb;">Prop</span>
				</div>
				<div style="background:#ffffff;border:1px solid #e5e7eb;border-radius:16px;padding:32px 28px;box-shadow:0 12px 32px rgba(15,23,42,0.08);">
					<div style="text-align:center;">
						<h2 style="margin:0 0 12px;font-size:24px;line-height:1.35;color:#111827;">ตั้งรหัสผ่าน MapxProp ใหม่</h2>
						<p style="margin:0 auto 22px;max-width:420px;font-size:16px;line-height:1.7;color:#374151;">เราได้รับคำขอตั้งรหัสผ่านใหม่สำหรับบัญชี MapxProp ของคุณ</p>
						<a href="%s" style="display:inline-block;background:#2563eb;color:#ffffff;text-decoration:none;padding:13px 24px;border-radius:10px;font-size:16px;font-weight:700;box-shadow:0 6px 16px rgba(37,99,235,0.24);">
							ตั้งรหัสผ่านใหม่
						</a>
					</div>
					<p style="margin:24px 0 0;font-size:15px;line-height:1.7;color:#4b5563;text-align:center;">ลิงก์นี้จะหมดอายุภายใน 30 นาที หากคุณไม่ได้เป็นผู้ขอเปลี่ยนรหัสผ่าน สามารถละเว้นอีเมลฉบับนี้ได้</p>
					<hr style="border:none;border-top:1px solid #e5e7eb;margin:26px 0;" />
					<div style="text-align:center;">
						<h3 style="margin:0 0 10px;font-size:18px;line-height:1.4;color:#111827;">Reset your MapxProp password</h3>
						<p style="margin:0 auto 10px;max-width:430px;font-size:15px;line-height:1.7;color:#4b5563;">We received a request to reset the password for your MapxProp account.</p>
						<p style="margin:0 auto;max-width:430px;font-size:15px;line-height:1.7;color:#4b5563;">This link expires in 30 minutes. If you did not request this, you can ignore this email.</p>
					</div>
				</div>
				<p style="margin:18px auto 0;max-width:520px;text-align:center;font-size:13px;line-height:1.6;color:#6b7280;word-break:break-all;">%s</p>
			</div>
		</div>
	`, escapedResetURL, escapedResetURL)

	textBody := fmt.Sprintf(
		"ตั้งรหัสผ่าน MapxProp ใหม่\n\nเราได้รับคำขอตั้งรหัสผ่านใหม่สำหรับบัญชี MapxProp ของคุณ\nเปิดลิงก์นี้เพื่อตั้งรหัสผ่านใหม่ ลิงก์จะหมดอายุใน 30 นาที:\n%s\n\nหากคุณไม่ได้เป็นผู้ขอเปลี่ยนรหัสผ่าน สามารถละเว้นอีเมลฉบับนี้ได้\n\nReset your MapxProp password\n\nOpen this link to set a new password. It expires in 30 minutes:\n%s\n\nIf you did not request this, you can ignore this email.",
		resetURL,
		resetURL,
	)

	payload := resendEmailRequest{
		From:    resendFromEmail(),
		To:      []string{recipient},
		Subject: "ตั้งรหัสผ่านใหม่ | Reset your MapxProp password",
		HTML:    htmlBody,
		Text:    textBody,
	}

	return sendResendEmail(ctx, payload)
}
