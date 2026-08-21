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
	api.Post("/password-reset/request", handlers.RequestPasswordReset(db))
	api.Post("/password-reset/confirm", handlers.ConfirmPasswordReset(db))
	api.Post("/email-verification/request", handlers.RequestEmailVerification(db))
	api.Post("/email-verification/confirm", handlers.ConfirmEmailVerification(db))
	api.Get("/auth/google/start", handlers.GoogleLoginStart())
	api.Get("/auth/google/callback", handlers.GoogleLoginCallback(db))
	api.Get("/auth/facebook/start", handlers.FacebookLoginStart())
	api.Get("/auth/facebook/callback", handlers.FacebookLoginCallback(db))
	api.Get("/auth/line/start", handlers.LineLoginStart())
	api.Get("/auth/line/callback", handlers.LineLoginCallback(db))
	api.Post("/refresh", handlers.UserRefresh(db))
	api.Post("/logout", handlers.UserLogout(db))
	api.Get("/me", handlers.GetMe(db))
	api.Post("/listings", handlers.CreateListing(db))
	api.Get("/listings/:slug", handlers.GetListingBySlug(db))
	api.Get("/listing-draft", handlers.GetListingDraft(db))
	api.Put("/listing-draft", handlers.UpsertListingDraft(db))
	api.Delete("/listing-draft", handlers.DeleteListingDraft(db))
	api.Get("/search/interpret", handlers.InterpretPropertySearch(db))
	api.Get("/search/suggestions", handlers.PropertySearchSuggestions(db))
	api.Get("/properties/search", handlers.SearchProperties(db))

	// api.Get("/properties", handlers.GetProperties(db))
}
