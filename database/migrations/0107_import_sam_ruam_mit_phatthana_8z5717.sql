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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing 8Z5717';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing 8Z5717';
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
        'c21d5f95-5d68-4335-b79f-e3a5d0d032a4',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'shophouse',
        'mixed',
        'sale',
        'whole_property',
        NULL,
        '92/36-37',
        'ขายตรง SAM อาคารพาณิชย์ 2 คูหา 4 ชั้นพร้อมชั้นลอย ถนนร่วมมิตรพัฒนา บางเขน ราคา 7.33 ล้านบาท',
        E'อาคารพาณิชย์ 2 คูหา เลขที่ 92/36 และ 92/37 ถนนร่วมมิตรพัฒนา แขวงท่าแร้ง เขตบางเขน กรุงเทพมหานคร โฉนดที่ดินเลขที่ 166942 และ 166943 จำนวน 2 ฉบับ เนื้อที่รวม 36 ตร.ว. (144 ตร.ม.) หน้า SAM ระบุเขตสีเหลือง

ที่ดิน 2 แปลงติดต่อกันเป็นรูปสี่เหลี่ยมผืนผ้า ด้านทิศเหนือติดถนน หน้ากว้างประมาณ 8 เมตร ลึกประมาณ 18 เมตร SAM ระบุรายการรับโอนกรรมสิทธิ์เป็นตึกแถว 4 ชั้น เลขที่ 92/36 และ 92/37 ส่วนข้อมูลสำรวจสภาพระบุเป็นอาคารพาณิชย์ 4 ชั้นพร้อมชั้นลอย 2 คูหา เจาะทะลุถึงกันทุกชั้น และมีบันไดขึ้นลงทางเดียว ผู้ซื้อควรตรวจแบบอาคาร ใบอนุญาต การเจาะเชื่อม โครงสร้าง ทางหนีไฟ และรายการที่จะโอนให้ตรงกัน

ถนนผ่านหน้าทรัพย์คือถนนร่วมมิตรพัฒนา SAM ระบุว่าเป็นทางสาธารณประโยชน์ ผิวจราจรคอนกรีตกว้างประมาณ 16 เมตร เขตทางกว้างประมาณ 20 เมตร หน้า SAM ไม่ได้เผยแพร่พื้นที่ใช้สอย จำนวนห้องนอน จำนวนห้องน้ำ ที่จอดรถ อายุอาคาร หรือรายละเอียดระบบไฟฟ้าและประปา ผู้ซื้อควรให้ SAM สำนักงานเขต และสำนักงานที่ดินยืนยันสิทธิทางเข้าออก ทะเบียนอาคาร จำนวนชั้น ชั้นลอย การเจาะเชื่อม การใช้อาคาร ระบบดับเพลิง และรายการที่จะโอน

หน้า SAM ระบุชัดว่าทรัพย์อยู่ในย่านที่อยู่อาศัยและพาณิชยกรรม MapxProp จึงจัดเป็น Mixed Use และให้ค้นพบได้ทั้งหมวดที่อยู่อาศัยและธุรกิจ อย่างไรก็ตาม การจัดหมวดนี้ไม่ใช่การรับรองว่าสามารถพักอาศัยหรือประกอบกิจการทุกประเภทได้ ผู้ซื้อต้องตรวจผังเมืองเขตสีเหลือง การใช้อาคาร ป้าย ที่จอดรถ ระบบดับเพลิง และใบอนุญาตสำหรับกิจการที่ต้องการ

