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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing HL0354';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing HL0354';
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
        '4f6eb1e7-d506-422d-a26d-ed10038749d6',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'detached_house',
        'residence',
        'sale',
        'whole_property',
        'บุญฟ้าแกรนด์โฮม',
        '222/34',
        'ขายตรง SAM บ้านเดี่ยว 2 ชั้น บุญฟ้าแกรนด์โฮม สารภี 3 ห้องนอน 3 ห้องน้ำ ราคา 2.734 ล้านบาท',
        E'บ้านเดี่ยว 2 ชั้น เลขที่ 222/34 ในหมู่บ้านบุญฟ้าแกรนด์โฮม ตำบลป่าบง อำเภอสารภี จังหวัดเชียงใหม่ บนโฉนดที่ดินเลขที่ 56048 จำนวน 1 ฉบับ เนื้อที่ 52.5 ตร.ว. (210 ตร.ม.) หน้า SAM ระบุ 3 ห้องนอน 3 ห้องน้ำ และรายการรับโอนกรรมสิทธิ์ระบุสิ่งปลูกสร้างเป็นบ้านพักอาศัยตึกสองชั้น เลขที่ 222/34 พร้อมโรงจอดรถ\n\nที่ดินเป็นรูปสี่เหลี่ยมผืนผ้า ด้านทิศตะวันตกติดถนนภายในโครงการ หน้ากว้างประมาณ 15 เมตร และลึกประมาณ 14 เมตร ผู้ซื้อควรตรวจโฉนด แนวเขต ขนาดจริง ทะเบียนอาคาร แบบแปลน ใบอนุญาต และยืนยันว่าบ้านกับโรงจอดรถอยู่ในรายการสิ่งปลูกสร้างที่จะได้รับโอนครบถ้วน\n\nถนนผ่านหน้าทรัพย์เป็นถนนคอนกรีตภายในหมู่บ้านบุญฟ้าแกรนด์โฮม ซึ่ง SAM ระบุว่าเป็นทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว ผิวจราจรกว้างประมาณ 8 เมตร และเขตทางกว้างประมาณ 10 เมตร ทรัพย์อยู่ในเขตผังเมืองสีเขียวและย่านที่อยู่อาศัย SAM ระบุว่ามีสาธารณูปโภคครบครันและการคมนาคมสะดวก แต่ผู้ซื้อต้องตรวจข้อกำหนดผังเมือง กฎโครงการ ค่าส่วนกลาง และสภาพระบบปัจจุบันเพิ่มเติม\n\nการเดินทางตาม SAM ใช้ถนนเชียงใหม่-แม่ออน (ทล.1317) จากเมืองเชียงใหม่มุ่งหน้าแม่ออน ผ่านตลาดเจริญเจริญ แยกสันกลาง และปั๊ม ปตท. แยกสันกลาง ถึงบริเวณหลัก กม.4+800 เลี้ยวขวาเข้าถนนสายบ้านสันป่าค่า-บ้านไชยสถานประมาณ 1.25 กิโลเมตร แล้วเลี้ยวซ้ายเข้าหมู่บ้านบุญฟ้าแกรนด์โฮมประมาณ 90 เมตร ทรัพย์อยู่ด้านซ้ายมือ\n\nหน้า SAM แสดงสถานะ “ซื้อตรง” และราคาประกาศขาย 2,734,000 บาท ณ วันที่ตรวจสอบ 10 กันยายน 2569 ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะผู้ครอบครอง และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ HL0354 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nภาพทรัพย์ต้นทางแสดงวันที่ 16 มิถุนายน 2565 สภาพจริงอาจเปลี่ยนแปลง ภาพแสดงรถยนต์และสิ่งของบริเวณหน้าบ้านในวันถ่าย แต่ไม่ใช่หลักฐานยืนยันสถานะผู้ครอบครองปัจจุบัน หน้า SAM ไม่ได้เผยแพร่พื้นที่ใช้สอย จำนวนที่จอดรถ อายุอาคาร สถานะผู้ครอบครอง ประวัติน้ำท่วม ค่าส่วนกลาง รายละเอียดระบบไฟฟ้า-ประปาภายใน หรือภาระผูกพันอื่น ผู้ซื้อควรนัดตรวจภายใน โครงสร้าง หลังคา รอยร้าว ความชื้น ปลวก ระบบไฟฟ้าและประปา การระบายน้ำ แนวเขต กฎโครงการ ค่าส่วนกลาง ภาษี ค่าใช้จ่าย และเอกสารทั้งหมดก่อนตัดสินใจ\n\nหมายเหตุภาพต้นทาง: ชื่อไฟล์แผนที่ของ SAM มีรหัส 8Z6500 อยู่ในวงเล็บ แม้หน้าและภาพทรัพย์ปัจจุบันใช้รหัส HL0354 ส่วนเนื้อหาในแผนที่แสดงเส้นทางบุญฟ้าแกรนด์โฮมตรงกับทรัพย์นี้ เมื่อติดต่อ SAM ให้ใช้อ้างอิงรหัส HL0354 และหน้า id 22077 พร้อมขอให้ยืนยันความเกี่ยวข้องของรหัสในชื่อไฟล์แผนที่',
        2734000,
        false,
        210,
        3,
        3,
        2,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        '222/34 หมู่บ้านบุญฟ้าแกรนด์โฮม',
        'เข้าจากถนนเชียงใหม่-แม่ออน (ทล.1317) ผ่านถนนสายบ้านสันป่าค่า-บ้านไชยสถาน',
        'ถนนภายในหมู่บ้านบุญฟ้าแกรนด์โฮม',
        NULL,
        18.742389130100154,
        99.061662384434,
        'เชียงใหม่',
        'สารภี',
        'ป่าบง',
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
        'sam-direct-sale-two-storey-house-boonfa-grand-home-saraphi-hl0354'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 2734000, 'total', 'THB', false
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
        'detached_house',
        1,
        jsonb_build_object(
            'source_property_category', 'บ้านเดี่ยว',
            'official_page_reference_code', 'HL0354',
            'source_gallery_filename_reference_code', 'HL0354',
            'source_page_id', 22077,
            'project_name', 'บุญฟ้าแกรนด์โฮม',
            'listed_unit_number', '222/34',
            'title_document_type', 'chanote',
            'title_deed_number', '56048',
            'title_document_count', 1,
            'land_area_rai', 0,
            'land_area_ngan', 0,
            'land_area_square_wah_remainder', 52.5,
            'land_area_square_wah', 52.5,
            'land_area_sqm', 210,
            'bedroom_count', 3,
            'bathroom_count', 3,
            'registered_transfer_description', 'บ้านพักอาศัยตึกสองชั้น เลขที่ 222/34, โรงจอดรถ',
            'registered_floor_count', 2,
            'registered_garage_reported', true,
            'plot_count', 1,
            'plot_shape', 'rectangle',
            'west_road_frontage_m_approx', 15,
            'maximum_depth_m_approx', 14,
            'front_road_name', 'ถนนภายในหมู่บ้านบุญฟ้าแกรนด์โฮม',
            'source_address_road_name', 'ถนนสายบ้านสันป่าค่า-บ้านไชยสถาน',
            'front_road_legal_status_th', 'ทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว',
            'front_road_surface', 'concrete',
            'front_road_width_m_approx', 8,
            'front_right_of_way_width_m_approx', 10,
            'zoning_color_th', 'สีเขียว',
            'surrounding_area_use_th', 'ย่านที่อยู่อาศัย',
            'mixed_use_classification', false,
            'mixed_use_exclusion_basis', 'SAM ระบุประเภททรัพย์เป็นบ้านเดี่ยวและย่านโดยรอบเป็นที่อยู่อาศัย ไม่ได้ระบุการใช้เชิงธุรกิจหรือ Mixed Use',
            'residential_classification', true,
            'utilities_described_as_complete_by_source', true,
            'transport_described_as_convenient_by_source', true
        ) || jsonb_build_object(
            'usable_area_not_published', true,
            'parking_count_not_published', true,
            'building_age_not_published', true,
            'occupancy_status_not_published', true,
            'flood_history_not_published', true,
            'common_fee_information_not_published', true,
            'internal_utilities_condition_not_published', true,
            'other_encumbrances_not_published', true,
            'source_images_show_vehicle_and_household_items', true,
            'source_images_are_not_current_occupancy_evidence', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'computed_price_per_square_wah', 52076.19,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_property_photo_date_displayed', '2022-06-16',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '18.742399,99.061620',
            'administrator_coordinate_distance_from_source_m_approx', 4.60,
            'online_pin_not_boundary_evidence', true,
            'source_map_filename', '20241016170237_HL0354M_67 (8Z6500).jpg',
            'source_map_filename_alternate_reference_code', '8Z6500',
            'source_reference_code_discrepancy', true,
            'source_map_content_matches_current_project', true,
            'alternate_reference_code_relationship_requires_sam_confirmation', true
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
        listing_id, role_code, authority_source_code, organization_name,
        organization_registration_no, verification_status, verification_note,
        verified_at, verified_by_user_id, organization_id, contact_user_id
    ) VALUES (
        property_listing_id,
        'developer_investor_representative',
        'investor_asset_holder',
        'บริษัท บริหารสินทรัพย์สุขุมวิท จำกัด (SAM)',
        '0105543033809',
        'authority_verified',
        'The official SAM NPA page identifies SAM as the asset holder and direct-sale contact for HL0354. The navigation-map filename additionally contains 8Z6500, while the map content itself shows the route to Boonfa Grand Home; buyers should quote current asset HL0354 and page id 22077 and ask SAM to confirm the filename reference. MapxProp does not collect deposits or represent SAM in the transaction.',
        now(), admin_user_id, sam_organization_id, NULL
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
        (property_listing_id, 'ถนนเชียงใหม่-แม่ออน (ทล.1317)', 'Chiang Mai-Mae On Highway 1317', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ถนนสายบ้านสันป่าค่า-บ้านไชยสถาน', 'Ban San Pa Kha-Ban Chai Sathan Road', 'road', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'สำนักงานเทศบาลตำบลป่าบง', 'Pa Bong Subdistrict Municipality Office', 'government', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'อินเตอร์มินิกอล์ฟ เชียงใหม่', 'Inter Mini Golf Chiang Mai', 'landmark', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'โรงเรียนอนุบาลเปรมฤดี', 'Premrudee Kindergarten', 'education', NULL, NULL, NULL, 50, true),
        (property_listing_id, 'วัดป่าบงหลวง', 'Wat Pa Bong Luang', 'landmark', NULL, NULL, NULL, 60, true),
        (property_listing_id, 'ตลาดเจริญเจริญ', 'Charoen Charoen Market', 'shopping', NULL, NULL, NULL, 70, false),
        (property_listing_id, 'แยกสันกลาง', 'San Klang Intersection', 'road', NULL, NULL, NULL, 80, false)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '2,734,000 บาท — โปรดตรวจสอบราคาล่าสุดและโปรโมชั่นกับ SAM', 'THB 2,734,000 — confirm the latest price and promotions with SAM', 'unspecified', 2734000, 'THB', 20),
        (property_listing_id, 'title_and_registered_structures', 'เอกสารสิทธิ์และสิ่งปลูกสร้างตามรายการรับโอน', 'Title and registered structures', 'โฉนดเลขที่ 56048 จำนวน 1 ฉบับ เนื้อที่ 52.5 ตร.ว. พร้อมบ้านพักอาศัยตึกสองชั้น เลขที่ 222/34 และโรงจอดรถ', 'Title deed no. 56048, one document, covering 52.5 sq.wah with a registered two-storey masonry residence numbered 222/34 and a garage', 'unspecified', NULL, '', 30),
        (property_listing_id, 'rooms', 'ห้องนอนและห้องน้ำ', 'Bedrooms and bathrooms', 'SAM ระบุ 3 ห้องนอน 3 ห้องน้ำ', 'SAM lists three bedrooms and three bathrooms', 'unspecified', NULL, '', 40),
        (property_listing_id, 'plot_dimensions', 'ขนาดแนวแปลง', 'Plot dimensions', 'แปลงรูปสี่เหลี่ยมผืนผ้า ด้านทิศตะวันตกติดถนนกว้างประมาณ 15 เมตร ลึกประมาณ 14 เมตร', 'Rectangular plot with approximately fifteen metres of west-side road frontage and approximately fourteen metres of depth', 'unspecified', 15, 'metres', 50),
        (property_listing_id, 'internal_project_road', 'ถนนภายในโครงการ', 'Internal development road', 'ถนนหมู่บ้านบุญฟ้าแกรนด์โฮมเป็นทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว ผิวคอนกรีตกว้างประมาณ 8 เมตร เขตทางประมาณ 10 เมตร', 'The Boonfa Grand Home road is an internal road in an authorized allocated development, with an approximately eight-metre concrete carriageway in a ten-metre right of way', 'unspecified', 8, 'metres', 60),
        (property_listing_id, 'source_photo_and_occupancy', 'วันที่ภาพและสถานะการครอบครอง', 'Photo date and occupancy', 'ภาพวันที่ 16 มิถุนายน 2565 แสดงรถยนต์และสิ่งของหน้าบ้าน แต่หน้า SAM ไม่ระบุสถานะผู้ครอบครองปัจจุบัน ต้องตรวจสอบกับ SAM และตรวจสถานที่จริง', 'Photos dated 16 June 2022 show vehicles and household items outside, but SAM does not publish current occupancy; confirm it with SAM and inspect the property', 'buyer', NULL, '', 70),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนด แนวเขต บ้านและโรงจอดรถตามรายการรับโอน ทะเบียนอาคาร แบบแปลน ใบอนุญาต สภาพภายใน ระบบไฟฟ้า-ประปา น้ำท่วม การครอบครอง ภาระผูกพัน กฎโครงการ ค่าส่วนกลาง ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Verify title, boundaries, the registered house and garage, building records, plans, permits, interior condition, electrical and plumbing systems, flooding, possession, encumbrances, development rules, common fees, costs and latest terms', 'buyer', NULL, '', 80)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'บ้านเดี่ยว 2 ชั้น เลขที่ 222/34', 'บ้านเดี่ยว 2 ชั้น เลขที่ 222/34 หมู่บ้านบุญฟ้าแกรนด์โฮม สารภี รหัส SAM HL0354', 'https://npa.sam.or.th/site/images/npa/22077/20241016170237_HL0354P3_67.jpg', '/listing-media/sam/hl0354/01.webp', 'image/webp', 31748, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมด้านหน้าบ้านและสวน', 'ภาพมุมด้านหน้าบ้านเลขที่ 222/34 พร้อมสวนและแนวรั้ว', 'https://npa.sam.or.th/site/images/npa/22077/HL0354P4_67.jpg', '/listing-media/sam/hl0354/02.webp', 'image/webp', 29326, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บ้านและแนวถนนภายในโครงการ', 'ภาพบ้านสองชั้นเลขที่ 222/34 และถนนคอนกรีตภายในหมู่บ้านบุญฟ้าแกรนด์โฮม', 'https://npa.sam.or.th/site/images/npa/22077/HL0354P5_67.jpg', '/listing-media/sam/hl0354/03.webp', 'image/webp', 17516, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมบ้านจากอีกด้าน', 'ภาพมุมด้านหน้าบ้านและแนวเขตจากถนนภายในโครงการ', 'https://npa.sam.or.th/site/images/npa/22077/HL0354P6_67.jpg', '/listing-media/sam/hl0354/04.webp', 'image/webp', 17810, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'จุดเลี้ยวจากถนนเชียงใหม่-แม่ออน', 'ภาพจุดเลี้ยวจากถนนเชียงใหม่-แม่ออน ทล.1317 เข้าถนนสายบ้านสันป่าค่า-บ้านไชยสถาน', 'https://npa.sam.or.th/site/images/npa/22077/HL0354P1_67.jpg', '/listing-media/sam/hl0354/05.webp', 'image/webp', 25972, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้าหมู่บ้านบุญฟ้าแกรนด์โฮม', 'ภาพจุดเลี้ยวจากถนนสายบ้านสันป่าค่า-บ้านไชยสถานเข้าสู่หมู่บ้านบุญฟ้าแกรนด์โฮม', 'https://npa.sam.or.th/site/images/npa/22077/HL0354P2_67.jpg', '/listing-media/sam/hl0354/06.webp', 'image/webp', 27732, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังตำแหน่งบ้านในบุญฟ้าแกรนด์โฮม', 'ผังโครงการต้นทางแสดงตำแหน่งแปลงบ้านและระยะประมาณ 90 เมตรจากทางเข้าโครงการ', 'https://npa.sam.or.th/site/images/npa/22077/HL0354C3.1_67.jpg', '/listing-media/sam/hl0354/07.webp', 'image/webp', 23226, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังแปลงโฉนดเลขที่ 56048', 'ผังต้นทางแสดงแปลงสี่เหลี่ยมผืนผ้าขนาดประมาณ 15 คูณ 14 เมตรและถนนด้านทิศตะวันตก', 'https://npa.sam.or.th/site/images/npa/22077/20241016170237_HL0354C1_67.jpg', '/listing-media/sam/hl0354/08.webp', 'image/webp', 11904, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังบ้านและโรงจอดรถบนแปลง', 'ผังต้นทางแสดงตำแหน่งบ้านสองชั้นและโรงจอดรถเลขที่ 222/34 ระหว่างบ้านเลขที่ 222/33 และ 222/35', 'https://npa.sam.or.th/site/images/npa/22077/20241016170237_HL0354C2_67.jpg', '/listing-media/sam/hl0354/09.webp', 'image/webp', 17940, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปบุญฟ้าแกรนด์โฮม', 'แผนที่ต้นทาง SAM แสดงเส้นทางจากถนนเชียงใหม่-แม่ออน ทล.1317 ผ่านถนนสายบ้านสันป่าค่า-บ้านไชยสถานไปหมู่บ้านบุญฟ้าแกรนด์โฮม', 'https://npa.sam.or.th/site/images/npa/22077/20241016170237_HL0354M_67 (8Z6500).jpg', '/listing-media/sam/hl0354/10.webp', 'image/webp', 56124, 785, 600, 100, false, true);

    INSERT INTO public.listing_sources (
        listing_id, source_type, publisher_name, source_url,
        reference_code, captured_at, notes
    ) VALUES (
        property_listing_id,
        'editorial_import',
        'บริษัท บริหารสินทรัพย์สุขุมวิท จำกัด (SAM)',
        'https://www.sam.or.th/site/npa/detail.php?id=22077&keyref=6004858',
        'HL0354',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA page id 22077. The page showed direct-purchase status and an announced sale price of THB 2,734,000 for a two-storey detached house numbered 222/34 in Boonfa Grand Home, Pa Bong, Saraphi, Chiang Mai. Title deed no. 56048 covers 52.5 sq.wah / 210 sq.m. The source lists three bedrooms and three bathrooms and identifies the registered transferred structures as a two-storey masonry residence numbered 222/34 and a garage. The rectangular plot has approximately fifteen metres of west-side project-road frontage and approximately fourteen metres of depth. The Boonfa Grand Home road is described as an internal concrete road in an authorized allocated development, approximately eight metres wide within an approximately ten-metre right of way. The source identifies green planning zoning, residential surroundings, complete utilities and convenient transport. Usable area, parking count, building age, occupancy, flood history, common fees, internal utility condition and other encumbrances are not published. Property images display 16 June 2022 and show vehicles and household items outside, which is not treated as current occupancy evidence. Administrator coordinates are approximately 4.60 metres from the rounded source coordinates and are used for the listing. The navigation-map filename also contains alternate asset code 8Z6500, while its visible content maps Boonfa Grand Home and the route described on the HL0354 page. MapxProp retains HL0354 as the current reference and records the filename discrepancy for SAM confirmation. MapxProp stores optimized copies of all ten unique source property, access, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Two-Storey House in Boonfa Grand Home, Saraphi, THB 2.734M',
        E'A two-storey detached house numbered 222/34 in Boonfa Grand Home, Pa Bong, Saraphi, Chiang Mai. Title deed no. 56048, one document, covers 52.5 sq.wah (210 sq.m.). SAM lists three bedrooms and three bathrooms and identifies the registered transferred structures as a two-storey masonry residence numbered 222/34 and a garage.\n\nThe rectangular plot has approximately fifteen metres of west-side frontage on the internal development road and approximately fourteen metres of depth. Buyers should verify the title, survey, boundaries, measurements, building registration, approved plans, permits and that both the house and garage are included in the transfer.\n\nThe Boonfa Grand Home road is described as an internal concrete road in an authorized allocated development, approximately eight metres wide within an approximately ten-metre right of way. SAM identifies green planning zoning and residential surroundings and describes complete utilities and convenient transport. Buyers should confirm current planning and building requirements, utility service, development rules and common fees.\n\nSAM directions use Chiang Mai-Mae On Highway 1317 from central Chiang Mai toward Mae On, passing Charoen Charoen Market, San Klang Intersection and the PTT station at San Klang. At approximately kilometre 4+800, turn right onto Ban San Pa Kha-Ban Chai Sathan Road for approximately 1.25 kilometres, then left into Boonfa Grand Home for approximately 90 metres. The property is on the left.\n\nThe SAM page listed the property for direct purchase at an announced THB 2,734,000 when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, offer procedures, current price, promotions, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: HL0354. MapxProp does not collect deposits or represent SAM.\n\nProperty photos display 16 June 2022, and conditions may have changed. They show vehicles and household items outside on the photo date, but this does not establish current occupancy. The source does not publish usable area, parking count, building age, occupancy, flood history, common fees, internal electrical and plumbing condition or other encumbrances. Buyers should inspect the interior, structure, roof, cracks, moisture, termites, electrical and plumbing systems, drainage, boundaries, development rules, common fees, taxes, costs and every current term before deciding.\n\nSource-media note: the current page and property images use HL0354, while the navigation-map filename also contains 8Z6500. The map content itself shows Boonfa Grand Home and matches the route on this page. Quote HL0354 and page id 22077 when contacting SAM and ask SAM to confirm the alternate filename reference.',
        '222/34, Boonfa Grand Home',
        'Access from Chiang Mai-Mae On Highway 1317 via Ban San Pa Kha-Ban Chai Sathan Road',
        'Boonfa Grand Home internal road',
        'Pa Bong',
        'Saraphi',
        'Chiang Mai',
        'SAM House in Boonfa Grand Home, Saraphi, THB 2.734M',
        'Official SAM asset HL0354: two-storey house with three bedrooms, three bathrooms and a garage on 52.5 sq.wah in Boonfa Grand Home. Direct-sale price THB 2.734M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset HL0354 detached house two storey 222/34 Boonfa Grand Home Pa Bong Saraphi Chiang Mai Highway 1317 52.5 sq.wah 210 sq.m. 3 bedrooms 3 bathrooms garage title deed 56048 THB 2734000')
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
        SELECT 1 FROM public.organization_verifications
        WHERE organization_id = sam_organization_id
          AND verification_type = 'listing_authority'
          AND status = 'verified'
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=22077&keyref=6004858'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=22077&keyref=6004858',
            'The official SAM NPA page identifies SAM as the asset holder and direct-sale contact for HL0354. Specifications, title deed, registered house and garage, images, rounded coordinates, announced price, direct-purchase status, road measurements, planning-zone wording and the alternate map-filename reference come from that page.',
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
        '4f6eb1e7-d506-422d-a26d-ed10038749d6',
        jsonb_build_object(
            'reference_code', 'HL0354',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'residence',
            'discovery_channels', jsonb_build_array('homes'),
            'title_document_count', 1,
            'registered_floor_count', 2,
            'bedroom_count', 3,
            'bathroom_count', 3,
            'registered_garage_reported', true,
            'source_reference_discrepancy', true,
            'alternate_reference_code_in_map_filename', '8Z6500',
            'source_image_count', 10
        )
    );
END $$;

COMMIT;
