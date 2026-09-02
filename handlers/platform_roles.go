package handlers

import (
	"context"
	"database/sql"
	"fmt"
	"strings"
	"time"

	"github.com/gofiber/fiber/v2"
)

const (
	primarySuperAdminEmail = "mapxprop@gmail.com"

	platformRoleSuperAdmin = "super_admin"
	platformRoleAdmin      = "admin"
	platformRoleModerator  = "moderator"
	platformRoleSupport    = "support"
	platformRoleMember     = "member"
)

type platformRoleResponse struct {
	Code            string `json:"code"`
	NameTH          string `json:"name_th"`
	NameEN          string `json:"name_en"`
	DescriptionTH   string `json:"description_th"`
	DescriptionEN   string `json:"description_en"`
	PermissionLevel int    `json:"permission_level"`
	IsAssignable    bool   `json:"is_assignable"`
}

type adminUserResponse struct {
	PublicUserID        string     `json:"public_user_id"`
	Name                string     `json:"name"`
	Surname             string     `json:"surname"`
	Email               string     `json:"email"`
	RoleCode            string     `json:"role_code"`
	RoleNameTH          string     `json:"role_name_th"`
	RoleNameEN          string     `json:"role_name_en"`
	IsActive            bool       `json:"is_active"`
	IsVerified          bool       `json:"is_verified"`
	IsPrimarySuperAdmin bool       `json:"is_primary_super_admin"`
	ListingCount        int        `json:"listing_count"`
	CreatedAt           time.Time  `json:"created_at"`
	RoleUpdatedAt       *time.Time `json:"role_updated_at,omitempty"`
}

type updateAdminUserRoleRequest struct {
	RoleCode string `json:"role_code"`
}

func requireSuperAdmin(
	c *fiber.Ctx,
	db *sql.DB,
) (*accessTokenClaims, context.Context, context.CancelFunc, int, error) {
	claims, ctx, cancel, err := authenticatedAccountRequest(c, db)
	if err != nil {
		return nil, nil, nil, fiber.StatusUnauthorized, err
	}

	var email, roleCode string
	err = db.QueryRowContext(ctx, `
		SELECT lower(email), role_code
		FROM public.auth_users
		WHERE id = $1
		  AND public_user_id::text = $2
		  AND is_active = true
		  AND deleted_at IS NULL
		LIMIT 1
	`, claims.UID, claims.Sub).Scan(&email, &roleCode)
	if err == sql.ErrNoRows {
		cancel()
		return nil, nil, nil, fiber.StatusUnauthorized, fmt.Errorf("user not found")
	}
	if err != nil {
		cancel()
		return nil, nil, nil, fiber.StatusInternalServerError, err
	}
	if roleCode != platformRoleSuperAdmin || email != primarySuperAdminEmail {
		cancel()
		return nil, nil, nil, fiber.StatusForbidden, fmt.Errorf("super admin permission required")
	}

	return claims, ctx, cancel, 0, nil
}

func platformRoleAuthError(c *fiber.Ctx, status int, err error) error {
	if status == fiber.StatusInternalServerError {
		fmt.Println("Platform role authorization error:", err)
		return c.Status(status).JSON(fiber.Map{"error": "cannot verify platform permission"})
	}
	return c.Status(status).JSON(fiber.Map{"error": err.Error()})
}

func GetPlatformRoles(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		_, ctx, cancel, status, err := requireSuperAdmin(c, db)
		if err != nil {
			return platformRoleAuthError(c, status, err)
		}
		defer cancel()

		rows, err := db.QueryContext(ctx, `
			SELECT code, name_th, name_en, description_th, description_en,
			       permission_level, is_assignable
			FROM public.platform_roles
			ORDER BY permission_level DESC
		`)
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot load platform roles"})
		}
		defer rows.Close()

		roles := make([]platformRoleResponse, 0, 5)
		for rows.Next() {
			var role platformRoleResponse
			if err := rows.Scan(
				&role.Code,
				&role.NameTH,
				&role.NameEN,
				&role.DescriptionTH,
				&role.DescriptionEN,
				&role.PermissionLevel,
				&role.IsAssignable,
			); err != nil {
				return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read platform roles"})
			}
			roles = append(roles, role)
		}
		if err := rows.Err(); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read platform roles"})
		}

		return c.JSON(fiber.Map{"roles": roles})
	}
}

