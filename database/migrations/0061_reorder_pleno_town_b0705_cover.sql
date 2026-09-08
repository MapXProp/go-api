BEGIN;

DO $$
DECLARE
    property_listing_id bigint;
BEGIN
    SELECT id INTO property_listing_id
    FROM public.listings
    WHERE slug = 'townhouse-pleno-town-pinklao-sai-5-b-0705'
      AND deleted_at IS NULL
    ORDER BY id
    LIMIT 1;

    IF property_listing_id IS NULL THEN
        RAISE EXCEPTION 'Pleno Town Pinklao-Sai 5 listing B-0705 is required before reordering its gallery';
    END IF;

    UPDATE public.listing_media
    SET is_primary = false,
        role_code = 'gallery',
        updated_at = now()
    WHERE listing_id = property_listing_id
      AND media_type = 'image'
      AND deleted_at IS NULL;

    UPDATE public.listing_media
    SET sort_order = CASE file_url
            WHEN '/listing-media/juzzmatch/b-0705/01.webp' THEN 10
            WHEN '/listing-media/juzzmatch/b-0705/00-cover.webp' THEN 20
            WHEN '/listing-media/juzzmatch/b-0705/02.webp' THEN 30
            WHEN '/listing-media/juzzmatch/b-0705/03.webp' THEN 40
            WHEN '/listing-media/juzzmatch/b-0705/04.webp' THEN 50
            WHEN '/listing-media/juzzmatch/b-0705/05.webp' THEN 60
            ELSE sort_order
        END,
        updated_at = now()
    WHERE listing_id = property_listing_id
      AND media_type = 'image'
      AND deleted_at IS NULL;

    UPDATE public.listing_media
    SET role_code = 'cover',
        is_primary = true,
        is_active = true,
        updated_at = now()
    WHERE listing_id = property_listing_id
      AND file_url = '/listing-media/juzzmatch/b-0705/01.webp'
      AND deleted_at IS NULL;

    UPDATE public.listings
    SET updated_at = now()
    WHERE id = property_listing_id;
END $$;

COMMIT;
