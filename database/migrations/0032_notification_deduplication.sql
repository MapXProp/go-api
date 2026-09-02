BEGIN;

ALTER TABLE public.user_notifications
    ADD COLUMN IF NOT EXISTS dedupe_key text;

CREATE UNIQUE INDEX IF NOT EXISTS idx_user_notifications_dedupe_key
    ON public.user_notifications(user_id, dedupe_key)
    WHERE dedupe_key IS NOT NULL;

COMMIT;
