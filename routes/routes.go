package routes

import (
	"database/sql"
	"estate-map-api/handlers"

	"github.com/gofiber/fiber/v2"
)

func SetupRoutes(app *fiber.App, db *sql.DB) {
	api := app.Group("/apix")

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
	api.Patch("/me", handlers.UpdateMyProfile(db))
	api.Post("/me/password", handlers.ChangeMyPassword(db))
	api.Get("/me/listings", handlers.GetMyListings(db))
	api.Get("/me/listings/:publicListingID/edit", handlers.GetMyListingEditDraft(db))
	api.Delete("/me/listings/:publicListingID", handlers.DeleteMyListing(db))
	api.Get("/me/notifications", handlers.GetMyNotifications(db))
	api.Patch("/me/notifications/read-all", handlers.MarkAllMyNotificationsRead(db))
	api.Patch("/me/notifications/:notificationID/read", handlers.MarkMyNotificationRead(db))
	api.Get("/me/listing-contact", handlers.GetMyListingContactProfile(db))
	api.Put("/me/listing-contact", handlers.UpsertMyListingContactProfile(db))
	api.Post("/listings", handlers.CreateListing(db))
	api.Get("/listings/:slug", handlers.GetListingBySlug(db))
	api.Post("/listing-media", handlers.UploadListingMedia(db))
	api.Get("/listing-media/files/:userID/:filename", handlers.ServeListingMedia)
	api.Get("/listing-draft", handlers.GetListingDraft(db))
	api.Put("/listing-draft", handlers.UpsertListingDraft(db))
	api.Delete("/listing-draft", handlers.DeleteListingDraft(db))
	api.Get("/admin/roles", handlers.GetPlatformRoles(db))
	api.Get("/admin/users", handlers.GetAdminUsers(db))
	api.Patch("/admin/users/:publicUserID/role", handlers.UpdateAdminUserRole(db))
	api.Get("/admin/listings/review", handlers.GetAdminReviewListings(db))
	api.Get("/admin/listings/:publicListingID/review", handlers.GetAdminReviewListing(db))
	api.Patch("/admin/listings/:publicListingID/moderation", handlers.UpdateListingModeration(db))
	api.Get("/search/interpret", handlers.InterpretPropertySearch(db))
	api.Get("/search/suggestions", handlers.PropertySearchSuggestions(db))
	api.Get("/properties/search", handlers.SearchProperties(db))

	// api.Get("/properties", handlers.GetProperties(db))
}
