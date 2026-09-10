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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing 8Z7001';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing 8Z7001';
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
        '90f34b44-c5af-4ad9-8d75-1feeb3e33911',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'factory',
        'business',
        'sale',
        'whole_property',
        'ขายตรง SAM โรงงาน/โกดัง ปงแสนทอง ลำปาง 6 ไร่ 2 งาน 88 ตร.ว. ราคา 7.898 ล้านบาท',
        E'โรงงานและโกดังพร้อมที่ดิน 2 แปลงติดต่อกัน ตำบลปงแสนทอง อำเภอเมืองลำปาง จังหวัดลำปาง เนื้อที่รวม 6 ไร่ 2 งาน 88 ตร.ว. หรือ 2,688 ตร.ว. (10,752 ตร.ม.) โฉนดที่ดินเลขที่ 140502 และ 140503 จำนวน 2 ฉบับ หน้า SAM ระบุเขตสีชมพูและตั้งอยู่ในย่านที่อยู่อาศัยและเกษตรกรรม

ที่ดินมีรูปคล้ายสี่เหลี่ยมผืนผ้าและติดถนน 2 ด้าน ด้านทิศตะวันออกและทิศตะวันตกกว้างด้านละประมาณ 45 เมตร ลึกสุดประมาณ 240 เมตร ถนนผ่านหน้าทรัพย์คือถนนนิคม เป็นทางสาธารณประโยชน์ ผิวลาดยางกว้างประมาณ 6 เมตร เขตทางกว้างประมาณ 12 เมตร ผู้ซื้อควรตรวจรังวัด แนวเขต ระดับถนน ทางเข้าออกทั้งสองด้าน และความเหมาะสมกับรถบรรทุกที่ต้องการใช้จริง

รายการที่ SAM จดทะเบียนรับโอนระบุว่าโฉนดเลขที่ 140502 มีโกดังชั้นเดียว 1 หลัง ส่วนโฉนดเลขที่ 140503 มีบ้านพักอาศัยตึกชั้นเดียว 1 หลัง บ้านพักอาศัยไม้ชั้นเดียว 1 หลัง และโกดังชั้นเดียว 3 หลัง

ผลสำรวจสภาพของ SAM ระบุสำนักงานชั้นเดียว โกดังหลังที่ 1 โกดังหลังที่ 2 และ 3 ซึ่งมีสภาพทรุดโทรม ส่วนโล่งหลังคาคลุมซึ่งมีสภาพทรุดโทรม และบ้านพักอาศัยไม้ชั้นเดียวที่รื้อถอนแล้ว SAM ระบุว่าจะโอนกรรมสิทธิ์ตามรายการสิ่งปลูกสร้างที่จดทะเบียนรับโอนทางทะเบียนเท่านั้น ผู้ซื้อต้องให้ SAM สำนักงานที่ดิน และหน่วยงานท้องถิ่นยืนยันสิ่งปลูกสร้างที่รวมในการโอน รายการที่รื้อถอน ความตรงกันระหว่างทะเบียนกับสภาพจริง และการอนุญาตใช้อาคารก่อนเสนอซื้อ

SAM ระบุผลตรวจ “พิทักษ์ไพร” ว่าทรัพย์อยู่ในเขตนิคมสหกรณ์ ตามกฎหมายว่าด้วยนิคมสหกรณ์ในท้องที่อำเภอห้างฉัตร อำเภอเกาะคา และอำเภอเมืองลำปาง จังหวัดลำปาง พ.ศ. 2531 และระบุว่าโฉนดทั้งสองออกเมื่อวันที่ 3 ตุลาคม 2544 จากหนังสือแสดงการทำประโยชน์ กสน.5 ผู้ซื้อต้องตรวจข้อจำกัดการถือครอง การโอน การใช้ประโยชน์ เงื่อนไขนิคมสหกรณ์ ที่มาของเอกสารสิทธิ์ และความเห็นจากหน่วยงานที่มีอำนาจด้วยตนเอง

