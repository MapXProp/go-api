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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing SL0249';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing SL0249';
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
        'eed873c6-ab29-4c83-8adb-bf0a4dee0df4',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'shophouse',
        'mixed',
        'sale',
        'whole_property',
        'ขายตรง SAM อาคารพาณิชย์ 2 ชั้น พะแสง บ้านตาขุน 30 ตร.ว. ราคา 950,000 บาท',
        E'อาคารพาณิชย์ 2 ชั้น จำนวน 1 คูหา ในตำบลพะแสง อำเภอบ้านตาขุน จังหวัดสุราษฎร์ธานี ที่ดิน 30 ตร.ว. (120 ตร.ม.) เอกสารสิทธิ์ น.ส.3ก. เลขที่ 1074 จำนวน 1 ฉบับ หน้า SAM ระบุ 2 ห้องนอน 1 ห้องน้ำ\n\nที่ดินรูปสี่เหลี่ยมผืนผ้า ด้านทิศใต้ติดถนนสายตาขุน-เขื่อนรัชชประภา (สฎ.3062) หน้ากว้างประมาณ 4 เมตร ลึกประมาณ 30 เมตร ถนนเป็นทางสาธารณประโยชน์ ผิวจราจรลาดยางกว้างประมาณ 8 เมตร เขตทางกว้างประมาณ 30 เมตร อยู่ในเขตผังเมืองสีเขียว ย่านที่อยู่อาศัย และ SAM ระบุว่าสาธารณูปโภคครบถ้วน เหมาะสำหรับพิจารณาใช้เป็นหน้าร้าน สำนักงาน ที่พักอาศัย หรือการใช้งานแบบผสม ทั้งนี้ผู้ซื้อต้องตรวจสอบข้อกำหนดและความเหมาะสมกับกิจการจริง\n\nข้อควรตรวจสอบสำคัญ: รายการรับโอนกรรมสิทธิ์ของ SAM ระบุสิ่งปลูกสร้างเป็นตึกแถวสองชั้นครึ่ง เลขที่ 21/4 แต่ผลสำรวจสภาพระบุเป็นอาคารพาณิชย์ 2 ชั้น จำนวน 1 คูหา ไม่ติดเลขที่ และ SAM ระบุว่าจะโอนกรรมสิทธิ์สิ่งปลูกสร้างตามรายการที่จดทะเบียนรับโอนทางทะเบียนเท่านั้น ผู้ซื้อจึงต้องตรวจสอบทะเบียนอาคาร เลขที่อาคาร จำนวนชั้น รายการสิ่งปลูกสร้างที่จะโอน และสภาพจริงให้ตรงกันก่อนเสนอซื้อ\n\nเอกสารสิทธิ์เป็น น.ส.3ก. ตำแหน่ง รูปแปลง ระยะ เนื้อที่ แนวเขต และรายละเอียดสำคัญอาจคลาดเคลื่อนจากข้อมูลที่แสดง ผู้สนใจต้องตรวจสอบเอกสารสิทธิ์ ตำแหน่งจริง แนวเขต เนื้อที่ และข้อมูลที่เกี่ยวข้องให้เป็นที่พอใจก่อนตัดสินใจเสนอซื้อ ข้อมูลต้นทางระบุ ณ วันที่ 17 กุมภาพันธ์ 2569\n\nการเดินทางใช้ถนนสายสุราษฎร์ธานี-ตะกั่วป่า (ทล.401) จากอำเภอตะกั่วป่ามุ่งหน้าเมืองสุราษฎร์ธานี ผ่านสำนักงานที่ดินจังหวัดสุราษฎร์ธานี สาขาบ้านตาขุน ที่ว่าการอำเภอบ้านตาขุน โรงเรียนตาขุน และวัดตาขุน แล้วเลี้ยวซ้ายเข้าถนนสายตาขุน-เขื่อนรัชชประภา (สฎ.3062) ผ่านโรงแรมที.อาร์.รีสอร์ท จะพบทรัพย์อยู่ด้านขวามือ สถานที่ใกล้เคียงที่ SAM ระบุ ได้แก่ องค์การบริหารส่วนตำบลพะแสง การไฟฟ้าส่วนภูมิภาค สาขาบ้านตาขุน และวัดตาขุน\n\nหน้า SAM ระบุสถานะ “ซื้อตรง” และราคาประกาศขาย 950,000 บาท ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคา ค่าใช้จ่าย รายการที่จะโอน และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ SL0249 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nหน้าต้นทางไม่ระบุพื้นที่ใช้สอย ที่จอดรถ อายุอาคาร สถานะผู้ใช้ประโยชน์ ภาระผูกพันอื่น หรือสภาพระบบไฟฟ้าและประปาภายใน ภาพทรัพย์ต้นทางมีวันที่กำกับ 29 กันยายน 2568 ผู้ซื้อควรนัดตรวจทรัพย์และตรวจสอบสภาพ เอกสารสิทธิ์ แนวเขต และเงื่อนไขล่าสุดก่อนตัดสินใจ',
        950000,
        false,
        120,
        2,
        1,
        2,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'เลขที่ตามทะเบียน 21/4',
        'ถนนสายบ้านตาขุน-เขื่อนรัชชประภา (สฎ.3062)',
        'ถนนสายตาขุน-เขื่อนรัชชประภา (สฎ.3062)',
        NULL,
        8.93504012,
        98.87037228,
        'สุราษฎร์ธานี',
        'บ้านตาขุน',
        'พะแสง',
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
        'sam-direct-sale-shophouse-pha-saeng-ban-ta-khun-sl0249'
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
        property_listing_id, 'sale', 950000, 'total', 'THB', false
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
            'title_document_type', 'nor_sor_3_kor',
            'title_document_type_th', 'น.ส.3ก.',
            'title_document_number', '1074',
            'title_document_count', 1,
            'land_area_square_wah', 30,
            'land_area_sqm', 120,
            'bedroom_count', 2,
            'bathroom_count', 1,
            'registered_floor_count', 2.5,
            'surveyed_floor_count', 2,
            'unit_count', 1,
            'registered_transfer_description', 'ตึกแถวสองชั้นครึ่ง เลขที่ 21/4',
            'registered_address_number', '21/4',
            'surveyed_structure_description', 'อาคารพาณิชย์ 2 ชั้น จำนวน 1 คูหา ไม่ติดเลขที่',
            'surveyed_has_displayed_address_number', false,
            'transaction_follows_registered_structure_record', true,
            'structure_records_require_buyer_review', true,
            'plot_shape', 'rectangle',
            'south_road_frontage_m', 4,
            'maximum_depth_m', 30,
            'access_type', 'public_road',
            'front_road_name', 'ถนนสายตาขุน-เขื่อนรัชชประภา (สฎ.3062)',
            'front_road_surface', 'asphalt',
            'front_road_width_m', 8,
            'front_right_of_way_width_m', 30,
            'zoning_color_th', 'สีเขียว',
            'surrounding_area_use_th', 'ที่อยู่อาศัย',
            'utilities_complete_according_to_source', true,
            'non_title_deed_location_boundary_warning', true,
            'location_shape_dimensions_area_may_vary', true,
            'buyer_must_verify_title_location_and_boundaries', true,
            'usable_area_not_published', true,
            'parking_information_not_published', true,
            'building_age_not_published', true,
            'occupancy_status_not_published', true,
            'other_encumbrances_not_published', true,
            'internal_utilities_condition_not_published', true,
            'source_photo_date_displayed', '2025-09-29',
            'source_information_date', '2026-02-17',
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-09',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '8.935020,98.870368',
            'administrator_coordinate_distance_from_source_m_approx', 2.29
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for SL0249. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนสายตาขุน-เขื่อนรัชชประภา (สฎ.3062)', 'Ta Khun–Ratchaprapha Dam Road (SR.3062)', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'องค์การบริหารส่วนตำบลพะแสง', 'Pha Saeng Subdistrict Administrative Organization', 'government', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'การไฟฟ้าส่วนภูมิภาค สาขาบ้านตาขุน', 'Provincial Electricity Authority, Ban Ta Khun Branch', 'government', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'วัดตาขุน', 'Wat Ta Khun', 'landmark', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'ที่ว่าการอำเภอบ้านตาขุน', 'Ban Ta Khun District Office', 'government', NULL, NULL, NULL, 50, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '950,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 950,000 — confirm the latest price with SAM', 'unspecified', 950000, 'THB', 20),
        (property_listing_id, 'title_document_due_diligence', 'การตรวจสอบเอกสารสิทธิ์', 'Title-document due diligence', 'เอกสารสิทธิ์เป็น น.ส.3ก. ตำแหน่ง รูปแปลง ระยะ เนื้อที่ และแนวเขตอาจคลาดเคลื่อน ผู้ซื้อต้องตรวจสอบก่อนเสนอซื้อ', 'The land document is Nor Sor 3 Kor; location, shape, dimensions, area and boundaries may vary and must be verified before offering', 'buyer', NULL, '', 30),
        (property_listing_id, 'registered_structure_transfer', 'สิ่งปลูกสร้างตามรายการรับโอน', 'Structure in acquisition records', 'รายการรับโอนระบุตึกแถว 2 ชั้นครึ่ง เลขที่ 21/4 แต่ผลสำรวจระบุอาคารพาณิชย์ 2 ชั้น 1 คูหาไม่ติดเลขที่ โดย SAM จะโอนตามรายการที่จดทะเบียนรับโอนทางทะเบียนเท่านั้น', 'The acquisition record identifies a 2.5-storey row building numbered 21/4, while the survey describes one unnumbered two-storey shophouse; SAM will transfer according to its registered acquisition record only', 'unspecified', NULL, '', 40),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนเสนอซื้อ', 'Buyer due diligence', 'ผู้ซื้อต้องตรวจสอบสภาพทรัพย์ เอกสารสิทธิ์ ทะเบียนอาคาร แนวเขต รายการที่จะโอน ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขล่าสุดกับ SAM', 'Buyers must verify property condition, title and building records, boundaries, transferred items, encumbrances, expenses and current terms with SAM', 'buyer', NULL, '', 50)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'อาคารพาณิชย์ติดถนนสาย สฎ.3062', 'ภาพมุมกว้างของอาคารพาณิชย์ SAM รหัส SL0249 ติดถนนสายตาขุน-เขื่อนรัชชประภา', 'https://npa.sam.or.th/site/images/npa/22990/20260212132113_SL0249P1_69.jpg', '/listing-media/sam/sl0249/01.webp', 'image/webp', 19956, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ด้านหน้าอาคารพาณิชย์', 'ด้านหน้าอาคารพาณิชย์ 2 ชั้น 1 คูหา รหัส SL0249 ถ่ายเมื่อ 29 กันยายน 2568', 'https://npa.sam.or.th/site/images/npa/22990/SL0249P2_69.jpg', '/listing-media/sam/sl0249/02.webp', 'image/webp', 28376, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'หน้าคูหาและประตูม้วน', 'ภาพใกล้ของหน้าคูหา ประตูม้วน และชั้นบนของอาคารพาณิชย์ SL0249', 'https://npa.sam.or.th/site/images/npa/22990/SL0249P3_69.jpg', '/listing-media/sam/sl0249/03.webp', 'image/webp', 22290, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แปลนชั้น 1 และชั้น 2', 'แปลนต้นทางแสดงโถง ห้องครัว ห้องน้ำ ห้องนอน และระเบียงของอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/22990/SL0249C3_69.jpg', '/listing-media/sam/sl0249/04.webp', 'image/webp', 12444, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังแปลงที่ดิน 30 ตารางวา', 'ผังแปลงสี่เหลี่ยมผืนผ้าหน้ากว้างประมาณ 4 เมตรและลึกประมาณ 30 เมตรติดถนน สฎ.3062', 'https://npa.sam.or.th/site/images/npa/22990/20260212132113_SL0249C1_69.jpg', '/listing-media/sam/sl0249/05.webp', 'image/webp', 15152, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังตำแหน่งอาคารบนแปลง', 'ผังแสดงตำแหน่งอาคารพาณิชย์ 2 ชั้นบนแปลงที่ดินและแนวถนนสายตาขุน-เขื่อนรัชชประภา', 'https://npa.sam.or.th/site/images/npa/22990/20260212132113_SL0249C2_69.jpg', '/listing-media/sam/sl0249/06.webp', 'image/webp', 17278, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แผนที่การเดินทางไปทรัพย์', 'แผนที่ต้นทางแสดงเส้นทางและสถานที่สำคัญรอบทรัพย์ SL0249 ในอำเภอบ้านตาขุน', 'https://npa.sam.or.th/site/images/npa/22990/20260212132113_SL0249M_69.jpg', '/listing-media/sam/sl0249/07.webp', 'image/webp', 34780, 785, 600, 70, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=22990',
        'SL0249',
        '2026-09-09 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 950,000 for one shophouse unit with two bedrooms and one bathroom on Nor Sor 3 Kor document no. 1074 covering 30 sq.wah / 120 sq.m. The rectangular plot has approximately four meters of south frontage and approximately 30 meters of depth on a public asphalt road approximately eight meters wide within an approximately 30-meter right of way. The registered acquisition record describes a 2.5-storey row building numbered 21/4, while the condition survey describes one unnumbered two-storey shophouse; SAM states that transfer will follow the registered acquisition record only. Nor Sor 3 Kor location, shape, dimensions, area and boundaries may vary and require buyer verification. Source information is dated 17 February 2026 and source property photos display 29 September 2025. Usable area, parking, building age, occupancy, other encumbrances and internal utility condition are not published. Administrator-supplied coordinates are approximately 2.29 meters from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all seven source property, floor-plan, plot and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Two-Storey Shophouse in Pha Saeng, Ban Ta Khun, THB 950,000',
        E'One two-storey shophouse unit in Pha Saeng, Ban Ta Khun, Surat Thani, on 30 sq.wah (120 sq.m.) of land under Nor Sor 3 Kor document no. 1074. The SAM page lists two bedrooms and one bathroom.\n\nThe rectangular plot has approximately four meters of south frontage on Ta Khun–Ratchaprapha Dam Road (SR.3062) and approximately 30 meters of depth. The frontage is a public asphalt road approximately eight meters wide within an approximately 30-meter right of way. SAM describes green zoning, a residential setting and complete utilities. The property may be considered for retail, office, residential or mixed use, subject to independent verification of suitability and applicable requirements.\n\nImportant record discrepancy: SAM''s registered acquisition record describes a 2.5-storey row building numbered 21/4, while the condition survey describes one unnumbered two-storey shophouse. SAM states that transfer to the buyer will follow the structure information in its registered acquisition record only. Buyers must verify the building registration, address number, storey count, structures included in the transfer and actual condition before submitting an offer.\n\nThe land document is Nor Sor 3 Kor. SAM warns that the displayed location, plot shape, dimensions, area, boundaries and other material details may vary. Buyers must verify the document, actual location, boundaries, area and related information to their satisfaction. The source property information is dated 17 February 2026.\n\nAccess is from Highway 401 from Takua Pa toward Surat Thani. Pass the Ban Ta Khun Land Office, Ban Ta Khun District Office, Ta Khun School and Wat Ta Khun, then turn left onto Ta Khun–Ratchaprapha Dam Road (SR.3062). Continue past T.R. Resort; the property is on the right. Nearby places listed by SAM include the Pha Saeng Subdistrict Administrative Organization, the Provincial Electricity Authority Ban Ta Khun branch and Wat Ta Khun.\n\nThe SAM page lists the property as direct purchase with an announced sale price of THB 950,000. It is not an auction. Contact SAM directly to confirm availability, offer procedures, current price, expenses, transferred items and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: SL0249. MapxProp does not collect deposits or represent SAM in the transaction.\n\nThe source does not publish internal usable area, parking, building age, occupancy, other encumbrances or the condition of internal electrical and plumbing systems. The source property photos display 29 September 2025. Buyers should arrange an inspection and verify current condition, title and building records, boundaries and terms before deciding.',
        'Registered address no. 21/4',
        'Ta Khun–Ratchaprapha Dam Road (SR.3062)',
        'Ta Khun–Ratchaprapha Dam Road (SR.3062)',
        'Pha Saeng',
        'Ban Ta Khun',
        'Surat Thani',
        'SAM Direct-Sale Shophouse in Ban Ta Khun, Surat Thani, THB 950K',
        'Official SAM NPA asset SL0249: two-storey shophouse on 120 sq.m., 2 bedrooms, 1 bathroom. Direct-sale price THB 950,000; building-record discrepancy disclosed.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset SL0249 shophouse commercial building Pha Saeng Ban Ta Khun Surat Thani 30 sq.wah 120 sq.m. Nor Sor 3 Kor 1074 two bedrooms one bathroom THB 950000')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=22990'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=22990',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for SL0249. The specifications, title-document warning, building-record discrepancy, images, rounded coordinates, announced price and direct-purchase status come from that record.',
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
        'eed873c6-ab29-4c83-8adb-bf0a4dee0df4',
        jsonb_build_object(
            'reference_code', 'SL0249',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'title_document_type', 'nor_sor_3_kor',
            'structure_record_discrepancy', true
        )
    );
END $$;

COMMIT;
