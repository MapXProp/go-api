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
        RAISE EXCEPTION 'Sutthisan land listing is required before attaching video media';
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
        'video',
        'user_upload',
        'property_video',
        'วิดีโอชมแปลงที่ดิน 700 ตร.ว. สุทธิสาร',
        'วิดีโอแสดงสภาพแปลงที่ดินเปล่า 2 แปลงติดกัน รวม 700 ตารางวา และบรรยากาศโดยรอบในซอยจัดสรร สุทธิสาร',
        'https://www.mapxprop.com/listing-media/mapxprop/sutthisan-700-sq-wah/land-overview-video.mp4',
        '/listing-media/mapxprop/sutthisan-700-sq-wah/land-overview-video.mp4',
        '/listing-media/mapxprop/sutthisan-700-sq-wah/land-overview-video-poster.webp',
        'video/mp4',
        12635620,
        1280,
        720,
        70,
        false,
        true
    WHERE NOT EXISTS (
        SELECT 1
        FROM public.listing_media
        WHERE listing_id = land_listing_id
          AND media_type = 'video'
          AND file_url = '/listing-media/mapxprop/sutthisan-700-sq-wah/land-overview-video.mp4'
          AND deleted_at IS NULL
    );
END $$;

COMMIT;
