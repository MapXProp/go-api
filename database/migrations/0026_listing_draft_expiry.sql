BEGIN;

ALTER TABLE public.listing_drafts
    ADD COLUMN IF NOT EXISTS expires_at timestamptz;

UPDATE public.listing_drafts
SET expires_at = updated_at + interval '48 hours'
WHERE expires_at IS NULL;

ALTER TABLE public.listing_drafts
    ALTER COLUMN expires_at SET DEFAULT (now() + interval '48 hours'),
    ALTER COLUMN expires_at SET NOT NULL;

CREATE INDEX IF NOT EXISTS idx_listing_drafts_expires_at
    ON public.listing_drafts(expires_at);

COMMIT;
