BEGIN;

ALTER TABLE public.listings
    ADD COLUMN IF NOT EXISTS submission_key text;

CREATE UNIQUE INDEX IF NOT EXISTS idx_listings_user_submission_key
    ON public.listings(user_id, submission_key)
    WHERE submission_key IS NOT NULL;

COMMIT;
