BEGIN;

DO $$
DECLARE
    admin_user_id bigint;
    sam_organization_id bigint;
    prathana_project_id bigint;
    property_listing_id bigint;
BEGIN
    SELECT id INTO admin_user_id
    FROM public.auth_users
    WHERE lower(email) = 'mapxprop@gmail.com'
      AND deleted_at IS NULL
    ORDER BY id
    LIMIT 1;

    IF admin_user_id IS NULL THEN
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing TL0902';
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
        logo_url,
        description,
        verification_status,
        verification_note,
        verified_at,
        verified_by_user_id,
        created_by_user_id,
        is_active
    ) VALUES (
        '2744ecba-3745-4b38-97e9-73c65c99e734',
        'sukhumvit-asset-management-sam',
        'SAM บริหารสินทรัพย์สุขุมวิท',
        'บริษัท บริหารสินทรัพย์สุขุมวิท จำกัด',
        'asset_manager',
        '0105543033809',
        'https://www.sam.or.th/',
        'sam.or.th',
        '/organization-media/sam/sam-logo.webp',
        'บริษัทบริหารสินทรัพย์ของรัฐภายใต้การกำกับของธนาคารแห่งประเทศไทย บริหารหนี้ด้อยคุณภาพ (NPL) และทรัพย์สินรอการขาย (NPA) ทั่วประเทศ',
        'verified',
        'MapxProp administrator verified SAM against the official company history, contact pages, public company registration, and the official TL0902 property record.',
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
        logo_url = EXCLUDED.logo_url,
        description = EXCLUDED.description,
        verification_status = 'verified',
        verification_note = EXCLUDED.verification_note,
        verified_at = COALESCE(public.organizations.verified_at, now()),
        verified_by_user_id = admin_user_id,
        is_active = true,
        deleted_at = NULL,
        updated_at = now()
    RETURNING id INTO sam_organization_id;

    INSERT INTO public.organization_specialties (organization_id, specialty_code)
    VALUES
        (sam_organization_id, 'sale'),
        (sam_organization_id, 'npa'),
        (sam_organization_id, 'condo'),
        (sam_organization_id, 'house'),
        (sam_organization_id, 'land'),
        (sam_organization_id, 'commercial'),
        (sam_organization_id, 'warehouse_factory'),
        (sam_organization_id, 'hotel_resort'),
        (sam_organization_id, 'investment')
    ON CONFLICT (organization_id, specialty_code) DO NOTHING;

    INSERT INTO public.organization_contacts (
        organization_id, channel_type, channel_value, label,
        is_primary, is_public, is_verified, verified_at
    ) VALUES
        (sam_organization_id, 'phone', '026861888', 'ฝ่ายบริหารการจำหน่ายทรัพย์ NPA', true, true, true, now()),
        (sam_organization_id, 'phone', '1443', 'SAM Call Center', false, true, true, now()),
        (sam_organization_id, 'phone', '026861800', 'สำนักงานใหญ่', false, true, true, now()),
        (sam_organization_id, 'line', '@samline', 'LINE Official', false, true, true, now()),
        (sam_organization_id, 'email', 'sale@sam.or.th', 'อีเมลฝ่ายขายทรัพย์ NPA', false, true, true, now()),
        (sam_organization_id, 'email', 'corp@sam.or.th', 'อีเมลองค์กร', false, true, true, now()),
        (sam_organization_id, 'website', 'https://www.sam.or.th/', 'เว็บไซต์ทางการ', false, true, true, now())
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
        WHERE organization_id = sam_organization_id
          AND verification_type = 'legal_entity'
          AND status = 'verified'
          AND source_url = 'https://www.dataforthai.com/company/0105543033809/'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'legal_entity',
            'verified',
            'https://www.dataforthai.com/company/0105543033809/',
            'Public company records identify บริษัท บริหารสินทรัพย์สุขุมวิท จำกัด, registration 0105543033809, as an active Thai asset-management company registered on 4 April 2000.',
            admin_user_id,
            now()
        );
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM public.organization_verifications
        WHERE organization_id = sam_organization_id
          AND verification_type = 'contact'
          AND status = 'verified'
          AND source_url = 'https://sam.or.th/site/sam/ติดต่อเรา/'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'contact',
            'verified',
            'https://sam.or.th/site/sam/ติดต่อเรา/',
            'The official SAM contact page publishes Call Center 1443, head-office phone 02-686-1800, the Bangkok head-office address, and the corporate email. The official NPA record publishes the NPA sales number 02-686-1888 and LINE @samline.',
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
        '6da52195-76b5-4343-b8b1-5fe8cb279f8f',
        'prathana-pluak-daeng',
        'housing_estate',
        'หมู่บ้านปรารถนา ปลวกแดง',
        'Prathana Pluak Daeng',
        ARRAY['semi_detached_house', 'townhouse'],
        'โครงการที่อยู่อาศัยในตำบลปลวกแดง อำเภอปลวกแดง จังหวัดระยอง เข้าถึงจากถนนสายปลวกแดง-หนองใหญ่ (ทล.3245) และถนนบ้านวังเขยง 8',
        'A residential development in Pluak Daeng, Rayong, accessed from Highway 3245 and Ban Wang Khayeng 8 Road.',
        'หมู่บ้านปรารถนา',
        'ถนนบ้านวังเขยง 8',
        'ปลวกแดง',
        'ปลวกแดง',
        'ระยอง',
        '21140',
        12.9800684,
        101.2252289,
        'https://www.sam.or.th/site/npa/detail.php?id=23569',
        'source_checked',
        'Project name, location, internal-road description, and housing type were cross-checked against the official SAM TL0902 record and matching public project records. Coordinates use the administrator-supplied property position as an approximate project point.',
        jsonb_build_object(
            'location_precision', 'approximate_project_point_from_listed_unit',
            'known_home_types', jsonb_build_array('single_storey_semi_detached_house'),
            'internal_road_surface', 'concrete',
            'internal_road_width_m', 6,
            'internal_right_of_way_width_m', 8
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
    RETURNING id INTO prathana_project_id;

    INSERT INTO public.property_project_aliases (
        project_id, locale, alias_name, alias_type
    ) VALUES
        (prathana_project_id, 'th', 'หมู่บ้านปรารถนา ปลวกแดง', 'official'),
        (prathana_project_id, 'th', 'บ้านปรารถนา ปลวกแดง', 'alternate'),
        (prathana_project_id, 'th', 'ปรารถนา ปลวกแดง-ระยอง', 'alternate'),
        (prathana_project_id, 'en', 'Prathana Pluak Daeng', 'official'),
        (prathana_project_id, 'en', 'Baan Prathana Pluak Daeng', 'alternate')
    ON CONFLICT (project_id, locale, normalized_alias) DO NOTHING;

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
        total_floors,
        contact_name,
        contact_phone,
        contact_phone_secondary,
        contact_email,
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
        '783de5ca-3051-4f48-8f58-fad82eec8a7c',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        prathana_project_id,
        'semi_detached_house',
        'residence',
        'sale',
        'whole_property',
        'หมู่บ้านปรารถนา ปลวกแดง',
        '599/53',
        'ทรัพย์ประมูล SAM บ้านแฝดชั้นเดียว หมู่บ้านปรารถนา ปลวกแดง 42 ตร.ว. ราคาอ้างอิง 1.43 ล้านบาท',
        E'บ้านพักอาศัยแฝดตึกชั้นเดียว เลขที่ 599/53 พร้อมโรงจอดรถ ในหมู่บ้านปรารถนา ตำบลปลวกแดง จังหวัดระยอง โดยหน้า SAM จัดหมวดทรัพย์ไว้เป็น “ทาวน์เฮ้าส์”\n\nที่ดิน 42 ตร.ว. (168 ตร.ม.) รูปสี่เหลี่ยมผืนผ้า หน้ากว้างติดถนนประมาณ 10.5 เมตร ลึกประมาณ 16 เมตร เอกสารสิทธิ์โฉนดที่ดินเลขที่ 30605 จำนวน 1 ฉบับ ถนนหน้าทรัพย์เป็นถนนคอนกรีตในโครงการ กว้างประมาณ 6 เมตร เขตทางประมาณ 8 เมตร\n\nอยู่ในย่านที่อยู่อาศัย การคมนาคมสะดวก เข้าจากถนนสายปลวกแดง-หนองใหญ่ (ทล.3245) ผ่านถนนบ้านวังเขยง 8 ใกล้ที่ว่าการอำเภอปลวกแดง สถานีตำรวจภูธรปลวกแดง และโรงพยาบาลปลวกแดง\n\nสำคัญ: หน้า SAM ระบุราคาประกาศ 1,430,000 บาท และสถานะ “ประมูล” ไม่ใช่ราคาซื้อได้ทันที รอบที่เผยแพร่ในต้นทางเปิดลงทะเบียนและยื่นซอง 16 ส.ค.–1 ก.ย. 2569 และเปิดซอง 8 ก.ย. 2569 เวลา 10.00 น. ซึ่งสิ้นสุดแล้ว ณ วันที่นำเข้าข้อมูล 9 ก.ย. 2569 ราคาบน MapxProp จึงเป็นราคาอ้างอิงจากประกาศเดิมเท่านั้น ไม่ใช่ราคาขายสุดท้าย\n\nผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อตรวจสอบผลประมูล สถานะทรัพย์ปัจจุบัน รอบจำหน่ายถัดไป เอกสาร และเงื่อนไขล่าสุด: ฝ่ายบริหารการจำหน่ายทรัพย์ NPA โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ TL0902\n\nผู้ซื้อควรตรวจสอบสภาพทรัพย์ เอกสารสิทธิ์ สิ่งปลูกสร้าง ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขทั้งหมดกับ SAM ก่อนตัดสินใจ',
        1430000,
        false,
        168,
        1,
        'ฝ่ายบริหารการจำหน่ายทรัพย์ NPA — SAM',
        '026861888',
        '1443',
        'sale@sam.or.th',
        '@samline',
        true,
        true,
        '599/53 หมู่บ้านปรารถนา ซอย 5',
        'ถนนบ้านวังเขยง 8',
        'ถนนบ้านวังเขยง 8',
        '21140',
        12.98006841,
        101.22522885,
        'ระยอง',
        'ปลวกแดง',
        'ปลวกแดง',
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
        'sam-auction-semi-detached-house-prathana-pluak-daeng-tl0902'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 1430000, 'total', 'THB', false
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
        'semi_detached_house',
        1,
        jsonb_build_object(
            'land_area_square_wah', 42,
            'storey_count', 1,
            'source_property_category', 'ทาวน์เฮ้าส์',
            'legal_building_description', 'บ้านพักอาศัยแฝดตึกชั้นเดียว พร้อมโรงจอดรถ',
            'title_deed_number', '30605',
            'title_document_count', 1,
            'plot_shape', 'rectangle',
            'frontage_m', 10.5,
            'maximum_depth_m', 16,
            'zoning_color_th', 'สีเหลืองอ่อน',
            'front_road_surface', 'concrete',
            'front_road_width_m', 6,
            'front_right_of_way_width_m', 8,
            'has_carport', true,
            'purchase_method', 'sealed_bid_auction',
            'published_price_kind', 'announced_reference_price',
            'auction_registration_starts_on', '2026-08-16',
            'auction_registration_ends_on', '2026-09-01',
            'auction_opening_at', '2026-09-08T10:00:00+07:00',
            'auction_round_status_at_import', 'ended_result_not_confirmed',
            'source_status_at_import', 'auction',
            'status_checked_on', '2026-09-09'
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
        organization_registration_no,
        verification_status,
        verification_note,
        verified_at,
        verified_by_user_id,
        organization_id,
        contact_user_id
    ) VALUES (
        property_listing_id,
        'developer_investor_representative',
        'investor_asset_holder',
        'บริษัท บริหารสินทรัพย์สุขุมวิท จำกัด (SAM)',
        '0105543033809',
        'authority_verified',
        'The official SAM NPA record identifies SAM as the asset holder and sole direct contact for TL0902. MapxProp does not collect bids or represent SAM in the auction.',
        now(),
        admin_user_id,
        sam_organization_id,
        NULL
    )
    ON CONFLICT (listing_id) DO UPDATE SET
        role_code = EXCLUDED.role_code,
        authority_source_code = EXCLUDED.authority_source_code,
        organization_name = EXCLUDED.organization_name,
        organization_registration_no = EXCLUDED.organization_registration_no,
        verification_status = EXCLUDED.verification_status,
        verification_note = EXCLUDED.verification_note,
        verified_at = EXCLUDED.verified_at,
        verified_by_user_id = EXCLUDED.verified_by_user_id,
        organization_id = EXCLUDED.organization_id,
        contact_user_id = EXCLUDED.contact_user_id,
        updated_at = now();

    INSERT INTO public.listing_amenities (listing_id, amenity_code)
    VALUES (property_listing_id, 'parking')
    ON CONFLICT (listing_id, amenity_code) DO NOTHING;

    INSERT INTO public.listing_nearby_places (
        listing_id, place_name_th, place_name_en, place_type_code,
        distance_meters, latitude, longitude, sort_order, is_highlight
    ) VALUES
        (property_listing_id, 'ถนนสายปลวกแดง-หนองใหญ่ (ทล.3245)', 'Pluak Daeng-Nong Yai Road (Highway 3245)', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'โรงพยาบาลปลวกแดง', 'Pluak Daeng Hospital', 'healthcare', 1320, 12.9699400, 101.2189220, 20, true),
        (property_listing_id, 'ที่ว่าการอำเภอปลวกแดง', 'Pluak Daeng District Office', 'government', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'สถานีตำรวจภูธรปลวกแดง', 'Pluak Daeng Police Station', 'government', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'นิคมอุตสาหกรรมอีสเทิร์นซีบอร์ด (ระยอง)', 'Eastern Seaboard Industrial Estate (Rayong)', 'landmark', NULL, NULL, NULL, 50, false)
    ON CONFLICT (listing_id, place_name_th) DO UPDATE SET
        place_name_en = EXCLUDED.place_name_en,
        place_type_code = EXCLUDED.place_type_code,
        distance_meters = EXCLUDED.distance_meters,
        latitude = EXCLUDED.latitude,
        longitude = EXCLUDED.longitude,
        sort_order = EXCLUDED.sort_order,
        is_highlight = EXCLUDED.is_highlight,
        updated_at = now();

    INSERT INTO public.listing_transaction_terms (
        listing_id, term_code, label_th, label_en, value_th, value_en,
        payer_code, numeric_value, unit_code, sort_order
    ) VALUES
        (property_listing_id, 'sale_method', 'วิธีจำหน่าย', 'Sale method', 'ประมูลยื่นซอง — ติดต่อ SAM เพื่อตรวจสอบสถานะล่าสุด', 'Sealed-bid auction — contact SAM to confirm the latest status', 'unspecified', NULL, '', 10),
        (property_listing_id, 'announced_reference_price', 'ราคาประกาศอ้างอิง', 'Announced reference price', '1,430,000 บาท (ไม่ใช่ราคาขายสุดท้าย)', 'THB 1,430,000 (not the final sale price)', 'unspecified', 1430000, 'THB', 20),
        (property_listing_id, 'auction_registration_period', 'ช่วงลงทะเบียนรอบที่เผยแพร่', 'Published registration period', '16 สิงหาคม–1 กันยายน 2569 (สิ้นสุดแล้ว)', '16 August–1 September 2026 (ended)', 'unspecified', NULL, '', 30),
        (property_listing_id, 'auction_opening', 'กำหนดเปิดซองรอบที่เผยแพร่', 'Published bid opening', '8 กันยายน 2569 เวลา 10.00 น. (ผ่านแล้ว ไม่ทราบผล)', '8 September 2026 at 10:00 (passed; result unconfirmed)', 'unspecified', NULL, '', 40)
    ON CONFLICT (listing_id, term_code) DO UPDATE SET
        label_th = EXCLUDED.label_th,
        label_en = EXCLUDED.label_en,
        value_th = EXCLUDED.value_th,
        value_en = EXCLUDED.value_en,
        payer_code = EXCLUDED.payer_code,
        numeric_value = EXCLUDED.numeric_value,
        unit_code = EXCLUDED.unit_code,
        sort_order = EXCLUDED.sort_order,
        updated_at = now();

    INSERT INTO public.listing_media (
        listing_id, media_type, source_type, role_code, title, alt_text,
        original_url, file_url, mime_type, file_size_bytes, width, height,
        sort_order, is_primary, is_active
    ) VALUES
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ด้านหน้าทรัพย์', 'บ้านแฝดชั้นเดียวเลขที่ 599/53 หมู่บ้านปรารถนา ปลวกแดง', 'https://npa.sam.or.th/site/images/npa/23569/20260814112407_TL0902P1_69.jpg', '/listing-media/sam/tl0902/01.webp', 'image/webp', 35206, 720, 400, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ด้านข้างและถนนหน้าทรัพย์', 'มุมด้านข้างบ้านแฝดและถนนคอนกรีตหน้าทรัพย์', 'https://npa.sam.or.th/site/images/npa/23569/TL0902P2_69.jpg', '/listing-media/sam/tl0902/02.webp', 'image/webp', 56260, 720, 400, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังรูปแปลงที่ดิน', 'ผังโฉนดที่ดินเลขที่ 30605 แสดงหน้ากว้าง 10.5 เมตรและความลึก 16 เมตร', 'https://npa.sam.or.th/site/images/npa/23569/20260814112407_TL0902C1_69.jpg', '/listing-media/sam/tl0902/03.webp', 'image/webp', 8888, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังตำแหน่งสิ่งปลูกสร้าง', 'ผังตำแหน่งบ้านแฝดชั้นเดียวภายในแปลงทรัพย์', 'https://npa.sam.or.th/site/images/npa/23569/20260814112407_TL0902C2_69.jpg', '/listing-media/sam/tl0902/04.webp', 'image/webp', 13402, 450, 450, 40, false, true);

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
        'บริษัท บริหารสินทรัพย์สุขุมวิท จำกัด (SAM)',
        'https://www.sam.or.th/site/npa/detail.php?id=23569',
        'TL0902',
        '2026-09-09 00:00:00+07',
        'Imported from the official SAM NPA record. The source categorized the asset as a townhouse but described the transferred building as a one-storey semi-detached residence with a carport, so MapxProp uses the more specific semi-detached-house taxonomy and preserves the source category in structured details. The source still showed auction status and THB 1,430,000 after the published registration period ended on 1 September 2026 and bid opening occurred on 8 September 2026. Availability and result were not confirmed at capture time; interested parties must contact SAM directly. Administrator-supplied coordinates match the source coordinates to within one meter. MapxProp stores optimized copies of all four source images without adding a MapxProp watermark.'
    );

    INSERT INTO public.listing_translations (
        listing_id, language_code, title, description,
        address_line1, address_line2, road,
        subdistrict_name, district_name, province_name,
        seo_title, seo_description,
        translation_status, translation_source, reviewed_at, search_text
    ) VALUES (
        property_listing_id,
        'en',
        'SAM Auction Asset: Single-Storey Semi-Detached House at Prathana Pluak Daeng, 42 sq.wah, THB 1.43M Reference Price',
        E'Single-storey semi-detached residence, house no. 599/53, with a carport in Prathana Village, Pluak Daeng, Rayong. The SAM source page categorizes the asset as a townhouse.\n\nThe rectangular 42 sq.wah (168 sq.m.) plot has approximately 10.5 meters of road frontage and a maximum depth of 16 meters. It has one title deed, no. 30605. The concrete project road in front of the property is approximately 6 meters wide within an 8-meter right of way.\n\nThe property is in a residential area accessed from Pluak Daeng-Nong Yai Road (Highway 3245) via Ban Wang Khayeng 8 Road. Nearby destinations include Pluak Daeng District Office, Pluak Daeng Police Station, and Pluak Daeng Hospital.\n\nImportant: SAM lists an announced price of THB 1,430,000 and the status as “auction.” This is not an immediate-purchase price. The published round accepted registrations and sealed bids from 16 August to 1 September 2026 and opened bids on 8 September 2026 at 10:00. That round had ended by MapxProp''s 9 September 2026 capture date, so the amount shown here is a reference price from the original announcement, not a final sale price.\n\nInterested parties must contact SAM directly to confirm the auction result, current availability, any next sale round, documents, and latest terms. SAM NPA Asset Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: TL0902.\n\nBuyers should verify the property condition, title documents, structures, encumbrances, expenses, and all terms with SAM before making a decision.',
        '599/53 Prathana Village, Soi 5',
        'Ban Wang Khayeng 8 Road',
        'Ban Wang Khayeng 8 Road',
        'Pluak Daeng',
        'Pluak Daeng',
        'Rayong',
        'SAM Auction Semi-Detached House, Prathana Pluak Daeng, THB 1.43M Reference Price',
        'Official SAM NPA asset TL0902: a single-storey semi-detached house on 42 sq.wah in Prathana Village, Pluak Daeng. THB 1.43M is the published auction reference price; contact SAM to confirm current status.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM auction asset TL0902 single-storey semi-detached house townhouse Prathana Pluak Daeng Rayong Ban Wang Khayeng 8 Road 42 sq.wah 168 sq.m. THB 1430000 reference price')
    )
    ON CONFLICT (listing_id, language_code) WHERE deleted_at IS NULL DO UPDATE SET
        title = EXCLUDED.title,
        description = EXCLUDED.description,
        address_line1 = EXCLUDED.address_line1,
        address_line2 = EXCLUDED.address_line2,
        road = EXCLUDED.road,
        subdistrict_name = EXCLUDED.subdistrict_name,
        district_name = EXCLUDED.district_name,
        province_name = EXCLUDED.province_name,
        seo_title = EXCLUDED.seo_title,
        seo_description = EXCLUDED.seo_description,
        translation_status = EXCLUDED.translation_status,
        translation_source = EXCLUDED.translation_source,
        reviewed_at = EXCLUDED.reviewed_at,
        search_text = EXCLUDED.search_text,
        updated_at = now();

    IF NOT EXISTS (
        SELECT 1
        FROM public.organization_verifications
        WHERE organization_id = sam_organization_id
          AND verification_type = 'listing_authority'
          AND status = 'verified'
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=23569'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=23569',
            'The official SAM NPA record identifies SAM as the asset holder and direct sales contact for TL0902. The property specifications, images, coordinates, announced reference price, auction method, and published schedule come from that record.',
            admin_user_id,
            now()
        );
    END IF;

    INSERT INTO public.organization_audit_logs (
        organization_id, actor_user_id, action_code,
        entity_type, entity_public_id, metadata
    ) VALUES
        (
            sam_organization_id,
            admin_user_id,
            'organization.verified',
            'organization',
            '2744ecba-3745-4b38-97e9-73c65c99e734',
            jsonb_build_object('verification_scope', 'legal_entity_contacts_and_official_domain')
        ),
        (
            sam_organization_id,
            admin_user_id,
            'listing.publisher_verified',
            'listing',
            '783de5ca-3051-4f48-8f58-fad82eec8a7c',
            jsonb_build_object(
                'reference_code', 'TL0902',
                'sale_method', 'sealed_bid_auction',
                'auction_round_status_at_import', 'ended_result_not_confirmed'
            )
        );
END $$;

COMMIT;