func GetAdminUsers(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		_, ctx, cancel, status, err := requireSuperAdmin(c, db)
		if err != nil {
			return platformRoleAuthError(c, status, err)
		}
		defer cancel()

		query := strings.TrimSpace(c.Query("q"))
		if len([]rune(query)) > 120 {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "search query is too long"})
		}
		limit := c.QueryInt("limit", 50)
		if limit < 1 || limit > 100 {
			limit = 50
		}
		offset := c.QueryInt("offset", 0)
		if offset < 0 {
			offset = 0
		}

		rows, err := db.QueryContext(ctx, `
			SELECT
				u.public_user_id::text,
				COALESCE(u.name, ''),
				COALESCE(u.surname, ''),
				u.email,
				u.role_code,
				r.name_th,
				r.name_en,
				COALESCE(u.is_active, true),
				COALESCE(u.is_verified, false),
				lower(u.email) = $1,
				(SELECT count(*) FROM public.listings l WHERE l.user_id = u.id AND l.deleted_at IS NULL),
				u.created_at,
				u.role_updated_at,
				count(*) OVER()
			FROM public.auth_users u
			JOIN public.platform_roles r ON r.code = u.role_code
			WHERE u.deleted_at IS NULL
			  AND (
				$2 = ''
				OR u.email ILIKE '%' || $2 || '%'
				OR COALESCE(u.name, '') ILIKE '%' || $2 || '%'
				OR COALESCE(u.surname, '') ILIKE '%' || $2 || '%'
			  )
			ORDER BY
				CASE WHEN lower(u.email) = $1 THEN 0 ELSE 1 END,
				r.permission_level DESC,
				u.created_at DESC,
				u.id DESC
			LIMIT $3 OFFSET $4
		`, primarySuperAdminEmail, query, limit, offset)
		if err != nil {
			fmt.Println("Read admin users error:", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot load users"})
		}
		defer rows.Close()

		users := make([]adminUserResponse, 0, limit)
		total := 0
		for rows.Next() {
			var user adminUserResponse
			var roleUpdatedAt sql.NullTime
			if err := rows.Scan(
				&user.PublicUserID,
				&user.Name,
				&user.Surname,
				&user.Email,
				&user.RoleCode,
				&user.RoleNameTH,
				&user.RoleNameEN,
				&user.IsActive,
				&user.IsVerified,
				&user.IsPrimarySuperAdmin,
				&user.ListingCount,
				&user.CreatedAt,
				&roleUpdatedAt,
				&total,
			); err != nil {
				return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read users"})
			}
			if roleUpdatedAt.Valid {
				user.RoleUpdatedAt = &roleUpdatedAt.Time
			}
			users = append(users, user)
		}
		if err := rows.Err(); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot read users"})
		}

		return c.JSON(fiber.Map{
			"users":  users,
			"total":  total,
			"limit":  limit,
			"offset": offset,
		})
	}
}

func UpdateAdminUserRole(db *sql.DB) fiber.Handler {
	return func(c *fiber.Ctx) error {
		claims, ctx, cancel, status, err := requireSuperAdmin(c, db)
		if err != nil {
			return platformRoleAuthError(c, status, err)
		}
		defer cancel()

		publicUserID := strings.TrimSpace(c.Params("publicUserID"))
		if publicUserID == "" || len(publicUserID) > 128 {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid user ID"})
		}

		var req updateAdminUserRoleRequest
		if err := c.BodyParser(&req); err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid role payload"})
		}
		req.RoleCode = strings.TrimSpace(strings.ToLower(req.RoleCode))
		if req.RoleCode == platformRoleSuperAdmin {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "the primary super admin role cannot be assigned"})
		}

		var roleAssignable bool
		err = db.QueryRowContext(ctx, `
			SELECT is_assignable FROM public.platform_roles WHERE code = $1
		`, req.RoleCode).Scan(&roleAssignable)
		if err == sql.ErrNoRows || !roleAssignable {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid assignable role"})
		}
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot validate role"})
		}

		tx, err := db.BeginTx(ctx, nil)
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot update user role"})
		}
		defer tx.Rollback()

		var targetUserID int64
		var targetEmail, previousRoleCode string
		err = tx.QueryRowContext(ctx, `
			SELECT id, lower(email), role_code
			FROM public.auth_users
			WHERE public_user_id::text = $1
			  AND deleted_at IS NULL
			FOR UPDATE
		`, publicUserID).Scan(&targetUserID, &targetEmail, &previousRoleCode)
		if err == sql.ErrNoRows {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{"error": "user not found"})
		}
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot load user role"})
		}
		if targetEmail == primarySuperAdminEmail || previousRoleCode == platformRoleSuperAdmin {
			return c.Status(fiber.StatusConflict).JSON(fiber.Map{"error": "the primary super admin role is protected"})
		}

		if previousRoleCode != req.RoleCode {
			if _, err := tx.ExecContext(ctx, `
				UPDATE public.auth_users
				SET role_code = $1,
				    role_updated_at = now(),
				    role_updated_by_user_id = $2,
				    updated_at = now()
				WHERE id = $3
			`, req.RoleCode, claims.UID, targetUserID); err != nil {
				return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot update user role"})
			}
			if _, err := tx.ExecContext(ctx, `
				INSERT INTO public.auth_user_role_audit (
					user_id, previous_role_code, new_role_code, changed_by_user_id
				) VALUES ($1, $2, $3, $4)
			`, targetUserID, previousRoleCode, req.RoleCode, claims.UID); err != nil {
				return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot record user role update"})
			}
		}

		if err := tx.Commit(); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "cannot update user role"})
		}

		return c.JSON(fiber.Map{
			"success":            true,
			"public_user_id":     publicUserID,
			"previous_role_code": previousRoleCode,
			"role_code":          req.RoleCode,
			"unchanged":          previousRoleCode == req.RoleCode,
		})
	}
}
