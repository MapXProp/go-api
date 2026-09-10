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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing HL0253';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing HL0253';
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
        'b0141625-7f5a-44a9-8385-bb4a803c6053',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'detached_house',
        'residence',
        'sale',
        'whole_property',
        'กาญจน์กนกวิลล์ 4',
        '113/83',
        'ขายตรง SAM บ้านเดี่ยว 2 ชั้น แปลงมุม กาญจน์กนกวิลล์ 4 สันกำแพง 74 ตร.ว. ราคา 2.92 ล้านบาท',
        E'บ้านเดี่ยว 2 ชั้น เลขที่ 113/83 หมู่ 12 ในโครงการกาญจน์กนกวิลล์ 4 ตำบลสันกำแพง อำเภอสันกำแพง จังหวัดเชียงใหม่ โฉนดที่ดินเลขที่ 71574 จำนวน 1 ฉบับ เนื้อที่ 74 ตร.ว. (296 ตร.ม.) รายการรับโอนกรรมสิทธิ์ของ SAM ระบุสิ่งปลูกสร้างเป็นบ้านพักอาศัยตึกสองชั้น เลขที่ 113/83\n\nที่ดินรูปสี่เหลี่ยมผืนผ้าเป็นแปลงมุมติดถนน 2 ด้าน ด้านทิศเหนือกว้างประมาณ 16 เมตร และด้านทิศตะวันออกกว้างประมาณ 18 เมตร ผู้ซื้อควรตรวจโฉนด แนวเขต ขนาดจริง ทิศทาง ทางเข้าออก ทะเบียนอาคาร แบบแปลน ใบอนุญาต และรายการสิ่งปลูกสร้างที่จะได้รับโอน\n\nถนนผ่านหน้าทรัพย์เป็นซอย 18 ภายในหมู่บ้านกาญจน์กนกวิลล์ 4 ซึ่ง SAM ระบุว่าเป็นทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว ผิวจราจรคอนกรีตกว้างประมาณ 6 เมตร และเขตทางกว้างประมาณ 8 เมตร ทรัพย์อยู่ในเขตผังเมืองสีเขียวและย่านที่อยู่อาศัย\n\nการเดินทางตาม SAM ใช้ถนนสายดอนจั่น-ห้วยแก้ว (ทล.1317) จากอำเภอสันกำแพงมุ่งหน้าตัวเมืองเชียงใหม่ ผ่านกาดศรีอรุณ ถึงบริเวณ กม. 6+80 ตามข้อความต้นทาง เลี้ยวซ้ายเข้าถนนเลียบลำน้ำแม่โฮมประมาณ 1 กิโลเมตร จากนั้นเลี้ยวซ้ายเข้าหมู่บ้านกาญจน์กนกวิลล์ 4 และซอย 18 รวมประมาณ 650 เมตร ทรัพย์อยู่ด้านซ้ายมือ สถานที่ใกล้เคียงที่ SAM ระบุ ได้แก่ โรงเรียนวัดสันป่าค่า วัดสันป่าแดง และสถานีไฟฟ้าสันกำแพง กฟภ.\n\nหน้า SAM แสดงสถานะ “ซื้อตรง” และราคาประกาศขาย 2,920,000 บาท ณ วันที่ตรวจสอบ 10 กันยายน 2569 ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะผู้ครอบครอง และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ HL0253 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nภาพตัวบ้านต้นทางแสดงวันที่ 5 เมษายน 2567 และไม่มีภาพภายใน สภาพจริงอาจเปลี่ยนแปลง หน้า SAM ไม่ได้เผยแพร่จำนวนห้องนอน ห้องน้ำ พื้นที่ใช้สอย จำนวนที่จอดรถ อายุอาคาร สถานะผู้ครอบครอง ประวัติน้ำท่วม ค่าส่วนกลาง สภาพระบบไฟฟ้า-ประปาภายใน หรือภาระผูกพันอื่น ผู้ซื้อควรนัดตรวจภายใน โครงสร้าง หลังคา รอยร้าว ความชื้น ปลวก ระบบไฟฟ้าและประปา การระบายน้ำ แนวเขต กฎโครงการ ค่าส่วนกลาง ภาษี ค่าใช้จ่าย และเอกสารทั้งหมดก่อนตัดสินใจ\n\nหมายเหตุการถอดข้อมูล: ข้อความชื่อถนนในหัวข้อรายละเอียดทรัพย์สินบนหน้า SAM มีคำสะกดคลาดเคลื่อน แต่หัวข้อการเข้าถึงและภาพต้นทางระบุหมู่บ้านกาญจน์กนกวิลล์ 4 ซอย 18 ตรงกัน MapxProp จึงใช้ชื่อที่อ่านได้จากสองส่วนดังกล่าวและบันทึกข้อสังเกตไว้ให้ตรวจสอบกับ SAM',
        2920000,
        false,
        296,
        NULL,
        NULL,
        2,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        '113/83 หมู่ 12 หมู่บ้านกาญจน์กนกวิลล์ 4 ซอย 18',
        'เข้าจากถนนสายดอนจั่น-ห้วยแก้ว (ทล.1317) ผ่านถนนเลียบลำน้ำแม่โฮม',
        'ถนนสายดอนจั่น-ห้วยแก้ว (ทล.1317)',
        NULL,
        18.732372620113328,
        99.07803353130102,
        'เชียงใหม่',
        'สันกำแพง',
        'สันกำแพง',
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
        'sam-direct-sale-two-storey-house-karnkanok-ville-4-san-kamphaeng-hl0253'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 2920000, 'total', 'THB', false
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
            'official_page_reference_code', 'HL0253',
            'source_gallery_filename_reference_code', 'HL0253',
            'source_page_id', 21741,
            'project_name', 'กาญจน์กนกวิลล์ 4',
            'listed_unit_number', '113/83',
            'listed_moo', '12',
            'title_document_type', 'chanote',
            'title_deed_number', '71574',
            'title_document_count', 1,
            'land_area_rai', 0,
            'land_area_ngan', 0,
            'land_area_square_wah_remainder', 74,
            'land_area_square_wah', 74,
            'land_area_sqm', 296,
            'registered_transfer_description', 'บ้านพักอาศัยตึกสองชั้น เลขที่ 113/83',
            'registered_floor_count', 2,
            'plot_count', 1,
            'plot_shape', 'rectangle',
            'corner_plot_two_road_frontages', true,
            'north_road_frontage_m_approx', 16,
            'east_road_frontage_m_approx', 18,
            'front_road_name', 'ซอย 18 ภายในหมู่บ้านกาญจน์กนกวิลล์ 4',
            'source_address_road_name', 'ถนนสายดอนจั่น-ห้วยแก้ว (ทล.1317)',
            'front_road_legal_status_th', 'ทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว',
            'front_road_surface', 'concrete',
            'front_road_width_m_approx', 6,
            'front_right_of_way_width_m_approx', 8,
            'zoning_color_th', 'สีเขียว',
            'surrounding_area_use_th', 'ย่านที่อยู่อาศัย',
            'mixed_use_classification', false,
            'mixed_use_exclusion_basis', 'SAM ระบุประเภททรัพย์เป็นบ้านเดี่ยวและย่านโดยรอบเป็นที่อยู่อาศัย ไม่ได้ระบุการใช้เชิงธุรกิจหรือ Mixed Use',
            'residential_classification', true
        ) || jsonb_build_object(
            'bedroom_count_not_published', true,
            'bathroom_count_not_published', true,
            'usable_area_not_published', true,
            'parking_count_not_published', true,
            'building_age_not_published', true,
            'occupancy_status_not_published', true,
            'flood_history_not_published', true,
            'common_fee_information_not_published', true,
            'internal_utilities_condition_not_published', true,
            'other_encumbrances_not_published', true,
            'source_interior_images_not_published', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'computed_price_per_square_wah', 39459.46,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_property_photo_date_displayed', '2024-04-05',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '18.732374,99.078042',
            'administrator_coordinate_distance_from_source_m_approx', 0.90,
            'online_pin_not_boundary_evidence', true,
            'source_front_road_text_contains_typographical_errors', true,
            'normalized_front_road_name_from_access_text_and_images', true
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
        'The official SAM NPA page identifies SAM as the asset holder and direct-sale contact for HL0253. Specifications, title deed, registered house, images, rounded coordinates, announced price, direct-purchase status, road measurements and planning-zone wording come from that page. The malformed front-road text is normalized from the access directions and source images and should be reconfirmed with SAM. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนสายดอนจั่น-ห้วยแก้ว (ทล.1317)', 'Don Chan-Huai Kaeo Road, Highway 1317', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'กาดศรีอรุณ', 'Kad Sri Arun', 'shopping', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'โรงเรียนวัดสันป่าค่า', 'Wat San Pa Kha School', 'education', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'วัดสันป่าแดง', 'Wat San Pa Daeng', 'landmark', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'สถานีไฟฟ้าสันกำแพง กฟภ.', 'PEA San Kamphaeng Substation', 'government', NULL, NULL, NULL, 50, true)
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
        (property_listing_id, 'sale_method', 'วิธีซื้อ', 'Purchase method', 'ซื้อตรงจาก SAM — ติดต่อ SAM เพื่อเสนอซื้อ', 'Direct purchase from SAM — contact SAM to submit an offer', 'unspecified', NULL, '', 10),
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '2,920,000 บาท — โปรดตรวจสอบราคาล่าสุดและโปรโมชั่นกับ SAM', 'THB 2,920,000 — confirm the latest price and promotions with SAM', 'unspecified', 2920000, 'THB', 20),
        (property_listing_id, 'title_and_registered_structure', 'เอกสารสิทธิ์และสิ่งปลูกสร้างตามรายการรับโอน', 'Title and registered structure', 'โฉนดเลขที่ 71574 จำนวน 1 ฉบับ เนื้อที่ 74 ตร.ว. พร้อมบ้านพักอาศัยตึกสองชั้น เลขที่ 113/83', 'Title deed no. 71574, one document, covering 74 sq.wah with a registered two-storey masonry residence numbered 113/83', 'unspecified', NULL, '', 30),
        (property_listing_id, 'corner_plot_dimensions', 'แปลงมุมและขนาดแนวแปลง', 'Corner plot and dimensions', 'แปลงรูปสี่เหลี่ยมผืนผ้าติดถนน 2 ด้าน ทิศเหนือกว้างประมาณ 16 เมตร และทิศตะวันออกกว้างประมาณ 18 เมตร', 'Rectangular corner plot fronting two roads, approximately sixteen metres on the north and eighteen metres on the east', 'unspecified', NULL, '', 40),
        (property_listing_id, 'internal_project_road', 'ถนนภายในโครงการ', 'Internal development road', 'ซอย 18 ในกาญจน์กนกวิลล์ 4 เป็นทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว ผิวคอนกรีตกว้างประมาณ 6 เมตร เขตทางประมาณ 8 เมตร', 'Soi 18 in Karnkanok Ville 4 is a road in an authorized allocated development, with an approximately six-metre concrete carriageway in an eight-metre right of way', 'unspecified', 6, 'metres', 50),
        (property_listing_id, 'source_photo_and_interior', 'วันที่ภาพและข้อมูลภายใน', 'Photo date and interior information', 'ภาพตัวบ้านวันที่ 5 เมษายน 2567 แต่ SAM ไม่มีภาพภายในและไม่ระบุจำนวนห้อง ต้องตรวจสถานที่จริง', 'Exterior photos display 5 April 2024, but SAM publishes no interior images or room counts; inspect the property', 'buyer', NULL, '', 60),
        (property_listing_id, 'source_text_normalization', 'ข้อสังเกตข้อความต้นทาง', 'Source-text note', 'ชื่อถนนในหัวข้อรายละเอียดของ SAM มีคำสะกดคลาดเคลื่อน จึงใช้ชื่อกาญจน์กนกวิลล์ 4 ซอย 18 ตามหัวข้อการเข้าถึงและภาพต้นทาง โปรดยืนยันกับ SAM', 'The front-road text in the SAM details contains typographical errors; Karnkanok Ville 4 Soi 18 is normalized from the access directions and source images and should be confirmed with SAM', 'buyer', NULL, '', 70),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนด แนวเขต บ้านตามรายการรับโอน ทะเบียนอาคาร แบบแปลน ใบอนุญาต สภาพภายใน จำนวนห้อง ระบบไฟฟ้า-ประปา น้ำท่วม การครอบครอง ภาระผูกพัน กฎโครงการ ค่าส่วนกลาง ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Verify title, boundaries, the registered house, building records, plans, permits, interior condition, room counts, electrical and plumbing systems, flooding, possession, encumbrances, development rules, common fees, costs and latest terms', 'buyer', NULL, '', 80)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'บ้านเดี่ยว 2 ชั้น เลขที่ 113/83', 'บ้านเดี่ยว 2 ชั้นแปลงมุม เลขที่ 113/83 กาญจน์กนกวิลล์ 4 สันกำแพง รหัส SAM HL0253', 'https://npa.sam.or.th/site/images/npa/21741/20240829103244_HL0253P3_67.jpg', '/listing-media/sam/hl0253/01.webp', 'image/webp', 17318, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมบ้านและถนนสองด้าน', 'ภาพบ้านเลขที่ 113/83 บนแปลงมุมพร้อมถนนคอนกรีตสองด้าน', 'https://npa.sam.or.th/site/images/npa/21741/HL0253P4_67.jpg', '/listing-media/sam/hl0253/02.webp', 'image/webp', 13510, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางแยกข้างแปลงบ้าน', 'ภาพแนวแปลงบ้านและทางแยกถนนภายในกาญจน์กนกวิลล์ 4', 'https://npa.sam.or.th/site/images/npa/21741/HL0253P5_67.jpg', '/listing-media/sam/hl0253/03.webp', 'image/webp', 16192, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'จุดเลี้ยวเข้าถนนเลียบลำน้ำแม่โฮม', 'ภาพจุดเลี้ยวจากถนนสายดอนจั่น-ห้วยแก้ว ทล.1317 เข้าถนนเลียบลำน้ำแม่โฮม', 'https://npa.sam.or.th/site/images/npa/21741/HL0253P1_67.jpg', '/listing-media/sam/hl0253/04.webp', 'image/webp', 15004, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้าหมู่บ้านกาญจน์กนกวิลล์ 4', 'ภาพจุดเลี้ยวจากถนนเลียบลำน้ำแม่โฮมเข้าสู่หมู่บ้านกาญจน์กนกวิลล์ 4', 'https://npa.sam.or.th/site/images/npa/21741/HL0253P2_67.jpg', '/listing-media/sam/hl0253/05.webp', 'image/webp', 22346, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังแปลงมุมโฉนดเลขที่ 71574', 'ผังต้นทางแสดงแปลงเลขกำกับ 1129 ติดทางภายใต้การจัดสรรสองด้าน กว้างประมาณ 16 และ 18 เมตร', 'https://npa.sam.or.th/site/images/npa/21741/20240829103244_HL0253C1_67.jpg', '/listing-media/sam/hl0253/06.webp', 'image/webp', 12126, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังตำแหน่งบ้านสองชั้นบนแปลง', 'ผังต้นทางแสดงตำแหน่งบ้านเดี่ยว 2 ชั้นภายในแปลงมุมเลขกำกับ 1129', 'https://npa.sam.or.th/site/images/npa/21741/20240829103244_HL0253C2_67.jpg', '/listing-media/sam/hl0253/07.webp', 'image/webp', 13750, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปกาญจน์กนกวิลล์ 4', 'แผนที่ต้นทาง SAM แสดงเส้นทางจากถนนสายดอนจั่น-ห้วยแก้ว ทล.1317 ผ่านถนนเลียบลำน้ำแม่โฮมไปกาญจน์กนกวิลล์ 4', 'https://npa.sam.or.th/site/images/npa/21741/20240829103244_HL0253M_67.jpg', '/listing-media/sam/hl0253/08.webp', 'image/webp', 33160, 785, 600, 80, false, true);

    INSERT INTO public.listing_sources (
        listing_id, source_type, publisher_name, source_url,
        reference_code, captured_at, notes
    ) VALUES (
        property_listing_id,
        'editorial_import',
        'บริษัท บริหารสินทรัพย์สุขุมวิท จำกัด (SAM)',
        'https://www.sam.or.th/site/npa/detail.php?id=21741&keyref=6004858',
        'HL0253',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA page id 21741. The page showed direct-purchase status and an announced sale price of THB 2,920,000 for a two-storey detached house numbered 113/83 in Karnkanok Ville 4, San Kamphaeng, San Kamphaeng, Chiang Mai. Title deed no. 71574 covers 74 sq.wah / 296 sq.m. The registered transferred structure is described as a two-storey masonry residence numbered 113/83. The rectangular corner plot fronts two roads, approximately sixteen metres on the north and eighteen metres on the east. Soi 18 in Karnkanok Ville 4 is described as a concrete road in an authorized allocated development, approximately six metres wide within an approximately eight-metre right of way. The source identifies green planning zoning and residential surroundings. Bedroom count, bathroom count, usable area, parking count, building age, occupancy, flood history, common fees, internal utility condition and other encumbrances are not published, and there are no interior images. Exterior property photos display 5 April 2024. Administrator coordinates are approximately 0.90 metres from the rounded source coordinates and are used for the listing. The front-road wording in the source details contains typographical errors; the normalized project and soi name comes from the access directions and source images and requires SAM confirmation. MapxProp stores optimized copies of all eight unique source property, access, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Two-Storey Corner House in Karnkanok Ville 4, THB 2.92M',
        E'A two-storey detached house numbered 113/83, Moo 12, in Karnkanok Ville 4, San Kamphaeng, Chiang Mai. Title deed no. 71574, one document, covers 74 sq.wah (296 sq.m.). SAM identifies the registered transferred structure as a two-storey masonry residence numbered 113/83.\n\nThe rectangular corner plot fronts two roads. The north side is approximately sixteen metres wide, and the east side is approximately eighteen metres wide. Buyers should verify the title, survey, boundaries, measurements, directions, access, building registration, approved plans, permits and transferred structure.\n\nSoi 18 in Karnkanok Ville 4 is described as a concrete road in an authorized allocated development, approximately six metres wide within an approximately eight-metre right of way. SAM identifies green planning zoning and residential surroundings.\n\nSAM directions use Don Chan-Huai Kaeo Road, Highway 1317, from San Kamphaeng toward central Chiang Mai. Pass Kad Sri Arun and, near kilometre 6+80 as written by the source, turn left onto the Mae Hom riverside road for approximately one kilometre. Then turn left into Karnkanok Ville 4 and Soi 18 for a combined approximately 650 metres; the property is on the left. Nearby places listed by SAM include Wat San Pa Kha School, Wat San Pa Daeng and the PEA San Kamphaeng Substation.\n\nThe SAM page listed the property for direct purchase at an announced THB 2,920,000 when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, offer procedures, current price, promotions, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: HL0253. MapxProp does not collect deposits or represent SAM.\n\nExterior property photos display 5 April 2024, and conditions may have changed. SAM publishes no interior images and does not state bedroom count, bathroom count, usable area, parking count, building age, occupancy, flood history, common fees, internal electrical and plumbing condition or other encumbrances. Buyers should inspect the interior, structure, roof, cracks, moisture, termites, electrical and plumbing systems, drainage, boundaries, development rules, common fees, taxes, costs and every current term before deciding.\n\nSource-text note: the front-road wording in the SAM details contains typographical errors. Karnkanok Ville 4 Soi 18 is normalized from the access directions and source images and should be reconfirmed with SAM.',
        '113/83, Moo 12, Karnkanok Ville 4, Soi 18',
        'Access from Don Chan-Huai Kaeo Road, Highway 1317, via the Mae Hom riverside road',
        'Don Chan-Huai Kaeo Road, Highway 1317',
        'San Kamphaeng',
        'San Kamphaeng',
        'Chiang Mai',
        'SAM Corner House in Karnkanok Ville 4, THB 2.92M',
        'Official SAM asset HL0253: two-storey detached corner house on 74 sq.wah in Karnkanok Ville 4, San Kamphaeng. Direct-sale price THB 2.92M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset HL0253 detached house two storey corner plot 113/83 Moo 12 Karnkanok Ville 4 Soi 18 San Kamphaeng Chiang Mai Highway 1317 74 sq.wah 296 sq.m. title deed 71574 THB 2920000')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=21741&keyref=6004858'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=21741&keyref=6004858',
            'The official SAM NPA page identifies SAM as the asset holder and direct-sale contact for HL0253. Specifications, title deed, registered two-storey house, images, rounded coordinates, announced price, direct-purchase status, road measurements and planning-zone wording come from that page. The malformed front-road wording is normalized from the access text and images and remains subject to SAM confirmation.',
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
        'b0141625-7f5a-44a9-8385-bb4a803c6053',
        jsonb_build_object(
            'reference_code', 'HL0253',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'residence',
            'discovery_channels', jsonb_build_array('homes'),
            'title_document_count', 1,
            'registered_floor_count', 2,
            'bedroom_count_published', false,
            'bathroom_count_published', false,
            'corner_plot_two_road_frontages', true,
            'source_interior_images_published', false,
            'source_text_normalized', true,
            'source_image_count', 8
        )
    );
END $$;

COMMIT;
