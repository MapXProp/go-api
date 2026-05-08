package database

import (
	"database/sql"
	"log"
)

func EnsureAuthSchema(db *sql.DB) {
	statements := []string{
		`CREATE TABLE IF NOT EXISTS public.auth_sessions (
			id bigserial PRIMARY KEY,
			user_id bigint NOT NULL REFERENCES public.auth_users(id) ON DELETE CASCADE,
			token_id uuid NOT NULL UNIQUE,
			user_agent text,
			ip_address text,
			expires_at timestamp with time zone NOT NULL,
			revoked_at timestamp with time zone,
			created_at timestamp with time zone NOT NULL DEFAULT now(),
			updated_at timestamp with time zone NOT NULL DEFAULT now()
		)`,
		`CREATE INDEX IF NOT EXISTS idx_auth_sessions_user_id
			ON public.auth_sessions(user_id)`,
		`CREATE INDEX IF NOT EXISTS idx_auth_sessions_active_token
			ON public.auth_sessions(token_id, user_id, expires_at)
			WHERE revoked_at IS NULL`,
		`ALTER TABLE public.auth_sessions
			ADD COLUMN IF NOT EXISTS refresh_token_hash text`,
		`ALTER TABLE public.auth_sessions
			ADD COLUMN IF NOT EXISTS refresh_expires_at timestamp with time zone`,
		`ALTER TABLE public.auth_sessions
			ADD COLUMN IF NOT EXISTS last_seen_at timestamp with time zone`,
		`CREATE INDEX IF NOT EXISTS idx_auth_sessions_refresh_token_hash
			ON public.auth_sessions(refresh_token_hash)
			WHERE revoked_at IS NULL`,
	}

	for _, statement := range statements {
		if _, err := db.Exec(statement); err != nil {
			log.Fatal("Error: cannot ensure auth schema:", err)
		}
	}
}
