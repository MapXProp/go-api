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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing 8Z2541';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing 8Z2541';
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
        '5bc201b0-c117-4c1d-8e25-031329b3e2e4',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'shophouse',
        'mixed',
        'sale',
        'whole_property',
        '151-153',
        'ขายตรง SAM อาคารพาณิชย์ 3 คูหา 4 ชั้นมีชั้นลอย ติดถนนเพชรเกษม หนองแขม 85.1 ตร.ว. ราคา 13.413 ล้านบาท',
        E'อาคารพาณิชย์ 3 คูหา เลขที่ 151, 152 และ 153 ถนนเพชรเกษม แขวงหนองค้างพลู เขตหนองแขม กรุงเทพมหานคร บนโฉนดที่ดินเลขที่ 112544, 112596 และ 112597 จำนวน 3 ฉบับ เนื้อที่รวม 85.1 ตร.ว. (340.4 ตร.ม.)

รายการรับโอนกรรมสิทธิ์ของ SAM ระบุอาคารเลขที่ 151 เป็นตึกแถว 4 ชั้นบนโฉนดเลขที่ 112544 อาคารเลขที่ 152 เป็นตึกแถว 4 ชั้นครึ่งบนโฉนดเลขที่ 112597 และอาคารเลขที่ 153 เป็นตึกแถว 4 ชั้นครึ่งบนโฉนดเลขที่ 112596 ขณะที่ข้อมูลสำรวจสภาพระบุว่าเป็นอาคารพาณิชย์ 4 ชั้น มีชั้นลอยทั้ง 3 คูหา เจาะทะลุถึงกัน และใช้บันไดขึ้นลงเดียวกัน ผู้ซื้อต้องให้ SAM สำนักงานเขต และสำนักงานที่ดินยืนยันจำนวนชั้น ชั้นลอย แบบแปลน ใบอนุญาต การเจาะเชื่อม โครงสร้าง ทางหนีไฟ และรายการสิ่งปลูกสร้างที่จะโอน

หน้า SAM ไม่ได้เผยแพร่พื้นที่ใช้สอย จำนวนห้องนอน ห้องน้ำ ที่จอดรถ อายุอาคาร ระบบไฟฟ้า-ประปา หรือสถานะผู้ใช้ประโยชน์ การแยกใช้งานหรือแยกขายแต่ละคูหาอาจมีข้อจำกัดเพราะอาคารเชื่อมถึงกันและใช้บันไดร่วม ผู้ซื้อควรตรวจสภาพจริง ความปลอดภัย ระบบดับเพลิง ทางเข้าออก และความสามารถในการใช้งานตามวัตถุประสงค์ก่อนเสนอซื้อ

ที่ดิน 3 แปลงติดต่อกัน เป็นรูปคล้ายสี่เหลี่ยมคางหมูและติดถนน 2 ด้าน ด้านทิศเหนือกว้างประมาณ 6 เมตร ด้านทิศใต้กว้างประมาณ 14 เมตร และลึกสุดประมาณ 30 เมตร ถนนเพชรเกษม (ทล.4) เป็นทางหลวงแผ่นดิน ผิวจราจรลาดยางกว้างประมาณ 18 เมตร เขตทางกว้างประมาณ 50 เมตร ถนนอีกด้านไม่ได้ระบุชื่อไว้ในรายละเอียดต้นทาง ผู้ซื้อต้องตรวจแนวเขตและทางเข้าออกจริง

หน้า SAM ระบุเขตสีเหลืองและระบุว่าทรัพย์อยู่ในย่านที่อยู่อาศัยและพาณิชยกรรม อาคารประเภทนี้จึงจัดเป็น Mixed Use บน MapxProp ให้ค้นได้ทั้งหมวดที่อยู่อาศัยและธุรกิจ เหมาะสำหรับพิจารณาใช้เป็นที่พักอาศัย หน้าร้าน หรือสำนักงาน ทั้งนี้ต้องตรวจผังเมือง กฎหมายอาคาร ข้อกำหนดการใช้ประโยชน์ ที่จอดรถ ป้าย ทางเข้าออก และใบอนุญาตกิจการกับหน่วยงานที่เกี่ยวข้องเอง

