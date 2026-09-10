BEGIN;

DO $$
DECLARE
    admin_user_id bigint;
    sam_organization_id bigint;
    property_listing_id bigint;
BEGIN
    SELECT id INTO admin_user_id
    FROM public.auth_users
    WHERE lower(email) = 'mapxprop@gmail.com'
      AND deleted_at IS NULL
    ORDER BY id
    LIMIT 1;

    IF admin_user_id IS NULL THEN
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing 8Z1860';
    END IF;

    SELECT id INTO sam_organization_id
    FROM public.organizations
    WHERE slug = 'sukhumvit-asset-management-sam'
      AND verification_status = 'verified'
      AND is_active = true
      AND deleted_at IS NULL
    ORDER BY id
    LIMIT 1;

    IF sam_organization_id IS NULL THEN
        RAISE EXCEPTION 'Verified SAM organization is required to import listing 8Z1860';
    END IF;

    INSERT INTO public.listings (
        public_listing_id,
        user_id,
        organization_id,
        created_by_user_id,
        published_by_user_id,
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
        '97a754f6-98f7-4fc6-8035-0a6475149b2e',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'shophouse',
        'mixed',
        'sale',
        'whole_property',
        NULL,
        '110/113, 110/114',
        'ขายตรง SAM อาคารพาณิชย์ 2 คูหา 2 ชั้นครึ่ง เจาะถึงกัน ซอยศรีจันทร์ 11/2 ขอนแก่น ราคา 4.196 ล้านบาท',
        E'อาคารพาณิชย์ 2 คูหา เลขที่ 110/113 และ 110/114 ถนนศรีจันทร์ ตำบลในเมือง อำเภอเมืองขอนแก่น จังหวัดขอนแก่น บนโฉนดที่ดินเลขที่ 24440 และ 24441 จำนวน 2 ฉบับ เนื้อที่รวม 32.4 ตร.ว. (129.6 ตร.ม.) หน้า SAM ระบุเขตพื้นที่สีชมพู

ที่ดินเป็นรูปสี่เหลี่ยมผืนผ้า ด้านทิศตะวันตกติดถนน หน้ากว้างประมาณ 8 เมตรและลึกประมาณ 16.2 เมตร SAM ระบุรายการรับโอนกรรมสิทธิ์เป็นอาคารพาณิชย์ 2 ชั้นครึ่ง จำนวน 2 หลัง เลขที่ 110/113 และ 110/114 โดยทั้งสองคูหาเจาะทะลุถึงกันและใช้บันไดขึ้นลงทางเดียวกัน ผู้ซื้อควรตรวจทะเบียนอาคาร แบบแปลน ใบอนุญาต การเจาะเชื่อม โครงสร้าง บันได ทางหนีไฟ ระบบดับเพลิง และรายการสิ่งปลูกสร้างที่จะโอนให้ตรงกัน

ถนนผ่านหน้าทรัพย์คือซอยศรีจันทร์ 11/2 ซึ่ง SAM ระบุว่าเป็นทางสาธารณประโยชน์ ผิวจราจรคอนกรีตกว้างประมาณ 6 เมตร และเขตทางกว้างประมาณ 8 เมตร ผู้ซื้อควรให้ SAM สำนักงานที่ดิน และหน่วยงานท้องถิ่นยืนยันแนวเขต ทางเข้าออก สถานะทางสาธารณะ และการใช้ประโยชน์จริงก่อนเสนอซื้อ

หน้า SAM ไม่ได้เผยแพร่พื้นที่ใช้สอย จำนวนห้องนอน ห้องน้ำ ที่จอดรถ อายุอาคาร ระบบไฟฟ้า-ประปา สถานะการครอบครอง หรือภาระผูกพันอื่น MapxProp จัดอาคารพาณิชย์นี้เป็น Mixed Use เพื่อให้ค้นพบได้ทั้งหมวดที่อยู่อาศัยและธุรกิจ เหมาะสำหรับพิจารณาเป็นที่พักอาศัย หน้าร้าน หรือสำนักงาน แต่การจัดหมวดไม่ใช่การรับรองว่าสามารถใช้เพื่ออยู่อาศัยหรือประกอบกิจการทุกประเภทได้ ผู้ซื้อต้องตรวจผังเมืองเขตสีชมพู การใช้อาคาร ป้าย ที่จอดรถ ระบบดับเพลิง และใบอนุญาตของกิจการที่ต้องการ

การเดินทางตาม SAM ใช้ถนนศรีจันทร์จากตัวเมืองขอนแก่นมุ่งหน้ากาฬสินธุ์ ผ่านวัดศรีจันทร์และถนนเฉลิมพระเกียรติ แล้วเลี้ยวขวาเข้าซอยศรีจันทร์ 11/2 ประมาณ 50 เมตร ทรัพย์อยู่ด้านซ้ายมือ

หน้า SAM แสดงสถานะ “ซื้อตรง” และราคาประกาศขาย 4,196,000 บาท ไม่ใช่การประมูลในสถานะที่ตรวจสอบเมื่อวันที่ 10 กันยายน 2569 ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะการครอบครอง และวิธีจำหน่ายล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ 8Z1860 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM

ภาพหน้าทรัพย์หลักแสดงวันที่ 27 สิงหาคม 2568 ส่วนภาพอาคารและภายในชุดเดิมแสดงวันที่ 8 พฤศจิกายน 2565 สภาพจริงอาจเปลี่ยนแปลง ผู้ซื้อควรนัดตรวจทั้ง 2 คูหา ตรวจโครงสร้าง หลังคา การเจาะเชื่อม บันได ทางหนีไฟ รอยร้าว ความชื้น ปลวก ระบบไฟฟ้าและประปา ห้องน้ำ ระบบดับเพลิง การครอบครอง ภาระผูกพัน ภาษี ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        4196000,
        false,
        129.6,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'อาคารพาณิชย์เลขที่ 110/113 และ 110/114',
        'เข้าซอยศรีจันทร์ 11/2 จากถนนศรีจันทร์ประมาณ 50 เมตร',
        'ซอยศรีจันทร์ 11/2',
        NULL,
        16.42869071,
        102.84240530,
        'ขอนแก่น',
        'เมืองขอนแก่น',
        'ในเมือง',
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
        'sam-direct-sale-two-connected-shophouses-srichan-khon-kaen-8z1860'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES
        (property_listing_id, 'residential'),
        (property_listing_id, 'retail'),
        (property_listing_id, 'office')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 4196000, 'total', 'THB', false
    )
    ON CONFLICT (listing_id, offer_type) DO UPDATE SET
        amount = EXCLUDED.amount,
        price_unit = EXCLUDED.price_unit,
        currency_code = EXCLUDED.currency_code,
        is_negotiable = EXCLUDED.is_negotiable,
        updated_at = now();

    INSERT INTO public.listing_discovery_channels (
        listing_id, channel_code, source, is_featured
    ) VALUES
        (property_listing_id, 'homes', 'editorial', false),
        (property_listing_id, 'business', 'editorial', false)
    ON CONFLICT (listing_id, channel_code) DO UPDATE SET
        source = EXCLUDED.source,
        is_featured = EXCLUDED.is_featured,
        updated_at = now();

    INSERT INTO public.listing_category_details (
        listing_id, category_code, schema_version, details, is_minimum_submission
    ) VALUES (
        property_listing_id,
        'shophouse',
        1,
        jsonb_build_object(
            'source_property_category', 'อาคารพาณิชย์',
            'title_document_type', 'chanote',
            'title_document_type_th', 'โฉนดที่ดิน',
            'title_document_numbers', jsonb_build_array('24440', '24441'),
            'title_document_count', 2,
            'land_area_rai', 0,
            'land_area_ngan', 0,
            'land_area_square_wah_remainder', 32.4,
            'land_area_square_wah', 32.4,
            'land_area_sqm', 129.6,
            'plot_count', 2,
            'unit_count', 2,
            'building_numbers', jsonb_build_array('110/113', '110/114'),
            'registered_transfer_description', 'อาคารพาณิชย์ 2.5 ชั้น จำนวน 2 หลัง เลขที่ 110/113 และ 110/114',
            'registered_floor_count_text', '2 ชั้นครึ่ง',
            'registered_floor_count_numeric', 2.5,
            'units_internally_connected', true,
            'single_shared_staircase', true,
            'plot_shape', 'rectangle',
            'west_road_frontage_m', 8,
            'maximum_depth_m', 16.2,
            'front_road_name', 'ซอยศรีจันทร์ 11/2',
            'front_road_legal_status_th', 'ทางสาธารณประโยชน์',
            'front_road_surface', 'concrete',
            'front_road_width_m', 6,
            'front_right_of_way_width_m', 8
        ) || jsonb_build_object(
            'zoning_color_th', 'สีชมพู ตามหน้า SAM',
            'mixed_use_classification', true,
            'mixed_use_basis', 'อาคารพาณิชย์ 2 คูหาที่สามารถพิจารณาใช้เป็นที่อยู่อาศัย หน้าร้าน หรือสำนักงาน โดยต้องตรวจการใช้อาคารและใบอนุญาต',
            'approved_use_requires_independent_verification', true,
            'usable_area_not_published', true,
            'bedroom_count_not_published', true,
            'bathroom_count_not_published', true,
            'parking_information_not_published', true,
            'building_age_not_published', true,
            'utilities_information_not_published', true,
            'occupancy_status_not_published', true,
            'other_encumbrances_not_published', true,
            'source_information_date_not_published', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'computed_price_per_square_wah', 129506.17,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_latest_exterior_photo_date_displayed', '2025-08-27',
            'source_older_property_photo_date_displayed', '2022-11-08',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '16.428691,102.842407',
            'administrator_coordinate_distance_from_source_m_approx', 0.18
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z1860. MapxProp does not collect deposits or represent SAM in the transaction.',
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

    INSERT INTO public.listing_nearby_places (
        listing_id, place_name_th, place_name_en, place_type_code,
        distance_meters, latitude, longitude, sort_order, is_highlight
    ) VALUES
        (property_listing_id, 'ถนนศรีจันทร์', 'Srichan Road', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ซอยศรีจันทร์ 11/2', 'Srichan Soi 11/2', 'road', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'วัดศรีจันทร์', 'Wat Srichan', 'landmark', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'ถนนเฉลิมพระเกียรติ', 'Chaloem Phra Kiat Road', 'road', NULL, NULL, NULL, 40, true)
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
        (property_listing_id, 'sale_method', 'วิธีจำหน่าย', 'Sale method', 'ซื้อตรงจาก SAM — ติดต่อ SAM เพื่อเสนอซื้อ', 'Direct purchase from SAM — contact SAM to submit an offer', 'unspecified', NULL, '', 10),
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '4,196,000 บาท — โปรดตรวจสอบราคาล่าสุดและโปรโมชั่นกับ SAM', 'THB 4,196,000 — confirm the latest price and promotions with SAM', 'unspecified', 4196000, 'THB', 20),
        (property_listing_id, 'registered_buildings', 'สิ่งปลูกสร้างตามรายการรับโอน', 'Registered buildings', 'อาคารพาณิชย์ 2 ชั้นครึ่ง จำนวน 2 หลัง เลขที่ 110/113 และ 110/114 เจาะถึงกันและใช้บันไดร่วมกัน', 'Two 2.5-storey shophouses numbered 110/113 and 110/114, internally connected and using one shared staircase', 'buyer', 2, 'units', 30),
        (property_listing_id, 'public_road', 'ถนนหน้าทรัพย์', 'Frontage road', 'ซอยศรีจันทร์ 11/2 เป็นทางสาธารณประโยชน์ ผิวคอนกรีตกว้างประมาณ 6 เมตร เขตทางประมาณ 8 เมตร', 'Srichan Soi 11/2 is described as a public-utility concrete road approximately six metres wide in an eight-metre right of way', 'unspecified', 6, 'metres', 40),
        (property_listing_id, 'mixed_use_due_diligence', 'การใช้งานแบบผสม', 'Mixed-use due diligence', 'MapxProp แสดงทั้งหมวดที่อยู่อาศัยและธุรกิจ แต่ผู้ซื้อต้องตรวจผังเมือง การใช้อาคาร ใบอนุญาต ที่จอดรถ ป้าย และระบบดับเพลิง', 'MapxProp shows the property in both homes and business; buyers must verify zoning, approved use, licences, parking, signage and fire safety', 'buyer', NULL, '', 50),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนดทั้ง 2 ฉบับ แนวเขต ทะเบียนอาคาร จำนวนชั้น การเจาะเชื่อม บันได ทางหนีไฟ สภาพอาคาร การครอบครอง ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Verify both title deeds, boundaries, building registration, storeys, internal openings, staircase, fire escape, building condition, possession, encumbrances, costs and latest terms', 'buyer', NULL, '', 60)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ด้านหน้าอาคารพาณิชย์ 2 คูหา', 'อาคารพาณิชย์ SAM รหัส 8Z1860 เลขที่ 110/113 และ 110/114 ซอยศรีจันทร์ 11/2 ขอนแก่น', 'https://npa.sam.or.th/site/images/npa/8852/20260107144736_8Z1860P2_68.jpg', '/listing-media/sam/8z1860/01.webp', 'image/webp', 24394, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมด้านข้างอาคารพาณิชย์', 'ภาพมุมด้านข้างอาคารพาณิชย์ 2 คูหาและอาคารข้างเคียงในซอยศรีจันทร์ 11/2', 'https://npa.sam.or.th/site/images/npa/8852/8Z1860P4_66.jpg', '/listing-media/sam/8z1860/02.webp', 'image/webp', 30950, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ด้านหน้าและแนวถนน', 'ภาพด้านหน้าอาคารพาณิชย์และแนวถนนคอนกรีตซอยศรีจันทร์ 11/2', 'https://npa.sam.or.th/site/images/npa/8852/8Z1860P2_66.jpg', '/listing-media/sam/8z1860/03.webp', 'image/webp', 28396, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ชั้นล่างด้านหน้า', 'ภาพพื้นที่เปิดภายในชั้นล่าง มองเห็นประตูม้วนและช่องเชื่อมระหว่างคูหา', 'https://npa.sam.or.th/site/images/npa/8852/8Z1860P7_66.jpg', '/listing-media/sam/8z1860/04.webp', 'image/webp', 20668, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ภายในสองระดับ', 'ภาพพื้นที่ภายในอาคารพาณิชย์ที่แสดงโถงชั้นล่างและชั้นบน', 'https://npa.sam.or.th/site/images/npa/8852/8Z1860P6_66.jpg', '/listing-media/sam/8z1860/05.webp', 'image/webp', 13252, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บันไดร่วมภายในอาคาร', 'ภาพบันไดที่ใช้ขึ้นลงภายในอาคารพาณิชย์สองคูหาที่เชื่อมถึงกัน', 'https://npa.sam.or.th/site/images/npa/8852/8Z1860P8_66.jpg', '/listing-media/sam/8z1860/06.webp', 'image/webp', 16898, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องภายในชั้นบน', 'ภาพห้องภายในชั้นบนพร้อมหน้าต่างด้านหน้าอาคาร', 'https://npa.sam.or.th/site/images/npa/8852/8Z1860P9_66.jpg', '/listing-media/sam/8z1860/07.webp', 'image/webp', 17864, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'access', 'ทางเข้าซอยศรีจันทร์ 11/2', 'ภาพจุดเลี้ยวจากถนนศรีจันทร์เข้าสู่ซอยศรีจันทร์ 11/2', 'https://npa.sam.or.th/site/images/npa/8852/8Z1860P1_64.JPG', '/listing-media/sam/8z1860/08.webp', 'image/webp', 23596, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังโฉนด 2 แปลงและอาคาร 2 คูหา', 'ผังต้นทางแสดงที่ดินโฉนดเลขที่ 24440 และ 24441 กับตำแหน่งอาคารพาณิชย์สองคูหา', 'https://npa.sam.or.th/site/images/npa/8852/20170130160917_8Z1860C1_59.jpg', '/listing-media/sam/8z1860/09.webp', 'image/webp', 11038, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปทรัพย์', 'แผนที่ต้นทางแสดงเส้นทางจากถนนศรีจันทร์เข้าสู่ซอยศรีจันทร์ 11/2 ไปยังทรัพย์ 8Z1860', 'https://npa.sam.or.th/site/images/npa/8852/20170130160809_8Z1860M1_59.jpg', '/listing-media/sam/8z1860/10.webp', 'image/webp', 22826, 785, 600, 100, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=8852&keyref=6004425',
        '8Z1860',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 4,196,000 for two 2.5-storey shophouses numbered 110/113 and 110/114 on Srichan Soi 11/2, Nai Mueang, Mueang Khon Kaen. Title deeds 24440 and 24441 cover a combined 32.4 sq.wah / 129.6 sq.m. The rectangular land has approximately eight metres of west-facing road frontage and a depth of approximately 16.2 metres. SAM identifies two commercial buildings that are internally connected and use a single shared staircase. Srichan Soi 11/2 is described as a public-utility concrete road approximately six metres wide within an approximately eight-metre right of way. The source identifies pink planning zoning but does not publish approved building use. MapxProp classifies the shophouses as mixed use for residential and business discovery, subject to verification of permitted use. Usable area, bedrooms, bathrooms, parking, age, utility specifications, occupancy and other encumbrances are not published. The latest frontage photo displays 27 August 2025, while older building and interior photos display 8 November 2022. Administrator coordinates are approximately 0.18 metres from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all ten unique source property, interior, access, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Two Connected 2.5-Storey Shophouses on Srichan Soi 11/2, THB 4.196M',
        E'Two shophouses numbered 110/113 and 110/114 on Srichan Road, Nai Mueang, Mueang Khon Kaen. Title deeds 24440 and 24441 cover a combined 32.4 sq.wah (129.6 sq.m.). SAM shows pink planning zoning.

The rectangular land has approximately eight metres of west-facing road frontage and a depth of approximately 16.2 metres. SAM''s acquisition record identifies two 2.5-storey commercial buildings. The units are internally connected and use one shared staircase. Buyers should verify building registration, approved plans, permits, structural openings, the staircase, fire escape and fire-protection arrangements, and every structure included in the transfer.

Srichan Soi 11/2 is described as a public-utility concrete road approximately six metres wide within an approximately eight-metre right of way. Buyers should ask SAM, the Land Office and local authorities to confirm boundaries, actual access, public-road status and approved use.

The source does not publish usable area, bedroom or bathroom counts, parking, building age, utility specifications, occupancy or other encumbrances. MapxProp classifies the shophouses as mixed use so they can be discovered in both homes and business, with residential, retail and office use cases. This classification does not guarantee residential use or every commercial use. Buyers must verify current pink-zone planning, approved building use, parking, signage, fire safety and licences for the intended activity.

SAM''s directions use Srichan Road from central Khon Kaen toward Kalasin, passing Wat Srichan and Chaloem Phra Kiat Road. Turn right into Srichan Soi 11/2 and continue approximately fifty metres. The property is on the left.

The SAM page listed the property for direct purchase at an announced THB 4,196,000 when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, offer procedures, current price, promotions, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: 8Z1860. MapxProp does not collect deposits or represent SAM in the transaction.

The latest frontage photo displays 27 August 2025, while older building and interior photos display 8 November 2022. Conditions may have changed. Buyers should inspect both units, structure, roof, internal openings, staircase, fire escape, cracks, moisture, termites, electrical and plumbing systems, bathrooms, fire safety, possession, encumbrances, taxes, costs and every current term before deciding.',
        'Shophouses 110/113 and 110/114 on Srichan Road',
        'Approximately 50 metres inside Srichan Soi 11/2',
        'Srichan Soi 11/2',
        'Nai Mueang',
        'Mueang Khon Kaen',
        'Khon Kaen',
        'SAM Two Connected Shophouses on Srichan Soi 11/2, THB 4.196M',
        'Official SAM NPA asset 8Z1860: two connected 2.5-storey mixed-use shophouses on 129.6 sq.m. Direct-sale price THB 4.196M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset 8Z1860 two connected 2.5 storey mixed use shophouses 110/113 110/114 Srichan Soi 11/2 Nai Mueang Mueang Khon Kaen title deeds 24440 24441 32.4 sq.wah 129.6 sq.m. THB 4196000 shared staircase pink zone')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=8852&keyref=6004425'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=8852&keyref=6004425',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z1860. Specifications, title deeds, storeys, connected-unit condition, shared staircase, images, rounded coordinates, announced price, direct-purchase status, road details and planning-zone wording come from that record.',
            admin_user_id,
            now()
        );
    END IF;

    INSERT INTO public.organization_audit_logs (
        organization_id, actor_user_id, action_code,
        entity_type, entity_public_id, metadata
    ) VALUES (
        sam_organization_id,
        admin_user_id,
        'listing.publisher_verified',
        'listing',
        '97a754f6-98f7-4fc6-8035-0a6475149b2e',
        jsonb_build_object(
            'reference_code', '8Z1860',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'mixed',
            'discovery_channels', jsonb_build_array('homes', 'business'),
            'title_document_count', 2,
            'plot_count', 2,
            'unit_count', 2,
            'registered_floor_count', 2.5,
            'connected_units_review_required', true,
            'shared_staircase_review_required', true,
            'public_road_review_required', true,
            'mixed_use_review_required', true,
            'source_image_count', 10
        )
    );
END $$;

COMMIT;
