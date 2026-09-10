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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing 8Z4420';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing 8Z4420';
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
        'be19e9d2-325c-46b1-910e-05bf1809580d',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'shophouse',
        'mixed',
        'sale',
        'whole_property',
        NULL,
        '9/386, 9/387, 9/388',
        'ขายตรง SAM อาคารพาณิชย์ 3 คูหา 3 ชั้นครึ่ง ซอยสะแกงาม 35/1 บางขุนเทียน ราคา 7.419 ล้านบาท',
        E'อาคารพาณิชย์ 3 คูหา เลขที่ 9/386, 9/387 และ 9/388 ถนนสะแกงาม แขวงแสมดำ เขตบางขุนเทียน กรุงเทพมหานคร โฉนดที่ดินเลขที่ 140315, 140316 และ 140317 จำนวน 3 ฉบับ เนื้อที่รวม 63 ตร.ว. (252 ตร.ม.) หน้า SAM ระบุเขตสีส้ม

ที่ดิน 3 แปลงติดต่อกันเป็นรูปสี่เหลี่ยมผืนผ้า ด้านทิศตะวันตกติดถนน หน้ากว้างประมาณ 12 เมตร ลึกประมาณ 21 เมตร SAM ระบุสิ่งปลูกสร้างที่รับโอนกรรมสิทธิ์เป็นตึกแถว 3 ชั้นครึ่ง จำนวน 3 คูหา ถนนผ่านหน้าทรัพย์คือซอยสะแกงาม 35/1 ซึ่งเป็นทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว ผิวจราจรคอนกรีตกว้างประมาณ 10 เมตร เขตทางกว้างประมาณ 12 เมตร

หน้า SAM ระบุว่าทรัพย์อยู่ในย่านที่อยู่อาศัย และมีข้อสังเกตสำคัญเรื่องการเชื่อมภายใน: ชั้นล่างของทั้ง 3 คูหาไม่ทะลุถึงกัน แต่ชั้นลอย ชั้น 2 และชั้น 3 เจาะทะลุถึงกัน มีบันไดขึ้นลงทางเดียวผ่านห้องเลขที่ 9/387 และไม่สามารถขึ้นจากชั้น 2 ไปชั้น 3 ได้เพราะแนวทางขึ้นบันไดมีปัญหาตามข้อความต้นทาง ผู้ซื้อต้องตรวจสภาพจริง ตรวจแบบอาคาร ใบอนุญาต การเจาะเชื่อม โครงสร้าง และทางหนีไฟก่อนเสนอซื้อ

หน้า SAM ไม่ได้เผยแพร่พื้นที่ใช้สอย จำนวนห้องนอน จำนวนห้องน้ำ ที่จอดรถ อายุอาคาร หรือรายละเอียดระบบไฟฟ้าและประปา ผู้ซื้อควรให้ SAM สำนักงานเขต และสำนักงานที่ดินยืนยันทะเบียนอาคาร จำนวนชั้น ชั้นลอย การเจาะเชื่อม การใช้อาคาร ระบบดับเพลิง และรายการที่จะโอน

MapxProp จัดอาคารพาณิชย์ประเภทตึกแถวเป็น Mixed Use เพื่อให้ค้นพบได้ทั้งหมวดที่อยู่อาศัยและธุรกิจ โดยมีข้อมูลต้นทางประกอบว่าทรัพย์อยู่ในย่านที่อยู่อาศัย อย่างไรก็ตาม การจัดหมวดนี้ไม่ใช่การรับรองว่าสามารถพักอาศัยหรือประกอบกิจการทุกประเภทได้ ผู้ซื้อต้องตรวจผังเมืองเขตสีส้ม การใช้อาคาร ป้าย ที่จอดรถ ระบบดับเพลิง และใบอนุญาตสำหรับกิจการที่ต้องการ

