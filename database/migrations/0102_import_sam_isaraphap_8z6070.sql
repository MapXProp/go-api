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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing 8Z6070';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing 8Z6070';
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
        'a09b8d15-a382-4c4f-b567-f8e738f3277d',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'shophouse',
        'mixed',
        'sale',
        'whole_property',
        'ขายตรง SAM ตึกแถว 4 ชั้นครึ่ง ถนนอิสรภาพ คลองสาน ติดถนน 3 ด้าน ราคา 10.179 ล้านบาท',
        E'ตึกแถวเลขที่ 1159/4 ถนนอิสรภาพ แขวงสมเด็จเจ้าพระยา เขตคลองสาน กรุงเทพมหานคร เอกสารสิทธิ์เป็นโฉนดที่ดินเลขที่ 569 จำนวน 1 ฉบับ เนื้อที่ 23.7 ตร.ว. (94.8 ตร.ม.)

SAM ระบุรายการสิ่งปลูกสร้างที่รับโอนกรรมสิทธิ์เป็นตึกแถว 4 ชั้นครึ่ง เลขที่ 1159/4 โดยหน้า SAM ไม่ได้เผยแพร่พื้นที่ใช้สอย จำนวนห้องนอน ห้องน้ำ ที่จอดรถ อายุอาคาร หรือรายละเอียดระบบไฟฟ้าและประปา ผู้ซื้อควรให้ SAM สำนักงานเขต และสำนักงานที่ดินยืนยันจำนวนชั้น ชั้นลอย แบบอาคาร ใบอนุญาต การต่อเติม การใช้อาคาร ระบบดับเพลิง และสิ่งปลูกสร้างที่รวมในการโอน

ที่ดินเป็นรูปหลายเหลี่ยมและ SAM ระบุว่าติดถนน 3 ด้าน ด้านทิศใต้กว้างประมาณ 5 เมตร ด้านทิศตะวันตกกว้างประมาณ 9.5 เมตร ด้านทิศเหนือกว้างประมาณ 13.25 เมตร และหน้าข้อมูลสรุประบุความลึกสูงสุดประมาณ 18 เมตร ผู้ซื้อควรตรวจโฉนด รังวัด แนวเขต ระดับถนน สิทธิทางเข้าออก และขนาดแต่ละด้านจริงก่อนเสนอซื้อ

ถนนผ่านหน้าทรัพย์คือถนนอิสรภาพ เป็นทางสาธารณประโยชน์ ผิวลาดยางกว้างประมาณ 12 เมตร เขตทางกว้างประมาณ 22 เมตร การเดินทางจากถนนประชาธิปกบริเวณสะพานพระปกเกล้ามุ่งหน้าวงเวียนใหญ่ ผ่านโรงเรียนศึกษานารีและมหาวิทยาลัยราชภัฏธนบุรี เลี้ยวซ้ายเข้าถนนอิสรภาพประมาณ 70 เมตร จะพบทรัพย์อยู่ด้านซ้าย ติดซอยอิสรภาพ 14

สถานที่ใกล้เคียงที่ SAM ระบุ ได้แก่ วงเวียนใหญ่ มหาวิทยาลัยราชภัฏธนบุรี มหาวิทยาลัยราชภัฏบ้านสมเด็จเจ้าพระยา โรงพยาบาลตากสิน และโรงเรียนศึกษานารี

หน้า SAM ระบุเขตสีน้ำตาล และระบุชัดว่าทรัพย์ตั้งอยู่ในย่านที่อยู่อาศัยและพาณิชยกรรม MapxProp จึงจัดเป็น Mixed Use และแสดงในทั้งหมวดที่อยู่อาศัยและธุรกิจ อย่างไรก็ตาม การจัดหมวดและสีผังเมืองไม่ใช่การรับรองว่าสามารถพักอาศัยหรือประกอบกิจการทุกประเภทได้ ผู้ซื้อต้องตรวจผังเมืองปัจจุบัน การใช้อาคาร ทางเข้าออก ที่จอดรถ ป้าย ระบบดับเพลิง และใบอนุญาตสำหรับการใช้งานที่ต้องการ

