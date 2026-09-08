package handlers

import (
	"context"
	"crypto/hmac"
	"crypto/sha256"
	"database/sql"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"html"
	"net/mail"
	"net/url"
	"regexp"
	"strings"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
)

const organizationInvitationTTL = 72 * time.Hour

var organizationSlugSeparator = regexp.MustCompile(`-+`)

type organizationSummaryResponse struct {
	PublicOrganizationID string     `json:"public_organization_id"`
	Slug                 string     `json:"slug"`
	DisplayName          string     `json:"display_name"`
	LegalName            string     `json:"legal_name"`
	OrganizationType     string     `json:"organization_type"`
	WebsiteURL           string     `json:"website_url"`
	LogoURL              string     `json:"logo_url"`
	Description          string     `json:"description"`
	VerificationStatus   string     `json:"verification_status"`
	VerificationNote     string     `json:"verification_note,omitempty"`
	VerifiedAt           *time.Time `json:"verified_at,omitempty"`
	RoleCode             string     `json:"role_code,omitempty"`
	IsPrimaryOwner       bool       `json:"is_primary_owner,omitempty"`
	MemberCount          int        `json:"member_count"`
	ListingCount         int        `json:"listing_count"`
}

type organizationContactResponse struct {
	ID           int64      `json:"id"`
	ChannelType  string     `json:"channel_type"`
	ChannelValue string     `json:"channel_value"`
	Label        string     `json:"label"`
	IsPrimary    bool       `json:"is_primary"`
	IsVerified   bool       `json:"is_verified"`
	VerifiedAt   *time.Time `json:"verified_at,omitempty"`
}

type organizationContactInput struct {
	ChannelType  string `json:"channel_type"`
	ChannelValue string `json:"channel_value"`
	Label        string `json:"label"`
	IsPrimary    bool   `json:"is_primary"`
}

type updateOrganizationContactsRequest struct {
	Contacts []organizationContactInput `json:"contacts"`
}

type organizationMemberResponse struct {
	PublicUserID   string     `json:"public_user_id"`
	Name           string     `json:"name"`
	Surname        string     `json:"surname"`
	Email          string     `json:"email"`
	RoleCode       string     `json:"role_code"`
	Status         string     `json:"status"`
	IsPrimaryOwner bool       `json:"is_primary_owner"`
	JoinedAt       *time.Time `json:"joined_at,omitempty"`
}

type organizationInvitationResponse struct {
	PublicInvitationID string     `json:"public_invitation_id"`
	Email              string     `json:"email"`
	RoleCode           string     `json:"role_code"`
	Status             string     `json:"status"`
	ExpiresAt          time.Time  `json:"expires_at"`
	AcceptedAt         *time.Time `json:"accepted_at,omitempty"`
	CreatedAt          time.Time  `json:"created_at"`
}

type createOrganizationRequest struct {
	DisplayName      string `json:"display_name"`
	LegalName        string `json:"legal_name"`
	OrganizationType string `json:"organization_type"`
	WebsiteURL       string `json:"website_url"`
}

type updateOrganizationRequest struct {
	DisplayName      string `json:"display_name"`
	LegalName        string `json:"legal_name"`
	OrganizationType string `json:"organization_type"`
	WebsiteURL       string `json:"website_url"`
	LogoURL          string `json:"logo_url"`
	Description      string `json:"description"`
}

type inviteOrganizationMemberRequest struct {
	Email    string `json:"email"`
	RoleCode string `json:"role_code"`
}

type updateOrganizationMemberRequest struct {
	RoleCode string `json:"role_code"`
	Status   string `json:"status"`
}

type transferOrganizationOwnershipRequest struct {
	PublicUserID string `json:"public_user_id"`
}

type verifyOrganizationRequest struct {
	Status           string `json:"status"`
	VerificationType string `json:"verification_type"`
	SourceURL        string `json:"source_url"`
	Note             string `json:"note"`
}

type organizationAccess struct {
	OrganizationID       int64
	PublicOrganizationID string
	DisplayName          string
	VerificationStatus   string
	RoleCode             string
	IsPrimaryOwner       bool
}

type organizationQueryRower interface {
	QueryRowContext(context.Context, string, ...any) *sql.Row
}

type organizationExecer interface {
	ExecContext(context.Context, string, ...any) (sql.Result, error)
}

func GetMyOrganizations(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, err := authenticatedAccountRequest(c, db)
		if err != nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": err.Error()})
		}
		defer cancel()

		rows, err := db.QueryContext(ctx, `
			SELECT
				o.public_organization_id::text, o.slug, o.display_name,
				COALESCE(o.legal_name, ''), o.organization_type,
				COALESCE(o.website_url, ''), COALESCE(o.logo_url, ''), COALESCE(o.description, ''),
				o.verification_status, COALESCE(o.verification_note, ''), o.verified_at,
				m.role_code, m.is_primary_owner,
				(SELECT count(*) FROM public.organization_memberships member
				 WHERE member.organization_id = o.id AND member.status = 'active'),
				(SELECT count(*) FROM public.listings listing
				 WHERE listing.organization_id = o.id AND listing.deleted_at IS NULL)
			FROM public.organization_memberships m
			JOIN public.organizations o ON o.id = m.organization_id
			WHERE m.user_id = $1
			  AND m.status = 'active'
			  AND o.is_active = true
			  AND o.deleted_at IS NULL
			ORDER BY m.is_primary_owner DESC, o.display_name, o.id
		`, claims.UID)
		if err != nil {
			return organizationDatabaseError(c, "cannot load organizations", err)
		}
		defer rows.Close()

		organizations := make([]organizationSummaryResponse, 0)
		for rows.Next() {
			var item organizationSummaryResponse
			var verifiedAt sql.NullTime
			if err := rows.Scan(
				&item.PublicOrganizationID, &item.Slug, &item.DisplayName,
				&item.LegalName, &item.OrganizationType, &item.WebsiteURL, &item.LogoURL, &item.Description,
				&item.VerificationStatus, &item.VerificationNote, &verifiedAt,
				&item.RoleCode, &item.IsPrimaryOwner, &item.MemberCount, &item.ListingCount,
			); err != nil {
				return organizationDatabaseError(c, "cannot load organizations", err)
			}
			if verifiedAt.Valid {
				item.VerifiedAt = &verifiedAt.Time
			}
			organizations = append(organizations, item)
		}
		if err := rows.Err(); err != nil {
			return organizationDatabaseError(c, "cannot load organizations", err)
		}

		return c.JSON(fiber.Map{"organizations": organizations})
	}
}

