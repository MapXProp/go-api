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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing SL0097';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing SL0097';
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
        'a2115a19-15f0-4f8c-817f-637c618f5fc8',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'shophouse',
        'mixed',
        'sale',
        'whole_property',
        'ขายตรง SAM อาคารพาณิชย์ 2 ชั้น ติด ทล.401 ต้นยวน พนม 22 ตร.ว. ราคา 2.11 ล้านบาท',
        E'อาคารพาณิชย์ 2 ชั้น จำนวน 1 คูหา ไม่ปรากฏเลขที่ ติดถนนสายสุราษฎร์ธานี-ตะกั่วป่า (ทล.401) ตำบลต้นยวน อำเภอพนม จังหวัดสุราษฎร์ธานี ที่ดิน 22 ตร.ว. (88 ตร.ม.) โฉนดที่ดินเลขที่ 6228 จำนวน 1 ฉบับ โดยรายการรับโอนกรรมสิทธิ์ของ SAM ระบุสิ่งปลูกสร้างเป็นตึกแถวสองชั้นไม่มีเลขที่\n\nที่ดินรูปสี่เหลี่ยมผืนผ้า ด้านทิศใต้ติดถนน หน้ากว้างประมาณ 4 เมตร ลึกประมาณ 22 เมตร อยู่ในเขตผังเมืองสีชมพู ย่านที่อยู่อาศัยและพาณิชยกรรม เหมาะสำหรับพิจารณาใช้เป็นหน้าร้าน สำนักงาน ที่พักอาศัย หรือการใช้งานแบบผสม ทั้งนี้ผู้ซื้อต้องตรวจสอบข้อกำหนดและความเหมาะสมกับกิจการจริง\n\nถนนหน้าทรัพย์เป็นทางสาธารณประโยชน์ ผิวจราจรลาดยาง หน้า SAM ระบุความกว้างผิวจราจรประมาณ 14 เมตร แต่ระบุเขตทางประมาณ 5 เมตร ซึ่งตัวเลขเขตทางน้อยกว่าความกว้างผิวจราจรและอาจต้องตรวจสอบซ้ำ ผู้ซื้อควรให้ SAM และหน่วยงานทางหลวงยืนยันแนวเขตทาง ระยะร่น ทางเข้า-ออก และขนาดจริงก่อนเสนอซื้อ\n\nสำคัญ: หน้า SAM แสดงคำเตือนว่ามีผู้ใช้ประโยชน์ในทรัพย์สินและขายตามสภาพ ผู้ซื้อต้องตรวจสอบทรัพย์ก่อนเสนอซื้อ และอาจต้องเจรจาหรือดำเนินการทางกฎหมายเพื่อเข้าครอบครองด้วยค่าใช้จ่ายของผู้ซื้อเอง ไม่สามารถใช้ประเด็นการครอบครองเป็นเหตุยกเลิกการเสนอซื้อหรือสัญญา หรือเรียกร้องจาก SAM ได้ ข้อมูลรายละเอียดส่วนนี้ระบุ ณ วันที่ 1 พฤษภาคม 2567 จึงต้องสอบถามสถานะล่าสุดกับ SAM\n\nSAM ระบุว่าจากการตรวจสอบผ่านเว็บพิทักษ์ไพร ทรัพย์ไม่อยู่ในเขตป่าสงวนหรือป่าไม้ถาวร แต่อยู่ใกล้บริเวณพื้นที่นิคมสหกรณ์อำเภอเขาพนม ผู้ซื้อควรตรวจสอบแนวเขต สถานะที่ดิน ข้อจำกัดการใช้ประโยชน์ และข้อมูลล่าสุดกับหน่วยงานที่เกี่ยวข้องให้เป็นที่พอใจก่อนเสนอซื้อ\n\nการเดินทางใช้ถนนสายสุราษฎร์ธานี-ตะกั่วป่า (ทล.401) จากจังหวัดพังงามุ่งหน้าตัวเมืองสุราษฎร์ธานี ผ่านโรงพยาบาลต้นยวน โรงเรียนชุมชนวัดปากตรัง วัดนิโครธาราม และปั๊มน้ำมันเชลล์ จะพบทรัพย์อยู่ด้านซ้ายมือ สถานที่ใกล้เคียงที่ SAM ระบุ ได้แก่ โรงเรียนอนุบาลเปี่ยมรัก วัดนิโครธาราม และโรงเรียนชุมชนวัดปากตรัง\n\nหน้า SAM ระบุสถานะ “ซื้อตรง” และราคาประกาศขาย 2,110,000 บาท ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย สถานะผู้ใช้ประโยชน์ ขั้นตอนเสนอซื้อ ราคา ค่าใช้จ่าย การเข้าครอบครอง และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ SL0097 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nหน้าต้นทางไม่ระบุพื้นที่ใช้สอย จำนวนห้องนอน ห้องน้ำ ที่จอดรถ อายุอาคาร ระบบสาธารณูปโภค ภาระผูกพันอื่น หรือสภาพภายในโดยละเอียด ภาพทรัพย์ต้นทางมีวันที่กำกับ 1 พฤษภาคม 2567 ผู้ซื้อควรนัดตรวจทรัพย์และตรวจสอบสภาพ เอกสารสิทธิ์ ทะเบียนอาคาร แนวเขต และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        2110000,
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
        'ตึกแถวสองชั้น ไม่ปรากฏเลขที่',
        'ติดถนนสายสุราษฎร์ธานี-ตะกั่วป่า (ทล.401)',
        'ถนนสายสุราษฎร์ธานี-ตะกั่วป่า (ทล.401)',
        NULL,
        8.88699088,
        98.88057052,
        'สุราษฎร์ธานี',
        'พนม',
        'ต้นยวน',
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
        'sam-direct-sale-shophouse-highway-401-ton-yuan-phanom-sl0097'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES
        (property_listing_id, 'retail'),
        (property_listing_id, 'office'),
        (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 2110000, 'total', 'THB', false
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
        (property_listing_id, 'business', 'editorial', false),
        (property_listing_id, 'homes', 'editorial', false)
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
            'title_deed_number', '6228',
            'title_document_count', 1,
            'land_area_square_wah', 22,
            'land_area_sqm', 88,
            'floor_count', 2,
            'unit_count', 1,
            'registered_transfer_description', 'ตึกแถวสองชั้น ไม่มีเลขที่',
            'registered_has_address_number', false,
            'plot_shape', 'rectangle',
            'south_road_frontage_m', 4,
            'maximum_depth_m', 22,
            'access_type', 'public_road',
            'front_road_name', 'ถนนสายสุราษฎร์ธานี-ตะกั่วป่า (ทล.401)',
            'front_road_surface', 'asphalt',
            'front_road_width_m', 14,
            'front_right_of_way_width_m', 5,
            'source_reported_road_width_exceeds_right_of_way_width', true,
            'road_dimensions_require_buyer_confirmation', true,
            'zoning_color_th', 'สีชมพู',
            'surrounding_area_use_th', 'ที่อยู่อาศัยและพาณิชยกรรม',
            'forest_check_source', 'พิทักษ์ไพร ตามที่ SAM ระบุ',
            'outside_reserved_or_permanent_forest_according_to_source', true,
            'near_khao_phanom_cooperative_settlement_area_according_to_source', true,
            'forest_and_settlement_boundaries_require_buyer_confirmation', true,
            'property_has_current_user', true,
            'occupancy_information_dated_on', '2024-05-01',
            'sold_as_is', true,
            'buyer_responsible_for_obtaining_possession', true,
            'usable_area_not_published', true,
            'bedroom_count_not_published', true,
            'bathroom_count_not_published', true,
            'parking_information_not_published', true,
            'building_age_not_published', true,
            'utilities_information_not_published', true,
            'other_encumbrances_not_published', true,
            'interior_condition_not_published', true,
            'source_photo_date_displayed', '2024-05-01',
            'source_information_date', '2024-05-01',
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-09',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '8.886990,98.880570',
            'administrator_coordinate_distance_from_source_m_approx', 0.114
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for SL0097. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนสายสุราษฎร์ธานี-ตะกั่วป่า (ทล.401)', 'Surat Thani–Takua Pa Road (Highway 401)', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'โรงเรียนอนุบาลเปี่ยมรัก', 'Piam Rak Kindergarten', 'education', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'วัดนิโครธาราม', 'Wat Nikhotharam', 'landmark', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'โรงเรียนชุมชนวัดปากตรัง', 'Chumchon Wat Pak Trang School', 'education', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'โรงพยาบาลต้นยวน', 'Ton Yuan Hospital', 'healthcare', NULL, NULL, NULL, 50, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '2,110,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 2,110,000 — confirm the latest price with SAM', 'unspecified', 2110000, 'THB', 20),
        (property_listing_id, 'occupancy_and_possession', 'ผู้ใช้ประโยชน์และการเข้าครอบครอง', 'Current user and possession', 'มีผู้ใช้ประโยชน์ในทรัพย์ ผู้ซื้อรับผิดชอบการเจรจาหรือดำเนินการทางกฎหมายและค่าใช้จ่ายเพื่อเข้าครอบครองเอง', 'The property has a current user; the buyer is responsible for negotiations or legal action and the costs of obtaining possession', 'buyer', NULL, '', 30),
        (property_listing_id, 'sold_as_is', 'สภาพการขาย', 'Sale condition', 'ขายตามสภาพที่เป็นอยู่ ผู้ซื้อต้องตรวจสอบทรัพย์ก่อนเสนอซื้อ', 'Sold as is; buyers must inspect the property before submitting an offer', 'unspecified', NULL, '', 40),
        (property_listing_id, 'road_measurements', 'ขนาดถนนและเขตทาง', 'Road and right-of-way measurements', 'ต้นทางระบุผิวจราจรกว้างประมาณ 14 เมตร แต่เขตทางประมาณ 5 เมตร ซึ่งควรให้ SAM และหน่วยงานทางหลวงยืนยัน', 'The source reports an approximately 14-meter carriageway but an approximately 5-meter right of way; confirm both measurements with SAM and the highway authority', 'buyer', NULL, '', 50),
        (property_listing_id, 'forest_and_settlement_review', 'แนวเขตป่าและพื้นที่นิคมสหกรณ์', 'Forest and cooperative-settlement review', 'SAM ระบุว่าทรัพย์ไม่อยู่ในป่าสงวนหรือป่าไม้ถาวร แต่อยู่ใกล้พื้นที่นิคมสหกรณ์อำเภอเขาพนม ผู้ซื้อต้องตรวจสอบแนวเขตและข้อจำกัดล่าสุด', 'SAM states that the property is outside reserved or permanent forest but near the Khao Phanom cooperative-settlement area; buyers must verify current boundaries and restrictions', 'buyer', NULL, '', 60)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ด้านหน้าอาคารพาณิชย์ SL0097', 'อาคารพาณิชย์ 2 ชั้น 1 คูหาติดถนนสายสุราษฎร์ธานี-ตะกั่วป่า รหัส SL0097', 'https://npa.sam.or.th/site/images/npa/22153/20241113105719_SL0097P3_67.jpg', '/listing-media/sam/sl0097/01.webp', 'image/webp', 26920, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'อาคารและคูหาข้างเคียงด้านซ้าย', 'ภาพมุมกว้างแสดงอาคารพาณิชย์ SL0097 และแนวคูหาข้างเคียงทางด้านซ้าย', 'https://npa.sam.or.th/site/images/npa/22153/SL0097P2_67.jpg', '/listing-media/sam/sl0097/02.webp', 'image/webp', 26724, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'อาคารและแนวถนนด้านขวา', 'ภาพมุมกว้างแสดงอาคารพาณิชย์ SL0097 แนวอาคารข้างเคียง และถนน ทล.401', 'https://npa.sam.or.th/site/images/npa/22153/SL0097P1_67.jpg', '/listing-media/sam/sl0097/03.webp', 'image/webp', 29438, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังแปลงที่ดิน 22 ตารางวา', 'ผังแปลงสี่เหลี่ยมผืนผ้าหน้ากว้างประมาณ 4 เมตรและลึกประมาณ 22 เมตรติดถนน ทล.401', 'https://npa.sam.or.th/site/images/npa/22153/20241113105719_SL0097C1_67.jpg', '/listing-media/sam/sl0097/04.webp', 'image/webp', 15084, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังตำแหน่งอาคารบนแปลง', 'ผังแสดงอาคารพาณิชย์ 2 ชั้นบนแปลงที่ดินและแนวถนนสายสุราษฎร์ธานี-ตะกั่วป่า', 'https://npa.sam.or.th/site/images/npa/22153/20241113105719_SL0097C2_67.jpg', '/listing-media/sam/sl0097/05.webp', 'image/webp', 16574, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แผนที่การเดินทางไปทรัพย์', 'แผนที่ต้นทางแสดงตำแหน่งทรัพย์ SL0097 และสถานที่สำคัญตามแนวถนน ทล.401', 'https://npa.sam.or.th/site/images/npa/22153/20241113105719_SL0097M_67.jpg', '/listing-media/sam/sl0097/06.webp', 'image/webp', 18772, 785, 600, 60, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?ref=71605497&id=22153',
        'SL0097',
        '2026-09-09 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 2,110,000 for one unnumbered two-storey row-building unit on title deed no. 6228 covering 22 sq.wah / 88 sq.m. The rectangular plot has approximately four meters of south frontage and approximately 22 meters of depth on Highway 401. The source reports an approximately 14-meter asphalt carriageway but an approximately 5-meter right of way, an internally inconsistent measurement requiring confirmation. The page flags a current user and states that the property is sold as is; the buyer bears responsibility and costs for obtaining possession. SAM states that its Pitakprai check places the property outside reserved and permanent forest but near the Khao Phanom cooperative-settlement area, which also requires buyer verification. Source property and occupancy information is dated 1 May 2024, and source photos display the same date. Usable area, room counts, parking, building age, utilities, other encumbrances and detailed interior condition are not published. Administrator-supplied coordinates are approximately 0.114 meters from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all six source property, plot and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Two-Storey Shophouse on Highway 401, Ton Yuan, THB 2.11M',
        E'One unnumbered two-storey shophouse unit on Surat Thani–Takua Pa Road (Highway 401), Ton Yuan, Phanom, Surat Thani. The property occupies 22 sq.wah (88 sq.m.) under title deed no. 6228. SAM''s acquisition record describes the structure as an unnumbered two-storey row building.\n\nThe rectangular plot has approximately four meters of south frontage and approximately 22 meters of depth. SAM identifies pink zoning in a residential and commercial area. The property may be considered for retail, office, residential or mixed use, subject to independent verification of suitability and applicable requirements.\n\nThe frontage is a public asphalt road. The SAM page reports an approximately 14-meter carriageway but an approximately 5-meter right of way. Because the reported right of way is narrower than the carriageway, buyers should ask SAM and the highway authority to confirm the road boundary, setbacks, access and actual measurements before submitting an offer.\n\nImportant: the SAM page flags a current user and states that the property is sold as is. The buyer must inspect before submitting an offer and may need to negotiate or take legal action to obtain possession at the buyer''s own cost. Occupancy cannot be used to cancel an offer or agreement or to make claims against SAM. This section of the source information is dated 1 May 2024, so current possession status must be reconfirmed.\n\nSAM states that its check through the Pitakprai website found the property outside reserved forest and permanent forest, but near the Khao Phanom cooperative-settlement area. Buyers should verify current boundaries, land status and applicable use restrictions with the relevant authorities to their satisfaction.\n\nTravel via Highway 401 from Phang Nga toward Surat Thani, passing Ton Yuan Hospital, Chumchon Wat Pak Trang School, Wat Nikhotharam and the Shell service station. The property is on the left. Nearby places listed by SAM include Piam Rak Kindergarten, Wat Nikhotharam and Chumchon Wat Pak Trang School.\n\nThe SAM page lists the property as direct purchase with an announced sale price of THB 2,110,000. It is not an auction. Contact SAM directly to confirm availability, current user status, offer procedures, current price, possession costs and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: SL0097. MapxProp does not collect deposits or represent SAM in the transaction.\n\nThe source does not publish internal usable area, bedroom or bathroom counts, parking, building age, utilities, other encumbrances or detailed interior condition. Source property photos display 1 May 2024. Buyers should arrange an inspection and verify title and building records, boundaries, current condition and all terms before deciding.',
        'Unnumbered two-storey row building',
        'Fronting Surat Thani–Takua Pa Road (Highway 401)',
        'Surat Thani–Takua Pa Road (Highway 401)',
        'Ton Yuan',
        'Phanom',
        'Surat Thani',
        'SAM Direct-Sale Shophouse on Highway 401 in Phanom, THB 2.11M',
        'Official SAM NPA asset SL0097: two-storey shophouse on 88 sq.m. along Highway 401. Direct-sale price THB 2.11M; current user and possession warning disclosed.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset SL0097 shophouse commercial building Highway 401 Surat Thani Takua Pa Road Ton Yuan Phanom Surat Thani 22 sq.wah 88 sq.m. title deed 6228 THB 2110000 current user occupied')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?ref=71605497&id=22153'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?ref=71605497&id=22153',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for SL0097. The specifications, images, rounded coordinates, announced price, direct-purchase status, current-user warning, road measurements and forest-check note come from that record.',
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
        'a2115a19-15f0-4f8c-817f-637c618f5fc8',
        jsonb_build_object(
            'reference_code', 'SL0097',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'occupancy_warning', true,
            'road_measurements_require_confirmation', true,
            'forest_proximity_note', true
        )
    );
END $$;

COMMIT;