การเดินทางตาม SAM ใช้ถนนลำปาง–เชียงใหม่ (ซุปเปอร์ไฮเวย์ ทล.11) จากลำปางมุ่งหน้าเชียงใหม่ ผ่านสำนักงานเกษตรลำปางและสถาบันฝึกฝีมือแรงงาน ถึงบริเวณหลัก กม.469+620 แล้วเลี้ยวขวาเข้าถนนนิคม ผ่านวัดพระธาตุกู่สีขันธ์และเรือนจำชั่วคราวปงยางคก จะพบทรัพย์ด้านขวามือ หน้า SAM พิมพ์ระยะบนถนนนิคมว่า “ประมาณ 1.04 ม.” ซึ่งอาจเป็นหน่วยที่คลาดเคลื่อน ผู้ซื้อควรใช้พิกัดและตรวจเส้นทางจริงกับ SAM

สถานที่ใกล้เคียงที่ SAM ระบุ ได้แก่ สถาบันพัฒนาฝีมือแรงงานและวัดห้วยน้ำเย็น

หน้า SAM แสดงสถานะ “ซื้อตรง” และราคาประกาศขาย 7,898,000 บาท ไม่ใช่การประมูลในสถานะที่ตรวจสอบเมื่อวันที่ 10 กันยายน 2569 ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย รายการสิ่งปลูกสร้างที่จะโอน และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ 8Z7001 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM

