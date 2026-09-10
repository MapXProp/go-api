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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing 8Z6901';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing 8Z6901';
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
        '9607b8fc-6b7e-4b9a-a33d-e4e66b61a4c2',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'shophouse',
        'mixed',
        'sale',
        'whole_property',
        'หมู่บ้านพรทวีวัฒน์',
        '199-201',
        'ขายตรง SAM อาคารพาณิชย์ 3 คูหา 4 ชั้นครึ่ง พรทวีวัฒน์ หนองแขม ราคา 7.839 ล้านบาท',
        E'อาคารพาณิชย์ 3 คูหา เลขที่ 199–201 ในหมู่บ้านพรทวีวัฒน์ แขวงหนองค้างพลู เขตหนองแขม กรุงเทพมหานคร ตั้งอยู่ใกล้ถนนเพชรเกษม (ทล.4) และเข้าทางซอยเพชรเกษม 73/2 ที่ดินเป็นโฉนดเลขที่ 112548, 112549 และ 112550 จำนวน 3 ฉบับ เนื้อที่รวม 48 ตร.ว. (192 ตร.ม.)

ที่ดิน 3 แปลงติดต่อกันเป็นรูปสี่เหลี่ยมผืนผ้า ด้านทิศใต้ติดถนนกว้างประมาณ 12 เมตร ลึกประมาณ 16 เมตร ถนนผ่านหน้าทรัพย์คือซอยหมู่บ้านพรทวีวัฒน์ ผิวคอนกรีตกว้างประมาณ 6 เมตร SAM ระบุให้ผู้สนใจตรวจสอบสิทธิในการใช้ทางก่อนเสนอซื้อ ผู้ซื้อควรตรวจกรรมสิทธิ์ถนน ภาระจำยอม ผู้มีสิทธิใช้ ค่าใช้จ่ายส่วนกลาง การเข้าออก และแนวเขตจริงด้วยตนเอง

รายการรับโอนกรรมสิทธิ์ของ SAM ระบุตึกแถว 4 ชั้นครึ่ง จำนวน 3 คูหา เลขที่ 199–201 ส่วนผลสำรวจสภาพระบุอาคารพาณิชย์ 4 ชั้นพร้อมชั้นลอย จำนวน 3 คูหาเจาะทะลุถึงกัน หน้า SAM ไม่ได้เผยแพร่พื้นที่ใช้สอย จำนวนห้องนอน ห้องน้ำ ที่จอดรถ อายุอาคาร หรือรายละเอียดระบบไฟฟ้าและประปา ผู้ซื้อควรให้ SAM สำนักงานเขต และสำนักงานที่ดินยืนยันจำนวนชั้น ชั้นลอย การเจาะเชื่อม แบบอาคาร ใบอนุญาต การต่อเติม การใช้อาคาร ระบบดับเพลิง และรายการที่จะโอน

หน้า SAM ระบุเขตสีเหลืองและระบุชัดว่าทรัพย์อยู่ในย่านที่อยู่อาศัยและพาณิชยกรรม MapxProp จึงจัดเป็น Mixed Use และแสดงทั้งหมวดที่อยู่อาศัยและธุรกิจ อย่างไรก็ตาม การจัดหมวดนี้ไม่ใช่การรับรองว่าสามารถพักอาศัยหรือประกอบกิจการทุกประเภทได้ ผู้ซื้อต้องตรวจผังเมืองปัจจุบัน การใช้อาคาร ป้าย ที่จอดรถ ระบบดับเพลิง และใบอนุญาตสำหรับการใช้งานที่ต้องการ

ข้อมูลที่อยู่มีประเด็นให้ตรวจสอบ: หน้า SAM แสดงตำแหน่งปัจจุบันเป็นแขวงหนองค้างพลู เขตหนองแขม แต่ระบุว่าหน้าโฉนดใช้ที่ตั้งเดิมว่า ตำบลหลักสอง อำเภอหนองแขม (ภาษีเจริญ) กรุงเทพมหานคร ผู้ซื้อต้องตรวจชื่อเขตการปกครอง เลขที่ดิน หน้าสำรวจ ระวาง และความตรงกันของโฉนดทั้ง 3 ฉบับกับตำแหน่งจริง