หน้า SAM แสดงสถานะ “ซื้อตรง” ราคาประกาศขาย 10,179,000 บาท ไม่ใช่การประมูลในสถานะที่ตรวจสอบเมื่อวันที่ 10 กันยายน 2569 ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะการครอบครอง และวิธีจำหน่ายล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ 8Z6070 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM

ภาพสภาพทรัพย์ด้านหน้าแสดงวันที่ 18 กรกฎาคม 2566 และภาพภายในกับดาดฟ้าแสดงวันที่ 12 พฤศจิกายน 2564 สภาพจริงอาจเปลี่ยนแปลง ผู้ซื้อควรนัดตรวจโครงสร้าง หลังคา ดาดฟ้า รอยร้าว ความชื้น ปลวก บันได ระบบไฟฟ้า ประปา ห้องน้ำ ระบบดับเพลิง ทางเข้าออก ภาระผูกพัน ภาษี ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        10179000,
        false,
        94.8,
        4,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'ตึกแถวเลขที่ 1159/4 ถนนอิสรภาพ',
        'ติดซอยอิสรภาพ 14 ใกล้วงเวียนใหญ่',
        'ถนนอิสรภาพ',
        NULL,
        13.73078766,
        100.49530843,
        'กรุงเทพมหานคร',
        'คลองสาน',
        'สมเด็จเจ้าพระยา',
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
        'sam-direct-sale-shophouse-isaraphap-khlong-san-8z6070'
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
        property_listing_id, 'sale', 10179000, 'total', 'THB', false
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
            'title_document_type', 'chanote',
            'title_deed_numbers', jsonb_build_array('569'),
            'title_document_count', 1,
            'land_area_rai', 0,
            'land_area_ngan', 0,
            'land_area_square_wah_remainder', 23.7,
            'land_area_square_wah', 23.7,
            'land_area_sqm', 94.8,
            'plot_count', 1,
            'unit_count', 1,
            'building_number', '1159/4',
            'registered_building_type_th', 'ตึกแถว',
            'registered_storeys', 4.5,
            'displayed_full_storeys', 4,
            'mezzanine_or_half_storey_reported', true,
            'usable_area_not_published', true,
            'bedroom_count_not_published', true,
            'bathroom_count_not_published', true,
            'parking_space_count_not_published', true,
            'building_age_not_published', true,
            'plot_shape', 'polygon',
            'road_frontage_side_count', 3,
            'south_frontage_m_approx', 5,
            'west_frontage_m_approx', 9.5,
            'north_frontage_m_approx', 13.25,
            'maximum_depth_m_approx', 18
        ) || jsonb_build_object(
            'front_road_name', 'ถนนอิสรภาพ',
            'front_road_legal_status_th', 'ทางสาธารณประโยชน์',
            'front_road_surface', 'asphalt',
            'front_road_width_m_approx', 12,
            'front_right_of_way_width_m_approx', 22,
            'adjacent_soi_th', 'ซอยอิสรภาพ 14',
            'zoning_color_th', 'เขตสีน้ำตาล ตามหน้า SAM',
            'surrounding_area_use_th', 'ย่านที่อยู่อาศัยและพาณิชยกรรม',
            'mixed_use_classification', true,
            'mixed_use_classification_basis', 'SAM ระบุว่าทรัพย์ตั้งอยู่ในย่านที่อยู่อาศัยและพาณิชยกรรม และทรัพย์เป็นตึกแถว',
            'intended_use_requires_independent_verification', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_information_date_not_published', true,
            'source_property_photo_dates_displayed', jsonb_build_array('2021-11-12', '2023-07-18'),
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '13.73079,100.49531',
            'administrator_coordinate_distance_from_source_m_approx', 0.31
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z6070. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนอิสรภาพ', 'Isaraphap Road', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ซอยอิสรภาพ 14', 'Soi Isaraphap 14', 'road', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'วงเวียนใหญ่', 'Wongwian Yai', 'landmark', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'มหาวิทยาลัยราชภัฏธนบุรี', 'Dhonburi Rajabhat University', 'education', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'มหาวิทยาลัยราชภัฏบ้านสมเด็จเจ้าพระยา', 'Bansomdejchaopraya Rajabhat University', 'education', NULL, NULL, NULL, 50, true),
        (property_listing_id, 'โรงพยาบาลตากสิน', 'Taksin Hospital', 'healthcare', NULL, NULL, NULL, 60, true),
        (property_listing_id, 'โรงเรียนศึกษานารี', 'Suksanari School', 'education', NULL, NULL, NULL, 70, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '10,179,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 10,179,000 — confirm the latest price with SAM', 'unspecified', 10179000, 'THB', 20),
        (property_listing_id, 'registered_structure', 'สิ่งปลูกสร้างตามทะเบียน', 'Registered structure', 'ตึกแถว 4 ชั้นครึ่ง เลขที่ 1159/4 — ต้องยืนยันชั้นลอย แบบอาคาร ใบอนุญาต และรายการที่จะโอน', 'Four-and-a-half-storey shophouse numbered 1159/4 — verify mezzanine, plans, permits and transfer scope', 'buyer', 4.5, 'storeys', 30),
        (property_listing_id, 'three_road_frontages', 'ที่ดินติดถนน 3 ด้าน', 'Three road frontages', 'ด้านใต้ประมาณ 5 เมตร ด้านตะวันตกประมาณ 9.5 เมตร และด้านเหนือประมาณ 13.25 เมตร ต้องตรวจรังวัดและสิทธิทางจริง', 'Approximately five metres south, 9.5 metres west and 13.25 metres north; verify survey and legal access', 'buyer', 3, 'sides', 40),
        (property_listing_id, 'road_details', 'ถนนหน้าทรัพย์', 'Road details', 'ถนนอิสรภาพเป็นทางสาธารณะ ผิวลาดยางกว้างประมาณ 12 เมตร เขตทางประมาณ 22 เมตร และทรัพย์ติดซอยอิสรภาพ 14', 'Isaraphap Road is a public asphalt road approximately twelve metres wide within an approximately twenty-two-metre right of way; the property adjoins Soi Isaraphap 14', 'unspecified', 12, 'metres', 50),
        (property_listing_id, 'mixed_use_review', 'การใช้เพื่ออยู่อาศัยและธุรกิจ', 'Residential and business use review', 'SAM ระบุย่านที่อยู่อาศัยและพาณิชยกรรม แต่ผู้ซื้อต้องตรวจผังเมือง การใช้อาคาร ระบบดับเพลิง ที่จอดรถ และใบอนุญาตสำหรับการใช้งานที่ต้องการ', 'SAM describes residential and commercial surroundings, but buyers must verify planning, approved building use, fire safety, parking and licences', 'buyer', NULL, '', 60),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนด รังวัด อาคาร ชั้นลอย โครงสร้าง ดาดฟ้า ทางเข้าออกสามด้าน ผังเมือง ระบบดับเพลิง ไฟฟ้า ประปา ภาระผูกพัน ค่าใช้จ่าย สถานะการครอบครอง และเงื่อนไขล่าสุด', 'Verify title, survey, building, mezzanine, structure, roof deck, three-sided access, planning, fire safety, utilities, encumbrances, costs, possession and current terms', 'buyer', NULL, '', 70)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ตึกแถว 4 ชั้นครึ่ง ถนนอิสรภาพ', 'ด้านหน้าตึกแถว SAM รหัส 8Z6070 เลขที่ 1159/4 ถนนอิสรภาพ', 'https://npa.sam.or.th/site/images/npa/14099/20230927093954_8Z6070P13_66.jpg', '/listing-media/sam/8z6070/01.webp', 'image/webp', 31186, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'หน้าตึกแถวติดถนนอิสรภาพ', 'ภาพหน้าตึกแถวริมถนนอิสรภาพพร้อมป้ายประกาศขาย', 'https://npa.sam.or.th/site/images/npa/14099/8Z6070P12_66.jpg', '/listing-media/sam/8z6070/02.webp', 'image/webp', 48236, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงชั้นล่างและบันได', 'ภาพโถงภายในชั้นล่างและบันไดขึ้นชั้นถัดไปของตึกแถว', 'https://npa.sam.or.th/site/images/npa/14099/8Z6070P4_65.jpg', '/listing-media/sam/8z6070/03.webp', 'image/webp', 10374, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องภายในอาคาร', 'ภาพห้องภายในตึกแถว SAM 8Z6070 พร้อมหน้าต่าง', 'https://npa.sam.or.th/site/images/npa/14099/8Z6070P8_65.jpg', '/listing-media/sam/8z6070/04.webp', 'image/webp', 10732, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ชั้นล่างและประตูม้วน', 'ภาพพื้นที่ภายในชั้นล่างพร้อมประตูม้วนด้านหน้า', 'https://npa.sam.or.th/site/images/npa/14099/8Z6070P9_65.jpg', '/listing-media/sam/8z6070/05.webp', 'image/webp', 16084, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องชั้นบนรับแสงธรรมชาติ', 'ภาพห้องภายในชั้นบนพร้อมหน้าต่างหลายด้าน', 'https://npa.sam.or.th/site/images/npa/14099/8Z6070P10_65.jpg', '/listing-media/sam/8z6070/06.webp', 'image/webp', 14694, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเชื่อมห้องภายใน', 'ภาพประตูและทางเชื่อมระหว่างห้องภายในตึกแถว', 'https://npa.sam.or.th/site/images/npa/14099/8Z6070P11_65.jpg', '/listing-media/sam/8z6070/07.webp', 'image/webp', 12258, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ดาดฟ้าและทิวทัศน์เมือง', 'ภาพพื้นที่ดาดฟ้าตึกแถวและทิวทัศน์ย่านคลองสาน', 'https://npa.sam.or.th/site/images/npa/14099/8Z6070P6_65.jpg', '/listing-media/sam/8z6070/08.webp', 'image/webp', 21518, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ดาดฟ้าอีกมุม', 'ภาพดาดฟ้าอีกด้านของตึกแถว SAM 8Z6070', 'https://npa.sam.or.th/site/images/npa/14099/8Z6070P7_65.jpg', '/listing-media/sam/8z6070/09.webp', 'image/webp', 19226, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังที่ดินติดถนน 3 ด้าน', 'ผังต้นทางแสดงแปลงโฉนดเลขที่ 569 รูปหลายเหลี่ยมและแนวถนนสามด้าน', 'https://npa.sam.or.th/site/images/npa/14099/20180618132137_8Z6070C1_61.jpg', '/listing-media/sam/8z6070/10.webp', 'image/webp', 11850, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังตำแหน่งตึกแถวบนแปลง', 'ผังต้นทางแสดงตำแหน่งตึกแถว 4 ชั้นครึ่งบนที่ดิน 23.7 ตารางวา', 'https://npa.sam.or.th/site/images/npa/14099/20200604105238_8Z6070C2_63.jpg', '/listing-media/sam/8z6070/11.webp', 'image/webp', 14198, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปทรัพย์', 'แผนที่ต้นทางแสดงเส้นทางถนนประชาธิปกและถนนอิสรภาพไปยังตึกแถว SAM 8Z6070', 'https://npa.sam.or.th/site/images/npa/14099/20180618132137_8Z6070M1_61.jpg', '/listing-media/sam/8z6070/12.webp', 'image/webp', 53324, 785, 600, 120, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=14099&keyref=6004389',
        '8Z6070',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 10,179,000 for a four-and-a-half-storey shophouse numbered 1159/4 on Isaraphap Road, Somdet Chao Phraya, Khlong San, Bangkok. Title deed 569 covers 23.7 sq.wah / 94.8 sq.m. SAM does not publish usable area, room counts, parking, age or utility specifications. The polygonal plot is reported to front three roads, approximately five metres on the south, 9.5 metres on the west and 13.25 metres on the north, with maximum depth approximately eighteen metres. Isaraphap Road is described as a public asphalt road approximately twelve metres wide within an approximately twenty-two-metre right of way. The property adjoins Soi Isaraphap 14. SAM shows brown planning zoning and explicitly describes residential-commercial surroundings; MapxProp therefore classifies the shophouse as mixed use and includes it in both homes and business discovery. Buyers must independently verify title, survey, storeys, mezzanine, plans, permits, approved building use, access and current transaction terms. Source exterior photos display 18 July 2023, while interior and roof-deck photos display 12 November 2021. Administrator coordinates are approximately 0.31 metres from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all twelve unique source property, interior, plot-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: 4.5-Storey Shophouse on Isaraphap Road, THB 10.179M',
        E'Four-and-a-half-storey shophouse numbered 1159/4 on Isaraphap Road, Somdet Chao Phraya, Khlong San, Bangkok. Title deed 569 covers 23.7 sq.wah (94.8 sq.m.).

