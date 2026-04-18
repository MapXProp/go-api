package models

// User คือโครงสร้างข้อมูลของสมาชิก
type UserStruct struct {
	ID           int    `json:"id"`
	PublicUserID string `json:"public_user_id"`
	Name         string `json:"name"`
	Surname      string `json:"surname"`
	Email        string `json:"email"`
}
