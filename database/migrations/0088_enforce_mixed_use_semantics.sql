BEGIN;

-- Keep one canonical storage value even when an importer or an older client
-- sends a human-readable variant such as "mixed use" or "mix used".
UPDATE public.listings
SET usage_type = CASE
        WHEN lower(regexp_replace(trim(usage_type), '[[:space:]-]+', '_', 'g')) = 'residential'
            THEN 'residence'
        ELSE 'mixed'
    END,
    updated_at = now()
WHERE lower(regexp_replace(trim(usage_type), '[[:space:]-]+', '_', 'g')) IN (
    'residential',
    'mixed_use',
    'mixed_used',
    'mix_use',
    'mix_used'
);

-- Existing mixed-use records must carry both sides of the meaning. Preserve a
-- specific business use (retail, industrial, etc.) when one is already known;
-- office is only the neutral fallback for incomplete legacy data.
INSERT INTO public.listing_use_cases (listing_id, use_case_code)
SELECT id, 'residential'
FROM public.listings
WHERE usage_type = 'mixed'
ON CONFLICT (listing_id, use_case_code) DO NOTHING;

INSERT INTO public.listing_use_cases (listing_id, use_case_code)
SELECT l.id, 'office'
FROM public.listings l
WHERE l.usage_type = 'mixed'
  AND NOT EXISTS (
      SELECT 1
      FROM public.listing_use_cases luc
      WHERE luc.listing_id = l.id
        AND luc.use_case_code <> 'residential'
  )
ON CONFLICT (listing_id, use_case_code) DO NOTHING;

INSERT INTO public.listing_discovery_channels (listing_id, channel_code, source)
SELECT l.id, channel.channel_code, 'derived'
FROM public.listings l
CROSS JOIN (VALUES ('homes'), ('business')) AS channel(channel_code)
WHERE l.usage_type = 'mixed'
ON CONFLICT (listing_id, channel_code) DO UPDATE SET
    source = CASE
        WHEN public.listing_discovery_channels.source IN ('manual', 'editorial')
            THEN public.listing_discovery_channels.source
        ELSE 'derived'
    END,
    updated_at = now();

CREATE OR REPLACE FUNCTION public.normalize_listing_usage_type()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    normalized_usage_type text;
BEGIN
    normalized_usage_type := lower(
        regexp_replace(trim(COALESCE(NEW.usage_type, '')), '[[:space:]-]+', '_', 'g')
    );

    IF normalized_usage_type = 'residential' THEN
        NEW.usage_type := 'residence';
    ELSIF normalized_usage_type IN ('mixed_use', 'mixed_used', 'mix_use', 'mix_used') THEN
        NEW.usage_type := 'mixed';
    END IF;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS listings_normalize_usage_type ON public.listings;
CREATE TRIGGER listings_normalize_usage_type
BEFORE INSERT OR UPDATE OF usage_type ON public.listings
FOR EACH ROW
EXECUTE FUNCTION public.normalize_listing_usage_type();

-- Deferred execution lets imports and the listing editor finish replacing
-- relation rows before the invariant is checked and repaired.
CREATE OR REPLACE FUNCTION public.ensure_mixed_use_semantics()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    current_usage_type text;
BEGIN
    SELECT usage_type
    INTO current_usage_type
    FROM public.listings
    WHERE id = NEW.id;

    IF NOT FOUND OR current_usage_type <> 'mixed' THEN
        RETURN NEW;
    END IF;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (NEW.id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    IF NOT EXISTS (
        SELECT 1
        FROM public.listing_use_cases
        WHERE listing_id = NEW.id
          AND use_case_code <> 'residential'
    ) THEN
        INSERT INTO public.listing_use_cases (listing_id, use_case_code)
        VALUES (NEW.id, 'office')
        ON CONFLICT (listing_id, use_case_code) DO NOTHING;
    END IF;

    INSERT INTO public.listing_discovery_channels (listing_id, channel_code, source)
    VALUES
        (NEW.id, 'homes', 'derived'),
        (NEW.id, 'business', 'derived')
    ON CONFLICT (listing_id, channel_code) DO UPDATE SET
        source = CASE
            WHEN public.listing_discovery_channels.source IN ('manual', 'editorial')
                THEN public.listing_discovery_channels.source
            ELSE 'derived'
        END,
        updated_at = now();

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS listings_ensure_mixed_use_semantics ON public.listings;
CREATE CONSTRAINT TRIGGER listings_ensure_mixed_use_semantics
AFTER INSERT OR UPDATE OF usage_type ON public.listings
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION public.ensure_mixed_use_semantics();

COMMIT;