ภาพหน้าทรัพย์ต้นทางแสดงวันที่ 9 ธันวาคม 2564 และภาพสภาพทรัพย์ส่วนใหญ่แสดงวันที่ 24 พฤศจิกายน 2565 สภาพจริงอาจเปลี่ยนแปลง หน้า SAM ไม่ได้เผยแพร่พื้นที่ใช้สอยอาคาร กำลังไฟฟ้า ใบอนุญาตโรงงานหรือโกดัง ความสูงอาคาร ระบบป้องกันอัคคีภัย การรับน้ำหนักพื้น สาธารณูปโภค หรือขนาดรถบรรทุกที่เข้าถึงได้ ผู้ซื้อควรนัดตรวจโครงสร้าง หลังคา อาคารที่ทรุดโทรม พื้นที่ที่รื้อถอน ไฟฟ้า ประปา การระบายน้ำ น้ำท่วม ดิน ผังเมือง ใบอนุญาต ภาระผูกพัน การครอบครอง ค่าใช้จ่าย และความเหมาะสมกับกิจการก่อนตัดสินใจ',
        7898000,
        false,
        10752,
        1,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'โรงงาน/โกดัง ตำบลปงแสนทอง',
        'เข้าทางถนนนิคม จากถนนลำปาง-เชียงใหม่ (ทล.11)',
        'ถนนนิคม',
        NULL,
        18.30528145,
        99.42129896,
        'ลำปาง',
        'เมืองลำปาง',
        'ปงแสนทอง',
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
        'sam-direct-sale-factory-warehouse-pong-saen-thong-lampang-8z7001'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES
        (property_listing_id, 'industrial'),
        (property_listing_id, 'storage')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 7898000, 'total', 'THB', false
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
        property_listing_id, 'business', 'editorial', false
    )
    ON CONFLICT (listing_id, channel_code) DO UPDATE SET
        source = EXCLUDED.source,
        is_featured = EXCLUDED.is_featured,
        updated_at = now();

    INSERT INTO public.listing_category_details (
        listing_id, category_code, schema_version, details, is_minimum_submission
    ) VALUES (
        property_listing_id,
        'factory',
        1,
        jsonb_build_object(
            'source_property_category', 'โรงงาน/โกดัง',
            'title_document_type', 'chanote',
            'title_deed_numbers', jsonb_build_array('140502', '140503'),
            'title_document_count', 2,
            'plot_count', 2,
            'plots_are_contiguous', true,
            'land_area_rai', 6,
            'land_area_ngan', 2,
            'land_area_square_wah_remainder', 88,
            'land_area_square_wah', 2688,
            'land_area_sqm', 10752,
            'plot_shape', 'near_rectangular',
            'road_frontage_side_count', 2,
            'east_frontage_m_approx', 45,
            'west_frontage_m_approx', 45,
            'maximum_depth_m_approx', 240,
            'front_road_name', 'ถนนนิคม',
            'front_road_legal_status_th', 'ทางสาธารณประโยชน์',
            'front_road_surface', 'asphalt',
            'front_road_width_m_approx', 6,
            'front_right_of_way_width_m_approx', 12,
            'zoning_color_th', 'เขตสีชมพู ตามหน้า SAM',
            'source_area_context', 'ย่านที่อยู่อาศัยและเกษตรกรรม'
        ) || jsonb_build_object(
            'registered_structure_title_deed_140502', jsonb_build_array('โกดัง 1 ชั้น จำนวน 1 หลัง'),
            'registered_structure_title_deed_140503', jsonb_build_array('บ้านพักอาศัยตึกชั้นเดียว', 'บ้านพักอาศัยไม้ชั้นเดียว', 'โกดัง 1 ชั้น จำนวน 3 หลัง'),
            'registered_structure_count', 6,
            'surveyed_structure_count_including_demolished', 6,
            'surveyed_structures', jsonb_build_array('สำนักงานชั้นเดียว', 'โกดังหลังที่ 1', 'โกดังหลังที่ 2 — สภาพทรุดโทรม', 'โกดังหลังที่ 3 — สภาพทรุดโทรม', 'ส่วนโล่งหลังคาคลุม — สภาพทรุดโทรม', 'บ้านพักอาศัยไม้ชั้นเดียว — รื้อถอนแล้ว'),
            'deteriorated_structure_count_reported', 3,
            'wooden_residence_demolished', true,
            'transfer_follows_registered_structure_schedule_only', true,
            'registered_and_actual_structures_require_reconciliation', true,
            'cooperative_settlement_area_reported', true,
            'cooperative_settlement_instrument_th', 'เขตนิคมสหกรณ์ในท้องที่อำเภอห้างฉัตร อำเภอเกาะคา อำเภอเมืองลำปาง จังหวัดลำปาง พ.ศ.2531',
            'title_deeds_issued_on', '2001-10-03',
            'title_deed_140502_origin_th', 'หนังสือแสดงการทำประโยชน์เลขที่ 4401/2543 (กสน.5 สารบัญทะเบียนที่ดิน 1859)',
            'title_deed_140503_origin_th', 'หนังสือแสดงการทำประโยชน์เลขที่ 4400/2543 (กสน.5 สารบัญทะเบียนที่ดิน 1858)',
            'cooperative_settlement_and_title_review_required', true,
            'usable_area_not_published', true,
            'power_specification_not_published', true,
            'factory_or_warehouse_licence_not_published', true,
            'building_clear_height_not_published', true,
            'fire_safety_system_not_published', true,
            'floor_load_not_published', true,
            'truck_access_not_published', true
        ) || jsonb_build_object(
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'computed_price_per_square_wah', 2938.24,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_information_date_not_published', true,
            'source_property_photo_dates_displayed', jsonb_build_array('2021-12-09', '2022-11-24'),
            'source_access_distance_text_th', 'ประมาณ 1.04 ม.',
            'source_access_distance_unit_may_be_inaccurate', true,
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '18.30528,99.42130',
            'administrator_coordinate_distance_from_source_m_approx', 0.20
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z7001. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนลำปาง-เชียงใหม่ (ทล.11)', 'Lampang-Chiang Mai Highway 11', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ถนนนิคม', 'Nikhom Road', 'road', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'สถาบันพัฒนาฝีมือแรงงาน', 'Institute for Skill Development', 'government', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'สำนักงานเกษตรลำปาง', 'Lampang Agricultural Office', 'government', NULL, NULL, NULL, 40, false),
        (property_listing_id, 'วัดห้วยน้ำเย็น', 'Wat Huai Nam Yen', 'landmark', NULL, NULL, NULL, 50, true),
        (property_listing_id, 'วัดพระธาตุกู่สีขันธ์', 'Wat Phra That Ku Si Khan', 'landmark', NULL, NULL, NULL, 60, false),
        (property_listing_id, 'เรือนจำชั่วคราวปงยางคก', 'Pong Yang Khok Temporary Prison', 'government', NULL, NULL, NULL, 70, false)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '7,898,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 7,898,000 — confirm the latest price with SAM', 'unspecified', 7898000, 'THB', 20),
        (property_listing_id, 'registered_structures', 'สิ่งปลูกสร้างตามทะเบียน', 'Registered structures', 'โฉนด 140502 มีโกดังชั้นเดียว 1 หลัง; โฉนด 140503 มีบ้านพักตึกชั้นเดียว บ้านพักไม้ชั้นเดียว และโกดังชั้นเดียว 3 หลัง', 'Deed 140502 lists one single-storey warehouse; deed 140503 lists one masonry residence, one wooden residence and three single-storey warehouses', 'buyer', 6, 'structures', 30),
        (property_listing_id, 'surveyed_condition', 'สภาพจากการสำรวจ', 'Surveyed condition', 'SAM สำรวจพบสำนักงาน โกดัง 3 หลัง ส่วนโล่งหลังคาคลุม และบ้านไม้ที่รื้อถอนแล้ว โดยโกดัง 2 หลังกับส่วนหลังคาคลุมมีสภาพทรุดโทรม', 'SAM surveyed an office, three warehouses, a roofed open area and a demolished wooden residence; two warehouses and the roofed area were reported deteriorated', 'buyer', NULL, '', 40),
        (property_listing_id, 'registered_transfer_scope', 'ขอบเขตสิ่งปลูกสร้างที่จะโอน', 'Registered transfer scope', 'SAM จะโอนตามรายการสิ่งปลูกสร้างที่จดทะเบียนรับโอนทางทะเบียนเท่านั้น ต้องตรวจให้ตรงกับสภาพจริงและรายการที่รื้อถอน', 'SAM will transfer only according to its registered acquisition schedule; reconcile it with current conditions and demolished structures', 'buyer', NULL, '', 50),
        (property_listing_id, 'road_and_frontages', 'ถนนและหน้ากว้าง', 'Road and frontages', 'ที่ดินติดถนน 2 ด้าน กว้างด้านตะวันออกและตะวันตกด้านละประมาณ 45 เมตร ถนนนิคมผิวลาดยางกว้างประมาณ 6 เมตร เขตทางประมาณ 12 เมตร', 'The land fronts two roads with approximately 45 metres on both east and west; Nikhom Road is asphalt, approximately six metres wide within a twelve-metre right of way', 'buyer', 2, 'sides', 60),
        (property_listing_id, 'cooperative_settlement_review', 'การตรวจสอบเขตนิคมสหกรณ์', 'Cooperative settlement review', 'SAM ระบุว่าทรัพย์อยู่ในเขตนิคมสหกรณ์ ผู้ซื้อต้องตรวจข้อจำกัดการถือครอง การโอน การใช้ประโยชน์ และที่มาของโฉนดกับหน่วยงานที่มีอำนาจ', 'SAM reports that the property is in a cooperative settlement area; buyers must verify ownership, transfer and use restrictions and title origins with the authorities', 'buyer', NULL, '', 70),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนด รังวัด สิ่งปลูกสร้างที่จดทะเบียนและมีอยู่จริง สภาพทรุดโทรม การรื้อถอน ใบอนุญาตโรงงาน การใช้อาคาร ไฟฟ้า ระบบดับเพลิง รถบรรทุก การครอบครอง ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Verify title, survey, registered and existing structures, deterioration, demolition, factory licences, approved use, power, fire safety, truck access, possession, encumbrances, costs and current terms', 'buyer', NULL, '', 80)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'โรงงานและโกดังปงแสนทอง', 'ภาพหน้าทรัพย์โรงงานและโกดัง SAM รหัส 8Z7001 ตำบลปงแสนทอง เมืองลำปาง', 'https://npa.sam.or.th/site/images/npa/16824/20240814092439_8Z7001P2_65.jpg', '/listing-media/sam/8z7001/01.webp', 'image/webp', 28104, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'หน้าทรัพย์จากถนน', 'ภาพมุมกว้างด้านหน้าโรงงานและโกดัง 8Z7001 จากถนน', 'https://npa.sam.or.th/site/images/npa/16824/8Z7001P2_66.jpg', '/listing-media/sam/8z7001/02.webp', 'image/webp', 28764, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'อาคารโกดังด้านหน้า', 'ภาพอาคารโกดังชั้นเดียวบริเวณด้านหน้าทรัพย์ปงแสนทอง', 'https://npa.sam.or.th/site/images/npa/16824/8Z7001P4_66.jpg', '/listing-media/sam/8z7001/03.webp', 'image/webp', 30114, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ด้านข้างอาคารโกดัง', 'ภาพแนวด้านข้างอาคารโกดังและพื้นที่โดยรอบ', 'https://npa.sam.or.th/site/images/npa/16824/8Z7001P12_66.jpg', '/listing-media/sam/8z7001/04.webp', 'image/webp', 29332, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางสัญจรภายในทรัพย์', 'ภาพทางสัญจรภายในแปลงข้างอาคารโกดัง', 'https://npa.sam.or.th/site/images/npa/16824/8Z7001P11_66.jpg', '/listing-media/sam/8z7001/05.webp', 'image/webp', 32592, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวอาคารและบล็อกแก้ว', 'ภาพด้านข้างอาคารโกดังพร้อมผนังบล็อกแก้ว', 'https://npa.sam.or.th/site/images/npa/16824/8Z7001P6_66.jpg', '/listing-media/sam/8z7001/06.webp', 'image/webp', 30596, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ภายในแปลง', 'ภาพถนนและพื้นที่ภายในแปลงโรงงานโกดัง 8Z7001', 'https://npa.sam.or.th/site/images/npa/16824/8Z7001P5_66.jpg', '/listing-media/sam/8z7001/07.webp', 'image/webp', 48584, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'สำนักงานชั้นเดียว', 'ภาพอาคารสำนักงานชั้นเดียวภายในทรัพย์ตามผลสำรวจของ SAM', 'https://npa.sam.or.th/site/images/npa/16824/8Z7001P7_66.jpg', '/listing-media/sam/8z7001/08.webp', 'image/webp', 36156, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'อาคารชั้นเดียวอีกมุม', 'ภาพอาคารสำนักงานหรืออาคารชั้นเดียวจากด้านหน้า', 'https://npa.sam.or.th/site/images/npa/16824/8Z7001P8_66.jpg', '/listing-media/sam/8z7001/09.webp', 'image/webp', 37190, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ภายในอาคารโกดัง', 'ภาพภายในอาคารโกดังชั้นเดียวพร้อมโครงหลังคาและเสา', 'https://npa.sam.or.th/site/images/npa/16824/8Z7001P9_66.jpg', '/listing-media/sam/8z7001/10.webp', 'image/webp', 26390, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โครงสร้างภายในโกดัง', 'ภาพภายในโกดังอีกมุมแสดงเสา พื้น และโครงหลังคา', 'https://npa.sam.or.th/site/images/npa/16824/8Z7001P10_66.jpg', '/listing-media/sam/8z7001/11.webp', 'image/webp', 22000, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ส่วนโล่งหลังคาคลุม', 'ภาพส่วนโล่งหลังคาคลุมภายในทรัพย์ SAM 8Z7001', 'https://npa.sam.or.th/site/images/npa/16824/8Z7001P13_66.jpg', '/listing-media/sam/8z7001/12.webp', 'image/webp', 32556, 450, 450, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โครงหลังคาส่วนที่ทรุดโทรม', 'ภาพพื้นที่ส่วนโล่งและโครงหลังคาที่ SAM ระบุว่ามีสภาพทรุดโทรม', 'https://npa.sam.or.th/site/images/npa/16824/8Z7001P14_66.jpg', '/listing-media/sam/8z7001/13.webp', 'image/webp', 28476, 450, 450, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางแยกเข้าถนนนิคม', 'ภาพจุดเลี้ยวจากถนนลำปาง-เชียงใหม่เข้าสู่ถนนนิคม', 'https://npa.sam.or.th/site/images/npa/16824/8Z7001P1_65.jpg', '/listing-media/sam/8z7001/14.webp', 'image/webp', 27588, 450, 450, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังที่ดิน 2 โฉนด', 'ผังต้นทางแสดงแปลงโฉนด 140502 และ 140503 รวม 6 ไร่ 2 งาน 88 ตารางวา', 'https://npa.sam.or.th/site/images/npa/16824/20240402153228_8Z7001C1.1_65.jpg', '/listing-media/sam/8z7001/15.webp', 'image/webp', 14828, 450, 450, 150, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังสิ่งปลูกสร้างในแปลง', 'ผังต้นทางแสดงตำแหน่งสำนักงาน โกดัง ส่วนหลังคาคลุม และบ้านไม้ที่รื้อถอนแล้ว', 'https://npa.sam.or.th/site/images/npa/16824/20240402153228_8Z7001C2_65.jpg', '/listing-media/sam/8z7001/16.webp', 'image/webp', 22430, 450, 450, 160, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปทรัพย์', 'แผนที่ต้นทางแสดงเส้นทางจากถนนลำปาง-เชียงใหม่ผ่านถนนนิคมไปยังโรงงานโกดัง 8Z7001', 'https://npa.sam.or.th/site/images/npa/16824/20240402134018_8Z7001M1_65.jpg', '/listing-media/sam/8z7001/17.webp', 'image/webp', 40560, 785, 600, 170, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=16824&keyref=6004389',
        '8Z7001',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 7,898,000 for a factory/warehouse property in Pong Saen Thong, Mueang Lampang, Lampang. Two contiguous title deeds numbered 140502 and 140503 cover 6 rai 2 ngan 88 sq.wah / 2,688 sq.wah / 10,752 sq.m. The near-rectangular land fronts roads on two sides, with approximately 45 metres on both the east and west and a maximum depth of approximately 240 metres. Nikhom Road is described as a public asphalt road approximately six metres wide within an approximately twelve-metre right of way. SAM''s registered acquisition schedule lists one single-storey warehouse on deed 140502, and one masonry residence, one wooden residence and three single-storey warehouses on deed 140503. The condition survey identifies an office, three warehouses, a roofed open area and a demolished wooden residence; two warehouses and the roofed open area are reported deteriorated. SAM states that transfer follows only the registered acquisition schedule. SAM also reports that the property lies in a cooperative settlement area under the 1988 local instrument and gives title origins from Kor Sor Nor 5 land-use documents, requiring independent legal and authority review. The source shows pink planning zoning and describes residential-agricultural surroundings. Usable area, power, factory or warehouse licences, clear height, fire safety, floor loading and truck access are not published. Source property photos display 9 December 2021 and 24 November 2022. Administrator coordinates are approximately 0.20 metres from the rounded source coordinates and are used for the listing. One duplicate source gallery image was omitted; MapxProp stores optimized copies of all seventeen unique source property, access, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Factory and Warehouses in Pong Saen Thong, Lampang, THB 7.898M',
        E'Factory and warehouse property on two contiguous plots in Pong Saen Thong, Mueang Lampang, Lampang. Title deeds 140502 and 140503 cover a combined 6 rai 2 ngan 88 sq.wah, or 2,688 sq.wah (10,752 sq.m.). SAM shows pink planning zoning and describes the surroundings as residential and agricultural.