สถานที่ใกล้เคียงที่ SAM ระบุ ได้แก่ บิ๊กซี โฮมโปร โรงพยาบาลวิชัยเวช อินเตอร์เนชั่นแนล หนองแขม มหาวิทยาลัยเอเชียอาคเนย์ และสำนักงานที่ดินกรุงเทพมหานคร สาขาหนองแขม การเดินทางจากบางแคมุ่งหน้านครปฐมบนถนนเพชรเกษม ผ่านแยกเพชรเกษม 69 ถึงซอยเพชรเกษม 73 แล้วตรงไปประมาณ 15 เมตร ทรัพย์อยู่ด้านซ้ายมือ

มีความต่างของชื่อพื้นที่ที่ควรตรวจสอบ: หน้ารายละเอียดปัจจุบันแสดงแขวงหนองค้างพลู เขตหนองแขม แต่ SAM ระบุว่าที่ตั้งตามหน้าเอกสารสิทธิ์เป็นตำบลหลักสอง อำเภอหนองแขม ผู้ซื้อต้องยืนยันที่ตั้งตามโฉนด เลขที่ดิน หน้าสำรวจ และเขตการปกครองปัจจุบันกับสำนักงานที่ดิน

หน้า SAM แสดงสถานะ “ซื้อตรง” และราคาประกาศขาย 13,413,000 บาท ไม่ใช่การประมูลในสถานะที่ตรวจสอบเมื่อวันที่ 10 กันยายน 2569 ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะการครอบครอง และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ 8Z2541 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM

