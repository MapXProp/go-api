package models

// User คือโครงสร้างข้อมูลของสมาชิก
type UserStruct struct {
	ID           int    `json:"id"`
	PublicUserID string `json:"public_user_id"`
	Name         string `json:"name"`
	Surname      string `json:"surname"`
	Email        string `json:"email"`
}

// UserSignup คือโครงสร้างข้อมูลที่รับจาก Next.js (Register Form)
type UserSignup struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

// UserPublic คือโครงสร้างข้อมูลที่จะส่งกลับไป (ตัด Password ออก)
type UserPublic struct {
	PublicUserID string `json:"public_user_id"`
	Name         string `json:"name"`
	Surname      string `json:"surname"`
	Email        string `json:"email"`
}