สถานที่สำคัญใกล้เคียงตามหน้า SAM ได้แก่ ศูนย์การค้าเนเบอร์เซ็นเตอร์ โรงเรียนบ้านคลองบัว และโรงเรียนรัตนโกสินทร์สมโภชบางเขน การเดินทางใช้ถนนรามอินทราจากหลักสี่มุ่งหน้ามีนบุรี ผ่านกองบินตำรวจ แล้วเลี้ยวซ้ายเข้าถนนวัชรพล ผ่านเสถียรธรรมสถานและศูนย์การค้าเพลินนารี เลี้ยวซ้ายผ่านคลินิกเวชกรรมวัชรพล รวมประมาณ 2 กิโลเมตรถึงแยกถนนสุขาภิบาล 5 แล้วเลี้ยวขวาเข้าถนนร่วมมิตรพัฒนาประมาณ 50 เมตร ทรัพย์อยู่ด้านขวามือ

หน้า SAM แสดงสถานะ “ซื้อตรง” และราคาประกาศขาย 7,330,000 บาท ไม่ใช่การประมูลในสถานะที่ตรวจสอบเมื่อวันที่ 10 กันยายน 2569 ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะการครอบครอง และวิธีจำหน่ายล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ 8Z5717 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM

ภาพทรัพย์ต้นทางแสดงวันที่ 1 สิงหาคม 2567 และสภาพจริงอาจเปลี่ยนแปลง ภาพแสดงด้านหน้า พื้นที่ภายใน ชั้นลอย ห้องน้ำ ห้องหลายชั้น บันได ระเบียง ผังแปลง และแผนที่ หน้า SAM ยังเชื่อมโยงวิดีโอ YouTube ของทรัพย์ ผู้ซื้อควรนัดตรวจโครงสร้าง หลังคา ชั้นลอย การเจาะเชื่อม บันได ทางหนีไฟ รอยร้าว การรั่วซึม ความชื้น ปลวก ห้องน้ำ ระบบไฟฟ้า ประปา ระบบดับเพลิง การครอบครอง ภาระผูกพัน ภาษี ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        7330000,
        false,
        144,
        4,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'อาคารพาณิชย์เลขที่ 92/36 และ 92/37',
        'ถนนร่วมมิตรพัฒนา ใกล้ถนนสุขาภิบาล 5',
        'ถนนร่วมมิตรพัฒนา',
        NULL,
        13.86677946,
        100.64708978,
        'กรุงเทพมหานคร',
        'บางเขน',
        'ท่าแร้ง',
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
        'sam-direct-sale-two-shophouses-ruam-mit-phatthana-bang-khen-8z5717'
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
        property_listing_id, 'sale', 7330000, 'total', 'THB', false
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
            'title_document_numbers', jsonb_build_array('166942', '166943'),
            'title_document_count', 2,
            'land_area_rai', 0,
            'land_area_ngan', 0,
            'land_area_square_wah_remainder', 36,
            'land_area_square_wah', 36,
            'land_area_sqm', 144,
            'plot_count', 2,
            'unit_count', 2,
            'building_numbers', jsonb_build_array('92/36', '92/37'),
            'registered_building_type_th', 'ตึกแถว',
            'registered_storeys', 4,
            'surveyed_building_type_th', 'อาคารพาณิชย์ 4 ชั้นพร้อมชั้นลอย 2 คูหา',
            'displayed_full_storeys', 4,
            'mezzanine_reported', true,
            'units_connected_every_floor', true,
            'single_stair_access_reported', true,
            'reported_stair_count', 1,
            'usable_area_not_published', true,
            'bedroom_count_not_published', true,
            'bathroom_count_not_published', true,
            'parking_space_count_not_published', true,
            'building_age_not_published', true,
            'plot_shape', 'rectangle',
            'north_frontage_m_approx', 8,
            'maximum_depth_m_approx', 18
        ) || jsonb_build_object(
            'address_road_name', 'ถนนร่วมมิตรพัฒนา',
            'access_road_public_utility', true,
            'access_road_surface', 'concrete',
            'access_carriageway_width_m_approx', 16,
            'access_right_of_way_width_m_approx', 20,
            'zoning_color_th', 'เขตสีเหลือง ตามหน้า SAM',
            'source_reports_residential_and_commercial_area', true,
            'mixed_use_classification', true,
            'mixed_use_classification_basis', 'SAM ระบุว่าทรัพย์อยู่ในย่านที่อยู่อาศัยและพาณิชยกรรม และ MapxProp จัดอาคารพาณิชย์ประเภทตึกแถวเป็นการใช้งานผสมเพื่อการค้นหา โดยผู้ซื้อต้องตรวจการใช้อาคารที่อนุญาตจริง',
            'intended_use_requires_independent_verification', true,
            'source_video_url', 'https://youtu.be/FfaNKFyPKZ8',
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'computed_price_per_square_wah', 203611.11,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_information_date_not_published', true,
            'source_property_photo_date_displayed', '2024-08-01',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '13.86678,100.64709',
            'administrator_coordinate_distance_from_source_m_approx', 0.07
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z5717. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนร่วมมิตรพัฒนา', 'Ruam Mit Phatthana Road', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ถนนสุขาภิบาล 5', 'Sukhaphiban 5 Road', 'road', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'ถนนวัชรพล', 'Watcharaphon Road', 'road', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'ถนนรามอินทรา', 'Ram Inthra Road', 'road', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'ศูนย์การค้าเนเบอร์เซ็นเตอร์', 'Neighbor Center', 'shopping', NULL, NULL, NULL, 50, true),
        (property_listing_id, 'ศูนย์การค้าเพลินนารี', 'Plearnary Mall', 'shopping', NULL, NULL, NULL, 60, true),
        (property_listing_id, 'โรงเรียนบ้านคลองบัว', 'Ban Khlong Bua School', 'education', NULL, NULL, NULL, 70, true),
        (property_listing_id, 'โรงเรียนรัตนโกสินทร์สมโภชบางเขน', 'Rattanakosin Somphot Bang Khen School', 'education', NULL, NULL, NULL, 80, true),
        (property_listing_id, 'เสถียรธรรมสถาน', 'Sathira Dhammasathan', 'landmark', NULL, NULL, NULL, 90, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '7,330,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 7,330,000 — confirm the latest price with SAM', 'unspecified', 7330000, 'THB', 20),
        (property_listing_id, 'title_document_due_diligence', 'การตรวจสอบเอกสารสิทธิ์', 'Title-document due diligence', 'โฉนดเลขที่ 166942 และ 166943 รวม 2 ฉบับ ต้องตรวจเลขที่ดิน ระวาง แนวเขต และความตรงกับพื้นที่จริง', 'Verify title deeds 166942 and 166943, including parcel numbers, survey sheets, boundaries and the actual site', 'buyer', 2, 'documents', 30),
        (property_listing_id, 'registered_structure', 'สิ่งปลูกสร้างตามรายการรับโอน', 'Registered acquisition structure', 'ตึกแถว 4 ชั้น 2 คูหา เลขที่ 92/36–92/37; ผลสำรวจระบุอาคารพาณิชย์ 4 ชั้นพร้อมชั้นลอย ต้องตรวจทะเบียน แบบและรายการที่จะโอน', 'Two four-storey shophouses numbered 92/36–92/37; the survey reports commercial buildings with mezzanines, requiring verification against the register, plans and transfer inventory', 'buyer', 4, 'storeys', 40),
        (property_listing_id, 'internal_connection_and_stair', 'การเจาะเชื่อมและบันไดร่วม', 'Internal openings and shared stair', '2 คูหาเจาะทะลุถึงกันทุกชั้นและมีบันไดขึ้นลงทางเดียว ต้องตรวจโครงสร้าง แบบอาคาร ทางหนีไฟ และการแบ่งใช้พื้นที่จริง', 'The two units connect on every floor and share one stair; verify structure, plans, fire escape and actual space allocation', 'buyer', 1, 'stairs', 50),
        (property_listing_id, 'public_frontage_road', 'ถนนสาธารณประโยชน์หน้าทรัพย์', 'Public frontage road', 'ถนนร่วมมิตรพัฒนาเป็นทางสาธารณประโยชน์ ผิวคอนกรีตกว้างประมาณ 16 ม. เขตทางประมาณ 20 ม. ต้องตรวจแนวเขตและสภาพจริง', 'Ruam Mit Phatthana Road is reported as a public-utility road, with an approximately 16 m concrete carriageway and 20 m right-of-way; verify boundaries and actual condition', 'buyer', 20, 'meters', 60),
        (property_listing_id, 'mixed_use_review', 'การใช้เพื่ออยู่อาศัยและธุรกิจ', 'Residential and business use review', 'ต้นทางระบุย่านที่อยู่อาศัยและพาณิชยกรรม และ MapxProp จัดเป็น Mixed Use แต่ผู้ซื้อต้องตรวจผังเมือง การใช้อาคาร ระบบดับเพลิง ที่จอดรถ ป้าย และใบอนุญาต', 'The source reports residential-commercial surroundings and MapxProp classifies the property as mixed use, but buyers must verify planning, approved use, fire safety, parking, signage and licences', 'buyer', NULL, '', 70),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจอาคารทั้ง 2 คูหา โครงสร้าง ชั้นลอย การเจาะเชื่อม บันไดร่วม ทางหนีไฟ หลังคา ระเบียง ความชื้น ระบบไฟฟ้า ประปา การครอบครอง ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Inspect both units, structure, mezzanines, openings, shared stair, fire escape, roofs, balconies, moisture, utilities, possession, encumbrances, costs and current terms', 'buyer', NULL, '', 80)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'อาคารพาณิชย์ 2 คูหา ถนนร่วมมิตรพัฒนา', 'ภาพด้านหน้าอาคารพาณิชย์ SAM รหัส 8Z5717 จำนวน 2 คูหา เลขที่ 92/36–92/37', 'https://npa.sam.or.th/site/images/npa/12987/20260106101301_8Z5717P1_68.jpg', '/listing-media/sam/8z5717/01.webp', 'image/webp', 27976, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวอาคารและถนนร่วมมิตรพัฒนา', 'ภาพแนวอาคารพาณิชย์และถนนร่วมมิตรพัฒนาจากมุมด้านข้าง', 'https://npa.sam.or.th/site/images/npa/12987/8Z5717P2_68.jpg', '/listing-media/sam/8z5717/02.webp', 'image/webp', 29640, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ชั้นล่างและชั้นลอย', 'ภาพพื้นที่เปิดภายในชั้นล่างพร้อมชั้นลอยของอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/12987/8Z5717P3_68.jpg', '/listing-media/sam/8z5717/03.webp', 'image/webp', 13030, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงชั้นล่างแบบเปิด', 'ภาพโถงชั้นล่างและส่วนเชื่อมภายในอาคารพาณิชย์ 2 คูหา', 'https://npa.sam.or.th/site/images/npa/12987/8Z5717P4_68.jpg', '/listing-media/sam/8z5717/04.webp', 'image/webp', 6972, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำชั้นล่าง', 'ภาพห้องน้ำและสุขภัณฑ์ภายในอาคารพาณิชย์ SAM 8Z5717', 'https://npa.sam.or.th/site/images/npa/12987/8Z5717P5_68.jpg', '/listing-media/sam/8z5717/05.webp', 'image/webp', 8986, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องภายในอาคาร', 'ภาพห้องภายในพร้อมหน้าต่างและพื้นที่เตรียมใช้งาน', 'https://npa.sam.or.th/site/images/npa/12987/8Z5717P6_68.jpg', '/listing-media/sam/8z5717/06.webp', 'image/webp', 7722, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บันไดร่วมภายใน', 'ภาพบันไดหลักที่ใช้ขึ้นลงภายในอาคารพาณิชย์ 2 คูหา', 'https://npa.sam.or.th/site/images/npa/12987/8Z5717P7_68.jpg', '/listing-media/sam/8z5717/07.webp', 'image/webp', 9132, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงชั้นบนและชั้นลอย', 'ภาพโถงชั้นบนพร้อมราวกันตกและช่องเปิดชั้นลอย', 'https://npa.sam.or.th/site/images/npa/12987/8Z5717P8_68.jpg', '/listing-media/sam/8z5717/08.webp', 'image/webp', 10104, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ชั้นบนแบบเปิด', 'ภาพพื้นที่เปิดชั้นบนของอาคารพาณิชย์พร้อมเสาและราวกันตก', 'https://npa.sam.or.th/site/images/npa/12987/8Z5717P9_68.jpg', '/listing-media/sam/8z5717/09.webp', 'image/webp', 8486, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ระเบียงภายนอก', 'ภาพระเบียงภายนอกอาคารและสภาพพื้นบริเวณด้านข้าง', 'https://npa.sam.or.th/site/images/npa/12987/8Z5717P10_68.jpg', '/listing-media/sam/8z5717/10.webp', 'image/webp', 30428, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ระเบียงอีกมุมหนึ่ง', 'ภาพระเบียงภายนอกอีกมุมพร้อมแนวอาคารฝั่งตรงข้าม', 'https://npa.sam.or.th/site/images/npa/12987/8Z5717P11_68.jpg', '/listing-media/sam/8z5717/11.webp', 'image/webp', 25510, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ภายในชั้นบน', 'ภาพพื้นที่ภายในชั้นบนแบบเปิดพร้อมบันไดและหน้าต่าง', 'https://npa.sam.or.th/site/images/npa/12987/8Z5717P12_68.jpg', '/listing-media/sam/8z5717/12.webp', 'image/webp', 9546, 450, 450, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงและส่วนเชื่อมคูหา', 'ภาพโถงภายในที่แสดงพื้นที่เชื่อมระหว่างคูหา', 'https://npa.sam.or.th/site/images/npa/12987/8Z5717P13_68.jpg', '/listing-media/sam/8z5717/13.webp', 'image/webp', 8938, 450, 450, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำชั้นบน', 'ภาพห้องน้ำชั้นบนภายในอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/12987/8Z5717P14_68.jpg', '/listing-media/sam/8z5717/14.webp', 'image/webp', 14080, 450, 450, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บันไดอีกช่วงหนึ่ง', 'ภาพบันไดคอนกรีตและราวจับเชื่อมระหว่างชั้น', 'https://npa.sam.or.th/site/images/npa/12987/8Z5717P15_68.jpg', '/listing-media/sam/8z5717/15.webp', 'image/webp', 14296, 450, 450, 150, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องเปิดโล่งชั้นบน', 'ภาพห้องภายในชั้นบนพร้อมหน้าต่างหลายบาน', 'https://npa.sam.or.th/site/images/npa/12987/8Z5717P16_68.jpg', '/listing-media/sam/8z5717/16.webp', 'image/webp', 9934, 450, 450, 160, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงบันไดชั้นบน', 'ภาพโถงชั้นบนและแนวบันไดร่วมของอาคาร', 'https://npa.sam.or.th/site/images/npa/12987/8Z5717P17_68.jpg', '/listing-media/sam/8z5717/17.webp', 'image/webp', 10112, 450, 450, 170, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องพร้อมประตูระเบียง', 'ภาพห้องภายในพร้อมประตูกระจกออกสู่ระเบียง', 'https://npa.sam.or.th/site/images/npa/12987/8Z5717P18_68.jpg', '/listing-media/sam/8z5717/18.webp', 'image/webp', 8856, 450, 450, 180, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องด้านหน้าพร้อมหน้าต่าง', 'ภาพห้องชั้นบนด้านหน้าพร้อมหน้าต่างขนาดใหญ่', 'https://npa.sam.or.th/site/images/npa/12987/8Z5717P19_68.jpg', '/listing-media/sam/8z5717/19.webp', 'image/webp', 10548, 450, 450, 190, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องแบ่งพื้นที่ภายใน', 'ภาพห้องภายในที่มีผนังแบ่งพื้นที่และหน้าต่าง', 'https://npa.sam.or.th/site/images/npa/12987/8Z5717P20_68.jpg', '/listing-media/sam/8z5717/20.webp', 'image/webp', 8300, 450, 450, 200, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องชั้นบนใกล้บันได', 'ภาพห้องชั้นบนและช่องบันไดภายในอาคาร', 'https://npa.sam.or.th/site/images/npa/12987/8Z5717P21_68.jpg', '/listing-media/sam/8z5717/21.webp', 'image/webp', 11148, 450, 450, 210, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำเพิ่มเติม', 'ภาพห้องน้ำเพิ่มเติมพร้อมอ่างล้างหน้าและสุขภัณฑ์', 'https://npa.sam.or.th/site/images/npa/12987/8Z5717P22_68.jpg', '/listing-media/sam/8z5717/22.webp', 'image/webp', 13256, 450, 450, 220, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังตำแหน่งทางเข้าทรัพย์', 'ผังต้นทางแสดงทางเข้าจากถนนสุขาภิบาล 5 สู่ถนนร่วมมิตรพัฒนาและตำแหน่งทรัพย์', 'https://npa.sam.or.th/site/images/npa/12987/20201027140825_8Z5717C1_62.jpg', '/listing-media/sam/8z5717/23.webp', 'image/webp', 15826, 450, 450, 230, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังที่ดินและอาคาร 2 คูหา', 'ผังต้นทางแสดงโฉนด 166942 และ 166943 กับตำแหน่งอาคารพาณิชย์ 2 คูหา', 'https://npa.sam.or.th/site/images/npa/12987/20201027140825_8Z5717C2_62.jpg', '/listing-media/sam/8z5717/24.webp', 'image/webp', 17156, 450, 450, 240, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปทรัพย์', 'แผนที่ต้นทางแสดงเส้นทางถนนรามอินทรา ถนนวัชรพล ถนนสุขาภิบาล 5 และถนนร่วมมิตรพัฒนาไปยัง 8Z5717', 'https://npa.sam.or.th/site/images/npa/12987/20201027140825_8Z5717M1_62.jpg', '/listing-media/sam/8z5717/25.webp', 'image/webp', 37036, 785, 600, 250, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=12987&keyref=6004389',
        '8Z5717',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 7,330,000 for two shophouses numbered 92/36 and 92/37 on Ruam Mit Phatthana Road, Tha Raeng, Bang Khen, Bangkok. Two contiguous title deeds numbered 166942 and 166943 cover 36 sq.wah / 144 sq.m. The rectangular land has approximately eight metres of northern road frontage and a maximum depth of approximately eighteen metres. SAM lists two four-storey shophouses, while its survey describes two four-storey commercial buildings with mezzanines, internally connected on every floor and served by one stair. Ruam Mit Phatthana Road is reported as a concrete public-utility road with approximately sixteen metres of carriageway and twenty metres of right-of-way. SAM shows yellow zoning and explicitly describes residential-commercial surroundings; MapxProp therefore classifies the listing as mixed use and includes it in both homes and business discovery, subject to verification of approved use. Usable area, room counts, parking, age and utility specifications are not published. Source property photos display 1 August 2024, and the source links the property video https://youtu.be/FfaNKFyPKZ8. Administrator coordinates are approximately 0.07 metres from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all twenty-five unique source property, interior, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Two Connected 4-Storey Shophouses with Mezzanines in Bang Khen, THB 7.33M',
        E'Two shophouses numbered 92/36 and 92/37 on Ruam Mit Phatthana Road, Tha Raeng, Bang Khen, Bangkok. Title deeds 166942 and 166943 cover a combined 36 sq.wah (144 sq.m.). SAM shows yellow planning zoning.

