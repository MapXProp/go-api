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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing 4T0923';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing 4T0923';
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
        '796d7ebc-904e-4c8d-b28d-b42d0b6c477d',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'land',
        'residence',
        'sale',
        'land_plot',
        'ขายตรง SAM ที่ดิน 33-1-31 ไร่ ติด ทล.12 ยางตลาด มีแนวเวนคืน ราคา 33.835 ล้านบาท',
        E'ที่ดินเปล่าโฉนดเลขที่ 26614 จำนวน 1 ฉบับ ตำบลยางตลาด อำเภอยางตลาด จังหวัดกาฬสินธุ์ เนื้อที่ 33 ไร่ 1 งาน 31 ตร.ว. หรือ 13,331 ตร.ว. (53,324 ตร.ม.) ติดถนนขอนแก่น-ยางตลาด (ทล.12) และถนนสาย กส.3037 หน้า SAM ระบุราคาต่อตารางวา 2,538 บาท และเขตพื้นที่สีขาวมีกรอบและเส้นทแยงสีเขียว\n\nที่ดินเป็นรูปหลายเหลี่ยมและติดถนน 2 ด้าน ด้านทิศใต้ติดถนนขอนแก่น-ยางตลาด กว้างประมาณ 328 เมตร ด้านทิศตะวันออกติดถนนสาย กส.3037 กว้างประมาณ 227 เมตร และแนวอีกด้านติดลำรางสาธารณประโยชน์ หน้า SAM ส่วนสรุประบุความลึกสุด 227 เมตร แต่รายละเอียดระบุความลึกสุดถึงลำรางประมาณ 230 เมตร ผู้ซื้อต้องตรวจโฉนด รังวัด รูปแปลง แนวเขต ระยะจริง ลำรางสาธารณะ ทางเข้าออกทั้งสองด้าน และตำแหน่งหลักเขตก่อนเสนอซื้อ\n\nข้อควรตรวจสำคัญที่สุด: SAM ระบุว่าที่ดินบางส่วนประมาณ 1 ไร่ 3 งาน 25 ตร.ว. หรือประมาณ 725 ตร.ว. (2,900 ตร.ม. คิดเป็นประมาณ 5.44% ของพื้นที่รวม) อยู่ในแนวเวนคืนตามพระราชกฤษฎีกากำหนดเขตที่ดินที่จะเวนคืนในตำบลยางตลาด ตำบลคลองขาม และตำบลหัวงัว อำเภอยางตลาด จังหวัดกาฬสินธุ์ พ.ศ. 2562 เพื่อสร้างถนนทางหลวงชนบทสายเลี่ยงเมืองยางตลาด ข้อความนี้หมายถึงอยู่ในแนวเวนคืนตามข้อมูล SAM ไม่ควรสรุปว่าเวนคืนเสร็จแล้ว ผู้ซื้อต้องตรวจแนวเขตล่าสุด ขั้นตอนเวนคืน พื้นที่ที่จะถูกใช้จริง เงินค่าทดแทน ผู้มีสิทธิรับค่าทดแทน ผลต่อทางเข้าออก และพื้นที่คงเหลือกับหน่วยงานเวนคืน สำนักงานที่ดิน และ SAM โดยตรง\n\nระดับที่ดินต่ำกว่าถนนประมาณ 1 เมตร จึงควรประเมินต้นทุนถมดิน ระบบระบายน้ำ น้ำท่วม และการเชื่อมทาง ถนนขอนแก่น-ยางตลาด (ทล.12) เป็นทางสาธารณประโยชน์ ผิวลาดยางกว้างประมาณ 12 เมตร เขตทางประมาณ 40 เมตร ส่วนผังระบุถนนสาย กส.3037 เป็นถนนลาดยางกว้างประมาณ 6 เมตร แต่ข้อความรายละเอียดไม่ได้ระบุสถานะทางหรือเขตทาง ผู้ซื้อต้องตรวจข้อกำหนดเชื่อมทางหลวง ทางเข้าออก จุดกลับรถ และเขตทางทั้งสองสาย\n\nSAM ระบุว่าทรัพย์อยู่ในย่านที่อยู่อาศัยและเกษตรกรรม MapxProp จึงจัดไว้ในหมวดที่อยู่อาศัยพร้อม use case ด้านเกษตรกรรม ไม่ได้จัดเป็น Mixed Use หรือหมวดธุรกิจ ข้อความเรื่องย่านและสีผังเมืองไม่ใช่การรับรองว่าสามารถจัดสรร ก่อสร้าง ทำโรงงาน หรือทำเกษตรตามแผนได้ ผู้ซื้อต้องตรวจผังเมืองสีขาวมีกรอบและเส้นทแยงสีเขียว ข้อกำหนดพื้นที่ชนบทและเกษตรกรรม การแบ่งแปลง ระยะร่นลำราง แนวเวนคืน สิ่งแวดล้อม สาธารณูปโภค และใบอนุญาตกับหน่วยงานที่เกี่ยวข้อง\n\nสถานที่ใกล้เคียงที่ SAM ระบุ ได้แก่ วัดปทุมคงคา องค์การบริหารส่วนตำบลยางตลาด สำนักงานพัฒนาฝีมือแรงงานกาฬสินธุ์ และโรงพยาบาลยางตลาด การเดินทางตาม SAM ใช้ถนนขอนแก่น-ยางตลาด (ทล.12) จากจังหวัดร้อยเอ็ดมุ่งหน้าจังหวัดขอนแก่น ถึงแยกยางตลาดแล้วตรงต่อประมาณ 3.8 กิโลเมตร ทรัพย์อยู่ด้านขวามือ SAM ยังระบุทรัพย์ใกล้เคียงรหัส 4T0921 และ 4T0922\n\nหน้า SAM แสดงสถานะ “ซื้อตรง” และราคาประกาศขาย 33,835,000 บาท ไม่ใช่การประมูลในสถานะที่ตรวจสอบเมื่อวันที่ 10 กันยายน 2569 ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น แนวเวนคืน ค่าใช้จ่าย สถานะการครอบครอง และวิธีจำหน่ายล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ 4T0923 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nภาพสภาพทรัพย์ต้นทางแสดงหลายช่วงเวลา ได้แก่ 20 กันยายน 2565, 19 มิถุนายน 2566 และ 15 ธันวาคม 2566 สภาพจริงอาจเปลี่ยนแปลง หน้า SAM ไม่ได้เผยแพร่ข้อมูลสาธารณูปโภค การครอบครอง ประวัติน้ำท่วม ผลสำรวจดิน หรือภาระผูกพันอื่น พิกัดที่ผู้ดูแลให้มาห่างจากพิกัดแบบปัดเศษของ SAM ประมาณ 79.4 เมตร ซึ่งอาจอยู่ภายในแปลงขนาดใหญ่เดียวกัน แต่ผู้ซื้อไม่ควรใช้หมุดออนไลน์แทนการรังวัด ต้องตรวจตำแหน่งและแนวเขตจริงก่อนตัดสินใจ',
        33835000,
        false,
        53324,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'ที่ดินเปล่าโฉนดเลขที่ 26614',
        'ติดถนนขอนแก่น-ยางตลาด (ทล.12) และถนนสาย กส.3037',
        'ขอนแก่น-ยางตลาด (ทล.12)',
        NULL,
        16.396924416379083,
        103.32075550860247,
        'กาฬสินธุ์',
        'ยางตลาด',
        'ยางตลาด',
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
        'sam-direct-sale-land-highway-12-yang-talat-expropriation-4t0923'
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
        property_listing_id, 'sale', 33835000, 'total', 'THB', false
    )
    ON CONFLICT (listing_id, offer_type) DO UPDATE SET
        amount = EXCLUDED.amount,
        price_unit = EXCLUDED.price_unit,
        currency_code = EXCLUDED.currency_code,
        is_negotiable = EXCLUDED.is_negotiable,
        updated_at = now();

    INSERT INTO public.listing_discovery_channels (
        listing_id, channel_code, source, is_featured
    ) VALUES (property_listing_id, 'homes', 'editorial', false)
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
            'official_page_reference_code', '4T0923',
            'source_gallery_filename_reference_code', '4T0923',
            'source_reference_code_discrepancy', false,
            'source_page_id', 20069,
            'title_document_type', 'chanote',
            'title_deed_number', '26614',
            'title_document_count', 1,
            'land_area_rai', 33,
            'land_area_ngan', 1,
            'land_area_square_wah_remainder', 31,
            'land_area_square_wah', 13331,
            'land_area_sqm', 53324,
            'plot_count', 1,
            'vacant_land', true,
            'structures_present', false,
            'plot_shape', 'polygon',
            'two_road_frontages_reported', true,
            'south_road_frontage_m_approx', 328,
            'east_road_frontage_m_approx', 227,
            'summary_maximum_depth_m', 227,
            'detail_maximum_depth_to_public_watercourse_m_approx', 230,
            'plot_measurement_discrepancy', true,
            'maximum_depth_difference_m', 3,
            'public_watercourse_boundary_reported', true,
            'land_level_below_road_m_approx', 1,
            'primary_front_road_name', 'ถนนขอนแก่น-ยางตลาด (ทล.12)',
            'primary_front_road_legal_status_th', 'ทางสาธารณประโยชน์',
            'primary_front_road_surface', 'asphalt',
            'primary_front_road_width_m_approx', 12,
            'primary_front_right_of_way_width_m_approx', 40
        ) || jsonb_build_object(
            'secondary_front_road_name', 'ถนนสาย กส.3037',
            'secondary_front_road_surface', 'asphalt',
            'secondary_front_road_width_m_approx_from_plan', 6,
            'secondary_front_road_legal_status_not_published', true,
            'secondary_front_right_of_way_width_not_published', true,
            'zoning_color_th', 'สีขาวมีกรอบและเส้นทแยงสีเขียว',
            'surrounding_area_use_th', 'ย่านที่อยู่อาศัยและเกษตรกรรม',
            'mixed_use_classification', false,
            'mixed_use_exclusion_basis', 'SAM ระบุการใช้โดยรอบเป็นที่อยู่อาศัยและเกษตรกรรม ไม่ได้ระบุพาณิชยกรรมหรือ Mixed Use',
            'residential_classification', true,
            'agriculture_use_case', true,
            'intended_use_requires_independent_verification', true,
            'expropriation_corridor_reported', true,
            'expropriation_area_rai', 1,
            'expropriation_area_ngan', 3,
            'expropriation_area_square_wah_remainder', 25,
            'expropriation_area_square_wah_approx', 725,
            'expropriation_area_sqm_approx', 2900,
            'expropriation_share_of_total_percent_approx', 5.44,
            'expropriation_legal_basis_th', 'พระราชกฤษฎีกากำหนดเขตที่ดินในบริเวณที่จะเวนคืน พ.ศ. 2562',
            'expropriation_project_th', 'ถนนทางหลวงชนบทสายเลี่ยงเมืองยางตลาด',
            'expropriation_status_requires_authority_confirmation', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'price_per_square_wah', 2538,
            'computed_exact_price_per_square_wah', 2538.07,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_property_photo_dates_displayed', jsonb_build_array('2022-09-20', '2023-06-19', '2023-12-15'),
            'occupancy_status_not_published', true,
            'utilities_information_not_published', true,
            'flood_history_not_published', true,
            'soil_information_not_published', true,
            'other_encumbrances_not_published', true,
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '16.396564,103.320113',
            'administrator_coordinate_distance_from_source_m_approx', 79.4,
            'large_plot_may_contain_both_coordinate_points', true,
            'online_pin_not_boundary_evidence', true,
            'nearby_sam_asset_codes', jsonb_build_array('4T0921', '4T0922')
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
        'The official SAM NPA page identifies SAM as the asset holder and direct-sale contact for asset 4T0923. The page reports that approximately 1 rai 3 ngan 25 sq.wah lies within an expropriation corridor for the Yang Talat rural-road bypass under a 2019 Royal Decree. Buyers must confirm the latest corridor, acquisition stage, compensation rights, remaining land, access and every sale term directly with SAM and the responsible authorities.',
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
        (property_listing_id, 'ถนนขอนแก่น-ยางตลาด (ทล.12)', 'Khon Kaen-Yang Talat Highway 12', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ถนนสาย กส.3037', 'Kalasin Rural Road KS.3037', 'road', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'ลำรางสาธารณประโยชน์', 'Public watercourse', 'landmark', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'วัดปทุมคงคา', 'Wat Pathum Khongkha', 'landmark', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'องค์การบริหารส่วนตำบลยางตลาด', 'Yang Talat Subdistrict Administrative Organization', 'government', NULL, NULL, NULL, 50, true),
        (property_listing_id, 'สำนักงานพัฒนาฝีมือแรงงานกาฬสินธุ์', 'Kalasin Skill Development Office', 'government', NULL, NULL, NULL, 60, false),
        (property_listing_id, 'โรงพยาบาลยางตลาด', 'Yang Talat Hospital', 'healthcare', NULL, NULL, NULL, 70, false),
        (property_listing_id, 'แยกยางตลาด', 'Yang Talat Intersection', 'road', NULL, NULL, NULL, 80, false)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '33,835,000 บาท หรือประมาณ 2,538 บาท/ตร.ว. — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 33,835,000, approximately THB 2,538 per sq.wah — confirm the latest price with SAM', 'unspecified', 33835000, 'THB', 20),
        (property_listing_id, 'title_and_land_area', 'โฉนดและเนื้อที่', 'Title and land area', 'โฉนดเลขที่ 26614 จำนวน 1 ฉบับ เนื้อที่ 33 ไร่ 1 งาน 31 ตร.ว. (53,324 ตร.ม.)', 'One title deed, no. 26614, covering 33 rai 1 ngan 31 sq.wah (53,324 sq.m.)', 'buyer', 13331, 'square_wah', 30),
        (property_listing_id, 'expropriation_corridor', 'มีที่ดินบางส่วนอยู่ในแนวเวนคืน', 'Part of the land lies in an expropriation corridor', 'SAM ระบุประมาณ 1 ไร่ 3 งาน 25 ตร.ว. (2,900 ตร.ม. หรือราว 5.44%) อยู่ในแนวเวนคืนถนนเลี่ยงเมืองยางตลาดตาม พ.ร.ฎ. พ.ศ. 2562 ต้องตรวจแนวเขต ขั้นตอน ค่าทดแทน ผู้มีสิทธิ และพื้นที่คงเหลือล่าสุด', 'SAM reports approximately 1 rai 3 ngan 25 sq.wah (2,900 sq.m., about 5.44%) within the Yang Talat bypass expropriation corridor under a 2019 Royal Decree; verify the latest corridor, stage, compensation, entitlement and remaining land', 'buyer', 2900, 'square_metres', 40),
        (property_listing_id, 'two_road_frontages', 'ติดถนน 2 ด้าน', 'Two road frontages', 'ด้านใต้ติด ทล.12 กว้างประมาณ 328 เมตร และด้านตะวันออกติดถนน กส.3037 กว้างประมาณ 227 เมตร', 'Approximately 328 metres of southern frontage on Highway 12 and 227 metres of eastern frontage on KS.3037', 'buyer', NULL, '', 50),
        (property_listing_id, 'public_highway', 'ถนนขอนแก่น-ยางตลาด', 'Khon Kaen-Yang Talat Highway', 'ทล.12 เป็นทางสาธารณประโยชน์ ผิวลาดยางกว้างประมาณ 12 เมตร เขตทางประมาณ 40 เมตร', 'Highway 12 is described as a public asphalt road approximately twelve metres wide within a forty-metre right of way', 'unspecified', 12, 'metres', 60),
        (property_listing_id, 'depth_and_watercourse', 'ความลึกและลำรางสาธารณะ', 'Depth and public watercourse', 'ส่วนสรุประบุลึกสุด 227 เมตร แต่รายละเอียดระบุถึงลำรางประมาณ 230 เมตร ต้องรังวัดและตรวจระยะร่นลำราง', 'The summary gives a maximum depth of 227 metres while the detail states approximately 230 metres to the public watercourse; survey and verify watercourse setbacks', 'buyer', NULL, '', 70),
        (property_listing_id, 'land_level_and_zoning', 'ระดับดินและผังเมือง', 'Land level and zoning', 'ที่ดินต่ำกว่าถนนประมาณ 1 เมตร อยู่ในเขตสีขาวมีกรอบและเส้นทแยงสีเขียว ต้องตรวจต้นทุนถมดิน การระบายน้ำ น้ำท่วม และการใช้ประโยชน์', 'Land is approximately one metre below the road in white zoning with a green border and diagonal lines; verify fill, drainage, flooding and permitted use', 'buyer', 1, 'metres', 80),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ยืนยันโฉนด รังวัด แนวเวนคืน ค่าทดแทน พื้นที่คงเหลือ ลำราง แนวเขต ถนนทั้งสองด้าน ทางเข้าออก ระดับดิน ผังเมือง สาธารณูปโภค การครอบครอง ภาระผูกพัน และเงื่อนไขล่าสุด', 'Confirm the title, survey, expropriation corridor, compensation, remaining land, watercourse, boundaries, both roads, access, land level, zoning, utilities, possession, encumbrances and latest terms', 'buyer', NULL, '', 90)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ป้ายขายและบริเวณที่ดินติด ทล.12', 'ป้ายขายตรง SAM บริเวณที่ดินเปล่า 33 ไร่ติดถนนขอนแก่น-ยางตลาด', 'https://npa.sam.or.th/site/images/npa/20069/20250606144317_P3_66.jpg', '/listing-media/sam/4t0923/01.webp', 'image/webp', 30780, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'สภาพที่ดินมุมกว้าง', 'ภาพพื้นที่โล่งและพืชพรรณภายในแปลงที่ดิน 4T0923', 'https://npa.sam.or.th/site/images/npa/20069/P4_66.jpg', '/listing-media/sam/4t0923/02.webp', 'image/webp', 29622, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่เกษตรภายในแปลง', 'ภาพพื้นที่ราบและแนวพืชพรรณภายในที่ดินยางตลาด', 'https://npa.sam.or.th/site/images/npa/20069/4T0923P2_66.jpg', '/listing-media/sam/4t0923/03.webp', 'image/webp', 21038, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวที่ดินและร่องน้ำ', 'ภาพสภาพพื้นที่โล่งและแนวร่องน้ำภายในหรือข้างแปลงจาก SAM', 'https://npa.sam.or.th/site/images/npa/20069/4T0923P3_66.jpg', '/listing-media/sam/4t0923/04.webp', 'image/webp', 26034, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวเสาไฟฟ้าริมแปลง', 'ภาพแนวที่ดินและเสาไฟฟ้าตามแนวถนนข้างแปลง', 'https://npa.sam.or.th/site/images/npa/20069/4T0923P4_66.jpg', '/listing-media/sam/4t0923/05.webp', 'image/webp', 23644, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'สภาพพืชพรรณริมที่ดิน', 'ภาพพื้นที่หญ้าและต้นไม้ตามแนวขอบแปลง 4T0923', 'https://npa.sam.or.th/site/images/npa/20069/4T0923P5_66.jpg', '/listing-media/sam/4t0923/06.webp', 'image/webp', 24486, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวพืชพรรณหนาแน่น', 'ภาพพื้นที่พืชพรรณหนาแน่นบริเวณหนึ่งของแปลงที่ดิน', 'https://npa.sam.or.th/site/images/npa/20069/4T0923P6_66.jpg', '/listing-media/sam/4t0923/07.webp', 'image/webp', 37776, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ถนนขอนแก่น-ยางตลาดหน้าทรัพย์', 'ภาพแนวถนนขอนแก่น-ยางตลาด ทล.12 และตำแหน่งทรัพย์จากภาพ SAM', 'https://npa.sam.or.th/site/images/npa/20069/4T0923P1_65.jpg', '/listing-media/sam/4t0923/08.webp', 'image/webp', 22154, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังแปลง แนวเวนคืน และถนนสองด้าน', 'ผัง SAM แสดงโฉนด 26614 แนวเวนคืน ถนน ทล.12 ถนน กส.3037 ลำรางสาธารณะ และระยะโดยประมาณ', 'https://npa.sam.or.th/site/images/npa/20069/20230317084617_4T0923C1_65.jpg', '/listing-media/sam/4t0923/09.webp', 'image/webp', 14616, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางจากแยกยางตลาด', 'แผนที่ต้นทาง SAM แสดงเส้นทางตาม ทล.12 จากแยกยางตลาดไปยังทรัพย์ 4T0923', 'https://npa.sam.or.th/site/images/npa/20069/20221116111859_4T0923M1_65.jpg', '/listing-media/sam/4t0923/10.webp', 'image/webp', 36524, 785, 600, 100, false, true);

    INSERT INTO public.listing_sources (
        listing_id, source_type, publisher_name, source_url,
        reference_code, captured_at, notes
    ) VALUES (
        property_listing_id,
        'editorial_import',
        'บริษัท บริหารสินทรัพย์สุขุมวิท จำกัด (SAM)',
        'https://www.sam.or.th/site/npa/detail.php?id=20069&keyref=6004430',
        '4T0923',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA page id 20069. The page showed direct-purchase status and an announced sale price of THB 33,835,000, or THB 2,538 per sq.wah, for vacant land under title deed 26614 in Yang Talat Subdistrict and District, Kalasin. The single title covers 33 rai 1 ngan 31 sq.wah, or 13,331 sq.wah / 53,324 sq.m. SAM describes a polygonal plot fronting two roads: approximately 328 metres on the south along Khon Kaen-Yang Talat Highway 12 and approximately 227 metres on the east along KS.3037. The summary gives maximum depth as 227 metres while the detailed text gives approximately 230 metres to a public watercourse. Land is approximately one metre below road level. Highway 12 is described as a public asphalt road approximately twelve metres wide within a forty-metre right of way. The source plan labels KS.3037 as an approximately six-metre asphalt road, but the detailed text does not publish its legal status or right-of-way width. Material expropriation caveat: SAM reports that approximately 1 rai 3 ngan 25 sq.wah, or 725 sq.wah / 2,900 sq.m. / about 5.44 percent of the total area, lies within an expropriation corridor under a 2019 Royal Decree for the Yang Talat rural-road bypass. This does not establish that acquisition has been completed; buyers must confirm the latest corridor, affected area, stage, compensation rights, access and remaining land with SAM, the Land Office and the acquiring authority. The source identifies white zoning with a green border and diagonal lines and residential-agricultural surroundings. MapxProp classifies the land for homes discovery with residential and agricultural use cases, not mixed use or business, subject to permitted-use verification. Source property photos display 20 September 2022, 19 June 2023 and 15 December 2023. Utilities, occupancy, flood history, soil information and other encumbrances are not published. Administrator coordinates are approximately 79.4 metres from the rounded source coordinates and are used for the listing; because the plot is over 300 metres wide, both points may be within the same property, but online pins are not boundary evidence. MapxProp stores optimized copies of all ten unique source land, road, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: 33-Rai Land on Highway 12, Yang Talat, with Expropriation Corridor, THB 33.835M',
        E'Vacant land under title deed no. 26614 in Yang Talat Subdistrict and District, Kalasin. The single title covers 33 rai 1 ngan 31 sq.wah, or 13,331 sq.wah (53,324 sq.m.), and fronts Khon Kaen-Yang Talat Highway 12 and KS.3037. SAM publishes THB 2,538 per sq.wah and shows white zoning with a green border and diagonal lines.\n\nThe polygonal property fronts two roads: approximately 328 metres on the south along Highway 12 and approximately 227 metres on the east along KS.3037. Another boundary adjoins a public watercourse. The summary gives maximum depth as 227 metres, while the detailed text states approximately 230 metres to the watercourse. Buyers must verify the title, survey, shape, boundaries, dimensions, public watercourse, markers and access from both roads before offering.\n\nMost important caveat: SAM reports that approximately 1 rai 3 ngan 25 sq.wah, or 725 sq.wah (2,900 sq.m., about 5.44% of the total area), lies within an expropriation corridor under a 2019 Royal Decree for the Yang Talat rural-road bypass. This wording does not mean acquisition is complete. Buyers must confirm the latest alignment, acquisition stage, affected area, compensation amount and entitlement, effect on access and usable remaining land with SAM, the Land Office and the acquiring authority.\n\nLand level is approximately one metre below the road, so fill, drainage, flooding and road-connection costs require assessment. Highway 12 is described as a public asphalt road approximately twelve metres wide within a forty-metre right of way. The source plan labels KS.3037 as an approximately six-metre asphalt road, but the detailed text does not publish its legal status or right-of-way width. Verify highway access permissions, turning arrangements, both rights of way and every entrance.\n\nSAM describes residential and agricultural surroundings. MapxProp therefore places the land in homes discovery with residential and agricultural use cases, not mixed use or business. This is not approval for subdivision, construction, industrial or agricultural development. Buyers must verify the white-with-green-border-and-diagonal zoning rules, subdivision controls, public-watercourse setbacks, the expropriation corridor, environmental requirements, utilities and all permits.\n\nNearby places named by SAM include Wat Pathum Khongkha, the Yang Talat Subdistrict Administrative Organization, Kalasin Skill Development Office and Yang Talat Hospital. Directions use Highway 12 from Roi Et toward Khon Kaen; from Yang Talat Intersection continue approximately 3.8 kilometres and the property is on the right. SAM also identifies nearby assets 4T0921 and 4T0922.\n\nThe SAM page listed the property for direct purchase at an announced THB 33,835,000 when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, current price, offer procedures, expropriation details, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: 4T0923. MapxProp does not collect deposits or represent SAM.\n\nSource property photos display 20 September 2022, 19 June 2023 and 15 December 2023, and conditions may have changed. The source does not publish utilities, possession, flood history, soil information or other encumbrances. Administrator coordinates are approximately 79.4 metres from SAM\'s rounded coordinates. Since this is a large plot, both points may be within it, but an online pin must not replace a cadastral survey. Buyers should inspect and verify every current condition before deciding.',
        'Vacant land, title deed no. 26614',
        'Fronting Khon Kaen-Yang Talat Highway 12 and KS.3037',
        'Khon Kaen-Yang Talat Highway 12',
        'Yang Talat',
        'Yang Talat',
        'Kalasin',
        'SAM 33-Rai Land on Highway 12, Yang Talat, THB 33.835M',
        'Official SAM 4T0923: 33 rai 1 ngan 31 sq.wah of two-road-frontage land in Yang Talat; approximately 2,900 sq.m. is reported within an expropriation corridor.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale land 4T0923 title deed 26614 Yang Talat Kalasin Khon Kaen Yang Talat Highway 12 KS 3037 33 rai 1 ngan 31 sq.wah 53324 sq.m. THB 33835000 expropriation corridor bypass agriculture residential')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=20069&keyref=6004430'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=20069&keyref=6004430',
            'The official SAM NPA page identifies SAM as direct-sale contact for asset 4T0923. It reports approximately 1 rai 3 ngan 25 sq.wah within the Yang Talat bypass expropriation corridor under a 2019 Royal Decree. Buyers must independently confirm the current corridor, acquisition stage, compensation rights, remaining land, access, title, possession and latest terms.',
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
        '796d7ebc-904e-4c8d-b28d-b42d0b6c477d',
        jsonb_build_object(
            'reference_code', '4T0923',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'residence',
            'discovery_channels', jsonb_build_array('homes'),
            'title_document_count', 1,
            'plot_count', 1,
            'two_road_frontages_reported', true,
            'plot_measurement_discrepancy', true,
            'expropriation_corridor_reported', true,
            'expropriation_area_sqm_approx', 2900,
            'administrator_coordinate_distance_from_source_m_approx', 79.4,
            'source_reference_discrepancy', false,
            'source_image_count', 10
        )
    );
END $$;

COMMIT;
