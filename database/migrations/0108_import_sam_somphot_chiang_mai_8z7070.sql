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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing 8Z7070';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing 8Z7070';
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
        '109a9b5e-a67b-4817-abfe-bce47b167c1d',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'shophouse',
        'mixed',
        'sale',
        'whole_property',
        NULL,
        '31, 33',
        'ขายตรง SAM อาคารพาณิชย์ 2 คูหา 3 ชั้นพร้อมชั้นลอย ติดถนนสมโภชเชียงใหม่ 700 ปี ราคา 6.114 ล้านบาท',
        E'อาคารพาณิชย์ 2 คูหา เลขที่ 31 และ 33 ติดถนนสมโภชเชียงใหม่ 700 ปี (ชม.3029) ตำบลช้างเผือก อำเภอเมืองเชียงใหม่ จังหวัดเชียงใหม่ โฉนดที่ดินเลขที่ 88053, 88054, 90428, 90429 และ 93151 จำนวน 5 ฉบับ เนื้อที่รวม 42.7 ตร.ว. (170.8 ตร.ม.) หน้า SAM ระบุเขตสีเหลือง

ที่ดิน 5 แปลงติดต่อกันเป็นรูปสี่เหลี่ยมผืนผ้า ด้านทิศใต้ติดถนน หน้ากว้างประมาณ 8 เมตร ลึกประมาณ 21.3 เมตร SAM ระบุรายการรับโอนกรรมสิทธิ์เป็นตึกแถว 3 ชั้นมีชั้นลอย รวม 2 คูหา เลขที่ 31 และ 33 ข้อมูลสำรวจสภาพระบุว่าทั้ง 2 คูหาใช้ประโยชน์ร่วมกันและภายในทะลุถึงกัน ผู้ซื้อควรตรวจแบบอาคาร ใบอนุญาต การเจาะเชื่อม โครงสร้าง ทางหนีไฟ ชั้นลอย และรายการที่จะโอนให้ตรงกัน

ถนนผ่านหน้าทรัพย์คือถนนสมโภชเชียงใหม่ 700 ปี (ชม.3029) SAM ระบุว่าเป็นทางสาธารณประโยชน์ ผิวจราจรลาดยางกว้างประมาณ 30 เมตร เขตทางกว้างประมาณ 40 เมตร หน้า SAM ไม่ได้เผยแพร่พื้นที่ใช้สอย จำนวนห้องนอน จำนวนห้องน้ำ ที่จอดรถ อายุอาคาร หรือรายละเอียดระบบไฟฟ้าและประปา ผู้ซื้อควรให้ SAM เทศบาล และสำนักงานที่ดินยืนยันสิทธิทางเข้าออก ทะเบียนอาคาร จำนวนชั้น ชั้นลอย การเจาะเชื่อม การใช้อาคาร ระบบดับเพลิง และรายการที่จะโอน

หน้า SAM ระบุว่าทรัพย์อยู่ในย่านที่อยู่อาศัย MapxProp จัดอาคารพาณิชย์ประเภทตึกแถวเป็น Mixed Use เพื่อให้ค้นพบได้ทั้งหมวดที่อยู่อาศัยและธุรกิจ อย่างไรก็ตาม การจัดหมวดนี้ไม่ใช่การรับรองว่าสามารถพักอาศัยหรือประกอบกิจการทุกประเภทได้ ผู้ซื้อต้องตรวจผังเมืองเขตสีเหลือง การใช้อาคาร ป้าย ที่จอดรถ ระบบดับเพลิง และใบอนุญาตสำหรับกิจการที่ต้องการ

