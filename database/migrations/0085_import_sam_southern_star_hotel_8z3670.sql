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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing 8Z3670';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing 8Z3670';
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
        '54c7abe8-ebb2-4d73-a9e7-390a44b1c436',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'hotel_resort',
        'business',
        'sale',
        'whole_property',
        'โรงแรมเซาท์เทอร์นสตาร์',
        '253',
        'ขายตรง SAM โรงแรมเซาท์เทอร์นสตาร์ 120 ห้อง ที่ดิน 6-1-90.7 ไร่ เมืองสุราษฎร์ฯ ราคา 101.964 ล้านบาท',
        E'โรงแรมเซาท์เทอร์นสตาร์ เลขที่ 253 ถนนชนเกษม อำเภอเมืองสุราษฎร์ธานี จังหวัดสุราษฎร์ธานี ข้อมูลสำรวจของ SAM ระบุอาคารโรงแรม 15 ชั้นพร้อมชั้นใต้ดิน จำนวนห้องพัก 120 ห้อง อาคารประชุมสัมมนา 3 ชั้น และอาคารตึกอีก 2 หลังที่มีสภาพทรุดโทรม ที่ดินรวม 25 โฉนด เนื้อที่ตามยอดรวมที่ประกาศ 6 ไร่ 1 งาน 90.7 ตร.ว. หรือ 2,590.7 ตร.ว. (10,362.8 ตร.ม.) เอกสารประกอบระบุแปลงอยู่ในตำบลตลาดและตำบลมะขามเตี้ย

ที่ดิน 25 แปลงไม่ติดต่อกัน แบ่งเป็น 3 กลุ่ม กลุ่มที่ 1 มี 22 แปลงไม่ติดต่อกัน เนื้อที่รวม 6 ไร่ 24.7 ตร.ว. รูปหลายเหลี่ยม ด้านทิศตะวันตกติดถนนสองช่วงกว้างประมาณ 12 และ 10 เมตร ลึกสุดประมาณ 236 เมตร SAM ระบุว่าที่ดินบางส่วนมีสภาพเป็นทางเข้า-ออกของบุคคลอื่น เนื้อที่ประมาณ 2 ไร่ 77.4 ตร.ว. หรือ 877.4 ตร.ว. ผู้ซื้อจึงต้องตรวจแนวเขต สิทธิทาง ภาระจำยอม และการใช้ทางจริงโดยละเอียด

กลุ่มที่ 2 เป็นที่ดิน 2 แปลงติดต่อกัน โฉนดเลขที่ 2420 และ 2421 รูปสี่เหลี่ยมผืนผ้า หน้ากว้างด้านทิศตะวันตกประมาณ 23 เมตร ลึกประมาณ 19 เมตร หน้าเว็บ SAM สรุปเนื้อที่กลุ่มนี้เป็น 0-1-43 ไร่ หรือ 143 ตร.ว. แต่ตารางรายแปลงในเอกสารประกอบระบุ 57.6 และ 56.7 ตร.ว. รวม 114.3 ตร.ว. ซึ่งเมื่อนำไปรวมกับกลุ่มอื่นจึงตรงกับยอดรวม 2,590.7 ตร.ว. ผู้ซื้อควรให้ SAM และสำนักงานที่ดินยืนยันเนื้อที่จากโฉนดทุกฉบับก่อนเสนอซื้อ

กลุ่มที่ 3 เป็นที่ดิน 1 แปลง โฉนดเลขที่ 3739 เนื้อที่ 51.7 ตร.ว. ด้านทิศใต้ติดแนวทางสาธารณประโยชน์กว้างประมาณ 9.5 เมตร ลึกสุดประมาณ 21 เมตร แต่ต้นทางระบุว่าไม่มีสภาพทาง ส่วนกลุ่มที่ 2 เข้าจากทางสาธารณประโยชน์ผิวดินกว้างประมาณ 3 เมตร เขตทางประมาณ 6 เมตร และรายละเอียดหน้าที่ดินระบุว่าไม่มีสภาพ ผู้ซื้อต้องตรวจสอบการเข้าถึงและสภาพใช้งานจริงของทุกกลุ่มแปลง