ภาพสภาพทรัพย์ในหน้าต้นทางแสดงวันที่ 15 กุมภาพันธ์ 2566 สภาพจริงอาจเปลี่ยนแปลง ผู้ซื้อควรนัดตรวจโครงสร้าง รอยร้าว ความชื้น ปลวก ระบบไฟฟ้า-ประปา ห้องน้ำ บันได ทางหนีไฟ ระบบดับเพลิง ทางเข้าออก การครอบครอง ภาระผูกพัน ภาษี ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        13413000,
        false,
        340.4,
        4,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        '151-153 ถนนเพชรเกษม แขวงหนองค้างพลู',
        'ใกล้ซอยเพชรเกษม 73 เขตหนองแขม',
        'ถนนเพชรเกษม (ทล.4)',
        NULL,
        13.70719248,
        100.36811427,
        'กรุงเทพมหานคร',
        'หนองแขม',
        'หนองค้างพลู',
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
        'sam-direct-sale-three-connected-shophouses-phetkasem-nong-khaem-8z2541'
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
        property_listing_id, 'sale', 13413000, 'total', 'THB', false
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
            'listed_unit_numbers', jsonb_build_array('151', '152', '153'),
            'unit_count', 3,
            'title_document_type', 'chanote',
            'title_deed_numbers', jsonb_build_array('112544', '112596', '112597'),
            'title_document_count', 3,
            'land_area_square_wah', 85.1,
            'land_area_sqm', 340.4,
            'plots_contiguous', true,
            'plot_count', 3,
            'plot_shape', 'trapezoid_like',
            'road_frontage_side_count', 2,
            'north_side_width_m', 6,
            'south_side_width_m', 14,
            'maximum_depth_m', 30,
            'registered_unit_151_description', 'ตึกแถว 4 ชั้น เลขที่ 151 บนโฉนดที่ดินเลขที่ 112544',
            'registered_unit_152_description', 'ตึกแถว 4 ชั้นครึ่ง เลขที่ 152 บนโฉนดที่ดินเลขที่ 112597',
            'registered_unit_153_description', 'ตึกแถว 4 ชั้นครึ่ง เลขที่ 153 บนโฉนดที่ดินเลขที่ 112596',
            'surveyed_structure_description', 'อาคารพาณิชย์ 4 ชั้น มีชั้นลอยทั้ง 3 คูหา',
            'surveyed_floor_count', 4,
            'mezzanine_present_all_units', true,
            'units_internally_connected', true,
            'shared_single_staircase', true,
            'floor_and_mezzanine_details_require_verification', true,
            'usable_area_not_published', true,
            'bedroom_count_not_published', true,
            'bathroom_count_not_published', true
        ) || jsonb_build_object(
            'parking_information_not_published', true,
            'building_age_not_published', true,
            'occupancy_status_not_published', true,
            'front_road_name', 'ถนนเพชรเกษม (ทล.4)',
            'front_road_legal_status_th', 'ทางหลวงแผ่นดิน',
            'front_road_surface', 'asphalt',
            'front_road_width_m', 18,
            'front_right_of_way_width_m', 50,
            'second_frontage_road_name_not_published', true,
            'zoning_color_th', 'เขตสีเหลือง ตามหน้า SAM',
            'surrounding_area_use_th', 'ย่านที่อยู่อาศัยและพาณิชยกรรม',
            'mixed_use_classification', true,
            'mixed_use_basis', 'SAM ระบุประเภททรัพย์เป็นอาคารพาณิชย์ 3 คูหาและระบุว่าสภาพแวดล้อมเป็นย่านที่อยู่อาศัยและพาณิชยกรรม',
            'business_use_requires_independent_verification', true,
            'title_location_th', 'ตำบลหลักสอง อำเภอหนองแขม',
            'current_page_location_th', 'แขวงหนองค้างพลู เขตหนองแขม',
            'location_name_discrepancy_requires_verification', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'computed_price_per_square_wah', 157614.57,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_information_date_not_published', true,
            'source_property_photo_date_displayed', '2023-02-15',
            'source_promotional_video_url', 'https://youtube.com/shorts/PBHyKOuFgnc?feature=share',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '13.707168,100.368119',
            'administrator_coordinate_distance_from_source_m_approx', 2.77
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z2541. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'บิ๊กซี', 'Big C', 'shopping', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'โฮมโปร', 'HomePro', 'shopping', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'โรงพยาบาลวิชัยเวช อินเตอร์เนชั่นแนล หนองแขม', 'Vichaivej International Hospital Nong Khaem', 'healthcare', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'มหาวิทยาลัยเอเชียอาคเนย์', 'Southeast Asia University', 'education', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'สำนักงานที่ดินกรุงเทพมหานคร สาขาหนองแขม', 'Bangkok Land Office, Nong Khaem Branch', 'government', NULL, NULL, NULL, 50, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '13,413,000 บาท — โปรดตรวจสอบราคาล่าสุดและโปรโมชั่นกับ SAM', 'THB 13,413,000 — confirm the latest price and promotions with SAM', 'unspecified', 13413000, 'THB', 20),
        (property_listing_id, 'connected_units', 'สภาพการเชื่อมต่อ 3 คูหา', 'Three connected units', 'ข้อมูลสำรวจระบุว่าทั้ง 3 คูหาเจาะทะลุถึงกัน มีชั้นลอย และใช้บันไดขึ้นลงเดียวกัน', 'The survey says all three units are internally connected, have mezzanines and share one staircase', 'unspecified', 3, 'units', 30),
        (property_listing_id, 'building_record_review', 'ตรวจทะเบียนและจำนวนชั้น', 'Building-record review', 'รายการรับโอนระบุ 4 ชั้นและ 4 ชั้นครึ่ง แต่ข้อมูลสำรวจระบุ 4 ชั้นมีชั้นลอย ต้องตรวจแบบแปลน ใบอนุญาต และรายการที่จะโอน', 'Acquisition records state four and four-and-a-half storeys while the survey states four storeys with mezzanines; verify plans, permits and transfer scope', 'buyer', NULL, '', 40),
        (property_listing_id, 'title_location_review', 'ตรวจชื่อพื้นที่ตามเอกสารสิทธิ์', 'Title location review', 'หน้าปัจจุบันระบุแขวงหนองค้างพลู แต่หน้าเอกสารสิทธิ์ระบุตำบลหลักสอง ต้องยืนยันโฉนดและเขตการปกครอง', 'The current page states Nong Khang Phlu while the title page states Lak Song; verify title and administrative location', 'buyer', NULL, '', 50),
        (property_listing_id, 'mixed_use_review', 'การใช้งานแบบผสม', 'Mixed-use review', 'จัดเป็นอาศัยและธุรกิจจากประเภทอาคารพาณิชย์และข้อความย่านที่อยู่อาศัยและพาณิชยกรรม แต่ต้องตรวจผังเมือง อาคาร ที่จอดรถ ป้ายและใบอนุญาตกิจการ', 'Classified for residential and business discovery based on the shophouse type and residential-commercial surroundings; verify planning, building, parking, signage and licences', 'buyer', NULL, '', 60),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนด แนวเขต อาคารเชื่อม บันได ทางหนีไฟ โครงสร้าง ระบบไฟฟ้า-ประปา ทางเข้าออก การครอบครอง ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Verify titles, boundaries, connected structures, stairs, fire escape, structure, utilities, access, possession, encumbrances, costs and current terms', 'buyer', NULL, '', 70)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'อาคารพาณิชย์ 3 คูหาติดถนนเพชรเกษม', 'ด้านหน้าอาคารพาณิชย์ SAM รหัส 8Z2541 จำนวน 3 คูหาติดถนนเพชรเกษม', 'https://npa.sam.or.th/site/images/npa/9704/20260106101750_8Z2541P2_66.jpg', '/listing-media/sam/8z2541/01.webp', 'image/webp', 35872, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวอาคารจากถนนเพชรเกษม', 'ภาพแนวอาคารพาณิชย์ 3 คูหาและทางเท้าริมถนนเพชรเกษม', 'https://npa.sam.or.th/site/images/npa/9704/8Z2541P1_65.JPG', '/listing-media/sam/8z2541/02.webp', 'image/webp', 26608, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ชั้นล่างภายในอาคาร', 'ภาพโถงชั้นล่างภายในอาคารพาณิชย์ที่เจาะเชื่อมถึงกัน', 'https://npa.sam.or.th/site/images/npa/9704/8Z2541P4_66.jpg', '/listing-media/sam/8z2541/03.webp', 'image/webp', 21718, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงและประตูภายใน', 'ภาพสภาพโถง ทางเดิน และประตูภายในอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/9704/8Z2541P5_66.jpg', '/listing-media/sam/8z2541/04.webp', 'image/webp', 13018, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องภายในคูหา', 'ภาพห้องภายในอาคารพาณิชย์ SAM 8Z2541', 'https://npa.sam.or.th/site/images/npa/9704/8Z2541P6_66.jpg', '/listing-media/sam/8z2541/05.webp', 'image/webp', 12004, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องและช่องแสงภายใน', 'ภาพห้องภายในพร้อมช่องแสงและสภาพพื้นผิวอาคาร', 'https://npa.sam.or.th/site/images/npa/9704/8Z2541P7_66.jpg', '/listing-media/sam/8z2541/06.webp', 'image/webp', 12628, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเดินภายในอาคาร', 'ภาพทางเดินแคบภายในอาคารพาณิชย์ที่เชื่อมหลายคูหา', 'https://npa.sam.or.th/site/images/npa/9704/8Z2541P8_66.jpg', '/listing-media/sam/8z2541/07.webp', 'image/webp', 14068, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องริมระเบียง', 'ภาพห้องภายในติดช่องเปิดและระเบียงของอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/9704/8Z2541P9_66.jpg', '/listing-media/sam/8z2541/08.webp', 'image/webp', 16158, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องภายในอีกคูหา', 'ภาพสภาพห้องภายในอีกส่วนของอาคารพาณิชย์ 3 คูหา', 'https://npa.sam.or.th/site/images/npa/9704/8Z2541P10_66.jpg', '/listing-media/sam/8z2541/09.webp', 'image/webp', 12498, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องรับแสงธรรมชาติ', 'ภาพห้องภายในที่มีประตูและหน้าต่างรับแสงธรรมชาติ', 'https://npa.sam.or.th/site/images/npa/9704/8Z2541P11_66.jpg', '/listing-media/sam/8z2541/10.webp', 'image/webp', 12342, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเชื่อมระหว่างห้อง', 'ภาพช่องทางเชื่อมและผนังภายในอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/9704/8Z2541P12_66.jpg', '/listing-media/sam/8z2541/11.webp', 'image/webp', 12298, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงทางเดินร่วม', 'ภาพโถงทางเดินร่วมภายในอาคารพาณิชย์ 3 คูหา', 'https://npa.sam.or.th/site/images/npa/9704/8Z2541P13_66.jpg', '/listing-media/sam/8z2541/12.webp', 'image/webp', 14024, 450, 450, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ตกแต่งภายใน', 'ภาพพื้นที่ภายในที่มีเคาน์เตอร์และผนังกรุวัสดุเดิม', 'https://npa.sam.or.th/site/images/npa/9704/8Z2541P14_66.jpg', '/listing-media/sam/8z2541/13.webp', 'image/webp', 18676, 450, 450, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำภายในอาคาร', 'ภาพสภาพห้องน้ำภายในอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/9704/8Z2541P15_66.jpg', '/listing-media/sam/8z2541/14.webp', 'image/webp', 19594, 450, 450, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'อ่างล้างหน้าและห้องน้ำ', 'ภาพอ่างล้างหน้าและพื้นที่ห้องน้ำภายในอาคาร', 'https://npa.sam.or.th/site/images/npa/9704/8Z2541P16_66.jpg', '/listing-media/sam/8z2541/15.webp', 'image/webp', 27686, 450, 450, 150, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังแปลงที่ดินติดถนน 2 ด้าน', 'ผังต้นทางแสดงที่ดิน 3 แปลงติดต่อกัน รูปคล้ายสี่เหลี่ยมคางหมูและแนวถนนสองด้าน', 'https://npa.sam.or.th/site/images/npa/9704/20170822133702_8Z2541C1_60.jpg', '/listing-media/sam/8z2541/16.webp', 'image/webp', 15832, 450, 450, 160, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังตำแหน่งอาคารเลขที่ 151-153', 'ผังต้นทางแสดงอาคารพาณิชย์เลขที่ 151, 152 และ 153 บนโฉนดทั้ง 3 แปลง', 'https://npa.sam.or.th/site/images/npa/9704/20170822133702_8Z2541C2_60.jpg', '/listing-media/sam/8z2541/17.webp', 'image/webp', 12944, 450, 450, 170, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปทรัพย์', 'แผนที่ต้นทางแสดงเส้นทางถนนเพชรเกษมไปอาคารพาณิชย์ SAM 8Z2541 เขตหนองแขม', 'https://npa.sam.or.th/site/images/npa/9704/20170914163539_8Z2541M1_60.jpg', '/listing-media/sam/8z2541/18.webp', 'image/webp', 26454, 785, 600, 180, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=9704&keyref=6004388',
        '8Z2541',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 13,413,000 for three contiguous shophouse plots at 151-153 Phet Kasem Road, Nong Khang Phlu, Nong Khaem, Bangkok. Title deeds 112544, 112596 and 112597 cover 85.1 sq.wah / 340.4 sq.m. SAM acquisition records identify unit 151 as four storeys and units 152-153 as four and a half storeys, while the physical survey describes all three units as four-storey commercial buildings with mezzanines, internally connected and sharing a single staircase. Usable area, bedrooms, bathrooms, parking, age, utilities and occupancy are not published. The trapezoid-like land fronts roads on two sides, with approximately six metres on the north, fourteen metres on the south and a maximum depth of thirty metres. Phet Kasem Highway 4 is described as an eighteen-metre asphalt national highway within a fifty-metre right of way. SAM shows yellow zoning and residential-commercial surroundings, so MapxProp classifies the shophouses as mixed use and lists them in both homes and business discovery. The current page states Nong Khang Phlu while SAM says the title page states Lak Song; buyers must verify the title location. Source property photos display 15 February 2023. Administrator coordinates are approximately 2.77 metres from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all eighteen unique source property, interior, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Three Connected Shophouses on Phet Kasem Road, THB 13.413M',
        E'Three shophouse units numbered 151, 152 and 153 on Phet Kasem Road, Nong Khang Phlu, Nong Khaem, Bangkok. The property comprises title deeds 112544, 112596 and 112597 with a combined land area of 85.1 sq.wah (340.4 sq.m.).