สถานที่สำคัญใกล้เคียงตามหน้า SAM ได้แก่ ศูนย์ราชการจังหวัดเชียงใหม่ องค์การบริหารส่วนจังหวัดเชียงใหม่ และโรงเรียนบ้านพระนอน การเดินทางใช้ถนนเชียงใหม่–พร้าว (ทล.1001) จากถนนเชียงใหม่–ลำปาง (ทล.11) มุ่งหน้าอำเภอแม่โจ้ ถึงบริเวณ กม.6+500 เลี้ยวซ้ายเข้าถนนสมโภชเชียงใหม่ 700 ปี ผ่านตลาดรวมโชคและโรงเรียนนานาชาตินครพายัพ ถึงแม่น้ำปิงแล้วตรงต่อประมาณ 940 เมตร ทรัพย์อยู่ด้านขวามือ

หน้า SAM แสดงสถานะ “ซื้อตรง” และราคาประกาศขาย 6,114,000 บาท ไม่ใช่การประมูลในสถานะที่ตรวจสอบเมื่อวันที่ 10 กันยายน 2569 ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะการครอบครอง และวิธีจำหน่ายล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ 8Z7070 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM

ภาพทรัพย์ต้นทางแสดงวันที่ 22 กรกฎาคม 2565 และสภาพจริงอาจเปลี่ยนแปลง ภาพแสดงด้านหน้า พื้นที่ภายใน ห้องหลายชั้น ห้องครัว บันได ชั้นลอย ผังแปลง และแผนที่ ผู้ซื้อควรนัดตรวจโครงสร้าง หลังคา ชั้นลอย การเจาะเชื่อม บันได ทางหนีไฟ รอยร้าว การรั่วซึม ความชื้น ปลวก ห้องน้ำ ระบบไฟฟ้า ประปา ระบบดับเพลิง การครอบครอง ภาระผูกพัน ภาษี ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        6114000,
        false,
        170.8,
        3,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'อาคารพาณิชย์เลขที่ 31 และ 33',
        'ติดถนนสมโภชเชียงใหม่ 700 ปี (ชม.3029)',
        'ถนนสมโภชเชียงใหม่ 700 ปี (ชม.3029)',
        NULL,
        18.84065761,
        98.97664640,
        'เชียงใหม่',
        'เมืองเชียงใหม่',
        'ช้างเผือก',
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
        'sam-direct-sale-two-shophouses-somphot-chiang-mai-700-years-8z7070'
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
        property_listing_id, 'sale', 6114000, 'total', 'THB', false
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
            'title_document_type_th', 'โฉนดที่ดิน',
            'title_document_numbers', jsonb_build_array('88053', '88054', '90428', '90429', '93151'),
            'title_document_count', 5,
            'land_area_rai', 0,
            'land_area_ngan', 0,
            'land_area_square_wah_remainder', 42.7,
            'land_area_square_wah', 42.7,
            'land_area_sqm', 170.8,
            'plot_count', 5,
            'unit_count', 2,
            'building_numbers', jsonb_build_array('31', '33'),
            'registered_building_type_th', 'ตึกแถว',
            'registered_storeys', 3,
            'mezzanine_reported', true,
            'survey_reports_joint_use', true,
            'units_internally_connected', true,
            'usable_area_not_published', true,
            'bedroom_count_not_published', true,
            'bathroom_count_not_published', true,
            'parking_space_count_not_published', true,
            'building_age_not_published', true,
            'plot_shape', 'rectangle',
            'south_frontage_m_approx', 8,
            'maximum_depth_m_approx', 21.3
        ) || jsonb_build_object(
            'address_road_name', 'ถนนสมโภชเชียงใหม่ 700 ปี (ชม.3029)',
            'access_road_public_utility', true,
            'access_road_surface', 'asphalt',
            'access_carriageway_width_m_approx', 30,
            'access_right_of_way_width_m_approx', 40,
            'zoning_color_th', 'เขตสีเหลือง ตามหน้า SAM',
            'source_reports_residential_area', true,
            'mixed_use_classification', true,
            'mixed_use_classification_basis', 'MapxProp จัดอาคารพาณิชย์ประเภทตึกแถวเป็นการใช้งานผสมเพื่อการค้นหา และต้นทางระบุว่าทรัพย์อยู่ในย่านที่อยู่อาศัย โดยผู้ซื้อต้องตรวจการใช้อาคารที่อนุญาตจริง',
            'intended_use_requires_independent_verification', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'computed_price_per_square_wah', 143185.01,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_information_date_not_published', true,
            'source_property_photo_date_displayed', '2022-07-22',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '18.840658,98.976646',
            'administrator_coordinate_distance_from_source_m_approx', 0.06
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z7070. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนสมโภชเชียงใหม่ 700 ปี (ชม.3029)', 'Somphot Chiang Mai 700 Pi Road 3029', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ถนนเชียงใหม่–พร้าว (ทล.1001)', 'Chiang Mai–Phrao Highway 1001', 'road', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'ถนนเชียงใหม่–ลำปาง (ทล.11)', 'Chiang Mai–Lampang Highway 11', 'road', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'ศูนย์ราชการจังหวัดเชียงใหม่', 'Chiang Mai Government Center', 'government', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'องค์การบริหารส่วนจังหวัดเชียงใหม่', 'Chiang Mai Provincial Administrative Organization', 'government', NULL, NULL, NULL, 50, true),
        (property_listing_id, 'โรงเรียนบ้านพระนอน', 'Ban Phra Non School', 'education', NULL, NULL, NULL, 60, true),
        (property_listing_id, 'ตลาดรวมโชค', 'Ruam Chok Market', 'shopping', NULL, NULL, NULL, 70, true),
        (property_listing_id, 'โรงเรียนนานาชาตินครพายัพ', 'Nakhon Payap International School', 'education', NULL, NULL, NULL, 80, true),
        (property_listing_id, 'แม่น้ำปิง', 'Ping River', 'landmark', NULL, NULL, NULL, 90, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '6,114,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 6,114,000 — confirm the latest price with SAM', 'unspecified', 6114000, 'THB', 20),
        (property_listing_id, 'title_document_due_diligence', 'การตรวจสอบเอกสารสิทธิ์', 'Title-document due diligence', 'โฉนดเลขที่ 88053, 88054, 90428, 90429 และ 93151 รวม 5 ฉบับ ต้องตรวจเลขที่ดิน ระวาง แนวเขต และความตรงกับพื้นที่จริง', 'Verify title deeds 88053, 88054, 90428, 90429 and 93151, including parcel numbers, survey sheets, boundaries and the actual site', 'buyer', 5, 'documents', 30),
        (property_listing_id, 'registered_structure', 'สิ่งปลูกสร้างตามรายการรับโอน', 'Registered acquisition structure', 'ตึกแถว 3 ชั้นมีชั้นลอย 2 คูหา เลขที่ 31 และ 33 ต้องยืนยันจำนวนชั้น ชั้นลอย แบบและรายการที่จะโอน', 'Two three-storey shophouses with mezzanines numbered 31 and 33; verify storeys, mezzanines, plans and transfer inventory', 'buyer', 3, 'storeys', 40),
        (property_listing_id, 'internal_connection', 'การใช้ร่วมกันและเจาะเชื่อม', 'Joint use and internal connection', 'ข้อมูลสำรวจระบุว่า 2 คูหาใช้ประโยชน์ร่วมกันและภายในทะลุถึงกัน ต้องตรวจโครงสร้าง แบบอาคาร ทางหนีไฟ และการแบ่งใช้พื้นที่จริง', 'The survey says both units are jointly used and internally connected; verify structure, plans, fire escape and actual space allocation', 'buyer', 2, 'units', 50),
        (property_listing_id, 'public_frontage_road', 'ถนนสาธารณประโยชน์หน้าทรัพย์', 'Public frontage road', 'ถนนสมโภชเชียงใหม่ 700 ปีเป็นทางสาธารณประโยชน์ ผิวลาดยางกว้างประมาณ 30 ม. เขตทางประมาณ 40 ม. ต้องตรวจแนวเขตและสภาพจริง', 'Somphot Chiang Mai 700 Pi Road is reported as a public-utility road, with an approximately 30 m asphalt carriageway and 40 m right-of-way; verify boundaries and actual condition', 'buyer', 40, 'meters', 60),
        (property_listing_id, 'mixed_use_review', 'การใช้เพื่ออยู่อาศัยและธุรกิจ', 'Residential and business use review', 'MapxProp จัดตึกแถวเป็น Mixed Use เพื่อการค้นหา แต่ผู้ซื้อต้องตรวจผังเมือง การใช้อาคาร ระบบดับเพลิง ที่จอดรถ ป้าย และใบอนุญาตสำหรับการใช้งานที่ต้องการ', 'MapxProp classifies the shophouses as mixed use for discovery, but buyers must verify planning, approved use, fire safety, parking, signage and licences', 'buyer', NULL, '', 70),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจอาคารทั้ง 2 คูหา โครงสร้าง ชั้นลอย การเจาะเชื่อม บันได ทางหนีไฟ หลังคา ความชื้น ระบบไฟฟ้า ประปา การครอบครอง ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Inspect both units, structure, mezzanines, openings, stairs, fire escape, roofs, moisture, utilities, possession, encumbrances, costs and current terms', 'buyer', NULL, '', 80)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'อาคารพาณิชย์ 2 คูหา ติดถนนใหญ่', 'ภาพด้านหน้าอาคารพาณิชย์ SAM รหัส 8Z7070 เลขที่ 31 และ 33 ติดถนนสมโภชเชียงใหม่ 700 ปี', 'https://npa.sam.or.th/site/images/npa/17051/20220530133326_8Z7070P1_65n.jpg', '/listing-media/sam/8z7070/01.webp', 'image/webp', 37190, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ด้านหน้าและทางเท้าริมถนน', 'ภาพด้านหน้าอาคารพาณิชย์และทางเท้าริมถนนสมโภชเชียงใหม่ 700 ปี', 'https://npa.sam.or.th/site/images/npa/17051/8Z7070P2_65n.jpg', '/listing-media/sam/8z7070/02.webp', 'image/webp', 39944, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่หน้าคูหาแรก', 'ภาพพื้นที่เปิดบริเวณหน้าคูหาและทางเข้าภายในอาคาร', 'https://npa.sam.or.th/site/images/npa/17051/8Z7070P3_65n.jpg', '/listing-media/sam/8z7070/03.webp', 'image/webp', 23780, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่หน้าคูหาที่สอง', 'ภาพพื้นที่เปิดและประตูม้วนบริเวณหน้าคูหาที่สอง', 'https://npa.sam.or.th/site/images/npa/17051/8Z7070P4_65n.jpg', '/listing-media/sam/8z7070/04.webp', 'image/webp', 25546, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ชั้นล่างภายใน', 'ภาพพื้นที่ชั้นล่างและส่วนเตรียมอาหารภายในอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/17051/8Z7070P5_65n.jpg', '/listing-media/sam/8z7070/05.webp', 'image/webp', 16678, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ครัวคูหาแรก', 'ภาพพื้นที่ครัวพร้อมเคาน์เตอร์และหน้าต่างภายในอาคาร', 'https://npa.sam.or.th/site/images/npa/17051/8Z7070P6_65n.jpg', '/listing-media/sam/8z7070/06.webp', 'image/webp', 19932, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ครัวอีกมุมหนึ่ง', 'ภาพเคาน์เตอร์ครัวและทางเชื่อมภายในอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/17051/8Z7070P7_65n.jpg', '/listing-media/sam/8z7070/07.webp', 'image/webp', 20160, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องภายในพร้อมหน้าต่าง', 'ภาพห้องภายในชั้นบนพร้อมหน้าต่างด้านหน้าอาคาร', 'https://npa.sam.or.th/site/images/npa/17051/8Z7070P8_65n.jpg', '/listing-media/sam/8z7070/08.webp', 'image/webp', 12928, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องชั้นบนพื้นกระเบื้อง', 'ภาพห้องชั้นบนพื้นกระเบื้องพร้อมหน้าต่างรับแสง', 'https://npa.sam.or.th/site/images/npa/17051/8Z7070P9_65n.jpg', '/listing-media/sam/8z7070/09.webp', 'image/webp', 20550, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องด้านหน้าอีกคูหา', 'ภาพห้องชั้นบนด้านหน้าอีกคูหาพร้อมหน้าต่าง', 'https://npa.sam.or.th/site/images/npa/17051/8Z7070P10_65n.jpg', '/listing-media/sam/8z7070/10.webp', 'image/webp', 18958, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงบันไดชั้นบน', 'ภาพโถงบันไดและทางเชื่อมภายในชั้นบน', 'https://npa.sam.or.th/site/images/npa/17051/8Z7070P11_65n.jpg', '/listing-media/sam/8z7070/11.webp', 'image/webp', 15352, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ชั้นบนและบันได', 'ภาพพื้นที่ชั้นบนที่แสดงแนวบันไดและส่วนเชื่อมคูหา', 'https://npa.sam.or.th/site/images/npa/17051/8Z7070P12_65n.jpg', '/listing-media/sam/8z7070/12.webp', 'image/webp', 17182, 450, 450, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ใช้งานร่วมกัน', 'ภาพพื้นที่ภายในที่ใช้เชื่อมต่อและใช้งานร่วมกันระหว่างสองคูหา', 'https://npa.sam.or.th/site/images/npa/17051/8Z7070P13_65n.jpg', '/listing-media/sam/8z7070/13.webp', 'image/webp', 14946, 450, 450, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงชั้นลอย', 'ภาพโถงชั้นลอยพร้อมราวกันตกและบันไดภายใน', 'https://npa.sam.or.th/site/images/npa/17051/8Z7070P14_65n.jpg', '/listing-media/sam/8z7070/14.webp', 'image/webp', 17226, 450, 450, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ชานพักบันได', 'ภาพชานพักบันไดและราวกันตกภายในอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/17051/8Z7070P15_65n.jpg', '/listing-media/sam/8z7070/15.webp', 'image/webp', 20482, 450, 450, 150, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังที่ดิน 5 แปลงและอาคาร 2 คูหา', 'ผังต้นทางแสดงโฉนด 5 ฉบับและตำแหน่งอาคารพาณิชย์เลขที่ 31 และ 33', 'https://npa.sam.or.th/site/images/npa/17051/20190531141615_8Z7070C1_62.jpg', '/listing-media/sam/8z7070/16.webp', 'image/webp', 12044, 450, 450, 160, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปทรัพย์', 'แผนที่ต้นทางแสดงเส้นทางจากถนนเชียงใหม่–พร้าวสู่ถนนสมโภชเชียงใหม่ 700 ปี และตำแหน่ง 8Z7070', 'https://npa.sam.or.th/site/images/npa/17051/20190531141615_8Z7070M1_62.jpg', '/listing-media/sam/8z7070/17.webp', 'image/webp', 56262, 785, 600, 170, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=17051&keyref=6004389',
        '8Z7070',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 6,114,000 for two shophouses numbered 31 and 33 fronting Somphot Chiang Mai 700 Pi Road 3029, Chang Phueak, Mueang Chiang Mai. Five contiguous title deeds numbered 88053, 88054, 90428, 90429 and 93151 cover 42.7 sq.wah / 170.8 sq.m. The rectangular land has approximately eight metres of southern road frontage and a maximum depth of approximately 21.3 metres. SAM lists two three-storey shophouses with mezzanines, jointly used and internally connected. The frontage road is reported as an asphalt public-utility road with approximately thirty metres of carriageway and forty metres of right-of-way. SAM shows yellow zoning and says the property is in a residential area; MapxProp classifies the shophouses as mixed use for discovery in both homes and business, subject to verification of approved use. Usable area, room counts, parking, age and utility specifications are not published. Source property photos display 22 July 2022. Administrator coordinates are approximately 0.06 metres from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all seventeen unique source property, interior, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Two Connected 3-Storey Shophouses on Chiang Mai 700 Pi Road, THB 6.114M',
        E'Two shophouses numbered 31 and 33 fronting Somphot Chiang Mai 700 Pi Road 3029, Chang Phueak, Mueang Chiang Mai. Title deeds 88053, 88054, 90428, 90429 and 93151 cover a combined 42.7 sq.wah (170.8 sq.m.). SAM shows yellow planning zoning.

