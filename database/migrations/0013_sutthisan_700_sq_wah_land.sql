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
    WHERE slug = 'land-for-sale-sutthisan-700-sq-wah'
    LIMIT 1;

    IF land_listing_id IS NULL THEN
        INSERT INTO public.listings (
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
            contact_email,
            show_phone,
            show_email,
            address_line1,
            address_line2,
            road,
            latitude,
            longitude,
            province_name,
            district_name,
            subdistrict_name,
            listing_status,
            moderation_status,
            approved_at,
            published_at,
            is_verified,
            is_active,
            source_channel,
            price_unit,
            listing_scope,
            slug
        ) VALUES (
            platform_user_id,
            'land',
            'mixed',
            'sale',
            'ขายที่ดิน 700 ตร.ว. สุทธิสาร 2 แปลงติดกัน หน้ากว้าง 87 ม.',
            E'ขายที่ดินเปล่า 2 แปลงติดกัน รวมเนื้อที่ 700 ตารางวา ภายในซอยจัดสรร แยกจากถนนสุทธิสารวินิจฉัย ขายรวมทั้งสองแปลง\n\nแต่ละแปลงมีเนื้อที่ประมาณ 350 ตารางวา แปลงแรกมีแนวหน้าติดถนนประมาณ 45 เมตร และแปลงที่สองประมาณ 42 เมตร รวมแนวหน้าติดถนนประมาณ 87 เมตร ปัจจุบันไม่มีสิ่งปลูกสร้างและมีต้นไม้ขึ้นบางส่วนตามสภาพจริง\n\nซอยเงียบสงบ รายล้อมด้วยบ้านพักอาศัยและบ้านขนาดใหญ่ เหมาะสำหรับผู้ที่มองหาที่ดินแปลงใหญ่ใจกลางกรุงเทพฯ เพื่อพิจารณาสร้างบ้านพักอาศัย Private Residence หรือ Family Compound โดยผู้ซื้อควรตรวจสอบข้อกำหนดผังเมือง แนวเขต และการใช้ประโยชน์ที่ดินกับหน่วยงานที่เกี่ยวข้องก่อนตัดสินใจ\n\nเดินทางเชื่อมต่อสุทธิสาร รัชดาภิเษก ลาดพร้าว และพระราม 9 ได้สะดวก เหมาะกับผู้ใช้รถยนต์ ใกล้ MRT สุทธิสาร สถานเอกอัครราชทูตตุรกี ศูนย์วัฒนธรรมแห่งประเทศไทย และ Central Rama 9',
            294000000,
            false,
            2800,
            'คุณคูณ',
            '0949496662',
            'mapxprop@gmail.com',
            true,
            true,
            'ซอยจัดสรร',
            'ถนนสุทธิสารวินิจฉัย กรุงเทพมหานคร',
            'ถนนสุทธิสารวินิจฉัย',
            13.787660402989946,
            100.58811388023786,
            'กรุงเทพมหานคร',
            '',
            '',
            'active',
            'approved',
            now(),
            now(),
            false,
            true,
            'web',
            'total',
            'land_plot',
            'land-for-sale-sutthisan-700-sq-wah'
        )
        RETURNING id INTO land_listing_id;
    END IF;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (land_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (listing_id, offer_type, amount, price_unit, is_negotiable)
    VALUES (land_listing_id, 'sale', 294000000, 'total', false)
    ON CONFLICT (listing_id, offer_type) DO UPDATE SET
        amount = EXCLUDED.amount,
        price_unit = EXCLUDED.price_unit,
        is_negotiable = EXCLUDED.is_negotiable,
        updated_at = now();

    INSERT INTO public.listing_discovery_channels (listing_id, channel_code, source, is_featured)
    VALUES
        (land_listing_id, 'homes', 'manual', true),
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
            'land_area_square_wah', 700,
            'plot_count', 2,
            'plot_areas_square_wah', jsonb_build_array(350, 350),
            'road_frontage_meters', 87,
            'plot_frontages_meters', jsonb_build_array(45, 42),
            'price_per_square_wah', 420000,
            'sale_together_only', true,
            'vacant_land', true,
            'structures_present', false,
            'vegetation_present', true,
            'transfer_fee_split', 'buyer_seller_equal',
            'other_transfer_expenses_paid_by', 'buyer',
            'broker_commission_percent', 2,
            'road_access', 'internal_road'
        ),
        true
    )
    ON CONFLICT (listing_id) DO UPDATE SET
        category_code = EXCLUDED.category_code,
        schema_version = EXCLUDED.schema_version,
        details = EXCLUDED.details,
        is_minimum_submission = EXCLUDED.is_minimum_submission,
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
        mime_type,
        width,
        height,
        sort_order,
        is_primary,
        is_active
    ) VALUES
        (land_listing_id, 'image', 'user_upload', 'cover', 'ภาพรวมที่ดินและแนวถนน', 'ที่ดินเปล่า 700 ตารางวาในซอยจัดสรร สุทธิสาร มองเห็นพื้นที่และแนวถนน', 'https://www.mapxprop.com/listing-media/mapxprop/sutthisan-700-sq-wah/01-cover.webp', '/listing-media/mapxprop/sutthisan-700-sq-wah/01-cover.webp', 'image/webp', 1920, 1080, 10, true, true),
        (land_listing_id, 'image', 'user_upload', 'site_plan', 'ภาพแนวแปลงที่ดิน', 'ภาพถ่ายดาวเทียมประกอบแนวที่ดิน 2 แปลง แปลงละประมาณ 350 ตารางวา', 'https://www.mapxprop.com/listing-media/mapxprop/sutthisan-700-sq-wah/02-plot-map.webp', '/listing-media/mapxprop/sutthisan-700-sq-wah/02-plot-map.webp', 'image/webp', 1282, 887, 20, false, true),
        (land_listing_id, 'image', 'user_upload', 'gallery', 'สภาพที่ดินปัจจุบัน', 'สภาพที่ดินเปล่าและบริเวณโดยรอบในซอยจัดสรร สุทธิสาร', 'https://www.mapxprop.com/listing-media/mapxprop/sutthisan-700-sq-wah/03-land-view.webp', '/listing-media/mapxprop/sutthisan-700-sq-wah/03-land-view.webp', 'image/webp', 1920, 1080, 30, false, true),
        (land_listing_id, 'image', 'user_upload', 'gallery', 'มุมมองที่ดินด้านหน้า', 'มุมมองพื้นที่ดินเปล่าและแนวรั้วติดถนนภายในซอย', 'https://www.mapxprop.com/listing-media/mapxprop/sutthisan-700-sq-wah/04-land-view.webp', '/listing-media/mapxprop/sutthisan-700-sq-wah/04-land-view.webp', 'image/webp', 1920, 1080, 40, false, true),
        (land_listing_id, 'image', 'user_upload', 'gallery', 'ที่ดินสองแปลงติดกัน', 'มุมมองพื้นที่รวมของที่ดิน 2 แปลงติดกัน เนื้อที่รวม 700 ตารางวา', 'https://www.mapxprop.com/listing-media/mapxprop/sutthisan-700-sq-wah/05-land-view.webp', '/listing-media/mapxprop/sutthisan-700-sq-wah/05-land-view.webp', 'image/webp', 1920, 1080, 50, false, true),
        (land_listing_id, 'image', 'user_upload', 'gallery', 'แนวรั้วและถนนหน้าแปลง', 'แนวรั้วของที่ดินและถนนภายในซอยจัดสรร สุทธิสาร', 'https://www.mapxprop.com/listing-media/mapxprop/sutthisan-700-sq-wah/06-land-view.webp', '/listing-media/mapxprop/sutthisan-700-sq-wah/06-land-view.webp', 'image/webp', 1920, 1080, 60, false, true),
        (land_listing_id, 'image', 'user_upload', 'gallery', 'ภาพมุมกว้างของแปลงที่ดิน', 'ภาพมุมกว้างของที่ดินเปล่า 700 ตารางวาและสภาพแวดล้อมโดยรอบ', 'https://www.mapxprop.com/listing-media/mapxprop/sutthisan-700-sq-wah/07-land-view.webp', '/listing-media/mapxprop/sutthisan-700-sq-wah/07-land-view.webp', 'image/webp', 1920, 1080, 70, false, true)
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
        'MapxProp',
        NULL,
        'mapxprop-owner-sutthisan-700-square-wah',
        now(),
        'ข้อมูล ราคา พิกัด และภาพถ่ายได้รับโดยตรงจากเจ้าของที่ดิน ข้อมูลโฉนด แนวเขต และข้อกำหนดการพัฒนาต้องตรวจสอบก่อนทำสัญญา'
    )
    ON CONFLICT (listing_id, source_type, reference_code) DO UPDATE SET
        publisher_name = EXCLUDED.publisher_name,
        notes = EXCLUDED.notes;
END $$;

COMMIT;