การเดินทางตาม SAM ใช้ถนนเพชรเกษม (ทล.4) จากบางแคมุ่งหน้านครปฐม ผ่านบิ๊กซี เอ็กซ์ตร้า เพชรเกษม 2 แล้วเลี้ยวซ้ายเข้าซอยเพชรเกษม 73/2 และเลี้ยวขวา รวมประมาณ 100 เมตร ทรัพย์อยู่ด้านขวามือ สถานที่ใกล้เคียงที่ SAM ระบุ ได้แก่ บิ๊กซี เอ็กซ์ตร้า เพชรเกษม 2 มหาวิทยาลัยเอเชียอาคเนย์ และสำนักงานที่ดินหนองแขม

หน้า SAM แสดงสถานะ “ซื้อตรง” และราคาประกาศขาย 7,839,000 บาท ไม่ใช่การประมูลในสถานะที่ตรวจสอบเมื่อวันที่ 10 กันยายน 2569 ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะการครอบครอง และวิธีจำหน่ายล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ 8Z6901 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM

ภาพภายในในหน้าต้นทางแสดงวันที่ 10 กรกฎาคม 2564 สภาพจริงอาจเปลี่ยนแปลง ผู้ซื้อควรนัดตรวจโครงสร้าง หลังคา ชั้นลอย การเจาะเชื่อม รอยร้าว ความชื้น ปลวก บันได ระบบไฟฟ้า ประปา ห้องน้ำ ระบบดับเพลิง การครอบครอง ภาระผูกพัน ภาษี ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        7839000,
        false,
        192,
        4,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'อาคารพาณิชย์เลขที่ 199–201 หมู่บ้านพรทวีวัฒน์',
        'เข้าทางซอยเพชรเกษม 73/2 ใกล้ถนนเพชรเกษม',
        'ซอยหมู่บ้านพรทวีวัฒน์',
        NULL,
        13.70676453,
        100.36615349,
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
        'sam-direct-sale-three-shophouses-phon-thawi-wat-nong-khaem-8z6901'
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
        property_listing_id, 'sale', 7839000, 'total', 'THB', false
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
            'project_name', 'หมู่บ้านพรทวีวัฒน์',
            'title_document_type', 'chanote',
            'title_deed_numbers', jsonb_build_array('112548', '112549', '112550'),
            'title_document_count', 3,
            'plot_count', 3,
            'plots_are_contiguous', true,
            'land_area_rai', 0,
            'land_area_ngan', 0,
            'land_area_square_wah_remainder', 48,
            'land_area_square_wah', 48,
            'land_area_sqm', 192,
            'unit_count', 3,
            'building_numbers', jsonb_build_array('199', '200', '201'),
            'registered_building_type_th', 'ตึกแถว',
            'registered_storeys', 4.5,
            'displayed_full_storeys', 4,
            'mezzanine_reported', true,
            'units_connected_internally', true,
            'internal_openings_require_approval_review', true,
            'usable_area_not_published', true,
            'bedroom_count_not_published', true,
            'bathroom_count_not_published', true,
            'parking_space_count_not_published', true,
            'building_age_not_published', true
        ) || jsonb_build_object(
            'plot_shape', 'rectangular',
            'south_frontage_m_approx', 12,
            'maximum_depth_m_approx', 16,
            'front_road_name', 'ซอยหมู่บ้านพรทวีวัฒน์',
            'front_road_surface', 'concrete',
            'front_road_width_m_approx', 6,
            'road_access_right_requires_buyer_verification', true,
            'zoning_color_th', 'เขตสีเหลือง ตามหน้า SAM',
            'surrounding_area_use_th', 'ย่านที่อยู่อาศัยและพาณิชยกรรม',
            'mixed_use_classification', true,
            'mixed_use_classification_basis', 'SAM ระบุว่าทรัพย์เป็นอาคารพาณิชย์และตั้งอยู่ในย่านที่อยู่อาศัยและพาณิชยกรรม',
            'intended_use_requires_independent_verification', true,
            'current_administrative_address_th', 'แขวงหนองค้างพลู เขตหนองแขม กรุงเทพมหานคร',
            'title_deed_address_text_th', 'ต.หลักสอง อ.หนองแขม (ภาษีเจริญ) กรุงเทพมหานคร',
            'title_deed_address_requires_reconciliation', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'computed_price_per_square_wah', 163312.50,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_information_date_not_published', true,
            'source_interior_photo_date_displayed', '2021-07-10',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '13.706765,100.366154',
            'administrator_coordinate_distance_from_source_m_approx', 0.08
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z6901. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนเพชรเกษม (ทล.4)', 'Phet Kasem Highway 4', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ซอยเพชรเกษม 73/2', 'Soi Phet Kasem 73/2', 'road', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'หมู่บ้านพรทวีวัฒน์', 'Phon Thawi Wat Village', 'landmark', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'บิ๊กซี เอ็กซ์ตร้า เพชรเกษม 2', 'Big C Extra Phet Kasem 2', 'shopping', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'มหาวิทยาลัยเอเชียอาคเนย์', 'Southeast Asia University', 'education', NULL, NULL, NULL, 50, true),
        (property_listing_id, 'สำนักงานที่ดินกรุงเทพมหานคร สาขาหนองแขม', 'Bangkok Metropolitan Land Office, Nong Khaem Branch', 'government', NULL, NULL, NULL, 60, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '7,839,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 7,839,000 — confirm the latest price with SAM', 'unspecified', 7839000, 'THB', 20),
        (property_listing_id, 'registered_structures', 'สิ่งปลูกสร้างตามทะเบียน', 'Registered structures', 'ตึกแถว 4 ชั้นครึ่ง จำนวน 3 คูหา เลขที่ 199–201', 'Three four-and-a-half-storey shophouses numbered 199–201', 'buyer', 3, 'units', 30),
        (property_listing_id, 'connected_units', 'การเจาะเชื่อม 3 คูหา', 'Connected units', 'ผลสำรวจระบุอาคารพาณิชย์ 4 ชั้นพร้อมชั้นลอย 3 คูหาเจาะทะลุถึงกัน ต้องตรวจแบบอาคาร การอนุญาต และโครงสร้าง', 'The survey reports three four-storey shophouses with mezzanines connected internally; verify plans, approvals and structure', 'buyer', 3, 'units', 40),
        (property_listing_id, 'access_right', 'สิทธิใช้ทาง', 'Road access right', 'ซอยหมู่บ้านพรทวีวัฒน์เป็นถนนคอนกรีตกว้างประมาณ 6 เมตร SAM ระบุให้ตรวจสิทธิในการใช้ทางก่อนเสนอซื้อ', 'Phon Thawi Wat Village Soi is an approximately six-metre concrete road; SAM instructs buyers to verify access rights before offering', 'buyer', 6, 'metres', 50),
        (property_listing_id, 'mixed_use_review', 'การใช้เพื่ออยู่อาศัยและธุรกิจ', 'Residential and business use review', 'SAM ระบุย่านที่อยู่อาศัยและพาณิชยกรรม แต่ผู้ซื้อต้องตรวจผังเมือง การใช้อาคาร ระบบดับเพลิง ที่จอดรถ ป้าย และใบอนุญาตสำหรับการใช้งานที่ต้องการ', 'SAM describes residential and commercial surroundings, but buyers must verify planning, approved building use, fire safety, parking, signage and licences', 'buyer', NULL, '', 60),
        (property_listing_id, 'address_reconciliation', 'การตรวจสอบที่อยู่ในโฉนด', 'Title address reconciliation', 'หน้า SAM แสดงแขวงหนองค้างพลู แต่หน้าโฉนดระบุ ต.หลักสอง อ.หนองแขม (ภาษีเจริญ) ต้องตรวจโฉนดทั้ง 3 ฉบับกับตำแหน่งจริง', 'SAM shows Nong Khang Phlu as the current location, while the deeds use the former Lak Song and Nong Khaem (Phasi Charoen) description; reconcile all three deeds with the actual site', 'buyer', 3, 'documents', 70),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนด รังวัด อาคาร ชั้นลอย การเจาะเชื่อม โครงสร้าง ทางเข้าออก สิทธิใช้ทาง ผังเมือง ระบบดับเพลิง ไฟฟ้า ประปา การครอบครอง ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Verify titles, survey, buildings, mezzanines, internal openings, structure, access rights, planning, fire safety, utilities, possession, encumbrances, costs and current terms', 'buyer', NULL, '', 80)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'อาคารพาณิชย์ 3 คูหา พรทวีวัฒน์', 'ภาพด้านหน้าอาคารพาณิชย์ 3 คูหา SAM รหัส 8Z6901 เลขที่ 199–201 หนองแขม', 'https://npa.sam.or.th/site/images/npa/17624/20240627143238_8Z6901P4_64.jpg', '/listing-media/sam/8z6901/01.webp', 'image/webp', 40488, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ด้านหน้าอาคารจากมุมซอย', 'ภาพด้านหน้าและด้านข้างอาคารพาณิชย์ 3 คูหาในซอยหมู่บ้านพรทวีวัฒน์', 'https://npa.sam.or.th/site/images/npa/17624/8Z6901P3_64.jpg', '/listing-media/sam/8z6901/02.webp', 'image/webp', 35354, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'หน้าร้านและประตูม้วน', 'ภาพหน้าร้านอาคารพาณิชย์ 3 คูหาพร้อมประตูม้วน', 'https://npa.sam.or.th/site/images/npa/17624/8Z6901P2_64.jpg', '/listing-media/sam/8z6901/03.webp', 'image/webp', 40988, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ชั้นล่าง', 'ภาพพื้นที่เปิดโล่งบริเวณชั้นล่างของอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/17624/8Z6901P5_64.jpg', '/listing-media/sam/8z6901/04.webp', 'image/webp', 8924, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ภายในแบบเปิดโล่ง', 'ภาพภายในอาคารพาณิชย์แสดงพื้นที่เปิดโล่งและเสาอาคาร', 'https://npa.sam.or.th/site/images/npa/17624/8Z6901P6_64.jpg', '/listing-media/sam/8z6901/05.webp', 'image/webp', 8744, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่เชื่อมระหว่างคูหา', 'ภาพภายในแสดงช่องเปิดและพื้นที่เชื่อมระหว่างอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/17624/8Z6901P7_64.jpg', '/listing-media/sam/8z6901/06.webp', 'image/webp', 11736, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ช่องเปิดภายในอาคาร', 'ภาพช่องเปิดภายในและพื้นที่ต่างระดับของอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/17624/8Z6901P8_64.jpg', '/listing-media/sam/8z6901/07.webp', 'image/webp', 8558, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บันไดและโถงชั้นบน', 'ภาพบันไดและโถงภายในอาคารพาณิชย์ SAM 8Z6901', 'https://npa.sam.or.th/site/images/npa/17624/8Z6901P9_64.jpg', '/listing-media/sam/8z6901/08.webp', 'image/webp', 11346, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องภายในชั้นบน', 'ภาพห้องภายในชั้นบนพร้อมพื้นกระเบื้องและหน้าต่าง', 'https://npa.sam.or.th/site/images/npa/17624/8Z6901P10_64.jpg', '/listing-media/sam/8z6901/09.webp', 'image/webp', 7646, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องเชื่อมภายใน', 'ภาพพื้นที่ห้องภายในที่เชื่อมต่อกันระหว่างคูหา', 'https://npa.sam.or.th/site/images/npa/17624/8Z6901P11_64.jpg', '/listing-media/sam/8z6901/10.webp', 'image/webp', 9436, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องชั้นบนรับแสงธรรมชาติ', 'ภาพห้องภายในชั้นบนพร้อมหน้าต่างด้านหน้า', 'https://npa.sam.or.th/site/images/npa/17624/8Z6901P12_64.jpg', '/listing-media/sam/8z6901/11.webp', 'image/webp', 8290, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ใช้งานภายในอาคาร', 'ภาพพื้นที่ใช้งานภายในพร้อมหน้าต่าง ประตู และส่วนกั้นห้อง', 'https://npa.sam.or.th/site/images/npa/17624/8Z6901P13_64.jpg', '/listing-media/sam/8z6901/12.webp', 'image/webp', 8824, 450, 450, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องภายในอีกชั้น', 'ภาพห้องภายในอาคารพาณิชย์อีกชั้นพร้อมหน้าต่าง', 'https://npa.sam.or.th/site/images/npa/17624/8Z6901P14_64.jpg', '/listing-media/sam/8z6901/13.webp', 'image/webp', 8736, 450, 450, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้าซอยเพชรเกษม 73/2', 'ภาพจุดเลี้ยวจากถนนเพชรเกษมเข้าสู่ซอยเพชรเกษม 73/2', 'https://npa.sam.or.th/site/images/npa/17624/8Z6901P1_64.jpg', '/listing-media/sam/8z6901/14.webp', 'image/webp', 26680, 450, 450, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังที่ดิน 3 แปลงติดต่อกัน', 'ผังต้นทางแสดงโฉนด 112548, 112549 และ 112550 รวม 48 ตารางวา', 'https://npa.sam.or.th/site/images/npa/17624/20191003172908_8Z6901C1_62.jpg', '/listing-media/sam/8z6901/15.webp', 'image/webp', 7892, 450, 450, 150, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังอาคารพาณิชย์ 3 คูหา', 'ผังต้นทางแสดงตำแหน่งอาคารพาณิชย์ 4 ชั้นพร้อมชั้นลอยทั้ง 3 คูหา', 'https://npa.sam.or.th/site/images/npa/17624/20191003172908_8Z6901C2_62.jpg', '/listing-media/sam/8z6901/16.webp', 'image/webp', 11218, 450, 450, 160, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปทรัพย์', 'แผนที่ต้นทางแสดงเส้นทางจากถนนเพชรเกษมผ่านซอยเพชรเกษม 73/2 ไปยังอาคารพาณิชย์ 8Z6901', 'https://npa.sam.or.th/site/images/npa/17624/20191003172908_8Z6901M1_62.jpg', '/listing-media/sam/8z6901/17.webp', 'image/webp', 30016, 785, 600, 170, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=17624&keyref=6004389',
        '8Z6901',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 7,839,000 for three connected shophouses numbered 199-201 in Phon Thawi Wat Village, Nong Khang Phlu, Nong Khaem, Bangkok. Three contiguous title deeds numbered 112548, 112549 and 112550 cover 48 sq.wah / 192 sq.m. The rectangular land has approximately twelve metres of southern road frontage and a depth of approximately sixteen metres. The concrete Phon Thawi Wat Village Soi is approximately six metres wide, and SAM expressly instructs buyers to verify access rights. SAM''s registered acquisition schedule lists three four-and-a-half-storey shophouses, while its survey describes three four-storey commercial buildings with mezzanines connected internally. The source shows yellow planning zoning and explicitly describes residential-commercial surroundings; MapxProp therefore classifies the listing as mixed use and includes it in both homes and business discovery. The current address is Nong Khang Phlu, Nong Khaem, while the source says the deed pages use the former Lak Song, Nong Khaem (Phasi Charoen) description. Usable area, room counts, parking, age and utility specifications are not published. Source interior photos display 10 July 2021. Administrator coordinates are approximately 0.08 metres from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all seventeen unique source property, interior, access, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Three Connected 4.5-Storey Shophouses in Nong Khaem, THB 7.839M',
        E'Three shophouses numbered 199–201 in Phon Thawi Wat Village, Nong Khang Phlu, Nong Khaem, Bangkok, near Phet Kasem Highway 4 and accessed via Soi Phet Kasem 73/2. Title deeds 112548, 112549 and 112550 cover a combined 48 sq.wah (192 sq.m.).