The five contiguous plots form a rectangle with approximately eight metres of southern road frontage and a maximum depth of approximately 21.3 metres. SAM records two three-storey shophouses with mezzanines. Its condition survey says both units are jointly used and internally connected. Buyers must verify plans, permits, structural openings, mezzanines, stairs, fire escape arrangements and everything included in transfer.

Somphot Chiang Mai 700 Pi Road is reported as a public-utility road with an approximately thirty-metre asphalt carriageway and forty-metre right-of-way. The source does not publish usable area, bedroom or bathroom counts, parking, building age, or electrical and plumbing specifications. Buyers should ask SAM, the municipality and the Land Office to verify road rights, storeys, mezzanines, structural openings, approved use and fire safety.

SAM states that the property is in a residential area. MapxProp classifies the shophouses as mixed use so they can be discovered in both homes and business. This classification does not guarantee residential use or every commercial use. Buyers must confirm current yellow-zone planning, approved building use, signage, parking, fire safety and licences for the intended use.

Nearby places named by SAM include the Chiang Mai Government Center, Chiang Mai Provincial Administrative Organization and Ban Phra Non School. Directions use Chiang Mai–Phrao Highway 1001 from Chiang Mai–Lampang Highway 11 toward Mae Jo. At km 6+500, turn left onto Somphot Chiang Mai 700 Pi Road, pass Ruam Chok Market and Nakhon Payap International School, cross the Ping River and continue approximately 940 metres. The property is on the right.

