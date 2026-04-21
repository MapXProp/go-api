package routes

import (
	"database/sql"
	"estate-map-api/handlers" // อย่าลืมแก้ให้ตรงกับชื่อ module ใน go.mod

	"github.com/gofiber/fiber/v2"
)

// SetupRoutes คือฟังก์ชันรวมศูนย์สำหรับจัดการ URL ทั้งหมด
func SetupRoutes(app *fiber.App, db *sql.DB) {

	// สร้าง Group สำหรับ API (เพื่อความเป็นระเบียบและใส่เวอร์ชัน)
	api := app.Group("/apix") // ใส่ชื่อ Path พิเศษที่คุณตั้งไว้ใน Nginx

	// --- User Routes ---
	api.Get("/users", handlers.GetUsers(db))

	api.Post("/signupNewUser", handlers.SignUp(db)) // API สำหรับ Register

	// --- Property Routes (ถ้ามี) ---
	// api.Get("/properties", handlers.GetProperties(db))
}
