BEGIN;

DO $$
DECLARE
    admin_user_id bigint;
    greatest_organization_id bigint;
    the_city_project_id bigint;
    property_listing_id bigint;
BEGIN
    SELECT id INTO admin_user_id
    FROM public.auth_users
    WHERE lower(email) = 'mapxprop@gmail.com'
      AND deleted_at IS NULL
    ORDER BY id
    LIMIT 1;

    IF admin_user_id IS NULL THEN
        RAISE EXCEPTION 'MapxProp super admin is required to import listing N0602911';
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
        'f637320d-3479-4d80-9d72-224ff9feba08',
        'greatest-property',
        'Greatest Property',
        'บริษัท เกรทเทสต์ พร๊อพเพอร์ตี้ จำกัด',
        'agency',
        '0105559168423',
        'https://greatestproperty.co.th/',
        'greatestproperty.co.th',
        'บริษัทตัวแทนและนายหน้าอสังหาริมทรัพย์ ให้บริการซื้อ ขาย เช่า และให้คำปรึกษาด้านอสังหาริมทรัพย์',
        'verified',
        'MapxProp administrator verified the active legal entity, official website and contacts, and the company''s authority for listing N0602911 against matching public property records.',
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
    RETURNING id INTO greatest_organization_id;

    INSERT INTO public.organization_specialties (organization_id, specialty_code)
    VALUES
        (greatest_organization_id, 'sale'),
        (greatest_organization_id, 'rent'),
        (greatest_organization_id, 'house')
    ON CONFLICT (organization_id, specialty_code) DO NOTHING;

    INSERT INTO public.organization_contacts (
        organization_id, channel_type, channel_value, label,
        is_primary, is_public, is_verified, verified_at
    ) VALUES
        (greatest_organization_id, 'phone', '022490156', 'สำนักงาน', true, true, true, now()),
        (greatest_organization_id, 'phone', '0863100409', 'สำนักงาน', false, true, true, now()),
        (greatest_organization_id, 'phone', '0823944659', 'คุณภัค', false, true, true, now()),
        (greatest_organization_id, 'line', '0823944659', 'LINE คุณภัค', false, true, true, now()),
        (greatest_organization_id, 'email', 'greatlyproperty@gmail.com', 'อีเมล', false, true, true, now()),
        (greatest_organization_id, 'website', 'https://greatestproperty.co.th/', 'เว็บไซต์', false, true, true, now())
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
        WHERE organization_id = greatest_organization_id
          AND verification_type = 'legal_entity'
          AND status = 'verified'
          AND source_url = 'https://www.dataforthai.com/company/0105559168423/'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            greatest_organization_id,
            'legal_entity',
            'verified',
            'https://www.dataforthai.com/company/0105559168423/',
            'The active Thai legal entity is บริษัท เกรทเทสต์ พร๊อพเพอร์ตี้ จำกัด (GREATEST PROPERTY COMPANY LIMITED), registration 0105559168423, operating as a real-estate agent and broker.',
            admin_user_id,
            now()
        );
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM public.organization_verifications
        WHERE organization_id = greatest_organization_id
          AND verification_type = 'contact'
          AND status = 'verified'
          AND source_url = 'https://greatestproperty.co.th/'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            greatest_organization_id,
            'contact',
            'verified',
            'https://greatestproperty.co.th/',
            'The official website publishes the company office contact channels. Matching property records identify คุณภัค, phone and LINE 082-394-4659, as the contact for N0602911.',
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
        '1abad4b0-63d0-41a6-9cad-3fef67bd7445',
        'the-city-ratchapruek-suanphak',
        'housing_estate',
        'เดอะ ซิตี้ ราชพฤกษ์-สวนผัก',
        'THE CITY Ratchapruek-Suanphak',
        'บริษัท เอพี (ไทยแลนด์) จำกัด (มหาชน)',
        'AP (Thailand) Public Company Limited',
        ARRAY['detached_house'],
        'โครงการบ้านเดี่ยวหรู 2 ชั้นจากเอพี บนถนนบางกรวย-จงถนอม ทำเลราชพฤกษ์-สวนผัก พร้อมคลับเฮาส์และพื้นที่ส่วนกลางสำหรับครอบครัว',
        'A two-storey luxury detached-house development by AP Thailand on Bang Kruai-Chong Thanom Road in the Ratchapruek-Suanphak area.',
        'เดอะ ซิตี้ ราชพฤกษ์-สวนผัก',
        'ถนนบางกรวย-จงถนอม',
        'มหาสวัสดิ์',
        'บางกรวย',
        'นนทบุรี',
        '11130',
        13.80177996,
        100.46640525,
        'https://www.apthai.com/th/single-detached-house/the-city-ratchapruek-suanpak',
        'source_checked',
        'Project name, developer, property type, project status and facilities were cross-checked against the official AP Thailand project page and public project records. Coordinates are an approximate project location based on the administrator-supplied listing position.',
        jsonb_build_object(
            'completion_year', 2021,
            'total_units', 133,
            'project_land_rai', 42,
            'project_land_ngan', 0,
            'project_land_square_wah', 38.2,
            'usable_area_min_sqm', 225,
            'usable_area_max_sqm', 375,
            'developer_brand', 'AP Thailand',
            'project_status', 'sold_out',
            'location_precision', 'approximate_project_location'
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
    RETURNING id INTO the_city_project_id;

    INSERT INTO public.property_project_aliases (
        project_id, locale, alias_name, alias_type
    ) VALUES
        (the_city_project_id, 'th', 'เดอะ ซิตี้ ราชพฤกษ์-สวนผัก', 'official'),
        (the_city_project_id, 'th', 'เดอะซิตี้ ราชพฤกษ์ สวนผัก', 'alternate'),
        (the_city_project_id, 'th', 'หมู่บ้านเดอะซิตี้ ราชพฤกษ์ สวนผัก', 'alternate'),
        (the_city_project_id, 'th', 'The City ราชพฤกษ์-สวนผัก', 'transliteration'),
        (the_city_project_id, 'en', 'THE CITY Ratchapruek-Suanphak', 'official'),
        (the_city_project_id, 'en', 'The City Ratchaphruek-Suanphak', 'alternate'),
        (the_city_project_id, 'en', 'The City Ratchapruek-Suanpak', 'alternate'),
        (the_city_project_id, 'en', 'The City Ratchaphruek - Suanphak', 'alternate')
    ON CONFLICT (project_id, locale, normalized_alias) DO NOTHING;

    INSERT INTO public.property_project_amenities (
        project_id, amenity_code, label_th, label_en, source_url
    ) VALUES
        (the_city_project_id, 'clubhouse', 'คลับเฮาส์', 'Clubhouse', 'https://www.apthai.com/th/single-detached-house/the-city-ratchapruek-suanpak'),
        (the_city_project_id, 'fitness', 'ฟิตเนส', 'Fitness centre', 'https://www.apthai.com/th/single-detached-house/the-city-ratchapruek-suanpak'),
        (the_city_project_id, 'swimming_pool', 'สระว่ายน้ำ', 'Swimming pool', 'https://www.apthai.com/th/single-detached-house/the-city-ratchapruek-suanpak'),
        (the_city_project_id, 'garden', 'สวนส่วนกลาง', 'Communal garden', 'https://www.apthai.com/th/single-detached-house/the-city-ratchapruek-suanpak'),
        (the_city_project_id, 'kids_room', 'ห้องเด็กเล่น', 'Kids room', 'https://www.apthai.com/th/single-detached-house/the-city-ratchapruek-suanpak'),
        (the_city_project_id, 'security', 'ระบบรักษาความปลอดภัย 24 ชม.', '24-hour security', 'https://www.apthai.com/th/single-detached-house/the-city-ratchapruek-suanpak')
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
        rent_price_monthly,
        price_negotiable,
        land_area_sqm,
        usable_area_sqm,
        bedroom_count,
        bathroom_count,
        parking_count,
        total_floors,
        furnishing_status,
        property_condition,
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
        moderation_submitted_at,
        moderated_at,
        is_verified,
        is_active,
        source_channel,
        price_unit,
        slug
    ) VALUES (
        'e15968c3-f5e6-476c-af3c-91fca0b40a59',
        admin_user_id,
        greatest_organization_id,
        admin_user_id,
        admin_user_id,
        the_city_project_id,
        'detached_house',
        'residence',
        'sale_and_rent',
        'whole_property',
        'เดอะ ซิตี้ ราชพฤกษ์-สวนผัก',
        'ขาย/เช่าบ้านเดี่ยว เดอะ ซิตี้ ราชพฤกษ์-สวนผัก 68.5 ตร.ว. 4 ห้องนอน',
        E'บ้านเดี่ยวหรู 2 ชั้น ในโครงการเดอะ ซิตี้ ราชพฤกษ์-สวนผัก เนื้อที่ 68.5 ตร.ว. พื้นที่ใช้สอย 309 ตร.ม. หันหน้าทิศใต้\n\n4 ห้องนอน 4 ห้องน้ำ 2 ห้องนั่งเล่น 1 ห้องแม่บ้าน 1 ห้องเก็บของ 3 ที่จอดรถ และเครื่องปรับอากาศ 6 เครื่อง ภายในโปร่ง ฝ้าสูง พร้อมเฟอร์นิเจอร์และบิลต์อิน มี Walk-in Closet ครัวบิลต์อิน และสวนข้างบ้าน\n\nส่วนกลางมีคลับเฮาส์ สระว่ายน้ำ ฟิตเนส ห้องเด็กเล่น สวน และระบบรักษาความปลอดภัย 24 ชม. เดินทางสะดวกสู่ราชพฤกษ์ ปิ่นเกล้า สิรินธร และทางด่วนศรีรัช-วงแหวนรอบนอก\n\nขาย 11,900,000 บาท หรือเช่า 65,000 บาท/เดือน\n\nติดต่อคุณภัค Greatest Property โทร/LINE 082-394-4659 รหัสทรัพย์ N0602911\n\nผู้ซื้อหรือผู้เช่าควรตรวจสอบสภาพทรัพย์ เอกสารสิทธิ์ ค่าใช้จ่าย และเงื่อนไขกับผู้ดูแลก่อนตัดสินใจ',
        11900000,
        65000,
        false,
        274,
        309,
        4,
        4,
        3,
        2,
        'fully_furnished',
        'ready_to_move_in',
        'คุณภัค',
        '0823944659',
        '0823944659',
        true,
        false,
        'โครงการเดอะ ซิตี้ ราชพฤกษ์-สวนผัก',
        'ทำเลราชพฤกษ์-สวนผัก',
        'ถนนบางกรวย-จงถนอม',
        '11130',
        13.80177996,
        100.46640525,
        'นนทบุรี',
        'บางกรวย',
        'มหาสวัสดิ์',
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
        'house-the-city-ratchapruek-suanphak-n0602911'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES
        (property_listing_id, 'sale', 11900000, 'total', 'THB', false),
        (property_listing_id, 'rent', 65000, 'month', 'THB', false)
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
            'land_area_square_wah', 68.5,
            'usable_area_sqm', 309,
            'storey_count', 2,
            'bedroom_count', 4,
            'bathroom_count', 4,
            'living_room_count', 2,
            'kitchen_count', 1,
            'maid_room_count', 1,
            'storage_room_count', 1,
            'air_conditioner_count', 6,
            'parking_count', 3,
            'facing_direction', 'south',
            'price_per_square_wah', 173723,
            'property_condition', 'ready_to_move_in'
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
        'บริษัท เกรทเทสต์ พร๊อพเพอร์ตี้ จำกัด',
        'authority_verified',
        'The exact KKPPropify record, matching agent advertisements and source-image branding consistently identify Greatest Property and contact คุณภัค for N0602911.',
        now(),
        admin_user_id,
        greatest_organization_id,
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
        (property_listing_id, 'air_conditioning'),
        (property_listing_id, 'clubhouse'),
        (property_listing_id, 'fitness'),
        (property_listing_id, 'garden'),
        (property_listing_id, 'parking'),
        (property_listing_id, 'playground'),
        (property_listing_id, 'security'),
        (property_listing_id, 'swimming_pool')
    ON CONFLICT (listing_id, amenity_code) DO NOTHING;

    INSERT INTO public.listing_nearby_places (
        listing_id, place_name_th, place_name_en, place_type_code,
        sort_order, is_highlight
    ) VALUES
        (property_listing_id, 'ทางพิเศษศรีรัช-วงแหวนรอบนอก', 'Si Rat-Outer Ring Road Expressway', 'road', 10, true),
        (property_listing_id, 'เดอะ คริสตัล เอสบี ราชพฤกษ์', 'The Crystal SB Ratchapruek', 'shopping', 20, true),
        (property_listing_id, 'เดอะวอล์ค ราชพฤกษ์', 'The Walk Ratchapruek', 'shopping', 30, true),
        (property_listing_id, 'โฮมโปร ราชพฤกษ์', 'HomePro Ratchapruek', 'shopping', 40, true),
        (property_listing_id, 'เซ็นทรัล ปิ่นเกล้า', 'Central Pinklao', 'shopping', 50, true),
        (property_listing_id, 'โรงพยาบาลบางกรวย', 'Bang Kruai Hospital', 'healthcare', 60, true),
        (property_listing_id, 'โรงเรียนเด่นหล้า พระราม 5', 'Denla Rama 5 School', 'education', 70, true)
    ON CONFLICT (listing_id, place_name_th) DO UPDATE SET
        place_name_en = EXCLUDED.place_name_en,
        place_type_code = EXCLUDED.place_type_code,
        sort_order = EXCLUDED.sort_order,
        is_highlight = EXCLUDED.is_highlight,
        updated_at = now();

    INSERT INTO public.listing_media (
        listing_id, media_type, source_type, role_code, title, alt_text,
        original_url, file_url, mime_type, file_size_bytes, width, height,
        sort_order, is_primary, is_active
    ) VALUES
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ด้านหน้าบ้าน', 'บ้านเดี่ยว 2 ชั้น เดอะ ซิตี้ ราชพฤกษ์-สวนผัก', 'https://media.kkpfg.com/npa/property/N0602911/001.jpg', '/listing-media/greatest-property/n0602911/001.webp', 'image/webp', 41950, 545, 307, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนั่งเล่นและรับประทานอาหาร', 'พื้นที่นั่งเล่นและมุมรับประทานอาหารภายในบ้าน', 'https://media.kkpfg.com/npa/property/N0602911/002.jpg', '/listing-media/greatest-property/n0602911/002.webp', 'image/webp', 20568, 578, 325, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมโทรทัศน์', 'ตู้บิลต์อินและมุมโทรทัศน์ในห้องนั่งเล่น', 'https://media.kkpfg.com/npa/property/N0602911/003.jpg', '/listing-media/greatest-property/n0602911/003.webp', 'image/webp', 16080, 578, 325, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนั่งเล่นรับแสงธรรมชาติ', 'ห้องนั่งเล่นพร้อมหน้าต่างบานใหญ่รับแสงธรรมชาติ', 'https://media.kkpfg.com/npa/property/N0602911/004.jpg', '/listing-media/greatest-property/n0602911/004.webp', 'image/webp', 21916, 578, 325, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมนั่งเล่น', 'มุมนั่งเล่นพร้อมโซฟาและหน้าต่าง', 'https://media.kkpfg.com/npa/property/N0602911/005.jpg', '/listing-media/greatest-property/n0602911/005.webp', 'image/webp', 23242, 578, 325, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่พักผ่อนชั้นล่าง', 'พื้นที่พักผ่อนและใช้งานอเนกประสงค์ชั้นล่าง', 'https://media.kkpfg.com/npa/property/N0602911/006.jpg', '/listing-media/greatest-property/n0602911/006.webp', 'image/webp', 19868, 578, 325, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงบันได', 'โถงบันไดเชื่อมพื้นที่นั่งเล่นภายในบ้าน', 'https://media.kkpfg.com/npa/property/N0602911/007.jpg', '/listing-media/greatest-property/n0602911/007.webp', 'image/webp', 21940, 578, 325, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บันไดและโคมไฟ', 'บันไดภายในบ้านพร้อมโคมไฟตกแต่ง', 'https://media.kkpfg.com/npa/property/N0602911/008.jpg', '/listing-media/greatest-property/n0602911/008.webp', 'image/webp', 14678, 578, 325, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอน', 'ห้องนอนพร้อมพื้นที่ทำงานและตู้เก็บของ', 'https://media.kkpfg.com/npa/property/N0602911/009.jpg', '/listing-media/greatest-property/n0602911/009.webp', 'image/webp', 22120, 578, 325, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำ', 'ห้องน้ำพร้อมพื้นที่อาบน้ำแยกส่วน', 'https://media.kkpfg.com/npa/property/N0602911/010.jpg', '/listing-media/greatest-property/n0602911/010.webp', 'image/webp', 18786, 578, 325, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนที่สอง', 'ห้องนอนพื้นไม้พร้อมหน้าต่างรับแสง', 'https://media.kkpfg.com/npa/property/N0602911/011.jpg', '/listing-media/greatest-property/n0602911/011.webp', 'image/webp', 15606, 578, 325, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำอีกมุม', 'เคาน์เตอร์อ่างล้างหน้าและพื้นที่อาบน้ำ', 'https://media.kkpfg.com/npa/property/N0602911/012.jpg', '/listing-media/greatest-property/n0602911/012.webp', 'image/webp', 18184, 578, 325, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนใหญ่', 'ห้องนอนใหญ่พร้อมพื้นที่พักผ่อนและหน้าต่างบานใหญ่', 'https://media.kkpfg.com/npa/property/N0602911/013.jpg', '/listing-media/greatest-property/n0602911/013.webp', 'image/webp', 17246, 578, 325, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'Walk-in Closet', 'พื้นที่แต่งตัวและตู้เสื้อผ้าแบบ Walk-in Closet', 'https://media.kkpfg.com/npa/property/N0602911/014.jpg', '/listing-media/greatest-property/n0602911/014.webp', 'image/webp', 18388, 578, 325, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำใหญ่', 'ห้องน้ำใหญ่พร้อมอ่างอาบน้ำและพื้นที่อาบน้ำแยกส่วน', 'https://media.kkpfg.com/npa/property/N0602911/015.jpg', '/listing-media/greatest-property/n0602911/015.webp', 'image/webp', 17734, 578, 325, 150, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องครัว', 'ครัวบิลต์อินพร้อมเคาน์เตอร์และพื้นที่เก็บของ', 'https://media.kkpfg.com/npa/property/N0602911/016.jpg', '/listing-media/greatest-property/n0602911/016.webp', 'image/webp', 25492, 578, 325, 160, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ซักล้าง', 'พื้นที่ซักล้างแยกภายในบ้าน', 'https://media.kkpfg.com/npa/property/N0602911/017.jpg', '/listing-media/greatest-property/n0602911/017.webp', 'image/webp', 15426, 578, 325, 170, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ที่จอดรถ', 'พื้นที่จอดรถในร่มบริเวณหน้าบ้าน', 'https://media.kkpfg.com/npa/property/N0602911/018.jpg', '/listing-media/greatest-property/n0602911/018.webp', 'image/webp', 34344, 578, 325, 180, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'สวนข้างบ้าน', 'ทางเดินและสวนข้างบ้านพร้อมหลังคาคลุม', 'https://media.kkpfg.com/npa/property/N0602911/019.jpg', '/listing-media/greatest-property/n0602911/019.webp', 'image/webp', 47514, 578, 325, 190, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเดินข้างบ้าน', 'เฉลียงและทางเดินข้างบ้านพร้อมพื้นที่สีเขียว', 'https://media.kkpfg.com/npa/property/N0602911/020.jpg', '/listing-media/greatest-property/n0602911/020.webp', 'image/webp', 51680, 578, 325, 200, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บ้านและถนนภายในโครงการ', 'ด้านหน้าบ้านและถนนภายในโครงการ', 'https://media.kkpfg.com/npa/property/N0602911/021.jpg', '/listing-media/greatest-property/n0602911/021.webp', 'image/webp', 45188, 578, 325, 210, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ฟิตเนส', 'ห้องออกกำลังกายภายในคลับเฮาส์', 'https://media.kkpfg.com/npa/property/N0602911/022.jpg', '/listing-media/greatest-property/n0602911/022.webp', 'image/webp', 22732, 578, 325, 220, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องเด็กเล่น', 'ห้องเด็กเล่นภายในพื้นที่ส่วนกลาง', 'https://media.kkpfg.com/npa/property/N0602911/023.jpg', '/listing-media/greatest-property/n0602911/023.webp', 'image/webp', 25256, 578, 325, 230, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'เลานจ์ส่วนกลาง', 'พื้นที่เลานจ์และนั่งพักผ่อนภายในคลับเฮาส์', 'https://media.kkpfg.com/npa/property/N0602911/024.jpg', '/listing-media/greatest-property/n0602911/024.webp', 'image/webp', 24808, 578, 325, 240, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'สระว่ายน้ำ', 'สระว่ายน้ำภายในโครงการเดอะ ซิตี้ ราชพฤกษ์-สวนผัก', 'https://media.kkpfg.com/npa/property/N0602911/025.jpg', '/listing-media/greatest-property/n0602911/025.webp', 'image/webp', 50970, 578, 325, 250, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'สวนส่วนกลาง', 'สนามหญ้าและสวนส่วนกลางภายในโครงการ', 'https://media.kkpfg.com/npa/property/N0602911/026.jpg', '/listing-media/greatest-property/n0602911/026.webp', 'image/webp', 51100, 578, 325, 260, false, true);

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
        'https://kkppropify.kkpfg.com/th/products/n0602911',
        'N0602911',
        '2026-09-08 00:00:00+07',
        'Imported from the public property record and cross-checked against matching Greatest Property advertisements and official project information. Greatest Property is the verified publisher and brokerage representative. Administrator-supplied coordinates override the older source-map coordinates. Both sale and monthly-rent offers are retained. MapxProp stores optimized copies of all 26 source images without adding a MapxProp watermark.'
    );

    IF NOT EXISTS (
        SELECT 1
        FROM public.organization_verifications
        WHERE organization_id = greatest_organization_id
          AND verification_type = 'listing_authority'
          AND status = 'verified'
          AND source_url = 'https://kkppropify.kkpfg.com/th/products/n0602911'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            greatest_organization_id,
            'listing_authority',
            'verified',
            'https://kkppropify.kkpfg.com/th/products/n0602911',
            'The exact property record, matching advertisements and source-image branding identify Greatest Property as the broker and คุณภัค as the contact for N0602911.',
            admin_user_id,
            now()
        );
    END IF;

    INSERT INTO public.organization_audit_logs (
        organization_id, actor_user_id, action_code,
        entity_type, entity_public_id, metadata
    ) VALUES
        (
            greatest_organization_id,
            admin_user_id,
            'organization.verified',
            'organization',
            'f637320d-3479-4d80-9d72-224ff9feba08',
            jsonb_build_object('verification_scope', 'legal_entity_contacts_and_publisher_identity')
        ),
        (
            greatest_organization_id,
            admin_user_id,
            'listing.publisher_verified',
            'listing',
            'e15968c3-f5e6-476c-af3c-91fca0b40a59',
            jsonb_build_object('reference_code', 'N0602911')
        );
END $$;

COMMIT;
