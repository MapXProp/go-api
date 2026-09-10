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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing 8Z6903';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing 8Z6903';
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
        '850f8385-2829-4156-98f3-a214501e77dd',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'shophouse',
        'mixed',
        'sale',
        'whole_property',
        '110/26',
        'ขายตรง SAM อาคารพาณิชย์ 2 ชั้นพร้อมชั้นลอย ติดถนน 2 ด้าน ถนนศรีจันทร์ ขอนแก่น ราคา 3.518 ล้านบาท',
        E'อาคารพาณิชย์เลขที่ 110/26 ถนนศรีจันทร์ ตำบลในเมือง อำเภอเมืองขอนแก่น จังหวัดขอนแก่น บนโฉนดที่ดินเลขที่ 24535 จำนวน 1 ฉบับ เนื้อที่ 24.8 ตร.ว. (99.2 ตร.ม.) หน้า SAM ระบุเขตพื้นที่สีชมพูและย่านโดยรอบเป็นทั้งที่อยู่อาศัยและพาณิชยกรรม\n\nที่ดินเป็นรูปสี่เหลี่ยมผืนผ้าและติดถนน 2 ด้าน ด้านทิศตะวันออกติดถนนอนามัย และด้านทิศตะวันตกติดซอยศรีจันทร์ 11/5 หน้ากว้างแต่ละด้านประมาณ 6 เมตร ลึกสุดประมาณ 17 เมตร รายการรับโอนกรรมสิทธิ์สิ่งปลูกสร้างระบุเป็นตึกแถว 2 ชั้น เลขที่ 110/26 ส่วนการสำรวจของ SAM ระบุลักษณะเป็นอาคารพาณิชย์ 2 ชั้น มีชั้นลอย ผู้ซื้อควรตรวจแนวเขต การติดถนนทั้งสองด้าน ทางเข้าออก ทะเบียนอาคาร แบบแปลน ใบอนุญาต จำนวนชั้น ชั้นลอย และสิ่งปลูกสร้างที่จะโอนให้ตรงกัน\n\nSAM ระบุว่าซอยศรีจันทร์ 11/5 เป็นทางสาธารณประโยชน์ ผิวจราจรคอนกรีตกว้างประมาณ 6 เมตร เขตทางกว้างประมาณ 8 เมตร ควรให้ SAM สำนักงานที่ดิน และหน่วยงานท้องถิ่นยืนยันแนวเขต สถานะทางสาธารณะ ทางเข้าออกจากทั้งสองด้าน และการใช้ประโยชน์จริงก่อนเสนอซื้อ\n\nหน้า SAM ไม่ได้เผยแพร่พื้นที่ใช้สอย จำนวนห้องนอน ห้องน้ำ ที่จอดรถ อายุอาคาร ระบบไฟฟ้า-ประปา สถานะการครอบครอง หรือภาระผูกพันอื่น MapxProp จัดอาคารพาณิชย์นี้เป็น Mixed Use เพื่อให้ค้นพบได้ทั้งหมวดที่อยู่อาศัยและธุรกิจ เหมาะสำหรับพิจารณาเป็นที่พักอาศัย หน้าร้าน หรือสำนักงาน แต่การจัดหมวดไม่ใช่การรับรองว่าสามารถอยู่อาศัยหรือประกอบกิจการทุกประเภทได้ ผู้ซื้อต้องตรวจผังเมืองเขตสีชมพู การใช้อาคาร ใบอนุญาต ป้าย ที่จอดรถ ทางหนีไฟ ระบบดับเพลิง และใบอนุญาตของกิจการที่ต้องการ\n\nสถานที่สำคัญใกล้เคียงที่ SAM ระบุ ได้แก่ โรงพยาบาลขอนแก่น วิทยาลัยเทคนิคขอนแก่น สำนักงานสาธารณสุข โรงพยาบาลศูนย์ขอนแก่น วัดศรีจันทร์ และธนาคารแห่งประเทศไทย การเดินทางตาม SAM ใช้ถนนศรีจันทร์จากตัวเมืองขอนแก่นมุ่งหน้ากาฬสินธุ์ ผ่านธนาคารแห่งประเทศไทย วัดศรีจันทร์ และโรงแรมแก่นนคร ถึงสี่แยกถนนอนามัย แล้วเลี้ยวขวาเข้าถนนอนามัยประมาณ 20 เมตร ทรัพย์อยู่ด้านขวามือ\n\nหน้า SAM แสดงสถานะ “ซื้อตรง” และราคาประกาศขาย 3,518,000 บาท ไม่ใช่การประมูลในสถานะที่ตรวจสอบเมื่อวันที่ 10 กันยายน 2569 ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะการครอบครอง และวิธีจำหน่ายล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ 8Z6903 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nภาพทรัพย์และภายในแสดงวันที่ 24 มีนาคม 2567 และบางภาพเห็นฝ้าหรือเพดานที่ควรตรวจสภาพเพิ่มเติม สภาพจริงอาจเปลี่ยนแปลง ผู้ซื้อควรนัดตรวจโครงสร้าง หลังคา ชั้นลอย บันได ทางหนีไฟ รอยร้าว ความชื้น ปลวก ฝ้าเพดาน ระบบไฟฟ้าและประปา ห้องน้ำ ระบบดับเพลิง การครอบครอง ภาระผูกพัน ภาษี ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        3518000,
        false,
        99.2,
        2,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'อาคารพาณิชย์เลขที่ 110/26',
        'ติดถนนอนามัยและซอยศรีจันทร์ 11/5',
        'ศรีจันทร์',
        NULL,
        16.428840134266277,
        102.84384968640252,
        'ขอนแก่น',
        'เมืองขอนแก่น',
        'ในเมือง',
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
        'sam-direct-sale-corner-shophouse-srichan-khon-kaen-8z6903'
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
        property_listing_id, 'sale', 3518000, 'total', 'THB', false
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
            'title_document_numbers', jsonb_build_array('24535'),
            'title_document_count', 1,
            'land_area_rai', 0,
            'land_area_ngan', 0,
            'land_area_square_wah_remainder', 24.8,
            'land_area_square_wah', 24.8,
            'land_area_sqm', 99.2,
            'plot_count', 1,
            'unit_count', 1,
            'building_numbers', jsonb_build_array('110/26'),
            'registered_transfer_description', 'ตึกแถว 2 ชั้น เลขที่ 110/26',
            'surveyed_building_description', 'อาคารพาณิชย์ 2 ชั้น มีชั้นลอย',
            'registered_floor_count_numeric', 2,
            'has_mezzanine', true,
            'plot_shape', 'rectangle',
            'dual_road_frontage', true,
            'east_frontage_road', 'ถนนอนามัย',
            'west_frontage_road', 'ซอยศรีจันทร์ 11/5',
            'east_road_frontage_m_approx', 6,
            'west_road_frontage_m_approx', 6,
            'maximum_depth_m', 17,
            'front_road_legal_status_th', 'ซอยศรีจันทร์ 11/5 เป็นทางสาธารณประโยชน์',
            'front_road_surface', 'concrete',
            'front_road_width_m', 6,
            'front_right_of_way_width_m', 8
        ) || jsonb_build_object(
            'zoning_color_th', 'สีชมพู ตามหน้า SAM',
            'source_neighborhood_use_th', 'ย่านที่อยู่อาศัยและพาณิชยกรรม',
            'mixed_use_classification', true,
            'mixed_use_basis', 'อาคารพาณิชย์ในย่านที่อยู่อาศัยและพาณิชยกรรม สามารถพิจารณาใช้เป็นที่อยู่อาศัย หน้าร้าน หรือสำนักงาน โดยต้องตรวจการใช้อาคารและใบอนุญาต',
            'approved_use_requires_independent_verification', true,
            'usable_area_not_published', true,
            'bedroom_count_not_published', true,
            'bathroom_count_not_published', true,
            'parking_information_not_published', true,
            'building_age_not_published', true,
            'utilities_information_not_published', true,
            'occupancy_status_not_published', true,
            'other_encumbrances_not_published', true,
            'source_photo_shows_ceiling_condition_for_review', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'computed_price_per_square_wah', 141854.84,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_property_photo_date_displayed', '2024-03-24',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '16.42884,102.84385',
            'administrator_coordinate_distance_from_source_m_approx', 0.037
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z6903. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนศรีจันทร์', 'Srichan Road', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ถนนอนามัย', 'Anamai Road', 'road', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'ซอยศรีจันทร์ 11/5', 'Srichan Soi 11/5', 'road', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'โรงพยาบาลขอนแก่น', 'Khon Kaen Hospital', 'healthcare', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'วิทยาลัยเทคนิคขอนแก่น', 'Khon Kaen Technical College', 'education', NULL, NULL, NULL, 50, true),
        (property_listing_id, 'สำนักงานสาธารณสุข', 'Public Health Office', 'government', NULL, NULL, NULL, 60, false),
        (property_listing_id, 'โรงพยาบาลศูนย์ขอนแก่น', 'Khon Kaen Regional Hospital', 'healthcare', NULL, NULL, NULL, 70, false),
        (property_listing_id, 'วัดศรีจันทร์', 'Wat Srichan', 'landmark', NULL, NULL, NULL, 80, true),
        (property_listing_id, 'ธนาคารแห่งประเทศไทย', 'Bank of Thailand', 'government', NULL, NULL, NULL, 90, true),
        (property_listing_id, 'โรงแรมแก่นนคร', 'Kaen Nakhon Hotel', 'landmark', NULL, NULL, NULL, 100, false)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '3,518,000 บาท — โปรดตรวจสอบราคาล่าสุดและโปรโมชั่นกับ SAM', 'THB 3,518,000 — confirm the latest price and promotions with SAM', 'unspecified', 3518000, 'THB', 20),
        (property_listing_id, 'registered_building', 'สิ่งปลูกสร้างตามรายการรับโอน', 'Registered building', 'ตึกแถว 2 ชั้น เลขที่ 110/26 โดยการสำรวจของ SAM ระบุเป็นอาคารพาณิชย์ 2 ชั้น มีชั้นลอย', 'A two-storey shophouse numbered 110/26; SAM survey information describes a two-storey commercial building with a mezzanine', 'buyer', 2, 'floors', 30),
        (property_listing_id, 'dual_road_frontage', 'ติดถนน 2 ด้าน', 'Dual road frontage', 'ด้านตะวันออกติดถนนอนามัย ด้านตะวันตกติดซอยศรีจันทร์ 11/5 หน้ากว้างด้านละประมาณ 6 เมตร', 'East side fronts Anamai Road and west side fronts Srichan Soi 11/5, with approximately six metres of frontage on each side', 'unspecified', 2, 'roads', 40),
        (property_listing_id, 'public_road', 'ถนนสาธารณะ', 'Public road', 'ซอยศรีจันทร์ 11/5 เป็นทางสาธารณประโยชน์ ผิวคอนกรีตกว้างประมาณ 6 เมตร เขตทางประมาณ 8 เมตร', 'Srichan Soi 11/5 is described as a public-utility concrete road approximately six metres wide in an eight-metre right of way', 'unspecified', 6, 'metres', 50),
        (property_listing_id, 'mixed_use_due_diligence', 'การใช้งานแบบผสม', 'Mixed-use due diligence', 'MapxProp แสดงทั้งหมวดที่อยู่อาศัยและธุรกิจ แต่ผู้ซื้อต้องตรวจผังเมือง การใช้อาคาร ใบอนุญาต ที่จอดรถ ป้าย ทางหนีไฟ และระบบดับเพลิง', 'MapxProp shows the property in both homes and business; buyers must verify zoning, approved use, licences, parking, signage, fire escape and fire safety', 'buyer', NULL, '', 60),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนด แนวเขต ทางเข้าออกสองด้าน ทะเบียนอาคาร ชั้นลอย โครงสร้าง หลังคา ฝ้าเพดาน บันได ทางหนีไฟ การครอบครอง ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Verify the title deed, boundaries, dual access, building registration, mezzanine, structure, roof, ceilings, stairs, fire escape, possession, encumbrances, costs and latest terms', 'buyer', NULL, '', 70)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ด้านหน้าอาคารพาณิชย์ 110/26', 'อาคารพาณิชย์ SAM รหัส 8Z6903 เลขที่ 110/26 ถนนศรีจันทร์ ขอนแก่น', 'https://npa.sam.or.th/site/images/npa/17036/20250804142903_8Z6903P2_68.jpg', '/listing-media/sam/8z6903/01.webp', 'image/webp', 30362, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ด้านหน้าอาคารอีกฝั่งถนน', 'ภาพด้านหน้าอาคารพาณิชย์เลขที่ 110/26 และอาคารข้างเคียงจากอีกฝั่งถนน', 'https://npa.sam.or.th/site/images/npa/17036/8Z6903P3_68.jpg', '/listing-media/sam/8z6903/02.webp', 'image/webp', 23618, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมด้านข้างอาคารพาณิชย์', 'ภาพมุมด้านข้างและขอบเขตอาคารพาณิชย์ SAM รหัส 8Z6903', 'https://npa.sam.or.th/site/images/npa/17036/8Z6903P4_68.jpg', '/listing-media/sam/8z6903/03.webp', 'image/webp', 18240, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงชั้นล่างและชั้นลอย', 'ภาพพื้นที่ชั้นล่าง มุมบันได และชั้นลอยภายในอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/17036/8Z6903P5_68.jpg', '/listing-media/sam/8z6903/04.webp', 'image/webp', 16426, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่เปิดชั้นล่าง', 'ภาพพื้นที่เปิดภายในชั้นล่างมองออกไปยังประตูม้วนด้านหน้า', 'https://npa.sam.or.th/site/images/npa/17036/8Z6903P6_68.jpg', '/listing-media/sam/8z6903/05.webp', 'image/webp', 16438, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ชั้นล่างและบันได', 'ภาพพื้นที่ชั้นล่างภายในอาคารพร้อมบันไดขึ้นชั้นบน', 'https://npa.sam.or.th/site/images/npa/17036/8Z6903P7_68.jpg', '/listing-media/sam/8z6903/06.webp', 'image/webp', 15312, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ข้างบันได', 'ภาพพื้นที่ภายในบริเวณข้างบันไดและทางไปส่วนหลังอาคาร', 'https://npa.sam.or.th/site/images/npa/17036/8Z6903P10_68.jpg', '/listing-media/sam/8z6903/07.webp', 'image/webp', 15246, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเดินภายในอาคาร', 'ภาพทางเดินและพื้นที่ภายในอาคารพาณิชย์ SAM รหัส 8Z6903', 'https://npa.sam.or.th/site/images/npa/17036/8Z6903P11_68.jpg', '/listing-media/sam/8z6903/08.webp', 'image/webp', 15954, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ภายในพร้อมตู้จัดเก็บ', 'ภาพพื้นที่ภายในอาคารพร้อมตู้และชั้นจัดเก็บติดผนัง', 'https://npa.sam.or.th/site/images/npa/17036/8Z6903P12_68.jpg', '/listing-media/sam/8z6903/09.webp', 'image/webp', 13370, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ส่วนหลังอาคาร', 'ภาพทางเดินและประตูไปยังพื้นที่ส่วนหลังของอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/17036/8Z6903P13_68.jpg', '/listing-media/sam/8z6903/10.webp', 'image/webp', 21410, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำภายในอาคาร', 'ภาพห้องน้ำภายในอาคารพาณิชย์เลขที่ 110/26', 'https://npa.sam.or.th/site/images/npa/17036/8Z6903P14_68.jpg', '/listing-media/sam/8z6903/11.webp', 'image/webp', 17960, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องชั้นบนพร้อมแนวหน้าต่าง', 'ภาพห้องชั้นบนของอาคารพร้อมแนวหน้าต่างด้านหน้า', 'https://npa.sam.or.th/site/images/npa/17036/8Z6903P15_68.jpg', '/listing-media/sam/8z6903/12.webp', 'image/webp', 18476, 450, 450, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องชั้นบนและสภาพเพดาน', 'ภาพห้องชั้นบนซึ่งแสดงสภาพฝ้าหรือเพดานที่ควรตรวจเพิ่มเติม', 'https://npa.sam.or.th/site/images/npa/17036/8Z6903P16_68.jpg', '/listing-media/sam/8z6903/13.webp', 'image/webp', 18152, 450, 450, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ดาดฟ้า', 'ภาพพื้นที่เปิดบนดาดฟ้าของอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/17036/8Z6903P17_68.jpg', '/listing-media/sam/8z6903/14.webp', 'image/webp', 23702, 450, 450, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ส่วนใช้งานบนดาดฟ้า', 'ภาพดาดฟ้าและสิ่งปลูกสร้างส่วนบนของอาคาร', 'https://npa.sam.or.th/site/images/npa/17036/8Z6903P18_68.jpg', '/listing-media/sam/8z6903/15.webp', 'image/webp', 21602, 450, 450, 150, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องสุขาภายในอาคาร', 'ภาพพื้นที่ห้องสุขาภายในอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/17036/8Z6903P8_68.jpg', '/listing-media/sam/8z6903/16.webp', 'image/webp', 19454, 450, 450, 160, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงบันได', 'ภาพโถงบันไดเชื่อมระหว่างชั้นภายในอาคาร', 'https://npa.sam.or.th/site/images/npa/17036/8Z6903P9_68.jpg', '/listing-media/sam/8z6903/17.webp', 'image/webp', 12386, 450, 450, 170, false, true),
        (property_listing_id, 'image', 'editorial_import', 'access', 'ทางเข้าจากถนนศรีจันทร์', 'ภาพแยกซอยศรีจันทร์ 11/5 และเส้นทางเข้าสู่ทรัพย์', 'https://npa.sam.or.th/site/images/npa/17036/8Z6903P1_64.jpg', '/listing-media/sam/8z6903/18.webp', 'image/webp', 19958, 450, 450, 180, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังแปลงติดถนนสองด้าน', 'ผังต้นทางแสดงแปลงอาคารพาณิชย์ติดถนนอนามัยและซอยศรีจันทร์ 11/5', 'https://npa.sam.or.th/site/images/npa/17036/20250804142903_8Z6903C2_64.jpg', '/listing-media/sam/8z6903/19.webp', 'image/webp', 12970, 450, 450, 190, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังตำแหน่งแปลงในกลุ่มอาคาร', 'ผังต้นทางแสดงตำแหน่งโฉนดเลขที่ 24535 ในกลุ่มอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/17036/20190715132846_8Z6903C1_62.jpg', '/listing-media/sam/8z6903/20.webp', 'image/webp', 18428, 450, 450, 200, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปทรัพย์', 'แผนที่ต้นทางแสดงเส้นทางจากถนนศรีจันทร์และถนนอนามัยไปยังทรัพย์ 8Z6903', 'https://npa.sam.or.th/site/images/npa/17036/20190715132846_8Z6903M1_62.jpg', '/listing-media/sam/8z6903/21.webp', 'image/webp', 24134, 785, 600, 210, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=17036&keyref=6004425',
        '8Z6903',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 3,518,000 for a two-storey shophouse with a mezzanine numbered 110/26 on Srichan Road, Nai Mueang, Mueang Khon Kaen. Title deed 24535 covers 24.8 sq.wah / 99.2 sq.m. The rectangular plot has dual road frontage: east on Anamai Road and west on Srichan Soi 11/5, approximately six metres on each side, with a maximum depth of approximately seventeen metres. Srichan Soi 11/5 is described as a public-utility concrete road approximately six metres wide within an approximately eight-metre right of way. The source identifies pink planning zoning and a residential-commercial neighborhood. MapxProp classifies the shophouse as mixed use for residential and business discovery, subject to verification of permitted use. Usable area, bedrooms, bathrooms, parking, age, utility specifications, occupancy and other encumbrances are not published. Property and interior photos display 24 March 2024, and one upper-floor photo shows ceiling condition that warrants inspection. Administrator coordinates are approximately 0.037 metres from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all twenty-one unique source property, interior, access, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Two-Storey Corner Shophouse with Mezzanine on Srichan Road, THB 3.518M',
        E'Shophouse 110/26 on Srichan Road, Nai Mueang, Mueang Khon Kaen. Title deed 24535 covers 24.8 sq.wah (99.2 sq.m.). SAM shows pink planning zoning and describes the surrounding area as residential and commercial.\n\nThe rectangular plot fronts two roads. Its east side fronts Anamai Road and its west side fronts Srichan Soi 11/5, with approximately six metres of frontage on each side and a maximum depth of approximately seventeen metres. SAM''s acquisition record identifies a two-storey shophouse, while its survey describes a two-storey commercial building with a mezzanine. Buyers should verify boundaries, access from both roads, building registration, approved plans, permits, storey count, mezzanine and every structure included in the transfer.\n\nSrichan Soi 11/5 is described as a public-utility concrete road approximately six metres wide within an approximately eight-metre right of way. Buyers should ask SAM, the Land Office and local authorities to confirm boundaries, public-road status, actual access and approved use.\n\nThe source does not publish usable area, bedroom or bathroom counts, parking, building age, utility specifications, occupancy or other encumbrances. MapxProp classifies the shophouse as mixed use so it can be discovered in both homes and business, with residential, retail and office use cases. This classification does not guarantee residential use or every commercial use. Buyers must verify current pink-zone planning, approved building use, parking, signage, fire escape, fire safety and licences for the intended activity.\n\nNearby places named by SAM include Khon Kaen Hospital, Khon Kaen Technical College, the Public Health Office, Khon Kaen Regional Hospital, Wat Srichan and the Bank of Thailand. SAM''s directions use Srichan Road from central Khon Kaen toward Kalasin, passing the Bank of Thailand, Wat Srichan and Kaen Nakhon Hotel. At the Anamai Road intersection, turn right and continue approximately twenty metres. The property is on the right.\n\nThe SAM page listed the property for direct purchase at an announced THB 3,518,000 when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, offer procedures, current price, promotions, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: 8Z6903. MapxProp does not collect deposits or represent SAM in the transaction.\n\nProperty and interior photos display 24 March 2024, and one photo shows ceiling condition that warrants further inspection. Conditions may have changed. Buyers should inspect the structure, roof, mezzanine, stairs, fire escape, cracks, moisture, termites, ceilings, electrical and plumbing systems, bathrooms, fire safety, possession, encumbrances, taxes, costs and every current term before deciding.',
        'Shophouse 110/26 on Srichan Road',
        'Fronting Anamai Road and Srichan Soi 11/5',
        'Srichan Road',
        'Nai Mueang',
        'Mueang Khon Kaen',
        'Khon Kaen',
        'SAM Corner Shophouse on Srichan Road, THB 3.518M',
        'Official SAM NPA asset 8Z6903: two-storey mixed-use shophouse with a mezzanine on a 99.2-sq.m. dual-frontage plot. Direct-sale price THB 3.518M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset 8Z6903 two storey mixed use corner shophouse with mezzanine 110/26 Srichan Road Anamai Road Srichan Soi 11/5 Nai Mueang Mueang Khon Kaen title deed 24535 24.8 sq.wah 99.2 sq.m. THB 3518000 dual road frontage pink zone')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=17036&keyref=6004425'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=17036&keyref=6004425',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z6903. Specifications, title deed, storeys, mezzanine, images, rounded coordinates, announced price, direct-purchase status, dual-frontage details, road description, neighborhood-use wording and planning-zone wording come from that record.',
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
        '850f8385-2829-4156-98f3-a214501e77dd',
        jsonb_build_object(
            'reference_code', '8Z6903',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'mixed',
            'discovery_channels', jsonb_build_array('homes', 'business'),
            'title_document_count', 1,
            'plot_count', 1,
            'unit_count', 1,
            'registered_floor_count', 2,
            'has_mezzanine', true,
            'dual_road_frontage_review_required', true,
            'public_road_review_required', true,
            'mixed_use_review_required', true,
            'source_image_count', 21
        )
    );
END $$;

COMMIT;
