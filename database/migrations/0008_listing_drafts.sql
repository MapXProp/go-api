BEGIN;

CREATE TABLE IF NOT EXISTS public.listing_drafts (
    id bigserial PRIMARY KEY,
    user_id bigint NOT NULL REFERENCES public.auth_users(id) ON DELETE CASCADE,
    data jsonb NOT NULL DEFAULT '{}'::jsonb,
    current_step smallint NOT NULL DEFAULT 1 CHECK (current_step BETWEEN 1 AND 4),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (user_id)
);

CREATE INDEX IF NOT EXISTS idx_listing_drafts_updated_at
    ON public.listing_drafts(updated_at DESC);

COMMIT;
