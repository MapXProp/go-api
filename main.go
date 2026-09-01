package main

import (
	"estate-map-api/database" // ดึงการเชื่อมต่อ DB
	"estate-map-api/handlers"
	"estate-map-api/routes" // ดึงการจัดการเส้นทาง URL
	"fmt"
	"log"
	"os"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/joho/godotenv"
)

func main() {
	_ = godotenv.Load()

	// 1. เริ่มต้นสร้างแอป API
	app := fiber.New(fiber.Config{BodyLimit: 56 * 1024 * 1024})
	allowedOrigins := os.Getenv("CORS_ALLOWED_ORIGINS")
	if allowedOrigins == "" {
		allowedOrigins = "http://localhost:3000,http://127.0.0.1:3000,http://192.168.1.45:3000"
	}
	app.Use(cors.New(cors.Config{
		AllowOrigins:     allowedOrigins,
		AllowHeaders:     "Origin, Content-Type, Accept, Authorization",
		AllowMethods:     "GET, POST, PUT, PATCH, DELETE, OPTIONS",
		AllowCredentials: true,
	}))

	// 2. เชื่อมต่อ Database (เรียกใช้จากแพ็กเกจที่แยกไว้)
	db := database.ConnectDB()
	defer db.Close()
	database.EnsureAuthSchema(db)
	if err := database.RunMigrations(db); err != nil {
		log.Fatal("Error: cannot run database migrations:", err)
	}
	if err := handlers.EnsureListingMediaStorage(); err != nil {
		log.Fatal("Error: listing media storage is not writable:", err)
	}
	stopDraftCleanup := handlers.StartListingDraftCleanup(db)
	defer stopDraftCleanup()

	// 3. ตั้งค่า Routes ทั้งหมด (รวมสารบัญ API ไว้ที่นี่)
	// ตรงนี้จะไปเรียกใช้ทั้ง handlers และดึงข้อมูลจาก models ให้อัตโนมัติ
	routes.SetupRoutes(app, db)

	// 4. หน้าแรกสำหรับเช็คว่า Server รันอยู่ไหม (Optional)
	app.Get("/", func(c *fiber.Ctx) error {
		return c.SendString("MapXProp API is Online!")
	})

	// 5. สั่งให้ API รันที่พอร์ต 8080
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	fmt.Printf("Server starts at :%s\n", port)
	log.Fatal(app.Listen(":" + port))
}