The three contiguous plots form a rectangle with approximately twelve metres of southern road frontage and a depth of approximately sixteen metres. The frontage is on a concrete Phon Thawi Wat Village Soi approximately six metres wide. SAM expressly tells interested buyers to verify access rights before offering. Buyers should confirm road ownership, registered servitude, eligible users, common expenses, practical access and surveyed boundaries.

SAM''s registered acquisition schedule lists three four-and-a-half-storey shophouses numbered 199–201. Its condition survey describes three four-storey commercial buildings with mezzanines and internal openings connecting the units. The source does not publish usable area, bedroom or bathroom counts, parking, building age, or electrical and plumbing specifications. Buyers should ask SAM, the district office and the Land Office to verify storeys, mezzanines, structural openings, plans, permits, alterations, approved building use, fire safety and everything included in transfer.

SAM shows yellow planning zoning and explicitly describes residential and commercial surroundings. MapxProp therefore classifies the property as mixed use and includes it in both homes and business discovery. This classification does not guarantee residential or commercial use of every floor or every business type. Buyers must confirm current planning, approved building use, signage, parking, fire safety and licences for the intended use.

The source contains an address issue requiring review. Its current location is Nong Khang Phlu, Nong Khaem, while SAM states that the deed pages use the former description Tambon Lak Song, Amphoe Nong Khaem (Phasi Charoen), Bangkok. Buyers must reconcile administrative names, land parcel numbers, survey sheets and all three deeds with the actual site.

