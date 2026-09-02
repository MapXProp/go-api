package handlers

import (
	"bytes"
	"database/sql"
	"encoding/json"
	"estate-map-api/database"
	"fmt"
	"net/http/httptest"
	"os"
	"testing"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
	"github.com/joho/godotenv"
)

func TestPlatformRoleAuthorizationAndAudit(t *testing.T) {
	if os.Getenv("MAPXPROP_DB_INTEGRATION") != "1" {
		t.Skip("set MAPXPROP_DB_INTEGRATION=1 to run the database integration test")
	}
	if err := godotenv.Load("../.env"); err != nil {
		t.Fatal("load integration database environment:", err)
	}

	db := database.ConnectDB()
	defer db.Close()
	if err := database.RunMigrations(db); err != nil {
		t.Fatal("run platform role migrations:", err)
	}

	var adminID int64
	var adminPublicUserID, adminEmail, adminRole string
	if err := db.QueryRow(`
		SELECT id, public_user_id::text, lower(email), role_code
		FROM public.auth_users
		WHERE lower(email) = $1 AND deleted_at IS NULL
	`, primarySuperAdminEmail).Scan(&adminID, &adminPublicUserID, &adminEmail, &adminRole); err == sql.ErrNoRows {
		t.Fatalf("primary super admin account %s does not exist", primarySuperAdminEmail)
	} else if err != nil {
		t.Fatal("load primary super admin:", err)
	}
	if adminRole != platformRoleSuperAdmin {
		t.Fatalf("primary admin role mismatch: got=%q want=%q", adminRole, platformRoleSuperAdmin)
	}

	testPublicUserID := uuid.NewString()
	testEmail := fmt.Sprintf("codex-role-test-%s@example.invalid", uuid.NewString())
	var testUserID int64
	if err := db.QueryRow(`
		INSERT INTO public.auth_users (
			public_user_id, email, password_hash, provider, is_active, is_verified,
			password_changed_at, last_login_at, updated_at
		) VALUES ($1, $2, 'integration-test-only', 'email', true, true, now(), now(), now())
		RETURNING id
	`, testPublicUserID, testEmail).Scan(&testUserID); err != nil {
		t.Fatal("create role test user:", err)
	}

	adminTokenID := uuid.NewString()
	testTokenID := uuid.NewString()
	expiresAt := time.Now().UTC().Add(10 * time.Minute)
	if _, err := db.Exec(`
		INSERT INTO public.auth_sessions (user_id, token_id, expires_at)
		VALUES ($1, $2, $3), ($4, $5, $3)
	`, adminID, adminTokenID, expiresAt, testUserID, testTokenID); err != nil {
		t.Fatal("create role test sessions:", err)
	}
	defer func() {
		if _, err := db.Exec(`DELETE FROM public.auth_sessions WHERE token_id = $1`, adminTokenID); err != nil {
			t.Errorf("delete primary admin test session: %v", err)
		}
		if _, err := db.Exec(`DELETE FROM public.auth_users WHERE id = $1 AND email = $2`, testUserID, testEmail); err != nil {
			t.Errorf("delete role test user: %v", err)
		}
	}()

	adminToken, err := createAccessToken(adminID, adminPublicUserID, adminEmail, adminTokenID, expiresAt)
	if err != nil {
		t.Fatal(err)
	}
	testToken, err := createAccessToken(testUserID, testPublicUserID, testEmail, testTokenID, expiresAt)
	if err != nil {
		t.Fatal(err)
	}

	app := fiber.New()
	app.Get("/me", GetMe(db))
	app.Get("/admin/roles", GetPlatformRoles(db))
	app.Get("/admin/users", GetAdminUsers(db))
	app.Patch("/admin/users/:publicUserID/role", UpdateAdminUserRole(db))

	assertRoleRequestStatus(t, app, "GET", "/admin/roles", "", nil, fiber.StatusUnauthorized)
	assertRoleRequestStatus(t, app, "GET", "/admin/roles", testToken, nil, fiber.StatusForbidden)

	rolesResponse := roleIntegrationRequest(t, app, "GET", "/admin/roles", adminToken, nil, fiber.StatusOK)
	var rolesBody struct {
		Roles []platformRoleResponse `json:"roles"`
	}
	if err := json.Unmarshal(rolesResponse, &rolesBody); err != nil {
		t.Fatal(err)
	}
	if len(rolesBody.Roles) != 5 || rolesBody.Roles[0].Code != platformRoleSuperAdmin || rolesBody.Roles[0].PermissionLevel != 100 || rolesBody.Roles[0].IsAssignable {
		t.Fatalf("platform role definitions mismatch: %#v", rolesBody.Roles)
	}

	usersResponse := roleIntegrationRequest(
		t,
		app,
		"GET",
		"/admin/users?q="+testEmail,
		adminToken,
		nil,
		fiber.StatusOK,
	)
	var usersBody struct {
		Users []adminUserResponse `json:"users"`
		Total int                 `json:"total"`
	}
	if err := json.Unmarshal(usersResponse, &usersBody); err != nil {
		t.Fatal(err)
	}
	if usersBody.Total != 1 || len(usersBody.Users) != 1 || usersBody.Users[0].RoleCode != platformRoleMember {
		t.Fatalf("admin user list mismatch: %#v", usersBody)
	}

	rolePayload, _ := json.Marshal(updateAdminUserRoleRequest{RoleCode: platformRoleModerator})
	roleIntegrationRequest(
		t,
		app,
		"PATCH",
		"/admin/users/"+testPublicUserID+"/role",
		adminToken,
		rolePayload,
		fiber.StatusOK,
	)

	var storedRole string
	var auditRows int
	if err := db.QueryRow(`SELECT role_code FROM public.auth_users WHERE id = $1`, testUserID).Scan(&storedRole); err != nil {
		t.Fatal(err)
	}
	if err := db.QueryRow(`
		SELECT count(*) FROM public.auth_user_role_audit
		WHERE user_id = $1
		  AND previous_role_code = 'member'
		  AND new_role_code = 'moderator'
		  AND changed_by_user_id = $2
	`, testUserID, adminID).Scan(&auditRows); err != nil {
		t.Fatal(err)
	}
	if storedRole != platformRoleModerator || auditRows != 1 {
		t.Fatalf("role update/audit mismatch: role=%q auditRows=%d", storedRole, auditRows)
	}

	// The token is unchanged, proving privileged checks use the current database
	// role instead of a stale role claim from the session token.
	assertRoleRequestStatus(t, app, "GET", "/admin/users", testToken, nil, fiber.StatusForbidden)

	primaryChange, _ := json.Marshal(updateAdminUserRoleRequest{RoleCode: platformRoleAdmin})
	assertRoleRequestStatus(
		t,
		app,
		"PATCH",
		"/admin/users/"+adminPublicUserID+"/role",
		adminToken,
		primaryChange,
		fiber.StatusConflict,
	)
	assignSuperAdmin, _ := json.Marshal(updateAdminUserRoleRequest{RoleCode: platformRoleSuperAdmin})
	assertRoleRequestStatus(
		t,
		app,
		"PATCH",
		"/admin/users/"+testPublicUserID+"/role",
		adminToken,
		assignSuperAdmin,
		fiber.StatusBadRequest,
	)

	meResponse := roleIntegrationRequest(t, app, "GET", "/me", adminToken, nil, fiber.StatusOK)
	var meBody struct {
		User struct {
			RoleCode string `json:"role_code"`
		} `json:"user"`
	}
	if err := json.Unmarshal(meResponse, &meBody); err != nil {
		t.Fatal(err)
	}
	if meBody.User.RoleCode != platformRoleSuperAdmin {
		t.Fatalf("current user response omitted super admin role: %#v", meBody)
	}
}

func assertRoleRequestStatus(
	t *testing.T,
	app *fiber.App,
	method string,
	path string,
	token string,
	body []byte,
	expectedStatus int,
) {
	t.Helper()
	roleIntegrationRequest(t, app, method, path, token, body, expectedStatus)
}

func roleIntegrationRequest(
	t *testing.T,
	app *fiber.App,
	method string,
	path string,
	token string,
	body []byte,
	expectedStatus int,
) []byte {
	t.Helper()
	request := httptest.NewRequest(method, path, bytes.NewReader(body))
	if len(body) > 0 {
		request.Header.Set("Content-Type", "application/json")
	}
	if token != "" {
		request.Header.Set("Authorization", "Bearer "+token)
	}
	response, err := app.Test(request, -1)
	if err != nil {
		t.Fatal(err)
	}
	defer response.Body.Close()
	var responseBody bytes.Buffer
	if _, err := responseBody.ReadFrom(response.Body); err != nil {
		t.Fatal(err)
	}
	if response.StatusCode != expectedStatus {
		t.Fatalf("%s %s status=%d want=%d body=%s", method, path, response.StatusCode, expectedStatus, responseBody.String())
	}
	return responseBody.Bytes()
}
