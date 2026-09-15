-- Counts begin at zero and are increased only by a recorded public opening.
-- The original production schema already has an integer counter. Preserve it.
ALTER TABLE public.listings ADD COLUMN IF NOT EXISTS view_count bigint NOT NULL DEFAULT 0 CHECK (view_count >= 0);

CREATE TABLE public.listing_view_events (
    listing_id bigint NOT NULL REFERENCES public.listings(id) ON DELETE CASCADE,
    event_id uuid NOT NULL,
    viewed_at timestamptz NOT NULL DEFAULT now(),
    source text NOT NULL CHECK (source IN ('listing_page', 'map_preview', 'map_modal')),
    PRIMARY KEY (listing_id, event_id)
);

CREATE FUNCTION public.record_listing_view(
    requested_listing uuid, opening_event uuid, view_source text
) RETURNS TABLE(view_count bigint, counted boolean)
LANGUAGE plpgsql AS $$
DECLARE
    listing_key bigint;
    total bigint;
    accepted integer;
BEGIN
    IF opening_event IS NULL OR opening_event = '00000000-0000-0000-0000-000000000000'::uuid
        OR view_source IS NULL OR view_source NOT IN ('listing_page', 'map_preview', 'map_modal') THEN
        RAISE EXCEPTION 'invalid listing view';
    END IF;

    SELECT l.id, l.view_count INTO listing_key, total
    FROM public.listings l
    WHERE l.public_listing_id = requested_listing
      AND l.published_at IS NOT NULL AND l.is_active = true
      AND l.deleted_at IS NULL AND l.listing_status = 'active'
      AND l.moderation_status = 'approved'
      AND (l.expires_at IS NULL OR l.expires_at > now())
    FOR UPDATE;
    IF NOT FOUND THEN RETURN; END IF;

    -- Each actual opening/refresh has a new event ID. Only transport retries
    -- of that same event are deduplicated, with no visitor or time window.
    INSERT INTO public.listing_view_events (listing_id, event_id, source)
    VALUES (listing_key, opening_event, view_source)
    ON CONFLICT (listing_id, event_id) DO NOTHING;
    GET DIAGNOSTICS accepted = ROW_COUNT;

    IF accepted = 1 THEN
        UPDATE public.listings l SET view_count = l.view_count + 1
        WHERE l.id = listing_key RETURNING l.view_count INTO total;
    END IF;
    RETURN QUERY SELECT total, accepted = 1;
END;
$$;
