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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing 8Z6125';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing 8Z6125';
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
        '61535fd7-6c3d-4e28-8ff4-b65936371d02',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'townhouse',
        'residential',
        'sale',
        'whole_property',
        'ภิรมย์สุข',
        '99/205',
        'ขายตรง SAM ทาวน์โฮม 4 ชั้น หมู่บ้านภิรมย์สุข ลาดพร้าววังหิน 21.6 ตร.ว. 6 ห้องนอน ราคา 4.086 ล้านบาท',
        E'ทาวน์โฮม 4 ชั้น เลขที่ 99/205 ในหมู่บ้านภิรมย์สุข ถนนลาดพร้าววังหิน แขวงลาดพร้าว เขตลาดพร้าว กรุงเทพมหานคร มี 6 ห้องนอน 5 ห้องน้ำ บนที่ดิน 21.6 ตร.ว. (86.4 ตร.ม.) โฉนดที่ดินเลขที่ 11209 จำนวน 1 ฉบับ อยู่ในเขตผังเมืองสีเหลืองตามหน้า SAM\n\nที่ดินเป็นรูปสี่เหลี่ยมผืนผ้า ด้านทิศตะวันตกติดถนน หน้ากว้างประมาณ 6 เมตร และลึกประมาณ 14.4 เมตร รายการรับโอนกรรมสิทธิ์ของ SAM ระบุสิ่งปลูกสร้างเป็นตึกแถว 4 ชั้น เลขที่ 99/205 ส่วนข้อมูลสำรวจสภาพระบุว่ามีลักษณะเป็นทาวน์โฮม 4 ชั้น แบ่งภายในเป็น 6 ห้องนอน 5 ห้องน้ำ MapxProp จึงจัดหมวดตามประเภททรัพย์และสภาพสำรวจของ SAM เป็นทาวน์โฮมสำหรับอยู่อาศัย ผู้ซื้อควรตรวจทะเบียนอาคาร แบบแปลน การใช้ประโยชน์ และสิ่งปลูกสร้างที่จะได้รับโอนให้ตรงกับสภาพจริง\n\nถนนผ่านหน้าทรัพย์เป็นถนนภายในโครงการหมู่บ้านภิรมย์สุข ซึ่ง SAM ระบุว่าเป็นทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว ผิวจราจรคอนกรีตกว้างประมาณ 6 เมตร และเขตทางกว้างประมาณ 9 เมตร SAM ระบุว่าทรัพย์อยู่ในย่านที่อยู่อาศัย การคมนาคมสะดวก ใกล้โรงเรียนวัดลาดพร้าว วัดลาดพร้าว โรงพยาบาลเปาโล โชคชัย 4 และสถานีตำรวจนครบาลโชคชัย 4\n\nการเดินทางตาม SAM ใช้ถนนลาดพร้าวจากแยกรัชดาภิเษกมุ่งหน้าบางกะปิ ผ่านคลองลาดพร้าว ตลาดสะพานสอง และสถานีตำรวจนครบาลโชคชัย 4 ถึงแยกโชคชัย 4 เลี้ยวซ้ายเข้าถนนโชคชัย 4 ประมาณ 1.1 กม. แล้วเลี้ยวซ้ายเข้าถนนลาดพร้าววังหินประมาณ 400 เมตร ก่อนเลี้ยวซ้ายเข้าซอยลาดพร้าววังหิน 11 และหมู่บ้านภิรมย์สุข รวมประมาณ 110 เมตร ทรัพย์อยู่ด้านซ้ายมือ\n\nหน้า SAM แสดงสถานะ “ซื้อตรง” และราคาประกาศขาย 4,086,000 บาท ณ วันที่ตรวจสอบ 10 กันยายน 2569 ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะการครอบครอง และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ 8Z6125 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nหน้าต้นทางไม่เผยแพร่พื้นที่ใช้สอย ที่จอดรถ อายุอาคาร ระบบไฟฟ้า-ประปา สถานะการครอบครอง หรือภาระผูกพันอื่น ภาพหน้าทรัพย์และภาพภายในแสดงวันที่ 14 เมษายน 2568 สภาพจริงอาจเปลี่ยนแปลง ผู้ซื้อควรนัดตรวจทั้ง 4 ชั้น ตรวจสภาพโครงสร้าง หลังคา ระเบียง บันได ห้องน้ำ ระบบไฟฟ้าและประปา รอยร้าว ความชื้น ปลวก แนวเขต กฎโครงการ การครอบครอง ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        4086000,
        false,
        86.4,
        6,
        5,
        4,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        '99/205 หมู่บ้านภิรมย์สุข',
        'เข้าจากซอยลาดพร้าววังหิน 11 ประมาณ 110 เมตร',
        'ลาดพร้าววังหิน',
        NULL,
        13.802519795851591,
        100.59291865576269,
        'กรุงเทพมหานคร',
        'ลาดพร้าว',
        'ลาดพร้าว',
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
        'sam-direct-sale-four-storey-townhouse-phirom-suk-lat-phrao-wang-hin-8z6125'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 4086000, 'total', 'THB', false
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
        'townhouse',
        1,
        jsonb_build_object(
            'source_property_category', 'ทาวน์เฮ้าส์',
            'project_name', 'ภิรมย์สุข',
            'listed_unit_number', '99/205',
            'title_document_type', 'chanote',
            'title_deed_number', '11209',
            'title_document_count', 1,
            'land_area_square_wah', 21.6,
            'land_area_sqm', 86.4,
            'floor_count', 4,
            'bedroom_count', 6,
            'bathroom_count', 5,
            'unit_count', 1,
            'plot_shape', 'rectangle',
            'west_road_frontage_m', 6,
            'maximum_depth_m', 14.4,
            'registered_transfer_description', 'ตึกแถว 4 ชั้น เลขที่ 99/205',
            'surveyed_property_description', 'ทาวน์โฮม 4 ชั้น แบ่งใช้ประโยชน์ภายในเป็น 6 ห้องนอน 5 ห้องน้ำ',
            'registered_address_number', '99/205',
            'usable_area_not_published', true,
            'parking_information_not_published', true,
            'building_age_not_published', true
        ) || jsonb_build_object(
            'access_type', 'authorized_land_allocation_project_road',
            'front_road_name', 'ถนนภายในโครงการหมู่บ้านภิรมย์สุข',
            'front_road_surface', 'concrete',
            'front_road_width_m', 6,
            'front_right_of_way_width_m', 9,
            'main_access_road', 'ถนนลาดพร้าววังหิน',
            'access_soi', 'ซอยลาดพร้าววังหิน 11',
            'distance_inside_soi_and_project_m_approx', 110,
            'zoning_color_th', 'สีเหลือง ตามหน้า SAM',
            'surrounding_area_use_th', 'ที่อยู่อาศัย',
            'source_states_convenient_transportation', true,
            'occupancy_status_not_published', true,
            'utilities_information_not_published', true,
            'other_encumbrances_not_published', true,
            'source_information_date_not_published', true,
            'source_property_photo_date_displayed', '2025-04-14',
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'computed_price_per_square_wah', 189166.67,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '13.80252,100.59292',
            'administrator_coordinate_distance_from_source_m_approx', 0.15
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z6125. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนลาดพร้าว', 'Lat Phrao Road', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ถนนโชคชัย 4', 'Chok Chai 4 Road', 'road', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'ถนนลาดพร้าววังหิน', 'Lat Phrao Wang Hin Road', 'road', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'โรงเรียนวัดลาดพร้าว', 'Wat Lat Phrao School', 'education', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'วัดลาดพร้าว', 'Wat Lat Phrao', 'landmark', NULL, NULL, NULL, 50, true),
        (property_listing_id, 'โรงพยาบาลเปาโล โชคชัย 4', 'Paolo Hospital Chokchai 4', 'healthcare', NULL, NULL, NULL, 60, true),
        (property_listing_id, 'สถานีตำรวจนครบาลโชคชัย 4', 'Chok Chai 4 Metropolitan Police Station', 'government', NULL, NULL, NULL, 70, true),
        (property_listing_id, 'ตลาดสะพานสอง', 'Saphan Song Market', 'shopping', NULL, NULL, NULL, 80, false),
        (property_listing_id, 'โรงเรียนฤทธิไกรศึกษา', 'Rittikrai Suksa School', 'education', NULL, NULL, NULL, 90, false)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '4,086,000 บาท — โปรดตรวจสอบราคาล่าสุดและโปรโมชั่นกับ SAM', 'THB 4,086,000 — confirm the latest price and promotions with SAM', 'unspecified', 4086000, 'THB', 20),
        (property_listing_id, 'registered_structure', 'สิ่งปลูกสร้างตามรายการรับโอน', 'Structure in acquisition records', 'รายการรับโอนของ SAM ระบุตึกแถว 4 ชั้น เลขที่ 99/205 ส่วนการสำรวจสภาพระบุทาวน์โฮม 4 ชั้น 6 ห้องนอน 5 ห้องน้ำ', 'SAM''s acquisition record identifies a four-storey row building numbered 99/205, while the condition survey describes a four-storey townhouse with six bedrooms and five bathrooms', 'unspecified', NULL, '', 30),
        (property_listing_id, 'project_road', 'ถนนหน้าทรัพย์', 'Road in front of the property', 'ถนนภายในหมู่บ้านภิรมย์สุขเป็นทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว ผิวคอนกรีตกว้างประมาณ 6 เมตร เขตทางประมาณ 9 เมตร', 'The internal Phirom Suk Village road is in an authorized land-allocation project, with an approximately six-metre concrete carriageway within an approximately nine-metre right of way', 'unspecified', NULL, '', 40),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนเสนอซื้อ', 'Buyer due diligence', 'ผู้ซื้อต้องตรวจสภาพปัจจุบัน โฉนด ทะเบียนและประเภทอาคาร แบบแปลน จำนวนชั้น ขอบเขต กฎโครงการ การครอบครอง สาธารณูปโภค ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขล่าสุดกับ SAM', 'Buyers must verify current condition, title, building registration and classification, plans, storeys, boundaries, project rules, possession, utilities, encumbrances, expenses and current terms with SAM', 'buyer', NULL, '', 50)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ด้านหน้าทาวน์โฮม 4 ชั้น', 'ด้านหน้าทาวน์โฮม 4 ชั้น เลขที่ 99/205 หมู่บ้านภิรมย์สุข รหัส SAM 8Z6125', 'https://npa.sam.or.th/site/images/npa/14239/20250429154414_P1_68.jpg', '/listing-media/sam/8z6125/01.webp', 'image/webp', 37222, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ด้านหลังทาวน์โฮม', 'มุมด้านหลังและประตูกระจกของทาวน์โฮม 4 ชั้นในหมู่บ้านภิรมย์สุข', 'https://npa.sam.or.th/site/images/npa/14239/P2_68.jpg', '/listing-media/sam/8z6125/02.webp', 'image/webp', 11910, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงภายในทาวน์โฮม', 'พื้นที่โถงภายในทาวน์โฮมพร้อมหน้าต่างและทางขึ้นบันได', 'https://npa.sam.or.th/site/images/npa/14239/P4_68.jpg', '/listing-media/sam/8z6125/03.webp', 'image/webp', 17150, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บันไดภายในบ้าน', 'บันไดเชื่อมพื้นที่ภายในทาวน์โฮม 4 ชั้น', 'https://npa.sam.or.th/site/images/npa/14239/P5_68.jpg', '/listing-media/sam/8z6125/04.webp', 'image/webp', 14980, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำพร้อมสุขภัณฑ์', 'ห้องน้ำภายในพร้อมโถสุขภัณฑ์ โถปัสสาวะ และอ่างล้างหน้า', 'https://npa.sam.or.th/site/images/npa/14239/P6_68.jpg', '/listing-media/sam/8z6125/05.webp', 'image/webp', 12214, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนพร้อมหน้าต่าง', 'ห้องนอนภายในทาวน์โฮมพร้อมหน้าต่างรับแสง', 'https://npa.sam.or.th/site/images/npa/14239/P7_68.jpg', '/listing-media/sam/8z6125/06.webp', 'image/webp', 12738, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำภายในบ้าน', 'ห้องน้ำภายในทาวน์โฮมพร้อมโถสุขภัณฑ์และสายฉีดชำระ', 'https://npa.sam.or.th/site/images/npa/14239/P8_68.jpg', '/listing-media/sam/8z6125/07.webp', 'image/webp', 9766, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องภายในพร้อมหน้าต่าง', 'ห้องภายในทาวน์โฮมพร้อมพื้นกระเบื้องและหน้าต่างด้านข้าง', 'https://npa.sam.or.th/site/images/npa/14239/P9_68.jpg', '/listing-media/sam/8z6125/08.webp', 'image/webp', 9902, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำชั้นบน', 'ห้องน้ำภายในทาวน์โฮมพร้อมโถสุขภัณฑ์และพื้นที่อาบน้ำ', 'https://npa.sam.or.th/site/images/npa/14239/P10_68.jpg', '/listing-media/sam/8z6125/09.webp', 'image/webp', 7138, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนอีกชั้น', 'ห้องนอนภายในทาวน์โฮมพร้อมหน้าต่างบานใหญ่', 'https://npa.sam.or.th/site/images/npa/14239/P11_68.jpg', '/listing-media/sam/8z6125/10.webp', 'image/webp', 12236, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำพร้อมอ่างล้างหน้า', 'ห้องน้ำภายในพร้อมโถสุขภัณฑ์และอ่างล้างหน้า', 'https://npa.sam.or.th/site/images/npa/14239/P12_68.jpg', '/listing-media/sam/8z6125/11.webp', 'image/webp', 8830, 455, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'access', 'ทางเข้าซอยลาดพร้าววังหิน 11', 'ภาพจุดเลี้ยวเข้าสู่ซอยลาดพร้าววังหิน 11 จากถนนลาดพร้าววังหิน', 'https://npa.sam.or.th/site/images/npa/14239/8Z6125P1_65.jpg', '/listing-media/sam/8z6125/12.webp', 'image/webp', 20568, 450, 450, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังแปลงที่ดิน 21.6 ตารางวา', 'ผังแปลงต้นทางแสดงหน้ากว้างประมาณ 6 เมตรและลึกประมาณ 14.4 เมตร', 'https://npa.sam.or.th/site/images/npa/14239/20180816165941_8Z6125C1_61.jpg', '/listing-media/sam/8z6125/13.webp', 'image/webp', 10560, 450, 450, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังตำแหน่งทาวน์โฮมเลขที่ 99/205', 'ผังต้นทางแสดงตำแหน่งทาวน์โฮมเลขที่ 99/205 และอาคารข้างเคียง', 'https://npa.sam.or.th/site/images/npa/14239/20180816165941_8Z6125C2_61.jpg', '/listing-media/sam/8z6125/14.webp', 'image/webp', 11384, 450, 450, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปหมู่บ้านภิรมย์สุข', 'แผนที่ต้นทางแสดงเส้นทางจากถนนลาดพร้าวและถนนลาดพร้าววังหินไปยังหมู่บ้านภิรมย์สุข', 'https://npa.sam.or.th/site/images/npa/14239/20180816165941_8Z6125M1_61.jpg', '/listing-media/sam/8z6125/15.webp', 'image/webp', 39064, 785, 600, 150, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=14239&keyref=6004425',
        '8Z6125',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 4,086,000 for a four-storey townhouse numbered 99/205 in Phirom Suk Village on Lat Phrao Wang Hin Road. Title deed no. 11209 covers 21.6 sq.wah / 86.4 sq.m. The rectangular plot has approximately six metres of western road frontage and a maximum depth of approximately 14.4 metres. SAM''s acquisition record describes a four-storey row building, while its condition survey describes a four-storey townhouse divided into six bedrooms and five bathrooms; MapxProp classifies it as a residential townhouse based on the source property category and survey. The property fronts an authorized land-allocation project road with an approximately six-metre concrete carriageway within an approximately nine-metre right of way. The source identifies yellow planning zoning. Usable area, parking, building age, utilities, occupancy and other encumbrances are not published. Property and interior photos visibly display 14 April 2025. Administrator coordinates are approximately 0.15 metres from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all fifteen unique source property, interior, access, plot and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Four-Storey Townhouse in Phirom Suk Village, Lat Phrao, THB 4.086M',
        E'Four-storey townhouse numbered 99/205 in Phirom Suk Village on Lat Phrao Wang Hin Road, Lat Phrao, Bangkok. The property has six bedrooms and five bathrooms on 21.6 sq.wah (86.4 sq.m.) of land under title deed no. 11209. The SAM page identifies yellow planning zoning.\n\nThe rectangular plot has approximately six metres of western road frontage and a maximum depth of approximately 14.4 metres. SAM''s acquisition record identifies a four-storey row building numbered 99/205, while its condition survey describes the structure as a four-storey townhouse divided into six bedrooms and five bathrooms. MapxProp therefore classifies it as a residential townhouse based on SAM''s property category and survey. Buyers should verify the building registration, approved plans, use and every structure included in the transfer against current conditions.\n\nThe property fronts the internal Phirom Suk Village road, which SAM identifies as being within an authorized land-allocation project. Its concrete carriageway is approximately six metres wide within an approximately nine-metre right of way. SAM describes the area as residential with convenient transport. Nearby places listed by SAM include Wat Lat Phrao School, Wat Lat Phrao, Paolo Hospital Chokchai 4 and Chok Chai 4 Metropolitan Police Station.\n\nSAM''s directions use Lat Phrao Road from Ratchadaphisek intersection toward Bang Kapi, passing Khlong Lat Phrao, Saphan Song Market and Chok Chai 4 Police Station. At Chok Chai 4 intersection, turn left onto Chok Chai 4 Road for approximately 1.1 km, then left onto Lat Phrao Wang Hin Road for about 400 metres. Turn left into Lat Phrao Wang Hin Soi 11 and Phirom Suk Village and continue approximately 110 metres. The property is on the left.\n\nThe SAM page listed the property for direct purchase at an announced THB 4,086,000 when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, offer procedures, current price, promotions, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: 8Z6125. MapxProp does not collect deposits or represent SAM in the transaction.\n\nThe source does not publish usable area, parking, building age, utility specifications, occupancy or other encumbrances. Property and interior photos visibly display 14 April 2025, and conditions may have changed. Buyers should inspect all four floors and verify the structure, roof, balcony, stairs, bathrooms, electrical and plumbing systems, cracks, moisture, termites, boundaries, project rules, possession, encumbrances, costs and every current term before deciding.',
        '99/205, Phirom Suk Village',
        'Approximately 110 m inside Lat Phrao Wang Hin Soi 11 and the village',
        'Lat Phrao Wang Hin Road',
        'Lat Phrao',
        'Lat Phrao',
        'Bangkok',
        'SAM Four-Storey Townhouse in Phirom Suk Village, Lat Phrao, THB 4.086M',
        'Official SAM NPA asset 8Z6125: four-storey townhouse with 6 bedrooms and 5 bathrooms on 86.4 sq.m. Direct-sale price THB 4.086M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset 8Z6125 four storey townhouse Phirom Suk Village Lat Phrao Wang Hin Road Soi 11 Lat Phrao Bangkok 21.6 sq.wah 86.4 sq.m. title deed 11209 six bedrooms five bathrooms THB 4086000 address 99/205')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=14239&keyref=6004425'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=14239&keyref=6004425',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z6125. Specifications, title deed, building descriptions, room counts, images, rounded coordinates, announced price, direct-purchase status, road details and planning-zone wording come from that record.',
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
        '61535fd7-6c3d-4e28-8ff4-b65936371d02',
        jsonb_build_object(
            'reference_code', '8Z6125',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'residential',
            'discovery_channels', jsonb_build_array('homes'),
            'title_document_count', 1,
            'floor_count', 4,
            'bedroom_count', 6,
            'bathroom_count', 5,
            'authorized_land_allocation_project_road', true,
            'building_description_review_required', true,
            'source_image_count', 15
        )
    );
END $$;

COMMIT;
