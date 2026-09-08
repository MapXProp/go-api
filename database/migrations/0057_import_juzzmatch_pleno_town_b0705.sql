BEGIN;

DO $$
DECLARE
    admin_user_id bigint;
    juzzmatch_organization_id bigint;
    pleno_project_id bigint;
    property_listing_id bigint;
BEGIN
    SELECT id INTO admin_user_id
    FROM public.auth_users
    WHERE lower(email) = 'mapxprop@gmail.com'
      AND deleted_at IS NULL
    ORDER BY id
    LIMIT 1;

    SELECT id INTO juzzmatch_organization_id
    FROM public.organizations
    WHERE slug = 'juzzmatch'
      AND is_active = true
      AND deleted_at IS NULL
    LIMIT 1;

    IF admin_user_id IS NULL THEN
        RAISE EXCEPTION 'MapxProp super admin is required to import listing B-0705';
    END IF;

    IF juzzmatch_organization_id IS NULL THEN
        RAISE EXCEPTION 'Verified Juzzmatch organization is required to import listing B-0705';
    END IF;

    UPDATE public.organizations
    SET verification_status = 'verified',
        verification_note = 'MapxProp administrator verified Juzzmatch as the publisher shown for listings B-0783 and B-0705.',
        verified_at = COALESCE(verified_at, now()),
        verified_by_user_id = admin_user_id,
        is_active = true,
        deleted_at = NULL,
        updated_at = now()
    WHERE id = juzzmatch_organization_id;

    INSERT INTO public.organization_specialties (organization_id, specialty_code)
    VALUES
        (juzzmatch_organization_id, 'sale'),
        (juzzmatch_organization_id, 'house')
    ON CONFLICT (organization_id, specialty_code) DO NOTHING;

    INSERT INTO public.organization_contacts (
        organization_id, channel_type, channel_value, label,
        is_primary, is_public, is_verified, verified_at
    ) VALUES (
        juzzmatch_organization_id,
        'phone',
        '024954506',
        'ติดต่อบริษัท',
        true,
        true,
        true,
        now()
    )
    ON CONFLICT (organization_id, channel_type, channel_value) DO UPDATE SET
        label = EXCLUDED.label,
        is_primary = true,
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
        official_website_url,
        source_url,
        verification_status,
        verification_note,
        metadata
    ) VALUES (
        '3a176fa3-36f0-4967-9b44-df9e9afc2f88',
        'pleno-town-pinklao-sai-5',
        'housing_estate',
        'พลีโน่ ทาวน์ ปิ่นเกล้า-สาย 5',
        'PLENO TOWN Pinklao-Sai 5',
        'บริษัท เอพี (ไทยแลนด์) จำกัด (มหาชน)',
        'AP (Thailand) Public Company Limited',
        ARRAY['townhouse', 'semi_detached_house'],
        'โครงการทาวน์โฮมและบ้านแฝด 2 ชั้น ในซอยวัดไร่ขิง 42 เชื่อมถนนพุทธมณฑลสาย 5 ใกล้ตลาดดอนหวายและเซ็นทรัล ศาลายา',
        'A two-storey townhome and semi-detached-house development in Wat Rai Khing Soi 42, connected to Phutthamonthon Sai 5 Road.',
        'ซอยวัดไร่ขิง 42',
        'ถนนพุทธมณฑลสาย 5',
        'ไร่ขิง',
        'สามพราน',
        'นครปฐม',
        '73210',
        13.75102407,
        100.29572752,
        'https://www.apthai.com/th/townhome/pleno-town-pinklao-sai5',
        'https://www.apthai.com/th/townhome/pleno-town-pinklao-sai5',
        'source_checked',
        'Project name, developer, address, development size, unit count, home types, usable areas, and facilities were verified against the official AP Thailand project page. Administrator-supplied coordinates identify this listing inside the project.',
        jsonb_build_object(
            'project_land_rai', 42,
            'project_land_ngan', 1,
            'project_land_square_wah', 73.5,
            'total_units', 452,
            'storey_count', 2,
            'usable_area_min_sqm', 93,
            'usable_area_max_sqm', 107,
            'parking_spaces', 2,
            'location_precision', 'listing_coordinate_used_as_project_reference'
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
        official_website_url = EXCLUDED.official_website_url,
        source_url = EXCLUDED.source_url,
        verification_status = EXCLUDED.verification_status,
        verification_note = EXCLUDED.verification_note,
        metadata = EXCLUDED.metadata,
        is_active = true,
        deleted_at = NULL,
        updated_at = now()
    RETURNING id INTO pleno_project_id;

    INSERT INTO public.property_project_aliases (
        project_id, locale, alias_name, alias_type
    ) VALUES
        (pleno_project_id, 'th', 'พลีโน่ ทาวน์ ปิ่นเกล้า-สาย 5', 'official'),
        (pleno_project_id, 'th', 'พลีโน่ ทาวน์ ปิ่นเกล้า - สาย 5', 'alternate'),
        (pleno_project_id, 'th', 'พลีโน่ ทาวน์ ปิ่นเกล้า พุทธมณฑล สาย 5', 'alternate'),
        (pleno_project_id, 'th', 'พลีโน่ ทาวน์ ปิ่นเกล้า พุทธมณฑลสาย 5', 'alternate'),
        (pleno_project_id, 'th', 'Pleno Town ปิ่นเกล้า-สาย 5', 'transliteration'),
        (pleno_project_id, 'en', 'PLENO TOWN Pinklao-Sai 5', 'official'),
        (pleno_project_id, 'en', 'Pleno Town Pinklao-Sai 5', 'alternate'),
        (pleno_project_id, 'en', 'PLENO TOWN Pinklao - Sai 5', 'alternate'),
        (pleno_project_id, 'en', 'Pleno Town Pinklao Phutthamonthon Sai 5', 'alternate')
    ON CONFLICT (project_id, locale, normalized_alias) DO NOTHING;

    INSERT INTO public.property_project_amenities (
        project_id, amenity_code, label_th, label_en, source_url
    ) VALUES
        (pleno_project_id, 'clubhouse', 'คลับเฮาส์', 'Clubhouse', 'https://www.apthai.com/th/townhome/pleno-town-pinklao-sai5'),
        (pleno_project_id, 'fitness', 'ฟิตเนส 24 ชั่วโมง', '24-hour fitness', 'https://www.apthai.com/th/townhome/pleno-town-pinklao-sai5'),
        (pleno_project_id, 'garden', 'สวนส่วนกลาง', 'Communal garden', 'https://www.apthai.com/th/townhome/pleno-town-pinklao-sai5'),
        (pleno_project_id, 'playground', 'สนามเด็กเล่น', 'Playground', 'https://www.apthai.com/th/townhome/pleno-town-pinklao-sai5'),
        (pleno_project_id, 'swimming_pool', 'สระว่ายน้ำ', 'Swimming pool', 'https://www.apthai.com/th/townhome/pleno-town-pinklao-sai5')
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
        custom_unit_number,
        title,
        description,
        sale_price,
        price_negotiable,
        land_area_sqm,
        bedroom_count,
        bathroom_count,
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
        'bcc2fce8-8e30-49c7-9a3c-f56b1dc8cfbc',
        admin_user_id,
        juzzmatch_organization_id,
        admin_user_id,
        admin_user_id,
        pleno_project_id,
        'townhouse',
        'residence',
        'sale',
        'whole_property',
        'พลีโน่ ทาวน์ ปิ่นเกล้า-สาย 5',
        '119/75',
        'ขายทาวน์โฮม 2 ชั้น พลีโน่ ทาวน์ ปิ่นเกล้า-สาย 5 18.1 ตร.ว. ราคา 2.755 ล้านบาท',
        E'ทาวน์โฮม 2 ชั้น บ้านเลขที่ 119/75 ในโครงการพลีโน่ ทาวน์ ปิ่นเกล้า-สาย 5 เนื้อที่ 18.1 ตร.ว.\n\n3 ห้องนอน 2 ห้องน้ำ บ้านว่าง ภายในโทนสว่าง เหมาะสำหรับครอบครัว เดินทางสะดวกผ่านถนนพุทธมณฑลสาย 5 และถนนเพชรเกษม\n\nใกล้ตลาดดอนหวาย เซ็นทรัล ศาลายา โรงพยาบาลวิชัยเวชฯ หนองแขม และมหาวิทยาลัยมหิดล\n\nราคาพิเศษ 2,755,000 บาท จากราคาเดิม 2,900,000 บาท\n\nติดต่อบริษัท จัซแมทช์ จำกัด โทร. 02-495-4506 รหัสทรัพย์ B-0705\n\nผู้ซื้อควรตรวจสอบสภาพทรัพย์ เอกสารสิทธิ์ ค่าใช้จ่าย และเงื่อนไขกับผู้ดูแลก่อนตัดสินใจ',
        2755000,
        false,
        72.4,
        3,
        2,
        'บริษัท จัซแมทช์ จำกัด',
        '024954506',
        true,
        false,
        '119/75 โครงการพลีโน่ ทาวน์ ปิ่นเกล้า-สาย 5',
        'ซอยวัดไร่ขิง 42',
        'ถนนพุทธมณฑลสาย 5',
        '73210',
        13.75102407,
        100.29572752,
        'นครปฐม',
        'สามพราน',
        'ไร่ขิง',
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
        'townhouse-pleno-town-pinklao-sai-5-b-0705'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 2755000, 'total', 'THB', false
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
        'townhouse',
        1,
        jsonb_build_object(
            'land_area_square_wah', 18.1,
            'storey_count', 2,
            'bedroom_count', 3,
            'bathroom_count', 2,
            'previous_price', 2900000,
            'price_per_square_wah', 152210,
            'property_condition', 'vacant_bright_interior'
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
        'บริษัท จัซแมทช์ จำกัด',
        'authority_verified',
        'The exact public property record identifies Juzzmatch Co., Ltd. as the verified sales representative for B-0705.',
        now(),
        admin_user_id,
        juzzmatch_organization_id,
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
        (property_listing_id, 'fitness'),
        (property_listing_id, 'garden'),
        (property_listing_id, 'parking'),
        (property_listing_id, 'pet_area'),
        (property_listing_id, 'playground'),
        (property_listing_id, 'swimming_pool')
    ON CONFLICT (listing_id, amenity_code) DO NOTHING;

    INSERT INTO public.listing_nearby_places (
        listing_id, place_name_th, place_name_en, place_type_code,
        distance_meters, sort_order, is_highlight
    ) VALUES
        (property_listing_id, 'ถนนพุทธมณฑลสาย 5', 'Phutthamonthon Sai 5 Road', 'road', 450, 10, true),
        (property_listing_id, 'ตลาดดอนหวาย', 'Don Wai Market', 'shopping', 3100, 20, true),
        (property_listing_id, 'ถนนเพชรเกษม', 'Phet Kasem Road', 'road', 5200, 30, true),
        (property_listing_id, 'โรงพยาบาลวิชัยเวช อินเตอร์เนชั่นแนล หนองแขม', 'Vichaivej International Hospital Nong Khaem', 'healthcare', 6200, 40, true),
        (property_listing_id, 'เซ็นทรัล ศาลายา', 'Central Salaya', 'shopping', 6400, 50, true),
        (property_listing_id, 'มหาวิทยาลัยมหิดล ศาลายา', 'Mahidol University Salaya', 'education', 10100, 60, true)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'โถงชั้นล่าง', 'โถงชั้นล่างทาวน์โฮม พลีโน่ ทาวน์ ปิ่นเกล้า-สาย 5', 'https://media.kkpfg.com/npa/property/B-0705/2.jpg', '/listing-media/juzzmatch/b-0705/01.webp', 'image/webp', 40954, 1600, 1200, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่นั่งเล่น', 'พื้นที่นั่งเล่นภายในทาวน์โฮม', 'https://media.kkpfg.com/npa/property/B-0705/3.jpg', '/listing-media/juzzmatch/b-0705/02.webp', 'image/webp', 31448, 1600, 1200, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมอเนกประสงค์', 'มุมอเนกประสงค์บริเวณชั้นล่างของบ้าน', 'https://media.kkpfg.com/npa/property/B-0705/4.jpg', '/listing-media/juzzmatch/b-0705/03.webp', 'image/webp', 34674, 1200, 1600, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอน', 'ห้องนอนภายในทาวน์โฮมพร้อมหน้าต่างรับแสง', 'https://media.kkpfg.com/npa/property/B-0705/5.jpg', '/listing-media/juzzmatch/b-0705/04.webp', 'image/webp', 52994, 1600, 1200, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงและห้องน้ำ', 'โถงชั้นล่างและห้องน้ำภายในบ้าน', 'https://media.kkpfg.com/npa/property/B-0705/6.jpg', '/listing-media/juzzmatch/b-0705/05.webp', 'image/webp', 26228, 1600, 1200, 50, false, true);

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
        'https://kkppropify.kkpfg.com/th/products/b-0705',
        'B-0705',
        '2026-09-08 00:00:00+07',
        'Imported from the public property record. The page identifies Juzzmatch Co., Ltd. as the verified publisher and gives a current price of 2.755 million baht, reduced from 2.9 million baht. Administrator-supplied coordinates and the official AP Thailand project address override inconsistent source province labels. MapxProp stores optimized copies of all five available property images without adding a watermark.'
    );

    IF NOT EXISTS (
        SELECT 1
        FROM public.organization_verifications
        WHERE organization_id = juzzmatch_organization_id
          AND verification_type = 'listing_authority'
          AND status = 'verified'
          AND source_url = 'https://kkppropify.kkpfg.com/th/products/b-0705'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            juzzmatch_organization_id,
            'listing_authority',
            'verified',
            'https://kkppropify.kkpfg.com/th/products/b-0705',
            'The exact property record identifies Juzzmatch Co., Ltd. as the verified sales representative for listing B-0705.',
            admin_user_id,
            now()
        );
    END IF;

    INSERT INTO public.organization_audit_logs (
        organization_id, actor_user_id, action_code,
        entity_type, entity_public_id, metadata
    ) VALUES (
        juzzmatch_organization_id,
        admin_user_id,
        'listing.publisher_verified',
        'listing',
        'bcc2fce8-8e30-49c7-9a3c-f56b1dc8cfbc',
        jsonb_build_object('reference_code', 'B-0705')
    );
END $$;

COMMIT;