func CreateOrganization(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, err := authenticatedAccountRequest(c, db)
		if err != nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": err.Error()})
		}
		defer cancel()

		var req createOrganizationRequest
		if err := c.BodyParser(&req); err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid organization payload"})
		}
		if err := normalizeOrganizationProfile(&req.DisplayName, &req.LegalName, &req.OrganizationType, &req.WebsiteURL); err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": err.Error()})
		}

		publicID := uuid.New().String()
		slug := organizationSlug(req.DisplayName)
		var slugExists bool
		if err := db.QueryRowContext(ctx, `SELECT EXISTS (SELECT 1 FROM public.organizations WHERE slug = $1)`, slug).Scan(&slugExists); err != nil {
			return organizationDatabaseError(c, "cannot create organization", err)
		}
		if slugExists {
			slug += "-" + strings.ReplaceAll(publicID[:8], "-", "")
		}

		tx, err := db.BeginTx(ctx, nil)
		if err != nil {
			return organizationDatabaseError(c, "cannot create organization", err)
		}
		defer tx.Rollback()

		var organizationID int64
		if err := tx.QueryRowContext(ctx, `
			INSERT INTO public.organizations (
				public_organization_id, slug, display_name, legal_name,
				organization_type, website_url, created_by_user_id
			) VALUES ($1, $2, $3, NULLIF($4, ''), $5, NULLIF($6, ''), $7)
			RETURNING id
		`, publicID, slug, req.DisplayName, req.LegalName, req.OrganizationType, req.WebsiteURL, claims.UID).Scan(&organizationID); err != nil {
			return organizationDatabaseError(c, "cannot create organization", err)
		}

		if _, err := tx.ExecContext(ctx, `
			INSERT INTO public.organization_memberships (
				organization_id, user_id, role_code, status, is_primary_owner, joined_at
			) VALUES ($1, $2, 'owner', 'active', true, now())
		`, organizationID, claims.UID); err != nil {
			return organizationDatabaseError(c, "cannot create organization", err)
		}
		if err := recordOrganizationAudit(ctx, tx, organizationID, claims.UID, "organization.created", "organization", publicID, map[string]any{"display_name": req.DisplayName}); err != nil {
			return organizationDatabaseError(c, "cannot create organization", err)
		}
		if err := tx.Commit(); err != nil {
			return organizationDatabaseError(c, "cannot create organization", err)
		}

		return c.Status(fiber.StatusCreated).JSON(fiber.Map{
			"success":                true,
			"public_organization_id": publicID,
			"slug":                   slug,
		})
	}
}

func GetOrganization(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		publicID := strings.TrimSpace(c.Params("publicOrganizationID"))
		if _, err := uuid.Parse(publicID); err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid organization ID"})
		}

		ctx, cancel := context.WithTimeout(context.Background(), 8*time.Second)
		defer cancel()

		var item organizationSummaryResponse
		var organizationID int64
		var verifiedAt sql.NullTime
		err := db.QueryRowContext(ctx, `
			SELECT o.id, o.public_organization_id::text, o.slug, o.display_name,
				COALESCE(o.legal_name, ''), o.organization_type,
				COALESCE(o.website_url, ''), COALESCE(o.logo_url, ''), COALESCE(o.description, ''),
				o.verification_status, COALESCE(o.verification_note, ''), o.verified_at,
				(SELECT count(*) FROM public.organization_memberships member
				 WHERE member.organization_id = o.id AND member.status = 'active'),
				(SELECT count(*) FROM public.listings listing
				 WHERE listing.organization_id = o.id
				   AND listing.deleted_at IS NULL
				   AND listing.listing_status = 'active'
				   AND listing.moderation_status = 'approved'
				   AND listing.published_at IS NOT NULL)
			FROM public.organizations o
			WHERE o.public_organization_id::text = $1
			  AND o.is_active = true
			  AND o.deleted_at IS NULL
			LIMIT 1
		`, publicID).Scan(
			&organizationID, &item.PublicOrganizationID, &item.Slug, &item.DisplayName,
			&item.LegalName, &item.OrganizationType, &item.WebsiteURL, &item.LogoURL, &item.Description,
			&item.VerificationStatus, &item.VerificationNote, &verifiedAt,
			&item.MemberCount, &item.ListingCount,
		)
		if err == sql.ErrNoRows {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{"error": "organization not found"})
		}
		if err != nil {
			return organizationDatabaseError(c, "cannot load organization", err)
		}
		if verifiedAt.Valid {
			item.VerifiedAt = &verifiedAt.Time
		}
		item.VerificationNote = ""

		contacts, err := loadPublicOrganizationContacts(ctx, db, organizationID)
		if err != nil {
			return organizationDatabaseError(c, "cannot load organization", err)
		}
		return c.JSON(fiber.Map{"organization": item, "contacts": contacts})
	}
}