กลุ่มที่ 1 ติดถนนชนเกษมซึ่งเป็นทางสาธารณประโยชน์ ผิวจราจรลาดยางกว้างประมาณ 10 เมตร เขตทางประมาณ 14 เมตร ทรัพย์อยู่ในเขตผังเมืองสีชมพู การเดินทางตาม SAM ใช้ถนนดอนนก ผ่านโรงแรมแกรนด์ธารา เลี้ยวเข้าถนนตลาดใหม่ ผ่านโรงเรียนเทศบาล 1 และโรงเรียนสุราษฎร์พิทยา แล้วเลี้ยวเข้าถนนชนเกษมประมาณ 200 เมตร ทรัพย์อยู่ด้านซ้ายมือ

ข้อควรตรวจสอบสำคัญ: รายการรับโอนกรรมสิทธิ์ของ SAM ระบุอาคารโรงแรม 16 ชั้น เลขที่ 253 และห้องจัดเลี้ยง 2 ชั้น แต่ข้อมูลสำรวจระบุโรงแรม 15 ชั้นพร้อมชั้นใต้ดิน อาคารประชุมสัมมนา 3 ชั้น และอาคารตึกสภาพทรุดโทรม 2 หลัง SAM ระบุว่าจะโอนเฉพาะสิ่งปลูกสร้างตามรายการที่จดทะเบียนรับโอนทางทะเบียนเท่านั้น ผู้ซื้อจึงต้องเทียบทะเบียนอาคาร ใบอนุญาต แบบอาคาร จำนวนชั้น รายการสิ่งปลูกสร้างที่จะโอน และสภาพจริงให้ตรงกัน ภาพต้นทางยังแสดงพื้นที่ภายในและอาคารบางส่วนที่มีคราบ ความเสียหาย ฝ้าเพดานชำรุด และร่องรอยการไม่ได้ใช้งาน จึงควรตรวจโครงสร้าง ระบบไฟฟ้า-ประปา ลิฟต์ ระบบปรับอากาศ ระบบดับเพลิง และงบปรับปรุงกับผู้เชี่ยวชาญ

โฉนดเลขที่ 400 มีข้อมูลเลขที่ดินไม่ตรงกัน โดยหน้าเอกสารสิทธิ์ระบุ 434 แต่ระวางและตารางแนบระบุ 454 ผู้ซื้อควรตรวจสอบกับสำนักงานที่ดิน นอกจากนี้จำนวนห้อง 120 ห้องเป็นข้อมูลสำรวจ ไม่ใช่การยืนยันใบอนุญาตโรงแรมหรือจำนวนห้องที่ได้รับอนุญาต

หน้า SAM ระบุสถานะ “ซื้อตรง” และราคาประกาศขาย 101,964,000 บาท ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน รายการทรัพย์ที่จะโอน สถานะการครอบครอง ค่าใช้จ่าย และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ 8Z3670 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM

