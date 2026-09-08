BEGIN;

DO $$
DECLARE
    kkp_user_id bigint;
    kkp_organization_id bigint;
    casa_legend_project_id bigint;
    property_listing_id bigint;
BEGIN
    SELECT id INTO kkp_user_id
    FROM public.auth_users
    WHERE lower(email) = 'kkpcontactcenter@kkpfg.com'
      AND deleted_at IS NULL
    ORDER BY id
    LIMIT 1;

    SELECT id INTO kkp_organization_id
    FROM public.organizations
    WHERE slug = 'kkppropify'
      AND is_active = true
      AND deleted_at IS NULL
    LIMIT 1;

    IF kkp_user_id IS NULL OR kkp_organization_id IS NULL THEN
        RAISE EXCEPTION 'Verified KKPPropify user and organization are required before importing TP2206058';
    END IF;

    INSERT INTO public.property_projects (
        public_project_id,
        slug,
        project_category,
        name_th,
        name_en,
        supported_property_types,
        description_th,
        description_en,
        address_line1,
        road,
        subdistrict_name,
        district_name,
        province_name,
        postal_code,
        latitude,
        longitude,
        source_url,
        verification_status,
        verification_note,
        metadata
    ) VALUES (
        'efc0abd3-568b-4a71-90a5-1953e26bcf77',
        'casa-legend-ratchaphruek-pinklao',
        'housing_estate',
        'คาซ่า เลเจ้นด์ ราชพฤกษ์-ปิ่นเกล้า',
        'Casa Legend Ratchaphruek-Pinklao',
        ARRAY['detached_house'],
        'โครงการบ้านเดี่ยวคาซ่า เลเจ้นด์ บนทำเลถนนราชพฤกษ์ เขตตลิ่งชัน',
        'A Casa Legend detached-house development on Ratchaphruek Road in Taling Chan.',
        'ซอย 1',
        'ถนนราชพฤกษ์',
        'ตลิ่งชัน',
        'ตลิ่งชัน',
        'กรุงเทพมหานคร',
        '10170',
        13.79239089,
        100.45244097,
        'https://kkppropify.kkpfg.com/th/products/tp2206058',
        'source_checked',
        'Project identity and location were checked against the KKPPropify asset page and the coordinates supplied by the MapxProp administrator.',
        jsonb_build_object(
            'brand', 'Casa Legend',
            'road_name_th', 'ราชพฤกษ์',
            'road_name_en', 'Ratchapruek',
            'location_precision', 'administrator_provided_coordinates',
            'source_reference', 'TP2206058'
        )
    )
    ON CONFLICT (slug) DO UPDATE SET
        project_category = EXCLUDED.project_category,
        name_th = EXCLUDED.name_th,
        name_en = EXCLUDED.name_en,
        supported_property_types = EXCLUDED.supported_property_types,
        description_th = EXCLUDED.description_th,
        description_en = EXCLUDED.description_en,
        address_line1 = EXCLUDED.address_line1,
        road = EXCLUDED.road,
        subdistrict_name = EXCLUDED.subdistrict_name,
        district_name = EXCLUDED.district_name,
        province_name = EXCLUDED.province_name,
        postal_code = EXCLUDED.postal_code,
        latitude = EXCLUDED.latitude,
        longitude = EXCLUDED.longitude,
        source_url = EXCLUDED.source_url,
        verification_status = EXCLUDED.verification_status,
        verification_note = EXCLUDED.verification_note,
        metadata = EXCLUDED.metadata,
        is_active = true,
        deleted_at = NULL,
        updated_at = now()
    RETURNING id INTO casa_legend_project_id;

    INSERT INTO public.property_project_aliases (
        project_id, locale, alias_name, alias_type
    ) VALUES
        (casa_legend_project_id, 'th', 'คาซ่า เลเจ้นด์ ราชพฤกษ์-ปิ่นเกล้า', 'official'),
        (casa_legend_project_id, 'th', 'คาซ่า เลเจนด์ ราชพฤกษ์-ปิ่นเกล้า', 'alternate'),
        (casa_legend_project_id, 'th', 'คาซ่า เลเจ้นด์', 'alternate'),
        (casa_legend_project_id, 'th', 'โครงการคาซ่า เลเจ้นด์', 'alternate'),
        (casa_legend_project_id, 'en', 'Casa Legend Ratchaphruek-Pinklao', 'official'),
        (casa_legend_project_id, 'en', 'Casa Legend', 'alternate'),
        (casa_legend_project_id, 'en', 'Casa Legend Ratchapruek', 'transliteration'),
        (casa_legend_project_id, 'en', 'Casa Legend Ratchapruk-Pinklao', 'transliteration')
    ON CONFLICT (project_id, locale, normalized_alias) DO NOTHING;

    INSERT INTO public.property_project_amenities (
        project_id, amenity_code, label_th, label_en, source_url
    ) VALUES (
        casa_legend_project_id,
        'pet_area',
        'พื้นที่สำหรับสัตว์เลี้ยง',
        'Pet area',
        'https://kkppropify.kkpfg.com/th/products/tp2206058'
    )
    ON CONFLICT (project_id, amenity_code) DO UPDATE SET
        label_th = EXCLUDED.label_th,
        label_en = EXCLUDED.label_en,
        source_url = EXCLUDED.source_url;

    SELECT id INTO property_listing_id
    FROM public.listings
    WHERE slug = 'house-casa-legend-ratchapruek-tp2206058'
    LIMIT 1;

    IF property_listing_id IS NULL THEN
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
            'cf1948bc-c487-4ffe-9b76-b39a2951b69c',
            kkp_user_id,
            kkp_organization_id,
            kkp_user_id,
            kkp_user_id,
            casa_legend_project_id,
            'detached_house',
            'residence',
            'sale',
            'whole_property',
            'คาซ่า เลเจ้นด์ ราชพฤกษ์-ปิ่นเกล้า',
            '189/10',
            'ขายบ้านเดี่ยว Casa Legend ราชพฤกษ์-ปิ่นเกล้า 3 ห้องนอน ราคา 8.9 ล้านบาท',
            E'บ้านเดี่ยวในโครงการคาซ่า เลเจ้นด์ ราชพฤกษ์-ปิ่นเกล้า บ้านเลขที่ 189/10 ซอย 1\n\nเนื้อที่ 50.6 ตร.ว. 3 ห้องนอน 3 ห้องน้ำ มีพื้นที่สำหรับสัตว์เลี้ยง ทำเลถนนราชพฤกษ์–พระราม 5 เขตตลิ่งชัน\n\nราคา 8,900,000 บาท\n\nเสนอขายโดย Aspire Real Estate Agency ผ่าน KKPPropify รหัสทรัพย์ TP2206058\n\nข้อมูลและรูปภาพนำเข้าจาก KKPPropify เมื่อวันที่ 8 กันยายน 2569 ผู้ซื้อควรตรวจสอบสภาพทรัพย์ เอกสารสิทธิ์ ค่าใช้จ่าย และเงื่อนไขกับผู้ดูแลก่อนตัดสินใจ',
            8900000,
            false,
            202.4,
            3,
            3,
            true,
            'Aspire Real Estate Agency',
            NULL,
            false,
            false,
            '189/10 ซอย 1 ถนนราชพฤกษ์',
            'โครงการคาซ่า เลเจ้นด์ ราชพฤกษ์-ปิ่นเกล้า',
            'ถนนราชพฤกษ์',
            '10170',
            13.79239089,
            100.45244097,
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
            'house-casa-legend-ratchapruek-tp2206058'
        )
        RETURNING id INTO property_listing_id;
    ELSE
        UPDATE public.listings
        SET organization_id = kkp_organization_id,
            created_by_user_id = COALESCE(created_by_user_id, kkp_user_id),
            published_by_user_id = COALESCE(published_by_user_id, kkp_user_id),
            project_id = casa_legend_project_id,
            custom_project_name = 'คาซ่า เลเจ้นด์ ราชพฤกษ์-ปิ่นเกล้า',
            custom_unit_number = '189/10',
            title = 'ขายบ้านเดี่ยว Casa Legend ราชพฤกษ์-ปิ่นเกล้า 3 ห้องนอน ราคา 8.9 ล้านบาท',
            sale_price = 8900000,
            land_area_sqm = 202.4,
            bedroom_count = 3,
            bathroom_count = 3,
            pet_allowed = true,
            contact_name = 'Aspire Real Estate Agency',
            contact_phone = NULL,
            show_phone = false,
            address_line1 = '189/10 ซอย 1 ถนนราชพฤกษ์',
            address_line2 = 'โครงการคาซ่า เลเจ้นด์ ราชพฤกษ์-ปิ่นเกล้า',
            road = 'ถนนราชพฤกษ์',
            postal_code = '10170',
            latitude = 13.79239089,
            longitude = 100.45244097,
            province_name = 'กรุงเทพมหานคร',
            district_name = 'ตลิ่งชัน',
            subdistrict_name = 'ตลิ่งชัน',
            is_verified = true,
            is_active = true,
            deleted_at = NULL,
            updated_at = now()
        WHERE id = property_listing_id;
    END IF;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 8900000, 'total', 'THB', false
    )
    ON CONFLICT (listing_id, offer_type) DO UPDATE SET
        amount = EXCLUDED.amount,
        price_unit = EXCLUDED.price_unit,
        currency_code = EXCLUDED.currency_code,
        is_negotiable = EXCLUDED.is_negotiable,
        updated_at = now();

    INSERT INTO public.listing_discovery_channels (
        listing_id, channel_code, source, is_featured
    ) VALUES (
        property_listing_id, 'homes', 'editorial', false
    )
    ON CONFLICT (listing_id, channel_code) DO UPDATE SET
        source = EXCLUDED.source,
        is_featured = EXCLUDED.is_featured,
        updated_at = now();

    INSERT INTO public.listing_category_details (
        listing_id, category_code, schema_version, details, is_minimum_submission
    ) VALUES (
        property_listing_id,
        'detached_house',
        1,
        jsonb_build_object(
            'land_area_square_wah', 50.6,
            'source_property_id', 'TP2206058',
            'source_posted_on', '2026-03-31',
            'source_agent_name', 'Aspire Real Estate Agency',
            'source_agent_verified', true,
            'road_name_th', 'ราชพฤกษ์',
            'road_name_en', 'Ratchapruek',
            'data_provenance', 'KKPPropify public asset page'
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
        verification_status,
        verification_note,
        verified_at,
        organization_id,
        contact_user_id
    ) VALUES (
        property_listing_id,
        'agency_broker',
        'brokerage_company',
        'Aspire Real Estate Agency',
        'identity_verified',
        'KKPPropify marks Aspire Real Estate Agency as Verified; MapxProp has not independently verified listing authority.',
        now(),
        NULL,
        NULL
    )
    ON CONFLICT (listing_id) DO UPDATE SET
        role_code = EXCLUDED.role_code,
        authority_source_code = EXCLUDED.authority_source_code,
        organization_name = EXCLUDED.organization_name,
        verification_status = EXCLUDED.verification_status,
        verification_note = EXCLUDED.verification_note,
        verified_at = EXCLUDED.verified_at,
        organization_id = EXCLUDED.organization_id,
        contact_user_id = EXCLUDED.contact_user_id,
        updated_at = now();

    INSERT INTO public.listing_amenities (listing_id, amenity_code)
    VALUES (property_listing_id, 'pet_area')
    ON CONFLICT (listing_id, amenity_code) DO NOTHING;

    INSERT INTO public.listing_media (
        listing_id, media_type, source_type, role_code, title, alt_text,
        original_url, file_url, mime_type, file_size_bytes, width, height,
        sort_order, is_primary, is_active
    ) VALUES
        (property_listing_id, 'image', 'editorial_import', 'cover', 'หน้าบ้าน', 'บ้านเดี่ยว Casa Legend ราชพฤกษ์-ปิ่นเกล้า', 'https://media.kkpfg.com/npa/property/TP2206058/1.jpg', '/listing-media/kkppropify/tp2206058/01.webp', 'image/webp', 216858, 1477, 1108, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ที่จอดรถ', 'พื้นที่จอดรถภายในบ้านเดี่ยว', 'https://media.kkpfg.com/npa/property/TP2206058/2.jpg', '/listing-media/kkppropify/tp2206058/02.webp', 'image/webp', 479410, 2400, 1800, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องรับแขก', 'ห้องรับแขกพร้อมหน้าต่างรับแสง', 'https://media.kkpfg.com/npa/property/TP2206058/3.jpg', '/listing-media/kkppropify/tp2206058/03.webp', 'image/webp', 164570, 2400, 1800, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่พักผ่อน', 'พื้นที่พักผ่อนภายในบ้าน', 'https://media.kkpfg.com/npa/property/TP2206058/4.jpg', '/listing-media/kkppropify/tp2206058/04.webp', 'image/webp', 178808, 2400, 1800, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ใช้สอย', 'พื้นที่ใช้สอยภายในชั้นล่าง', 'https://media.kkpfg.com/npa/property/TP2206058/5.jpg', '/listing-media/kkppropify/tp2206058/05.webp', 'image/webp', 241516, 2400, 1800, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมรับแขก', 'มุมรับแขกและพื้นที่ภายในบ้าน', 'https://media.kkpfg.com/npa/property/TP2206058/6.jpg', '/listing-media/kkppropify/tp2206058/06.webp', 'image/webp', 159470, 2400, 1800, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บันไดภายในบ้าน', 'บันไดเชื่อมพื้นที่ชั้นล่างและชั้นบน', 'https://media.kkpfg.com/npa/property/TP2206058/7.jpg', '/listing-media/kkppropify/tp2206058/07.webp', 'image/webp', 116084, 2400, 1800, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงชั้นบน', 'โถงทางเดินบริเวณชั้นบน', 'https://media.kkpfg.com/npa/property/TP2206058/8.jpg', '/listing-media/kkppropify/tp2206058/08.webp', 'image/webp', 160574, 2400, 1800, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอน', 'ห้องนอนพร้อมหน้าต่างและตู้เสื้อผ้า', 'https://media.kkpfg.com/npa/property/TP2206058/9.jpg', '/listing-media/kkppropify/tp2206058/09.webp', 'image/webp', 102356, 2400, 1800, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนอีกมุม', 'พื้นที่ภายในห้องนอนอีกมุมหนึ่ง', 'https://media.kkpfg.com/npa/property/TP2206058/10.jpg', '/listing-media/kkppropify/tp2206058/10.webp', 'image/webp', 151462, 2400, 1800, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่แต่งตัว', 'พื้นที่แต่งตัวและตู้เก็บของภายในบ้าน', 'https://media.kkpfg.com/npa/property/TP2206058/11.jpg', '/listing-media/kkppropify/tp2206058/11.webp', 'image/webp', 74850, 1080, 810, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนแนวตั้ง', 'ห้องนอนพร้อมเตียงและหน้าต่าง', 'https://media.kkpfg.com/npa/property/TP2206058/12.jpg', '/listing-media/kkppropify/tp2206058/12.webp', 'image/webp', 82834, 1080, 1441, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ตู้เสื้อผ้า', 'พื้นที่ตู้เสื้อผ้าและทางเดินภายในห้อง', 'https://media.kkpfg.com/npa/property/TP2206058/13.jpg', '/listing-media/kkppropify/tp2206058/13.webp', 'image/webp', 89554, 1037, 1383, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมนั่งเล่น', 'มุมนั่งเล่นขนาดกะทัดรัดภายในบ้าน', 'https://media.kkpfg.com/npa/property/TP2206058/14.jpg', '/listing-media/kkppropify/tp2206058/14.webp', 'image/webp', 36732, 993, 745, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ช่องแสงบริเวณบันได', 'ช่องแสงและบันไดภายในบ้าน', 'https://media.kkpfg.com/npa/property/TP2206058/15.jpg', '/listing-media/kkppropify/tp2206058/15.webp', 'image/webp', 221014, 2400, 1800, 150, false, true)
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
        property_listing_id,
        'editorial_import',
        'KKPPropify',
        'https://kkppropify.kkpfg.com/th/products/tp2206058',
        'TP2206058',
        '2026-09-08 00:00:00+07',
        'Imported from the public KKPPropify asset page. The page names Aspire Real Estate Agency as the verified property consultant. Administrator-supplied coordinates override the source map coordinates. Images are preserved without a MapxProp watermark; MapxProp stores optimized copies and retains each original source URL.'
    )
    ON CONFLICT (listing_id, source_type, reference_code) DO UPDATE SET
        publisher_name = EXCLUDED.publisher_name,
        source_url = EXCLUDED.source_url,
        captured_at = EXCLUDED.captured_at,
        notes = EXCLUDED.notes;
END $$;

COMMIT;
