BEGIN;

DO $$
DECLARE
    platform_user_id bigint;
    land_listing_id bigint;
BEGIN
    SELECT id INTO platform_user_id
    FROM public.auth_users
    WHERE lower(email) = lower('mapxprop@gmail.com')
    ORDER BY id
    LIMIT 1;

    IF platform_user_id IS NULL THEN
        RAISE EXCEPTION 'MapxProp platform user is required before publishing the owner listing';
    END IF;

    SELECT id INTO land_listing_id
    FROM public.listings
    WHERE slug = 'land-for-sale-yothin-pattana-11-200-sq-wah'
    LIMIT 1;

    IF land_listing_id IS NULL THEN
        INSERT INTO public.listings (
            public_listing_id,
            user_id,
            property_type_code,
            usage_type,
            listing_type,
            title,
            description,
            sale_price,
            price_negotiable,
            land_area_sqm,
            contact_name,
            contact_phone,
            contact_phone_secondary,
            contact_email,
            show_phone,
            show_email,
            address_line1,
            address_line2,
            road,
            postal_code,
            latitude,
            longitude,
            province_name,
            district_name,
            subdistrict_name,
            listing_status,
            moderation_status,
            approved_at,
            published_at,
            moderation_submitted_at,
            moderated_at,
            is_verified,
            is_active,
            source_channel,
            price_unit,
            listing_scope,
            slug
        ) VALUES (
            '88fde0e9-3634-4223-87b4-dff46fb374d3',
            platform_user_id,
            'land',
            'mixed',
            'sale',
            'ขายด่วน ที่ดิน 200 ตร.ว. ซอยโยธินพัฒนา 11 ใกล้เลียบด่วน',
            E'ขายด่วน ที่ดิน 200 ตารางวา ในซอยโยธินพัฒนา 11 ใกล้ปากซอย เชื่อมถนนประดิษฐ์มนูธรรมและเลียบด่วนรามอินทราได้สะดวก\n\nหน้าที่ดินติดถนนกว้าง ปัจจุบันมีลานใช้งานและสิ่งปลูกสร้าง เหมาะทำธุรกิจ สำนักงาน ร้านค้า ร้านอาหาร หรือพัฒนาเป็นที่อยู่อาศัย ใกล้ Central Eastville, CDC, HomePro, Lotus และ Chic Republic\n\nราคา 50 ล้านบาท (250,000 บาท/ตร.ว.) ต่อรองได้ เจ้าของขายเอง นายหน้าได้รับค่าคอมมิชชัน 2% นัดชมและสอบถามรายละเอียดกับคุณตุ้ม\n\nผู้ซื้อควรตรวจสอบโฉนด แนวเขต สิ่งปลูกสร้าง ผังเมือง และข้อกำหนดการใช้ประโยชน์ก่อนทำสัญญา',
            50000000,
            true,
            800,
            'คุณตุ้ม',
            '0971579560',
            '0846656240',
            NULL,
            true,
            false,
            'ซอยโยธินพัฒนา 11',
            'ใกล้ปากซอยและถนนประดิษฐ์มนูธรรม เลียบด่วนรามอินทรา',
            'ซอยโยธินพัฒนา 11',
            '10240',
            13.807632880775722,
            100.61979829488973,
            'กรุงเทพมหานคร',
            'บางกะปิ',
            'คลองจั่น',
            'active',
            'approved',
            now(),
            now(),
            now(),
            now(),
            false,
            true,
            'web',
            'total',
            'land_plot',
            'land-for-sale-yothin-pattana-11-200-sq-wah'
        )
        RETURNING id INTO land_listing_id;
    END IF;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES
        (land_listing_id, 'residential'),
        (land_listing_id, 'office'),
        (land_listing_id, 'retail'),
        (land_listing_id, 'food_service')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id,
        offer_type,
        amount,
        price_unit,
        currency_code,
        is_negotiable
    ) VALUES (
        land_listing_id,
        'sale',
        50000000,
        'total',
        'THB',
        true
    )
    ON CONFLICT (listing_id, offer_type) DO UPDATE SET
        amount = EXCLUDED.amount,
        price_unit = EXCLUDED.price_unit,
        currency_code = EXCLUDED.currency_code,
        is_negotiable = EXCLUDED.is_negotiable,
        updated_at = now();

    INSERT INTO public.listing_discovery_channels (listing_id, channel_code, source, is_featured)
    VALUES
        (land_listing_id, 'homes', 'manual', false),
        (land_listing_id, 'business', 'manual', false)
    ON CONFLICT (listing_id, channel_code) DO UPDATE SET
        source = EXCLUDED.source,
        is_featured = EXCLUDED.is_featured,
        updated_at = now();

    INSERT INTO public.listing_category_details (
        listing_id,
        category_code,
        schema_version,
        details,
        is_minimum_submission
    ) VALUES (
        land_listing_id,
        'land',
        1,
        jsonb_build_object(
            'land_area_square_wah', 200,
            'price_per_square_wah', 250000,
            'vacant_land', false,
            'structures_present', true,
            'vegetation_present', true,
            'broker_commission_percent', 2,
            'road_access', 'public_road',
            'source_listing_age_at_capture', 'ประมาณ 1 เดือน'
        ),
        true
    )
    ON CONFLICT (listing_id) DO UPDATE SET
        category_code = EXCLUDED.category_code,
        schema_version = EXCLUDED.schema_version,
        details = EXCLUDED.details,
        is_minimum_submission = EXCLUDED.is_minimum_submission,
        updated_at = now();

    INSERT INTO public.listing_contact_profiles (
        listing_id,
        role_code,
        authority_source_code,
        organization_name,
        verification_status
    ) VALUES (
        land_listing_id,
        'owner',
        'self',
        NULL,
        'unverified'
    )
    ON CONFLICT (listing_id) DO UPDATE SET
        role_code = EXCLUDED.role_code,
        authority_source_code = EXCLUDED.authority_source_code,
        organization_name = EXCLUDED.organization_name,
        verification_status = EXCLUDED.verification_status,
        verification_note = NULL,
        verified_at = NULL,
        verified_by_user_id = NULL,
        updated_at = now();

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
    ) VALUES
        (land_listing_id, 'image', 'user_upload', 'cover', 'ภาพรวมที่ดินติดถนน', 'ภาพมุมสูงแสดงที่ดิน 200 ตารางวาและแนวรั้วติดซอยโยธินพัฒนา 11', 'https://www.mapxprop.com/listing-media/mapxprop/yothin-pattana-11-200-sq-wah/01-cover.webp', '/listing-media/mapxprop/yothin-pattana-11-200-sq-wah/01-cover.webp', NULL, 'image/webp', 1614902, 3840, 2160, 10, true, true),
        (land_listing_id, 'image', 'user_upload', 'gallery', 'หน้าที่ดินติดถนน', 'แนวรั้วและทางเข้าที่ดินติดถนนในซอยโยธินพัฒนา 11', 'https://www.mapxprop.com/listing-media/mapxprop/yothin-pattana-11-200-sq-wah/02-road-frontage.webp', '/listing-media/mapxprop/yothin-pattana-11-200-sq-wah/02-road-frontage.webp', NULL, 'image/webp', 1167106, 2364, 1774, 20, false, true),
        (land_listing_id, 'image', 'user_upload', 'gallery', 'ภาพมุมสูงของแปลงและถนน', 'มุมมองจากที่สูงแสดงแนวหน้าที่ดินและสภาพถนนหน้าแปลง', 'https://www.mapxprop.com/listing-media/mapxprop/yothin-pattana-11-200-sq-wah/03-elevated-overview.webp', '/listing-media/mapxprop/yothin-pattana-11-200-sq-wah/03-elevated-overview.webp', NULL, 'image/webp', 517132, 1920, 1080, 30, false, true),
        (land_listing_id, 'image', 'user_upload', 'site_plan', 'แผนที่ตำแหน่งโดยรอบ', 'ภาพถ่ายดาวเทียมแสดงตำแหน่งที่ดินใกล้ถนนประดิษฐ์มนูธรรม', 'https://www.mapxprop.com/listing-media/mapxprop/yothin-pattana-11-200-sq-wah/04-location-map.webp', '/listing-media/mapxprop/yothin-pattana-11-200-sq-wah/04-location-map.webp', NULL, 'image/webp', 350104, 1309, 884, 40, false, true),
        (land_listing_id, 'image', 'user_upload', 'site_plan', 'แนวแปลงที่ดิน', 'ภาพถ่ายดาวเทียมระบุแนวโดยประมาณของที่ดิน 200 ตารางวา', 'https://www.mapxprop.com/listing-media/mapxprop/yothin-pattana-11-200-sq-wah/05-plot-map.webp', '/listing-media/mapxprop/yothin-pattana-11-200-sq-wah/05-plot-map.webp', NULL, 'image/webp', 220768, 1268, 881, 50, false, true),
        (land_listing_id, 'image', 'user_upload', 'gallery', 'ลานและสิ่งปลูกสร้างภายใน', 'สภาพลานใช้งานและสิ่งปลูกสร้างภายในที่ดินปัจจุบัน', 'https://www.mapxprop.com/listing-media/mapxprop/yothin-pattana-11-200-sq-wah/06-yard-entry.webp', '/listing-media/mapxprop/yothin-pattana-11-200-sq-wah/06-yard-entry.webp', NULL, 'image/webp', 1145358, 2364, 1774, 60, false, true),
        (land_listing_id, 'image', 'user_upload', 'gallery', 'พื้นที่ลานมุมกว้าง', 'ภาพมุมกว้างของลานภายในและพื้นที่ใช้งานปัจจุบัน', 'https://www.mapxprop.com/listing-media/mapxprop/yothin-pattana-11-200-sq-wah/07-yard-wide.webp', '/listing-media/mapxprop/yothin-pattana-11-200-sq-wah/07-yard-wide.webp', NULL, 'image/webp', 1114800, 2364, 1774, 70, false, true),
        (land_listing_id, 'image', 'user_upload', 'gallery', 'ลานและอาคารภายใน', 'พื้นที่ลานจอดรถและอาคารภายในที่ดิน 200 ตารางวา', 'https://www.mapxprop.com/listing-media/mapxprop/yothin-pattana-11-200-sq-wah/08-yard-building.webp', '/listing-media/mapxprop/yothin-pattana-11-200-sq-wah/08-yard-building.webp', NULL, 'image/webp', 1159594, 2364, 1774, 80, false, true),
        (land_listing_id, 'image', 'user_upload', 'gallery', 'มุมมองภายในแปลง', 'มุมมองจากด้านในแสดงลานและทางเข้าที่ดิน', 'https://www.mapxprop.com/listing-media/mapxprop/yothin-pattana-11-200-sq-wah/09-yard-rear.webp', '/listing-media/mapxprop/yothin-pattana-11-200-sq-wah/09-yard-rear.webp', NULL, 'image/webp', 1126484, 2364, 1774, 90, false, true),
        (land_listing_id, 'video', 'user_upload', 'property_video', 'วิดีโอชมที่ดินและพื้นที่โดยรอบ', 'วิดีโอแสดงที่ดิน 200 ตารางวา ทางเข้า และสภาพแวดล้อมในซอยโยธินพัฒนา 11', 'https://www.mapxprop.com/listing-media/mapxprop/yothin-pattana-11-200-sq-wah/video-1.mp4', '/listing-media/mapxprop/yothin-pattana-11-200-sq-wah/video-1.mp4', '/listing-media/mapxprop/yothin-pattana-11-200-sq-wah/video-1-poster.webp', 'video/mp4', 21177795, 1920, 1080, 100, false, true),
        (land_listing_id, 'video', 'user_upload', 'property_video', 'วิดีโอมุมเพิ่มเติมของที่ดิน', 'วิดีโอมุมเพิ่มเติมแสดงพื้นที่ใช้งานและสภาพปัจจุบันของที่ดิน', 'https://www.mapxprop.com/listing-media/mapxprop/yothin-pattana-11-200-sq-wah/video-2.mp4', '/listing-media/mapxprop/yothin-pattana-11-200-sq-wah/video-2.mp4', '/listing-media/mapxprop/yothin-pattana-11-200-sq-wah/video-2-poster.webp', 'video/mp4', 1001049, 960, 540, 110, false, true)
    ON CONFLICT DO NOTHING;

    INSERT INTO public.listing_sources (
        listing_id,
        source_type,
        publisher_name,
        source_url,
        reference_code,
        captured_at,
        notes
    ) VALUES (
        land_listing_id,
        'owner',
        'คุณตุ้ม',
        NULL,
        'mapxprop-owner-yothin-pattana-11-200-square-wah',
        now(),
        'ประกาศระบุว่าเจ้าของขายเอง ข้อมูลราคา พิกัด ภาพถ่าย วิดีโอ และเบอร์ติดต่อได้รับจากผู้ใช้เมื่อ 7 กันยายน 2569 ผู้ติดต่อยังไม่ผ่านการยืนยันโดย MapxProp และผู้ซื้อควรตรวจสอบเอกสารสิทธิ์ แนวเขต สิ่งปลูกสร้าง ผังเมือง และข้อกำหนดการพัฒนาก่อนทำสัญญา'
    )
    ON CONFLICT (listing_id, source_type, reference_code) DO UPDATE SET
        publisher_name = EXCLUDED.publisher_name,
        captured_at = EXCLUDED.captured_at,
        notes = EXCLUDED.notes;
END $$;

COMMIT;
