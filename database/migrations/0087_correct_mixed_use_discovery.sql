BEGIN;

-- `house` is the retired pre-taxonomy code. The public UI and filters use
-- `detached_house`, so keeping active records on `house` makes their labels and
-- property-type searches inconsistent.
UPDATE public.listings
SET property_type_code = 'detached_house',
    updated_at = now()
WHERE property_type_code = 'house'
  AND deleted_at IS NULL;

UPDATE public.listing_category_details lcd
SET category_code = 'detached_house',
    updated_at = now()
FROM public.listings l
WHERE lcd.listing_id = l.id
  AND l.property_type_code = 'detached_house'
  AND lcd.category_code = 'house';

DO $$
DECLARE
    property_listing_id bigint;
BEGIN
    SELECT id INTO property_listing_id
    FROM public.listings
    WHERE public_listing_id = '3d15154f-11a8-4aed-837b-8bf86da9f282'
      AND deleted_at IS NULL;

    IF property_listing_id IS NULL THEN
        RAISE EXCEPTION 'SAM listing 8Z7018 is required for mixed-use correction';
    END IF;

    -- SAM's registered acquisition schedule includes a residence and two
    -- factory buildings. Represent that combination as mixed use while keeping
    -- the registered-versus-surveyed structure warning on the listing.
    UPDATE public.listings
    SET usage_type = 'mixed',
        updated_at = now()
    WHERE id = property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES
        (property_listing_id, 'residential'),
        (property_listing_id, 'industrial')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_discovery_channels (
        listing_id, channel_code, source, is_featured
    ) VALUES
        (property_listing_id, 'homes', 'editorial', false),
        (property_listing_id, 'business', 'editorial', false)
    ON CONFLICT (listing_id, channel_code) DO UPDATE SET
        source = EXCLUDED.source,
        is_featured = EXCLUDED.is_featured,
        updated_at = now();
END $$;

COMMIT;
