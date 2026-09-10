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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing 3A1139';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing 3A1139';
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
        'e7fee466-d3e9-4845-9741-835109e964bf',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'shophouse',
        'mixed',
        'sale',
        'whole_property',
        '108/147-148',
        'ขายตรง SAM อาคารพาณิชย์ 3 ชั้น 2 คูหาเจาะถึงกัน ถนนอนามัย 40.1 ตร.ว. ราคา 10.088 ล้านบาท',
        E'อาคารพาณิชย์ 3 ชั้น จำนวน 2 คูหา เลขที่ 108/147-148 เจาะทะลุถึงกัน ตั้งอยู่ถนนอนามัย ตำบลในเมือง อำเภอเมืองขอนแก่น จังหวัดขอนแก่น บนโฉนดที่ดินเลขที่ 274419 จำนวน 1 ฉบับ เนื้อที่รวม 40.1 ตร.ว. (160.4 ตร.ม.) หน้า SAM ระบุเขตพื้นที่สีชมพูและย่านโดยรอบเป็นทั้งที่อยู่อาศัยและพาณิชยกรรม\n\nที่ดินเป็นรูปสี่เหลี่ยมผืนผ้าและ SAM ระบุว่าติดถนน 2 ด้าน ด้านทิศตะวันออกและทิศตะวันตกกว้างด้านละประมาณ 8 เมตร ลึกประมาณ 20 เมตร ผังต้นทางแสดงอาคาร 3 ชั้น 2 คูหาเชื่อมถึงกัน ผู้ซื้อต้องตรวจโฉนด รังวัด รูปแปลง แนวเขต ถนนทั้งสองด้าน ทางเข้าออก ตำแหน่งอาคาร และการเจาะเชื่อมอาคารก่อนเสนอซื้อ\n\nถนนอนามัยผ่านหน้าทรัพย์ SAM ระบุว่าเป็นทางสาธารณประโยชน์ ผิวจราจรลาดยางกว้างประมาณ 8 เมตร เขตทางกว้างประมาณ 10 เมตร ควรตรวจสถานะถนน สิทธิทาง แนวเขตทาง ทางเข้าออก จุดกลับรถ ที่จอดรถ และข้อจำกัดการใช้พื้นที่หน้าทรัพย์กับหน่วยงานที่เกี่ยวข้อง\n\nMapxProp จัดอาคารพาณิชย์นี้เป็น Mixed Use เพื่อให้ค้นพบได้ทั้งหมวดที่อยู่อาศัยและธุรกิจ เหมาะสำหรับพิจารณาเป็นที่พักอาศัย หน้าร้าน หรือสำนักงานตามลักษณะอาคารและข้อความย่านที่อยู่อาศัย–พาณิชยกรรมของ SAM แต่การจัดหมวดไม่ใช่การรับรองการใช้ประโยชน์ ผู้ซื้อต้องตรวจผังเมืองสีชมพู การใช้อาคาร การเจาะเชื่อม 2 คูหา ใบอนุญาต ป้าย ที่จอดรถ ทางหนีไฟ ระบบดับเพลิง และใบอนุญาตกิจการ\n\nสถานที่สำคัญที่ SAM ระบุ ได้แก่ เรือนจำกลางจังหวัดขอนแก่น สำนักงานสาธารณสุขจังหวัดขอนแก่น และวิทยาลัยการสาธารณสุขสิรินธร จังหวัดขอนแก่น การเดินทางตาม SAM ใช้ถนนศรีจันทร์จากโรงพยาบาลศูนย์ขอนแก่นมุ่งหน้าศาลหลักเมือง ผ่านเรือนจำกลางขอนแก่น แล้วเลี้ยวซ้ายเข้าถนนอนามัยประมาณ 120 เมตร ทรัพย์อยู่ด้านขวามือตรงข้ามสำนักงานสาธารณสุขจังหวัดขอนแก่น\n\nหน้า SAM แสดงสถานะ “ซื้อตรง” และราคาประกาศขาย 10,088,000 บาท ไม่ใช่การประมูลในสถานะที่ตรวจสอบเมื่อวันที่ 10 กันยายน 2569 ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะการครอบครอง และวิธีจำหน่ายล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nหน้า SAM มีวิดีโอทรัพย์บน YouTube และภาพทรัพย์ต้นทางแสดงวันที่ 21 กุมภาพันธ์ 2567 สภาพจริงอาจเปลี่ยนแปลง หน้า SAM ไม่ได้เผยแพร่พื้นที่ใช้สอย จำนวนห้องนอน ห้องน้ำ ที่จอดรถ อายุอาคาร ระบบไฟฟ้า-ประปา หรือสถานะการครอบครอง ผู้ซื้อควรนัดตรวจโครงสร้าง หลังคา บันได การเชื่อมต่อระหว่างคูหา ทางหนีไฟ รอยร้าว ความชื้น ปลวก ระบบไฟฟ้าและประปา ห้องน้ำ ระบบดับเพลิง การครอบครอง ภาระผูกพัน ภาษี ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        10088000,
        false,
        160.4,
        3,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        '108/147-148',
        'อาคารพาณิชย์ 3 ชั้น 2 คูหาเจาะทะลุถึงกัน',
        'อนามัย',
        NULL,
        16.427926802821965,
        102.84382905992801,
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
        'sam-direct-sale-mixed-use-two-shophouses-anamai-khon-kaen-3a1139'
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
        property_listing_id, 'sale', 10088000, 'total', 'THB', false
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
            'official_page_reference_code', '3A1139',
            'source_gallery_filename_reference_code', '3A1139',
            'source_reference_code_discrepancy', false,
            'source_page_id', 19784,
            'source_address_display', '108/147-148',
            'registered_building_number', '108/147-148',
            'building_number_discrepancy', false,
            'title_document_type', 'chanote',
            'title_deed_number', '274419',
            'title_document_count', 1,
            'land_area_rai', 0,
            'land_area_ngan', 0,
            'land_area_square_wah_remainder', 40.1,
            'land_area_square_wah', 40.1,
            'land_area_sqm', 160.4,
            'plot_count', 1,
            'unit_count', 2,
            'registered_transfer_description', 'ตึกแถว 3 ชั้น เลขที่ 108/147-148',
            'source_building_description', 'อาคารพาณิชย์ 3 ชั้น จำนวน 2 คูหา เลขที่ 108/147-148 เจาะทะลุถึงกัน',
            'registered_floor_count', 3,
            'connected_units', true,
            'connected_on_unspecified_floors', true,
            'plot_shape', 'rectangle',
            'summary_road_frontage_m', 8,
            'summary_maximum_depth_m', 20,
            'detail_east_side_width_m_approx', 8,
            'detail_west_side_width_m_approx', 8,
            'detail_depth_m_approx', 20,
            'two_road_frontages_reported', true,
            'plot_measurement_discrepancy', false
        ) || jsonb_build_object(
            'front_road_name', 'ถนนอนามัย',
            'front_road_legal_status_th', 'ทางสาธารณประโยชน์',
            'front_road_surface', 'asphalt',
            'front_road_width_m_approx', 8,
            'front_right_of_way_width_m_approx', 10,
            'zoning_color_th', 'เขตสีชมพู ตามหน้า SAM',
            'surrounding_area_use_th', 'ย่านที่อยู่อาศัยและพาณิชยกรรม',
            'mixed_use_classification', true,
            'mixed_use_basis', 'อาคารพาณิชย์ 2 คูหาในย่านที่อยู่อาศัยและพาณิชยกรรม เหมาะพิจารณาใช้เป็นที่อยู่อาศัย หน้าร้าน หรือสำนักงาน โดยต้องตรวจการใช้อาคารและใบอนุญาต',
            'approved_use_requires_independent_verification', true,
            'source_video_url', 'https://www.youtube.com/watch?v=cqDcszuoyXA',
            'usable_area_not_published', true,
            'bedroom_count_not_published', true,
            'bathroom_count_not_published', true,
            'parking_information_not_published', true,
            'building_age_not_published', true,
            'utilities_information_not_published', true,
            'occupancy_status_not_published', true,
            'other_encumbrances_not_published', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'computed_price_per_square_wah', 251571.07,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_photo_date_displayed', '2024-02-21',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '16.427929,102.843829',
            'administrator_coordinate_distance_from_source_m_approx', 0.24
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
        listing_id, role_code, authority_source_code, organization_name,
        organization_registration_no, verification_status, verification_note,
        verified_at, verified_by_user_id, organization_id, contact_user_id
    ) VALUES (
        property_listing_id,
        'developer_investor_representative',
        'investor_asset_holder',
        'บริษัท บริหารสินทรัพย์สุขุมวิท จำกัด (SAM)',
        '0105543033809',
        'authority_verified',
        'The official SAM NPA page identifies SAM as the asset holder and direct-sale contact for asset 3A1139. The page, gallery filenames, address and registered building description are internally consistent. Buyers must still confirm availability and every title, building and sale term directly with SAM. MapxProp does not collect deposits or represent SAM.',
        now(), admin_user_id, sam_organization_id, NULL
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
        (property_listing_id, 'ถนนอนามัย', 'Anamai Road', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'สำนักงานสาธารณสุขจังหวัดขอนแก่น', 'Khon Kaen Provincial Public Health Office', 'government', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'เรือนจำกลางจังหวัดขอนแก่น', 'Khon Kaen Central Prison', 'government', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'วิทยาลัยการสาธารณสุขสิรินธร จังหวัดขอนแก่น', 'Sirindhorn College of Public Health Khon Kaen', 'education', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'ถนนศรีจันทร์', 'Srichan Road', 'road', NULL, NULL, NULL, 50, false),
        (property_listing_id, 'โรงพยาบาลศูนย์ขอนแก่น', 'Khon Kaen Regional Hospital', 'healthcare', NULL, NULL, NULL, 60, false),
        (property_listing_id, 'ศาลหลักเมืองขอนแก่น', 'Khon Kaen City Pillar Shrine', 'landmark', NULL, NULL, NULL, 70, false)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '10,088,000 บาท — โปรดตรวจสอบราคาล่าสุดและโปรโมชั่นกับ SAM', 'THB 10,088,000 — confirm the latest price and promotions with SAM', 'unspecified', 10088000, 'THB', 20),
        (property_listing_id, 'connected_units', 'อาคาร 2 คูหาเจาะถึงกัน', 'Two internally connected units', 'อาคารพาณิชย์ 3 ชั้น เลขที่ 108/147-148 จำนวน 2 คูหาเจาะทะลุถึงกัน ต้องตรวจโครงสร้าง แบบอาคาร และการอนุญาต', 'Three-storey shophouses 108/147-148 comprise two internally connected units; verify the structure, approved plans and permissions', 'buyer', 2, 'units', 30),
        (property_listing_id, 'two_road_frontages', 'ติดถนน 2 ด้าน', 'Two road frontages', 'SAM ระบุแปลงรูปสี่เหลี่ยมผืนผ้าติดถนน 2 ด้าน ด้านตะวันออกและตะวันตกกว้างด้านละประมาณ 8 เมตร ลึกประมาณ 20 เมตร', 'SAM describes a rectangular plot with two road frontages, east and west sides approximately eight metres wide and depth approximately twenty metres', 'buyer', NULL, '', 40),
        (property_listing_id, 'public_road', 'ถนนหน้าทรัพย์', 'Frontage road', 'ถนนอนามัยเป็นทางสาธารณประโยชน์ ผิวลาดยางกว้างประมาณ 8 เมตร เขตทางประมาณ 10 เมตร', 'Anamai Road is described as a public asphalt road approximately eight metres wide within a ten-metre right of way', 'unspecified', 8, 'metres', 50),
        (property_listing_id, 'mixed_use_due_diligence', 'การใช้งานแบบผสม', 'Mixed-use due diligence', 'MapxProp แสดงทั้งหมวดที่อยู่อาศัยและธุรกิจ แต่ผู้ซื้อต้องตรวจผังเมือง การใช้อาคาร การเจาะเชื่อม ใบอนุญาต ที่จอดรถ ป้าย ทางหนีไฟ และระบบดับเพลิง', 'MapxProp shows the property in both homes and business; buyers must verify planning, approved use, connected-building alterations, licences, parking, signage, fire escape and fire safety', 'buyer', NULL, '', 60),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ยืนยันโฉนด รังวัด แนวเขต ถนนทั้งสองด้าน อาคาร 2 คูหา การเจาะเชื่อม แบบอาคาร สภาพภายใน การครอบครอง ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Confirm the title, survey, boundaries, both roads, two units, connecting alterations, approved plans, interior, possession, encumbrances, costs and latest terms', 'buyer', NULL, '', 70)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ด้านหน้าอาคารพาณิชย์ 2 คูหา', 'อาคารพาณิชย์ 3 ชั้น 2 คูหาเลขที่ 108/147-148 บนถนนอนามัยจากภาพ SAM', 'https://npa.sam.or.th/site/images/npa/19784/20250123101920_3A1139P1_67.jpg', '/listing-media/sam/3a1139/01.webp', 'image/webp', 28896, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ชั้นล่างและเคาน์เตอร์', 'ภาพพื้นที่เปิดและเคาน์เตอร์ภายในชั้นล่างของอาคาร 2 คูหา', 'https://npa.sam.or.th/site/images/npa/19784/3A1139P2_67.jpg', '/listing-media/sam/3a1139/02.webp', 'image/webp', 11642, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ร้านค้าชั้นล่าง', 'ภาพพื้นที่ชั้นล่างมองตามแนวอาคารพาณิชย์ที่เชื่อมถึงกัน', 'https://npa.sam.or.th/site/images/npa/19784/3A1139P3_67.jpg', '/listing-media/sam/3a1139/03.webp', 'image/webp', 12752, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเดินภายในอาคาร', 'ภาพทางเดินภายในอาคารพาณิชย์จากชุดภาพต้นทาง SAM', 'https://npa.sam.or.th/site/images/npa/19784/3A1139P4_67.jpg', '/listing-media/sam/3a1139/04.webp', 'image/webp', 8168, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'เคาน์เตอร์และพื้นที่บริการ', 'ภาพเคาน์เตอร์และพื้นที่บริการภายในอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/19784/3A1139P5_67.jpg', '/listing-media/sam/3a1139/05.webp', 'image/webp', 11482, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่สุขภัณฑ์ภายใน', 'ภาพส่วนสุขภัณฑ์และอ่างล้างมือภายในอาคาร', 'https://npa.sam.or.th/site/images/npa/19784/3A1139P6_67.jpg', '/listing-media/sam/3a1139/06.webp', 'image/webp', 10400, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำและบันได', 'ภาพห้องน้ำและบันไดภายในอาคารพาณิชย์ 3 ชั้น', 'https://npa.sam.or.th/site/images/npa/19784/3A1139P7_67.jpg', '/listing-media/sam/3a1139/07.webp', 'image/webp', 10400, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่เปิดชั้นบน', 'ภาพพื้นที่เปิดโล่งบนชั้นบนพร้อมช่องเปิดรับแสง', 'https://npa.sam.or.th/site/images/npa/19784/3A1139P8_67.jpg', '/listing-media/sam/3a1139/08.webp', 'image/webp', 8030, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องกว้างบนชั้นบน', 'ภาพห้องกว้างพร้อมหน้าต่างและประตูภายในชั้นบน', 'https://npa.sam.or.th/site/images/npa/19784/3A1139P9_67.jpg', '/listing-media/sam/3a1139/09.webp', 'image/webp', 9282, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงชั้นบนและเสากลาง', 'ภาพโถงเปิดชั้นบนของอาคาร 2 คูหาที่มีเสากลาง', 'https://npa.sam.or.th/site/images/npa/19784/3A1139P10_67.jpg', '/listing-media/sam/3a1139/10.webp', 'image/webp', 8748, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บันไดภายในอาคาร', 'ภาพบันไดเชื่อมชั้นภายในอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/19784/3A1139P11_67.jpg', '/listing-media/sam/3a1139/11.webp', 'image/webp', 9994, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่เปิดอีกมุม', 'ภาพพื้นที่เปิดอีกมุมบนชั้นบนของอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/19784/3A1139P12_67.jpg', '/listing-media/sam/3a1139/12.webp', 'image/webp', 6934, 450, 450, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องภายในชั้นบน', 'ภาพห้องภายในชั้นบนพร้อมหน้าต่างและประตู', 'https://npa.sam.or.th/site/images/npa/19784/3A1139P13_67.jpg', '/listing-media/sam/3a1139/13.webp', 'image/webp', 7788, 450, 450, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องสว่างภายในอาคาร', 'ภาพห้องภายในที่มีช่องรับแสงหลายด้าน', 'https://npa.sam.or.th/site/images/npa/19784/3A1139P14_67.jpg', '/listing-media/sam/3a1139/14.webp', 'image/webp', 7532, 450, 450, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงและช่องบันได', 'ภาพโถงภายในพร้อมช่องบันไดและเสากลาง', 'https://npa.sam.or.th/site/images/npa/19784/3A1139P15_67.jpg', '/listing-media/sam/3a1139/15.webp', 'image/webp', 8956, 450, 450, 150, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำภายในอาคาร', 'ภาพห้องน้ำภายในอาคารพาณิชย์จากชุดภาพ SAM', 'https://npa.sam.or.th/site/images/npa/19784/3A1139P16_67.jpg', '/listing-media/sam/3a1139/16.webp', 'image/webp', 11028, 450, 450, 160, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่เปิดชั้นบนอีกส่วน', 'ภาพพื้นที่เปิดชั้นบนพร้อมช่องหน้าต่างและเสากลาง', 'https://npa.sam.or.th/site/images/npa/19784/3A1139P17_67.jpg', '/listing-media/sam/3a1139/17.webp', 'image/webp', 7474, 450, 450, 170, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่เคาน์เตอร์จากอีกมุม', 'ภาพพื้นที่เคาน์เตอร์และส่วนใช้งานด้านหลังจากอีกมุม', 'https://npa.sam.or.th/site/images/npa/19784/3A1139P18_67.jpg', '/listing-media/sam/3a1139/18.webp', 'image/webp', 11962, 450, 450, 180, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'เคาน์เตอร์ภายในชั้นล่าง', 'ภาพเคาน์เตอร์ยาวและพื้นที่ภายในชั้นล่าง', 'https://npa.sam.or.th/site/images/npa/19784/3A1139P19_67.jpg', '/listing-media/sam/3a1139/19.webp', 'image/webp', 9640, 450, 450, 190, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่หน้าร้านจากด้านใน', 'ภาพพื้นที่หน้าร้านมองออกไปยังประตูกระจกด้านหน้าอาคาร', 'https://npa.sam.or.th/site/images/npa/19784/3A1139P20_67.jpg', '/listing-media/sam/3a1139/20.webp', 'image/webp', 14810, 450, 450, 200, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังอาคารพาณิชย์ 2 คูหา', 'ผังต้นทางแสดงอาคารเลขที่ 108/147 และ 108/148 จำนวน 2 คูหาเจาะถึงกันและถนนโดยรอบ', 'https://npa.sam.or.th/site/images/npa/19784/20210923150620_3A1139C1_64.jpg', '/listing-media/sam/3a1139/21.webp', 'image/webp', 18164, 450, 450, 210, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปถนนอนามัย', 'แผนที่ต้นทางแสดงเส้นทางจากถนนศรีจันทร์เข้าถนนอนามัยไปยังทรัพย์ 3A1139', 'https://npa.sam.or.th/site/images/npa/19784/20210923150620_3A1139M1_64.jpg', '/listing-media/sam/3a1139/22.webp', 'image/webp', 24010, 785, 600, 220, false, true);

    INSERT INTO public.listing_sources (
        listing_id, source_type, publisher_name, source_url,
        reference_code, captured_at, notes
    ) VALUES (
        property_listing_id,
        'editorial_import',
        'บริษัท บริหารสินทรัพย์สุขุมวิท จำกัด (SAM)',
        'https://www.sam.or.th/site/npa/detail.php?id=19784&keyref=6004430',
        '3A1139',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA page id 19784. The page showed direct-purchase status and an announced sale price of THB 10,088,000 for two internally connected three-storey shophouses numbered 108/147-148 on Anamai Road, Nai Mueang, Mueang Khon Kaen. One title deed numbered 274419 covers 40.1 sq.wah / 160.4 sq.m. SAM describes a rectangular plot with two road frontages, east and west sides each approximately eight metres wide and a depth of approximately twenty metres. Anamai Road is described as a public asphalt road approximately eight metres wide within an approximately ten-metre right of way. The page, gallery filenames, address and registered building description consistently use reference 3A1139 and building numbers 108/147-148; no material internal code or building-number discrepancy was identified. The source identifies pink zoning and residential-commercial surroundings. MapxProp therefore classifies the property as mixed use for both homes and business discovery, subject to verification of permitted use and the connected-building alterations. The source links a property video at https://www.youtube.com/watch?v=cqDcszuoyXA. Usable area, room counts, parking, age, utilities, occupancy and other encumbrances are not published. Property photos display 21 February 2024. Administrator coordinates are approximately 0.24 metres from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all twenty-two unique source exterior, interior, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Two Connected Three-Storey Shophouses on Anamai Road, Khon Kaen, THB 10.088M',
        E'Two internally connected three-storey shophouses numbered 108/147-148 on Anamai Road, Nai Mueang, Mueang Khon Kaen. Title deed 274419 covers 40.1 sq.wah (160.4 sq.m.). SAM shows pink planning zoning and describes residential-commercial surroundings.\n\nSAM describes the rectangular plot as fronting two roads, with east and west sides each approximately eight metres wide and a depth of approximately twenty metres. The source plan shows the two three-storey units connected internally. Buyers must verify the title deed, survey, plot shape, boundaries, both road frontages, access, building positions, approved plans and connecting alterations before offering.\n\nAnamai Road is described as a public asphalt road approximately eight metres wide within an approximately ten-metre right of way. Buyers should verify the road status, access rights, boundaries, turning space, parking and restrictions affecting the frontage.\n\nMapxProp classifies the shophouses as mixed use so they can be discovered in both homes and business, with residential, retail and office use cases. This does not guarantee residential use or every commercial activity. Buyers must verify current pink-zone planning rules, approved building use, the connected-unit alterations, licences, parking, signage, fire escape and fire safety.\n\nNearby places named by SAM include Khon Kaen Central Prison, Khon Kaen Provincial Public Health Office and Sirindhorn College of Public Health Khon Kaen. Directions use Srichan Road from Khon Kaen Regional Hospital toward the City Pillar Shrine, pass the central prison, then turn left onto Anamai Road for approximately 120 metres; the property is on the right opposite the Provincial Public Health Office.\n\nThe SAM page listed the property for direct purchase at an announced THB 10,088,000 when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, offer procedures, current price, promotions, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. MapxProp does not collect deposits or represent SAM.\n\nThe SAM page links a property video on YouTube. Property photos display 21 February 2024, and conditions may have changed. The source does not publish usable area, bedroom or bathroom counts, parking, building age, utility specifications or occupancy. Buyers should inspect the structure, roof, stairs, the inter-unit connections, fire escape, cracks, moisture, termites, utilities, bathrooms, fire safety, possession, encumbrances, taxes, costs and every current term before deciding.',
        '108/147-148',
        'Two connected three-storey shophouses',
        'Anamai Road',
        'Nai Mueang',
        'Mueang Khon Kaen',
        'Khon Kaen',
        'SAM Two Connected Mixed-Use Shophouses, Anamai Road, THB 10.088M',
        'Official SAM 3A1139: two connected three-storey mixed-use shophouses on 160.4 sq.m. in central Khon Kaen. Direct-sale price THB 10.088M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset 3A1139 two connected three storey mixed use shophouses 108/147-148 Anamai Road Nai Mueang Mueang Khon Kaen title deed 274419 40.1 sq.wah 160.4 sq.m. THB 10088000 pink zoning two road frontages')
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
        SELECT 1 FROM public.organization_verifications
        WHERE organization_id = sam_organization_id
          AND verification_type = 'listing_authority'
          AND status = 'verified'
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=19784&keyref=6004430'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=19784&keyref=6004430',
            'The official SAM NPA page identifies SAM as direct-sale contact for asset 3A1139. The page, property gallery, address and registered building description are internally consistent for two connected three-storey units 108/147-148. Buyers must independently confirm the title, both road frontages, connecting alterations, possession and latest terms.',
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
        'e7fee466-d3e9-4845-9741-835109e964bf',
        jsonb_build_object(
            'reference_code', '3A1139',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'mixed',
            'discovery_channels', jsonb_build_array('homes', 'business'),
            'title_document_count', 1,
            'unit_count', 2,
            'connected_units', true,
            'two_road_frontages_reported', true,
            'source_reference_discrepancy', false,
            'building_number_discrepancy', false,
            'plot_measurement_discrepancy', false,
            'mixed_use_review_required', true,
            'source_image_count', 22,
            'source_video_available', true
        )
    );
END $$;

COMMIT;
