package handlers

import (
	"database/sql"
	"fmt"
	"strings"

	"github.com/gofiber/fiber/v2"
)

type listingContactProfileRequest struct {
	ContactName                string `json:"contact_name"`
	ContactPhone               string `json:"contact_phone"`
	ContactPhoneSecondary      string `json:"contact_phone_secondary"`
	ContactEmail               string `json:"contact_email"`
	LineID                     string `json:"line_id"`
	InstagramHandle            string `json:"instagram_handle"`
	RoleCode                   string `json:"role_code"`
	AuthoritySourceCode        string `json:"authority_source_code"`
	OrganizationName           string `json:"organization_name"`
	OrganizationRegistrationNo string `json:"organization_registration_no"`
}

type listingContactProfileResponse struct {
	ContactName                string `json:"contact_name"`
	ContactPhone               string `json:"contact_phone"`
	ContactPhoneSecondary      string `json:"contact_phone_secondary"`
	ContactEmail               string `json:"contact_email"`
	LineID                     string `json:"line_id"`
	InstagramHandle            string `json:"instagram_handle"`
	RoleCode                   string `json:"role_code"`
	AuthoritySourceCode        string `json:"authority_source_code"`
	OrganizationName           string `json:"organization_name"`
	OrganizationRegistrationNo string `json:"organization_registration_no"`
}

func (req *listingContactProfileRequest) normalize() {
	req.ContactName = strings.TrimSpace(req.ContactName)
	req.ContactPhone = strings.TrimSpace(req.ContactPhone)
	req.ContactPhoneSecondary = strings.TrimSpace(req.ContactPhoneSecondary)
	req.ContactEmail = strings.TrimSpace(req.ContactEmail)
	req.LineID = strings.TrimSpace(req.LineID)
	req.InstagramHandle = normalizeInstagramHandle(req.InstagramHandle)
	req.RoleCode = cleanCode(req.RoleCode, "")
	req.AuthoritySourceCode = cleanCode(req.AuthoritySourceCode, "")
	req.OrganizationName = strings.TrimSpace(req.OrganizationName)
	req.OrganizationRegistrationNo = strings.TrimSpace(req.OrganizationRegistrationNo)
	if req.RoleCode == "owner" {
		req.AuthoritySourceCode = "self"
	}
}

func (req listingContactProfileRequest) validate() error {
	if req.ContactName == "" {
		return fmt.Errorf("contact name is required")
	}
	if req.ContactPhone == "" {
		return fmt.Errorf("contact phone is required")
	}
	if len([]rune(req.ContactName)) > 160 || len(req.ContactPhone) > 64 || len(req.ContactPhoneSecondary) > 64 {
		return fmt.Errorf("contact details are too long")
	}
	if len(req.ContactEmail) > 320 || len([]rune(req.LineID)) > 160 || len(req.InstagramHandle) > 64 {
		return fmt.Errorf("contact channel is too long")
	}
	if req.InstagramHandle != "" && !isValidInstagramHandle(req.InstagramHandle) {
		return fmt.Errorf("invalid Instagram username")
	}
	if !inSet(
		req.RoleCode,
		"owner",
		"owner_representative",
		"independent_broker",
		"agency_broker",
		"developer_investor_representative",
		"property_manager",
	) {
		return fmt.Errorf("invalid contact role")
	}
	if !inSet(
		req.AuthoritySourceCode,
		"self",
		"property_owner",
		"brokerage_company",
		"developer_project",
		"investor_asset_holder",
		"co_broker",
		"property_management_company",
	) {
		return fmt.Errorf("invalid contact authority source")
	}
	if req.RoleCode != "owner" && req.AuthoritySourceCode == "self" {
		return fmt.Errorf("invalid self-authority for contact role")
	}
	if inSet(req.RoleCode, "agency_broker", "developer_investor_representative") && req.OrganizationName == "" {
		return fmt.Errorf("contact organization is required for this role")
	}
	if len([]rune(req.OrganizationName)) > 160 || len(req.OrganizationRegistrationNo) > 64 {
		return fmt.Errorf("contact organization details are too long")
	}
	if req.OrganizationRegistrationNo != "" && req.OrganizationName == "" {
		return fmt.Errorf("contact organization is required with a registration number")
	}
	return nil
}