SAM''s acquisition records identify unit 151 as a four-storey shophouse on title deed 112544, unit 152 as a four-and-a-half-storey shophouse on title deed 112597, and unit 153 as a four-and-a-half-storey shophouse on title deed 112596. The physical survey instead describes all three as four-storey commercial buildings with mezzanines. The three units are internally connected and use one shared staircase. Buyers must ask SAM, the district office and the Land Office to verify storey and mezzanine counts, plans, permits, structural alterations, fire escape, safety and every structure included in the transfer.

The source does not publish usable area, bedroom or bathroom counts, parking, building age, electrical or plumbing specifications, or occupancy. Independent use or separation of the three units may be constrained by their internal connections and shared staircase. Buyers should inspect the condition, structure, fire safety, utilities and practical suitability before offering.

The three land plots are contiguous, trapezoid-like and front roads on two sides. The northern side is approximately six metres wide, the southern side approximately fourteen metres wide and the maximum depth approximately thirty metres. Phet Kasem Highway 4 is a national highway with an approximately eighteen-metre asphalt carriageway in an approximately fifty-metre right of way. The source does not name the second frontage road, so boundaries and actual access must be verified.

SAM shows yellow planning zoning and describes the surroundings as residential and commercial. MapxProp therefore classifies the shophouses as mixed use and lists them in both homes and business discovery. Potential residential, retail or office use remains subject to current planning, building control, parking, signage, access and business-licence requirements.

