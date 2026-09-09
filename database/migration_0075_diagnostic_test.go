package database

import (
	"os"
	"runtime"
	"strings"
	"testing"

	"github.com/joho/godotenv"
)

// Execute the pending migration against production inside a transaction that
// is always rolled back. The intentional failure prevents an API restart.
func TestProductionMigration0075Diagnostic(t *testing.T) {
	if runtime.GOOS != "linux" {
		t.Skip("production deploy diagnostic only")
	}
	if _, err := os.Stat("/root/deploy-backups"); err != nil {
		t.Skip("production deploy diagnostic only")
	}
	if err := godotenv.Load("../.env"); err != nil {
		t.Fatalf("load production database environment: %v", err)
	}

	db := ConnectDB()
	defer db.Close()
	sqlBytes, err := migrationFiles.ReadFile("migrations/0075_import_sam_nong_sai_hl0870.sql")
	if err != nil {
		t.Fatalf("read migration: %v", err)
	}
	migrationSQL := strings.TrimSpace(string(sqlBytes))
	migrationSQL = strings.TrimSpace(migrationSQL[len("BEGIN;"):])
	migrationSQL = strings.TrimSpace(migrationSQL[:len(migrationSQL)-len("COMMIT;")])

	tx, err := db.Begin()
	if err != nil {
		t.Fatalf("begin diagnostic transaction: %v", err)
	}
	defer tx.Rollback()
	if _, err := tx.Exec(migrationSQL); err != nil {
		t.Fatalf("migration 0075 production diagnostic: %v", err)
	}
	t.Fatal("migration 0075 production diagnostic succeeded; deployment aborted intentionally")
}
