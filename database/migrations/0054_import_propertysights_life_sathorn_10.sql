BEGIN;

DO $$
DECLARE
    admin_user_id bigint;
    propertysights_organization_id bigint;
    life_sathorn_project_id bigint;
    property_listing_id bigint;
BEGIN
    SELECT id INTO admin_user_id
    FROM public.auth_users
    WHERE lower(email) = 'mapxprop@gmail.com'
      AND deleted_at IS NULL
    ORDER BY id
    LIMIT 1;

    IF admin_user_id IS NULL THEN
        RAISE EXCEPTION 'MapxProp super admin is required to import listing 10024893';
    END IF;

    INSERT INTO public.organizations (
        public_organization_id,
        slug,
        display_name,
        legal_name,
        organization_type,
        registration_no,
        website_url,
        verified_domain,
        description,
        verification_status,
        verification_note,
        verified_at,
        verified_by_user_id,
        created_by_user_id,
        is_active
    ) VALUES (
        '828de420-61e4-46ac-825a-9a1d2e51682a',
        'propertysights-real-estate',
        'PropertySights Real Estate',
        'Rubin Global Co., Ltd.',
        'agency',
        '0105556180040',
        'https://propertysights.com/',
        'propertysights.com',
        'บริษัทตัวแทนอสังหาริมทรัพย์ในกรุงเทพฯ เชี่ยวชาญด้านคอนโด บ้าน การซื้อขาย และการเช่า',
        'verified',
        'MapxProp administrator verified the organization website, DBD registration details, public contact information, and listing authority for property 10024893.',
        now(),
        admin_user_id,
        admin_user_id,
        true
    )
    ON CONFLICT (slug) DO UPDATE SET
        display_name = EXCLUDED.display_name,
        legal_name = EXCLUDED.legal_name,
        organization_type = EXCLUDED.organization_type,
        registration_no = EXCLUDED.registration_no,
        website_url = EXCLUDED.website_url,
        verified_domain = EXCLUDED.verified_domain,
        description = EXCLUDED.description,
        verification_status = 'verified',
        verification_note = EXCLUDED.verification_note,
        verified_at = COALESCE(public.organizations.verified_at, now()),
        verified_by_user_id = admin_user_id,
        is_active = true,
        deleted_at = NULL,
        updated_at = now()
    RETURNING id INTO propertysights_organization_id;

    INSERT INTO public.organization_specialties (organization_id, specialty_code)
    VALUES
        (propertysights_organization_id, 'sale'),
        (propertysights_organization_id, 'rent'),
        (propertysights_organization_id, 'condo'),
        (propertysights_organization_id, 'investment')
    ON CONFLICT (organization_id, specialty_code) DO NOTHING;

    INSERT INTO public.organization_contacts (
        organization_id, channel_type, channel_value, label,
        is_primary, is_public, is_verified, verified_at
    ) VALUES
        (propertysights_organization_id, 'phone', '0955179606', 'ติดต่อประกาศ', true, true, true, now()),
        (propertysights_organization_id, 'email', 'hello@propertysights.com', 'อีเมล', false, true, true, now()),
        (propertysights_organization_id, 'website', 'https://propertysights.com/', 'เว็บไซต์', false, true, true, now())
    ON CONFLICT (organization_id, channel_type, channel_value) DO UPDATE SET
        label = EXCLUDED.label,
        is_primary = EXCLUDED.is_primary,
        is_public = true,
        is_verified = true,
        verified_at = COALESCE(public.organization_contacts.verified_at, now()),
        updated_at = now();

    IF NOT EXISTS (
        SELECT 1
        FROM public.organization_verifications
        WHERE organization_id = propertysights_organization_id
          AND verification_type = 'legal_entity'
          AND status = 'verified'
          AND source_url = 'https://propertysights.com/about-us'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            propertysights_organization_id,
            'legal_entity',
            'verified',
            'https://propertysights.com/about-us',
            'PropertySights identifies Rubin Global Co., Ltd., DBD registration 0105556180040, as the registered operator and states TREBA membership 6302-001397.',
            admin_user_id,
            now()
        );
    END IF;

    INSERT INTO public.property_projects (
        public_project_id,
        slug,
        project_category,
        name_th,
        name_en,
        developer_name_th,
        developer_name_en,
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
        '069d00cc-c7ad-45f5-9593-1b96aa0a137e',
        'life-at-sathorn-10',
        'condominium',
        'ไลฟ์ แอท สาทร 10',
        'Life @ Sathorn 10',
        'บริษัท เอพี (ไทยแลนด์) จำกัด (มหาชน)',
        'AP (Thailand) Public Company Limited',
        ARRAY['condo'],
        'โครงการคอนโดมิเนียมในซอยสาทร 10 เขตบางรัก ใกล้ BTS ช่องนนทรี',
        'A condominium development on Sathorn Soi 10 in Bang Rak, near BTS Chong Nonsi.',
        '48 ซอยสาทร 10',
        'ถนนสาทรเหนือ',
        'สีลม',
        'บางรัก',
        'กรุงเทพมหานคร',
        '10500',
        13.72250105,
        100.52692967,
        'https://propertysights.com/projects/life-sathorn-10',
        'source_checked',
        'Project identity, developer, address, completion details, and facilities were cross-checked against the publisher project page and AP Thailand public records. Administrator-supplied coordinates are authoritative for MapxProp.',
        jsonb_build_object(
            'completion_year', 2010,
            'building_count', 1,
            'total_floors', 27,
            'total_units', 286,
            'tenure', 'freehold',
            'common_fee_per_sqm', 40
        )
    )
    ON CONFLICT (slug) DO UPDATE SET
        project_category = EXCLUDED.project_category,
        name_th = EXCLUDED.name_th,
        name_en = EXCLUDED.name_en,
        developer_name_th = EXCLUDED.developer_name_th,
        developer_name_en = EXCLUDED.developer_name_en,
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
    RETURNING id INTO life_sathorn_project_id;

    INSERT INTO public.property_project_aliases (
        project_id, locale, alias_name, alias_type
    ) VALUES
        (life_sathorn_project_id, 'th', 'ไลฟ์ แอท สาทร 10', 'official'),
        (life_sathorn_project_id, 'th', 'ไลฟ์ สาทร 10', 'alternate'),
        (life_sathorn_project_id, 'th', 'ไลฟ์ แอท สาทรเท็น', 'alternate'),
        (life_sathorn_project_id, 'en', 'Life @ Sathorn 10', 'official'),
        (life_sathorn_project_id, 'en', 'Life at Sathorn 10', 'alternate'),
        (life_sathorn_project_id, 'en', 'Life Sathorn 10', 'alternate'),
        (life_sathorn_project_id, 'en', 'Life @ Sathon 10', 'transliteration')
    ON CONFLICT (project_id, locale, normalized_alias) DO NOTHING;

    INSERT INTO public.property_project_amenities (
        project_id, amenity_code, label_th, label_en, source_url
    ) VALUES
        (life_sathorn_project_id, 'elevator', 'ลิฟต์', 'Elevator', 'https://propertysights.com/projects/life-sathorn-10'),
        (life_sathorn_project_id, 'fitness', 'ฟิตเนส', 'Fitness', 'https://propertysights.com/projects/life-sathorn-10'),
        (life_sathorn_project_id, 'parking', 'ที่จอดรถ', 'Parking', 'https://propertysights.com/projects/life-sathorn-10'),
        (life_sathorn_project_id, 'swimming_pool', 'สระว่ายน้ำ', 'Swimming pool', 'https://propertysights.com/projects/life-sathorn-10'),
        (life_sathorn_project_id, 'garden', 'สวนส่วนกลาง', 'Garden', 'https://propertysights.com/projects/life-sathorn-10'),
        (life_sathorn_project_id, 'security', 'ระบบรักษาความปลอดภัย 24 ชม.', '24-hour security', 'https://propertysights.com/projects/life-sathorn-10'),
        (life_sathorn_project_id, 'sauna', 'ซาวน่า', 'Sauna', 'https://propertysights.com/projects/life-sathorn-10'),
        (life_sathorn_project_id, 'playground', 'สนามเด็กเล่น', 'Playground', 'https://propertysights.com/projects/life-sathorn-10')
    ON CONFLICT (project_id, amenity_code) DO UPDATE SET
        label_th = EXCLUDED.label_th,
        label_en = EXCLUDED.label_en,
        source_url = EXCLUDED.source_url;

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
        title,
        description,
        sale_price,
        price_negotiable,
        usable_area_sqm,
        bedroom_count,
        bathroom_count,
        floor_no,
        total_floors,
        contact_name,
        contact_phone,
        contact_email,
        instagram_handle,
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
        '3eb2e9bb-da14-438b-a7e9-bfd9f4f6e065',
        admin_user_id,
        propertysights_organization_id,
        admin_user_id,
        admin_user_id,
        life_sathorn_project_id,
        'condo',
        'residence',
        'sale',
        'single_unit',
        'ไลฟ์ แอท สาทร 10',
        'ขายคอนโด Life @ Sathorn 10 ชั้น 27 ขนาด 65 ตร.ม. ราคา 9.5 ล้านบาท',
        E'คอนโด Life @ Sathorn 10 ขนาด 65 ตร.ม. ชั้น 27 มี 2 ห้องนอน 2 ห้องน้ำ ระเบียงพร้อมวิวเมือง\n\nครัวพร้อมเครื่องใช้ไฟฟ้าบิลต์อิน มีพื้นที่นั่งเล่นและรับประทานอาหาร ห้องเก็บของ พื้นที่ซักล้าง และตู้เสื้อผ้าบิลต์อิน\n\nส่วนกลางมีฟิตเนส สระว่ายน้ำ ลิฟต์ ที่จอดรถ และระบบรักษาความปลอดภัย\n\nราคา 9,500,000 บาท\n\nติดต่อ PropertySights Real Estate โทร. 095-517-9606 รหัสทรัพย์ 10024893\n\nผู้ซื้อควรตรวจสอบสภาพทรัพย์ เอกสารสิทธิ์ ค่าใช้จ่าย และเงื่อนไขกับผู้ดูแลก่อนตัดสินใจ',
        9500000,
        false,
        65,
        2,
        2,
        27,
        27,
        'PropertySights Real Estate',
        '0955179606',
        'hello@propertysights.com',
        'propertysights88',
        true,
        true,
        '48 ซอยสาทร 10 ถนนสาทรเหนือ',
        'โครงการไลฟ์ แอท สาทร 10',
        'ถนนสาทรเหนือ',
        '10500',
        13.72250105,
        100.52692967,
        'กรุงเทพมหานคร',
        'บางรัก',
        'สีลม',
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
        'condo-life-at-sathorn-10-10024893'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential');

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 9500000, 'total', 'THB', false
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
        'condo',
        1,
        jsonb_build_object(
            'unit_area_sqm', 65,
            'unit_floor', 27,
            'price_per_sqm', 146154,
            'project_completion_year', 2010,
            'tenure', 'freehold'
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
        'PropertySights Real Estate',
        'authority_verified',
        'MapxProp administrator verified this company and its authority as the publisher for listing 10024893.',
        now(),
        admin_user_id,
        propertysights_organization_id,
        NULL
    );

    INSERT INTO public.listing_amenities (listing_id, amenity_code)
    VALUES
        (property_listing_id, 'elevator'),
        (property_listing_id, 'fitness'),
        (property_listing_id, 'parking'),
        (property_listing_id, 'security'),
        (property_listing_id, 'swimming_pool');

    INSERT INTO public.listing_media (
        listing_id, media_type, source_type, role_code, title, alt_text,
        original_url, file_url, mime_type, file_size_bytes, width, height,
        sort_order, is_primary, is_active
    ) VALUES
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ห้องนั่งเล่น', 'ห้องนั่งเล่นคอนโด Life @ Sathorn 10', 'https://media.kkpfg.com/npa/property/10024893/01.jpg', '/listing-media/propertysights/10024893/01.webp', 'image/webp', 119998, 2400, 1582, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมรับแขก', 'โซฟาและมุมรับแขกภายในห้อง', 'https://media.kkpfg.com/npa/property/10024893/02.jpg', '/listing-media/propertysights/10024893/02.webp', 'image/webp', 69528, 2400, 1582, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมทีวีและระเบียง', 'พื้นที่นั่งเล่นเชื่อมต่อระเบียง', 'https://media.kkpfg.com/npa/property/10024893/03.jpg', '/listing-media/propertysights/10024893/03.webp', 'image/webp', 103722, 2400, 1582, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่รับประทานอาหาร', 'โต๊ะรับประทานอาหารและตู้บิลต์อิน', 'https://media.kkpfg.com/npa/property/10024893/04.jpg', '/listing-media/propertysights/10024893/04.webp', 'image/webp', 97048, 2400, 1582, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนใหญ่', 'ห้องนอนใหญ่พร้อมวิวเมืองจากชั้น 27', 'https://media.kkpfg.com/npa/property/10024893/05.jpg', '/listing-media/propertysights/10024893/05.webp', 'image/webp', 96052, 2400, 1582, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ตู้เสื้อผ้าบิลต์อิน', 'ตู้เสื้อผ้าบิลต์อินและพื้นที่แต่งตัว', 'https://media.kkpfg.com/npa/property/10024893/06.jpg', '/listing-media/propertysights/10024893/06.webp', 'image/webp', 66294, 2400, 1582, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนอีกมุม', 'พื้นที่เก็บของภายในห้องนอน', 'https://media.kkpfg.com/npa/property/10024893/07.jpg', '/listing-media/propertysights/10024893/07.webp', 'image/webp', 41946, 2400, 1582, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่อาบน้ำ', 'พื้นที่อาบน้ำแยกส่วนภายในห้องน้ำ', 'https://media.kkpfg.com/npa/property/10024893/08.jpg', '/listing-media/propertysights/10024893/08.webp', 'image/webp', 84496, 2400, 1582, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนที่สอง', 'ห้องนอนที่สองพร้อมหน้าต่างรับแสง', 'https://media.kkpfg.com/npa/property/10024893/09.jpg', '/listing-media/propertysights/10024893/09.webp', 'image/webp', 153150, 2400, 1582, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำ', 'ห้องน้ำพร้อมเคาน์เตอร์อ่างล้างหน้า', 'https://media.kkpfg.com/npa/property/10024893/10.jpg', '/listing-media/propertysights/10024893/10.webp', 'image/webp', 70840, 2400, 1582, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมทำงาน', 'โต๊ะทำงานและตู้เก็บของภายในห้องนอน', 'https://media.kkpfg.com/npa/property/10024893/11.jpg', '/listing-media/propertysights/10024893/11.webp', 'image/webp', 77450, 2400, 1582, 110, false, true);

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
        'https://kkppropify.kkpfg.com/th/products/10024893',
        '10024893',
        '2026-09-08 00:00:00+07',
        'Imported from the public KKPPropify asset page and cross-checked against the publisher listing page. PropertySights Real Estate is the verified listing publisher. Administrator-supplied coordinates override the source map coordinates. MapxProp stores optimized copies of the 11 supplied images without adding a MapxProp watermark.'
    );

    IF NOT EXISTS (
        SELECT 1
        FROM public.organization_verifications
        WHERE organization_id = propertysights_organization_id
          AND verification_type = 'listing_authority'
          AND status = 'verified'
          AND source_url = 'https://kkppropify.kkpfg.com/th/products/10024893'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            propertysights_organization_id,
            'listing_authority',
            'verified',
            'https://kkppropify.kkpfg.com/th/products/10024893',
            'The listing identifies PropertySights Real Estate as its verified property consultant; MapxProp administrator supplied and approved the listing contact.',
            admin_user_id,
            now()
        );
    END IF;

    INSERT INTO public.organization_audit_logs (
        organization_id, actor_user_id, action_code,
        entity_type, entity_public_id, metadata
    ) VALUES
        (
            propertysights_organization_id,
            admin_user_id,
            'organization.verified',
            'organization',
            '828de420-61e4-46ac-825a-9a1d2e51682a',
            jsonb_build_object('registration_no', '0105556180040')
        ),
        (
            propertysights_organization_id,
            admin_user_id,
            'listing.publisher_verified',
            'listing',
            '3eb2e9bb-da14-438b-a7e9-bfd9f4f6e065',
            jsonb_build_object('reference_code', '10024893')
        );
END $$;

COMMIT;
