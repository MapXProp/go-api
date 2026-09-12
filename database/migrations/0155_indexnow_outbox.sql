-- IndexNow is asynchronous: these triggers only persist public URL changes.
CREATE TABLE public.indexnow_outbox (
    path text PRIMARY KEY CHECK (left(path, 1) = '/'),
    revision bigint NOT NULL DEFAULT 1,
    delivered_revision bigint NOT NULL DEFAULT 0,
    changed_at timestamptz NOT NULL DEFAULT now(),
    next_attempt_at timestamptz NOT NULL DEFAULT now() + interval '5 minutes',
    last_attempt_at timestamptz,
    accepted_at timestamptz,
    attempts integer NOT NULL DEFAULT 0,
    last_status integer,
    last_error text
);
CREATE INDEX indexnow_outbox_pending ON public.indexnow_outbox(next_attempt_at)
    WHERE revision > delivered_revision;

-- Expiry occurs without an UPDATE, so retain its scheduled notification.
CREATE TABLE public.indexnow_expirations (
    listing_id bigint PRIMARY KEY REFERENCES public.listings(id) ON DELETE CASCADE,
    path text NOT NULL,
    expires_at timestamptz NOT NULL
);
CREATE INDEX indexnow_expirations_due ON public.indexnow_expirations(expires_at);

CREATE FUNCTION public.indexnow_enqueue(p_path text) RETURNS void LANGUAGE plpgsql AS $$
BEGIN
    IF p_path IS NULL OR p_path = '/real-estate-listings/' THEN RETURN; END IF;
    INSERT INTO public.indexnow_outbox(path) VALUES (p_path)
    ON CONFLICT(path) DO UPDATE SET
        revision = indexnow_outbox.revision + 1,
        changed_at = now(),
        -- Wait for edits to settle and the public page cache to refresh, while
        -- preserving a longer Retry-After/backoff already scheduled by delivery.
        next_attempt_at = GREATEST(indexnow_outbox.next_attempt_at, now() + interval '5 minutes');
END;
$$;

CREATE FUNCTION public.indexnow_is_public(p jsonb) RETURNS boolean LANGUAGE sql STABLE AS $$
    SELECT COALESCE(
        p->>'published_at' IS NOT NULL AND p->>'deleted_at' IS NULL
        AND (p->>'is_active')::boolean
        AND p->>'listing_status' = 'active' AND p->>'moderation_status' = 'approved'
        AND (p->>'expires_at' IS NULL OR (p->>'expires_at')::timestamptz > now()), false);
$$;

CREATE FUNCTION public.indexnow_listing_changed() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE
    previous jsonb;
    current_row jsonb;
    was_public boolean := false;
    is_public boolean := false;
    old_path text;
    new_path text;
    ignored text[] := ARRAY['updated_at','created_at','view_count','views_count',
        'favorite_count','inquiry_count','last_viewed_at','moderation_submitted_at',
        'moderated_at','moderated_by_user_id','moderation_note','submission_key'];
BEGIN
    IF TG_OP <> 'INSERT' THEN
        previous := to_jsonb(OLD);
        -- An expired published page also needs its removal signal, including a
        -- delete that happens before the expiry worker's next tick.
        was_public := public.indexnow_is_public(previous - 'expires_at');
        old_path := '/real-estate-listings/' || NULLIF(previous->>'slug', '');
    END IF;
    IF TG_OP <> 'DELETE' THEN
        current_row := to_jsonb(NEW);
        is_public := public.indexnow_is_public(current_row);
        new_path := '/real-estate-listings/' || NULLIF(current_row->>'slug', '');
    END IF;
    IF TG_OP = 'UPDATE' AND (previous - ignored) = (current_row - ignored) THEN
        RETURN NULL;
    END IF;
    -- Match the expiry worker's lock order: schedule first, then outbox.
    IF TG_OP <> 'DELETE' THEN
        DELETE FROM public.indexnow_expirations WHERE listing_id = NEW.id;
        IF is_public AND NEW.expires_at IS NOT NULL AND new_path IS NOT NULL THEN
            INSERT INTO public.indexnow_expirations(listing_id, path, expires_at)
            VALUES(NEW.id, new_path, NEW.expires_at);
        END IF;
    END IF;
    IF was_public THEN PERFORM public.indexnow_enqueue(old_path); END IF;
    IF is_public AND (NOT was_public OR new_path IS DISTINCT FROM old_path) THEN
        PERFORM public.indexnow_enqueue(new_path);
    END IF;
    RETURN NULL;
END;
$$;
CREATE TRIGGER indexnow_listing_changed AFTER INSERT OR UPDATE OR DELETE ON public.listings
    FOR EACH ROW EXECUTE FUNCTION public.indexnow_listing_changed();

-- Related public details can also be edited by imports, outside the HTTP handler.
CREATE FUNCTION public.indexnow_listing_detail_changed() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE
    parent_id bigint;
    parent_ids bigint[] := ARRAY[]::bigint[];
    listing jsonb;
BEGIN
    IF TG_OP = 'UPDATE' AND (to_jsonb(OLD) - 'updated_at') = (to_jsonb(NEW) - 'updated_at') THEN
        RETURN NULL;
    END IF;
    IF TG_OP <> 'INSERT' THEN parent_ids := array_append(parent_ids, OLD.listing_id); END IF;
    IF TG_OP <> 'DELETE' THEN parent_ids := array_append(parent_ids, NEW.listing_id); END IF;
    FOR parent_id IN SELECT DISTINCT unnest(parent_ids) LOOP
        SELECT to_jsonb(l) INTO listing FROM public.listings l WHERE l.id = parent_id;
        IF public.indexnow_is_public(listing) THEN
            PERFORM public.indexnow_enqueue('/real-estate-listings/' || NULLIF(listing->>'slug', ''));
        END IF;
    END LOOP;
    RETURN NULL;
END;
$$;
DO $$
DECLARE detail_table text;
BEGIN
    FOREACH detail_table IN ARRAY ARRAY['listing_offers','listing_media','listing_category_details',
        'listing_contact_profiles','listing_space_types','listing_amenities','listing_use_cases',
        'listing_business_details','listing_event_details','listing_event_rounds'] LOOP
        EXECUTE format('CREATE TRIGGER indexnow_public_detail_changed AFTER INSERT OR UPDATE OR DELETE ON public.%I FOR EACH ROW EXECUTE FUNCTION public.indexnow_listing_detail_changed()', detail_table);
    END LOOP;
END;
$$;

INSERT INTO public.indexnow_expirations(listing_id, path, expires_at)
SELECT id, '/real-estate-listings/' || slug, expires_at FROM public.listings l
WHERE public.indexnow_is_public(to_jsonb(l)) AND expires_at IS NOT NULL AND NULLIF(slug, '') IS NOT NULL;

-- These two pages changed in today's SEO release. Existing untouched inventory
-- is already in the sitemap; do not retrospectively resubmit its entire history.
INSERT INTO public.indexnow_outbox(path, next_attempt_at)
VALUES ('/homes', now() + interval '2 minutes'),
       ('/real-estate-categories/all', now() + interval '2 minutes');