func UpdateOrganizationContacts(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, err := authenticatedAccountRequest(c, db)
		if err != nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": err.Error()})
		}
		defer cancel()
		access, err := loadOrganizationAccess(ctx, db, strings.TrimSpace(c.Params("publicOrganizationID")), claims.UID)
		if err != nil {
			return organizationAccessError(c, err)
		}
		if !organizationRoleAtLeast(access.RoleCode, "admin") {
			return c.Status(fiber.StatusForbidden).JSON(fiber.Map{"error": "organization admin permission required"})
		}

		var req updateOrganizationContactsRequest
		if err := c.BodyParser(&req); err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid contacts payload"})
		}
		if len(req.Contacts) > 20 {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "an organization can have at most 20 public contacts"})
		}
		seen := make(map[string]bool, len(req.Contacts))
		primarySeen := make(map[string]bool)
		for index := range req.Contacts {
			contact := &req.Contacts[index]
			contact.ChannelType = strings.ToLower(strings.TrimSpace(contact.ChannelType))
			contact.ChannelValue = strings.TrimSpace(contact.ChannelValue)
			contact.Label = strings.TrimSpace(contact.Label)
			if err := validateOrganizationContact(*contact); err != nil {
				return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": err.Error()})
			}
			key := contact.ChannelType + "\x00" + strings.ToLower(contact.ChannelValue)
			if seen[key] {
				return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "duplicate organization contact"})
			}
			seen[key] = true
			if contact.IsPrimary {
				if primarySeen[contact.ChannelType] {
					return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "choose only one primary contact for each channel"})
				}
				primarySeen[contact.ChannelType] = true
			}
		}

		tx, err := db.BeginTx(ctx, nil)
		if err != nil {
			return organizationDatabaseError(c, "cannot update organization contacts", err)
		}
		defer tx.Rollback()
		if _, err := tx.ExecContext(ctx, `
			UPDATE public.organization_contacts
			SET is_public = false, is_primary = false, updated_at = now()
			WHERE organization_id = $1
		`, access.OrganizationID); err != nil {
			return organizationDatabaseError(c, "cannot update organization contacts", err)
		}
		for _, contact := range req.Contacts {
			if _, err := tx.ExecContext(ctx, `
				INSERT INTO public.organization_contacts (
					organization_id, channel_type, channel_value, label, is_primary, is_public
				) VALUES ($1, $2, $3, NULLIF($4, ''), $5, true)
				ON CONFLICT (organization_id, channel_type, channel_value) DO UPDATE SET
					label = EXCLUDED.label,
					is_primary = EXCLUDED.is_primary,
					is_public = true,
					updated_at = now()
			`, access.OrganizationID, contact.ChannelType, contact.ChannelValue, contact.Label, contact.IsPrimary); err != nil {
				return organizationDatabaseError(c, "cannot update organization contacts", err)
			}
		}
		if err := recordOrganizationAudit(ctx, tx, access.OrganizationID, claims.UID, "contacts.updated", "organization", access.PublicOrganizationID, map[string]any{"contact_count": len(req.Contacts)}); err != nil {
			return organizationDatabaseError(c, "cannot update organization contacts", err)
		}
		if err := tx.Commit(); err != nil {
			return organizationDatabaseError(c, "cannot update organization contacts", err)
		}
		return c.JSON(fiber.Map{"success": true})
	}
}

func UpdateOrganization(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, err := authenticatedAccountRequest(c, db)
		if err != nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": err.Error()})
		}
		defer cancel()

		access, err := loadOrganizationAccess(ctx, db, strings.TrimSpace(c.Params("publicOrganizationID")), claims.UID)
		if err != nil {
			return organizationAccessError(c, err)
		}
		if !organizationRoleAtLeast(access.RoleCode, "admin") {
			return c.Status(fiber.StatusForbidden).JSON(fiber.Map{"error": "organization admin permission required"})
		}

		var req updateOrganizationRequest
		if err := c.BodyParser(&req); err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid organization payload"})
		}
		if err := normalizeOrganizationProfile(&req.DisplayName, &req.LegalName, &req.OrganizationType, &req.WebsiteURL); err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": err.Error()})
		}
		req.LogoURL = strings.TrimSpace(req.LogoURL)
		req.Description = strings.TrimSpace(req.Description)
		if len([]rune(req.Description)) > 2000 || len(req.LogoURL) > 2000 {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "organization profile is too long"})
		}

		if _, err := db.ExecContext(ctx, `
			UPDATE public.organizations
			SET display_name = $1,
				legal_name = NULLIF($2, ''),
				organization_type = $3,
				website_url = NULLIF($4, ''),
				logo_url = NULLIF($5, ''),
				description = NULLIF($6, ''),
				updated_at = now()
			WHERE id = $7
		`, req.DisplayName, req.LegalName, req.OrganizationType, req.WebsiteURL, req.LogoURL, req.Description, access.OrganizationID); err != nil {
			return organizationDatabaseError(c, "cannot update organization", err)
		}
		_ = recordOrganizationAudit(ctx, db, access.OrganizationID, claims.UID, "organization.updated", "organization", access.PublicOrganizationID, nil)
		return c.JSON(fiber.Map{"success": true})
	}
}

func GetOrganizationMembers(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, err := authenticatedAccountRequest(c, db)
		if err != nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": err.Error()})
		}
		defer cancel()
		access, err := loadOrganizationAccess(ctx, db, strings.TrimSpace(c.Params("publicOrganizationID")), claims.UID)
		if err != nil {
			return organizationAccessError(c, err)
		}

		rows, err := db.QueryContext(ctx, `
			SELECT u.public_user_id::text, COALESCE(u.name, ''), COALESCE(u.surname, ''),
				u.email, m.role_code, m.status, m.is_primary_owner, m.joined_at
			FROM public.organization_memberships m
			JOIN public.auth_users u ON u.id = m.user_id
			WHERE m.organization_id = $1
			  AND m.status <> 'removed'
			  AND u.deleted_at IS NULL
			ORDER BY m.is_primary_owner DESC,
				CASE m.role_code WHEN 'owner' THEN 0 WHEN 'admin' THEN 1 WHEN 'publisher' THEN 2 WHEN 'editor' THEN 3 ELSE 4 END,
				lower(u.email)
		`, access.OrganizationID)
		if err != nil {
			return organizationDatabaseError(c, "cannot load organization members", err)
		}
		defer rows.Close()

		members := make([]organizationMemberResponse, 0)
		for rows.Next() {
			var member organizationMemberResponse
			var joinedAt sql.NullTime
			if err := rows.Scan(&member.PublicUserID, &member.Name, &member.Surname, &member.Email, &member.RoleCode, &member.Status, &member.IsPrimaryOwner, &joinedAt); err != nil {
				return organizationDatabaseError(c, "cannot load organization members", err)
			}
			if joinedAt.Valid {
				member.JoinedAt = &joinedAt.Time
			}
			members = append(members, member)
		}
		if err := rows.Err(); err != nil {
			return organizationDatabaseError(c, "cannot load organization members", err)
		}
		return c.JSON(fiber.Map{"members": members, "my_role_code": access.RoleCode})
	}
}

