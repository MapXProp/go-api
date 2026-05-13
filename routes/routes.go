package routes

import (
	"database/sql"
	"estate-map-api/handlers"

	"github.com/gofiber/fiber/v2"
)

func SetupRoutes(app *fiber.App, db *sql.DB) {
	api := app.Group("/apix")

	api.Get("/users", handlers.GetUsers(db))
	api.Post("/userRegister", handlers.UserRegister(db))
	api.Post("/userLogin", handlers.UserLogin(db))
	api.Get("/auth/google/start", handlers.GoogleLoginStart())
	api.Get("/auth/google/callback", handlers.GoogleLoginCallback(db))
	api.Get("/auth/facebook/start", handlers.FacebookLoginStart())
	api.Get("/auth/facebook/callback", handlers.FacebookLoginCallback(db))
	api.Post("/refresh", handlers.UserRefresh(db))
	api.Post("/logout", handlers.UserLogout(db))
	api.Get("/me", handlers.GetMe(db))

	// api.Get("/properties", handlers.GetProperties(db))
}
