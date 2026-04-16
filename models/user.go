package models

// User คือโครงสร้างข้อมูลของสมาชิก
type User struct {
	UserID       int    `json:"user_id"`
	PublicUserID string `json:"public_user_id"`
	Name         string `json:"name"`
	Surname      string `json:"surname"`
}