The two contiguous plots form a rectangle with approximately eight metres of northern road frontage and a maximum depth of approximately eighteen metres. SAM records two four-storey shophouses. Its condition survey describes two four-storey commercial buildings with mezzanines, connected internally on every floor and served by one stair. Buyers must verify plans, permits, structural openings, the shared stair, fire escape arrangements and everything included in transfer.

Ruam Mit Phatthana Road is reported as a public-utility road with an approximately sixteen-metre concrete carriageway and twenty-metre right-of-way. The source does not publish usable area, bedroom or bathroom counts, parking, building age, or electrical and plumbing specifications. Buyers should ask SAM, the district office and the Land Office to verify road rights, storeys, mezzanines, structural openings, plans, approved use and fire safety.

SAM expressly states that the property is in a residential and commercial area. MapxProp therefore classifies it as mixed use and includes it in both homes and business discovery. This classification does not guarantee residential use or every commercial use. Buyers must confirm current yellow-zone planning, approved building use, signage, parking, fire safety and licences for the intended use.

Nearby places named by SAM include Neighbor Center, Ban Khlong Bua School and Rattanakosin Somphot Bang Khen School. Directions use Ram Inthra Road from Lak Si toward Min Buri, passing the Police Aviation Division, then turn left onto Watcharaphon Road, pass Sathira Dhammasathan and Plearnary Mall, and continue to the Sukhaphiban 5 intersection. Turn right onto Ruam Mit Phatthana Road for approximately fifty metres; the property is on the right.

