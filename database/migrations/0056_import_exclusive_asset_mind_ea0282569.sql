BEGIN;

DO $$
DECLARE
    admin_user_id bigint;
    exclusive_asset_organization_id bigint;
    mind_project_id bigint;
    property_listing_id bigint;
BEGIN
    SELECT id INTO admin_user_id
    FROM public.auth_users
    WHERE lower(email) = 'mapxprop@gmail.com'
      AND deleted_at IS NULL
    ORDER BY id
    LIMIT 1;

    IF admin_user_id IS NULL THEN
        RAISE EXCEPTION 'MapxProp super admin is required to import listing EA0282569';
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
        '66c8ca9f-d0b9-414d-a2ae-5b70e33684a0',
        'exclusive-asset',
        'Exclusive Asset',
        'บริษัท เอ็กซ์คลูซีฟ แอสเสท จำกัด',
        'agency',
        '0105565095319',
        'https://www.exclusive-asset.com/',
        'exclusive-asset.com',
        'บริษัทตัวแทนและที่ปรึกษาด้านอสังหาริมทรัพย์ ดูแลทรัพย์เพื่อขายในกรุงเทพฯ และนนทบุรี โดยเฉพาะบ้านและอสังหาริมทรัพย์ระดับพรีเมียม',
        'verified',
        'Company identity, registration, official contact channels, and authority for listing EA0282569 were cross-checked against public company and exact listing records.',
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
    RETURNING id INTO exclusive_asset_organization_id;

    INSERT INTO public.organization_specialties (organization_id, specialty_code)
    VALUES
        (exclusive_asset_organization_id, 'sale'),
        (exclusive_asset_organization_id, 'house'),
        (exclusive_asset_organization_id, 'investment')
    ON CONFLICT (organization_id, specialty_code) DO NOTHING;

    INSERT INTO public.organization_contacts (
        organization_id, channel_type, channel_value, label,
        is_primary, is_public, is_verified, verified_at
    ) VALUES
        (exclusive_asset_organization_id, 'phone', '0829566564', 'คุณนุ่น ยลศิริ', true, true, true, now()),
        (exclusive_asset_organization_id, 'phone', '0646456987', 'สำนักงานใหญ่', false, true, true, now()),
        (exclusive_asset_organization_id, 'line', '@exclusiveasset', 'LINE องค์กร', false, true, true, now()),
        (exclusive_asset_organization_id, 'email', 'nathakhom@hotmail.com', 'อีเมล', false, true, true, now()),
        (exclusive_asset_organization_id, 'website', 'https://www.exclusive-asset.com/', 'เว็บไซต์', false, true, true, now())
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
        WHERE organization_id = exclusive_asset_organization_id
          AND verification_type = 'legal_entity'
          AND status = 'verified'
          AND source_url = 'https://www.dataforthai.com/company/0105565095319/'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            exclusive_asset_organization_id,
            'legal_entity',
            'verified',
            'https://www.dataforthai.com/company/0105565095319/',
            'Public company records identify บริษัท เอ็กซ์คลูซีฟ แอสเสท จำกัด, registration 0105565095319; the official company website and contacts match the listing publisher.',
            admin_user_id,
            now()
        );
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM public.organization_verifications
        WHERE organization_id = exclusive_asset_organization_id
          AND verification_type = 'contact'
          AND status = 'verified'
          AND source_url = 'https://www.exclusive-asset.com/contact'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            exclusive_asset_organization_id,
            'contact',
            'verified',
            'https://www.exclusive-asset.com/contact',
            'The official contact page publishes the organization address and contact channels; the exact property page identifies คุณนุ่น ยลศิริ as the listing contact.',
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
        '5a946131-532a-4ea9-94eb-cab3fc197aee',
        'mind-pinklao-charan',
        'housing_estate',
        'มายด์ ปิ่นเกล้า-จรัญ',
        'MIND Pinklao-Charan',
        'บริษัท เอพี (ไทยแลนด์) จำกัด (มหาชน)',
        'AP (Thailand) Public Company Limited',
        ARRAY['detached_house'],
        'โครงการบ้านเดี่ยว 2–3 ชั้น บนถนนบางกรวย-ไทรน้อย ใกล้ทางด่วนศรีรัช–วงแหวนรอบนอก',
        'A 2–3 storey detached-house development on Bang Kruai–Sai Noi Road, near the Si Rat–Outer Ring Road Expressway.',
        'ซอยบางกรวย-ไทรน้อย 17',
        'ถนนบางกรวย-ไทรน้อย',
        'บางสีทอง',
        'บางกรวย',
        'นนทบุรี',
        '11130',
        13.80800000,
        100.48570000,
        'https://www.home.co.th/home/mind-pinklao-charan-8319',
        'source_checked',
        'Project identity, developer, address, development scale, home types, and facilities were cross-checked against public project records. Listing coordinates remain property-specific.',
        jsonb_build_object(
            'completion_year', 2017,
            'total_units', 90,
            'project_land_rai', 22,
            'project_land_ngan', 2,
            'project_land_square_wah', 24,
            'minimum_land_square_wah', 54,
            'usable_area_min_sqm', 220,
            'usable_area_max_sqm', 250,
            'tenure', 'freehold',
            'location_precision', 'approximate_project_center'
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
    RETURNING id INTO mind_project_id;

    INSERT INTO public.property_project_aliases (
        project_id, locale, alias_name, alias_type
    ) VALUES
        (mind_project_id, 'th', 'มายด์ ปิ่นเกล้า-จรัญ', 'official'),
        (mind_project_id, 'th', 'มายด์ ปิ่นเกล้า-จรัญฯ', 'alternate'),
        (mind_project_id, 'th', 'Mind ปิ่นเกล้า-จรัญ', 'alternate'),
        (mind_project_id, 'th', 'Mind ปิ่นเกล้า-จรัญฯ', 'alternate'),
        (mind_project_id, 'en', 'MIND Pinklao-Charan', 'official'),
        (mind_project_id, 'en', 'Mind Pinklao-Charan', 'alternate'),
        (mind_project_id, 'en', 'MIND Pinklao-Charansanitwong', 'alternate')
    ON CONFLICT (project_id, locale, normalized_alias) DO NOTHING;

    INSERT INTO public.property_project_amenities (
        project_id, amenity_code, label_th, label_en, source_url
    ) VALUES
        (mind_project_id, 'clubhouse', 'คลับเฮาส์', 'Clubhouse', 'https://www.home.co.th/home/mind-pinklao-charan-8319'),
        (mind_project_id, 'fitness', 'ฟิตเนส', 'Fitness', 'https://www.home.co.th/home/mind-pinklao-charan-8319'),
        (mind_project_id, 'garden', 'สวนส่วนกลาง', 'Communal garden', 'https://www.home.co.th/home/mind-pinklao-charan-8319'),
        (mind_project_id, 'security', 'ระบบรักษาความปลอดภัย 24 ชม.', '24-hour security', 'https://www.home.co.th/home/mind-pinklao-charan-8319'),
        (mind_project_id, 'swimming_pool', 'สระว่ายน้ำ', 'Swimming pool', 'https://www.home.co.th/home/mind-pinklao-charan-8319')
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
        land_area_sqm,
        usable_area_sqm,
        bedroom_count,
        bathroom_count,
        parking_count,
        total_floors,
        contact_name,
        contact_phone,
        contact_phone_secondary,
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
        'ea4ebe42-ff25-4195-bae5-2c3aface9055',
        admin_user_id,
        exclusive_asset_organization_id,
        admin_user_id,
        admin_user_id,
        mind_project_id,
        'detached_house',
        'residence',
        'sale',
        'whole_property',
        'มายด์ ปิ่นเกล้า-จรัญ',
        'ขายบ้านเดี่ยว 3 ชั้น MIND ปิ่นเกล้า-จรัญ 64 ตร.ว. ราคา 8.3 ล้านบาท',
        E'บ้านเดี่ยว 3 ชั้น แปลงริม หลังสุดซอย โครงการ MIND ปิ่นเกล้า-จรัญ เนื้อที่ 64 ตร.ว. พื้นที่ใช้สอย 250 ตร.ม.\n\n5 ห้องนอน 5 ห้องน้ำ จอดรถในร่มได้ 3 คัน หน้าบ้านหันทิศเหนือ มีครัวหลังบ้านและพื้นที่อเนกประสงค์ต่อเติมขนาดประมาณ 2.5 x 10 เมตร ลงเสาเข็มไมโครไพล์ เหมาะอยู่อาศัย ทำโฮมออฟฟิศ หรือสตูดิโอไลฟ์สด\n\nใกล้ทางด่วนศรีรัช–วงแหวนรอบนอก และเซ็นทรัล ปิ่นเกล้า\n\nปรับราคาจาก 8,500,000 บาท เหลือ 8,300,000 บาท\n\nติดต่อ Exclusive Asset คุณนุ่น ยลศิริ โทร. 082-956-6564 LINE: yolsiri\n\nผู้ซื้อควรตรวจสอบสภาพทรัพย์ เอกสารสิทธิ์ ค่าใช้จ่าย และเงื่อนไขกับผู้ดูแลก่อนตัดสินใจ',
        8300000,
        false,
        256,
        250,
        5,
        5,
        3,
        3,
        'Exclusive Asset — คุณนุ่น ยลศิริ',
        '0829566564',
        '0646456987',
        'yolsiri',
        true,
        false,
        'โครงการมายด์ ปิ่นเกล้า-จรัญ',
        'ซอยบางกรวย-ไทรน้อย 17',
        'ถนนบางกรวย-ไทรน้อย',
        '11130',
        13.80807342,
        100.48569271,
        'นนทบุรี',
        'บางกรวย',
        'บางสีทอง',
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
        'house-mind-pinklao-charan-ea0282569'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES
        (property_listing_id, 'residential'),
        (property_listing_id, 'office')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 8300000, 'total', 'THB', false
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
            'land_area_square_wah', 64,
            'usable_area_sqm', 250,
            'storey_count', 3,
            'bedroom_count', 5,
            'bathroom_count', 5,
            'covered_parking_count', 3,
            'facing_direction', 'north',
            'house_position', 'edge_plot_end_of_soi',
            'rear_kitchen', true,
            'extension_width_m', 2.5,
            'extension_length_m', 10,
            'extension_foundation', 'micropile',
            'furnishing_status', 'unfurnished',
            'previous_price', 8500000,
            'price_per_square_wah', 129688,
            'suitable_for', jsonb_build_array('residence', 'home_office', 'studio')
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
        'Exclusive Asset',
        'authority_verified',
        'The exact public property page and KKPPropify record identify Exclusive Asset as the verified sales representative for EA0282569.',
        now(),
        admin_user_id,
        exclusive_asset_organization_id,
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
        (property_listing_id, 'security'),
        (property_listing_id, 'swimming_pool')
    ON CONFLICT (listing_id, amenity_code) DO NOTHING;

    INSERT INTO public.listing_nearby_places (
        listing_id, place_name_th, place_name_en, place_type_code,
        sort_order, is_highlight
    ) VALUES
        (property_listing_id, 'ทางด่วนศรีรัช–วงแหวนรอบนอก', 'Si Rat–Outer Ring Road Expressway', 'road', 10, true),
        (property_listing_id, 'เซ็นทรัล ปิ่นเกล้า', 'Central Pinklao', 'shopping', 20, true),
        (property_listing_id, 'MRT บางอ้อ', 'MRT Bang O', 'transit', 30, true),
        (property_listing_id, 'โรงพยาบาลยันฮี', 'Yanhee Hospital', 'healthcare', 40, true)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'หน้าบ้าน', 'บ้านเดี่ยว 3 ชั้น MIND ปิ่นเกล้า-จรัญ แปลงริม', 'https://www.exclusive-asset.com/upload/own_23/post_list/69ce0a566dcef_admin_89566.png', '/listing-media/exclusive-asset/ea0282569/001.webp', 'image/webp', 97578, 1200, 896, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'หน้าบ้านและถนน', 'บ้านแปลงริมและถนนภายในโครงการ MIND ปิ่นเกล้า-จรัญ', 'https://www.exclusive-asset.com/upload/own_23/post_list/69ce0a56ce12c_admin_91620.jpeg', '/listing-media/exclusive-asset/ea0282569/002.webp', 'image/webp', 133362, 1200, 677, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ลานจอดรถ', 'พื้นที่จอดรถในร่มและส่วนต่อเติมข้างบ้าน', 'https://www.exclusive-asset.com/upload/own_23/post_list/69ce0a5729444_admin_91013.jpeg', '/listing-media/exclusive-asset/ea0282569/003.webp', 'image/webp', 174754, 1200, 676, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ข้างบ้าน', 'พื้นที่ต่อเติมขนาดใหญ่ข้างบ้าน', 'https://www.exclusive-asset.com/upload/own_23/post_list/69ce0a5791e89_admin_96672.jpeg', '/listing-media/exclusive-asset/ea0282569/004.webp', 'image/webp', 117572, 1200, 677, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่อเนกประสงค์', 'พื้นที่อเนกประสงค์ต่อเติมเหมาะทำโฮมออฟฟิศหรือสตูดิโอ', 'https://www.exclusive-asset.com/upload/own_23/post_list/69ce0a5828059_admin_67717.jpeg', '/listing-media/exclusive-asset/ea0282569/005.webp', 'image/webp', 230456, 1200, 774, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ที่จอดรถในร่ม', 'พื้นที่จอดรถในร่มบริเวณข้างบ้าน', 'https://www.exclusive-asset.com/upload/own_23/post_list/69ce0a586d5d0_admin_97295.jpeg', '/listing-media/exclusive-asset/ea0282569/006.webp', 'image/webp', 58794, 1200, 677, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้าบ้าน', 'ทางเข้าบ้านเชื่อมพื้นที่จอดรถ', 'https://www.exclusive-asset.com/upload/own_23/post_list/69ce0a58da2a1_admin_35964.jpeg', '/listing-media/exclusive-asset/ea0282569/007.webp', 'image/webp', 65606, 1200, 677, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนั่งเล่น', 'ห้องนั่งเล่นภายในบ้านชั้นล่าง', 'https://www.exclusive-asset.com/upload/own_23/post_list/69ce0a593eb17_admin_57234.jpeg', '/listing-media/exclusive-asset/ea0282569/008.webp', 'image/webp', 38250, 1200, 677, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่รับแขก', 'พื้นที่รับแขกแบบเปิดโล่งภายในบ้าน', 'https://www.exclusive-asset.com/upload/own_23/post_list/69ce0a59a4621_admin_50406.jpeg', '/listing-media/exclusive-asset/ea0282569/009.webp', 'image/webp', 44214, 1200, 699, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงชั้นล่าง', 'โถงชั้นล่างและทางเดินภายในบ้าน', 'https://www.exclusive-asset.com/upload/own_23/post_list/69ce0a5a209c2_admin_34455.jpeg', '/listing-media/exclusive-asset/ea0282569/010.webp', 'image/webp', 59022, 1200, 688, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ภายใน', 'พื้นที่ใช้งานภายในบ้านชั้นล่าง', 'https://www.exclusive-asset.com/upload/own_23/post_list/69ce0a5a83172_admin_50355.jpeg', '/listing-media/exclusive-asset/ea0282569/011.webp', 'image/webp', 50774, 1200, 677, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ครัวหลังบ้าน', 'พื้นที่ครัวบริเวณหลังบ้าน', 'https://www.exclusive-asset.com/upload/own_23/post_list/69ce0a5ad4b92_admin_17592.jpeg', '/listing-media/exclusive-asset/ea0282569/012.webp', 'image/webp', 22638, 1200, 720, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงอเนกประสงค์', 'โถงอเนกประสงค์ต่อเติมด้านข้างบ้าน', 'https://www.exclusive-asset.com/upload/own_23/post_list/69ce0a5b4f140_admin_81246.jpeg', '/listing-media/exclusive-asset/ea0282569/013.webp', 'image/webp', 24926, 1200, 677, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่สตูดิโอ', 'พื้นที่ต่อเติมขนาดใหญ่เหมาะทำสตูดิโอหรือสำนักงาน', 'https://www.exclusive-asset.com/upload/own_23/post_list/69ce0a5ba3f25_admin_13430.jpeg', '/listing-media/exclusive-asset/ea0282569/014.webp', 'image/webp', 19090, 1200, 677, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ส่วนต่อเติม', 'มุมมองพื้นที่อเนกประสงค์ที่ต่อเติมข้างบ้าน', 'https://www.exclusive-asset.com/upload/own_23/post_list/69ce0a5c1560f_admin_92917.jpeg', '/listing-media/exclusive-asset/ea0282569/015.webp', 'image/webp', 27826, 1200, 677, 150, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำ', 'ห้องน้ำภายในบ้านพร้อมอ่างอาบน้ำ', 'https://www.exclusive-asset.com/upload/own_23/post_list/69ce0a5c6f469_admin_13760.jpeg', '/listing-media/exclusive-asset/ea0282569/016.webp', 'image/webp', 32032, 1200, 677, 160, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอน', 'ห้องนอนภายในบ้าน MIND ปิ่นเกล้า-จรัญ', 'https://www.exclusive-asset.com/upload/own_23/post_list/69ce0a5ce8e8d_admin_11794.jpeg', '/listing-media/exclusive-asset/ea0282569/017.webp', 'image/webp', 45924, 1200, 677, 170, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนอีกมุม', 'มุมมองภายในห้องนอน', 'https://www.exclusive-asset.com/upload/own_23/post_list/69ce0a5d63424_admin_31274.jpeg', '/listing-media/exclusive-asset/ea0282569/018.webp', 'image/webp', 41564, 1200, 677, 180, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนชั้นบน', 'ห้องนอนชั้นบนพร้อมหน้าต่างรับแสง', 'https://www.exclusive-asset.com/upload/own_23/post_list/69ce0a5dd0b3a_admin_86494.jpeg', '/listing-media/exclusive-asset/ea0282569/019.webp', 'image/webp', 34252, 1200, 677, 190, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่แต่งตัว', 'ตู้เสื้อผ้าและพื้นที่แต่งตัวภายในห้องนอน', 'https://www.exclusive-asset.com/upload/own_23/post_list/69ce0a5e361cc_admin_27722.jpeg', '/listing-media/exclusive-asset/ea0282569/020.webp', 'image/webp', 30960, 1200, 677, 200, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนใหญ่', 'ห้องนอนใหญ่ภายในบ้านสามชั้น', 'https://www.exclusive-asset.com/upload/own_23/post_list/69ce0a5e8d310_admin_98405.jpeg', '/listing-media/exclusive-asset/ea0282569/021.webp', 'image/webp', 36746, 1200, 719, 210, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ตู้เสื้อผ้า', 'ตู้เสื้อผ้าภายในห้องนอน', 'https://www.exclusive-asset.com/upload/own_23/post_list/69ce0a5ee1562_admin_92728.jpeg', '/listing-media/exclusive-asset/ea0282569/022.webp', 'image/webp', 24932, 1200, 677, 220, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนที่สาม', 'พื้นที่ห้องนอนภายในบ้าน', 'https://www.exclusive-asset.com/upload/own_23/post_list/69ce0a5f587ae_admin_70755.jpeg', '/listing-media/exclusive-asset/ea0282569/023.webp', 'image/webp', 36868, 1200, 677, 230, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนที่สี่', 'ห้องนอนพร้อมพื้นที่เก็บของ', 'https://www.exclusive-asset.com/upload/own_23/post_list/69ce0a5fb3ef1_admin_31597.jpeg', '/listing-media/exclusive-asset/ea0282569/024.webp', 'image/webp', 28054, 1200, 699, 240, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนที่ห้า', 'ห้องนอนอีกห้องภายในบ้าน', 'https://www.exclusive-asset.com/upload/own_23/post_list/69ce0a60207de_admin_42451.jpeg', '/listing-media/exclusive-asset/ea0282569/025.webp', 'image/webp', 29358, 1200, 677, 250, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ตู้บิลต์อิน', 'พื้นที่เก็บของและตู้บิลต์อินในห้องนอน', 'https://www.exclusive-asset.com/upload/own_23/post_list/69ce0a608c08f_admin_39812.jpeg', '/listing-media/exclusive-asset/ea0282569/026.webp', 'image/webp', 28940, 1200, 677, 260, false, true);

    INSERT INTO public.listing_sources (
        listing_id,
        source_type,
        publisher_name,
        source_url,
        reference_code,
        captured_at,
        notes
    ) VALUES
        (
            property_listing_id,
            'editorial_import',
            'KKPPropify',
            'https://kkppropify.kkpfg.com/th/products/ea0282569',
            'EA0282569',
            '2026-09-08 00:00:00+07',
            'Imported from the public property record. Exclusive Asset is the verified listing publisher. Administrator-supplied coordinates override source map coordinates.'
        ),
        (
            property_listing_id,
            'editorial_import',
            'Exclusive Asset',
            'https://www.exclusive-asset.com/detail/186/near-si-rat-expressway-house-3-floors-5-bedrooms-mind-pinklao-charan-add-a-large-area-suitabl.html',
            '20260402186',
            '2026-09-08 00:00:00+07',
            'The exact publisher page supplies the current 8.3 million baht price, previous 8.5 million baht price, house details, direct contact, and 26 original photographs. MapxProp stores optimized copies without adding a watermark.'
        );

    IF NOT EXISTS (
        SELECT 1
        FROM public.organization_verifications
        WHERE organization_id = exclusive_asset_organization_id
          AND verification_type = 'listing_authority'
          AND status = 'verified'
          AND source_url = 'https://kkppropify.kkpfg.com/th/products/ea0282569'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            exclusive_asset_organization_id,
            'listing_authority',
            'verified',
            'https://kkppropify.kkpfg.com/th/products/ea0282569',
            'The KKPPropify property record names Exclusive Asset as the verified sales representative; the exact company page publishes matching property and contact details.',
            admin_user_id,
            now()
        );
    END IF;

    INSERT INTO public.organization_audit_logs (
        organization_id, actor_user_id, action_code,
        entity_type, entity_public_id, metadata
    ) VALUES
        (
            exclusive_asset_organization_id,
            admin_user_id,
            'organization.verified',
            'organization',
            '66c8ca9f-d0b9-414d-a2ae-5b70e33684a0',
            jsonb_build_object('registration_no', '0105565095319')
        ),
        (
            exclusive_asset_organization_id,
            admin_user_id,
            'listing.publisher_verified',
            'listing',
            'ea4ebe42-ff25-4195-bae5-2c3aface9055',
            jsonb_build_object('reference_code', 'EA0282569')
        );
END $$;

COMMIT;
