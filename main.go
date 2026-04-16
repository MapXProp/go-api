package main

import (
	"estate-map-api/database" // ดึงการเชื่อมต่อ DB
	"estate-map-api/routes"   // ดึงการจัดการเส้นทาง URL
	"fmt"
	"log"

	"github.com/gofiber/fiber/v2"
)

func main() {
	// 1. เริ่มต้นสร้างแอป API
	app := fiber.New()

	// 2. เชื่อมต่อ Database (เรียกใช้จากแพ็กเกจที่แยกไว้)
	db := database.ConnectDB()
	defer db.Close()

	// 3. ตั้งค่า Routes ทั้งหมด (รวมสารบัญ API ไว้ที่นี่)
	// ตรงนี้จะไปเรียกใช้ทั้ง handlers และดึงข้อมูลจาก models ให้อัตโนมัติ
	routes.SetupRoutes(app, db)

	// 4. หน้าแรกสำหรับเช็คว่า Server รันอยู่ไหม (Optional)
	app.Get("/", func(c *fiber.Ctx) error {
		return c.SendString("MapXProp API is Online!")
	})

	// 5. สั่งให้ API รันที่พอร์ต 8080
	fmt.Println("Server starts at :8080")
	log.Fatal(app.Listen(":8080"))
}
