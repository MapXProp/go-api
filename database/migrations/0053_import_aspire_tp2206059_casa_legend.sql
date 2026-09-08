BEGIN;

DO $$
DECLARE
    admin_user_id bigint;
    aspire_organization_id bigint;
    casa_legend_project_id bigint;
    property_listing_id bigint;
BEGIN
    SELECT id INTO admin_user_id
    FROM public.auth_users
    WHERE lower(email) = 'mapxprop@gmail.com'
      AND deleted_at IS NULL
    ORDER BY id
    LIMIT 1;

    SELECT id INTO aspire_organization_id
    FROM public.organizations
    WHERE slug = 'aspire-real-estate-agency'
      AND verification_status = 'verified'
      AND is_active = true
      AND deleted_at IS NULL
    LIMIT 1;

    SELECT id INTO casa_legend_project_id
    FROM public.property_projects
    WHERE slug = 'casa-legend-ratchaphruek-pinklao'
      AND is_active = true
      AND deleted_at IS NULL
    LIMIT 1;

    IF admin_user_id IS NULL
       OR aspire_organization_id IS NULL
       OR casa_legend_project_id IS NULL THEN
        RAISE EXCEPTION 'MapxProp admin, verified Aspire organization, and Casa Legend project are required before importing TP2206059';
    END IF;

    INSERT INTO public.listings (
        public_listing_id,
        user_id,
        organization_id,
        created_by_user_id,
        published_by_user_id,
        project_id,
        property_type_code,
        usage_type,
        listing_type,
        listing_scope,
        custom_project_name,
        custom_unit_number,
        title,
        description,
        sale_price,
        price_negotiable,
        land_area_sqm,
        bedroom_count,
        bathroom_count,
        pet_allowed,
        contact_name,
        contact_phone,
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
        slug
    ) VALUES (
        'e0b1800b-a660-4447-abf9-99c3aaa6f94e',
        admin_user_id,
        aspire_organization_id,
        admin_user_id,
        admin_user_id,
        casa_legend_project_id,
        'detached_house',
        'residence',
        'sale',
        'whole_property',
        'คาซ่า เลเจ้นด์ ราชพฤกษ์-ปิ่นเกล้า',
        '189/68',
        'ขายบ้านเดี่ยว Casa Legend ราชพฤกษ์-ปิ่นเกล้า 63.4 ตร.ว. ราคา 9.9 ล้านบาท',
        E'บ้านเดี่ยวในโครงการคาซ่า เลเจ้นด์ ราชพฤกษ์-ปิ่นเกล้า บ้านเลขที่ 189/68 ซอย 4\n\nเนื้อที่ 63.4 ตร.ว. 3 ห้องนอน 3 ห้องน้ำ มีพื้นที่สำหรับสัตว์เลี้ยง ทำเลถนนราชพฤกษ์–พระราม 5 เขตตลิ่งชัน\n\nราคา 9,900,000 บาท\n\nเสนอขายโดย Aspire Real Estate Agency รหัสทรัพย์ TP2206059\n\nผู้ซื้อควรตรวจสอบสภาพทรัพย์ เอกสารสิทธิ์ ค่าใช้จ่าย และเงื่อนไขกับผู้ดูแลก่อนตัดสินใจ',
        9900000,
        false,
        253.6,
        3,
        3,
        true,
        'Aspire Real Estate Agency',
        NULL,
        false,
        false,
        '189/68 ซอย 4 ถนนราชพฤกษ์',
        'โครงการคาซ่า เลเจ้นด์ ราชพฤกษ์-ปิ่นเกล้า',
        'ถนนราชพฤกษ์',
        '10170',
        13.79153215,
        100.45240006,
        'กรุงเทพมหานคร',
        'ตลิ่งชัน',
        'ตลิ่งชัน',
        'active',
        'approved',
        now(),
        now(),
        now(),
        now(),
        true,
        true,
        'editorial_import',
        'total',
        'house-casa-legend-ratchapruek-tp2206059'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential');

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 9900000, 'total', 'THB', false
    );

    INSERT INTO public.listing_discovery_channels (
        listing_id, channel_code, source, is_featured
    ) VALUES (
        property_listing_id, 'homes', 'editorial', false
    );

    INSERT INTO public.listing_category_details (
        listing_id, category_code, schema_version, details, is_minimum_submission
    ) VALUES (
        property_listing_id,
        'detached_house',
        1,
        jsonb_build_object(
            'land_area_square_wah', 63.4,
            'road_name_th', 'ราชพฤกษ์',
            'road_name_en', 'Ratchapruek'
        ),
        true
    );

    INSERT INTO public.listing_contact_profiles (
        listing_id,
        role_code,
        authority_source_code,
        organization_name,
        verification_status,
        verification_note,
        verified_at,
        verified_by_user_id,
        organization_id,
        contact_user_id
    ) VALUES (
        property_listing_id,
        'agency_broker',
        'brokerage_company',
        'Aspire Real Estate Agency',
        'authority_verified',
        'MapxProp administrator verified this company as the publisher for listing TP2206059.',
        now(),
        admin_user_id,
        aspire_organization_id,
        NULL
    );

    INSERT INTO public.listing_amenities (listing_id, amenity_code)
    VALUES (property_listing_id, 'pet_area');

    INSERT INTO public.listing_media (
        listing_id, media_type, source_type, role_code, title, alt_text,
        original_url, file_url, mime_type, file_size_bytes, width, height,
        sort_order, is_primary, is_active
    ) VALUES
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ด้านหน้าบ้าน', 'บ้านเดี่ยว Casa Legend ราชพฤกษ์-ปิ่นเกล้า', 'https://media.kkpfg.com/npa/property/TP2206059/1.jpg', '/listing-media/kkppropify/tp2206059/01.webp', 'image/webp', 281394, 2400, 1800, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'สวนข้างบ้าน', 'สวนและทางเดินข้างบ้าน', 'https://media.kkpfg.com/npa/property/TP2206059/2.jpg', '/listing-media/kkppropify/tp2206059/02.webp', 'image/webp', 580064, 2400, 1800, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่หน้าบ้าน', 'ลานและพื้นที่จอดรถหน้าบ้าน', 'https://media.kkpfg.com/npa/property/TP2206059/3.jpg', '/listing-media/kkppropify/tp2206059/03.webp', 'image/webp', 377116, 2400, 1800, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องรับแขก', 'ห้องรับแขกโทนสว่างมองออกสู่สวน', 'https://media.kkpfg.com/npa/property/TP2206059/4.jpg', '/listing-media/kkppropify/tp2206059/04.webp', 'image/webp', 174912, 2400, 1800, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องรับแขกอีกมุม', 'มุมนั่งเล่นและพื้นที่รับแขก', 'https://media.kkpfg.com/npa/property/TP2206059/5.jpg', '/listing-media/kkppropify/tp2206059/05.webp', 'image/webp', 113594, 2400, 1800, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนใหญ่', 'ห้องนอนใหญ่พร้อมพื้นที่แต่งตัว', 'https://media.kkpfg.com/npa/property/TP2206059/6.jpg', '/listing-media/kkppropify/tp2206059/06.webp', 'image/webp', 87178, 2400, 1800, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ตู้เสื้อผ้าบิลต์อิน', 'พื้นที่ตู้เสื้อผ้าบิลต์อินในห้องนอน', 'https://media.kkpfg.com/npa/property/TP2206059/7.jpg', '/listing-media/kkppropify/tp2206059/07.webp', 'image/webp', 147714, 2400, 1800, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอน', 'ห้องนอนพร้อมตู้เก็บของและมุมนั่งเล่น', 'https://media.kkpfg.com/npa/property/TP2206059/8.jpg', '/listing-media/kkppropify/tp2206059/08.webp', 'image/webp', 149856, 2400, 1800, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องครัว', 'ห้องครัวพร้อมตู้และพื้นที่ปรุงอาหาร', 'https://media.kkpfg.com/npa/property/TP2206059/9.jpg', '/listing-media/kkppropify/tp2206059/09.webp', 'image/webp', 216638, 2400, 1800, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงบันได', 'โถงบันไดและพื้นที่ชั้นล่าง', 'https://media.kkpfg.com/npa/property/TP2206059/10.jpg', '/listing-media/kkppropify/tp2206059/10.webp', 'image/webp', 137970, 2400, 1800, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมมองสู่สวน', 'ประตูกระจกจากห้องรับแขกสู่สวนข้างบ้าน', 'https://media.kkpfg.com/npa/property/TP2206059/11.jpg', '/listing-media/kkppropify/tp2206059/11.webp', 'image/webp', 142282, 2400, 1800, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'หน้าต่างรับแสง', 'หน้าต่างมองออกไปยังพื้นที่สีเขียว', 'https://media.kkpfg.com/npa/property/TP2206059/12.jpg', '/listing-media/kkppropify/tp2206059/12.webp', 'image/webp', 330600, 2400, 1800, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำ', 'ห้องน้ำพร้อมพื้นที่อาบน้ำแบบกระจก', 'https://media.kkpfg.com/npa/property/TP2206059/13.jpg', '/listing-media/kkppropify/tp2206059/13.webp', 'image/webp', 261724, 1800, 2400, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนอีกห้อง', 'ห้องนอนโทนสว่างพร้อมเครื่องปรับอากาศ', 'https://media.kkpfg.com/npa/property/TP2206059/14.jpg', '/listing-media/kkppropify/tp2206059/14.webp', 'image/webp', 101700, 2400, 1800, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมพักผ่อนในห้องนอน', 'พื้นที่พักผ่อนภายในห้องนอน', 'https://media.kkpfg.com/npa/property/TP2206059/15.jpg', '/listing-media/kkppropify/tp2206059/15.webp', 'image/webp', 90632, 2400, 1800, 150, false, true);

    INSERT INTO public.listing_sources (
        listing_id,
        source_type,
        publisher_name,
        source_url,
        reference_code,
        captured_at,
        notes
    ) VALUES (
        property_listing_id,
        'editorial_import',
        'KKPPropify',
        'https://kkppropify.kkpfg.com/th/products/tp2206059',
        'TP2206059',
        '2026-09-08 00:00:00+07',
        'Imported from the public KKPPropify asset page. The page names Aspire Real Estate Agency as the verified property consultant. Administrator-supplied coordinates override the source map coordinates. Images are preserved without a MapxProp watermark; MapxProp stores optimized copies and retains each original source URL.'
    );

    IF NOT EXISTS (
        SELECT 1
        FROM public.organization_verifications
        WHERE organization_id = aspire_organization_id
          AND verification_type = 'listing_authority'
          AND status = 'verified'
          AND source_url = 'https://kkppropify.kkpfg.com/th/products/tp2206059'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            aspire_organization_id,
            'listing_authority',
            'verified',
            'https://kkppropify.kkpfg.com/th/products/tp2206059',
            'The listing identifies Aspire Real Estate Agency as its verified property consultant; MapxProp administrator approved the publisher.',
            admin_user_id,
            now()
        );
    END IF;

    INSERT INTO public.organization_audit_logs (
        organization_id, actor_user_id, action_code,
        entity_type, entity_public_id, metadata
    ) VALUES (
        aspire_organization_id,
        admin_user_id,
        'listing.publisher_verified',
        'listing',
        'e0b1800b-a660-4447-abf9-99c3aaa6f94e',
        jsonb_build_object('reference_code', 'TP2206059')
    );
END $$;

COMMIT;
