BEGIN;

ALTER TABLE public.listings
    ADD COLUMN IF NOT EXISTS moderation_submitted_at timestamptz;

ALTER TABLE public.listings
    ADD COLUMN IF NOT EXISTS moderated_at timestamptz;

ALTER TABLE public.listings
    ADD COLUMN IF NOT EXISTS moderated_by_user_id bigint;

ALTER TABLE public.listings
    ADD COLUMN IF NOT EXISTS moderation_note text;

UPDATE public.listings
SET moderation_submitted_at = COALESCE(moderation_submitted_at, created_at)
WHERE moderation_submitted_at IS NULL;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'listings_moderated_by_user_fkey'
    ) THEN
        ALTER TABLE public.listings
            ADD CONSTRAINT listings_moderated_by_user_fkey
            FOREIGN KEY (moderated_by_user_id) REFERENCES public.auth_users(id) ON DELETE SET NULL;
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_listings_moderation_queue
    ON public.listings(moderation_status, moderation_submitted_at DESC, id DESC)
    WHERE deleted_at IS NULL;

CREATE TABLE IF NOT EXISTS public.listing_moderation_audit (
    id bigserial PRIMARY KEY,
    listing_id bigint NOT NULL REFERENCES public.listings(id) ON DELETE CASCADE,
    previous_status text NOT NULL,
    new_status text NOT NULL,
    action text NOT NULL,
    note text,
    moderated_by_user_id bigint REFERENCES public.auth_users(id) ON DELETE SET NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    CHECK (action IN ('approved', 'changes_requested')),
    CHECK (new_status IN ('approved', 'rejected'))
);

CREATE INDEX IF NOT EXISTS idx_listing_moderation_audit_listing
    ON public.listing_moderation_audit(listing_id, created_at DESC, id DESC);

CREATE TABLE IF NOT EXISTS public.user_notifications (
    id bigserial PRIMARY KEY,
    user_id bigint NOT NULL REFERENCES public.auth_users(id) ON DELETE CASCADE,
    notification_type text NOT NULL,
    title_th text NOT NULL,
    title_en text NOT NULL,
    body_th text NOT NULL,
    body_en text NOT NULL,
    action_url text,
    listing_id bigint REFERENCES public.listings(id) ON DELETE SET NULL,
    read_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    CHECK (notification_type IN ('listing_published', 'listing_changes_requested', 'system'))
);

CREATE INDEX IF NOT EXISTS idx_user_notifications_recent
    ON public.user_notifications(user_id, created_at DESC, id DESC);

CREATE INDEX IF NOT EXISTS idx_user_notifications_unread
    ON public.user_notifications(user_id, created_at DESC, id DESC)
    WHERE read_at IS NULL;

COMMIT;
