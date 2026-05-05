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

	// api.Get("/properties", handlers.GetProperties(db))
}