The near-rectangular land fronts roads on two sides. Its eastern and western sides are each approximately 45 metres wide, with a maximum depth of approximately 240 metres. Nikhom Road is described as a public asphalt road approximately six metres wide within an approximately twelve-metre right of way. Buyers should verify the survey, boundaries, road levels, access from both sides and suitability for their required truck size.

SAM''s registered acquisition schedule lists one single-storey warehouse on title deed 140502. Title deed 140503 lists one single-storey masonry residence, one single-storey wooden residence and three single-storey warehouses.

SAM''s condition survey identifies a one-storey office, warehouse no. 1, deteriorated warehouses nos. 2 and 3, a deteriorated roofed open area and a demolished wooden residence. SAM states that transfer will follow only the structures in its registered acquisition schedule. Buyers must ask SAM, the Land Office and local authorities to reconcile registered structures, demolished items and actual conditions and to confirm the approved use of every building before offering.

SAM reports that the property is in a cooperative settlement area under the 1988 instrument covering Hang Chat, Ko Kha and Mueang Lampang districts. It also states that both title deeds were issued on 3 October 2001 from Kor Sor Nor 5 land-use documents. Buyers must independently obtain legal and authority advice on ownership, transfer and land-use restrictions, settlement conditions and the origin and validity of both title deeds.

