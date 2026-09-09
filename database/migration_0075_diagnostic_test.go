package database

import (
	"database/sql"
	"fmt"
	"os"
	"runtime"
	"strings"
	"testing"

	"github.com/joho/godotenv"
	_ "github.com/lib/pq"
)

// TestProductionMigration0075Diagnostic executes the pending migration inside
// a transaction that is always rolled back. It is intentionally limited to the
// production deploy host and intentionally fails so the deploy gate cannot
// restart the API while this one-off diagnostic is present.
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

	connStr := fmt.Sprintf(
		"host=%s port=%s user=%s password=%s dbname=%s sslmode=disable",
		os.Getenv("DB_HOST"),
		os.Getenv("DB_PORT"),
		os.Getenv("DB_USER"),
		os.Getenv("DB_PASS"),
		os.Getenv("DB_NAME"),
	)
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		t.Fatalf("open production database: %v", err)
	}
	defer db.Close()
	if err := db.Ping(); err != nil {
		t.Fatalf("ping production database: %v", err)
	}

	sqlBytes, err := migrationFiles.ReadFile("migrations/0075_import_sam_nong_sai_hl0870.sql")
	if err != nil {
		t.Fatalf("read migration: %v", err)
	}
	migrationSQL := strings.TrimSpace(string(sqlBytes))
	if strings.HasPrefix(strings.ToUpper(migrationSQL), "BEGIN;") {
		migrationSQL = strings.TrimSpace(migrationSQL[len("BEGIN;"):])
	}
	if strings.HasSuffix(strings.ToUpper(migrationSQL), "COMMIT;") {
		migrationSQL = strings.TrimSpace(migrationSQL[:len(migrationSQL)-len("COMMIT;")])
	}

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
