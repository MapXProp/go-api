package database

import (
	"database/sql"
	"fmt"
	"log"
	"os" // สำหรับดึงค่าจากระบบปฏิบัติการ

	"github.com/joho/godotenv" // Library สำหรับโหลด .env
	_ "github.com/lib/pq"
)

// ConnectDB ทำหน้าที่สร้างการเชื่อมต่อกับ Database โดยดึงค่าจาก .env
func ConnectDB() *sql.DB {
	// 1. โหลดไฟล์ .env
	err := godotenv.Load()
	if err != nil {
		// ถ้าโหลดไม่ได้ให้แจ้งเตือน (แต่บางครั้งบน VPS เราอาจจะตั้งค่าในระบบแทน .env ก็ได้)
		log.Println("Warning: .env file not found, using system environment variables")
	}

	// 2. ดึงค่าจาก .env ผ่าน os.Getenv
	host := os.Getenv("DB_HOST")
	port := os.Getenv("DB_PORT")
	user := os.Getenv("DB_USER")
	password := os.Getenv("DB_PASS")
	dbname := os.Getenv("DB_NAME")

	// 3. สร้าง Connection String
	connStr := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable",
		host, port, user, password, dbname)

	// 4. เริ่มเปิดการเชื่อมต่อ
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal("Error: ไม่สามารถเปิดการเชื่อมต่อ Database ได้:", err)
	}

	// 5. ตรวจสอบว่าเชื่อมต่อได้จริงไหม
	err = db.Ping()
	if err != nil {
		log.Fatal("Error: เชื่อมต่อ Database ล้มเหลว (Ping failed):", err)
	}

	fmt.Println("Successfully connected to database via .env!")
	return db
}