Nearby places listed by SAM include Big C, HomePro, Vichaivej International Hospital Nong Khaem, Southeast Asia University and the Bangkok Land Office Nong Khaem Branch. From Bang Khae, travel toward Nakhon Pathom on Phet Kasem Road, pass Phet Kasem 69 intersection and Soi Phet Kasem 73, then continue about fifteen metres; the property is on the left.

There is a location-name discrepancy to verify: the current detail page states Nong Khang Phlu, Nong Khaem, while SAM says the title page states Lak Song, Nong Khaem. Buyers should confirm the title deed, land parcel, survey page and current administrative area with the Land Office.

The SAM page listed the property for direct purchase at an announced THB 13,413,000 when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, the current sale method, offer procedures, price, promotions, costs, occupancy and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: 8Z2541. MapxProp does not collect deposits or represent SAM in the transaction.

Source property photos display 15 February 2023, and conditions may have changed. Buyers should inspect structure, cracks, moisture, termites, electrical and plumbing systems, bathrooms, stairs, fire escape, fire protection, access, possession, encumbrances, taxes, costs and every current term before deciding.',
        '151-153 Phet Kasem Road, Nong Khang Phlu',
        'Near Soi Phet Kasem 73, Nong Khaem',
        'Phet Kasem Road, Highway 4',
        'Nong Khang Phlu',
        'Nong Khaem',
        'Bangkok',
        'SAM Three Connected Shophouses, Phet Kasem Road, THB 13.413M',
        'Official SAM NPA asset 8Z2541: three connected four-storey shophouses with mezzanines on 340.4 sq.m. Mixed-use direct sale at THB 13.413M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset 8Z2541 three connected shophouses commercial buildings 151 152 153 Phet Kasem Road Highway 4 Nong Khang Phlu Nong Khaem Bangkok 85.1 sq.wah 340.4 sq.m. title deeds 112544 112596 112597 four storey mezzanine mixed use THB 13413000')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=9704&keyref=6004388'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=9704&keyref=6004388',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z2541. Specifications, title deeds, registered structures, surveyed condition, images, rounded coordinates, announced price, direct-purchase status, road measurements, planning-zone wording and location discrepancy come from that record.',
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
        '5bc201b0-c117-4c1d-8e25-031329b3e2e4',
        jsonb_build_object(
            'reference_code', '8Z2541',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'mixed',
            'discovery_channels', jsonb_build_array('business', 'homes'),
            'title_document_count', 3,
            'unit_count', 3,
            'units_internally_connected', true,
            'shared_single_staircase', true,
            'building_record_review_required', true,
            'location_review_required', true,
            'source_image_count', 18
        )
    );
END $$;

COMMIT;
