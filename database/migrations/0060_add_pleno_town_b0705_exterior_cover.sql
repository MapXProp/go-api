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
        RAISE EXCEPTION 'Pleno Town Pinklao-Sai 5 listing B-0705 is required before adding the exterior cover';
    END IF;

    UPDATE public.listing_media
    SET role_code = 'gallery',
        sort_order = CASE file_url
            WHEN '/listing-media/juzzmatch/b-0705/01.webp' THEN 20
            WHEN '/listing-media/juzzmatch/b-0705/02.webp' THEN 30
            WHEN '/listing-media/juzzmatch/b-0705/03.webp' THEN 40
            WHEN '/listing-media/juzzmatch/b-0705/04.webp' THEN 50
            WHEN '/listing-media/juzzmatch/b-0705/05.webp' THEN 60
            ELSE sort_order + 10
        END,
        is_primary = false,
        updated_at = now()
    WHERE listing_id = property_listing_id
      AND media_type = 'image'
      AND file_url <> '/listing-media/juzzmatch/b-0705/00-cover.webp'
      AND deleted_at IS NULL;

    INSERT INTO public.listing_media (
        listing_id,
        media_type,
        source_type,
        role_code,
        title,
        alt_text,
        original_url,
        file_url,
        thumbnail_url,
        mime_type,
        file_size_bytes,
        width,
        height,
        sort_order,
        is_primary,
        is_active
    )
    SELECT
        property_listing_id,
        'image',
        'user_upload',
        'cover',
        'ด้านหน้าทาวน์โฮม',
        'ด้านหน้าทาวน์โฮม 2 ชั้น พลีโน่ ทาวน์ ปิ่นเกล้า-สาย 5 พร้อมประตูรั้วและป้ายขาย',
        '/listing-media/juzzmatch/b-0705/00-cover.webp',
        '/listing-media/juzzmatch/b-0705/00-cover.webp',
        '/listing-media/juzzmatch/b-0705/00-cover.webp',
        'image/webp',
        37696,
        446,
        594,
        10,
        true,
        true
    WHERE NOT EXISTS (
        SELECT 1
        FROM public.listing_media
        WHERE listing_id = property_listing_id
          AND file_url = '/listing-media/juzzmatch/b-0705/00-cover.webp'
          AND deleted_at IS NULL
    );

    UPDATE public.listing_media
    SET role_code = 'cover',
        sort_order = 10,
        is_primary = true,
        is_active = true,
        deleted_at = NULL,
        updated_at = now()
    WHERE listing_id = property_listing_id
      AND file_url = '/listing-media/juzzmatch/b-0705/00-cover.webp';

    UPDATE public.listings
    SET updated_at = now()
    WHERE id = property_listing_id;
END $$;

COMMIT;