SAM''s directions use Phet Kasem Highway 4 from Bang Khae toward Nakhon Pathom, passing Big C Extra Phet Kasem 2, then turning left into Soi Phet Kasem 73/2 and right for a combined distance of approximately 100 metres. The property is on the right. Nearby places named by SAM include Big C Extra Phet Kasem 2, Southeast Asia University and the Nong Khaem Land Office.

The SAM page listed the property for direct purchase at an announced THB 7,839,000 when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, offer procedures, current price, promotions, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: 8Z6901. MapxProp does not collect deposits or represent SAM in the transaction.

Source interior photos display 10 July 2021, and conditions may have changed. Buyers should inspect the structure, roofs, mezzanines, internal openings, cracks, moisture, termites, stairs, electrical and plumbing systems, bathrooms, fire safety, possession, encumbrances, taxes, costs and every current term before deciding.',
        'Shophouses 199–201 in Phon Thawi Wat Village',
        'Access via Soi Phet Kasem 73/2 near Phet Kasem Highway 4',
        'Phon Thawi Wat Village Soi',
        'Nong Khang Phlu',
        'Nong Khaem',
        'Bangkok',
        'SAM Three Connected Shophouses in Nong Khaem, THB 7.839M',
        'Official SAM NPA asset 8Z6901: three connected four-and-a-half-storey mixed-use shophouses on 192 sq.m. in Nong Khaem. Direct-sale price THB 7.839M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset 8Z6901 three connected four and a half storey mixed use shophouses 199 200 201 Phon Thawi Wat Village Nong Khang Phlu Nong Khaem Bangkok Phet Kasem 73/2 Highway 4 title deeds 112548 112549 112550 48 sq.wah 192 sq.m. THB 7839000 access right mezzanine')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=17624&keyref=6004389'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=17624&keyref=6004389',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z6901. Specifications, title deeds, registered and surveyed storeys, connected-unit condition, images, rounded coordinates, announced price, direct-purchase status, access-right caveat, address discrepancy, road measurement, planning-zone wording and residential-commercial context come from that record.',
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
        '9607b8fc-6b7e-4b9a-a33d-e4e66b61a4c2',
        jsonb_build_object(
            'reference_code', '8Z6901',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'mixed',
            'discovery_channels', jsonb_build_array('homes', 'business'),
            'title_document_count', 3,
            'unit_count', 3,
            'registered_storeys', 4.5,
            'connected_units_review_required', true,
            'access_right_review_required', true,
            'title_address_review_required', true,
            'source_image_count', 17
        )
    );
END $$;

COMMIT;
