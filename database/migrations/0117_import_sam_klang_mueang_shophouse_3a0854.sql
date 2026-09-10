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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing 3A0854';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing 3A0854';
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
        '2d090539-c30d-4dea-a960-4b1a6c0fd505',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'shophouse',
        'mixed',
        'sale',
        'whole_property',
        '140/16',
        'ขายตรง SAM อาคารพาณิชย์ 2 ชั้น ถนนกลางเมือง ใกล้บึงแก่นนคร 22 ตร.ว. ราคา 2.863 ล้านบาท',
        E'อาคารพาณิชย์ 2 ชั้น ถนนกลางเมือง (เจนจบทิศ) ตำบลเมืองเก่า อำเภอเมืองขอนแก่น จังหวัดขอนแก่น บนโฉนดที่ดินเลขที่ 75398 จำนวน 1 ฉบับ เนื้อที่ 22 ตร.ว. (88 ตร.ม.) หน้า SAM ระบุเขตพื้นที่สีชมพูและย่านโดยรอบเป็นทั้งที่อยู่อาศัยและพาณิชยกรรม\n\nสำคัญ—ข้อมูลเลขที่อาคารไม่ตรงกันภายในหน้าต้นทาง: ส่วนที่อยู่แสดงเลขที่ 140/16-18 รายการรับโอนกรรมสิทธิ์บนโฉนดระบุเป็นตึกแถว 2 ชั้น เลขที่ 140/16 ส่วนข้อมูลสำรวจระบุอาคารพาณิชย์ 2 ชั้น “ไม่ติดเลขที่” ผู้ซื้อต้องให้ SAM สำนักงานที่ดิน และหน่วยงานท้องถิ่นยืนยันว่าเลขที่ใด อาคารส่วนใด และสิ่งปลูกสร้างใดรวมอยู่ในการขายและการโอน\n\nสำคัญ—ข้อมูลหน้ากว้างไม่ตรงกัน: ช่องสรุปบนหน้า SAM แสดงหน้ากว้างติดถนน 12 เมตรและลึกสุด 22 เมตร แต่รายละเอียดทรัพย์และผังแปลงแสดงด้านทิศตะวันออกติดถนนกว้างประมาณ 4 เมตร ลึกประมาณ 22 เมตร MapxProp ไม่เลือกยืนยันตัวเลขใดแทน SAM ผู้ซื้อต้องตรวจโฉนด รังวัด รูปแปลง แนวเขต หน้ากว้าง ความลึก ทางเข้าออก และตำแหน่งอาคารจริงก่อนเสนอซื้อ\n\nสำคัญ—รหัสในชุดภาพไม่ตรงกับรหัสหน้าประกาศ: หน้า SAM ระบุรหัสทรัพย์ 3A0854 แต่ชื่อไฟล์ภาพและผังทั้งหมดใช้รหัส 3A0584 แม้ชุดภาพจะถูกเผยแพร่บนหน้าทรัพย์ id 18835 นี้ ผู้ซื้อควรขอให้ SAM ยืนยันเป็นลายลักษณ์อักษรว่าภาพอาคาร ภาพภายใน ผังแปลง และแผนที่เป็นของทรัพย์ 3A0854 ก่อนตัดสินใจ\n\nถนนผ่านหน้าทรัพย์คือถนนกลางเมือง ซึ่ง SAM ระบุว่าเป็นทางสาธารณประโยชน์ ผิวจราจรลาดยางกว้างประมาณ 20 เมตร เขตทางกว้างประมาณ 40 เมตร ควรตรวจแนวเขตทาง ทางเข้าออก จุดกลับรถ ที่จอดรถ และข้อจำกัดการใช้พื้นที่หน้าทรัพย์กับหน่วยงานที่เกี่ยวข้อง\n\nMapxProp จัดอาคารพาณิชย์นี้เป็น Mixed Use เพื่อให้ค้นพบได้ทั้งหมวดที่อยู่อาศัยและธุรกิจ เหมาะสำหรับพิจารณาเป็นที่พักอาศัย หน้าร้าน หรือสำนักงานตามลักษณะอาคารและข้อความย่านที่อยู่อาศัย–พาณิชยกรรมของ SAM แต่การจัดหมวดไม่ใช่การรับรองการใช้ประโยชน์ ผู้ซื้อต้องตรวจผังเมืองสีชมพู การใช้อาคาร ใบอนุญาต ป้าย ที่จอดรถ ทางหนีไฟ ระบบดับเพลิง และใบอนุญาตกิจการ\n\nสถานที่สำคัญที่ SAM ระบุ ได้แก่ พระมหาธาตุแก่นนคร บึงแก่นนคร และบิ๊กซี ซูเปอร์เซ็นเตอร์ ขอนแก่น สาขา 2 การเดินทางตาม SAM ใช้ถนนมิตรภาพจากอำเภอบ้านไผ่มุ่งหน้าเมืองขอนแก่น ช่วง กม.331-332 เข้าถนนเลี่ยงเมืองขอนแก่น (ทล.230) ฝั่งขวา ผ่านทางรถไฟสายตะวันออกเฉียงเหนือ แล้วเลี้ยวซ้ายเข้าถนนกลางเมืองประมาณ 1.25 กิโลเมตร ทรัพย์อยู่ด้านซ้ายมือ\n\nหน้า SAM แสดงสถานะ “ซื้อตรง” และราคาประกาศขาย 2,863,000 บาท ไม่ใช่การประมูลในสถานะที่ตรวจสอบเมื่อวันที่ 10 กันยายน 2569 ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย รหัสทรัพย์ที่ถูกต้อง ความสัมพันธ์ของชุดภาพ ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะการครอบครอง และวิธีจำหน่ายล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nภาพภายในต้นทางแสดงวันที่ 7 สิงหาคม 2564 สภาพจริงอาจเปลี่ยนแปลง และหน้า SAM ไม่ได้เผยแพร่พื้นที่ใช้สอย จำนวนห้องนอน ห้องน้ำ ที่จอดรถ อายุอาคาร ระบบไฟฟ้า-ประปา หรือสถานะการครอบครอง ผู้ซื้อควรนัดตรวจโครงสร้าง หลังคา บันได ทางหนีไฟ รอยร้าว ความชื้น ปลวก ระบบไฟฟ้าและประปา ห้องน้ำ ระบบดับเพลิง การครอบครอง ภาระผูกพัน ภาษี ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        2863000,
        false,
        88,
        2,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'ตามหน้า SAM: 140/16-18; รายการทะเบียน: 140/16',
        'ติดถนนกลางเมือง (เจนจบทิศ)',
        'กลางเมือง (เจนจบทิศ)',
        NULL,
        16.396333606257564,
        102.82923801892402,
        'ขอนแก่น',
        'เมืองขอนแก่น',
        'เมืองเก่า',
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
        'sam-direct-sale-mixed-use-shophouse-klang-mueang-khon-kaen-3a0854'
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
        property_listing_id, 'sale', 2863000, 'total', 'THB', false
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
            'official_page_reference_code', '3A0854',
            'source_gallery_filename_reference_code', '3A0584',
            'source_reference_code_discrepancy', true,
            'source_page_id', 18835,
            'source_address_display', '140/16-18',
            'registered_building_number', '140/16',
            'surveyed_building_number_status', 'ไม่ติดเลขที่',
            'building_number_discrepancy', true,
            'title_document_type', 'chanote',
            'title_deed_number', '75398',
            'title_document_count', 1,
            'land_area_rai', 0,
            'land_area_ngan', 0,
            'land_area_square_wah_remainder', 22,
            'land_area_square_wah', 22,
            'land_area_sqm', 88,
            'plot_count', 1,
            'unit_count', 1,
            'registered_transfer_description', 'ตึกแถว 2 ชั้น เลขที่ 140/16',
            'surveyed_building_description', 'อาคารพาณิชย์ 2 ชั้น ไม่ติดเลขที่',
            'registered_floor_count', 2,
            'plot_shape', 'rectangle',
            'summary_road_frontage_m', 12,
            'detail_east_road_frontage_m_approx', 4,
            'site_plan_road_frontage_m_approx', 4,
            'maximum_depth_m_approx', 22,
            'road_frontage_measurement_discrepancy', true
        ) || jsonb_build_object(
            'front_road_name', 'ถนนกลางเมือง (เจนจบทิศ)',
            'front_road_legal_status_th', 'ทางสาธารณประโยชน์',
            'front_road_surface', 'asphalt',
            'front_road_width_m_approx', 20,
            'front_right_of_way_width_m_approx', 40,
            'zoning_color_th', 'สีชมพู ตามหน้า SAM',
            'surrounding_area_use_th', 'ย่านที่อยู่อาศัยและพาณิชยกรรม',
            'mixed_use_classification', true,
            'mixed_use_basis', 'อาคารพาณิชย์ในย่านที่อยู่อาศัยและพาณิชยกรรม เหมาะพิจารณาใช้เป็นที่อยู่อาศัย หน้าร้าน หรือสำนักงาน โดยต้องตรวจการใช้อาคารและใบอนุญาต',
            'approved_use_requires_independent_verification', true,
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
            'computed_price_per_square_wah', 130136.36,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_interior_photo_date_displayed', '2021-08-07',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '16.396386,102.829118',
            'administrator_coordinate_distance_from_source_m_approx', 14.07
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
        'The official SAM NPA page identifies SAM as the asset holder and direct-sale contact for page reference 3A0854. The gallery filenames use 3A0584, so buyers must confirm the image-to-asset relationship directly with SAM. MapxProp does not collect deposits or represent SAM.',
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
        (property_listing_id, 'ถนนกลางเมือง (เจนจบทิศ)', 'Klang Mueang Road (Jenchop Thit)', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'พระมหาธาตุแก่นนคร', 'Phra Mahathat Kaen Nakhon', 'landmark', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'บึงแก่นนคร', 'Bueng Kaen Nakhon', 'landmark', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'บิ๊กซี ซูเปอร์เซ็นเตอร์ ขอนแก่น สาขา 2', 'Big C Supercenter Khon Kaen 2', 'shopping', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'ถนนมิตรภาพ', 'Mittraphap Road', 'road', NULL, NULL, NULL, 50, false),
        (property_listing_id, 'ถนนเลี่ยงเมืองขอนแก่น (ทล.230)', 'Khon Kaen Bypass Highway 230', 'road', NULL, NULL, NULL, 60, false),
        (property_listing_id, 'ทางรถไฟสายตะวันออกเฉียงเหนือ', 'Northeastern Railway', 'transit', NULL, NULL, NULL, 70, false)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '2,863,000 บาท — โปรดตรวจสอบราคาล่าสุดและโปรโมชั่นกับ SAM', 'THB 2,863,000 — confirm the latest price and promotions with SAM', 'unspecified', 2863000, 'THB', 20),
        (property_listing_id, 'source_reference_discrepancy', 'รหัสทรัพย์กับรหัสภาพไม่ตรงกัน', 'Asset and gallery code discrepancy', 'หน้าประกาศระบุ 3A0854 แต่ชื่อไฟล์ภาพและผังใช้ 3A0584 ต้องให้ SAM ยืนยันว่าชุดภาพเป็นของทรัพย์นี้', 'The page lists 3A0854 while gallery and plan filenames use 3A0584; SAM must confirm that the gallery belongs to this asset', 'buyer', NULL, '', 30),
        (property_listing_id, 'building_number_discrepancy', 'เลขที่อาคารไม่ตรงกัน', 'Building-number discrepancy', 'ส่วนที่อยู่แสดง 140/16-18 รายการทะเบียนระบุ 140/16 และผลสำรวจระบุไม่ติดเลขที่ ต้องยืนยันอาคารและสิ่งปลูกสร้างที่จะโอน', 'The address shows 140/16-18, the registered record shows 140/16 and the survey says no number is attached; confirm the building and transferred structures', 'buyer', NULL, '', 40),
        (property_listing_id, 'plot_measurement_discrepancy', 'หน้ากว้างแปลงไม่ตรงกัน', 'Plot-frontage discrepancy', 'ช่องสรุประบุ 12 เมตร แต่รายละเอียดและผังระบุประมาณ 4 เมตร โดยทั้งสองส่วนระบุความลึกราว 22 เมตร ต้องตรวจโฉนดและรังวัด', 'The summary states twelve metres, while the detail and site plan state about four metres; both state a depth around twenty-two metres. Verify the title and survey', 'buyer', NULL, '', 50),
        (property_listing_id, 'public_road', 'ถนนหน้าทรัพย์', 'Frontage road', 'ถนนกลางเมืองเป็นทางสาธารณประโยชน์ ผิวลาดยางกว้างประมาณ 20 เมตร เขตทางประมาณ 40 เมตร', 'Klang Mueang Road is described as a public asphalt road approximately twenty metres wide in a forty-metre right of way', 'unspecified', 20, 'metres', 60),
        (property_listing_id, 'mixed_use_due_diligence', 'การใช้งานแบบผสม', 'Mixed-use due diligence', 'MapxProp แสดงทั้งหมวดที่อยู่อาศัยและธุรกิจ แต่ผู้ซื้อต้องตรวจผังเมือง การใช้อาคาร ใบอนุญาต ที่จอดรถ ป้าย ทางหนีไฟ และระบบดับเพลิง', 'MapxProp shows the property in both homes and business; buyers must verify planning, approved use, licences, parking, signage, fire escape and fire safety', 'buyer', NULL, '', 70),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ยืนยันรหัสทรัพย์กับชุดภาพ เลขที่อาคาร หน้ากว้าง โฉนด รังวัด แนวเขต ทะเบียนอาคาร สภาพภายใน การครอบครอง ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Confirm the asset-to-gallery code, building number, frontage, title, survey, boundaries, building record, interior, possession, encumbrances, costs and latest terms', 'buyer', NULL, '', 80)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ด้านหน้าอาคารพาณิชย์บนถนนกลางเมือง', 'อาคารพาณิชย์ 2 ชั้นบนถนนกลางเมืองจากหน้าทรัพย์ SAM id 18835 ซึ่งชื่อไฟล์ภาพใช้รหัส 3A0584', 'https://npa.sam.or.th/site/images/npa/18835/20251212113058_3A0584P4_64_cleanup.jpg', '/listing-media/sam/3a0854/01.webp', 'image/webp', 25062, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ภายในชั้นบน', 'ภาพพื้นที่ชั้นบน หน้าต่าง และบันไดภายในอาคารพาณิชย์จากชุดภาพต้นทาง', 'https://npa.sam.or.th/site/images/npa/18835/3A0584P5_64.jpg', '/listing-media/sam/3a0854/02.webp', 'image/webp', 13600, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ภายในส่วนหลัง', 'ภาพพื้นที่ภายในและช่องทางเข้าส่วนหลังของอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/18835/3A0584P6_64.jpg', '/listing-media/sam/3a0854/03.webp', 'image/webp', 14398, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่เปิดชั้นล่าง', 'ภาพโถงเปิดภายในชั้นล่างมองออกไปยังประตูด้านหน้าอาคาร', 'https://npa.sam.or.th/site/images/npa/18835/3A0584P7_64.jpg', '/listing-media/sam/3a0854/04.webp', 'image/webp', 14044, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ชั้นล่างอีกมุม', 'ภาพพื้นที่ชั้นล่างภายในอาคารพาณิชย์จากมุมด้านหน้าไปส่วนหลัง', 'https://npa.sam.or.th/site/images/npa/18835/3A0584P8_64.jpg', '/listing-media/sam/3a0854/05.webp', 'image/webp', 12392, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังแปลงและอาคารพาณิชย์', 'ผังต้นทางแสดงแปลงโฉนดเลขที่ 75398 หน้ากว้างประมาณ 4 เมตร ลึกประมาณ 22 เมตร และอาคารพาณิชย์ 2 ชั้น', 'https://npa.sam.or.th/site/images/npa/18835/20260108092231_3A0584C1_68.jpg', '/listing-media/sam/3a0854/06.webp', 'image/webp', 13066, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปถนนกลางเมือง', 'แผนที่ต้นทางแสดงเส้นทางถนนมิตรภาพ ถนนเลี่ยงเมือง และถนนกลางเมืองไปยังทรัพย์ id 18835', 'https://npa.sam.or.th/site/images/npa/18835/20210129170028_3A0584M1_64.jpg', '/listing-media/sam/3a0854/07.webp', 'image/webp', 35366, 785, 600, 70, false, true);

    INSERT INTO public.listing_sources (
        listing_id, source_type, publisher_name, source_url,
        reference_code, captured_at, notes
    ) VALUES (
        property_listing_id,
        'editorial_import',
        'บริษัท บริหารสินทรัพย์สุขุมวิท จำกัด (SAM)',
        'https://www.sam.or.th/site/npa/detail.php?id=18835&keyref=6004425',
        '3A0854',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA page id 18835. The page showed direct-purchase status and an announced sale price of THB 2,863,000 for a two-storey shophouse on Klang Mueang Road, Mueang Kao, Mueang Khon Kaen. Title deed 75398 covers 22 sq.wah / 88 sq.m. Three material source discrepancies are preserved. First, the official page reference is 3A0854 while every gallery and plan filename uses 3A0584. Second, the address display is 140/16-18, the registered acquisition record identifies shophouse 140/16 and the survey describes a two-storey commercial building without an attached number. Third, the summary states twelve metres of road frontage and twenty-two metres depth, while the detailed description and source plan state approximately four metres of eastern road frontage and approximately twenty-two metres depth. Buyers must obtain direct SAM confirmation of the asset-gallery relationship, building identity and surveyed dimensions before offering. Klang Mueang Road is described as a public asphalt road approximately twenty metres wide within an approximately forty-metre right of way. The source identifies pink planning zoning and residential-commercial surroundings. MapxProp classifies the property as mixed use for both homes and business discovery, subject to verification of permitted use. Usable area, rooms, parking, age, utilities, occupancy and other encumbrances are not published. Interior photos display 7 August 2021. Administrator coordinates are approximately 14.07 metres from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all seven unique source exterior, interior, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Two-Storey Shophouse on Klang Mueang Road, Khon Kaen, THB 2.863M',
        E'Two-storey shophouse on Klang Mueang Road (Jenchop Thit), Mueang Kao, Mueang Khon Kaen. Title deed 75398 covers 22 sq.wah (88 sq.m.). SAM shows pink planning zoning and describes residential-commercial surroundings.\n\nImportant building-number discrepancy: the address section shows 140/16-18, the registered acquisition record identifies a two-storey shophouse numbered 140/16, and the survey describes a two-storey commercial building without an attached number. Buyers must ask SAM, the Land Office and local authorities to confirm the exact building, number and structures included in transfer.\n\nImportant frontage discrepancy: the SAM summary states twelve metres of road frontage and a maximum depth of twenty-two metres, while the detailed description and site plan show approximately four metres of eastern road frontage and approximately twenty-two metres depth. MapxProp does not choose one figure as authoritative. Buyers must verify the title deed, survey, plot shape, boundaries, frontage, depth, access and building position before offering.\n\nImportant gallery-code discrepancy: the SAM page identifies asset 3A0854, while all published gallery and plan filenames use 3A0584. Although the images appear on official page id 18835, buyers should obtain written confirmation from SAM that the building, interior, plan and map images belong to asset 3A0854.\n\nKlang Mueang Road is described as a public asphalt road approximately twenty metres wide within an approximately forty-metre right of way. MapxProp classifies the shophouse as mixed use so it can be discovered in both homes and business, with residential, retail and office use cases. This does not guarantee residential use or every commercial activity. Buyers must verify current planning, approved building use, licences, parking, signage, fire escape and fire safety.\n\nNearby places named by SAM include Phra Mahathat Kaen Nakhon, Bueng Kaen Nakhon and Big C Supercenter Khon Kaen 2. Directions use Mittraphap Road from Ban Phai toward Khon Kaen, Highway 230, the Northeastern Railway and Klang Mueang Road for approximately 1.25 kilometres; the property is on the left.\n\nThe SAM page listed the property for direct purchase at an announced THB 2,863,000 when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, the correct asset code, the gallery relationship, offer procedures, current price, promotions, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. MapxProp does not collect deposits or represent SAM.\n\nInterior photos display 7 August 2021, and conditions may have changed. The source does not publish usable area, bedroom or bathroom counts, parking, building age, utility specifications or occupancy. Buyers should inspect the structure, roof, stairs, fire escape, cracks, moisture, termites, utilities, bathrooms, fire safety, possession, encumbrances, taxes, costs and every current term before deciding.',
        'Source address 140/16-18; registered building 140/16',
        'Fronting Klang Mueang Road (Jenchop Thit)',
        'Klang Mueang Road (Jenchop Thit)',
        'Mueang Kao',
        'Mueang Khon Kaen',
        'Khon Kaen',
        'SAM Mixed-Use Shophouse on Klang Mueang Road, THB 2.863M',
        'Official SAM page 3A0854: two-storey mixed-use shophouse on 88 sq.m. in Mueang Kao. Direct-sale price THB 2.863M; source discrepancies disclosed.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset 3A0854 gallery code 3A0584 two storey mixed use shophouse 140/16 140/16-18 Klang Mueang Jenchop Thit Road Mueang Kao Mueang Khon Kaen title deed 75398 22 sq.wah 88 sq.m. THB 2863000 source discrepancy')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=18835&keyref=6004425'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=18835&keyref=6004425',
            'The official SAM NPA page identifies SAM as direct-sale contact for page asset code 3A0854. The page itself contains discrepancies: gallery filenames use 3A0584, address and registered/surveyed building numbers differ, and summary versus detailed frontage measurements differ. These discrepancies are prominently disclosed and require direct SAM confirmation.',
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
        '2d090539-c30d-4dea-a960-4b1a6c0fd505',
        jsonb_build_object(
            'reference_code', '3A0854',
            'gallery_filename_reference_code', '3A0584',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'mixed',
            'discovery_channels', jsonb_build_array('homes', 'business'),
            'title_document_count', 1,
            'source_reference_discrepancy', true,
            'building_number_discrepancy', true,
            'frontage_measurement_discrepancy', true,
            'mixed_use_review_required', true,
            'source_image_count', 7
        )
    );
END $$;

COMMIT;