func InviteOrganizationMember(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, err := authenticatedAccountRequest(c, db)
		if err != nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": err.Error()})
		}
		defer cancel()
		access, err := loadOrganizationAccess(ctx, db, strings.TrimSpace(c.Params("publicOrganizationID")), claims.UID)
		if err != nil {
			return organizationAccessError(c, err)
		}
		if !organizationRoleAtLeast(access.RoleCode, "admin") {
			return c.Status(fiber.StatusForbidden).JSON(fiber.Map{"error": "organization admin permission required"})
		}

		var req inviteOrganizationMemberRequest
		if err := c.BodyParser(&req); err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid invitation payload"})
		}
		req.Email = strings.ToLower(strings.TrimSpace(req.Email))
		req.RoleCode = strings.ToLower(strings.TrimSpace(req.RoleCode))
		parsedEmail, err := mail.ParseAddress(req.Email)
		if err != nil || !strings.EqualFold(parsedEmail.Address, req.Email) {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid email address"})
		}
		if !organizationInvitationRole(req.RoleCode) {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid organization role"})
		}
		if access.RoleCode == "admin" && req.RoleCode == "admin" {
			return c.Status(fiber.StatusForbidden).JSON(fiber.Map{"error": "only an organization owner can invite admins"})
		}

		var alreadyMember bool
		if err := db.QueryRowContext(ctx, `
			SELECT EXISTS (
				SELECT 1
				FROM public.organization_memberships m
				JOIN public.auth_users u ON u.id = m.user_id
				WHERE m.organization_id = $1
				  AND lower(u.email) = $2
				  AND m.status = 'active'
				  AND u.deleted_at IS NULL
			)
		`, access.OrganizationID, req.Email).Scan(&alreadyMember); err != nil {
			return organizationDatabaseError(c, "cannot create invitation", err)
		}
		if alreadyMember {
			return c.Status(fiber.StatusConflict).JSON(fiber.Map{"error": "this email is already an organization member"})
		}

		token, err := createOpaqueToken()
		if err != nil {
			return organizationDatabaseError(c, "cannot create invitation", err)
		}
		tokenHash := hashOrganizationInvitationToken(token)
		invitationID := uuid.New().String()
		expiresAt := time.Now().UTC().Add(organizationInvitationTTL)

		tx, err := db.BeginTx(ctx, nil)
		if err != nil {
			return organizationDatabaseError(c, "cannot create invitation", err)
		}
		defer tx.Rollback()
		if _, err := tx.ExecContext(ctx, `
			UPDATE public.organization_invitations
			SET status = 'revoked', revoked_at = now(), updated_at = now()
			WHERE organization_id = $1 AND lower(email) = $2 AND status = 'pending'
		`, access.OrganizationID, req.Email); err != nil {
			return organizationDatabaseError(c, "cannot create invitation", err)
		}
		if _, err := tx.ExecContext(ctx, `
			INSERT INTO public.organization_invitations (
				public_invitation_id, organization_id, email, role_code,
				token_hash, status, invited_by_user_id, expires_at
			) VALUES ($1, $2, $3, $4, $5, 'pending', $6, $7)
		`, invitationID, access.OrganizationID, req.Email, req.RoleCode, tokenHash, claims.UID, expiresAt); err != nil {
			return organizationDatabaseError(c, "cannot create invitation", err)
		}
		if err := recordOrganizationAudit(ctx, tx, access.OrganizationID, claims.UID, "member.invited", "invitation", invitationID, map[string]any{"email": req.Email, "role_code": req.RoleCode}); err != nil {
			return organizationDatabaseError(c, "cannot create invitation", err)
		}
		if err := tx.Commit(); err != nil {
			return organizationDatabaseError(c, "cannot create invitation", err)
		}

		if err := sendOrganizationInvitationEmail(ctx, req.Email, access.DisplayName, req.RoleCode, token); err != nil {
			_, _ = db.ExecContext(ctx, `
				UPDATE public.organization_invitations
				SET status = 'revoked', revoked_at = now(), updated_at = now()
				WHERE public_invitation_id::text = $1 AND status = 'pending'
			`, invitationID)
			return organizationDatabaseError(c, "cannot send organization invitation", err)
		}

		return c.Status(fiber.StatusCreated).JSON(fiber.Map{"success": true, "public_invitation_id": invitationID, "expires_at": expiresAt})
	}
}

func GetOrganizationInvitations(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, err := authenticatedAccountRequest(c, db)
		if err != nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": err.Error()})
		}
		defer cancel()
		access, err := loadOrganizationAccess(ctx, db, strings.TrimSpace(c.Params("publicOrganizationID")), claims.UID)
		if err != nil {
			return organizationAccessError(c, err)
		}
		if !organizationRoleAtLeast(access.RoleCode, "admin") {
			return c.Status(fiber.StatusForbidden).JSON(fiber.Map{"error": "organization admin permission required"})
		}

		rows, err := db.QueryContext(ctx, `
			SELECT public_invitation_id::text, email, role_code, status, expires_at, accepted_at, created_at
			FROM public.organization_invitations
			WHERE organization_id = $1
			  AND status IN ('pending', 'accepted')
			ORDER BY created_at DESC, id DESC
			LIMIT 100
		`, access.OrganizationID)
		if err != nil {
			return organizationDatabaseError(c, "cannot load invitations", err)
		}
		defer rows.Close()
		invitations := make([]organizationInvitationResponse, 0)
		for rows.Next() {
			var item organizationInvitationResponse
			var acceptedAt sql.NullTime
			if err := rows.Scan(&item.PublicInvitationID, &item.Email, &item.RoleCode, &item.Status, &item.ExpiresAt, &acceptedAt, &item.CreatedAt); err != nil {
				return organizationDatabaseError(c, "cannot load invitations", err)
			}
			if acceptedAt.Valid {
				item.AcceptedAt = &acceptedAt.Time
			}
			invitations = append(invitations, item)
		}
		return c.JSON(fiber.Map{"invitations": invitations})
	}
}