SAM''s directions use the Lampang-Chiang Mai Superhighway 11 from Lampang toward Chiang Mai, passing the Lampang Agricultural Office and the skill-development institute. At kilometre 469+620, turn right onto Nikhom Road, pass Wat Phra That Ku Si Khan and the Pong Yang Khok temporary prison, and the property is on the right. The SAM page prints the Nikhom Road distance as approximately “1.04 m”, which may contain a unit error; buyers should use the coordinates and confirm the route directly with SAM.

Nearby places named by SAM include the skill-development institute and Wat Huai Nam Yen.

The SAM page listed the property for direct purchase at an announced THB 7,898,000 when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, offer procedures, current price, promotions, costs, the structures included in transfer and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: 8Z7001. MapxProp does not collect deposits or represent SAM in the transaction.

The source front photo displays 9 December 2021, while most condition photos display 24 November 2022. Conditions may have changed. The source does not publish usable area, power capacity, factory or warehouse licences, clear height, fire-safety systems, floor loading, utilities or supported truck size. Buyers should inspect the structures, roofs, deteriorated and demolished areas, electrical and plumbing systems, drainage, flood and soil conditions, planning, licences, encumbrances, possession, costs and suitability for the intended operation before deciding.',
        'Factory and warehouses in Pong Saen Thong',
        'Access via Nikhom Road from Lampang-Chiang Mai Highway 11',
        'Nikhom Road',
        'Pong Saen Thong',
        'Mueang Lampang',
        'Lampang',
        'SAM Factory and Warehouses in Lampang, THB 7.898M',
        'Official SAM NPA asset 8Z7001: factory and warehouses on 10,752 sq.m. in Pong Saen Thong, Mueang Lampang. Direct-sale price THB 7.898M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset 8Z7001 factory warehouse storage office Pong Saen Thong Mueang Lampang Lampang Nikhom Road Highway 11 6 rai 2 ngan 88 sq.wah 2688 sq.wah 10752 sq.m. title deeds 140502 140503 THB 7898000 deteriorated structures demolished wooden residence cooperative settlement')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=16824&keyref=6004389'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=16824&keyref=6004389',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z7001. Specifications, title deeds and origins, registered and surveyed structures, demolition and deterioration notes, images, rounded coordinates, announced price, direct-purchase status, road measurements, cooperative settlement note and planning-zone wording come from that record.',
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
        '90f34b44-c5af-4ad9-8d75-1feeb3e33911',
        jsonb_build_object(
            'reference_code', '8Z7001',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'business',
            'discovery_channels', jsonb_build_array('business'),
            'title_document_count', 2,
            'registered_structure_count', 6,
            'deteriorated_structure_count_reported', 3,
            'demolished_structure_review_required', true,
            'cooperative_settlement_review_required', true,
            'factory_licence_review_required', true,
            'source_unique_image_count', 17
        )
    );
END $$;

COMMIT;