SAM records the structure as a four-and-a-half-storey shophouse. The source does not publish usable area, bedroom or bathroom counts, parking, building age, or electrical and plumbing specifications. Buyers should ask SAM, the district office and the Land Office to verify storeys, mezzanine, plans, permits, alterations, approved building use, fire safety and everything included in the transfer.

The polygonal land is reported to front three roads: approximately five metres on the southern side, 9.5 metres on the western side and 13.25 metres on the northern side. The summary states a maximum depth of approximately eighteen metres. Buyers should verify the title deed, survey, boundaries, road levels, legal access and every measurement before offering.

Isaraphap Road is described as a public asphalt road approximately twelve metres wide within an approximately twenty-two-metre right of way. From Prajadhipok Road near Memorial Bridge, travel toward Wongwian Yai, pass Suksanari School and Dhonburi Rajabhat University, then turn left onto Isaraphap Road for approximately seventy metres. The property is on the left next to Soi Isaraphap 14.

Nearby places named by SAM include Wongwian Yai, Dhonburi Rajabhat University, Bansomdejchaopraya Rajabhat University, Taksin Hospital and Suksanari School.

The source shows brown planning zoning and explicitly describes residential and commercial surroundings. MapxProp therefore classifies the shophouse as mixed use and includes it in both homes and business discovery. This classification does not guarantee residential or commercial use of every floor or every business type. Buyers must confirm current planning, approved building use, access, parking, signage, fire safety and licences for the intended use.

