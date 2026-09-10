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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing SL0013';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing SL0013';
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
        bedroom_count,
        bathroom_count,
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
        '96f3061f-adf8-486f-b681-1379f3415669',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'shophouse',
        'mixed',
        'sale',
        'whole_property',
        'บ้านไทย',
        '337/13-16',
        'ขายตรง SAM อาคารพาณิชย์ 3 ชั้น 4 คูหา บ้านไทย 6 ห้องนอน 8 ห้องน้ำ ราคา 8.351 ล้านบาท',
        E'อาคารพาณิชย์ 3 ชั้น จำนวน 4 คูหา เลขที่ 337/13-16 ในโครงการบ้านไทย ตำบลศิลา อำเภอเมืองขอนแก่น จังหวัดขอนแก่น อยู่บนโฉนดเลขที่ 103165, 103166, 103167 และ 103168 รวม 4 ฉบับ เนื้อที่รวม 67.5 ตร.ว. (270 ตร.ม.) หน้า SAM ระบุรวม 6 ห้องนอน 8 ห้องน้ำ และเขตพื้นที่สีชมพู\n\nที่ดิน 4 แปลงติดกันเป็นรูปสี่เหลี่ยมผืนผ้า ติดถนน 2 ด้าน ด้านทิศตะวันออกกว้างประมาณ 18 เมตร ด้านทิศเหนือกว้างประมาณ 15 เมตร และลึกสุดประมาณ 16 เมตร ผู้ซื้อต้องตรวจโฉนด รังวัด รูปแปลง แนวเขต ถนนทั้งสองด้าน ทางเข้าออก และตำแหน่งอาคารจริงก่อนเสนอซื้อ\n\nข้อควรตรวจสำคัญ: เลขอาคารที่จดทะเบียนรับโอนกับเลขที่สำรวจของ SAM สลับกันทั้ง 4 โฉนด ได้แก่ โฉนด 103165 จดทะเบียนเลขที่ 337/13 แต่สำรวจเป็น 337/16, โฉนด 103166 จดทะเบียน 337/14 แต่สำรวจเป็น 337/15, โฉนด 103167 จดทะเบียน 337/15 แต่สำรวจเป็น 337/14 และโฉนด 103168 จดทะเบียน 337/16 แต่สำรวจเป็น 337/13 ผู้ซื้อต้องให้ SAM และสำนักงานที่ดินยืนยันว่าแต่ละโฉนดสัมพันธ์กับอาคารและตำแหน่งใด รวมถึงตรวจทะเบียนอาคาร แบบแปลน ใบอนุญาต เลขที่บ้าน และรายการสิ่งปลูกสร้างที่จะโอนให้ตรงกับสภาพจริง\n\nทรัพย์ติดถนนหมู่บ้านบ้านไทย (ซอย 2) ซึ่ง SAM ระบุว่าเป็นถนนในโครงการจัดสรรที่ได้รับอนุญาต ผิวคอนกรีตกว้างประมาณ 6 เมตร เขตทางประมาณ 12 เมตร ส่วนที่อยู่ต้นทางใช้ชื่อถนนมิตรภาพ (ทล.2) แต่เส้นทางเข้าจริงจากถนนมิตรภาพผ่านซอยอินทจักรแล้วเข้าสู่ถนนหมู่บ้านบ้านไทย รวมประมาณ 335 เมตร จึงไม่ควรเข้าใจว่าทรัพย์ติดถนนมิตรภาพโดยตรง\n\nMapxProp จัดอาคารพาณิชย์นี้เป็น Mixed Use เพื่อให้ค้นพบได้ทั้งหมวดที่อยู่อาศัยและธุรกิจ เนื่องจากเป็นอาคารพาณิชย์ที่ SAM ระบุ 6 ห้องนอน 8 ห้องน้ำ และพื้นที่โดยรอบเป็นย่านที่อยู่อาศัย เหมาะสำหรับพิจารณาเป็นที่พักอาศัย หน้าร้าน หรือสำนักงาน แต่การจัดหมวดไม่ใช่การรับรองการใช้ประโยชน์ ผู้ซื้อต้องตรวจผังเมืองสีชมพู การใช้อาคาร ใบอนุญาตกิจการ ป้าย ที่จอดรถ ทางเข้าออก ทางหนีไฟ และระบบดับเพลิงกับหน่วยงานที่เกี่ยวข้อง\n\nสถานที่ใกล้เคียงที่ SAM ระบุ ได้แก่ ที่ทำการไปรษณีย์ขอนแก่น สหกรณ์ออมทรัพย์ครูขอนแก่น วัดสว่างสุทธาราม แม็คโครขอนแก่น 3 และโลตัสขอนแก่น 2 การเดินทางตาม SAM ใช้ถนนมิตรภาพ (ทล.2) จากเซ็นทรัลขอนแก่น ผ่านโรงพยาบาลราชพฤกษ์ โรงพยาบาลศรีนครินทร์ มหาวิทยาลัยขอนแก่น โลตัสขอนแก่น 2 และที่ทำการไปรษณีย์ขอนแก่น แล้วเลี้ยวซ้ายเข้าซอยอินทจักร ก่อนเลี้ยวซ้ายเข้าถนนหมู่บ้านบ้านไทย ทรัพย์อยู่ด้านซ้ายมือ\n\nหน้า SAM แสดงสถานะ “ซื้อตรง” และราคาประกาศขาย 8,351,000 บาท ไม่ใช่การประมูลในสถานะที่ตรวจสอบเมื่อวันที่ 10 กันยายน 2569 ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะการครอบครอง และวิธีจำหน่ายล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ SL0013 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nภาพทรัพย์ต้นทางแสดงวันที่ 12 มิถุนายน 2567 สภาพจริงอาจเปลี่ยนแปลง หน้า SAM ไม่ได้เผยแพร่พื้นที่ใช้สอย ที่จอดรถ อายุอาคาร รายละเอียดระบบไฟฟ้า-ประปา สถานะการครอบครอง หรือภาระผูกพันอื่น ผู้ซื้อควรนัดตรวจทั้ง 4 คูหา ภายในทุกชั้น โครงสร้าง หลังคา บันได ทางหนีไฟ รอยร้าว ความชื้น ปลวก ระบบไฟฟ้าและประปา ห้องน้ำ การระบายน้ำ น้ำท่วม การครอบครอง ภาระผูกพัน ภาษี ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        8351000,
        false,
        270,
        6,
        8,
        3,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        '337/13-16 หมู่บ้านบ้านไทย',
        'ติดถนนหมู่บ้านบ้านไทย (ซอย 2); เข้าจากถนนมิตรภาพผ่านซอยอินทจักรประมาณ 335 ม.',
        'ถนนหมู่บ้านบ้านไทย (ซอย 2)',
        NULL,
        16.50307023045034,
        102.82933567232101,
        'ขอนแก่น',
        'เมืองขอนแก่น',
        'ศิลา',
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
        'sam-direct-sale-mixed-use-four-shophouses-baan-thai-khon-kaen-sl0013'
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
        property_listing_id, 'sale', 8351000, 'total', 'THB', false
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
            'official_page_reference_code', 'SL0013',
            'source_gallery_filename_reference_code', 'SL0013',
            'source_reference_code_discrepancy', false,
            'source_page_id', 21568,
            'source_address_display', '337/13-16 ถนนมิตรภาพ (ทล.2) ตำบลศิลา อำเภอเมืองขอนแก่น จังหวัดขอนแก่น',
            'source_address_road_name', 'ถนนมิตรภาพ (ทล.2)',
            'registered_building_numbers', jsonb_build_array('337/13', '337/14', '337/15', '337/16'),
            'building_number_mapping_discrepancy', true,
            'title_document_type', 'chanote',
            'title_deed_numbers', jsonb_build_array('103165', '103166', '103167', '103168'),
            'title_document_count', 4,
            'land_area_rai', 0,
            'land_area_ngan', 0,
            'land_area_square_wah_remainder', 67.5,
            'land_area_square_wah', 67.5,
            'land_area_sqm', 270,
            'plot_count', 4,
            'contiguous_plots', true,
            'unit_count', 4,
            'registered_floor_count', 3,
            'bedroom_count_total', 6,
            'bathroom_count_total', 8,
            'connected_units_not_stated', true,
            'plot_shape', 'rectangle',
            'summary_road_frontage_m', 18,
            'summary_maximum_depth_m', 16,
            'detail_east_side_width_m_approx', 18,
            'detail_north_side_width_m_approx', 15,
            'detail_depth_m_approx', 16,
            'two_road_frontages_reported', true,
            'plot_measurement_discrepancy', false
        ) || jsonb_build_object(
            'deed_103165_registered_building_number', '337/13',
            'deed_103165_surveyed_building_number', '337/16',
            'deed_103166_registered_building_number', '337/14',
            'deed_103166_surveyed_building_number', '337/15',
            'deed_103167_registered_building_number', '337/15',
            'deed_103167_surveyed_building_number', '337/14',
            'deed_103168_registered_building_number', '337/16',
            'deed_103168_surveyed_building_number', '337/13',
            'registered_to_surveyed_building_mapping', jsonb_build_array(
                jsonb_build_object('title_deed_number', '103165', 'registered_building_number', '337/13', 'surveyed_building_number', '337/16'),
                jsonb_build_object('title_deed_number', '103166', 'registered_building_number', '337/14', 'surveyed_building_number', '337/15'),
                jsonb_build_object('title_deed_number', '103167', 'registered_building_number', '337/15', 'surveyed_building_number', '337/14'),
                jsonb_build_object('title_deed_number', '103168', 'registered_building_number', '337/16', 'surveyed_building_number', '337/13')
            ),
            'mapping_requires_land_office_confirmation', true,
            'front_road_name', 'ถนนหมู่บ้านบ้านไทย (ซอย 2)',
            'front_road_legal_status_th', 'ถนนในโครงการจัดสรรที่ได้รับอนุญาต',
            'front_road_surface', 'concrete',
            'front_road_width_m_approx', 6,
            'front_right_of_way_width_m_approx', 12,
            'direct_mittraphap_frontage', false,
            'access_from_mittraphap_via_soi_inthachak_m_approx', 335,
            'zoning_color_th', 'เขตสีชมพู ตามหน้า SAM',
            'surrounding_area_use_th', 'ย่านที่อยู่อาศัย',
            'mixed_use_classification', true,
            'mixed_use_basis', 'อาคารพาณิชย์ 4 คูหาที่ SAM ระบุรวม 6 ห้องนอน 8 ห้องน้ำ เหมาะพิจารณาใช้เป็นที่อยู่อาศัย หน้าร้าน หรือสำนักงาน โดยต้องตรวจการใช้อาคารและใบอนุญาต',
            'approved_use_requires_independent_verification', true,
            'usable_area_not_published', true,
            'parking_information_not_published', true,
            'building_age_not_published', true,
            'utilities_information_not_published', true,
            'occupancy_status_not_published', true,
            'other_encumbrances_not_published', true
        ) || jsonb_build_object(
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'computed_price_per_square_wah', 123718.52,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_photo_date_displayed', '2024-06-12',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '16.503058,102.829342',
            'administrator_coordinate_distance_from_source_m_approx', 1.52
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
        'The official SAM NPA page identifies SAM as the asset holder and direct-sale contact for asset SL0013. The page shows four title deeds and four three-storey shophouses, but the registered and surveyed building-number mapping differs across every deed. Buyers must confirm availability, each deed-to-building mapping, possession and every sale term directly with SAM. MapxProp does not collect deposits or represent SAM.',
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
        (property_listing_id, 'ถนนหมู่บ้านบ้านไทย (ซอย 2)', 'Baan Thai Village Road (Soi 2)', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ถนนมิตรภาพ (ทล.2)', 'Mittraphap Highway 2', 'road', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'ที่ทำการไปรษณีย์ขอนแก่น', 'Khon Kaen Post Office', 'government', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'สหกรณ์ออมทรัพย์ครูขอนแก่น', 'Khon Kaen Teachers Savings Cooperative', 'other', NULL, NULL, NULL, 40, false),
        (property_listing_id, 'วัดสว่างสุทธาราม', 'Wat Sawang Suttharam', 'landmark', NULL, NULL, NULL, 50, false),
        (property_listing_id, 'แม็คโครขอนแก่น 3', 'Makro Khon Kaen 3', 'shopping', NULL, NULL, NULL, 60, false),
        (property_listing_id, 'โลตัสขอนแก่น 2', 'Lotus Khon Kaen 2', 'shopping', NULL, NULL, NULL, 70, false),
        (property_listing_id, 'มหาวิทยาลัยขอนแก่น', 'Khon Kaen University', 'education', NULL, NULL, NULL, 80, false),
        (property_listing_id, 'โรงพยาบาลราชพฤกษ์', 'Ratchaphruek Hospital', 'healthcare', NULL, NULL, NULL, 90, false),
        (property_listing_id, 'โรงพยาบาลศรีนครินทร์', 'Srinagarind Hospital', 'healthcare', NULL, NULL, NULL, 100, false)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '8,351,000 บาท — โปรดตรวจสอบราคาล่าสุดและโปรโมชั่นกับ SAM', 'THB 8,351,000 — confirm the latest price and promotions with SAM', 'unspecified', 8351000, 'THB', 20),
        (property_listing_id, 'four_deeds_four_units', 'โฉนด 4 ฉบับ อาคาร 4 คูหา', 'Four deeds and four units', 'โฉนด 103165-103168 รวม 4 ฉบับ รองรับอาคารพาณิชย์ 3 ชั้น 4 คูหา ต้องยืนยันตำแหน่งแต่ละแปลงและอาคาร', 'Four title deeds, 103165-103168, correspond to four three-storey shophouses; confirm every plot and building position', 'buyer', 4, 'units', 30),
        (property_listing_id, 'building_number_mapping_discrepancy', 'เลขอาคารเทียบโฉนดไม่ตรงกัน', 'Deed-to-building number discrepancy', 'SAM ระบุเลขจดทะเบียนเทียบเลขสำรวจเป็น 103165: 337/13→337/16, 103166: 337/14→337/15, 103167: 337/15→337/14 และ 103168: 337/16→337/13 ต้องยืนยันกับ SAM และสำนักงานที่ดิน', 'SAM maps registered to surveyed numbers as 103165: 337/13→337/16, 103166: 337/14→337/15, 103167: 337/15→337/14 and 103168: 337/16→337/13; confirm with SAM and the Land Office', 'buyer', NULL, '', 40),
        (property_listing_id, 'two_road_frontages', 'ติดถนน 2 ด้าน', 'Two road frontages', 'SAM ระบุด้านตะวันออกกว้างประมาณ 18 เมตร ด้านเหนือประมาณ 15 เมตร และลึกสุดประมาณ 16 เมตร', 'SAM reports approximately 18 metres on the east side, 15 metres on the north side and a maximum depth of 16 metres', 'buyer', NULL, '', 50),
        (property_listing_id, 'subdivision_road', 'ถนนหน้าทรัพย์', 'Frontage road', 'ถนนหมู่บ้านบ้านไทย (ซอย 2) เป็นถนนโครงการจัดสรรที่ได้รับอนุญาต ผิวคอนกรีตกว้างประมาณ 6 เมตร เขตทางประมาณ 12 เมตร', 'Baan Thai Village Road (Soi 2) is described as an approved subdivision road with an approximately six-metre concrete carriageway and twelve-metre right of way', 'unspecified', 6, 'metres', 60),
        (property_listing_id, 'mixed_use_due_diligence', 'การใช้งานแบบผสม', 'Mixed-use due diligence', 'MapxProp แสดงทั้งหมวดที่อยู่อาศัยและธุรกิจจากประเภทอาคารและข้อมูล 6 ห้องนอน 8 ห้องน้ำ แต่ผู้ซื้อต้องตรวจผังเมือง การใช้อาคาร ใบอนุญาต ที่จอดรถ ป้าย ทางหนีไฟ และระบบดับเพลิง', 'MapxProp shows the property in both homes and business based on the building type and six-bedroom/eight-bathroom source data; buyers must verify planning, approved use, licences, parking, signage, fire escape and fire safety', 'buyer', NULL, '', 70),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ยืนยันโฉนดทั้ง 4 ฉบับ การจับคู่เลขอาคาร รังวัด แนวเขต ถนนทั้งสองด้าน อาคาร 4 คูหา สภาพภายใน การครอบครอง ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Confirm all four deeds, building-number mapping, survey, boundaries, both road frontages, four units, interior, possession, encumbrances, costs and latest terms', 'buyer', NULL, '', 80)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'อาคารพาณิชย์ 4 คูหา บ้านไทย', 'อาคารพาณิชย์ 3 ชั้น 4 คูหาเลขที่ 337/13-16 ในโครงการบ้านไทยจากภาพ SAM', 'https://npa.sam.or.th/site/images/npa/21568/20240606144112_SL0013P5_67.jpg', '/listing-media/sam/sl0013/01.webp', 'image/webp', 20782, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ด้านหน้าอาคารพาณิชย์มุมที่หนึ่ง', 'ภาพด้านหน้าอาคารพาณิชย์ 4 คูหาและแนวถนนหมู่บ้านบ้านไทยจาก SAM', 'https://npa.sam.or.th/site/images/npa/21568/SL0013P3_67.jpg', '/listing-media/sam/sl0013/02.webp', 'image/webp', 19438, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ด้านหน้าอาคารพาณิชย์มุมที่สอง', 'ภาพอาคารพาณิชย์ 3 ชั้น 4 คูหาจากอีกมุมหนึ่งของชุดภาพ SAM', 'https://npa.sam.or.th/site/images/npa/21568/SL0013P4_67.jpg', '/listing-media/sam/sl0013/03.webp', 'image/webp', 21320, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้าจากถนนมิตรภาพ', 'ภาพจุดเลี้ยวจากถนนมิตรภาพเข้าสู่ซอยอินทจักรตามเส้นทาง SAM', 'https://npa.sam.or.th/site/images/npa/21568/SL0013P1_67.jpg', '/listing-media/sam/sl0013/04.webp', 'image/webp', 17192, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้าโครงการบ้านไทย', 'ภาพทางเข้าโครงการบ้านไทยก่อนเข้าสู่ถนนหมู่บ้านบ้านไทย ซอย 2', 'https://npa.sam.or.th/site/images/npa/21568/SL0013P2_67.jpg', '/listing-media/sam/sl0013/05.webp', 'image/webp', 15454, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังที่ดินและขนาดแปลง', 'ผังต้นทาง SAM แสดงที่ดิน 4 แปลง อาคาร 4 คูหา ถนนสองด้าน และขนาดโดยประมาณ', 'https://npa.sam.or.th/site/images/npa/21568/20240606142441_SL0013C2_67.jpg', '/listing-media/sam/sl0013/06.webp', 'image/webp', 16928, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังอาคารและเลขที่ 4 คูหา', 'ผังต้นทาง SAM แสดงตำแหน่งอาคารพาณิชย์ 4 คูหาและเลขที่อาคารในโครงการบ้านไทย', 'https://npa.sam.or.th/site/images/npa/21568/20240606142441_SL0013C1_67.jpg', '/listing-media/sam/sl0013/07.webp', 'image/webp', 24998, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปโครงการบ้านไทย', 'แผนที่ต้นทาง SAM แสดงเส้นทางจากถนนมิตรภาพผ่านซอยอินทจักรไปยังทรัพย์ SL0013', 'https://npa.sam.or.th/site/images/npa/21568/20240606144112_SL0013M_67.jpg', '/listing-media/sam/sl0013/08.webp', 'image/webp', 53016, 785, 600, 80, false, true);

    INSERT INTO public.listing_sources (
        listing_id, source_type, publisher_name, source_url,
        reference_code, captured_at, notes
    ) VALUES (
        property_listing_id,
        'editorial_import',
        'บริษัท บริหารสินทรัพย์สุขุมวิท จำกัด (SAM)',
        'https://www.sam.or.th/site/npa/detail.php?id=21568&keyref=6004430',
        'SL0013',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA page id 21568. The page showed direct-purchase status and an announced sale price of THB 8,351,000 for four three-storey shophouses numbered 337/13-16 in Baan Thai, Sila, Mueang Khon Kaen. Four contiguous title deeds numbered 103165-103168 cover 67.5 sq.wah / 270 sq.m. The source lists six bedrooms and eight bathrooms in total. A material mapping discrepancy requires buyer verification: deed 103165 is registered with building 337/13 but surveyed as 337/16; deed 103166 is registered 337/14 but surveyed as 337/15; deed 103167 is registered 337/15 but surveyed as 337/14; and deed 103168 is registered 337/16 but surveyed as 337/13. Buyers must reconcile every deed, registered building entry, surveyed number and physical unit with SAM and the Land Office. SAM describes a rectangular property with two road frontages, approximately eighteen metres on the east, fifteen metres on the north and a maximum depth of sixteen metres. The actual frontage is Baan Thai Village Road Soi 2, described as an approved subdivision road with an approximately six-metre concrete carriageway and twelve-metre right of way. Although the source address names Mittraphap Highway 2, access is via Soi Inthachak and the village road for approximately 335 metres; the property does not directly front Mittraphap Highway. The source identifies pink zoning and residential surroundings. MapxProp classifies the shophouses as mixed use for both homes and business discovery because the source also lists six bedrooms and eight bathrooms, subject to independent confirmation of permitted use. Usable area, parking, age, utility specifications, occupancy and other encumbrances are not published. Property photos display 12 June 2024. Administrator coordinates are approximately 1.52 metres from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all eight unique source exterior, access, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Four Three-Storey Mixed-Use Shophouses in Baan Thai, Khon Kaen, THB 8.351M',
        E'Four three-storey shophouses numbered 337/13-16 in Baan Thai, Sila, Mueang Khon Kaen. Four contiguous title deeds numbered 103165-103168 cover 67.5 sq.wah (270 sq.m.). SAM lists six bedrooms and eight bathrooms in total and shows pink planning zoning.\n\nSAM describes the rectangular property as fronting two roads, with approximately eighteen metres on the east side, fifteen metres on the north side and a maximum depth of approximately sixteen metres. Buyers must verify all four deeds, survey, boundaries, measurements, both road frontages, access and building positions before offering.\n\nImportant building-record caveat: SAM shows a different registered-to-surveyed building-number mapping for every deed. Deed 103165 is registered as 337/13 but surveyed as 337/16; 103166 is registered as 337/14 but surveyed as 337/15; 103167 is registered as 337/15 but surveyed as 337/14; and 103168 is registered as 337/16 but surveyed as 337/13. Buyers must ask SAM and the Land Office to confirm which deed corresponds to each physical building and inspect house-number records, building registrations, plans, permits and the exact structures to be transferred.\n\nThe property fronts Baan Thai Village Road (Soi 2), described by SAM as an approved subdivision road with an approximately six-metre concrete carriageway and twelve-metre right of way. The source address names Mittraphap Highway 2, but actual access is from Mittraphap via Soi Inthachak and the village road for approximately 335 metres. The property should not be described as directly fronting Mittraphap Highway.\n\nMapxProp classifies the shophouses as mixed use so they can be discovered in both homes and business, with residential, retail and office use cases. The classification is based on the commercial-building type and SAM\'s listing of six bedrooms and eight bathrooms in residential surroundings. It does not guarantee residential use or any commercial activity. Buyers must verify current pink-zone planning rules, approved building use, licences, parking, signage, access, fire escape and fire safety.\n\nNearby places named by SAM include Khon Kaen Post Office, Khon Kaen Teachers Savings Cooperative, Wat Sawang Suttharam, Makro Khon Kaen 3 and Lotus Khon Kaen 2. SAM\'s directions use Mittraphap Highway 2 from Central Khon Kaen, passing Ratchaphruek Hospital, Srinagarind Hospital, Khon Kaen University, Lotus Khon Kaen 2 and Khon Kaen Post Office, then turn left into Soi Inthachak and left again into Baan Thai Village Road; the property is on the left.\n\nThe SAM page listed the property for direct purchase at an announced THB 8,351,000 when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, offer procedures, current price, promotions, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: SL0013. MapxProp does not collect deposits or represent SAM.\n\nProperty photos display 12 June 2024, and conditions may have changed. The source does not publish usable area, parking, building age, utility specifications, occupancy or other encumbrances. Buyers should inspect all four units, every floor, structure, roof, stairs, fire escape, cracks, moisture, termites, utilities, bathrooms, drainage, flooding, possession, encumbrances, taxes, costs and every current term before deciding.',
        '337/13-16, Baan Thai',
        'Four three-storey shophouses; access from Mittraphap Highway via Soi Inthachak',
        'Baan Thai Village Road (Soi 2)',
        'Sila',
        'Mueang Khon Kaen',
        'Khon Kaen',
        'SAM Four Mixed-Use Shophouses, Baan Thai Khon Kaen, THB 8.351M',
        'Official SAM SL0013: four three-storey mixed-use shophouses with 6 bedrooms and 8 bathrooms on 270 sq.m. Direct-sale price THB 8.351M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset SL0013 four three storey mixed use shophouses 337/13-16 Baan Thai Sila Mueang Khon Kaen title deeds 103165 103166 103167 103168 6 bedrooms 8 bathrooms 67.5 sq.wah 270 sq.m. THB 8351000 pink zoning two road frontages')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=21568&keyref=6004430'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=21568&keyref=6004430',
            'The official SAM NPA page identifies SAM as direct-sale contact for asset SL0013. It describes four title deeds and four three-storey shophouses, with a material registered-to-surveyed building-number discrepancy across all four deeds. Buyers must independently confirm every deed-to-building mapping, both road frontages, possession and latest terms.',
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
        '96f3061f-adf8-486f-b681-1379f3415669',
        jsonb_build_object(
            'reference_code', 'SL0013',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'mixed',
            'discovery_channels', jsonb_build_array('homes', 'business'),
            'title_document_count', 4,
            'unit_count', 4,
            'bedroom_count', 6,
            'bathroom_count', 8,
            'connected_units_not_stated', true,
            'two_road_frontages_reported', true,
            'source_reference_discrepancy', false,
            'building_number_mapping_discrepancy', true,
            'plot_measurement_discrepancy', false,
            'direct_mittraphap_frontage', false,
            'mixed_use_review_required', true,
            'source_image_count', 8
        )
    );
END $$;

COMMIT;
