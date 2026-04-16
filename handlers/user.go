package handlers

import (
	"database/sql"
	"estate-map-api/models" // เรียกใช้ Model

	"github.com/gofiber/fiber/v2"
)

// GetUsers เป็นฟังก์ชันสำหรับดึงข้อมูล User ทั้งหมด
func GetUsers(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		rows, err := db.Query("SELECT user_id, public_user_id, name, surname FROM public.users")
		if err != nil {
			return c.Status(500).SendString("ดึงข้อมูลพลาด!")
		}
		defer rows.Close()

		var users []models.User
		for rows.Next() {
			var u models.User
			if err := rows.Scan(&u.UserID, &u.PublicUserID, &u.Name, &u.Surname); err != nil {
				return c.Status(500).SendString("Scan ข้อมูลพลาด!")
			}
			users = append(users, u)
		}

		return c.JSON(users)
	}
}