The SAM page listed the property for direct purchase at an announced THB 10,179,000 when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, the current sale method, offer procedures, price, promotions, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: 8Z6070. MapxProp does not collect deposits or represent SAM in the transaction.

Source exterior photos display 18 July 2023, while interior and roof-deck photos display 12 November 2021. Conditions may have changed. Buyers should inspect the structure, roof, roof deck, cracks, moisture, termites, stairs, electrical and plumbing systems, bathrooms, fire safety, access, encumbrances, taxes, costs and every current term before deciding.',
        '1159/4 Isaraphap Road',
        'Next to Soi Isaraphap 14, near Wongwian Yai',
        'Isaraphap Road',
        'Somdet Chao Phraya',
        'Khlong San',
        'Bangkok',
        'SAM 4.5-Storey Shophouse, Isaraphap Road, THB 10.179M',
        'Official SAM NPA asset 8Z6070: a four-and-a-half-storey mixed-use shophouse on 94.8 sq.m., fronting three roads near Wongwian Yai. Direct sale at THB 10.179M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset 8Z6070 four and a half storey mixed use shophouse 1159/4 Isaraphap Road Soi Isaraphap 14 Somdet Chao Phraya Khlong San Bangkok Wongwian Yai title deed 569 23.7 sq.wah 94.8 sq.m. three road frontages THB 10179000')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=14099&keyref=6004389'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=14099&keyref=6004389',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z6070. Specifications, title deed, registered structure, images, rounded coordinates, announced price, direct-purchase status, three road frontages, road measurements, planning-zone wording and surrounding-use description come from that record.',
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
        'a09b8d15-a382-4c4f-b567-f8e738f3277d',
        jsonb_build_object(
            'reference_code', '8Z6070',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'mixed',
            'discovery_channels', jsonb_build_array('homes', 'business'),
            'title_document_count', 1,
            'unit_count', 1,
            'registered_storeys', 4.5,
            'road_frontage_side_count', 3,
            'zoning_review_required', true,
            'source_image_count', 12
        )
    );
END $$;

COMMIT;
