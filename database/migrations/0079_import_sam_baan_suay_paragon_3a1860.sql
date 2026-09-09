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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing 3A1860';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing 3A1860';
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
        'c13f4249-b1ef-4cf3-b980-48378e4f27fb',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'shophouse',
        'mixed',
        'sale',
        'whole_property',
        'บ้านสวยพารากอน',
        '188/265',
        'ขายตรง SAM อาคารพาณิชย์หลังริม 2 ชั้น บ้านสวยพารากอน วัดประดู่ 27 ตร.ว. ราคา 2.489 ล้านบาท',
        E'อาคารพาณิชย์หลังริม 2 ชั้น เลขที่ตามหน้ารายละเอียด SAM 188/265 ในโครงการบ้านสวยพารากอน ตำบลวัดประดู่ อำเภอเมืองสุราษฎร์ธานี จังหวัดสุราษฎร์ธานี ที่ดิน 27 ตร.ว. (108 ตร.ม.) โฉนดที่ดินเลขที่ 109187 จำนวน 1 ฉบับ มี 2 ห้องนอน 2 ห้องน้ำ โดยรายการรับโอนกรรมสิทธิ์ของ SAM ระบุสิ่งปลูกสร้างเป็นตึกแถว 2 ชั้น เลขที่ 188/265\n\nแปลงที่ดินรูปสี่เหลี่ยมผืนผ้าและติดถนนในโครงการ 2 ด้าน ด้านทิศตะวันตกกว้างประมาณ 6 เมตร ด้านทิศเหนือกว้างประมาณ 18 เมตร และลึกสุดประมาณ 18 เมตร เป็นหลังริมจึงมีแนวเปิดด้านข้าง ถนนหมู่บ้านบ้านสวยพารากอนเป็นทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว ผิวคอนกรีตเสริมเหล็กกว้างประมาณ 6 เมตร เขตทางประมาณ 8 เมตร อยู่ในเขตผังเมืองสีชมพูและย่านที่อยู่อาศัย เหมาะสำหรับพิจารณาใช้เป็นหน้าร้าน สำนักงาน ที่พักอาศัย หรือการใช้งานแบบผสม ทั้งนี้ผู้ซื้อต้องตรวจสอบข้อกำหนดโครงการและความเหมาะสมกับกิจการจริง\n\nข้อควรตรวจสอบสำคัญ: หน้ารายละเอียดและรายการรับโอนของ SAM ระบุเลขที่ 188/265 แต่ผังสิ่งปลูกสร้างในชุดภาพต้นทางระบุ “ตึกแถว 2 ชั้น เลขที่ 188/264” ผู้ซื้อควรให้ SAM ยืนยันเลขที่อาคาร ทะเบียนอาคาร ความสัมพันธ์กับโฉนดเลขที่ 109187 ขอบเขตแปลง และรายการสิ่งปลูกสร้างที่จะโอนก่อนเสนอซื้อ ไม่ควรอาศัยเลขที่จากภาพหรือข้อความเพียงส่วนเดียว\n\nการเดินทางใช้ถนนสายสุราษฎร์ธานี-กองบิน 7 (ทล.417) จากกองบิน 7 มุ่งหน้าเซ็นทรัลพลาซา สุราษฎร์ธานี เลี้ยวซ้ายเข้าซอยโรงพยาบาลกรุงเทพ จากนั้นเลี้ยวขวาและตรงเข้าถนนหมู่บ้านบ้านสวยพารากอน รวมประมาณ 600 เมตร ทรัพย์อยู่ด้านขวามือและเป็นหลังริม สถานที่ใกล้เคียงที่ SAM ระบุ ได้แก่ โรงพยาบาลกรุงเทพสุราษฎร์ โฮมโปร สุราษฎร์ธานี เซ็นทรัล สุราษฎร์ธานี และสำนักงานขนส่งจังหวัดสุราษฎร์ธานี\n\nหน้า SAM ระบุสถานะ “ซื้อตรง” และราคาประกาศขาย 2,489,000 บาท ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคา ค่าใช้จ่าย สถานะการครอบครอง เลขที่อาคาร และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ 3A1860 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nหน้าต้นทางไม่ระบุพื้นที่ใช้สอย ที่จอดรถ อายุอาคาร สถานะผู้ใช้ประโยชน์ สาธารณูปโภค ภาระผูกพันอื่น หรือวันที่ของข้อมูลรายละเอียด ภาพภายนอกชุดแรกมีวันที่กำกับ 28 ตุลาคม 2565 ส่วนภาพภายนอกและภาพภายในชุดถัดมามีวันที่กำกับ 28 สิงหาคม 2566 ผู้ซื้อควรนัดตรวจทรัพย์และตรวจสอบสภาพปัจจุบัน เอกสารสิทธิ์ ทะเบียนอาคาร กฎโครงการ และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        2489000,
        false,
        108,
        2,
        2,
        2,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        '188/265 หมู่บ้านบ้านสวยพารากอน',
        'ใกล้ถนนสุราษฎร์ธานี-กองบิน 7 (ทล.417)',
        'ถนนหมู่บ้านบ้านสวยพารากอน',
        NULL,
        9.12567187,
        99.29409924,
        'สุราษฎร์ธานี',
        'เมืองสุราษฎร์ธานี',
        'วัดประดู่',
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
        'sam-direct-sale-corner-shophouse-baan-suay-paragon-wat-pradu-3a1860'
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
        property_listing_id, 'sale', 2489000, 'total', 'THB', false
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
            'project_name', 'บ้านสวยพารากอน',
            'listed_unit_number', '188/265',
            'title_document_type', 'chanote',
            'title_deed_number', '109187',
            'title_document_count', 1,
            'land_area_square_wah', 27,
            'land_area_sqm', 108,
            'floor_count', 2,
            'bedroom_count', 2,
            'bathroom_count', 2,
            'unit_count', 1,
            'end_unit', true,
            'corner_plot', true,
            'road_frontage_side_count', 2,
            'plot_shape', 'rectangle',
            'west_road_frontage_m', 6,
            'north_road_frontage_m', 18,
            'maximum_depth_m', 18,
            'registered_transfer_description', 'ตึกแถว 2 ชั้น เลขที่ 188/265',
            'registered_address_number', '188/265'
        ) || jsonb_build_object(
            'source_diagram_structure_description', 'ตึกแถว 2 ชั้น เลขที่ 188/264',
            'source_diagram_address_number', '188/264',
            'source_address_number_discrepancy', true,
            'address_and_building_records_require_buyer_review', true,
            'access_type', 'authorized_land_allocation_project_road',
            'front_road_name', 'ถนนหมู่บ้านบ้านสวยพารากอน',
            'front_road_surface', 'reinforced_concrete',
            'front_road_width_m', 6,
            'front_right_of_way_width_m', 8,
            'main_access_road', 'ถนนสุราษฎร์ธานี-กองบิน 7 (ทล.417)',
            'distance_from_main_road_m_approx', 600,
            'zoning_color_th', 'สีชมพู',
            'surrounding_area_use_th', 'ที่อยู่อาศัย',
            'same_project_other_sam_asset_codes', jsonb_build_array('8Z7724'),
            'usable_area_not_published', true,
            'parking_information_not_published', true,
            'building_age_not_published', true,
            'occupancy_status_not_published', true,
            'utilities_information_not_published', true,
            'other_encumbrances_not_published', true,
            'source_information_date_not_published', true,
            'source_exterior_photo_dates_displayed', jsonb_build_array('2022-10-28', '2023-08-28'),
            'source_interior_photo_date_displayed', '2023-08-28',
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-09',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '9.125672,99.294100',
            'administrator_coordinate_distance_from_source_m_approx', 0.084
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 3A1860. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนสุราษฎร์ธานี-กองบิน 7 (ทล.417)', 'Surat Thani–Wing 7 Road (Highway 417)', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'โรงพยาบาลกรุงเทพสุราษฎร์', 'Bangkok Hospital Surat', 'healthcare', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'โฮมโปร สุราษฎร์ธานี', 'HomePro Surat Thani', 'shopping', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'เซ็นทรัล สุราษฎร์ธานี', 'Central Surat Thani', 'shopping', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'สำนักงานขนส่งจังหวัดสุราษฎร์ธานี', 'Surat Thani Provincial Transport Office', 'government', NULL, NULL, NULL, 50, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '2,489,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 2,489,000 — confirm the latest price with SAM', 'unspecified', 2489000, 'THB', 20),
        (property_listing_id, 'registered_structure', 'สิ่งปลูกสร้างตามรายการรับโอน', 'Structure in acquisition records', 'รายการรับโอนของ SAM ระบุตึกแถว 2 ชั้น เลขที่ 188/265 บนโฉนดเลขที่ 109187', 'SAM''s acquisition record identifies a two-storey row building numbered 188/265 on title deed no. 109187', 'unspecified', NULL, '', 30),
        (property_listing_id, 'address_number_discrepancy', 'เลขที่อาคารในข้อมูลต้นทางไม่ตรงกัน', 'Source address-number discrepancy', 'หน้ารายละเอียดระบุ 188/265 แต่ผังสิ่งปลูกสร้างในชุดภาพระบุ 188/264 ต้องให้ SAM ยืนยันทะเบียนอาคารและรายการที่จะโอน', 'The detail page states 188/265, while the source structure diagram states 188/264; buyers must ask SAM to confirm the building record and transferred structure', 'buyer', NULL, '', 40),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนเสนอซื้อ', 'Buyer due diligence', 'ผู้ซื้อต้องตรวจสอบสภาพปัจจุบัน โฉนด ทะเบียนอาคาร ขอบเขต กฎโครงการ สถานะการครอบครอง ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขล่าสุดกับ SAM', 'Buyers must verify current condition, title and building records, boundaries, project rules, possession, encumbrances, expenses and current terms with SAM', 'buyer', NULL, '', 50)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ด้านหน้าอาคารพาณิชย์หลังริม', 'อาคารพาณิชย์ 2 ชั้นหลังริม บ้านสวยพารากอน รหัส SAM 3A1860', 'https://npa.sam.or.th/site/images/npa/20676/20250619104037_3A1860P2_66.jpg', '/listing-media/sam/3a1860/01.webp', 'image/webp', 22956, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมด้านหน้าและถนนในโครงการ', 'ภาพอาคารพาณิชย์หลังริมและแนวถนนคอนกรีตภายในโครงการบ้านสวยพารากอน', 'https://npa.sam.or.th/site/images/npa/20676/3A1860P3_66.jpg', '/listing-media/sam/3a1860/02.webp', 'image/webp', 19406, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมด้านข้างของอาคารหลังริม', 'ภาพแสดงด้านข้างและถนนสองด้านของอาคารพาณิชย์หลังริม 3A1860', 'https://npa.sam.or.th/site/images/npa/20676/3A1860P4_66.jpg', '/listing-media/sam/3a1860/03.webp', 'image/webp', 22240, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ด้านหน้าอาคารชุดภาพปี 2566', 'ภาพด้านหน้าอาคารพาณิชย์ บ้านสวยพารากอน ลงวันที่ 28 สิงหาคม 2566', 'https://npa.sam.or.th/site/images/npa/20676/P1_66.jpg', '/listing-media/sam/3a1860/04.webp', 'image/webp', 25030, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ชั้นล่าง', 'พื้นที่ภายในชั้นล่างของอาคารพาณิชย์ มองไปทางบันได', 'https://npa.sam.or.th/site/images/npa/20676/P2_66.jpg', '/listing-media/sam/3a1860/05.webp', 'image/webp', 13158, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องภายในอาคาร', 'ห้องภายในอาคารพาณิชย์พร้อมหน้าต่างและพื้นกระเบื้อง', 'https://npa.sam.or.th/site/images/npa/20676/P5_66.jpg', '/listing-media/sam/3a1860/06.webp', 'image/webp', 9006, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องและประตูภายใน', 'ภาพห้องภายในอาคารพาณิชย์ แสดงพื้น ผนัง และประตู', 'https://npa.sam.or.th/site/images/npa/20676/P4_66.jpg', '/listing-media/sam/3a1860/07.webp', 'image/webp', 7796, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำภายใน', 'ห้องน้ำภายในอาคารพาณิชย์พร้อมสุขภัณฑ์', 'https://npa.sam.or.th/site/images/npa/20676/P3_66.jpg', '/listing-media/sam/3a1860/08.webp', 'image/webp', 9902, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอน', 'ห้องนอนภายในอาคารพาณิชย์พร้อมหน้าต่างและพื้นกระเบื้อง', 'https://npa.sam.or.th/site/images/npa/20676/P6_66.jpg', '/listing-media/sam/3a1860/09.webp', 'image/webp', 7894, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำพร้อมอ่างล้างหน้า', 'ห้องน้ำภายในพร้อมโถสุขภัณฑ์ อ่างล้างหน้า และกระจก', 'https://npa.sam.or.th/site/images/npa/20676/P7_66.jpg', '/listing-media/sam/3a1860/10.webp', 'image/webp', 11928, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่โถงชั้นบน', 'พื้นที่ภายในชั้นบนพร้อมประตูเชื่อมไปยังห้องต่าง ๆ', 'https://npa.sam.or.th/site/images/npa/20676/P9_66.jpg', '/listing-media/sam/3a1860/11.webp', 'image/webp', 9420, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องติดระเบียง', 'ห้องภายในชั้นบนพร้อมประตูกระจกและระเบียงด้านหลัง', 'https://npa.sam.or.th/site/images/npa/20676/P8_66.jpg', '/listing-media/sam/3a1860/12.webp', 'image/webp', 14532, 450, 450, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำพร้อมพื้นที่อาบน้ำ', 'ห้องน้ำภายในพร้อมสุขภัณฑ์ อ่างล้างหน้า และพื้นที่อาบน้ำ', 'https://npa.sam.or.th/site/images/npa/20676/P10_66.jpg', '/listing-media/sam/3a1860/13.webp', 'image/webp', 6690, 450, 450, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังแปลงหัวมุม 27 ตารางวา', 'ผังโฉนดเลขที่ 109187 แสดงแปลงหน้ากว้างประมาณ 6 เมตรและยาวประมาณ 18 เมตรติดถนนสองด้าน', 'https://npa.sam.or.th/site/images/npa/20676/20230307144813_3A1860C2_66.jpg', '/listing-media/sam/3a1860/14.webp', 'image/webp', 13770, 450, 450, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังตำแหน่งอาคารและเลขที่ที่ต้องตรวจสอบ', 'ผังต้นทางแสดงอาคารพาณิชย์ 2 ชั้นบนแปลงและระบุเลขที่ 188/264 ซึ่งต่างจากหน้ารายละเอียด 188/265', 'https://npa.sam.or.th/site/images/npa/20676/20230307144813_3A1860C1_66.jpg', '/listing-media/sam/3a1860/15.webp', 'image/webp', 16680, 450, 450, 150, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แผนที่การเดินทางไปบ้านสวยพารากอน', 'แผนที่ต้นทางแสดงเส้นทางจากถนน ทล.417 ไปยังโครงการบ้านสวยพารากอนและสถานที่ใกล้เคียง', 'https://npa.sam.or.th/site/images/npa/20676/20230307144813_3A1860M_66(8Z7724).jpg', '/listing-media/sam/3a1860/16.webp', 'image/webp', 59284, 785, 600, 160, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=20676',
        '3A1860',
        '2026-09-09 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 2,489,000 for one end-unit two-storey shophouse with two bedrooms and two bathrooms in Baan Suay Paragon on title deed no. 109187 covering 27 sq.wah / 108 sq.m. The rectangular corner plot fronts two authorized land-allocation project roads, approximately six meters on the west and 18 meters on the north, with a maximum depth of approximately 18 meters. The reinforced-concrete internal road is approximately six meters wide within an approximately eight-meter right of way. The SAM detail and acquisition record state address no. 188/265, while the source structure diagram states no. 188/264; buyers must confirm the building registration, title relationship and transferred structure with SAM. The page does not publish the information date, usable area, parking, building age, occupancy, utilities or other encumbrances. Exterior photos display 28 October 2022 and 28 August 2023; interior photos display 28 August 2023. Administrator-supplied coordinates are approximately 0.084 meters from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all sixteen source property, interior, plot and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Two-Storey End Shophouse in Baan Suay Paragon, THB 2.489M',
        E'Two-storey end-unit shophouse identified on the SAM detail page as no. 188/265 in Baan Suay Paragon, Wat Pradu, Mueang Surat Thani, Surat Thani. The property has two bedrooms and two bathrooms on 27 sq.wah (108 sq.m.) of land under title deed no. 109187. SAM''s acquisition record describes a two-storey row building numbered 188/265.\n\nThe rectangular corner plot fronts two internal project roads, with approximately six meters of west frontage and 18 meters of north frontage, and a maximum depth of approximately 18 meters. The Baan Suay Paragon road is within an authorized land-allocation project and has an approximately six-meter reinforced-concrete carriageway within an approximately eight-meter right of way. SAM identifies pink zoning in a residential area. The end-unit position may suit retail, office, residential or mixed use, subject to project rules and independent verification of suitability.\n\nImportant source discrepancy: the SAM detail page and acquisition record state address no. 188/265, while the source structure diagram states “two-storey row building no. 188/264.” Buyers should ask SAM to confirm the building registration, address number, relationship to title deed no. 109187, plot boundaries and structure included in the transfer. Neither the image nor the page text should be relied upon alone.\n\nAccess is from Surat Thani–Wing 7 Road (Highway 417), travelling from Wing 7 toward Central Plaza Surat Thani. Turn left into the Bangkok Hospital road, then right and continue on the Baan Suay Paragon road for approximately 600 meters. The end-unit property is on the right. Nearby places listed by SAM include Bangkok Hospital Surat, HomePro Surat Thani, Central Surat Thani and the Surat Thani Provincial Transport Office.\n\nThe SAM page lists the property as direct purchase with an announced sale price of THB 2,489,000. It is not an auction. Contact SAM directly to confirm availability, offer procedures, current price, expenses, possession, the correct address number and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: 3A1860. MapxProp does not collect deposits or represent SAM in the transaction.\n\nThe source does not publish internal usable area, parking, building age, occupancy, utilities, other encumbrances or a date for the detailed property information. The first exterior-photo set displays 28 October 2022, while the later exterior and interior photos display 28 August 2023. Buyers should arrange an inspection and verify current condition, title and building records, project rules and all terms before deciding.',
        '188/265, Baan Suay Paragon',
        'Near Surat Thani–Wing 7 Road (Highway 417)',
        'Baan Suay Paragon internal road',
        'Wat Pradu',
        'Mueang Surat Thani',
        'Surat Thani',
        'SAM Direct-Sale End Shophouse in Baan Suay Paragon, THB 2.489M',
        'Official SAM NPA asset 3A1860: two-storey end shophouse with 2 bedrooms and 2 bathrooms on 108 sq.m. Direct-sale price THB 2.489M; address discrepancy disclosed.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset 3A1860 end unit corner shophouse commercial building Baan Suay Paragon Wat Pradu Mueang Surat Thani Highway 417 27 sq.wah 108 sq.m. title deed 109187 two bedrooms two bathrooms THB 2489000 address 188/265 188/264')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=20676'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=20676',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 3A1860. The specifications, images, rounded coordinates, announced price, direct-purchase status, project name and address-number discrepancy come from that record.',
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
        'c13f4249-b1ef-4cf3-b980-48378e4f27fb',
        jsonb_build_object(
            'reference_code', '3A1860',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'corner_plot', true,
            'address_number_discrepancy', true
        )
    );
END $$;

COMMIT;
