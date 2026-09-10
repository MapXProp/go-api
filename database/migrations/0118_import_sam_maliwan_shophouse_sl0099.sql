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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing SL0099';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing SL0099';
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
        'a3c6c9ce-2961-4b1a-9ed2-09e22b651b47',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'shophouse',
        'mixed',
        'sale',
        'whole_property',
        '153',
        'ขายตรง SAM อาคารพาณิชย์ 3 ชั้น มุมถนน 2 ด้าน ใกล้ มข. 26.4 ตร.ว. ราคา 2.564 ล้านบาท',
        E'อาคารพาณิชย์ 3 ชั้น ตำบลบ้านเป็ด อำเภอเมืองขอนแก่น จังหวัดขอนแก่น บนโฉนดที่ดินเลขที่ 22016 จำนวน 1 ฉบับ เนื้อที่ 26.4 ตร.ว. (105.6 ตร.ม.) อยู่ในซอยจากถนนมะลิวัลย์ (ทล.12) และ SAM ระบุว่าที่ดินติดถนน 2 ด้านในย่านที่อยู่อาศัยและพาณิชยกรรม\n\nสำคัญ—ข้อมูลเลขที่อาคารไม่ตรงกันภายในหน้าต้นทาง: ส่วนที่อยู่และรายการรับโอนกรรมสิทธิ์ระบุเลขที่ 153 แต่ข้อมูลสำรวจระบุอาคารพาณิชย์ 3 ชั้นติดเลขที่ 153/2 ผู้ซื้อต้องให้ SAM สำนักงานที่ดิน และหน่วยงานท้องถิ่นยืนยันอาคาร เลขที่ และสิ่งปลูกสร้างที่จะรวมอยู่ในการขายและการโอน\n\nสำคัญ—คำอธิบายขนาดแปลงต่างกันตามบริบท: ช่องสรุปบนหน้า SAM แสดงหน้ากว้างติดถนน 6.2 เมตรและลึกสุด 17.5 เมตร ขณะที่รายละเอียดระบุว่าที่ดินติดถนน 2 ด้าน โดยด้านทิศตะวันตกกว้างประมาณ 6.2 เมตรและด้านทิศใต้กว้างประมาณ 17.5 เมตร จึงไม่ควรตีความ 17.5 เมตรเป็นความลึกเพียงอย่างเดียว ผู้ซื้อต้องตรวจโฉนด รังวัด รูปแปลง แนวเขต ถนนทั้งสองด้าน ทางเข้าออก และตำแหน่งอาคารจริงก่อนเสนอซื้อ\n\nสำคัญ—ชื่อไฟล์แผนที่ต้นทางมีรหัสเพิ่มเติม: หน้าและชุดภาพทรัพย์ใช้รหัส SL0099 แต่ชื่อไฟล์แผนที่การเดินทางมีข้อความ “3A2217” อยู่ในวงเล็บ แม้แผนที่จะถูกเผยแพร่บนหน้า SAM id 21887 ผู้ซื้อควรให้ SAM ยืนยันว่าแผนที่ดังกล่าวเป็นของทรัพย์ SL0099\n\nถนนด้านหน้าทรัพย์ SAM ระบุว่าเป็นทางสาธารณประโยชน์ ผิวจราจรลาดยางกว้างประมาณ 6 เมตร เขตทางประมาณ 10 เมตร ส่วนด้านทิศใต้ติดทางสาธารณประโยชน์ผิวคอนกรีตกว้างประมาณ 2.5 เมตร เขตทางประมาณ 3.5 เมตร รถยนต์เข้าออกได้แต่สวนทางกันไม่ได้ ควรตรวจสิทธิทาง เข้าออกจริง แนวเขตทาง การกลับรถ ที่จอดรถ และข้อจำกัดของรถขนาดใหญ่\n\nMapxProp จัดอาคารพาณิชย์นี้เป็น Mixed Use เพื่อให้ค้นพบได้ทั้งหมวดที่อยู่อาศัยและธุรกิจ เหมาะสำหรับพิจารณาเป็นที่พักอาศัย หน้าร้าน หรือสำนักงานตามลักษณะอาคารและข้อความย่านที่อยู่อาศัย–พาณิชยกรรมของ SAM แต่การจัดหมวดไม่ใช่การรับรองการใช้ประโยชน์ ผู้ซื้อต้องตรวจผังเมือง การใช้อาคาร ใบอนุญาต ป้าย ที่จอดรถ ทางหนีไฟ ระบบดับเพลิง และใบอนุญาตกิจการ\n\nสถานที่สำคัญที่ SAM ระบุ ได้แก่ มหาวิทยาลัยขอนแก่น ค่ายสีหราชเดโชไชย และท่าอากาศยานขอนแก่น การเดินทางตาม SAM ใช้ถนนมะลิวัลย์ (ทล.12) จากถนนมิตรภาพมุ่งหน้าอำเภอบ้านฝาง ผ่านมหาวิทยาลัยขอนแก่น การไฟฟ้าส่วนภูมิภาค และร้านอาหารลีลาวดี ถึงสี่แยกแล้วเลี้ยวซ้ายเข้าซอยประมาณ 530 เมตร ทรัพย์อยู่ด้านซ้ายมือ\n\nหน้า SAM แสดงสถานะ “ซื้อตรง” และราคาประกาศขาย 2,564,000 บาท ไม่ใช่การประมูลในสถานะที่ตรวจสอบเมื่อวันที่ 10 กันยายน 2569 ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะการครอบครอง และวิธีจำหน่ายล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nภาพทรัพย์ต้นทางแสดงวันที่ 24 พฤศจิกายน 2567 สภาพจริงอาจเปลี่ยนแปลง และหน้า SAM ไม่ได้เผยแพร่พื้นที่ใช้สอย จำนวนห้องนอน ห้องน้ำ ที่จอดรถ อายุอาคาร ระบบไฟฟ้า-ประปา หรือสถานะการครอบครอง ผู้ซื้อควรนัดตรวจโครงสร้าง หลังคา บันได ทางหนีไฟ รอยร้าว ความชื้น ปลวก ระบบไฟฟ้าและประปา ห้องน้ำ ระบบดับเพลิง การครอบครอง ภาระผูกพัน ภาษี ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        2564000,
        false,
        105.6,
        3,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'ตามหน้า SAM และรายการทะเบียน: 153; ผลสำรวจ: 153/2',
        'เข้าซอยจากถนนมะลิวัลย์ (ทล.12) ประมาณ 530 ม.',
        'มะลิวัลย์ (ทล.12)',
        NULL,
        16.439682490862573,
        102.79293183630432,
        'ขอนแก่น',
        'เมืองขอนแก่น',
        'บ้านเป็ด',
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
        'sam-direct-sale-mixed-use-shophouse-maliwan-ban-pet-khon-kaen-sl0099'
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
        property_listing_id, 'sale', 2564000, 'total', 'THB', false
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
            'official_page_reference_code', 'SL0099',
            'source_gallery_filename_reference_code', 'SL0099',
            'source_map_filename_additional_reference_code', '3A2217',
            'source_map_filename_reference_discrepancy', true,
            'source_page_id', 21887,
            'source_address_display', '153',
            'registered_building_number', '153',
            'surveyed_building_number', '153/2',
            'building_number_discrepancy', true,
            'title_document_type', 'chanote',
            'title_deed_number', '22016',
            'title_document_count', 1,
            'land_area_rai', 0,
            'land_area_ngan', 0,
            'land_area_square_wah_remainder', 26.4,
            'land_area_square_wah', 26.4,
            'land_area_sqm', 105.6,
            'plot_count', 1,
            'unit_count', 1,
            'registered_transfer_description', 'ตึกแถว 3 ชั้น เลขที่ 153',
            'surveyed_building_description', 'อาคารพาณิชย์ 3 ชั้น ติดเลขที่ 153/2',
            'registered_floor_count', 3,
            'plot_shape_th', 'รูปคล้ายสี่เหลี่ยมจัตุรัส',
            'summary_road_frontage_m', 6.2,
            'summary_maximum_depth_m', 17.5,
            'detail_west_side_width_m_approx', 6.2,
            'detail_south_side_width_m_approx', 17.5,
            'two_road_frontages_reported', true,
            'summary_depth_vs_detail_south_frontage_context_differs', true
        ) || jsonb_build_object(
            'access_from_road_name', 'ถนนมะลิวัลย์ (ทล.12)',
            'access_soi_distance_from_maliwan_m_approx', 530,
            'front_road_legal_status_th', 'ทางสาธารณประโยชน์',
            'front_road_surface', 'asphalt',
            'front_road_width_m_approx', 6,
            'front_right_of_way_width_m_approx', 10,
            'south_road_legal_status_th', 'ทางสาธารณประโยชน์',
            'south_road_surface', 'concrete',
            'south_road_width_m_approx', 2.5,
            'south_right_of_way_width_m_approx', 3.5,
            'south_road_vehicle_access', true,
            'south_road_cars_cannot_pass_each_other', true,
            'zoning_not_published', true,
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
            'computed_price_per_square_wah', 97121.21,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_photo_date_displayed', '2024-11-24',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '16.439684,102.792933',
            'administrator_coordinate_distance_from_source_m_approx', 0.21
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
        'The official SAM NPA page identifies SAM as the asset holder and direct-sale contact for asset SL0099. The page and property gallery use SL0099, while the navigation-map filename additionally contains 3A2217; buyers should confirm that map directly with SAM. MapxProp does not collect deposits or represent SAM.',
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
        (property_listing_id, 'ถนนมะลิวัลย์ (ทล.12)', 'Maliwan Road (Highway 12)', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'มหาวิทยาลัยขอนแก่น', 'Khon Kaen University', 'education', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'ค่ายสีหราชเดโชไชย', 'Si Harat Decho Chai Camp', 'landmark', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'ท่าอากาศยานขอนแก่น', 'Khon Kaen Airport', 'transit', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'ถนนมิตรภาพ', 'Mittraphap Road', 'road', NULL, NULL, NULL, 50, false),
        (property_listing_id, 'การไฟฟ้าส่วนภูมิภาค', 'Provincial Electricity Authority', 'government', NULL, NULL, NULL, 60, false)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '2,564,000 บาท — โปรดตรวจสอบราคาล่าสุดและโปรโมชั่นกับ SAM', 'THB 2,564,000 — confirm the latest price and promotions with SAM', 'unspecified', 2564000, 'THB', 20),
        (property_listing_id, 'building_number_discrepancy', 'เลขที่อาคารไม่ตรงกัน', 'Building-number discrepancy', 'ส่วนที่อยู่และรายการทะเบียนระบุ 153 แต่ผลสำรวจระบุ 153/2 ต้องยืนยันอาคารและสิ่งปลูกสร้างที่จะโอน', 'The address and registered record show 153, while the survey shows 153/2; confirm the exact building and transferred structures', 'buyer', NULL, '', 30),
        (property_listing_id, 'plot_dimension_context', 'บริบทขนาดแปลงและถนน 2 ด้าน', 'Plot-dimension and two-road context', 'ช่องสรุประบุหน้ากว้าง 6.2 เมตร ลึก 17.5 เมตร แต่รายละเอียดระบุด้านตะวันตก 6.2 เมตรและด้านใต้ 17.5 เมตรพร้อมติดถนน 2 ด้าน ต้องตรวจโฉนดและรังวัด', 'The summary states 6.2-metre frontage and 17.5-metre depth, while the detail describes west and south sides of those dimensions with two road frontages; verify the title and survey', 'buyer', NULL, '', 40),
        (property_listing_id, 'source_map_reference_discrepancy', 'รหัสเพิ่มเติมในชื่อไฟล์แผนที่', 'Additional code in map filename', 'หน้าและภาพทรัพย์ใช้ SL0099 แต่ชื่อไฟล์แผนที่มี “3A2217” ในวงเล็บ ต้องให้ SAM ยืนยันแผนที่', 'The page and property gallery use SL0099, while the map filename includes 3A2217 in parentheses; SAM should confirm the map', 'buyer', NULL, '', 50),
        (property_listing_id, 'public_road_access', 'ถนนสาธารณะ 2 ด้าน', 'Two public-road frontages', 'ด้านหน้าผิวลาดยางกว้างประมาณ 6 เมตร เขตทาง 10 เมตร; ด้านใต้ผิวคอนกรีตกว้างประมาณ 2.5 เมตร เขตทาง 3.5 เมตร รถเข้าออกได้แต่สวนทางไม่ได้', 'Front asphalt road about six metres wide in a ten-metre right of way; south concrete road about 2.5 metres wide in a 3.5-metre right of way, with vehicle access but no room for cars to pass', 'unspecified', NULL, '', 60),
        (property_listing_id, 'mixed_use_due_diligence', 'การใช้งานแบบผสม', 'Mixed-use due diligence', 'MapxProp แสดงทั้งหมวดที่อยู่อาศัยและธุรกิจ แต่ผู้ซื้อต้องตรวจผังเมือง การใช้อาคาร ใบอนุญาต ที่จอดรถ ป้าย ทางหนีไฟ และระบบดับเพลิง', 'MapxProp shows the property in both homes and business; buyers must verify planning, approved use, licences, parking, signage, fire escape and fire safety', 'buyer', NULL, '', 70),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ยืนยันเลขที่อาคาร แผนที่ ขนาดแปลง ถนนทั้งสองด้าน โฉนด รังวัด แนวเขต ทะเบียนอาคาร สภาพภายใน การครอบครอง ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Confirm the building number, map, plot dimensions, both roads, title, survey, boundaries, building record, interior, possession, encumbrances, costs and latest terms', 'buyer', NULL, '', 80)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ด้านหน้าอาคารพาณิชย์ 3 ชั้น', 'อาคารพาณิชย์ 3 ชั้นหมายเลขทรัพย์ SL0099 พร้อมเส้นประแสดงขอบเขตโดยประมาณจากภาพ SAM', 'https://npa.sam.or.th/site/images/npa/21887/20240808114336_SL0099P2_67.jpg', '/listing-media/sam/sl0099/01.webp', 'image/webp', 18154, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ประตูม้วนด้านหน้าทรัพย์', 'ภาพระยะใกล้ประตูม้วนและบริเวณด้านหน้าอาคารพาณิชย์ SL0099', 'https://npa.sam.or.th/site/images/npa/21887/SL0099P3_67.jpg', '/listing-media/sam/sl0099/02.webp', 'image/webp', 21276, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ภายในชั้นล่าง', 'พื้นที่เปิดภายในชั้นล่างของอาคารพาณิชย์มองไปยังส่วนหลัง', 'https://npa.sam.or.th/site/images/npa/21887/SL0099P4_67.jpg', '/listing-media/sam/sl0099/03.webp', 'image/webp', 12252, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บันไดและโถงภายใน', 'ภาพบันไดและโถงภายในอาคารพาณิชย์ 3 ชั้นจากชุดภาพ SAM', 'https://npa.sam.or.th/site/images/npa/21887/SL0099P5_67.jpg', '/listing-media/sam/sl0099/04.webp', 'image/webp', 8236, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงชั้นบนและบันได', 'ภาพโถงชั้นบน หน้าต่าง และบันไดภายในอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/21887/SL0099P6_67.jpg', '/listing-media/sam/sl0099/05.webp', 'image/webp', 10438, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเดินและห้องภายใน', 'ภาพทางเดิน หน้าต่าง และประตูห้องภายในอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/21887/SL0099P7_67.jpg', '/listing-media/sam/sl0099/06.webp', 'image/webp', 9160, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องภายในอาคาร', 'ภาพห้องภายในอาคารพาณิชย์จากชุดภาพต้นทาง SAM', 'https://npa.sam.or.th/site/images/npa/21887/SL0099P8_67.jpg', '/listing-media/sam/sl0099/07.webp', 'image/webp', 9870, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้าจากถนนมะลิวัลย์', 'ภาพแยกทางเข้าซอยจากถนนมะลิวัลย์ ทางหลวงหมายเลข 12 ไปยังทรัพย์ SL0099', 'https://npa.sam.or.th/site/images/npa/21887/SL0099P1_66.jpg', '/listing-media/sam/sl0099/08.webp', 'image/webp', 25168, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังแปลงติดทางสาธารณะ 2 ด้าน', 'ผังต้นทางแสดงแปลงหมายเลข 144 ด้านประมาณ 6.2 และ 17.5 เมตร ติดทางสาธารณประโยชน์ 2 ด้าน', 'https://npa.sam.or.th/site/images/npa/21887/20240808114336_SL0099C1_67.jpg', '/listing-media/sam/sl0099/09.webp', 'image/webp', 11324, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางจากถนนมะลิวัลย์', 'แผนที่ต้นทางบนหน้า SAM id 21887 แสดงเส้นทางจากถนนมะลิวัลย์ไปยังทรัพย์ โดยชื่อไฟล์มีรหัส 3A2217 เพิ่มเติม', 'https://npa.sam.or.th/site/images/npa/21887/20240808114336_SL0099M_66 (3A2217).jpg', '/listing-media/sam/sl0099/10.webp', 'image/webp', 40228, 785, 600, 100, false, true);

    INSERT INTO public.listing_sources (
        listing_id, source_type, publisher_name, source_url,
        reference_code, captured_at, notes
    ) VALUES (
        property_listing_id,
        'editorial_import',
        'บริษัท บริหารสินทรัพย์สุขุมวิท จำกัด (SAM)',
        'https://www.sam.or.th/site/npa/detail.php?id=21887&keyref=6004425',
        'SL0099',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA page id 21887. The page showed direct-purchase status and an announced sale price of THB 2,564,000 for a three-storey shophouse in Ban Pet, Mueang Khon Kaen, accessed from Maliwan Road (Highway 12). Title deed 22016 covers 26.4 sq.wah / 105.6 sq.m. Three source issues are prominently preserved. First, the page address and registered transfer record identify building 153, while the survey identifies commercial building 153/2. Second, the summary describes 6.2 metres of road frontage and 17.5 metres maximum depth, while the detail describes a roughly square plot with west and south sides of approximately 6.2 and 17.5 metres and says it fronts two roads. Third, the page and property gallery use SL0099, but the navigation-map filename additionally contains 3A2217 in parentheses. Buyers must obtain direct SAM confirmation of the exact building, title survey, plot dimensions, both road frontages and navigation map before offering. The front public asphalt road is described as approximately six metres wide within an approximately ten-metre right of way. The south public concrete road is approximately 2.5 metres wide within an approximately 3.5-metre right of way; vehicles can enter and exit, but cars cannot pass one another. The source does not publish zoning colour and describes residential-commercial surroundings. MapxProp classifies the property as mixed use for both homes and business discovery, subject to verification of permitted use. Usable area, room counts, parking, age, utilities, occupancy and other encumbrances are not published. Property photos display 24 November 2024. Administrator coordinates are approximately 0.21 metres from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all ten unique source exterior, interior, access, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Three-Storey Mixed-Use Shophouse near Maliwan Road, Khon Kaen, THB 2.564M',
        E'Three-storey shophouse in Ban Pet, Mueang Khon Kaen, accessed from Maliwan Road (Highway 12). Title deed 22016 covers 26.4 sq.wah (105.6 sq.m.). SAM says the plot fronts two roads and is in a residential-commercial area.\n\nImportant building-number discrepancy: the address section and registered acquisition record show building 153, while the survey describes a three-storey commercial building numbered 153/2. Buyers must ask SAM, the Land Office and local authorities to confirm the exact building, number and structures included in transfer.\n\nImportant dimension context: the SAM summary states 6.2 metres of road frontage and a maximum depth of 17.5 metres. The detailed description instead says the roughly square plot fronts two roads, with a west side approximately 6.2 metres wide and a south side approximately 17.5 metres wide. Buyers should not treat 17.5 metres only as depth without verifying the title, survey, plot shape, boundaries, both frontages, access and building position.\n\nImportant map-filename discrepancy: the page and property gallery use SL0099, while the navigation-map filename additionally contains 3A2217 in parentheses. Although that map is published on official page id 21887, buyers should obtain confirmation from SAM that it belongs to SL0099.\n\nSAM describes the front public road as asphalt, approximately six metres wide within a ten-metre right of way. The south public concrete road is approximately 2.5 metres wide within a 3.5-metre right of way; vehicles can enter and exit, but cars cannot pass each other. Buyers must verify public-road status, access rights, boundaries, turning space, parking and access for larger vehicles.\n\nMapxProp classifies the shophouse as mixed use so it can be discovered in both homes and business, with residential, retail and office use cases. This does not guarantee residential use or every commercial activity. Buyers must verify current planning, approved building use, licences, parking, signage, fire escape and fire safety.\n\nNearby places named by SAM include Khon Kaen University, Si Harat Decho Chai Camp and Khon Kaen Airport. Directions use Maliwan Road from Mittraphap Road toward Ban Fang, passing Khon Kaen University and the Provincial Electricity Authority, then turn left at an intersection and continue approximately 530 metres; the property is on the left.\n\nThe SAM page listed the property for direct purchase at an announced THB 2,564,000 when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, offer procedures, current price, promotions, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. MapxProp does not collect deposits or represent SAM.\n\nProperty photos display 24 November 2024, and conditions may have changed. The source does not publish usable area, bedroom or bathroom counts, parking, building age, utility specifications or occupancy. Buyers should inspect the structure, roof, stairs, fire escape, cracks, moisture, termites, utilities, bathrooms, fire safety, possession, encumbrances, taxes, costs and every current term before deciding.',
        'Source and registered building 153; surveyed building 153/2',
        'Approximately 530 m inside a soi from Maliwan Road (Highway 12)',
        'Maliwan Road (Highway 12)',
        'Ban Pet',
        'Mueang Khon Kaen',
        'Khon Kaen',
        'SAM Mixed-Use Shophouse near Maliwan Road, THB 2.564M',
        'Official SAM SL0099: three-storey mixed-use shophouse on 105.6 sq.m. in Ban Pet. Direct-sale price THB 2.564M; source discrepancies disclosed.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset SL0099 map filename 3A2217 three storey mixed use shophouse 153 153/2 Maliwan Highway 12 Ban Pet Mueang Khon Kaen title deed 22016 26.4 sq.wah 105.6 sq.m. THB 2564000 two road frontages source discrepancy')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=21887&keyref=6004425'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=21887&keyref=6004425',
            'The official SAM NPA page identifies SAM as direct-sale contact for asset SL0099. The building number differs between the address/registered record and survey, the summary and detail frame the 17.5-metre dimension differently, and the navigation-map filename additionally contains 3A2217. These issues are prominently disclosed and require direct SAM confirmation.',
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
        'a3c6c9ce-2961-4b1a-9ed2-09e22b651b47',
        jsonb_build_object(
            'reference_code', 'SL0099',
            'map_filename_additional_reference_code', '3A2217',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'mixed',
            'discovery_channels', jsonb_build_array('homes', 'business'),
            'title_document_count', 1,
            'map_filename_reference_discrepancy', true,
            'building_number_discrepancy', true,
            'plot_dimension_context_difference', true,
            'mixed_use_review_required', true,
            'source_image_count', 10
        )
    );
END $$;

COMMIT;
