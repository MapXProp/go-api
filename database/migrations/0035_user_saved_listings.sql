BEGIN;

CREATE TABLE IF NOT EXISTS public.user_saved_listings (
    user_id bigint NOT NULL REFERENCES public.auth_users(id) ON DELETE CASCADE,
    listing_id bigint NOT NULL REFERENCES public.listings(id) ON DELETE CASCADE,
    created_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, listing_id)
);

CREATE INDEX IF NOT EXISTS idx_user_saved_listings_recent
    ON public.user_saved_listings(user_id, created_at DESC, listing_id DESC);

COMMIT;