func GetOrganizationInvitation(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		token := strings.TrimSpace(c.Params("token"))
		if token == "" || len(token) > 512 {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid invitation"})
		}
		ctx, cancel := context.WithTimeout(context.Background(), 8*time.Second)
		defer cancel()
		var displayName, roleCode, status, email string
		var expiresAt time.Time
		err := db.QueryRowContext(ctx, `
			SELECT o.display_name, i.role_code, i.status, i.email, i.expires_at
			FROM public.organization_invitations i
			JOIN public.organizations o ON o.id = i.organization_id
			WHERE i.token_hash = $1
			  AND o.is_active = true
			  AND o.deleted_at IS NULL
			LIMIT 1
		`, hashOrganizationInvitationToken(token)).Scan(&displayName, &roleCode, &status, &email, &expiresAt)
		if err == sql.ErrNoRows {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{"error": "invitation not found"})
		}
		if err != nil {
			return organizationDatabaseError(c, "cannot load invitation", err)
		}
		if status == "pending" && time.Now().UTC().After(expiresAt) {
			status = "expired"
		}
		return c.JSON(fiber.Map{
			"organization_name": displayName,
			"role_code":         roleCode,
			"status":            status,
			"email":             maskOrganizationInvitationEmail(email),
			"expires_at":        expiresAt,
		})
	}
}

func AcceptOrganizationInvitation(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, err := authenticatedAccountRequest(c, db)
		if err != nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": err.Error()})
		}
		defer cancel()
		token := strings.TrimSpace(c.Params("token"))
		if token == "" || len(token) > 512 {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid invitation"})
		}

		tx, err := db.BeginTx(ctx, nil)
		if err != nil {
			return organizationDatabaseError(c, "cannot accept invitation", err)
		}
		defer tx.Rollback()
		var invitationID, organizationID int64
		var publicOrganizationID, displayName, recipientEmail, roleCode, status string
		var expiresAt time.Time
		err = tx.QueryRowContext(ctx, `
			SELECT i.id, i.organization_id, o.public_organization_id::text, o.display_name,
				i.email, i.role_code, i.status, i.expires_at
			FROM public.organization_invitations i
			JOIN public.organizations o ON o.id = i.organization_id
			WHERE i.token_hash = $1
			  AND o.is_active = true
			  AND o.deleted_at IS NULL
			FOR UPDATE
		`, hashOrganizationInvitationToken(token)).Scan(&invitationID, &organizationID, &publicOrganizationID, &displayName, &recipientEmail, &roleCode, &status, &expiresAt)
		if err == sql.ErrNoRows {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{"error": "invitation not found"})
		}
		if err != nil {
			return organizationDatabaseError(c, "cannot accept invitation", err)
		}
		if status != "pending" {
			return c.Status(fiber.StatusConflict).JSON(fiber.Map{"error": "invitation is no longer available"})
		}
		if time.Now().UTC().After(expiresAt) {
			_, _ = tx.ExecContext(ctx, `UPDATE public.organization_invitations SET status = 'expired', updated_at = now() WHERE id = $1`, invitationID)
			_ = tx.Commit()
			return c.Status(fiber.StatusGone).JSON(fiber.Map{"error": "invitation has expired"})
		}
		if !strings.EqualFold(strings.TrimSpace(claims.Email), strings.TrimSpace(recipientEmail)) {
			return c.Status(fiber.StatusForbidden).JSON(fiber.Map{"error": "sign in with the invited email address"})
		}

		if _, err := tx.ExecContext(ctx, `
			INSERT INTO public.organization_memberships (
				organization_id, user_id, role_code, status, is_primary_owner, invited_by_user_id, joined_at
			)
			SELECT organization_id, $1, role_code, 'active', false, invited_by_user_id, now()
			FROM public.organization_invitations WHERE id = $2
			ON CONFLICT (organization_id, user_id) DO UPDATE SET
				role_code = EXCLUDED.role_code,
				status = 'active',
				is_primary_owner = false,
				invited_by_user_id = EXCLUDED.invited_by_user_id,
				joined_at = now(),
				updated_at = now()
		`, claims.UID, invitationID); err != nil {
			return organizationDatabaseError(c, "cannot accept invitation", err)
		}
		if _, err := tx.ExecContext(ctx, `
			UPDATE public.organization_invitations
			SET status = 'accepted', accepted_by_user_id = $1, accepted_at = now(), updated_at = now()
			WHERE id = $2
		`, claims.UID, invitationID); err != nil {
			return organizationDatabaseError(c, "cannot accept invitation", err)
		}
		if err := recordOrganizationAudit(ctx, tx, organizationID, claims.UID, "member.joined", "user", claims.Sub, map[string]any{"role_code": roleCode}); err != nil {
			return organizationDatabaseError(c, "cannot accept invitation", err)
		}
		if err := tx.Commit(); err != nil {
			return organizationDatabaseError(c, "cannot accept invitation", err)
		}
		return c.JSON(fiber.Map{"success": true, "public_organization_id": publicOrganizationID, "organization_name": displayName, "role_code": roleCode})
	}
}

