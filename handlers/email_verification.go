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

	"github.com/gofiber/fiber/v2"
)

const emailVerificationTTL = 24 * time.Hour

type emailVerificationRequest struct {
	Email string `json:"email"`
}

type emailVerificationConfirmRequest struct {
	Token string `json:"token"`
}

func RequestEmailVerification(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		var payload emailVerificationRequest
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
			userID     int64
			dbEmail    string
			isActive   bool
			isVerified bool
		)

		err := db.QueryRowContext(ctx, `
			SELECT id, email, COALESCE(is_active, true), COALESCE(is_verified, false)
			FROM public.auth_users
			WHERE lower(email) = $1
			  AND deleted_at IS NULL
			LIMIT 1
		`, email).Scan(&userID, &dbEmail, &isActive, &isVerified)
		if err == sql.ErrNoRows || !isActive || isVerified {
			return emailVerificationAccepted(c)
		}
		if err != nil {
			fmt.Println("Email Verification Lookup Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "Cannot request email verification right now"})
		}

		if err := issueEmailVerification(ctx, db, userID, dbEmail, c.Get("User-Agent"), c.IP()); err != nil {
			fmt.Println("Email Verification Send Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "Cannot send verification email right now"})
		}

		return emailVerificationAccepted(c)
	}
}

func ConfirmEmailVerification(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		var payload emailVerificationConfirmRequest
		if err := c.BodyParser(&payload); err != nil {
			return c.Status(400).JSON(fiber.Map{"error": "Invalid request"})
		}

		token := strings.TrimSpace(payload.Token)
		if token == "" {
			return c.Status(400).JSON(fiber.Map{"error": "Verification link is invalid or expired"})
		}

		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()

		var (
			verificationID int64
			userID         int64
			email          string
			isActive       bool
		)

		err := db.QueryRowContext(ctx, `
			SELECT v.id, u.id, v.email, COALESCE(u.is_active, true)
			FROM public.auth_email_verifications v
			JOIN public.auth_users u ON u.id = v.user_id
			WHERE v.token_hash = $1
			  AND v.used_at IS NULL
			  AND v.expires_at > now()
			  AND lower(u.email) = lower(v.email)
			  AND u.deleted_at IS NULL
			LIMIT 1
		`, hashEmailVerificationToken(token)).Scan(&verificationID, &userID, &email, &isActive)
		if err == sql.ErrNoRows {
			return c.Status(400).JSON(fiber.Map{"error": "Verification link is invalid or expired"})
		}
		if err != nil {
			fmt.Println("Email Verification Confirm Lookup Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "Cannot verify email right now"})
		}
		if !isActive {
			return c.Status(403).JSON(fiber.Map{"error": "User account is inactive"})
		}

		tx, err := db.BeginTx(ctx, nil)
		if err != nil {
			fmt.Println("Email Verification Tx Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "Cannot verify email right now"})
		}
		defer tx.Rollback()

		if _, err := tx.ExecContext(ctx, `
			UPDATE public.auth_users
			SET is_verified = true,
			    email_verified_at = COALESCE(email_verified_at, now()),
			    updated_at = now()
			WHERE id = $1
		`, userID); err != nil {
			fmt.Println("Email Verification User Update Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "Cannot verify email right now"})
		}

		if _, err := tx.ExecContext(ctx, `
			UPDATE public.auth_email_verifications
			SET used_at = now()
			WHERE user_id = $1
			  AND lower(email) = lower($2)
			  AND used_at IS NULL
		`, userID, email); err != nil {
			fmt.Println("Email Verification Mark Used Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "Cannot verify email right now"})
		}

		if err := tx.Commit(); err != nil {
			fmt.Println("Email Verification Commit Error:", err)
			return c.Status(500).JSON(fiber.Map{"error": "Cannot verify email right now"})
		}

		return c.JSON(fiber.Map{"success": true})
	}
}

func issueEmailVerification(ctx context.Context, db *sql.DB, userID int64, email string, userAgent string, ipAddress string) error {
	token, err := createOpaqueToken()
	if err != nil {
		return err
	}

	tokenHash := hashEmailVerificationToken(token)
	expiresAt := time.Now().UTC().Add(emailVerificationTTL)

	tx, err := db.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	if _, err := tx.ExecContext(ctx, `
		UPDATE public.auth_email_verifications
		SET used_at = COALESCE(used_at, now())
		WHERE user_id = $1
		  AND lower(email) = lower($2)
		  AND used_at IS NULL
	`, userID, email); err != nil {
		return err
	}

	if _, err := tx.ExecContext(ctx, `
		INSERT INTO public.auth_email_verifications (
			user_id, token_hash, email, user_agent, ip_address, expires_at
		)
		VALUES ($1, $2, $3, $4, $5, $6)
	`, userID, tokenHash, email, userAgent, ipAddress, expiresAt); err != nil {
		return err
	}

	if err := tx.Commit(); err != nil {
		return err
	}

	if err := sendEmailVerificationEmail(ctx, email, token); err != nil {
		if _, cleanupErr := db.ExecContext(ctx, `
			UPDATE public.auth_email_verifications
			SET used_at = now()
			WHERE token_hash = $1
			  AND used_at IS NULL
		`, tokenHash); cleanupErr != nil {
			fmt.Println("Email Verification Cleanup Error:", cleanupErr)
		}
		return err
	}

	return nil
}

func emailVerificationAccepted(c *fiber.Ctx) error {
	return c.JSON(fiber.Map{
		"success": true,
		"message": "If this email needs verification, a verification link has been sent.",
	})
}

func hashEmailVerificationToken(token string) string {
	mac := hmac.New(sha256.New, []byte(emailVerificationSecret()))
	_, _ = mac.Write([]byte(token))
	return base64.RawURLEncoding.EncodeToString(mac.Sum(nil))
}

func emailVerificationSecret() string {
	if secret := os.Getenv("EMAIL_VERIFICATION_SECRET"); secret != "" {
		return secret
	}
	return refreshTokenSecret()
}

func sendEmailVerificationEmail(ctx context.Context, recipient string, token string) error {
	verifyURL := frontendURL() + "/verify-email?token=" + token
	escapedVerifyURL := html.EscapeString(verifyURL)

	htmlBody := fmt.Sprintf(`
		<div style="font-family: Arial, sans-serif; color: #111827; font-size: 16px; line-height: 1.7;">
			<h2 style="margin: 0 0 12px;">ยืนยันอีเมล MapxProp ของคุณ</h2>
			<p>กรุณายืนยันอีเมลนี้สำหรับบัญชี MapxProp ของคุณ</p>
			<p>
				<a href="%s" style="display:inline-block;background:#111827;color:#ffffff;text-decoration:none;padding:12px 18px;border-radius:8px;font-weight:600;">
					ยืนยันอีเมล
				</a>
			</p>
			<p>ลิงก์นี้จะหมดอายุภายใน 24 ชั่วโมง หากคุณไม่ได้สมัครบัญชีนี้ สามารถละเว้นอีเมลฉบับนี้ได้</p>
			<hr style="border:none;border-top:1px solid #e5e7eb;margin:22px 0;" />
			<h3 style="margin: 0 0 10px;">Verify your MapxProp email</h3>
			<p>Please confirm this email address for your MapxProp account.</p>
			<p>This link expires in 24 hours. If you did not create this account, you can ignore this email.</p>
			<p style="font-size: 14px; color: #6b7280; line-height: 1.6;">%s</p>
		</div>
	`, escapedVerifyURL, escapedVerifyURL)

	textBody := fmt.Sprintf(
		"ยืนยันอีเมล MapxProp ของคุณ\n\nกรุณาเปิดลิงก์นี้เพื่อยืนยันอีเมลของคุณ ลิงก์จะหมดอายุใน 24 ชั่วโมง:\n%s\n\nหากคุณไม่ได้สมัครบัญชีนี้ สามารถละเว้นอีเมลฉบับนี้ได้\n\nVerify your MapxProp email\n\nOpen this link to verify your email address. It expires in 24 hours:\n%s\n\nIf you did not create this account, you can ignore this email.",
		verifyURL,
		verifyURL,
	)

	return sendResendEmail(ctx, resendEmailRequest{
		From:    resendFromEmail(),
		To:      []string{recipient},
		Subject: "ยืนยันอีเมลของคุณ | Verify your MapxProp email",
		HTML:    htmlBody,
		Text:    textBody,
	})
}