The SAM page listed the property for direct purchase at an announced THB 6,114,000 when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, offer procedures, current price, promotions, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: 8Z7070. MapxProp does not collect deposits or represent SAM in the transaction.

Source property photos display 22 July 2022 and conditions may have changed. Buyers should inspect both units, structure, roofs, mezzanines, internal openings, stairs, fire escape, cracks, leaks, moisture, termites, bathrooms, electrical and plumbing systems, fire safety, possession, encumbrances, taxes, costs and every current term before deciding.',
        'Shophouses 31 and 33 on Somphot Chiang Mai 700 Pi Road',
        'Chang Phueak, Mueang Chiang Mai',
        'Somphot Chiang Mai 700 Pi Road 3029',
        'Chang Phueak',
        'Mueang Chiang Mai',
        'Chiang Mai',
        'SAM Two Connected Shophouses on Chiang Mai 700 Pi Road, THB 6.114M',
        'Official SAM NPA asset 8Z7070: two connected three-storey mixed-use shophouses with mezzanines on 170.8 sq.m. Direct-sale price THB 6.114M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset 8Z7070 two connected three storey mixed use shophouses 31 33 Somphot Chiang Mai 700 Pi Road Chang Phueak Mueang Chiang Mai title deeds 88053 88054 90428 90429 93151 42.7 sq.wah 170.8 sq.m. THB 6114000 mezzanine yellow zone residential')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=17051&keyref=6004389'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=17051&keyref=6004389',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z7070. Specifications, title deeds, storeys, mezzanines, connected-unit condition, images, rounded coordinates, announced price, direct-purchase status, road details, planning-zone wording and residential-area context come from that record.',
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
        '109a9b5e-a67b-4817-abfe-bce47b167c1d',
        jsonb_build_object(
            'reference_code', '8Z7070',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'mixed',
            'discovery_channels', jsonb_build_array('homes', 'business'),
            'title_document_count', 5,
            'plot_count', 5,
            'unit_count', 2,
            'registered_storeys', 3,
            'mezzanine_review_required', true,
            'connected_units_review_required', true,
            'public_road_review_required', true,
            'source_image_count', 17
        )
    );
END $$;

COMMIT;