func UpdateOrganizationMember(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, err := authenticatedAccountRequest(c, db)
		if err != nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": err.Error()})
		}
		defer cancel()
		access, err := loadOrganizationAccess(ctx, db, strings.TrimSpace(c.Params("publicOrganizationID")), claims.UID)
		if err != nil {
			return organizationAccessError(c, err)
		}
		if !organizationRoleAtLeast(access.RoleCode, "admin") {
			return c.Status(fiber.StatusForbidden).JSON(fiber.Map{"error": "organization admin permission required"})
		}

		var req updateOrganizationMemberRequest
		if err := c.BodyParser(&req); err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid member payload"})
		}
		req.RoleCode = strings.ToLower(strings.TrimSpace(req.RoleCode))
		req.Status = strings.ToLower(strings.TrimSpace(req.Status))
		if !organizationInvitationRole(req.RoleCode) || (req.Status != "active" && req.Status != "suspended" && req.Status != "removed") {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid member role or status"})
		}

		targetPublicID := strings.TrimSpace(c.Params("publicUserID"))
		var targetUserID int64
		var currentRole string
		var isPrimaryOwner bool
		err = db.QueryRowContext(ctx, `
			SELECT m.user_id, m.role_code, m.is_primary_owner
			FROM public.organization_memberships m
			JOIN public.auth_users u ON u.id = m.user_id
			WHERE m.organization_id = $1 AND u.public_user_id::text = $2 AND m.status <> 'removed'
			LIMIT 1
		`, access.OrganizationID, targetPublicID).Scan(&targetUserID, &currentRole, &isPrimaryOwner)
		if err == sql.ErrNoRows {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{"error": "organization member not found"})
		}
		if err != nil {
			return organizationDatabaseError(c, "cannot update member", err)
		}
		if targetUserID == claims.UID || isPrimaryOwner || currentRole == "owner" {
			return c.Status(fiber.StatusConflict).JSON(fiber.Map{"error": "use ownership transfer to change the organization owner"})
		}
		if access.RoleCode == "admin" && (currentRole == "admin" || req.RoleCode == "admin") {
			return c.Status(fiber.StatusForbidden).JSON(fiber.Map{"error": "only an organization owner can manage admins"})
		}

		if _, err := db.ExecContext(ctx, `
			UPDATE public.organization_memberships
			SET role_code = $1, status = $2, updated_at = now()
			WHERE organization_id = $3 AND user_id = $4
		`, req.RoleCode, req.Status, access.OrganizationID, targetUserID); err != nil {
			return organizationDatabaseError(c, "cannot update member", err)
		}
		_ = recordOrganizationAudit(ctx, db, access.OrganizationID, claims.UID, "member.updated", "user", targetPublicID, map[string]any{"role_code": req.RoleCode, "status": req.Status})
		return c.JSON(fiber.Map{"success": true})
	}
}

func TransferOrganizationOwnership(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, err := authenticatedAccountRequest(c, db)
		if err != nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": err.Error()})
		}
		defer cancel()
		access, err := loadOrganizationAccess(ctx, db, strings.TrimSpace(c.Params("publicOrganizationID")), claims.UID)
		if err != nil {
			return organizationAccessError(c, err)
		}
		if access.RoleCode != "owner" || !access.IsPrimaryOwner {
			return c.Status(fiber.StatusForbidden).JSON(fiber.Map{"error": "primary organization owner permission required"})
		}
		var req transferOrganizationOwnershipRequest
		if err := c.BodyParser(&req); err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid ownership transfer payload"})
		}
		req.PublicUserID = strings.TrimSpace(req.PublicUserID)
		if req.PublicUserID == "" || req.PublicUserID == claims.Sub {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "choose another active organization member"})
		}

		tx, err := db.BeginTx(ctx, nil)
		if err != nil {
			return organizationDatabaseError(c, "cannot transfer ownership", err)
		}
		defer tx.Rollback()
		var targetUserID int64
		err = tx.QueryRowContext(ctx, `
			SELECT m.user_id
			FROM public.organization_memberships m
			JOIN public.auth_users u ON u.id = m.user_id
			WHERE m.organization_id = $1
			  AND u.public_user_id::text = $2
			  AND m.status = 'active'
			  AND u.deleted_at IS NULL
			FOR UPDATE
		`, access.OrganizationID, req.PublicUserID).Scan(&targetUserID)
		if err == sql.ErrNoRows {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{"error": "target member not found"})
		}
		if err != nil {
			return organizationDatabaseError(c, "cannot transfer ownership", err)
		}
		if _, err := tx.ExecContext(ctx, `
			UPDATE public.organization_memberships
			SET role_code = 'admin', is_primary_owner = false, updated_at = now()
			WHERE organization_id = $1 AND user_id = $2
		`, access.OrganizationID, claims.UID); err != nil {
			return organizationDatabaseError(c, "cannot transfer ownership", err)
		}
		if _, err := tx.ExecContext(ctx, `
			UPDATE public.organization_memberships
			SET role_code = 'owner', is_primary_owner = true, updated_at = now()
			WHERE organization_id = $1 AND user_id = $2
		`, access.OrganizationID, targetUserID); err != nil {
			return organizationDatabaseError(c, "cannot transfer ownership", err)
		}
		if err := recordOrganizationAudit(ctx, tx, access.OrganizationID, claims.UID, "ownership.transferred", "user", req.PublicUserID, map[string]any{"previous_owner": claims.Sub}); err != nil {
			return organizationDatabaseError(c, "cannot transfer ownership", err)
		}
		if err := tx.Commit(); err != nil {
			return organizationDatabaseError(c, "cannot transfer ownership", err)
		}
		return c.JSON(fiber.Map{"success": true})
	}
}