หน้าต้นทางไม่ระบุวันที่ของข้อมูลรายละเอียด พื้นที่ใช้สอย สถานะการดำเนินกิจการ สถานะผู้ใช้ประโยชน์ ใบอนุญาตโรงแรม รายได้ อัตราเข้าพัก สัญญาเช่า ที่จอดรถ ระบบอาคาร ความจุห้องประชุม ภาระผูกพันอื่น หรือวันที่ถ่ายภาพ ผู้ซื้อควรตรวจสอบเอกสารสิทธิ์และเนื้อที่รายแปลง แนวเขต สิทธิทาง สิ่งปลูกสร้างและใบอนุญาต สภาพโครงสร้างและระบบอาคาร ผังเมือง การเข้าถึงทุกกลุ่มแปลง การครอบครอง ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        101964000,
        false,
        10362.8,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'โรงแรมเซาท์เทอร์นสตาร์ เลขที่ 253',
        'ที่ดิน 25 แปลง แบ่งเป็น 3 กลุ่ม ถนนชนเกษม',
        'ชนเกษม',
        NULL,
        9.14063616,
        99.32788731,
        'สุราษฎร์ธานี',
        'เมืองสุราษฎร์ธานี',
        'ตลาด',
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
        'sam-direct-sale-southern-star-hotel-chonkasem-surat-thani-8z3670'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'hospitality')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 101964000, 'total', 'THB', false
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
        'hotel_resort',
        1,
        jsonb_build_object(
            'source_property_category', 'โรงแรม/รีสอร์ท',
            'project_name', 'โรงแรมเซาท์เทอร์นสตาร์',
            'registered_address_number', '253',
            'title_document_type', 'chanote',
            'title_deed_numbers', jsonb_build_array('399', '400', '408', '416', '515', '1781', '2417', '2418', '2419', '2420', '2421', '2435', '2468', '3025', '3026', '3739', '3966', '3967', '17856', '17857', '17858', '17859', '17860', '17861', '44198'),
            'title_document_count', 25,
            'land_area_rai', 6,
            'land_area_ngan', 1,
            'land_area_square_wah_remainder', 90.7,
            'land_area_square_wah', 2590.7,
            'land_area_sqm', 10362.8,
            'plot_count', 25,
            'plots_contiguous', false,
            'plot_group_count', 3,
            'attachment_lists_subdistricts', jsonb_build_array('ตลาด', 'มะขามเตี้ย'),
            'group_1_plot_count', 22,
            'group_1_plots_contiguous', false,
            'group_1_area_square_wah', 2424.7,
            'group_1_plot_shape', 'polygon',
            'group_1_west_frontage_sections_m', jsonb_build_array(12, 10),
            'group_1_maximum_depth_m', 236,
            'group_1_third_party_access_area_rai', 2,
            'group_1_third_party_access_area_square_wah_remainder', 77.4,
            'group_1_third_party_access_area_square_wah', 877.4,
            'group_1_third_party_access_area_sqm', 3509.6
        ) || jsonb_build_object(
            'group_2_title_deed_numbers', jsonb_build_array('2420', '2421'),
            'group_2_plot_count', 2,
            'group_2_plots_contiguous', true,
            'group_2_source_summary_area_square_wah', 143,
            'group_2_attachment_deed_2420_area_square_wah', 57.6,
            'group_2_attachment_deed_2421_area_square_wah', 56.7,
            'group_2_attachment_sum_area_square_wah', 114.3,
            'group_2_area_inconsistency_requires_confirmation', true,
            'attachment_individual_plot_sum_matches_listed_total', true,
            'group_2_plot_shape', 'rectangle',
            'group_2_west_frontage_m', 23,
            'group_2_depth_m', 19,
            'group_2_frontage_condition_reported', 'no_formed_condition',
            'group_2_access_type', 'public_dirt_road',
            'group_2_access_road_width_m', 3,
            'group_2_access_right_of_way_width_m', 6,
            'group_3_title_deed_number', '3739',
            'group_3_plot_count', 1,
            'group_3_area_square_wah', 51.7,
            'group_3_south_frontage_m', 9.5,
            'group_3_maximum_depth_m', 21,
            'group_3_access_type', 'public_road_without_formed_road',
            'all_plot_access_requires_buyer_confirmation', true
        ) || jsonb_build_object(
            'group_1_front_road_name', 'ถนนชนเกษม',
            'group_1_front_road_type', 'public_road',
            'group_1_front_road_surface', 'asphalt',
            'group_1_front_road_width_m', 10,
            'group_1_front_right_of_way_width_m', 14,
            'zoning_color_th', 'สีชมพู',
            'registered_transfer_hotel_floor_count', 16,
            'registered_transfer_hotel_address_number', '253',
            'registered_transfer_banquet_building_floor_count', 2,
            'surveyed_hotel_floor_count', 15,
            'surveyed_hotel_has_basement', true,
            'surveyed_conference_building_floor_count', 3,
            'surveyed_additional_deteriorated_building_count', 2,
            'surveyed_guest_room_count', 120,
            'transfer_limited_to_registered_structures', true,
            'building_records_require_reconciliation', true,
            'title_deed_400_document_land_number', '434',
            'title_deed_400_cadastral_plan_land_number', '454',
            'title_deed_400_land_number_inconsistency', true,
            'source_photos_show_deterioration_and_maintenance_needs', true,
            'source_video_url', 'https://www.youtube.com/watch?v=8HLV1wjXO5g',
            'source_information_date_not_published', true,
            'source_photo_date_not_published', true,
            'usable_area_not_published', true,
            'hotel_operating_status_not_published', true,
            'occupancy_status_not_published', true,
            'hotel_license_information_not_published', true,
            'revenue_and_occupancy_rate_not_published', true,
            'lease_information_not_published', true,
            'parking_information_not_published', true,
            'building_systems_information_not_published', true,
            'conference_capacity_not_published', true,
            'other_encumbrances_not_published', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-09',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '9.140636,99.327887',
            'administrator_coordinate_distance_from_source_m_approx', 0.038
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z3670. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนชนเกษม', 'Chon Kasem Road', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ถนนตลาดใหม่', 'Talat Mai Road', 'road', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'โรงเรียนเทศบาล 1', 'Municipal School 1', 'education', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'โรงเรียนสุราษฎร์พิทยา', 'Suratpittaya School', 'education', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'โรงแรมแกรนด์ธารา', 'Grand Thara Hotel', 'landmark', NULL, NULL, NULL, 50, true),
        (property_listing_id, 'ศาลหลักเมืองสุราษฎร์ธานี', 'Surat Thani City Pillar Shrine', 'landmark', NULL, NULL, NULL, 60, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '101,964,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 101,964,000 — confirm the latest price with SAM', 'unspecified', 101964000, 'THB', 20),
        (property_listing_id, 'land_package', 'ชุดที่ดินที่ขาย', 'Land package', '25 โฉนด รวม 6-1-90.7 ไร่ แบ่งเป็น 3 กลุ่มและแปลงไม่ติดต่อกัน', 'Twenty-five title deeds totalling 6 rai 1 ngan 90.7 sq.wah, split across three non-contiguous groups', 'unspecified', 25, 'documents', 30),
        (property_listing_id, 'group_2_area_discrepancy', 'เนื้อที่กลุ่มที่ 2 ไม่ตรงกัน', 'Group 2 area discrepancy', 'หน้าเว็บสรุป 143 ตร.ว. แต่ตารางรายโฉนดรวม 114.3 ตร.ว. และยอดรายแปลงจึงตรงกับยอดรวมทั้งหมด ต้องยืนยันกับ SAM และสำนักงานที่ดิน', 'The web summary states 143 sq.wah, but the attached deed schedule totals 114.3 sq.wah and makes the individual-plot sum agree with the overall total; confirm with SAM and the Land Office', 'buyer', NULL, '', 40),
        (property_listing_id, 'third_party_access_area', 'พื้นที่ใช้เป็นทางเข้า-ออกของบุคคลอื่น', 'Area used for third-party access', 'SAM ระบุพื้นที่ในกลุ่มที่ 1 ประมาณ 2-0-77.4 ไร่ ใช้เป็นทางเข้า-ออกของบุคคลอื่น ต้องตรวจแนวเขต สิทธิทาง และภาระจำยอม', 'SAM reports approximately 2 rai 77.4 sq.wah in Group 1 used for access by other persons; verify boundaries, access rights and easements', 'buyer', 877.4, 'sq_wah', 50),
        (property_listing_id, 'registered_structures_only', 'สิ่งปลูกสร้างที่จะโอน', 'Structures included in transfer', 'SAM จะโอนเฉพาะสิ่งปลูกสร้างตามรายการที่จดทะเบียนรับโอน ซึ่งไม่ตรงกับจำนวนชั้นและอาคารในข้อมูลสำรวจ ต้องตรวจทะเบียนและรายการโอน', 'SAM will transfer only structures in its registered acquisition records, which differ from the surveyed floors and buildings; verify registrations and the transfer schedule', 'buyer', NULL, '', 60),
        (property_listing_id, 'access_conditions', 'สภาพทางเข้าแต่ละกลุ่ม', 'Access conditions by plot group', 'กลุ่มที่ 1 ติดถนนลาดยาง กลุ่มที่ 2 ใช้ทางสาธารณะผิวดินและหน้าที่ดินระบุไม่มีสภาพ กลุ่มที่ 3 ติดแนวทางสาธารณะที่ไม่มีสภาพทาง ต้องตรวจการเข้าถึงจริง', 'Group 1 fronts an asphalt road; Group 2 uses a public dirt road and its frontage is reported as unformed; Group 3 adjoins a public alignment without a formed road. Verify actual access', 'buyer', NULL, '', 70),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนดและเนื้อที่รายแปลง เลขที่ดิน แนวเขต สิทธิทาง อาคารและใบอนุญาตโรงแรม ระบบอาคาร อัคคีภัย ลิฟต์ โครงสร้าง การครอบครอง ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Verify each title deed and plot area, land numbers, boundaries, access rights, buildings and hotel licence, building and fire-safety systems, lifts, structure, possession, encumbrances, costs and latest terms', 'buyer', NULL, '', 80)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'อาคารโรงแรมเซาท์เทอร์นสตาร์', 'อาคารสูงของโรงแรมเซาท์เทอร์นสตาร์ รหัสทรัพย์ 8Z3670 ถนนชนเกษม', 'https://npa.sam.or.th/site/images/npa/10922/20260515092042_8Z3670P1_64UP.jpg', '/listing-media/sam/8z3670/01.webp', 'image/webp', 30936, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางแยกเข้าสู่พื้นที่ทรัพย์', 'ภาพทางแยกและถนนภักดีอนุสรณ์ตามเส้นทางไปยังทรัพย์ 8Z3670', 'https://npa.sam.or.th/site/images/npa/10922/8Z3670P_63.JPG', '/listing-media/sam/8z3670/02.webp', 'image/webp', 22850, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ถนนชนเกษมบริเวณทรัพย์', 'ภาพถนนชนเกษมและอาคารพาณิชย์บริเวณทางเข้าสู่โรงแรมเซาท์เทอร์นสตาร์', 'https://npa.sam.or.th/site/images/npa/10922/8Z3670P1_63.JPG', '/listing-media/sam/8z3670/03.webp', 'image/webp', 24024, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'อาคารด้านหน้าที่ปิดกั้นพื้นที่', 'ภาพบริเวณด้านหน้าอาคารส่วนหนึ่งของทรัพย์พร้อมแนวรั้วปิดกั้น', 'https://npa.sam.or.th/site/images/npa/10922/8Z3670P4_63.jpg', '/listing-media/sam/8z3670/04.webp', 'image/webp', 24890, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'อาคารตึกสภาพทรุดโทรม', 'ภาพอาคารตึกขนาดเล็กในทรัพย์ที่เห็นคราบและสภาพทรุดโทรม', 'https://npa.sam.or.th/site/images/npa/10922/8Z3670P5_63.jpg', '/listing-media/sam/8z3670/05.webp', 'image/webp', 27400, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ระหว่างอาคาร', 'ภาพทางและพื้นที่ระหว่างอาคารซึ่งเห็นคราบและร่องรอยการไม่ได้ใช้งาน', 'https://npa.sam.or.th/site/images/npa/10922/8Z3670P7_63.jpg', '/listing-media/sam/8z3670/06.webp', 'image/webp', 35188, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'เคาน์เตอร์ภายในอาคาร', 'ภาพเคาน์เตอร์และพื้นที่ภายในอาคารโรงแรมที่ควรตรวจสภาพและงบปรับปรุง', 'https://npa.sam.or.th/site/images/npa/10922/8Z3670P9_63.jpg', '/listing-media/sam/8z3670/07.webp', 'image/webp', 24982, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงและบันไดภายใน', 'ภาพโถงบันไดและพื้นที่ภายในอาคารที่เห็นร่องรอยการไม่ได้ใช้งาน', 'https://npa.sam.or.th/site/images/npa/10922/8Z3670P10_63.jpg', '/listing-media/sam/8z3670/08.webp', 'image/webp', 14160, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องประชุมหรือห้องจัดเลี้ยง', 'ภาพพื้นที่โถงขนาดใหญ่ในอาคารประชุมสัมมนาหรือห้องจัดเลี้ยง', 'https://npa.sam.or.th/site/images/npa/10922/8Z3670P13_63.jpg', '/listing-media/sam/8z3670/09.webp', 'image/webp', 24028, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'เคาน์เตอร์ไม้ภายใน', 'ภาพเคาน์เตอร์ไม้และพื้นที่ภายในส่วนหนึ่งของทรัพย์', 'https://npa.sam.or.th/site/images/npa/10922/8Z3670P14_63.jpg', '/listing-media/sam/8z3670/10.webp', 'image/webp', 15786, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงขนาดใหญ่ที่ต้องปรับปรุง', 'ภาพโถงภายในขนาดใหญ่ที่เห็นฝ้าเพดานและพื้นบางส่วนชำรุด', 'https://npa.sam.or.th/site/images/npa/10922/8Z3670P19_63.jpg', '/listing-media/sam/8z3670/11.webp', 'image/webp', 29056, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเดินภายในโรงแรม', 'ภาพทางเดินและประตูห้องภายในอาคารโรงแรม', 'https://npa.sam.or.th/site/images/npa/10922/8Z3670P21_63.jpg', '/listing-media/sam/8z3670/12.webp', 'image/webp', 10350, 450, 450, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังอาคารและกลุ่มแปลง', 'ผังแสดงตำแหน่งอาคารโรงแรม อาคารสัมมนา อาคารตึก และส่วนที่ดินมีสภาพเป็นถนน', 'https://npa.sam.or.th/site/images/npa/10922/20190614143216_8Z3670C2_61.jpg', '/listing-media/sam/8z3670/13.webp', 'image/webp', 32278, 450, 450, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แผนที่การเดินทางไปโรงแรม', 'แผนที่ต้นทางแสดงตำแหน่งโรงแรมเซาท์เทอร์นสตาร์และสถานที่สำคัญใจกลางเมืองสุราษฎร์ธานี', 'https://npa.sam.or.th/site/images/npa/10922/20160825180006_8Z3670M1_59.jpg', '/listing-media/sam/8z3670/14.webp', 'image/webp', 46642, 785, 600, 140, false, true);

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
            'บริษัท บริหารสินทรัพย์สุขุมวิท จำกัด (SAM)',
            'https://www.sam.or.th/site/npa/detail.php?id=10922',
            '8Z3670',
            '2026-09-09 00:00:00+07',
            'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 101,964,000 for the Southern Star Hotel property, asset 8Z3670. The page lists 25 title deeds and total land of 6 rai 1 ngan 90.7 sq.wah / 2,590.7 sq.wah / 10,362.8 sq.m., split into three non-contiguous groups. SAM reports approximately 877.4 sq.wah within Group 1 used as access by other persons. Group 2 and Group 3 have limited or unformed access conditions requiring confirmation. The registered acquisition record lists a 16-storey hotel numbered 253 and a two-storey banquet building, while the survey lists a 15-storey hotel with basement, a three-storey conference building and two deteriorated buildings. SAM states that only registered structures will be transferred. The survey reports 120 guest rooms, but the page does not publish a hotel licence or authorized room count. Title deed 400 has land number 434 on the deed face but 454 on the cadastral plan. The source does not publish its information date, usable area, operation or occupancy status, licence, revenue, occupancy rate, leases, parking, building systems, conference capacity, other encumbrances or photo dates. Source images visibly show substantial maintenance and renovation needs. Administrator-supplied coordinates are approximately 0.038 meters from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all fourteen unique source property, interior, site-plan and navigation images; one exact duplicate source image and the separate video thumbnail were omitted, and no MapxProp watermark was added.'
        ),
        (
            property_listing_id,
            'editorial_import',
            'บริษัท บริหารสินทรัพย์สุขุมวิท จำกัด (SAM)',
            'https://npa.sam.or.th/site/attach/npa/10922/8Z3670%20merge.pdf',
            '8Z3670-property-attachment',
            '2026-09-09 00:00:00+07',
            'The official two-page property attachment maps the 25 plots across Talat and Makham Tia subdistricts and provides a plot-by-plot title-deed, land-number, survey-sheet and area schedule. The individual areas sum to 2,590.7 sq.wah, matching the overall listed total. For Group 2, title deeds 2420 and 2421 are listed as 57.6 and 56.7 sq.wah, totalling 114.3 sq.wah, while the main web-page group summary says 143 sq.wah. This discrepancy must be resolved against the title deeds and Land Office records before an offer.'
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
        'SAM Direct Sale: 120-Room Southern Star Hotel in Surat Thani, THB 101.964M',
        E'Southern Star Hotel, no. 253, on Chon Kasem Road in Mueang Surat Thani, Surat Thani. SAM''s survey describes a 15-storey hotel with basement and 120 guest rooms, a three-storey conference building and two additional deteriorated buildings. The 25 title deeds have a listed total area of 6 rai 1 ngan 90.7 sq.wah, or 2,590.7 sq.wah (10,362.8 sq.m.). The attached schedule places plots in both Talat and Makham Tia subdistricts.\n\nThe 25 plots are non-contiguous and divided into three groups. Group 1 comprises 22 non-contiguous plots totalling 2,424.7 sq.wah. It is polygonal, with two western road-frontage sections of approximately 12 and 10 meters and maximum depth of approximately 236 meters. SAM reports that approximately 2 rai 77.4 sq.wah, or 877.4 sq.wah, is used for access by other persons. Buyers must closely verify boundaries, access rights, easements and actual use.\n\nGroup 2 comprises two contiguous rectangular plots under title deeds 2420 and 2421, with approximately 23 meters of western frontage and 19 meters of depth. The SAM web page summarizes Group 2 as 143 sq.wah, but its attached schedule lists the plots as 57.6 and 56.7 sq.wah, totalling 114.3 sq.wah. The schedule''s individual-plot sum then agrees with the overall 2,590.7-sq.wah total. Buyers should have SAM and the Land Office confirm every title-deed area before offering.\n\nGroup 3 is title deed 3739, covering 51.7 sq.wah with approximately 9.5 meters of southern frontage and maximum depth of approximately 21 meters. The source says its adjoining public-road alignment has no formed road. Group 2 is approached by a public dirt road approximately three meters wide within a six-meter right of way, and its frontage description also says there is no formed condition. Buyers must inspect and confirm practical and legal access to every plot group.\n\nGroup 1 fronts public asphalt Chon Kasem Road, with an approximately ten-meter carriageway within an approximately 14-meter right of way. The property is in pink zoning. SAM''s route proceeds via Don Nok Road and Talat Mai Road, past Municipal School 1 and Suratpittaya School, then approximately 200 meters along Chon Kasem Road.\n\nImportant building-record issue: SAM''s registered acquisition record lists a 16-storey hotel numbered 253 and a two-storey banquet building. Its condition survey instead lists a 15-storey hotel with basement, a three-storey conference building and two deteriorated buildings. SAM states that it will transfer only structures in its registered acquisition records. Buyers must reconcile the building registration, permits, plans, floor counts, transfer schedule and actual conditions. Source photos visibly show staining, damaged ceilings and areas that appear unused, so qualified specialists should inspect the structure, electrical and plumbing systems, lifts, air conditioning, fire-safety systems and renovation budget.\n\nTitle deed 400 also contains a land-number discrepancy: the deed face states 434, while the cadastral plan and attached schedule state 454. This must be checked with the Land Office. The reported 120 rooms are survey information and do not confirm a hotel licence or authorized room count.\n\nThe SAM page lists the property as direct purchase with an announced sale price of THB 101,964,000. It is not an auction. Contact SAM directly to confirm availability, offer procedures, current price, structures included, possession, costs and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: 8Z3670. MapxProp does not collect deposits or represent SAM in the transaction.\n\nThe source does not publish a date for its detailed information, usable area, operating or occupancy status, hotel licence, revenue, occupancy rate, leases, parking, building systems, conference capacity, other encumbrances or photo dates. Buyers should verify every title deed and plot area, boundaries, access rights, buildings and licences, structure and systems, zoning, possession, encumbrances, expenses and all terms before deciding.',
        'Southern Star Hotel, no. 253',
        'Twenty-five plots in three groups on Chon Kasem Road',
        'Chon Kasem Road',
        'Talat',
        'Mueang Surat Thani',
        'Surat Thani',
        'SAM Direct-Sale Southern Star Hotel in Surat Thani, THB 101.964M',
        'Official SAM NPA asset 8Z3670: 120-room hotel property on 10,362.8 sq.m. Direct-sale price THB 101.964M; plot-area, access and building-record discrepancies disclosed.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset 8Z3670 Southern Star Hotel 120 rooms Chon Kasem Road Talat Makham Tia Mueang Surat Thani 25 title deeds 6 rai 1 ngan 90.7 sq.wah 2590.7 sq.wah 10362.8 sq.m. THB 101964000 hotel property non contiguous plots third party access')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=10922'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=10922',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z3670. The specifications, title-deed list, images, rounded coordinates, announced price, direct-purchase status, access conditions and building-record discrepancies come from that record and its official property attachment.',
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
        '54c7abe8-ebb2-4d73-a9e7-390a44b1c436',
        jsonb_build_object(
            'reference_code', '8Z3670',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'title_document_count', 25,
            'group_2_area_discrepancy', true,
            'third_party_access_warning', true,
            'building_records_require_reconciliation', true,
            'duplicate_source_image_omitted', true
        )
    );
END $$;

COMMIT;
