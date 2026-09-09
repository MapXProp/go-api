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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing 8Z3511';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing 8Z3511';
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
        '228925a7-6eff-4eb7-895a-6e27879b31df',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'land',
        'mixed',
        'sale',
        'land_plot',
        'ขายตรง SAM ที่ดิน 66 ไร่ 2 งาน 48 ตร.ว. ติด ทล.417 พุนพิน ราคา 144.89 ล้านบาท',
        E'ที่ดินเปล่า 1 แปลง เอกสารสิทธิ์ น.ส.3ก. เลขที่ 199 จำนวน 1 ฉบับ ตำบลศรีวิชัย อำเภอพุนพิน จังหวัดสุราษฎร์ธานี เนื้อที่ตามประกาศ 66 ไร่ 2 งาน 48 ตร.ว. หรือ 26,648 ตร.ว. (106,592 ตร.ม.) ติดถนนสายท่าอากาศยานสุราษฎร์ธานี-บรรจบทางหลวงหมายเลข 401 (ทล.417)\n\nSAM ระบุว่าที่ดินถูกถนน ทล.417 ตัดผ่านและแบ่งเป็น 2 ส่วน ส่วนที่ 1 เนื้อที่ 64 ไร่ 2 งาน 70 ตร.ว. ด้านทิศเหนือติดถนนกว้างประมาณ 410 เมตร ลึกสุดประมาณ 275 เมตร ส่วนที่ 2 เนื้อที่ 1 ไร่ 3 งาน 78 ตร.ว. ด้านทิศใต้ติดถนนกว้างประมาณ 45 เมตร ลึกสุดประมาณ 65 เมตร ถนนหน้าทรัพย์เป็นทางสาธารณประโยชน์ ผิวจราจรลาดยางกว้างประมาณ 14 เมตร เขตทางกว้างประมาณ 80 เมตร อยู่ในเขตผังเมืองสีเขียว ย่านที่อยู่อาศัยและเกษตรกรรม และต้นทางระบุว่ามีไฟฟ้า\n\nข้อควรตรวจสอบสำคัญ: SAM ระบุว่าที่ดินส่วนที่ 1 มีแนวสายไฟฟ้าแรงสูง 230,000 โวลต์พาดผ่าน แนวกว้างประมาณ 50 เมตร ยาวเฉลี่ยประมาณ 231 เมตร คิดเป็นพื้นที่ประมาณ 7 ไร่ 87.5 ตร.ว. มีบางส่วนเป็นแนวพิพาทเรื่องทางภาระจำยอมกว้างประมาณ 5 เมตร ยาวเฉลี่ยประมาณ 231 เมตร คิดเป็นพื้นที่ประมาณ 2 งาน 88.75 ตร.ว. และมีพื้นที่ตั้งเสาไฟฟ้าแรงสูงประมาณ 17 x 17 เมตร หรือ 72.25 ตร.ว. โดยหน้า SAM สรุปพื้นที่รวมประมาณ 7 ไร่ 2 งาน ผู้ซื้อควรให้ SAM และหน่วยงานการไฟฟ้ายืนยันแนว ข้อจำกัด และพื้นที่ล่าสุด เพราะตัวเลขแต่ละส่วนอาจซ้อนทับกัน\n\nSAM ยังระบุว่าที่ดินบางส่วนถูกเวนคืนเพื่อสร้างถนน ทล.417 เนื้อที่ 11 ไร่ 71 ตร.ว. และพบข้อมูลเลขที่ดินไม่ตรงกัน โดยรายการทะเบียนระบุเลขที่ดิน 123 แต่รูปที่ดินระบุเลขที่ดิน 29 นอกจากนี้ ผังภาพต้นทางแสดงขนาดแนวสายไฟบางรายการต่างจากข้อความบนหน้าเว็บปัจจุบัน ผู้ซื้อจึงต้องตรวจสอบว่าเนื้อที่คงเหลือและขอบเขตใดรวมอยู่ในการขาย ตรวจสารบัญจดทะเบียน ภาระจำยอม เขตเวนคืน และขอรังวัดยืนยันก่อนเสนอซื้อ\n\nเอกสารสิทธิ์เป็น น.ส.3ก. ตำแหน่ง รูปแปลง ระยะ เนื้อที่ แนวเขต และรายละเอียดสำคัญอาจคลาดเคลื่อนจากข้อมูลที่แสดง ผู้สนใจต้องตรวจสอบเอกสารสิทธิ์ ตำแหน่งจริง แนวเขต เนื้อที่ ภาระผูกพัน และข้อจำกัดการใช้ประโยชน์ทั้งหมดให้เป็นที่พอใจก่อนตัดสินใจ\n\nการเดินทางจากถนนสายเอเชีย (ทล.41) ฝั่งทุ่งสงมุ่งหน้าไชยา ผ่านสหกรณ์สุราษฎร์ธานีและท่าอากาศยานนานาชาติสุราษฎร์ธานี ถึงบริเวณ กม.161 เลี้ยวขวาเข้าถนน ทล.417 ผ่านมหาวิทยาลัยตาปี ไปถึงประมาณหลัก กม.5 ทรัพย์อยู่ด้านขวามือ\n\nหน้า SAM ระบุสถานะ “ซื้อตรง” และราคาประกาศขาย 144,890,000 บาท หรือประมาณ 5,437 บาทต่อ ตร.ว. ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย เนื้อที่และขอบเขตที่จะโอน ขั้นตอนเสนอซื้อ ราคา ค่าใช้จ่าย และเงื่อนไขล่าสุด โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ 8Z3511 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nหน้าต้นทางไม่ระบุผลรังวัดล่าสุด สถานะผู้ใช้ประโยชน์ ระดับถมดิน ระบบระบายน้ำ ภาระผูกพันฉบับปัจจุบัน หรือข้อกำหนดพัฒนาที่ดินโดยละเอียด ภาพหน้าทรัพย์หลักมีวันที่กำกับ 14 กรกฎาคม 2565 ผู้ซื้อควรนัดตรวจพื้นที่และตรวจสอบข้อมูลกับ SAM กรมที่ดิน หน่วยงานเวนคืน และการไฟฟ้าก่อนตัดสินใจ',
        144890000,
        false,
        106592,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'ที่ดินติดถนน ทล.417',
        'ถนนสายท่าอากาศยานสุราษฎร์ธานี-บรรจบทางหลวงหมายเลข 401',
        'ทางหลวงหมายเลข 417',
        NULL,
        9.15266592,
        99.19453011,
        'สุราษฎร์ธานี',
        'พุนพิน',
        'ศรีวิชัย',
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
        'sam-direct-sale-large-land-sri-wichai-phunphin-surat-thani-8z3511'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES
        (property_listing_id, 'residential'),
        (property_listing_id, 'agriculture')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 144890000, 'total', 'THB', false
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
        'land',
        1,
        jsonb_build_object(
            'source_property_category', 'ที่ดินเปล่า',
            'vacant_land', true,
            'land_area_rai', 66,
            'land_area_ngan', 2,
            'land_area_square_wah', 48,
            'land_area_total_square_wah', 26648,
            'land_area_sqm', 106592,
            'document_type_th', 'น.ส.3ก.',
            'document_number', '199',
            'title_document_count', 1,
            'registration_land_number', '123',
            'plot_diagram_land_number', '29',
            'land_number_mismatch', true,
            'document_location_accuracy_warning', true,
            'survey_and_boundary_verification_required', true,
            'registered_plot_count', 1,
            'physical_section_count', 2,
            'road_divides_property', true,
            'section_1_area_rai', 64,
            'section_1_area_ngan', 2,
            'section_1_area_square_wah', 70,
            'section_1_area_total_square_wah', 25870,
            'section_1_area_sqm', 103480,
            'section_1_north_road_frontage_m', 410,
            'section_1_maximum_depth_m', 275,
            'section_2_area_rai', 1,
            'section_2_area_ngan', 3,
            'section_2_area_square_wah', 78,
            'section_2_area_total_square_wah', 778,
            'section_2_area_sqm', 3112,
            'section_2_south_road_frontage_m', 45,
            'section_2_maximum_depth_m', 65
        ) || jsonb_build_object(
            'front_road_name', 'ถนนสายท่าอากาศยานสุราษฎร์ธานี-บรรจบทางหลวงหมายเลข 401 (ทล.417)',
            'access_type', 'public_road',
            'front_road_surface', 'asphalt',
            'front_road_width_m', 14,
            'front_right_of_way_width_m', 80,
            'zoning_color_th', 'สีเขียว',
            'surrounding_area_use_th', 'ที่อยู่อาศัยและเกษตรกรรม',
            'electricity_available_source_claim', true,
            'high_voltage_line_crosses_section_1', true,
            'high_voltage_line_volts', 230000,
            'page_text_high_voltage_corridor_width_m', 50,
            'page_text_high_voltage_corridor_average_length_m', 231,
            'page_text_high_voltage_area_rai', 7,
            'page_text_high_voltage_area_ngan', 0,
            'page_text_high_voltage_area_square_wah', 87.5,
            'page_text_high_voltage_area_total_square_wah', 2887.5,
            'disputed_easement_reported', true,
            'disputed_easement_width_m', 5,
            'disputed_easement_average_length_m', 231,
            'disputed_easement_area_ngan', 2,
            'disputed_easement_area_square_wah', 88.75,
            'disputed_easement_area_total_square_wah', 288.75,
            'high_voltage_pole_on_land', true,
            'high_voltage_pole_site_width_m', 17,
            'high_voltage_pole_site_length_m', 17,
            'high_voltage_pole_site_area_square_wah', 72.25,
            'page_text_total_high_voltage_affected_area_rai', 7,
            'page_text_total_high_voltage_affected_area_ngan', 2,
            'page_text_total_high_voltage_affected_area_square_wah', 0,
            'page_text_total_high_voltage_affected_area_sqm', 12000,
            'high_voltage_components_may_overlap', true,
            'source_diagram_high_voltage_corridor_width_m', 20,
            'source_diagram_high_voltage_corridor_length_m', 240,
            'source_diagram_high_voltage_area_rai', 6,
            'source_diagram_high_voltage_area_sqm', 9600
        ) || jsonb_build_object(
            'page_text_and_diagram_high_voltage_details_differ', true,
            'road_expropriation_reported', true,
            'road_expropriated_area_rai', 11,
            'road_expropriated_area_ngan', 0,
            'road_expropriated_area_square_wah', 71,
            'road_expropriated_area_total_square_wah', 4471,
            'road_expropriated_area_sqm', 17884,
            'remaining_transferable_area_requires_confirmation', true,
            'price_per_square_wah', 5437,
            'price_per_square_wah_currency', 'THB',
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-09',
            'source_cover_photo_date_displayed', '2022-07-14',
            'occupancy_status_not_published', true,
            'land_fill_level_not_published', true,
            'drainage_information_not_published', true,
            'current_encumbrance_record_not_published', true,
            'latest_survey_result_not_published', true,
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '9.152646,99.193588',
            'administrator_coordinate_distance_from_source_m_approx', 103
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z3511. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ทางหลวงหมายเลข 417', 'Highway 417', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ถนนสายเอเชีย (ทล.41)', 'Asian Highway 2 / Highway 41', 'road', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'ท่าอากาศยานนานาชาติสุราษฎร์ธานี', 'Surat Thani International Airport', 'transit', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'มหาวิทยาลัยตาปี', 'Tapee University', 'education', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'สหกรณ์สุราษฎร์ธานี', 'Surat Thani Cooperative', 'landmark', NULL, NULL, NULL, 50, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '144,890,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 144,890,000 — confirm the latest price with SAM', 'unspecified', 144890000, 'THB', 20),
        (property_listing_id, 'title_document', 'เอกสารสิทธิ์', 'Title document', 'น.ส.3ก. เลขที่ 199 จำนวน 1 ฉบับ — รายการทะเบียนระบุเลขที่ดิน 123 แต่รูปที่ดินระบุเลขที่ดิน 29', 'Nor Sor 3 Gor no. 199, one document — the register states land parcel no. 123 while the plot diagram states no. 29', 'unspecified', NULL, '', 30),
        (property_listing_id, 'road_division_and_expropriation', 'ถนนตัดผ่านและการเวนคืน', 'Road division and expropriation', 'ที่ดินถูก ทล.417 ตัดเป็น 2 ส่วน และ SAM ระบุว่ามีพื้นที่ถูกเวนคืน 11 ไร่ 71 ตร.ว. ต้องยืนยันเนื้อที่และขอบเขตที่จะโอน', 'Highway 417 divides the land into two sections, and SAM reports 11 rai 71 sq.wah as expropriated; the transferable area and boundaries must be confirmed', 'buyer', NULL, '', 40),
        (property_listing_id, 'high_voltage_line_and_easement', 'แนวสายไฟฟ้าแรงสูงและภาระจำยอม', 'High-voltage line and easement', 'มีแนวสายไฟฟ้าแรงสูง 230 kV พาดผ่าน พื้นที่ตั้งเสาไฟ และแนวพิพาทเรื่องทางภาระจำยอม โดยตัวเลขในข้อความกับผังภาพมีรายละเอียดต่างกัน ต้องให้ SAM และการไฟฟ้ายืนยัน', 'A 230 kV transmission line crosses the land, with a tower site and a disputed easement. The page text and plot diagram contain differing measurements, which must be confirmed with SAM and the electricity authority', 'buyer', NULL, '', 50),
        (property_listing_id, 'survey_and_legal_verification', 'การรังวัดและตรวจสอบสิทธิ', 'Survey and legal verification', 'ผู้ซื้อต้องตรวจสอบตำแหน่ง แนวเขต เนื้อที่คงเหลือ สารบัญจดทะเบียน ภาระจำยอม เขตเวนคืน และข้อจำกัดการใช้ประโยชน์ก่อนเสนอซื้อ', 'The buyer must verify the location, boundaries, remaining area, registration record, easements, expropriation limits, and use restrictions before submitting an offer', 'buyer', NULL, '', 60)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ที่ดินติดถนน ทล.417', 'แนวหน้าที่ดินรหัส 8Z3511 ติดถนนสายท่าอากาศยานสุราษฎร์ธานี ทล.417', 'https://npa.sam.or.th/site/images/npa/10579/20260105110930_8Z3511P1_65.jpg', '/listing-media/sam/8z3511/01.webp', 'image/webp', 16768, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ภายในและแนวสายไฟฟ้า', 'สภาพที่ดินภายในแปลง มองเห็นเสาและแนวสายไฟฟ้าแรงสูง', 'https://npa.sam.or.th/site/images/npa/10579/8Z3511P2_61.JPG', '/listing-media/sam/8z3511/02.webp', 'image/webp', 18830, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ป้ายหน้าทรัพย์', 'ป้ายประกาศขายที่ดิน 66 ไร่ของ SAM บริเวณริมถนน', 'https://npa.sam.or.th/site/images/npa/10579/8Z3511P3_61.JPG', '/listing-media/sam/8z3511/03.webp', 'image/webp', 15172, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวถนนหน้าที่ดิน', 'แนวหน้าที่ดินริมถนน ทล.417 พร้อมป้ายประกาศและเสาไฟฟ้าแรงสูง', 'https://npa.sam.or.th/site/images/npa/10579/8Z3511P4_61.JPG', '/listing-media/sam/8z3511/04.webp', 'image/webp', 19008, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'สภาพแปลงส่วนริมทาง', 'สภาพพื้นที่แปลงริมถนนและแนวเสาไฟฟ้าแรงสูง', 'https://npa.sam.or.th/site/images/npa/10579/8Z3511P5_61.JPG', '/listing-media/sam/8z3511/05.webp', 'image/webp', 22026, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังแปลงและแนวข้อจำกัด', 'ผังต้นทางแสดงที่ดิน 2 ส่วน แนวถนนที่ตัดผ่าน พื้นที่เวนคืน และแนวสายไฟฟ้าแรงสูง โปรดตรวจสอบกับข้อมูลล่าสุด', 'https://npa.sam.or.th/site/images/npa/10579/20180226143559_8Z3511C1_61.jpg', '/listing-media/sam/8z3511/06.webp', 'image/webp', 20212, 450, 450, 60, false, true);

    INSERT INTO public.listing_sources (
        listing_id, source_type, publisher_name, source_url,
        reference_code, captured_at, notes
    ) VALUES (
        property_listing_id,
        'editorial_import',
        'บริษัท บริหารสินทรัพย์สุขุมวิท จำกัด (SAM)',
        'https://www.sam.or.th/site/npa/detail.php?id=10579&keyref=',
        '8Z3511',
        '2026-09-09 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 144,890,000 (THB 5,437 per sq.wah) for 66 rai 2 ngan 48 sq.wah, or 26,648 sq.wah / 106,592 sq.m., under Nor Sor 3 Gor no. 199. The registered plot is physically divided into two sections by Highway 417: 64-2-70 rai and 1-3-78 rai. SAM reports a 230 kV transmission corridor, a tower site, a disputed easement, and a total high-voltage-affected area of approximately 7-2-0 rai. SAM also reports 11-0-71 rai expropriated for Highway 417 and a discrepancy between registered land parcel no. 123 and plot-diagram no. 29. The older source diagram and current page text show differing high-voltage corridor measurements, and the reported component areas may overlap; all measurements, restrictions, and the remaining transferable area require confirmation. Source coordinates are 9.152646,99.193588; administrator-supplied coordinates approximately 103 meters away are used for the large plot. The cover photo displays 14 July 2022. Occupancy, land-fill level, drainage, a current encumbrance record, and a current survey are not published. SAM''s schematic area map was excluded; MapxProp stores optimized copies of five property photos and the plot diagram without adding a MapxProp watermark.'
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
        'SAM Direct Sale: 66 Rai 2 Ngan 48 Sq.Wah Land on Highway 417, Phunphin, THB 144.89M',
        E'One registered vacant-land plot under Nor Sor 3 Gor no. 199 in Sri Wichai, Phunphin, Surat Thani. The advertised area is 66 rai 2 ngan 48 sq.wah, equivalent to 26,648 sq.wah or 106,592 sq.m. The land fronts the Surat Thani Airport-to-Highway 401 road (Highway 417).\n\nSAM states that Highway 417 divides the land into two physical sections. Section 1 covers 64 rai 2 ngan 70 sq.wah, with approximately 410 meters of north-side road frontage and a maximum depth of approximately 275 meters. Section 2 covers 1 rai 3 ngan 78 sq.wah, with approximately 45 meters of south-side frontage and a maximum depth of approximately 65 meters. The public asphalt road is approximately 14 meters wide within an approximately 80-meter right of way. The source identifies green zoning in a residential and agricultural area and states that electricity is available.\n\nCritical due diligence: SAM reports that a 230 kV transmission line crosses Section 1. The current page describes an approximately 50-meter-wide corridor averaging 231 meters long and about 7 rai 87.5 sq.wah, a disputed access easement approximately 5 meters wide and 231 meters long covering about 2 ngan 88.75 sq.wah, and a 17-by-17-meter transmission-tower site covering 72.25 sq.wah. The page summarizes the affected area as approximately 7 rai 2 ngan. These components may overlap and should not be added together without confirmation.\n\nSAM also states that 11 rai 71 sq.wah was expropriated for Highway 417. The registration record identifies land parcel no. 123, while the plot diagram identifies no. 29. In addition, the older diagram and the current page text contain differing transmission-corridor measurements. Buyers must confirm the remaining transferable area, registered boundaries, easements, expropriation limits, electricity-authority restrictions, and development limitations with SAM and the relevant authorities.\n\nBecause the document is Nor Sor 3 Gor, the displayed location, shape, dimensions, area, boundaries, and other material details may vary. Buyers must independently inspect the land, review the registration record, and arrange an appropriate survey before submitting an offer.\n\nAccess is from Highway 41 toward Chaiya, passing the Surat Thani Cooperative and Surat Thani International Airport. Near kilometer marker 161, turn right onto Highway 417, pass Tapee University, and continue to approximately kilometer marker 5; the property is on the right.\n\nThe SAM page lists the property for direct purchase at an announced sale price of THB 144,890,000, approximately THB 5,437 per sq.wah. It is not an auction. Contact SAM directly to confirm availability, the area and boundaries included in the transfer, offer procedure, current price, expenses, and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: 8Z3511. MapxProp does not collect deposits or represent SAM in the transaction.\n\nThe source does not publish a current survey, occupancy, land-fill level, drainage, a current encumbrance record, or detailed development controls. The main frontage photo displays 14 July 2022. Buyers should inspect the site and verify all current information before deciding.',
        'Land fronting Highway 417',
        'Surat Thani Airport-to-Highway 401 Road',
        'Highway 417',
        'Sri Wichai',
        'Phunphin',
        'Surat Thani',
        'SAM Direct-Sale 66-Rai Land on Highway 417, Phunphin',
        'Official SAM asset 8Z3511: 66 rai 2 ngan 48 sq.wah of Nor Sor 3 Gor land on Highway 417, with high-voltage, easement, and expropriation disclosures.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset 8Z3511 vacant land Sri Wichai Phunphin Surat Thani Highway 417 airport road 66 rai 2 ngan 48 sq.wah 26648 sq.wah 106592 sq.m. Nor Sor 3 Gor 199 THB 144890000 high voltage easement expropriation')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=10579&keyref='
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=10579&keyref=',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z3511. Specifications, images, rounded source coordinates, price, status, high-voltage disclosures, easement dispute, expropriation, and document discrepancies come from that record.',
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
        '228925a7-6eff-4eb7-895a-6e27879b31df',
        jsonb_build_object(
            'reference_code', '8Z3511',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'document_type', 'nor_sor_3_gor',
            'high_voltage_warning', true,
            'easement_dispute_warning', true,
            'expropriation_warning', true,
            'land_number_mismatch_warning', true
        )
    );
END $$;

COMMIT;
