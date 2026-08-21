BEGIN;

DO $$
DECLARE
    platform_user_id bigint;
    event_listing_id bigint;
BEGIN
    SELECT id INTO platform_user_id
    FROM public.auth_users
    WHERE lower(email) = lower('mapxprop@gmail.com')
    ORDER BY id
    LIMIT 1;

    IF platform_user_id IS NULL THEN
        RAISE EXCEPTION 'MapxProp platform user is required before importing editorial listings';
    END IF;

    SELECT id INTO event_listing_id
    FROM public.listings
    WHERE slug = 'local-favorites-emsphere-2026'
    LIMIT 1;

    IF event_listing_id IS NULL THEN
        INSERT INTO public.listings (
            user_id,
            property_type_code,
            usage_type,
            listing_type,
            custom_project_name,
            custom_building_name,
            title,
            description,
            price_negotiable,
            contact_name,
            contact_phone,
            line_id,
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
            expires_at,
            is_verified,
            is_active,
            source_channel,
            business_type_code,
            space_type_code,
            target_tenant_type,
            price_unit,
            listing_scope,
            slug
        ) VALUES (
            platform_user_id,
            'retail_space',
            'business',
            'event_booking',
            'EMSPHERE',
            'EM MARKET HALL',
            'เปิดจองบูธงาน LOCAL FAVORITES ที่ EMSPHERE ชั้น G',
            E'เปิดรับร้านค้าออกบูธงาน LOCAL FAVORITES ระหว่างวันที่ 11–22 กันยายน 2026 ที่ EM MARKET HALL ชั้น G ศูนย์การค้า EMSPHERE รับร้านอาหาร เครื่องดื่ม เบเกอรี่ และของหวาน\n\nกลุ่มผู้เข้าชมหลักเป็นวัยทำงาน คนเดินห้าง นักท่องเที่ยว และชาวต่างชาติ ทำเลอยู่ภายในศูนย์การค้าและผู้จัดระบุว่ามีการประชาสัมพันธ์ผ่านช่องทางของงาน\n\nราคา ขนาดบูธ เลขบูธ จำนวนพื้นที่คงเหลือ เงื่อนไขการขาย ระบบไฟ น้ำ และแปลนพื้นที่ กรุณาสอบถาม HBD Event โดยตรงก่อนจอง',
            false,
            'HBD Event',
            '0992602026',
            '@hbdtalk',
            true,
            false,
            'EM MARKET HALL ชั้น G, EMSPHERE',
            '628 ถนนสุขุมวิท แขวงคลองตัน เขตคลองเตย กรุงเทพมหานคร',
            'ถนนสุขุมวิท',
            '10110',
            13.732147,
            100.566540,
            'กรุงเทพมหานคร',
            'คลองเตย',
            'คลองตัน',
            'active',
            'approved',
            now(),
            '2026-08-18 18:16:00+07',
            '2026-09-23 00:00:00+07',
            false,
            true,
            'editorial_import',
            'food_and_beverage_event',
            'event_booth',
            'office_workers_mall_visitors_and_international_visitors',
            'event_round',
            'space_slot',
            'local-favorites-emsphere-2026'
        )
        RETURNING id INTO event_listing_id;
    END IF;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES
        (event_listing_id, 'retail'),
        (event_listing_id, 'food_service')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (listing_id, offer_type, amount, price_unit, is_negotiable)
    VALUES (event_listing_id, 'event_booking', NULL, 'event_round', false)
    ON CONFLICT (listing_id, offer_type) DO UPDATE SET
        amount = EXCLUDED.amount,
        price_unit = EXCLUDED.price_unit,
        is_negotiable = EXCLUDED.is_negotiable,
        updated_at = now();

    INSERT INTO public.listing_discovery_channels (listing_id, channel_code, source, is_featured)
    VALUES (event_listing_id, 'business', 'editorial', false)
    ON CONFLICT (listing_id, channel_code) DO UPDATE SET
        source = EXCLUDED.source,
        updated_at = now();

    INSERT INTO public.listing_business_details (
        listing_id,
        venue_type_code,
        floor_label,
        allowed_business_types,
        foot_traffic_level,
        cooking_allowed
    ) VALUES (
        event_listing_id,
        'event_booth',
        'G',
        ARRAY['food','beverage','bakery','dessert'],
        'mall_visitors',
        false
    )
    ON CONFLICT (listing_id) DO UPDATE SET
        venue_type_code = EXCLUDED.venue_type_code,
        floor_label = EXCLUDED.floor_label,
        allowed_business_types = EXCLUDED.allowed_business_types,
        foot_traffic_level = EXCLUDED.foot_traffic_level,
        updated_at = now();

    INSERT INTO public.listing_event_details (
        listing_id,
        event_name,
        organizer_name,
        venue_name,
        venue_floor_label,
        audience_segments,
        accepted_product_categories,
        application_instructions,
        floor_plan_url,
        price_on_request,
        booth_size_on_request,
        source_published_at
    ) VALUES (
        event_listing_id,
        'LOCAL FAVORITES',
        'HBD Event',
        'EMSPHERE – EM MARKET HALL',
        'G',
        ARRAY['วัยทำงาน','คนเดินห้าง','นักท่องเที่ยวและชาวต่างชาติ'],
        ARRAY['อาหาร','เครื่องดื่ม','เบเกอรี่','ของหวาน'],
        'ติดต่อ HBD Event เพื่อสอบถามราคา ขนาดบูธ เลขบูธ แปลน เงื่อนไข และจำนวนพื้นที่ที่ยังว่างก่อนจอง',
        'https://bit.ly/2CgdOmX',
        true,
        true,
        '2026-08-18 18:16:00+07'
    )
    ON CONFLICT (listing_id) DO UPDATE SET
        event_name = EXCLUDED.event_name,
        organizer_name = EXCLUDED.organizer_name,
        venue_name = EXCLUDED.venue_name,
        venue_floor_label = EXCLUDED.venue_floor_label,
        audience_segments = EXCLUDED.audience_segments,
        accepted_product_categories = EXCLUDED.accepted_product_categories,
        application_instructions = EXCLUDED.application_instructions,
        floor_plan_url = EXCLUDED.floor_plan_url,
        price_on_request = EXCLUDED.price_on_request,
        booth_size_on_request = EXCLUDED.booth_size_on_request,
        source_published_at = EXCLUDED.source_published_at,
        updated_at = now();

    INSERT INTO public.listing_event_rounds
        (listing_id, round_label, starts_on, ends_on, availability_status, price_unit, sort_order)
    VALUES
        (event_listing_id, 'รอบงาน LOCAL FAVORITES', '2026-09-11', '2026-09-22', 'open', 'event_round', 10)
    ON CONFLICT (listing_id, starts_on, ends_on) DO UPDATE SET
        round_label = EXCLUDED.round_label,
        availability_status = EXCLUDED.availability_status,
        price_unit = EXCLUDED.price_unit,
        sort_order = EXCLUDED.sort_order,
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
    ) VALUES (
        event_listing_id,
        'image',
        'editorial_import',
        'cover',
        'โปสเตอร์ LOCAL FAVORITES',
        'เปิดจองบูธ LOCAL FAVORITES วันที่ 11 ถึง 22 กันยายน 2026 ที่ EMSPHERE EM MARKET HALL ชั้น G',
        'https://www.mapxprop.com/listing-media/hbd/local-favorites-emsphere-2026.jpg',
        '/listing-media/hbd/local-favorites-emsphere-2026.jpg',
        'image/jpeg',
        1024,
        1536,
        10,
        true,
        true
    )
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
        event_listing_id,
        'public_post',
        'HBD Event',
        NULL,
        'hbd-event-facebook-2026-08-18-emsphere',
        '2026-08-21 00:00:00+07',
        'นำเข้าจากโพสต์สาธารณะและโปสเตอร์ที่ผู้ดูแล MapxProp ตรวจทาน ข้อมูลราคา ขนาดบูธ เลขบูธ จำนวนคงเหลือ และเงื่อนไขทางเทคนิคยังต้องยืนยันกับผู้จัด'
    )
    ON CONFLICT (listing_id, source_type, reference_code) DO UPDATE SET
        publisher_name = EXCLUDED.publisher_name,
        notes = EXCLUDED.notes;
END $$;

COMMIT;
