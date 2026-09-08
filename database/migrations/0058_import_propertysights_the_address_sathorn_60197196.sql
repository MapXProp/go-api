BEGIN;

DO $$
DECLARE
    admin_user_id bigint;
    propertysights_organization_id bigint;
    address_sathorn_project_id bigint;
    property_listing_id bigint;
BEGIN
    SELECT id INTO admin_user_id
    FROM public.auth_users
    WHERE lower(email) = 'mapxprop@gmail.com'
      AND deleted_at IS NULL
    ORDER BY id
    LIMIT 1;

    IF admin_user_id IS NULL THEN
        RAISE EXCEPTION 'MapxProp super admin is required to import listing 60197196';
    END IF;

    SELECT id INTO propertysights_organization_id
    FROM public.organizations
    WHERE slug = 'propertysights-real-estate'
      AND deleted_at IS NULL
    ORDER BY id
    LIMIT 1;

    IF propertysights_organization_id IS NULL THEN
        RAISE EXCEPTION 'Verified PropertySights Real Estate organization is required to import listing 60197196';
    END IF;

    UPDATE public.organizations
    SET verification_status = 'verified',
        verification_note = 'MapxProp administrator verified PropertySights Real Estate and its listing authority for properties 10024893 and 60197196.',
        verified_at = COALESCE(verified_at, now()),
        verified_by_user_id = admin_user_id,
        is_active = true,
        deleted_at = NULL,
        updated_at = now()
    WHERE id = propertysights_organization_id;

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
        '17736f55-f29a-4a58-8eb6-72b363b2641c',
        'the-address-sathorn',
        'condominium',
        'ดิ แอดเดรส สาทร',
        'The Address Sathorn',
        'บริษัท เอพี (ไทยแลนด์) จำกัด (มหาชน)',
        'AP (Thailand) Public Company Limited',
        ARRAY['condo'],
        'โครงการคอนโดมิเนียมไฮไรส์ในซอยสาทร 12 แขวงสีลม เขตบางรัก ใกล้ BTS เซนต์หลุยส์',
        'A high-rise condominium development on Sathorn Soi 12 in Si Lom, Bang Rak, near BTS Saint Louis.',
        '98 ซอยสาทร 12',
        'ถนนสาทรเหนือ',
        'สีลม',
        'บางรัก',
        'กรุงเทพมหานคร',
        '10500',
        13.72262800,
        100.52517653,
        'https://propertysights.com/th/projects/the-address-sathorn',
        'source_checked',
        'Project identity, developer, address, completion year, building details, and facilities were cross-checked against public project records and AP Thailand disclosures. Administrator-supplied coordinates are authoritative for MapxProp.',
        jsonb_build_object(
            'completion_year', 2012,
            'building_count', 1,
            'total_floors', 40,
            'total_units', 562,
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
    RETURNING id INTO address_sathorn_project_id;

    INSERT INTO public.property_project_aliases (
        project_id, locale, alias_name, alias_type
    ) VALUES
        (address_sathorn_project_id, 'th', 'ดิ แอดเดรส สาทร', 'official'),
        (address_sathorn_project_id, 'th', 'เดอะ แอดเดรส สาทร', 'alternate'),
        (address_sathorn_project_id, 'th', 'ดิ แอดเดรส สาทร 12', 'alternate'),
        (address_sathorn_project_id, 'th', 'เดอะ แอดเดรส สาทร 12', 'alternate'),
        (address_sathorn_project_id, 'en', 'The Address Sathorn', 'official'),
        (address_sathorn_project_id, 'en', 'The Address Sathorn 12', 'alternate'),
        (address_sathorn_project_id, 'en', 'The Address Sathon', 'transliteration'),
        (address_sathorn_project_id, 'en', 'The Address Sathon 12', 'transliteration')
    ON CONFLICT (project_id, locale, normalized_alias) DO NOTHING;

    INSERT INTO public.property_project_amenities (
        project_id, amenity_code, label_th, label_en, source_url
    ) VALUES
        (address_sathorn_project_id, 'elevator', 'ลิฟต์', 'Elevator', 'https://propertysights.com/th/projects/the-address-sathorn'),
        (address_sathorn_project_id, 'fitness', 'ฟิตเนส', 'Fitness', 'https://propertysights.com/th/projects/the-address-sathorn'),
        (address_sathorn_project_id, 'garden', 'สวนส่วนกลาง', 'Communal garden', 'https://propertysights.com/th/projects/the-address-sathorn'),
        (address_sathorn_project_id, 'parking', 'ที่จอดรถ', 'Parking', 'https://propertysights.com/th/projects/the-address-sathorn'),
        (address_sathorn_project_id, 'sauna', 'ซาวน่า', 'Sauna', 'https://propertysights.com/th/projects/the-address-sathorn'),
        (address_sathorn_project_id, 'security', 'ระบบรักษาความปลอดภัย 24 ชม.', '24-hour security', 'https://propertysights.com/th/projects/the-address-sathorn'),
        (address_sathorn_project_id, 'swimming_pool', 'สระว่ายน้ำ', 'Swimming pool', 'https://propertysights.com/th/projects/the-address-sathorn')
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
        furnishing_status,
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
        '174d3d3c-6bae-4083-a8f8-eb363932912b',
        admin_user_id,
        propertysights_organization_id,
        admin_user_id,
        admin_user_id,
        address_sathorn_project_id,
        'condo',
        'residence',
        'sale',
        'single_unit',
        'ดิ แอดเดรส สาทร',
        'ขายคอนโด The Address Sathorn ชั้นสูง 1 ห้องนอน 55.28 ตร.ม. ราคา 13.5 ล้านบาท',
        E'คอนโดชั้นสูง The Address Sathorn ขนาด 55.28 ตร.ม. 1 ห้องนอน 1 ห้องน้ำ พร้อมเฟอร์นิเจอร์และวิวเมือง\n\nพื้นที่นั่งเล่นโปร่งรับแสง เชื่อมต่อครัวบิลต์อินและระเบียง ห้องนอนมีตู้เสื้อผ้าบิลต์อิน ห้องน้ำมีอ่างอาบน้ำและพื้นที่อาบน้ำแยกส่วน\n\nทำเลซอยสาทร 12 ใกล้ BTS เซนต์หลุยส์ประมาณ 200 เมตร เดินทางสะดวกสู่ย่านสาทร–สีลม\n\nราคาขาย 13,500,000 บาท\n\nติดต่อ PropertySights Real Estate โทร. 095-517-9606 รหัสทรัพย์ 60197196\n\nผู้ซื้อควรตรวจสอบสภาพทรัพย์ เอกสารสิทธิ์ ค่าใช้จ่าย และเงื่อนไขกับผู้ดูแลก่อนตัดสินใจ',
        13500000,
        false,
        55.28,
        1,
        1,
        'fully_furnished',
        40,
        'PropertySights Real Estate',
        '0955179606',
        'hello@propertysights.com',
        'propertysights88',
        true,
        true,
        '98 ซอยสาทร 12',
        'โครงการดิ แอดเดรส สาทร',
        'ถนนสาทรเหนือ',
        '10500',
        13.72262800,
        100.52517653,
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
        'condo-the-address-sathorn-60197196'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 13500000, 'total', 'THB', false
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
        'condo',
        1,
        jsonb_build_object(
            'unit_area_sqm', 55.28,
            'bedroom_count', 1,
            'bathroom_count', 1,
            'price_per_sqm', 244211,
            'project_completion_year', 2012,
            'project_total_floors', 40,
            'project_total_units', 562,
            'tenure', 'freehold',
            'floor_position', 'high_floor',
            'furnishing_status', 'fully_furnished'
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
        verified_by_user_id,
        organization_id,
        contact_user_id
    ) VALUES (
        property_listing_id,
        'agency_broker',
        'brokerage_company',
        'PropertySights Real Estate',
        'authority_verified',
        'The public property record identifies PropertySights Real Estate as the verified representative for listing 60197196.',
        now(),
        admin_user_id,
        propertysights_organization_id,
        NULL
    )
    ON CONFLICT (listing_id) DO UPDATE SET
        role_code = EXCLUDED.role_code,
        authority_source_code = EXCLUDED.authority_source_code,
        organization_name = EXCLUDED.organization_name,
        verification_status = EXCLUDED.verification_status,
        verification_note = EXCLUDED.verification_note,
        verified_at = EXCLUDED.verified_at,
        verified_by_user_id = EXCLUDED.verified_by_user_id,
        organization_id = EXCLUDED.organization_id,
        contact_user_id = EXCLUDED.contact_user_id,
        updated_at = now();

    INSERT INTO public.listing_amenities (listing_id, amenity_code)
    VALUES
        (property_listing_id, 'elevator'),
        (property_listing_id, 'fitness'),
        (property_listing_id, 'garden'),
        (property_listing_id, 'parking'),
        (property_listing_id, 'sauna'),
        (property_listing_id, 'security'),
        (property_listing_id, 'swimming_pool')
    ON CONFLICT (listing_id, amenity_code) DO NOTHING;

    INSERT INTO public.listing_nearby_places (
        listing_id, place_name_th, place_name_en, place_type_code,
        distance_meters, sort_order, is_highlight
    ) VALUES
        (property_listing_id, 'BTS เซนต์หลุยส์', 'BTS Saint Louis', 'transit', 200, 10, true),
        (property_listing_id, 'ย่านธุรกิจสาทร–สีลม', 'Sathorn–Silom CBD', 'landmark', 300, 20, true)
    ON CONFLICT (listing_id, place_name_th) DO UPDATE SET
        place_name_en = EXCLUDED.place_name_en,
        place_type_code = EXCLUDED.place_type_code,
        distance_meters = EXCLUDED.distance_meters,
        sort_order = EXCLUDED.sort_order,
        is_highlight = EXCLUDED.is_highlight,
        updated_at = now();

    INSERT INTO public.listing_media (
        listing_id, media_type, source_type, role_code, title, alt_text,
        original_url, file_url, mime_type, file_size_bytes, width, height,
        sort_order, is_primary, is_active
    ) VALUES
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ห้องนั่งเล่นและวิวเมือง', 'ห้องนั่งเล่นคอนโด The Address Sathorn พร้อมวิวเมือง', 'https://media.kkpfg.com/npa/property/60197196/01.jpg', '/listing-media/propertysights/60197196/01.webp', 'image/webp', 33306, 910, 600, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่นั่งเล่นและครัว', 'พื้นที่นั่งเล่นเชื่อมต่อครัวและระเบียง', 'https://media.kkpfg.com/npa/property/60197196/02.jpg', '/listing-media/propertysights/60197196/02.webp', 'image/webp', 36076, 910, 600, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ตู้บิลต์อินและมุมทีวี', 'ตู้เก็บของบิลต์อินและมุมทีวีภายในห้อง', 'https://media.kkpfg.com/npa/property/60197196/03.jpg', '/listing-media/propertysights/60197196/03.webp', 'image/webp', 32878, 910, 600, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ครัวพร้อมไอส์แลนด์', 'ครัวบิลต์อินพร้อมไอส์แลนด์และโต๊ะรับประทานอาหาร', 'https://media.kkpfg.com/npa/property/60197196/04.jpg', '/listing-media/propertysights/60197196/04.webp', 'image/webp', 31168, 910, 600, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนและห้องน้ำ', 'ห้องนอนพร้อมวิวเมืองและห้องน้ำกระจก', 'https://media.kkpfg.com/npa/property/60197196/05.jpg', '/listing-media/propertysights/60197196/05.webp', 'image/webp', 36766, 910, 600, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำพร้อมอ่างอาบน้ำ', 'ห้องน้ำพร้อมอ่างอาบน้ำและพื้นที่อาบน้ำแยกส่วน', 'https://media.kkpfg.com/npa/property/60197196/06.jpg', '/listing-media/propertysights/60197196/06.webp', 'image/webp', 43300, 910, 600, 60, false, true);

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
        'https://kkppropify.kkpfg.com/th/products/60197196',
        '60197196',
        '2026-09-08 00:00:00+07',
        'Imported from the public KKPPropify property record and cross-checked against the verified publisher listing. PropertySights Real Estate is the listing representative. Administrator-supplied coordinates are authoritative. MapxProp stores optimized copies of all six images available on the KKP property page and does not add an additional watermark.'
    );

    IF NOT EXISTS (
        SELECT 1
        FROM public.organization_verifications
        WHERE organization_id = propertysights_organization_id
          AND verification_type = 'listing_authority'
          AND status = 'verified'
          AND source_url = 'https://kkppropify.kkpfg.com/th/products/60197196'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            propertysights_organization_id,
            'listing_authority',
            'verified',
            'https://kkppropify.kkpfg.com/th/products/60197196',
            'The public property record identifies PropertySights Real Estate as the verified representative for listing 60197196.',
            admin_user_id,
            now()
        );
    END IF;

    INSERT INTO public.organization_audit_logs (
        organization_id, actor_user_id, action_code,
        entity_type, entity_public_id, metadata
    ) VALUES (
        propertysights_organization_id,
        admin_user_id,
        'listing.publisher_verified',
        'listing',
        '174d3d3c-6bae-4083-a8f8-eb363932912b',
        jsonb_build_object('reference_code', '60197196')
    );
END $$;

COMMIT;
