package handlers

import (
	"database/sql"
	"estate-map-api/models" // เรียกใช้ Model

	"github.com/gofiber/fiber/v2"
)

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
				return c.Status(500).SendString("Scan ข้อมูลพลาด!")
			}
			users = append(users, u)
		}

		return c.JSON(users)
	}
}