The SAM page listed the property for direct purchase at an announced THB 7,330,000 when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, offer procedures, current price, promotions, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: 8Z5717. MapxProp does not collect deposits or represent SAM in the transaction.

Source property photos display 1 August 2024 and conditions may have changed. SAM also links a property video. Buyers should inspect both units, structure, roofs, mezzanines, internal openings, shared stair, fire escape, balconies, cracks, leaks, moisture, termites, bathrooms, electrical and plumbing systems, fire safety, possession, encumbrances, taxes, costs and every current term before deciding.',
        'Shophouses 92/36–92/37 on Ruam Mit Phatthana Road',
        'Near Sukhaphiban 5 Road, Tha Raeng, Bang Khen',
        'Ruam Mit Phatthana Road',
        'Tha Raeng',
        'Bang Khen',
        'Bangkok',
        'SAM Two Connected Shophouses in Bang Khen, THB 7.33M',
        'Official SAM NPA asset 8Z5717: two connected four-storey mixed-use shophouses with mezzanines on 144 sq.m. in Bang Khen. Direct-sale price THB 7.33M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset 8Z5717 two connected four storey mixed use shophouses 92/36 92/37 Ruam Mit Phatthana Tha Raeng Bang Khen Bangkok title deeds 166942 166943 36 sq.wah 144 sq.m. THB 7330000 mezzanine shared stair yellow zone residential commercial')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=12987&keyref=6004389'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=12987&keyref=6004389',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z5717. Specifications, title deeds, registered and surveyed storeys, mezzanines, connected-unit condition, shared stair, images, video link, rounded coordinates, announced price, direct-purchase status, road details, planning-zone wording and residential-commercial context come from that record.',
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
        'c21d5f95-5d68-4335-b79f-e3a5d0d032a4',
        jsonb_build_object(
            'reference_code', '8Z5717',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'mixed',
            'discovery_channels', jsonb_build_array('homes', 'business'),
            'title_document_count', 2,
            'unit_count', 2,
            'registered_storeys', 4,
            'mezzanine_review_required', true,
            'connected_units_review_required', true,
            'single_stair_review_required', true,
            'public_road_review_required', true,
            'source_image_count', 25,
            'source_video_available', true
        )
    );
END $$;

COMMIT;