func GetMyListingContactProfile(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, err := authenticatedAccountRequest(c, db)
		if err != nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": err.Error()})
		}
		defer cancel()

		var profile listingContactProfileResponse
		err = db.QueryRowContext(ctx, `
			SELECT
				contact_name,
				contact_phone,
				COALESCE(contact_phone_secondary, ''),
				COALESCE(contact_email, ''),
				COALESCE(line_id, ''),
				COALESCE(instagram_handle, ''),
				role_code,
				authority_source_code,
				COALESCE(organization_name, ''),
				COALESCE(organization_registration_no, '')
			FROM public.user_listing_contact_profiles
			WHERE user_id = $1
		`, claims.UID).Scan(
			&profile.ContactName,
			&profile.ContactPhone,
			&profile.ContactPhoneSecondary,
			&profile.ContactEmail,
			&profile.LineID,
			&profile.InstagramHandle,
			&profile.RoleCode,
			&profile.AuthoritySourceCode,
			&profile.OrganizationName,
			&profile.OrganizationRegistrationNo,
		)
		if err == sql.ErrNoRows {
			return c.JSON(fiber.Map{"profile": nil})
		}
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read listing contact profile"})
		}
		return c.JSON(fiber.Map{"profile": profile})
	}
}

func UpsertMyListingContactProfile(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, err := authenticatedAccountRequest(c, db)
		if err != nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": err.Error()})
		}
		defer cancel()

		var req listingContactProfileRequest
		if err := c.BodyParser(&req); err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid listing contact profile payload"})
		}
		req.normalize()
		if err := req.validate(); err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": err.Error()})
		}

		var profile listingContactProfileResponse
		err = db.QueryRowContext(ctx, `
			INSERT INTO public.user_listing_contact_profiles (
				user_id,
				contact_name,
				contact_phone,
				contact_phone_secondary,
				contact_email,
				line_id,
				instagram_handle,
				role_code,
				authority_source_code,
				organization_name,
				organization_registration_no
			) VALUES (
				$1, $2, $3, NULLIF($4, ''), NULLIF($5, ''), NULLIF($6, ''),
				NULLIF($7, ''), $8, $9, NULLIF($10, ''), NULLIF($11, '')
			)
			ON CONFLICT (user_id) DO UPDATE SET
				contact_name = EXCLUDED.contact_name,
				contact_phone = EXCLUDED.contact_phone,
				contact_phone_secondary = EXCLUDED.contact_phone_secondary,
				contact_email = EXCLUDED.contact_email,
				line_id = EXCLUDED.line_id,
				instagram_handle = EXCLUDED.instagram_handle,
				role_code = EXCLUDED.role_code,
				authority_source_code = EXCLUDED.authority_source_code,
				organization_name = EXCLUDED.organization_name,
				organization_registration_no = EXCLUDED.organization_registration_no,
				updated_at = now()
			RETURNING
				contact_name,
				contact_phone,
				COALESCE(contact_phone_secondary, ''),
				COALESCE(contact_email, ''),
				COALESCE(line_id, ''),
				COALESCE(instagram_handle, ''),
				role_code,
				authority_source_code,
				COALESCE(organization_name, ''),
				COALESCE(organization_registration_no, '')
		`,
			claims.UID,
			req.ContactName,
			req.ContactPhone,
			req.ContactPhoneSecondary,
			req.ContactEmail,
			req.LineID,
			req.InstagramHandle,
			req.RoleCode,
			req.AuthoritySourceCode,
			req.OrganizationName,
			req.OrganizationRegistrationNo,
		).Scan(
			&profile.ContactName,
			&profile.ContactPhone,
			&profile.ContactPhoneSecondary,
			&profile.ContactEmail,
			&profile.LineID,
			&profile.InstagramHandle,
			&profile.RoleCode,
			&profile.AuthoritySourceCode,
			&profile.OrganizationName,
			&profile.OrganizationRegistrationNo,
		)
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot save listing contact profile"})
		}

		return c.JSON(fiber.Map{"success": true, "profile": profile})
	}
}
