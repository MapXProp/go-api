package models

// User คือโครงสร้างข้อมูลของสมาชิก
type UserStruct struct {
	ID           int    `json:"id"`
	PublicUserID string `json:"public_user_id"`
	Name         string `json:"name"`
	Surname      string `json:"surname"`
	Email        string `json:"email"`
}

// UserRegister คือโครงสร้างข้อมูลที่รับจาก Next.js (Register Form)
type UserRegisterStruct struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type UserLoginStruct struct {
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

type UserLoginResponse struct {
	Token        string `json:"token,omitempty"`
	TokenType    string `json:"token_type"`
	ExpiresIn    int64  `json:"expires_in"`
	PublicUserID string `json:"public_user_id"`
	Name         string `json:"name"`
	Surname      string `json:"surname"`
	Email        string `json:"email"`
}

type UserMeResponse struct {
	Authenticated bool       `json:"authenticated"`
	User          UserPublic `json:"user"`
}

type UserLogoutResponse struct {
	Success bool `json:"success"`
}
