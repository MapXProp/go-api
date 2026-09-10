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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing BL0034';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing BL0034';
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
        'aa42a4f4-5080-4534-a8eb-9738228a07e9',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'retail_space',
        'business',
        'sale',
        'whole_property',
        '37/1-5',
        'ขายตรง SAM โชว์รูมพร้อมสำนักงาน 3 ชั้น หัวมุมเมืองขอนแก่น 350.5 ตร.ว. ราคา 52.41 ล้านบาท',
        E'โชว์รูมพร้อมสำนักงาน 3 ชั้น เลขที่ 37/1-5 ถนนหน้าเมือง ตำบลในเมือง อำเภอเมืองขอนแก่น จังหวัดขอนแก่น บนโฉนดที่ดินเลขที่ 1867, 1868, 1869, 1870, 1873, 2045, 2046, 32188 และ 32189 รวม 9 ฉบับ เนื้อที่ 3 งาน 50.5 ตร.ว. หรือ 350.5 ตร.ว. (1,402 ตร.ม.) หน้า SAM ระบุเขตพื้นที่สีชมพูและย่านพาณิชยกรรม\n\nรายการรับโอนกรรมสิทธิ์สิ่งปลูกสร้างของ SAM ระบุเป็นโรงงานซ่อมรถยนต์และสำนักงานสูง 3 ชั้น เลขที่ 37/1-5 ขณะที่ข้อมูลสำรวจสภาพทรัพย์และประเภทหน้าประกาศระบุเป็นโชว์รูมพร้อมสำนักงาน 3 ชั้น ผู้ซื้อต้องตรวจทะเบียนอาคาร รายการสิ่งปลูกสร้างที่จะโอน แบบแปลน ใบอนุญาต การดัดแปลงอาคาร และการใช้ประโยชน์ที่ได้รับอนุญาตให้ตรงกับสภาพจริง โดยเฉพาะหากจะใช้เป็นโชว์รูม ศูนย์บริการรถยนต์ สำนักงาน หรือกิจการอื่น\n\nที่ดิน 9 แปลงติดกันเป็นรูปหลายเหลี่ยมและติดถนน 2 ด้าน SAM ระบุด้านทิศตะวันตกกว้างประมาณ 35 เมตร ด้านทิศเหนือกว้างประมาณ 38 เมตร และลึกสุดประมาณ 46.5 เมตร ผังต้นทางแสดงด้านตะวันตกติดถนนหน้าเมืองและด้านเหนือติดถนนอนามัย ผู้ซื้อต้องตรวจโฉนดทั้ง 9 ฉบับ รังวัด รูปแปลง แนวเขต การรวมใช้ประโยชน์ข้ามแปลง ทางเข้าออก และตำแหน่งอาคารก่อนเสนอซื้อ\n\nถนนหน้าเมืองผ่านหน้าทรัพย์ SAM ระบุว่าเป็นทางสาธารณประโยชน์ ผิวจราจรลาดยางกว้างประมาณ 12 เมตร เขตทางประมาณ 18 เมตร ส่วนสถานะและขนาดของถนนอนามัยอีกด้านไม่ได้ระบุไว้ในข้อความรายละเอียด คำบอกทางของ SAM ยังมีข้อความวงเล็บว่า “ติดกับถนนอำมาตย์” ซึ่งไม่ตรงกับผังแปลงและแผนที่ที่แสดงหัวมุมถนนหน้าเมือง–ถนนอนามัย ผู้ซื้อต้องตรวจชื่อถนน แนวเขตทาง สิทธิทาง ทางเข้าออกแต่ละด้าน จุดกลับรถ และการเชื่อมทางกับหน่วยงานที่เกี่ยวข้อง\n\nMapxProp จัดทรัพย์นี้อยู่ในหมวดธุรกิจ โดยใช้ประเภทพื้นที่ค้าขายเพื่อให้ค้นหาโชว์รูมได้ และระบุ use case เป็นโชว์รูม/ค้าปลีก สำนักงาน และงานอุตสาหกรรมตามรายการโรงงานซ่อมรถยนต์เดิม การจัดหมวดไม่ใช่การรับรองการใช้ประโยชน์ ผู้ซื้อต้องตรวจผังเมืองสีชมพู ใบอนุญาตอาคาร ใบอนุญาตโรงงานหรือกิจการ ป้าย ที่จอดรถ ทางเข้าออก ทางหนีไฟ ระบบดับเพลิง และข้อกำหนดด้านสิ่งแวดล้อม\n\nสถานที่สำคัญที่ SAM ระบุ ได้แก่ สวนสาธารณรัชดานุสรณ์ ศาลากลางจังหวัดขอนแก่น และสถานีรถไฟขอนแก่น การเดินทางตาม SAM ใช้ถนนประชาสโมสรจากอำเภอเชียงยืนมุ่งหน้าสนามบิน ผ่านโรงแรมเซ็นทารา ขอนแก่น และที่ว่าการอำเภอเมืองขอนแก่น จากนั้นเลี้ยวซ้ายเข้าถนนหน้าเมืองประมาณ 500 เมตร ทรัพย์อยู่ด้านซ้ายมือ\n\nหน้า SAM แสดงสถานะ “ซื้อตรง” และราคาประกาศขาย 52,410,000 บาท ไม่ใช่การประมูลในสถานะที่ตรวจสอบเมื่อวันที่ 10 กันยายน 2569 ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะการครอบครอง และวิธีจำหน่ายล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ BL0034 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nภาพภายนอกและภายในต้นทางแสดงวันที่ 18 เมษายน 2568 สภาพจริงอาจเปลี่ยนแปลง ชุดภาพแสดงพื้นที่โชว์รูม ห้องสำนักงาน ทางเดิน ห้องน้ำ และโถงอาคาร แต่หน้า SAM ไม่ได้เผยแพร่พื้นที่ใช้สอย จำนวนที่จอดรถ อายุอาคาร รายละเอียดระบบไฟฟ้า-ประปา สถานะการครอบครอง หรือภาระผูกพันอื่น ผู้ซื้อควรนัดตรวจพื้นที่ทุกชั้น โครงสร้าง หลังคาช่วงกว้าง ระบบไฟฟ้า ระบบปรับอากาศ ระบบระบายน้ำ ระบบดับเพลิง ทางหนีไฟ รอยร้าว ความชื้น การครอบครอง ภาระผูกพัน ภาษี ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ\n\nหมายเหตุข้อมูลต้นทาง: รหัสหน้าประกาศและชื่อไฟล์ภาพส่วนใหญ่เป็น BL0034 แต่ชื่อไฟล์แผนที่ของ SAM มีข้อความ “3A1119” อยู่ในวงเล็บ ผู้สนใจควรใช้อ้างอิงรหัสปัจจุบัน BL0034 และหน้า id 21697 เมื่อติดต่อ SAM พร้อมขอให้ยืนยันว่ารหัสเก่าเกี่ยวข้องกับทรัพย์เดียวกัน',
        52410000,
        false,
        1402,
        3,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        '37/1-5 ถนนหน้าเมือง',
        'หัวมุมถนนหน้าเมือง–ถนนอนามัยตามผัง SAM; คำบอกทางมีชื่อถนนอำมาตย์ที่ควรตรวจสอบ',
        'หน้าเมือง',
        NULL,
        16.434034246577355,
        102.8344633450048,
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
        'sam-direct-sale-three-storey-showroom-office-na-mueang-khon-kaen-bl0034'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES
        (property_listing_id, 'retail'),
        (property_listing_id, 'office'),
        (property_listing_id, 'industrial')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 52410000, 'total', 'THB', false
    )
    ON CONFLICT (listing_id, offer_type) DO UPDATE SET
        amount = EXCLUDED.amount,
        price_unit = EXCLUDED.price_unit,
        currency_code = EXCLUDED.currency_code,
        is_negotiable = EXCLUDED.is_negotiable,
        updated_at = now();

    INSERT INTO public.listing_discovery_channels (
        listing_id, channel_code, source, is_featured
    ) VALUES (property_listing_id, 'business', 'editorial', false)
    ON CONFLICT (listing_id, channel_code) DO UPDATE SET
        source = EXCLUDED.source,
        is_featured = EXCLUDED.is_featured,
        updated_at = now();

    INSERT INTO public.listing_category_details (
        listing_id, category_code, schema_version, details, is_minimum_submission
    ) VALUES (
        property_listing_id,
        'retail_space',
        1,
        jsonb_build_object(
            'source_property_category', 'โชว์รูม',
            'source_listing_use_description', 'โชว์รูมพร้อมสำนักงาน 3 ชั้น',
            'official_page_reference_code', 'BL0034',
            'source_gallery_filename_reference_code', 'BL0034',
            'source_map_filename', '20241129095303_BL0034M_67(3A1119).jpg',
            'source_map_filename_alternate_reference_code', '3A1119',
            'source_reference_code_discrepancy', true,
            'source_page_id', 21697,
            'source_address_display', '37/1-5 ถนนหน้าเมือง ตำบลในเมือง อำเภอเมืองขอนแก่น จังหวัดขอนแก่น',
            'registered_building_number', '37/1-5',
            'title_document_type', 'chanote',
            'title_deed_numbers', jsonb_build_array('1867', '1868', '1869', '1870', '1873', '2045', '2046', '32188', '32189'),
            'title_document_count', 9,
            'land_area_rai', 0,
            'land_area_ngan', 3,
            'land_area_square_wah_remainder', 50.5,
            'land_area_square_wah', 350.5,
            'land_area_sqm', 1402,
            'plot_count', 9,
            'contiguous_plots', true,
            'registered_transfer_description', 'โรงงานซ่อมรถยนต์, สำนักงานความสูง 3 ชั้น เลขที่ 37/1-5',
            'surveyed_structure_description', 'โชว์รูมพร้อมสำนักงาน 3 ชั้น',
            'registered_vs_surveyed_structure_description_discrepancy', true,
            'registered_floor_count', 3,
            'plot_shape', 'polygon',
            'summary_west_side_width_m_approx', 35,
            'summary_north_side_width_m_approx', 38,
            'summary_maximum_depth_m_approx', 46.5,
            'two_road_frontages_reported', true,
            'west_frontage_road_name_from_plan', 'ถนนหน้าเมือง',
            'north_frontage_road_name_from_plan', 'ถนนอนามัย'
        ) || jsonb_build_object(
            'primary_front_road_name', 'ถนนหน้าเมือง',
            'primary_front_road_legal_status_th', 'ทางสาธารณประโยชน์',
            'primary_front_road_surface', 'asphalt',
            'primary_front_road_width_m_approx', 12,
            'primary_front_right_of_way_width_m_approx', 18,
            'second_frontage_road_status_not_published', true,
            'second_frontage_road_width_not_published', true,
            'source_route_parenthetical_road_name', 'ถนนอำมาตย์',
            'plan_and_route_road_name_discrepancy', true,
            'road_name_discrepancy_requires_site_confirmation', true,
            'zoning_color_th', 'เขตสีชมพู ตามหน้า SAM',
            'surrounding_area_use_th', 'ย่านพาณิชยกรรม',
            'source_states_convenient_transportation', true,
            'business_classification', true,
            'business_classification_basis', 'หน้าประกาศระบุเป็นโชว์รูม ข้อมูลสำรวจเป็นโชว์รูมพร้อมสำนักงาน และรายการรับโอนระบุโรงงานซ่อมรถยนต์กับสำนักงาน',
            'approved_use_requires_independent_verification', true,
            'usable_area_not_published', true,
            'parking_information_not_published', true,
            'building_age_not_published', true,
            'utilities_information_not_published', true,
            'occupancy_status_not_published', true,
            'other_encumbrances_not_published', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'computed_price_per_square_wah', 149529.24,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_photo_date_displayed', '2025-04-18',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '16.434033,102.834465',
            'administrator_coordinate_distance_from_source_m_approx', 0.22
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
        'The official SAM NPA page identifies SAM as the asset holder and direct-sale contact for asset BL0034. The page describes nine title deeds and a three-storey showroom with office, while the registered acquisition description refers to an automotive repair factory and office. The route text also names Amat Road where the source plans show the Na Mueang-Anamai corner. Buyers must confirm the registered structures, permitted use, both road frontages, possession and every sale term directly with SAM.',
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
        (property_listing_id, 'ถนนหน้าเมือง', 'Na Mueang Road', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ถนนอนามัย', 'Anamai Road', 'road', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'สวนสาธารณรัชดานุสรณ์', 'Ratchadanuson Park', 'landmark', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'ศาลากลางจังหวัดขอนแก่น', 'Khon Kaen Provincial Hall', 'government', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'สถานีรถไฟขอนแก่น', 'Khon Kaen Railway Station', 'transit', NULL, NULL, NULL, 50, true),
        (property_listing_id, 'ถนนประชาสโมสร', 'Prachasamosorn Road', 'road', NULL, NULL, NULL, 60, false),
        (property_listing_id, 'โรงแรมเซ็นทารา ขอนแก่น', 'Centara Hotel Khon Kaen', 'landmark', NULL, NULL, NULL, 70, false),
        (property_listing_id, 'ที่ว่าการอำเภอเมืองขอนแก่น', 'Mueang Khon Kaen District Office', 'government', NULL, NULL, NULL, 80, false),
        (property_listing_id, 'สถานีขนส่งผู้โดยสารจังหวัดขอนแก่น', 'Khon Kaen Bus Terminal', 'transit', NULL, NULL, NULL, 90, false)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '52,410,000 บาท — โปรดตรวจสอบราคาล่าสุดและโปรโมชั่นกับ SAM', 'THB 52,410,000 — confirm the latest price and promotions with SAM', 'unspecified', 52410000, 'THB', 20),
        (property_listing_id, 'nine_title_deeds', 'โฉนด 9 ฉบับ', 'Nine title deeds', 'โฉนดเลขที่ 1867, 1868, 1869, 1870, 1873, 2045, 2046, 32188 และ 32189 รวมเนื้อที่ 350.5 ตร.ว. ต้องตรวจทุกแปลงและการใช้พื้นที่ร่วมกัน', 'Nine title deeds numbered 1867, 1868, 1869, 1870, 1873, 2045, 2046, 32188 and 32189 total 350.5 sq.wah; verify every plot and cross-plot use', 'buyer', 9, 'deeds', 30),
        (property_listing_id, 'registered_vs_surveyed_use', 'รายการอาคารไม่ตรงกับการสำรวจ', 'Registered and surveyed use differ', 'รายการรับโอนระบุโรงงานซ่อมรถยนต์และสำนักงาน 3 ชั้น แต่การสำรวจระบุโชว์รูมพร้อมสำนักงาน 3 ชั้น ต้องตรวจทะเบียนอาคาร รายการที่จะโอน ใบอนุญาต และการดัดแปลง', 'The acquisition record refers to an automotive repair factory and three-storey office, while the survey describes a showroom with office; verify registrations, transfer schedule, permits and alterations', 'buyer', NULL, '', 40),
        (property_listing_id, 'two_road_frontages', 'ติดถนน 2 ด้าน', 'Two road frontages', 'SAM ระบุด้านตะวันตกกว้างประมาณ 35 เมตร ด้านเหนือประมาณ 38 เมตร และลึกสุดประมาณ 46.5 เมตร ผังแสดงถนนหน้าเมืองและถนนอนามัย', 'SAM reports approximately 35 metres on the west side, 38 metres on the north side and a maximum depth of 46.5 metres; the plan shows Na Mueang and Anamai roads', 'buyer', NULL, '', 50),
        (property_listing_id, 'public_road', 'ถนนหน้าเมือง', 'Na Mueang Road', 'ทางสาธารณประโยชน์ ผิวลาดยางกว้างประมาณ 12 เมตร เขตทางประมาณ 18 เมตร', 'Public asphalt road with an approximately twelve-metre carriageway and eighteen-metre right of way', 'unspecified', 12, 'metres', 60),
        (property_listing_id, 'road_name_discrepancy', 'ชื่อถนนในคำบอกทางไม่ตรงผัง', 'Road-name discrepancy', 'ผังและแผนที่แสดงหัวมุมถนนหน้าเมือง–ถนนอนามัย แต่คำบอกทางมีข้อความ “ติดกับถนนอำมาตย์” ต้องตรวจชื่อถนน แนวเขต และทางเข้าจริง', 'Plans show the Na Mueang-Anamai corner, while the directions mention Amat Road; verify road names, boundaries and actual access', 'buyer', NULL, '', 70),
        (property_listing_id, 'business_use_due_diligence', 'ตรวจการใช้ประโยชน์ทางธุรกิจ', 'Business-use due diligence', 'ตรวจผังเมืองสีชมพู การใช้เป็นโชว์รูม สำนักงาน หรือศูนย์ซ่อม ใบอนุญาตโรงงานหรือกิจการ ที่จอดรถ ทางเข้าออก ป้าย ระบบไฟ ทางหนีไฟ และระบบดับเพลิง', 'Verify pink-zone rules, showroom, office or workshop use, factory and business licences, parking, access, signage, electrical capacity, fire escape and fire safety', 'buyer', NULL, '', 80),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ยืนยันโฉนด 9 ฉบับ รังวัด แนวเขต อาคารที่จะโอน การใช้ประโยชน์ ถนนทั้งสองด้าน สภาพทุกชั้น การครอบครอง ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Confirm all nine deeds, survey, boundaries, structures transferred, permitted use, both roads, every floor, possession, encumbrances, costs and latest terms', 'buyer', NULL, '', 90)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ด้านหน้าโชว์รูมหัวมุมถนน', 'โชว์รูมพร้อมสำนักงาน 3 ชั้น เลขที่ 37/1-5 หัวมุมเมืองขอนแก่นจากภาพ SAM', 'https://npa.sam.or.th/site/images/npa/21697/20251209135954_BL0034P3_68.jpg', '/listing-media/sam/bl0034/01.webp', 'image/webp', 28904, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ด้านข้างโชว์รูมริมถนนหน้าเมือง', 'ภาพแนวอาคารโชว์รูมพร้อมสำนักงานจากด้านถนนหน้าเมืองในชุดภาพ SAM', 'https://npa.sam.or.th/site/images/npa/21697/BL0034P1_68.jpg', '/listing-media/sam/bl0034/02.webp', 'image/webp', 31708, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'อาคารหัวมุมจากถนนอีกด้าน', 'ภาพอาคาร 3 ชั้นและแนวหัวมุมถนนอีกด้านของทรัพย์ BL0034', 'https://npa.sam.or.th/site/images/npa/21697/BL0034P2_68.jpg', '/listing-media/sam/bl0034/03.webp', 'image/webp', 26188, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงโชว์รูมชั้นล่าง', 'ภาพโถงเปิดขนาดใหญ่และเสาภายในพื้นที่โชว์รูมชั้นล่าง', 'https://npa.sam.or.th/site/images/npa/21697/BL0034P4_68.jpg', '/listing-media/sam/bl0034/04.webp', 'image/webp', 12200, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่โชว์รูมมองสู่ด้านหน้า', 'ภาพพื้นที่ภายในชั้นล่างมองออกไปยังช่องเปิดด้านหน้าอาคาร', 'https://npa.sam.or.th/site/images/npa/21697/BL0034P5_68.jpg', '/listing-media/sam/bl0034/05.webp', 'image/webp', 15032, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงลิฟต์หรือประตูบริการ', 'ภาพพื้นที่ภายในพร้อมประตูโลหะคู่และเคาน์เตอร์จากชุดภาพ SAM', 'https://npa.sam.or.th/site/images/npa/21697/BL0034P6_68.jpg', '/listing-media/sam/bl0034/06.webp', 'image/webp', 13182, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงภายในพร้อมผนังตกแต่ง', 'ภาพพื้นที่โชว์รูมพร้อมเสาและผนังตกแต่งลวดลายเรขาคณิต', 'https://npa.sam.or.th/site/images/npa/21697/BL0034P7_68.jpg', '/listing-media/sam/bl0034/07.webp', 'image/webp', 14368, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงโชว์รูมอีกมุม', 'ภาพโถงเปิดและเสาตกแต่งภายในอาคารจากอีกมุมหนึ่ง', 'https://npa.sam.or.th/site/images/npa/21697/BL0034P8_68.jpg', '/listing-media/sam/bl0034/08.webp', 'image/webp', 15686, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องสำนักงานขนาดเล็ก', 'ภาพห้องสำนักงานภายในพร้อมหน้าต่างและประตู', 'https://npa.sam.or.th/site/images/npa/21697/BL0034P9_68.jpg', '/listing-media/sam/bl0034/09.webp', 'image/webp', 9602, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องสำนักงานแนวยาว', 'ภาพห้องสำนักงานภายในแบบฝ้าแขวนและพื้นกระเบื้อง', 'https://npa.sam.or.th/site/images/npa/21697/BL0034P10_68.jpg', '/listing-media/sam/bl0034/10.webp', 'image/webp', 13278, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องสำนักงานพร้อมผนังกระจก', 'ภาพห้องสำนักงานภายในที่มีช่องหน้าต่างและผนังกระจก', 'https://npa.sam.or.th/site/images/npa/21697/BL0034P11_68.jpg', '/listing-media/sam/bl0034/11.webp', 'image/webp', 13634, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องสำนักงานโล่ง', 'ภาพห้องสำนักงานโล่งพร้อมฝ้าแขวนและหน้าต่างภายใน', 'https://npa.sam.or.th/site/images/npa/21697/BL0034P12_68.jpg', '/listing-media/sam/bl0034/12.webp', 'image/webp', 10722, 450, 450, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องทำงานพร้อมหน้าต่าง', 'ภาพพื้นที่สำนักงานพร้อมหน้าต่างและประตูกระจก', 'https://npa.sam.or.th/site/images/npa/21697/BL0034P13_68.jpg', '/listing-media/sam/bl0034/13.webp', 'image/webp', 14832, 450, 450, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่สำนักงานแบบเปิด', 'ภาพสำนักงานแบบเปิดพร้อมเสาและห้องกั้นกระจก', 'https://npa.sam.or.th/site/images/npa/21697/BL0034P14_68.jpg', '/listing-media/sam/bl0034/14.webp', 'image/webp', 16246, 450, 450, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องสำนักงานอีกส่วน', 'ภาพห้องภายในพร้อมหน้าต่างและร่องรอยการถอดอุปกรณ์จากผนัง', 'https://npa.sam.or.th/site/images/npa/21697/BL0034P15_68.jpg', '/listing-media/sam/bl0034/15.webp', 'image/webp', 12218, 450, 450, 150, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่สำนักงานชั้นบน', 'ภาพพื้นที่สำนักงานหรือโถงชั้นบนขนาดใหญ่พร้อมแนวเสา', 'https://npa.sam.or.th/site/images/npa/21697/BL0034P16_68.jpg', '/listing-media/sam/bl0034/16.webp', 'image/webp', 13238, 450, 450, 160, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเดินและบันไดภายใน', 'ภาพทางเดินโครงโลหะและบันไดเชื่อมพื้นที่ภายในอาคาร', 'https://npa.sam.or.th/site/images/npa/21697/BL0034P17_68.jpg', '/listing-media/sam/bl0034/17.webp', 'image/webp', 16126, 450, 450, 170, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำภายในอาคาร', 'ภาพห้องน้ำพร้อมโถสุขภัณฑ์และอ่างล้างมือจากชุดภาพ SAM', 'https://npa.sam.or.th/site/images/npa/21697/BL0034P18_68.jpg', '/listing-media/sam/bl0034/18.webp', 'image/webp', 12634, 450, 450, 180, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงด้านหลังอาคาร', 'ภาพพื้นที่โถงขนาดใหญ่ด้านหลังอาคารพร้อมแนวเสา', 'https://npa.sam.or.th/site/images/npa/21697/BL0034P19_68.jpg', '/listing-media/sam/bl0034/19.webp', 'image/webp', 10192, 450, 450, 190, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่โรงงานหรือศูนย์บริการ', 'ภาพโถงหลังคาช่วงกว้างที่สัมพันธ์กับรายการโรงงานซ่อมรถยนต์ในเอกสาร SAM', 'https://npa.sam.or.th/site/images/npa/21697/BL0034P21_68.jpg', '/listing-media/sam/bl0034/20.webp', 'image/webp', 22730, 450, 450, 200, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงหลังคาช่วงกว้างอีกมุม', 'ภาพพื้นที่ภายในหลังคาช่วงกว้างจากอีกมุมหนึ่งของอาคาร', 'https://npa.sam.or.th/site/images/npa/21697/BL0034P22_68.jpg', '/listing-media/sam/bl0034/21.webp', 'image/webp', 22110, 450, 450, 210, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังโฉนด 9 แปลงและขนาดที่ดิน', 'ผังต้นทาง SAM แสดงโฉนด 9 แปลง ถนนหน้าเมือง ถนนอนามัย และขนาดโดยประมาณ', 'https://npa.sam.or.th/site/images/npa/21697/20240613110728_BL0034C2_67.jpg', '/listing-media/sam/bl0034/22.webp', 'image/webp', 20448, 450, 450, 220, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังอาคารโชว์รูมพร้อมสำนักงาน', 'ผังต้นทาง SAM แสดงอาคารโชว์รูมพร้อมสำนักงาน 3 ชั้นและถนนสองด้าน', 'https://npa.sam.or.th/site/images/npa/21697/20240613110728_BL0034C1_67.jpg', '/listing-media/sam/bl0034/23.webp', 'image/webp', 19558, 450, 450, 230, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปถนนหน้าเมือง', 'แผนที่ต้นทาง SAM แสดงตำแหน่งทรัพย์ BL0034 บริเวณถนนหน้าเมืองและถนนอนามัยในเมืองขอนแก่น', 'https://npa.sam.or.th/site/images/npa/21697/20241129095303_BL0034M_67(3A1119).jpg', '/listing-media/sam/bl0034/24.webp', 'image/webp', 64812, 785, 600, 240, false, true);

    INSERT INTO public.listing_sources (
        listing_id, source_type, publisher_name, source_url,
        reference_code, captured_at, notes
    ) VALUES (
        property_listing_id,
        'editorial_import',
        'บริษัท บริหารสินทรัพย์สุขุมวิท จำกัด (SAM)',
        'https://www.sam.or.th/site/npa/detail.php?id=21697&keyref=6004430',
        'BL0034',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA page id 21697. The page showed direct-purchase status and an announced sale price of THB 52,410,000 for a three-storey showroom with office numbered 37/1-5 on Na Mueang Road, Nai Mueang, Mueang Khon Kaen. Nine contiguous title deeds numbered 1867, 1868, 1869, 1870, 1873, 2045, 2046, 32188 and 32189 cover 3 ngan 50.5 sq.wah, or 350.5 sq.wah / 1,402 sq.m. The registered acquisition description refers to an automotive repair factory and three-storey office, while the survey and current category describe a showroom with office. Buyers must reconcile the registered structures, exact transfer schedule, plans, alterations and permitted use with the physical property. SAM describes a polygonal site with two road frontages, approximately thirty-five metres on the west, thirty-eight metres on the north and a maximum depth of 46.5 metres. The source plan labels Na Mueang Road on the west and Anamai Road on the north. Na Mueang Road is described as a public asphalt road approximately twelve metres wide within an eighteen-metre right of way; the source does not publish the legal status or width of Anamai Road. A further source discrepancy requires site confirmation: the route text says the property is adjacent to Amat Road, while the plan and navigation map show the Na Mueang-Anamai corner. The map filename also contains alternate reference 3A1119 in parentheses, although the current page and the other asset images use BL0034. The source identifies pink zoning and commercial surroundings. MapxProp classifies the property as business-only discovery using the closest available retail-space category, with retail, office and industrial use cases subject to permitted-use verification. Usable area, parking, building age, utility specifications, occupancy and other encumbrances are not published. Exterior and interior photos display 18 April 2025. Administrator coordinates are approximately 0.22 metres from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all twenty-four unique source exterior, interior, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Three-Storey Showroom with Office in Central Khon Kaen, THB 52.41M',
        E'Three-storey showroom with office numbered 37/1-5 on Na Mueang Road, Nai Mueang, Mueang Khon Kaen. Nine contiguous title deeds numbered 1867, 1868, 1869, 1870, 1873, 2045, 2046, 32188 and 32189 cover 3 ngan 50.5 sq.wah, or 350.5 sq.wah (1,402 sq.m.). SAM shows pink planning zoning and describes commercial surroundings.\n\nImportant building-record caveat: SAM\'s registered acquisition description refers to an automotive repair factory and a three-storey office numbered 37/1-5, while its condition survey and listing category describe a three-storey showroom with office. Buyers must verify the building registrations, structures included in the transfer, approved plans, alterations, present condition and permitted use, especially before operating a showroom, vehicle service centre, office or another business.\n\nSAM describes the nine-plot polygonal property as fronting two roads, with approximately thirty-five metres on the west, thirty-eight metres on the north and a maximum depth of 46.5 metres. Its plan shows Na Mueang Road on the west and Anamai Road on the north. Buyers must verify all nine deeds, survey, boundaries, cross-plot building use, both road frontages, access and building positions before offering.\n\nNa Mueang Road is described as a public asphalt road approximately twelve metres wide within an eighteen-metre right of way. The source text does not publish the status or width of Anamai Road. A source inconsistency also requires site confirmation: the written directions say the property is adjacent to Amat Road, while the plot plan and navigation map show the Na Mueang-Anamai corner. Buyers should confirm every road name, right-of-way boundary, access point, turning arrangement and road connection with relevant authorities.\n\nMapxProp places the property in business discovery under the closest available retail-space category, with retail/showroom, office and industrial use cases reflecting the source descriptions. This does not guarantee any proposed activity. Buyers must verify current pink-zone planning rules, approved building use, factory and business licences, signage, parking, access, electrical capacity, fire escape, fire safety and environmental requirements.\n\nNearby places named by SAM include Ratchadanuson Park, Khon Kaen Provincial Hall and Khon Kaen Railway Station. SAM\'s directions use Prachasamosorn Road from Chiang Yuen toward the airport, pass Centara Hotel Khon Kaen and the Mueang Khon Kaen District Office, then turn left onto Na Mueang Road for approximately 500 metres; the property is on the left.\n\nThe SAM page listed the property for direct purchase at an announced THB 52,410,000 when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, offer procedures, current price, promotions, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: BL0034. MapxProp does not collect deposits or represent SAM.\n\nExterior and interior photos display 18 April 2025, and conditions may have changed. The gallery shows showroom areas, offices, corridors, a bathroom and wide-span halls, but the source does not publish usable area, parking count, building age, utility specifications, occupancy or other encumbrances. Buyers should inspect every floor, structure, wide-span roof, electrical capacity, air conditioning, drainage, fire systems, fire escapes, cracks, moisture, possession, encumbrances, taxes, costs and every current term before deciding.\n\nSource-reference note: the current page and most media filenames use BL0034, while the SAM map filename also contains 3A1119 in parentheses. Quote current asset BL0034 and page id 21697 when contacting SAM, and ask SAM to confirm whether the alternate code is historical.',
        '37/1-5, Na Mueang Road',
        'Corner of Na Mueang and Anamai roads according to SAM plans; written directions mention Amat Road and require confirmation',
        'Na Mueang Road',
        'Nai Mueang',
        'Mueang Khon Kaen',
        'Khon Kaen',
        'SAM Three-Storey Showroom and Office, Central Khon Kaen, THB 52.41M',
        'Official SAM BL0034: three-storey showroom with office on nine title deeds totaling 1,402 sq.m. in central Khon Kaen. Direct-sale price THB 52.41M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset BL0034 3A1119 three storey showroom office automotive repair factory 37/1-5 Na Mueang Road Anamai Road Nai Mueang Mueang Khon Kaen 9 title deeds 350.5 sq.wah 1402 sq.m. THB 52410000 pink zoning business commercial')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=21697&keyref=6004430'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=21697&keyref=6004430',
            'The official SAM NPA page identifies SAM as direct-sale contact for asset BL0034. It describes nine title deeds and a three-storey showroom with office. Buyers must independently reconcile the registered automotive-repair-factory and office description with the surveyed showroom use, confirm both road frontages and resolve the Amat versus Anamai road-name discrepancy before purchase.',
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
        'aa42a4f4-5080-4534-a8eb-9738228a07e9',
        jsonb_build_object(
            'reference_code', 'BL0034',
            'alternate_reference_code_in_map_filename', '3A1119',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'business',
            'discovery_channels', jsonb_build_array('business'),
            'title_document_count', 9,
            'plot_count', 9,
            'registered_vs_surveyed_structure_description_discrepancy', true,
            'two_road_frontages_reported', true,
            'source_reference_discrepancy', true,
            'road_name_discrepancy', true,
            'source_image_count', 24
        )
    );
END $$;

COMMIT;