func VerifyOrganization(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, statusCode, err := requireSuperAdmin(c, db)
		if err != nil {
			return platformRoleAuthError(c, statusCode, err)
		}
		defer cancel()
		var req verifyOrganizationRequest
		if err := c.BodyParser(&req); err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid verification payload"})
		}
		req.Status = strings.ToLower(strings.TrimSpace(req.Status))
		req.VerificationType = strings.ToLower(strings.TrimSpace(req.VerificationType))
		req.SourceURL = strings.TrimSpace(req.SourceURL)
		req.Note = strings.TrimSpace(req.Note)
		if req.Status != "unverified" && req.Status != "contact_checked" && req.Status != "verified" && req.Status != "rejected" {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid verification status"})
		}
		if req.VerificationType == "" {
			req.VerificationType = "legal_entity"
		}
		if req.VerificationType != "domain" && req.VerificationType != "contact" && req.VerificationType != "legal_entity" && req.VerificationType != "listing_authority" {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid verification type"})
		}

		publicID := strings.TrimSpace(c.Params("publicOrganizationID"))
		tx, err := db.BeginTx(ctx, nil)
		if err != nil {
			return organizationDatabaseError(c, "cannot verify organization", err)
		}
		defer tx.Rollback()
		var organizationID int64
		err = tx.QueryRowContext(ctx, `
			UPDATE public.organizations
			SET verification_status = $1,
				verification_note = NULLIF($2, ''),
				verified_at = CASE WHEN $1 IN ('contact_checked', 'verified') THEN now() ELSE NULL END,
				verified_by_user_id = CASE WHEN $1 IN ('contact_checked', 'verified') THEN $3 ELSE NULL END,
				updated_at = now()
			WHERE public_organization_id::text = $4 AND deleted_at IS NULL
			RETURNING id
		`, req.Status, req.Note, claims.UID, publicID).Scan(&organizationID)
		if err == sql.ErrNoRows {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{"error": "organization not found"})
		}
		if err != nil {
			return organizationDatabaseError(c, "cannot verify organization", err)
		}
		verificationRecordStatus := "verified"
		if req.Status == "rejected" {
			verificationRecordStatus = "rejected"
		} else if req.Status == "unverified" {
			verificationRecordStatus = "pending"
		}
		if _, err := tx.ExecContext(ctx, `
			INSERT INTO public.organization_verifications (
				organization_id, verification_type, status, source_url,
				evidence_note, reviewed_by_user_id, reviewed_at
			) VALUES ($1, $2, $3, NULLIF($4, ''), NULLIF($5, ''), $6, now())
		`, organizationID, req.VerificationType, verificationRecordStatus, req.SourceURL, req.Note, claims.UID); err != nil {
			return organizationDatabaseError(c, "cannot verify organization", err)
		}
		if err := recordOrganizationAudit(ctx, tx, organizationID, claims.UID, "verification.updated", "organization", publicID, map[string]any{"status": req.Status, "verification_type": req.VerificationType}); err != nil {
			return organizationDatabaseError(c, "cannot verify organization", err)
		}
		if err := tx.Commit(); err != nil {
			return organizationDatabaseError(c, "cannot verify organization", err)
		}
		return c.JSON(fiber.Map{"success": true, "verification_status": req.Status})
	}
}

func loadOrganizationAccess(ctx context.Context, db organizationQueryRower, publicID string, userID int64) (organizationAccess, error) {
	var access organizationAccess
	if _, err := uuid.Parse(publicID); err != nil {
		return access, fmt.Errorf("invalid organization ID")
	}
	err := db.QueryRowContext(ctx, `
		SELECT o.id, o.public_organization_id::text, o.display_name, o.verification_status,
			m.role_code, m.is_primary_owner
		FROM public.organizations o
		JOIN public.organization_memberships m ON m.organization_id = o.id
		WHERE o.public_organization_id::text = $1
		  AND m.user_id = $2
		  AND m.status = 'active'
		  AND o.is_active = true
		  AND o.deleted_at IS NULL
		LIMIT 1
	`, publicID, userID).Scan(
		&access.OrganizationID, &access.PublicOrganizationID, &access.DisplayName,
		&access.VerificationStatus, &access.RoleCode, &access.IsPrimaryOwner,
	)
	return access, err
}

func organizationAccessError(c *fiber.Ctx, err error) error {
	if err == sql.ErrNoRows {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{"error": "organization not found"})
	}
	if strings.Contains(err.Error(), "invalid organization ID") {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": err.Error()})
	}
	return organizationDatabaseError(c, "cannot verify organization access", err)
}

func organizationRoleAtLeast(role, required string) bool {
	rank := map[string]int{"viewer": 1, "editor": 2, "publisher": 3, "admin": 4, "owner": 5}
	return rank[role] >= rank[required]
}

func organizationInvitationRole(role string) bool {
	return role == "admin" || role == "publisher" || role == "editor" || role == "viewer"
}

func normalizeOrganizationProfile(displayName, legalName, organizationType, websiteURL *string) error {
	*displayName = strings.TrimSpace(*displayName)
	*legalName = strings.TrimSpace(*legalName)
	*organizationType = strings.ToLower(strings.TrimSpace(*organizationType))
	*websiteURL = strings.TrimSpace(*websiteURL)
	if len([]rune(*displayName)) < 2 || len([]rune(*displayName)) > 160 {
		return fmt.Errorf("organization display name must be 2 to 160 characters")
	}
	if len([]rune(*legalName)) > 240 {
		return fmt.Errorf("organization legal name is too long")
	}
	allowedTypes := map[string]bool{
		"agency": true, "developer": true, "bank_npa": true, "asset_manager": true,
		"property_company": true, "corporate": true, "team": true, "other": true,
	}
	if !allowedTypes[*organizationType] {
		return fmt.Errorf("invalid organization type")
	}
	if *websiteURL != "" {
		parsed, err := url.ParseRequestURI(*websiteURL)
		if err != nil || (parsed.Scheme != "http" && parsed.Scheme != "https") || parsed.Host == "" {
			return fmt.Errorf("invalid organization website URL")
		}
	}
	return nil
}

