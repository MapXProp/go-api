BEGIN;

DO $$
DECLARE
    land_listing_id bigint;
BEGIN
    SELECT id INTO land_listing_id
    FROM public.listings
    WHERE slug = 'land-for-sale-sutthisan-700-sq-wah'
    LIMIT 1;

    IF land_listing_id IS NULL THEN
        RAISE EXCEPTION 'Sutthisan land listing is required before attaching panorama media';
    END IF;

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
        land_listing_id,
        '360',
        'user_upload',
        'panorama',
        'ภาพ 360° มุมมองแปลงที่ดิน',
        'ภาพพาโนรามา 360 องศา แสดงแปลงที่ดินเปล่า 700 ตารางวาและสภาพแวดล้อมในซอยจัดสรร สุทธิสาร',
        'https://www.mapxprop.com/listing-media/mapxprop/sutthisan-700-sq-wah/360-panorama-land.webp',
        '/listing-media/mapxprop/sutthisan-700-sq-wah/360-panorama-land.webp',
        '/listing-media/mapxprop/sutthisan-700-sq-wah/360-panorama-land-thumb.webp',
        'image/webp',
        1086946,
        4096,
        2048,
        80,
        false,
        true
    WHERE NOT EXISTS (
        SELECT 1
        FROM public.listing_media
        WHERE listing_id = land_listing_id
          AND media_type = '360'
          AND file_url = '/listing-media/mapxprop/sutthisan-700-sq-wah/360-panorama-land.webp'
          AND deleted_at IS NULL
    );

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
        land_listing_id,
        '360',
        'user_upload',
        'panorama',
        'ภาพ 360° มุมมองถนนและบริเวณรอบแปลง',
        'ภาพพาโนรามา 360 องศา แสดงถนนภายในซอย บ้านพักอาศัย และบรรยากาศโดยรอบแปลงที่ดินสุทธิสาร',
        'https://www.mapxprop.com/listing-media/mapxprop/sutthisan-700-sq-wah/360-panorama-road.webp',
        '/listing-media/mapxprop/sutthisan-700-sq-wah/360-panorama-road.webp',
        '/listing-media/mapxprop/sutthisan-700-sq-wah/360-panorama-road-thumb.webp',
        'image/webp',
        964832,
        4096,
        2048,
        90,
        false,
        true
    WHERE NOT EXISTS (
        SELECT 1
        FROM public.listing_media
        WHERE listing_id = land_listing_id
          AND media_type = '360'
          AND file_url = '/listing-media/mapxprop/sutthisan-700-sq-wah/360-panorama-road.webp'
          AND deleted_at IS NULL
    );
END $$;

COMMIT;
