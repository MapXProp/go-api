package handlers

import (
	"os"
	"strings"
	"testing"
)

// requireSafeIntegrationDatabase prevents a manually enabled integration test
// from writing fixtures into a remote production database. Remote integration
// databases require both an explicit opt-in and a database name containing
// "test"; local PostgreSQL remains convenient for development.
func requireSafeIntegrationDatabase(t *testing.T) {
	t.Helper()

	host := strings.ToLower(strings.TrimSpace(os.Getenv("DB_HOST")))
	databaseName := strings.ToLower(strings.TrimSpace(os.Getenv("DB_NAME")))
	if host == "" || databaseName == "" {
		t.Fatal("integration database host and name must be configured")
	}

	isLocal := host == "localhost" || host == "127.0.0.1" || host == "::1"
	if isLocal {
		return
	}

	if os.Getenv("MAPXPROP_DB_INTEGRATION_ALLOW_REMOTE") != "1" || !strings.Contains(databaseName, "test") {
		t.Fatalf("refusing to run integration fixtures against remote non-test database host=%q database=%q", host, databaseName)
	}
}