func validateOrganizationContact(contact organizationContactInput) error {
	if !map[string]bool{"phone": true, "email": true, "line": true, "website": true}[contact.ChannelType] {
		return fmt.Errorf("invalid organization contact channel")
	}
	if contact.ChannelValue == "" || len([]rune(contact.ChannelValue)) > 500 || len([]rune(contact.Label)) > 120 {
		return fmt.Errorf("invalid organization contact value")
	}
	switch contact.ChannelType {
	case "email":
		address, err := mail.ParseAddress(contact.ChannelValue)
		if err != nil || !strings.EqualFold(address.Address, contact.ChannelValue) {
			return fmt.Errorf("invalid organization contact email")
		}
	case "website":
		parsed, err := url.ParseRequestURI(contact.ChannelValue)
		if err != nil || (parsed.Scheme != "http" && parsed.Scheme != "https") || parsed.Host == "" {
			return fmt.Errorf("invalid organization contact website")
		}
	case "phone":
		digitCount := 0
		for _, char := range contact.ChannelValue {
			if char >= '0' && char <= '9' {
				digitCount++
			}
		}
		if digitCount < 8 || digitCount > 16 {
			return fmt.Errorf("invalid organization contact phone")
		}
	}
	return nil
}

func organizationSlug(value string) string {
	var builder strings.Builder
	lastDash := false
	for _, char := range strings.ToLower(strings.TrimSpace(value)) {
		if (char >= 'a' && char <= 'z') || (char >= '0' && char <= '9') {
			builder.WriteRune(char)
			lastDash = false
			continue
		}
		if !lastDash && builder.Len() > 0 {
			builder.WriteByte('-')
			lastDash = true
		}
	}
	slug := strings.Trim(organizationSlugSeparator.ReplaceAllString(builder.String(), "-"), "-")
	if slug == "" {
		return "organization-" + strings.ReplaceAll(uuid.New().String()[:8], "-", "")
	}
	if len(slug) > 120 {
		slug = strings.Trim(slug[:120], "-")
	}
	return slug
}

func loadPublicOrganizationContacts(ctx context.Context, db *sql.DB, organizationID int64) ([]organizationContactResponse, error) {
	rows, err := db.QueryContext(ctx, `
		SELECT id, channel_type, channel_value, COALESCE(label, ''), is_primary, is_verified, verified_at
		FROM public.organization_contacts
		WHERE organization_id = $1 AND is_public = true
		ORDER BY channel_type, is_primary DESC, id
	`, organizationID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	contacts := make([]organizationContactResponse, 0)
	for rows.Next() {
		var item organizationContactResponse
		var verifiedAt sql.NullTime
		if err := rows.Scan(&item.ID, &item.ChannelType, &item.ChannelValue, &item.Label, &item.IsPrimary, &item.IsVerified, &verifiedAt); err != nil {
			return nil, err
		}
		if verifiedAt.Valid {
			item.VerifiedAt = &verifiedAt.Time
		}
		contacts = append(contacts, item)
	}
	return contacts, rows.Err()
}

func recordOrganizationAudit(ctx context.Context, db organizationExecer, organizationID, actorUserID int64, actionCode, entityType, entityPublicID string, metadata map[string]any) error {
	if metadata == nil {
		metadata = map[string]any{}
	}
	metadataJSON, err := json.Marshal(metadata)
	if err != nil {
		return err
	}
	_, err = db.ExecContext(ctx, `
		INSERT INTO public.organization_audit_logs (
			organization_id, actor_user_id, action_code, entity_type, entity_public_id, metadata
		) VALUES ($1, $2, $3, NULLIF($4, ''), NULLIF($5, ''), $6::jsonb)
	`, organizationID, actorUserID, actionCode, entityType, entityPublicID, string(metadataJSON))
	return err
}

func hashOrganizationInvitationToken(token string) string {
	mac := hmac.New(sha256.New, []byte(emailVerificationSecret()))
	_, _ = mac.Write([]byte("organization-invitation:" + token))
	return base64.RawURLEncoding.EncodeToString(mac.Sum(nil))
}

func maskOrganizationInvitationEmail(value string) string {
	parts := strings.Split(strings.TrimSpace(value), "@")
	if len(parts) != 2 || len(parts[0]) < 2 {
		return "***"
	}
	return parts[0][:1] + strings.Repeat("*", len(parts[0])-1) + "@" + parts[1]
}

func sendOrganizationInvitationEmail(ctx context.Context, recipient, organizationName, roleCode, token string) error {
	invitationURL := frontendURL() + "/organization-invitations/" + url.PathEscape(token)
	escapedURL := html.EscapeString(invitationURL)
	escapedOrganization := html.EscapeString(organizationName)
	htmlBody := fmt.Sprintf(`
		<div style="margin:0;padding:32px 16px;background:#f6f8fb;font-family:Arial,sans-serif;color:#111827;">
			<div style="max-width:560px;margin:0 auto;background:#fff;border:1px solid #e5e7eb;border-radius:16px;padding:30px;">
				<h2 style="margin:0 0 12px;">คำเชิญเข้าร่วม %s</h2>
				<p style="line-height:1.7;color:#4b5563;">คุณได้รับเชิญให้เข้าร่วมองค์กรบน MapxProp ในสิทธิ์ <strong>%s</strong></p>
				<a href="%s" style="display:inline-block;margin-top:12px;background:#176b50;color:#fff;text-decoration:none;padding:13px 22px;border-radius:10px;font-weight:700;">ตอบรับคำเชิญ</a>
				<p style="margin-top:20px;font-size:14px;line-height:1.6;color:#6b7280;">ลิงก์นี้ใช้ได้ 72 ชั่วโมง และต้องเข้าสู่ระบบด้วยอีเมลที่ได้รับคำเชิญ</p>
			</div>
		</div>
	`, escapedOrganization, html.EscapeString(roleCode), escapedURL)
	textBody := fmt.Sprintf("คุณได้รับเชิญให้เข้าร่วม %s บน MapxProp ในสิทธิ์ %s\n\nเปิดลิงก์ภายใน 72 ชั่วโมง:\n%s", organizationName, roleCode, invitationURL)
	return sendResendEmail(ctx, resendEmailRequest{
		From: resendFromEmail(), To: []string{recipient},
		Subject: "คำเชิญเข้าร่วม " + organizationName + " บน MapxProp",
		HTML:    htmlBody, Text: textBody,
	})
}

func organizationDatabaseError(c *fiber.Ctx, message string, err error) error {
	fmt.Println("Organization error:", err)
	return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": message})
}
