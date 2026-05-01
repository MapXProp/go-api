package handlers

import (
	"context"
	"database/sql"
	"estate-map-api/models" // เรียกใช้ Model
	"fmt"
	"net/mail"
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