การเดินทางตาม SAM ใช้ถนนพระรามที่ 2 จากสุขสวัสดิ์มุ่งหน้าสมุทรสาคร ผ่านบิ๊กซีซูเปอร์เซ็นเตอร์และเทสโก้โลตัส เลี้ยวซ้ายเข้าถนนสะแกงามประมาณ 2 กิโลเมตร จากนั้นเลี้ยวซ้ายเข้าซอยสะแกงาม 35/1 ประมาณ 125 เมตร จะพบทรัพย์อยู่ด้านขวามือ

หน้า SAM แสดงสถานะ “ซื้อตรง” และราคาประกาศขาย 7,419,000 บาท ไม่ใช่การประมูลในสถานะที่ตรวจสอบเมื่อวันที่ 10 กันยายน 2569 ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะการครอบครอง และวิธีจำหน่ายล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ 8Z4420 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM

ภาพทรัพย์ต้นทางแสดงวันที่ 5 มีนาคม 2566 และสภาพจริงอาจเปลี่ยนแปลง ภาพแสดงด้านหน้า พื้นที่ภายใน ห้องน้ำ ห้องหลายชั้น บันได ทางเข้าโครงการ ผังแปลง และแผนที่ ผู้ซื้อควรนัดตรวจโครงสร้าง หลังคา ชั้นลอย การเจาะเชื่อม บันได รอยร้าว การรั่วซึม ความชื้น ปลวก ห้องน้ำ ระบบไฟฟ้า ประปา ระบบดับเพลิง การครอบครอง ภาระผูกพัน ภาษี ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        7419000,
        false,
        252,
        3,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'อาคารพาณิชย์เลขที่ 9/386, 9/387 และ 9/388',
        'ซอยสะแกงาม 35/1 ถนนสะแกงาม',
        'ซอยสะแกงาม 35/1',
        NULL,
        13.63456048,
        100.42702420,
        'กรุงเทพมหานคร',
        'บางขุนเทียน',
        'แสมดำ',
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
        'sam-direct-sale-three-shophouses-sakae-ngam-bang-khun-thian-8z4420'
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
        property_listing_id, 'sale', 7419000, 'total', 'THB', false
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
            'title_document_numbers', jsonb_build_array('140315', '140316', '140317'),
            'title_document_count', 3,
            'land_area_rai', 0,
            'land_area_ngan', 0,
            'land_area_square_wah_remainder', 63,
            'land_area_square_wah', 63,
            'land_area_sqm', 252,
            'plot_count', 3,
            'unit_count', 3,
            'building_numbers', jsonb_build_array('9/386', '9/387', '9/388'),
            'registered_building_type_th', 'ตึกแถว',
            'registered_storeys', 3.5,
            'displayed_full_storeys', 3,
            'mezzanine_reported', true,
            'ground_floor_units_connected', false,
            'upper_floor_internal_openings_reported', true,
            'single_stair_access_via_unit', '9/387',
            'second_to_third_floor_access_issue_reported', true,
            'usable_area_not_published', true,
            'bedroom_count_not_published', true,
            'bathroom_count_not_published', true,
            'parking_space_count_not_published', true,
            'building_age_not_published', true,
            'plot_shape', 'rectangle',
            'west_frontage_m_approx', 12,
            'maximum_depth_m_approx', 21
        ) || jsonb_build_object(
            'address_road_name', 'ถนนสะแกงาม',
            'access_soi_name', 'ซอยสะแกงาม 35/1',
            'access_road_in_licensed_subdivision', true,
            'access_road_surface', 'concrete',
            'access_carriageway_width_m_approx', 10,
            'access_right_of_way_width_m_approx', 12,
            'zoning_color_th', 'เขตสีส้ม ตามหน้า SAM',
            'source_reports_residential_area', true,
            'mixed_use_classification', true,
            'mixed_use_classification_basis', 'MapxProp จัดอาคารพาณิชย์ประเภทตึกแถวเป็นการใช้งานผสมเพื่อการค้นหา และต้นทางระบุว่าทรัพย์อยู่ในย่านที่อยู่อาศัย โดยผู้ซื้อต้องตรวจการใช้อาคารที่อนุญาตจริง',
            'intended_use_requires_independent_verification', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'computed_price_per_square_wah', 117761.90,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_information_date_not_published', true,
            'source_property_photo_date_displayed', '2023-03-05',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '13.634551,100.427075',
            'administrator_coordinate_distance_from_source_m_approx', 5.59
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z4420. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนพระรามที่ 2', 'Rama II Road', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'บิ๊กซีซูเปอร์เซ็นเตอร์', 'Big C Supercenter', 'shopping', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'เทสโก้โลตัส', 'Tesco Lotus', 'shopping', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'ถนนสะแกงาม', 'Sakae Ngam Road', 'road', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'ซอยสะแกงาม 35/1', 'Soi Sakae Ngam 35/1', 'road', NULL, NULL, NULL, 50, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '7,419,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 7,419,000 — confirm the latest price with SAM', 'unspecified', 7419000, 'THB', 20),
        (property_listing_id, 'title_document_due_diligence', 'การตรวจสอบเอกสารสิทธิ์', 'Title-document due diligence', 'โฉนดเลขที่ 140315, 140316 และ 140317 รวม 3 ฉบับ ต้องตรวจเลขที่ดิน ระวาง แนวเขต และความตรงกับพื้นที่จริง', 'Verify title deeds 140315, 140316 and 140317, including parcel numbers, survey sheets, boundaries and the actual site', 'buyer', 3, 'documents', 30),
        (property_listing_id, 'registered_structure', 'สิ่งปลูกสร้างตามรายการรับโอน', 'Registered acquisition structure', 'ตึกแถว 3 ชั้นครึ่ง 3 คูหา เลขที่ 9/386–9/388 ต้องยืนยันจำนวนชั้น ชั้นลอย แบบและรายการที่จะโอน', 'Three three-and-a-half-storey shophouses numbered 9/386–9/388; verify storeys, mezzanines, plans and transfer inventory', 'buyer', 3.5, 'storeys', 40),
        (property_listing_id, 'internal_connection_and_stair', 'การเจาะเชื่อมและบันได', 'Internal openings and stair', 'ชั้นล่างไม่เชื่อมกัน ชั้นลอย ชั้น 2 และชั้น 3 เจาะทะลุ มีบันไดทางเดียวผ่าน 9/387 และต้นทางระบุปัญหาทางขึ้นจากชั้น 2 ไปชั้น 3 ต้องตรวจจริง', 'Ground floors are separate; mezzanine, second and third floors have openings, with one stair via 9/387 and a reported second-to-third-floor access issue requiring inspection', 'buyer', 3, 'units', 50),
        (property_listing_id, 'access_road', 'ถนนผ่านหน้าทรัพย์', 'Frontage road', 'ซอยสะแกงาม 35/1 เป็นทางในโครงการจัดสรรที่ได้รับอนุญาต ผิวคอนกรีตกว้างประมาณ 10 ม. เขตทางประมาณ 12 ม. ต้องตรวจสิทธิและสภาพจริง', 'Soi Sakae Ngam 35/1 is reported as a road in a licensed subdivision, with an approximately 10 m concrete carriageway and 12 m right-of-way; verify rights and actual condition', 'buyer', 12, 'meters', 60),
        (property_listing_id, 'mixed_use_review', 'การใช้เพื่ออยู่อาศัยและธุรกิจ', 'Residential and business use review', 'MapxProp จัดตึกแถวเป็น Mixed Use เพื่อการค้นหา แต่ผู้ซื้อต้องตรวจผังเมือง การใช้อาคาร ระบบดับเพลิง ที่จอดรถ ป้าย และใบอนุญาตสำหรับการใช้งานที่ต้องการ', 'MapxProp classifies the shophouses as mixed use for discovery, but buyers must verify planning, approved use, fire safety, parking, signage and licences', 'buyer', NULL, '', 70),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจอาคารทั้ง 3 คูหา โครงสร้าง ชั้นลอย การเจาะเชื่อม บันได ทางหนีไฟ หลังคา ความชื้น ระบบไฟฟ้า ประปา การครอบครอง ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Inspect all three units, structure, mezzanines, openings, stairs, fire escape, roofs, moisture, utilities, possession, encumbrances, costs and current terms', 'buyer', NULL, '', 80)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'อาคารพาณิชย์ 3 คูหา ซอยสะแกงาม', 'ภาพด้านหน้าอาคารพาณิชย์ SAM รหัส 8Z4420 จำนวน 3 คูหา เลขที่ 9/386–9/388', 'https://npa.sam.or.th/site/images/npa/12259/20260106095512_8Z4420P2_66.jpg', '/listing-media/sam/8z4420/01.webp', 'image/webp', 28010, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ด้านหน้าอาคารอีกมุม', 'ภาพด้านหน้าและแนวอาคารพาณิชย์ 3 คูหาจากอีกมุมหนึ่ง', 'https://npa.sam.or.th/site/images/npa/12259/8Z4420P3_66.jpg', '/listing-media/sam/8z4420/02.webp', 'image/webp', 25724, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ชั้นล่างคูหาแรก', 'ภาพพื้นที่เปิดภายในชั้นล่างของอาคารพาณิชย์ SAM 8Z4420', 'https://npa.sam.or.th/site/images/npa/12259/8Z4420P4_66.jpg', '/listing-media/sam/8z4420/03.webp', 'image/webp', 13864, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ชั้นล่างและชั้นลอย', 'ภาพภายในชั้นล่างพร้อมพื้นที่ชั้นลอยของอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/12259/8Z4420P5_66.jpg', '/listing-media/sam/8z4420/04.webp', 'image/webp', 11132, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเดินภายในอาคาร', 'ภาพทางเดินและประตูภายในอาคารพาณิชย์ 3 คูหา', 'https://npa.sam.or.th/site/images/npa/12259/8Z4420P6_66.jpg', '/listing-media/sam/8z4420/05.webp', 'image/webp', 10154, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บันไดและโถงภายใน', 'ภาพบันไดหลักและโถงภายในอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/12259/8Z4420P7_66.jpg', '/listing-media/sam/8z4420/06.webp', 'image/webp', 15406, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำภายในอาคาร', 'ภาพห้องน้ำและสุขภัณฑ์ภายในอาคารพาณิชย์ SAM 8Z4420', 'https://npa.sam.or.th/site/images/npa/12259/8Z4420P8_66.jpg', '/listing-media/sam/8z4420/07.webp', 'image/webp', 15794, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องภายในชั้นบน', 'ภาพห้องภายในชั้นบนพร้อมหน้าต่างและทางเข้าห้องน้ำ', 'https://npa.sam.or.th/site/images/npa/12259/8Z4420P9_66.jpg', '/listing-media/sam/8z4420/08.webp', 'image/webp', 14832, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ห้องพร้อมช่องเปิด', 'ภาพพื้นที่ห้องภายในพร้อมช่องเปิดและพื้นกระเบื้อง', 'https://npa.sam.or.th/site/images/npa/12259/8Z4420P10_66.jpg', '/listing-media/sam/8z4420/09.webp', 'image/webp', 18978, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงภายในขนาดใหญ่', 'ภาพโถงภายในอาคารพาณิชย์พร้อมหน้าต่างรับแสง', 'https://npa.sam.or.th/site/images/npa/12259/8Z4420P11_66.jpg', '/listing-media/sam/8z4420/10.webp', 'image/webp', 16716, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องและประตูเชื่อม', 'ภาพห้องภายในและประตูบริเวณส่วนเชื่อมระหว่างพื้นที่', 'https://npa.sam.or.th/site/images/npa/12259/8Z4420P12_66.jpg', '/listing-media/sam/8z4420/11.webp', 'image/webp', 13540, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องด้านหน้าชั้นบน', 'ภาพห้องด้านหน้าชั้นบนพร้อมหน้าต่างหลายบาน', 'https://npa.sam.or.th/site/images/npa/12259/8Z4420P13_66.jpg', '/listing-media/sam/8z4420/12.webp', 'image/webp', 12266, 450, 450, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ช่องทางเดินแคบภายใน', 'ภาพช่องทางเดินและทางเชื่อมภายในอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/12259/8Z4420P14_66.jpg', '/listing-media/sam/8z4420/13.webp', 'image/webp', 14684, 450, 450, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บันไดอีกช่วงหนึ่ง', 'ภาพบันไดคอนกรีตภายในที่ต้องตรวจแนวทางขึ้นและสภาพจริง', 'https://npa.sam.or.th/site/images/npa/12259/8Z4420P15_66.jpg', '/listing-media/sam/8z4420/14.webp', 'image/webp', 18258, 450, 450, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ชั้นล่างอีกคูหา', 'ภาพพื้นที่ภายในชั้นล่างอีกคูหาพร้อมส่วนกั้นด้านข้าง', 'https://npa.sam.or.th/site/images/npa/12259/8Z4420P16_66.jpg', '/listing-media/sam/8z4420/15.webp', 'image/webp', 13648, 450, 450, 150, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้าซอยสะแกงาม 35/1', 'ภาพจุดทางเข้าซอยสะแกงาม 35/1 ไปยังทรัพย์ SAM 8Z4420', 'https://npa.sam.or.th/site/images/npa/12259/8Z4420P1_63.JPG', '/listing-media/sam/8z4420/16.webp', 'image/webp', 36712, 450, 450, 160, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังที่ดิน 3 แปลงติดต่อกัน', 'ผังต้นทางแสดงโฉนด 140315, 140316 และ 140317 รวม 63 ตารางวา', 'https://npa.sam.or.th/site/images/npa/12259/20170703144730_8Z4420C1_60.jpg', '/listing-media/sam/8z4420/17.webp', 'image/webp', 9074, 450, 450, 170, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังอาคารพาณิชย์ 3 คูหา', 'ผังต้นทางแสดงตำแหน่งตึกแถว 3 ชั้นครึ่ง 3 คูหาบนที่ดินทั้ง 3 แปลง', 'https://npa.sam.or.th/site/images/npa/12259/20170703144730_8Z4420C2_60.jpg', '/listing-media/sam/8z4420/18.webp', 'image/webp', 16078, 450, 450, 180, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปทรัพย์', 'แผนที่ต้นทางแสดงเส้นทางจากถนนพระรามที่ 2 ผ่านถนนสะแกงามและซอยสะแกงาม 35/1 ไปยัง 8Z4420', 'https://npa.sam.or.th/site/images/npa/12259/20170703144730_8Z4420M1_60.jpg', '/listing-media/sam/8z4420/19.webp', 'image/webp', 37854, 785, 600, 190, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=12259&keyref=6004389',
        '8Z4420',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 7,419,000 for three shophouses numbered 9/386, 9/387 and 9/388 in Samae Dam, Bang Khun Thian, Bangkok. Three contiguous title deeds numbered 140315, 140316 and 140317 cover 63 sq.wah / 252 sq.m. The rectangular land has approximately twelve metres of western road frontage and a maximum depth of approximately twenty-one metres. The source lists three three-and-a-half-storey shophouses. Ground floors are not connected, while the mezzanine, second and third floors have internal openings; one stair serves the units through 9/387, and SAM reports an access issue between the second and third floors. Soi Sakae Ngam 35/1 is reported as a concrete road in a licensed subdivision, with approximately ten metres of carriageway and twelve metres of right-of-way. SAM shows orange zoning and says the property is in a residential area; MapxProp classifies the shophouses as mixed use for discovery in both homes and business, subject to verification of approved use. Usable area, room counts, parking, age and utility specifications are not published. Source property photos display 5 March 2023. Administrator coordinates are approximately 5.59 metres from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all nineteen unique source property, interior, access, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Three Connected 3.5-Storey Shophouses in Bang Khun Thian, THB 7.419M',
        E'Three shophouses numbered 9/386, 9/387 and 9/388 on Sakae Ngam Road, Samae Dam, Bang Khun Thian, Bangkok. Title deeds 140315, 140316 and 140317 cover a combined 63 sq.wah (252 sq.m.). SAM shows orange planning zoning.

The three contiguous plots form a rectangle with approximately twelve metres of western road frontage and a maximum depth of approximately twenty-one metres. SAM records three three-and-a-half-storey shophouses. Soi Sakae Ngam 35/1 is described as a road in a licensed subdivision, with an approximately ten-metre concrete carriageway and twelve-metre right-of-way.

SAM reports an important internal-layout issue. The three ground floors do not connect, while the mezzanine, second and third floors have openings between units. There is one stair through unit 9/387, and the source says access from the second to the third floor is unavailable because of a stair-route issue. Buyers must inspect the actual condition and verify plans, permits, structural openings, stair and fire escape arrangements before offering.

The source does not publish usable area, bedroom or bathroom counts, parking, building age, or electrical and plumbing specifications. Buyers should ask SAM, the district office and the Land Office to verify storeys, mezzanines, structural openings, plans, permits, approved building use, fire safety and everything included in transfer.

SAM states that the property is in a residential area. MapxProp classifies the shophouses as mixed use so they can be discovered in both homes and business. This classification does not guarantee residential use or every commercial use. Buyers must confirm current orange-zone planning, approved building use, signage, parking, fire safety and licences for the intended use.

SAM directions use Rama II Road from Suksawat toward Samut Sakhon, passing Big C Supercenter and Tesco Lotus, then turning left onto Sakae Ngam Road for approximately two kilometres. Turn left into Soi Sakae Ngam 35/1 for approximately 125 metres; the property is on the right.

The SAM page listed the property for direct purchase at an announced THB 7,419,000 when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, offer procedures, current price, promotions, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: 8Z4420. MapxProp does not collect deposits or represent SAM in the transaction.

Source property photos display 5 March 2023 and conditions may have changed. Buyers should inspect all three units, structure, roofs, mezzanines, internal openings, stairs, cracks, leaks, moisture, termites, bathrooms, electrical and plumbing systems, fire safety, possession, encumbrances, taxes, costs and every current term before deciding.',
        'Shophouses 9/386–9/388 on Soi Sakae Ngam 35/1',
        'Sakae Ngam Road, Samae Dam, Bang Khun Thian',
        'Soi Sakae Ngam 35/1',
        'Samae Dam',
        'Bang Khun Thian',
        'Bangkok',
        'SAM Three Shophouses in Bang Khun Thian, THB 7.419M',
        'Official SAM NPA asset 8Z4420: three connected 3.5-storey mixed-use shophouses on 252 sq.m. in Bang Khun Thian. Direct-sale price THB 7.419M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset 8Z4420 three connected three and a half storey mixed use shophouses 9/386 9/387 9/388 Sakae Ngam 35/1 Samae Dam Bang Khun Thian Bangkok title deeds 140315 140316 140317 63 sq.wah 252 sq.m. THB 7419000 mezzanine internal openings stair issue')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=12259&keyref=6004389'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=12259&keyref=6004389',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z4420. Specifications, title deeds, storeys, connected-unit layout, stair-access warning, images, rounded coordinates, announced price, direct-purchase status, road details, planning-zone wording and residential-area context come from that record.',
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
        'be19e9d2-325c-46b1-910e-05bf1809580d',
        jsonb_build_object(
            'reference_code', '8Z4420',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'mixed',
            'discovery_channels', jsonb_build_array('homes', 'business'),
            'title_document_count', 3,
            'unit_count', 3,
            'registered_storeys', 3.5,
            'connected_units_review_required', true,
            'stair_access_review_required', true,
            'access_road_review_required', true,
            'source_image_count', 19
        )
    );
END $$;

COMMIT;
