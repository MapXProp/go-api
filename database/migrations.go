package database

import (
	"database/sql"
	"embed"
	"fmt"
	"io/fs"
	"sort"
	"strings"
)

//go:embed migrations/*.sql
var migrationFiles embed.FS

// RunMigrations applies each SQL migration once. Migrations are embedded in the
// API binary so local and production deployments always use the same schema.
func RunMigrations(db *sql.DB) error {
	if _, err := db.Exec(`CREATE TABLE IF NOT EXISTS public.schema_migrations (
		version text PRIMARY KEY,
		applied_at timestamptz NOT NULL DEFAULT now()
	)`); err != nil {
		return fmt.Errorf("create schema_migrations: %w", err)
	}

	entries, err := fs.ReadDir(migrationFiles, "migrations")
	if err != nil {
		return fmt.Errorf("read migrations: %w", err)
	}
	sort.Slice(entries, func(i, j int) bool { return entries[i].Name() < entries[j].Name() })

	for _, entry := range entries {
		if entry.IsDir() {
			continue
		}
		var applied bool
		if err := db.QueryRow(`SELECT EXISTS (
			SELECT 1 FROM public.schema_migrations WHERE version = $1
		)`, entry.Name()).Scan(&applied); err != nil {
			return fmt.Errorf("check migration %s: %w", entry.Name(), err)
		}
		if applied {
			continue
		}

		sqlBytes, err := migrationFiles.ReadFile("migrations/" + entry.Name())
		if err != nil {
			return fmt.Errorf("read migration %s: %w", entry.Name(), err)
		}
		tx, err := db.Begin()
		if err != nil {
			return fmt.Errorf("begin migration %s: %w", entry.Name(), err)
		}
		migrationSQL := strings.TrimSpace(string(sqlBytes))
		if strings.HasPrefix(strings.ToUpper(migrationSQL), "BEGIN;") {
			migrationSQL = strings.TrimSpace(migrationSQL[len("BEGIN;"):])
		}
		if strings.HasSuffix(strings.ToUpper(migrationSQL), "COMMIT;") {
			migrationSQL = strings.TrimSpace(migrationSQL[:len(migrationSQL)-len("COMMIT;")])
		}
		if _, err := tx.Exec(migrationSQL); err != nil {
			_ = tx.Rollback()
			return fmt.Errorf("apply migration %s: %w", entry.Name(), err)
		}
		if _, err := tx.Exec(`INSERT INTO public.schema_migrations(version) VALUES ($1)`, entry.Name()); err != nil {
			_ = tx.Rollback()
			return fmt.Errorf("record migration %s: %w", entry.Name(), err)
		}
		if err := tx.Commit(); err != nil {
			return fmt.Errorf("commit migration %s: %w", entry.Name(), err)
		}
	}
	return nil
}
