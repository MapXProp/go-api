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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing HL0324';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing HL0324';
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
        '20941ebc-126f-4ee5-acad-8c0895de4121',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'detached_house',
        'residence',
        'sale',
        'whole_property',
        'กรีนวิวโฮม',
        '234/164',
        'ขายตรง SAM บ้านเดี่ยวชั้นเดียว กรีนวิวโฮม สันทราย 3 ห้องนอน 2 ห้องน้ำ ราคา 2.68 ล้านบาท',
        E'บ้านเดี่ยวชั้นเดียว เลขที่ 234/164 ในหมู่บ้านกรีนวิวโฮม ซอย 14 ตำบลหนองหาร อำเภอสันทราย จังหวัดเชียงใหม่ บนโฉนดที่ดินเลขที่ 106376 จำนวน 1 ฉบับ เนื้อที่ 56.3 ตร.ว. (225.2 ตร.ม.) หน้า SAM ระบุ 3 ห้องนอน 2 ห้องน้ำ และรายการรับโอนกรรมสิทธิ์ระบุสิ่งปลูกสร้างเป็นบ้านพักอาศัยตึกชั้นเดียว เลขที่ 234/164\n\nที่ดินเป็นรูปสี่เหลี่ยมจัตุรัส ด้านทิศตะวันออกติดถนนภายในโครงการ หน้ากว้างประมาณ 15 เมตร และลึกประมาณ 15 เมตร ผู้ซื้อควรตรวจโฉนด แนวเขต ขนาดจริง ทะเบียนอาคาร แบบแปลน ใบอนุญาต และรายการสิ่งปลูกสร้างที่จะได้รับโอนให้ตรงกับสภาพปัจจุบันก่อนเสนอซื้อ\n\nถนนผ่านหน้าทรัพย์เป็นถนนภายในหมู่บ้านกรีนวิวโฮม ซอย 14 ซึ่ง SAM ระบุว่าเป็นทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว ผิวจราจรคอนกรีตกว้างประมาณ 6 เมตร และเขตทางกว้างประมาณ 8 เมตร ทรัพย์อยู่ในเขตผังเมืองสีเหลืองและย่านที่อยู่อาศัย SAM ระบุว่าการคมนาคมสะดวก แต่การใช้ประโยชน์ กฎโครงการ ค่าส่วนกลาง และสภาพสาธารณูปโภคปัจจุบันต้องตรวจสอบเพิ่มเติม\n\nการเดินทางตาม SAM ใช้ถนนเชียงใหม่-พร้าว (ทล.1001) จากอำเภอเชียงดาวมุ่งหน้าอำเภอเมืองเชียงใหม่ ผ่านสำนักงานเทศบาลเมืองแม่โจ้ ตลาดแม่โจ้ โรงเรียนบ้านแม่โจ้ มหาวิทยาลัยแม่โจ้ และแยกมหาวิทยาลัยแม่โจ้ แล้วเลี้ยวขวาเข้าซอย 16 ชุมชนสหกรณ์นิคม 1 จากนั้นเลี้ยวขวาเข้าหมู่บ้านกรีนวิวโฮมและถนนภายในหมู่บ้านซอย 14 ทรัพย์อยู่ด้านขวามือ แผนที่ต้นทางแสดงระยะจากแนวถนนใหญ่ถึงบริเวณทรัพย์ประมาณ 480 เมตร\n\nหน้า SAM แสดงสถานะ “ซื้อตรง” และราคาประกาศขาย 2,680,000 บาท ณ วันที่ตรวจสอบ 10 กันยายน 2569 ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะผู้ครอบครอง และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ HL0324 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nภาพทรัพย์ต้นทางแสดงวันที่ 25 มิถุนายน 2567 สภาพจริงอาจเปลี่ยนแปลง ชุดภาพสาธารณะมีภาพภายนอกบ้านและทางเข้า แต่ไม่มีภาพภายใน หน้า SAM ไม่ได้เผยแพร่พื้นที่ใช้สอย จำนวนที่จอดรถ อายุอาคาร สถานะผู้ครอบครอง ประวัติน้ำท่วม ค่าส่วนกลาง รายละเอียดระบบไฟฟ้า-ประปาภายใน หรือภาระผูกพันอื่น ผู้ซื้อควรนัดตรวจโครงสร้าง หลังคา รอยร้าว ความชื้น ปลวก ระบบไฟฟ้าและประปา การระบายน้ำ แนวเขต กฎโครงการ ค่าส่วนกลาง ภาษี ค่าใช้จ่าย และเอกสารทั้งหมดก่อนตัดสินใจ',
        2680000,
        false,
        225.2,
        3,
        2,
        1,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        '234/164 หมู่บ้านกรีนวิวโฮม ซอย 14',
        'เข้าจากถนนเชียงใหม่-พร้าว (ทล.1001) ผ่านซอย 16 ชุมชนสหกรณ์นิคม 1',
        'ถนนภายในหมู่บ้านกรีนวิวโฮม ซอย 14',
        NULL,
        18.885257483462944,
        99.00286766388281,
        'เชียงใหม่',
        'สันทราย',
        'หนองหาร',
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
        'sam-direct-sale-single-storey-house-greenview-home-san-sai-hl0324'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 2680000, 'total', 'THB', false
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
            'official_page_reference_code', 'HL0324',
            'source_gallery_filename_reference_code', 'HL0324',
            'source_reference_code_discrepancy', false,
            'source_page_id', 21910,
            'project_name', 'กรีนวิวโฮม',
            'project_soi', 'ซอย 14',
            'listed_unit_number', '234/164',
            'title_document_type', 'chanote',
            'title_deed_number', '106376',
            'title_document_count', 1,
            'land_area_rai', 0,
            'land_area_ngan', 0,
            'land_area_square_wah_remainder', 56.3,
            'land_area_square_wah', 56.3,
            'land_area_sqm', 225.2,
            'bedroom_count', 3,
            'bathroom_count', 2,
            'registered_transfer_description', 'บ้านพักอาศัยตึกชั้นเดียว เลขที่ 234/164',
            'registered_floor_count', 1,
            'plot_count', 1,
            'plot_shape', 'square',
            'east_road_frontage_m_approx', 15,
            'maximum_depth_m_approx', 15,
            'front_road_name', 'ถนนภายในหมู่บ้านกรีนวิวโฮม ซอย 14',
            'source_address_road_name', 'ถนนสายเชียงใหม่-พร้าว (ทล.1001)',
            'front_road_legal_status_th', 'ทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว',
            'front_road_surface', 'concrete',
            'front_road_width_m_approx', 6,
            'front_right_of_way_width_m_approx', 8,
            'zoning_color_th', 'สีเหลือง',
            'surrounding_area_use_th', 'ย่านที่อยู่อาศัย',
            'mixed_use_classification', false,
            'mixed_use_exclusion_basis', 'SAM ระบุประเภททรัพย์เป็นบ้านเดี่ยวในโครงการที่อยู่อาศัยและไม่ได้ระบุการใช้เชิงธุรกิจหรือ Mixed Use',
            'residential_classification', true
        ) || jsonb_build_object(
            'transport_described_as_convenient_by_source', true,
            'source_map_distance_from_main_road_m_approx', 480,
            'source_public_gallery_has_interior_photos', false,
            'usable_area_not_published', true,
            'parking_information_not_published', true,
            'building_age_not_published', true,
            'occupancy_status_not_published', true,
            'flood_history_not_published', true,
            'common_fee_information_not_published', true,
            'internal_utilities_condition_not_published', true,
            'other_encumbrances_not_published', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'computed_price_per_square_wah', 47602.13,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_property_photo_date_displayed', '2024-06-25',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '18.885255,99.002868',
            'administrator_coordinate_distance_from_source_m_approx', 0.28,
            'online_pin_not_boundary_evidence', true
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
        'The official SAM NPA page identifies SAM as the asset holder and direct-sale contact for HL0324. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนเชียงใหม่-พร้าว (ทล.1001)', 'Chiang Mai-Phrao Highway 1001', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ซอย 16 ชุมชนสหกรณ์นิคม 1', 'Soi 16, Sahakorn Nikhom 1 Community', 'road', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'มหาวิทยาลัยแม่โจ้', 'Maejo University', 'education', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'สถานีตำรวจภูธรแม่โจ้', 'Mae Jo Police Station', 'government', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'สำนักงานเทศบาลเมืองแม่โจ้', 'Mae Jo Town Municipality Office', 'government', NULL, NULL, NULL, 50, true),
        (property_listing_id, 'ตลาดแม่โจ้', 'Mae Jo Market', 'shopping', NULL, NULL, NULL, 60, true),
        (property_listing_id, 'โรงเรียนบ้านแม่โจ้', 'Ban Mae Jo School', 'education', NULL, NULL, NULL, 70, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '2,680,000 บาท — โปรดตรวจสอบราคาล่าสุดและโปรโมชั่นกับ SAM', 'THB 2,680,000 — confirm the latest price and promotions with SAM', 'unspecified', 2680000, 'THB', 20),
        (property_listing_id, 'title_and_registered_house', 'เอกสารสิทธิ์และบ้านตามรายการรับโอน', 'Title and registered house', 'โฉนดเลขที่ 106376 จำนวน 1 ฉบับ เนื้อที่ 56.3 ตร.ว. พร้อมบ้านพักอาศัยตึกชั้นเดียว เลขที่ 234/164', 'Title deed no. 106376, one document, covering 56.3 sq.wah with a registered single-storey masonry residence numbered 234/164', 'unspecified', NULL, '', 30),
        (property_listing_id, 'rooms', 'ห้องนอนและห้องน้ำ', 'Bedrooms and bathrooms', 'SAM ระบุ 3 ห้องนอน 2 ห้องน้ำ', 'SAM lists three bedrooms and two bathrooms', 'unspecified', NULL, '', 40),
        (property_listing_id, 'plot_dimensions', 'ขนาดแนวแปลง', 'Plot dimensions', 'แปลงรูปสี่เหลี่ยมจัตุรัส ด้านทิศตะวันออกติดถนนกว้างประมาณ 15 เมตร ลึกประมาณ 15 เมตร', 'Square plot with approximately fifteen metres of east-side road frontage and approximately fifteen metres of depth', 'unspecified', 15, 'metres', 50),
        (property_listing_id, 'internal_project_road', 'ถนนภายในโครงการ', 'Internal development road', 'ถนนหมู่บ้านกรีนวิวโฮม ซอย 14 เป็นทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว ผิวคอนกรีตกว้างประมาณ 6 เมตร เขตทางประมาณ 8 เมตร', 'Greenview Home Soi 14 is an internal road in an authorized allocated development, with an approximately six-metre concrete carriageway in an eight-metre right of way', 'unspecified', 6, 'metres', 60),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนด แนวเขต ทะเบียนอาคาร แบบแปลน ใบอนุญาต สภาพบ้านและภายใน ระบบไฟฟ้า-ประปา น้ำท่วม การครอบครอง ภาระผูกพัน กฎโครงการ ค่าส่วนกลาง ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Verify title, boundaries, building registration, plans, permits, house and interior condition, electrical and plumbing systems, flooding, possession, encumbrances, development rules, common fees, costs and latest terms', 'buyer', NULL, '', 70)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'บ้านเดี่ยวชั้นเดียว เลขที่ 234/164', 'บ้านเดี่ยวชั้นเดียว เลขที่ 234/164 หมู่บ้านกรีนวิวโฮม สันทราย รหัส SAM HL0324', 'https://npa.sam.or.th/site/images/npa/21910/20240821111943_HL0324P3_67.jpg', '/listing-media/sam/hl0324/01.webp', 'image/webp', 19362, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมบ้านและถนนในซอย 14', 'ภาพมุมด้านข้างบ้านเลขที่ 234/164 และถนนคอนกรีตภายในหมู่บ้านกรีนวิวโฮม ซอย 14', 'https://npa.sam.or.th/site/images/npa/21910/HL0324P4_67.jpg', '/listing-media/sam/hl0324/02.webp', 'image/webp', 17396, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'จุดเลี้ยวจากถนนเชียงใหม่-พร้าว', 'ภาพจุดเลี้ยวจากถนนเชียงใหม่-พร้าว ทล.1001 เข้าซอย 16 ชุมชนสหกรณ์นิคม 1', 'https://npa.sam.or.th/site/images/npa/21910/HL0324P1_67.jpg', '/listing-media/sam/hl0324/03.webp', 'image/webp', 18848, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้าหมู่บ้านกรีนวิวโฮม', 'ภาพทางเข้าหมู่บ้านกรีนวิวโฮมจากซอย 16 ชุมชนสหกรณ์นิคม 1', 'https://npa.sam.or.th/site/images/npa/21910/HL0324P2_67.jpg', '/listing-media/sam/hl0324/04.webp', 'image/webp', 19864, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังตำแหน่งบ้านในกรีนวิวโฮม', 'ผังโครงการต้นทางแสดงตำแหน่งแปลงบ้านเลขที่ 234/164 ภายในหมู่บ้านกรีนวิวโฮม', 'https://npa.sam.or.th/site/images/npa/21910/HL0324C3_67.jpg', '/listing-media/sam/hl0324/05.webp', 'image/webp', 16732, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังแปลงโฉนดเลขที่ 106376', 'ผังต้นทางแสดงแปลงสี่เหลี่ยมจัตุรัสขนาดประมาณ 15 คูณ 15 เมตรและถนนด้านทิศตะวันออก', 'https://npa.sam.or.th/site/images/npa/21910/20240821111943_HL0324C1_67.jpg', '/listing-media/sam/hl0324/06.webp', 'image/webp', 14628, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังบ้านบนแปลงเลขที่ 234/164', 'ผังต้นทางแสดงตำแหน่งบ้านเดี่ยวชั้นเดียวเลขที่ 234/164 ระหว่างบ้านเลขที่ 234/163 และ 234/165', 'https://npa.sam.or.th/site/images/npa/21910/20240821111943_HL0324C2_67.jpg', '/listing-media/sam/hl0324/07.webp', 'image/webp', 14052, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปกรีนวิวโฮม', 'แผนที่ต้นทาง SAM แสดงเส้นทางจากถนนเชียงใหม่-พร้าว ทล.1001 ผ่านซอย 16 ชุมชนสหกรณ์นิคม 1 ไปหมู่บ้านกรีนวิวโฮม', 'https://npa.sam.or.th/site/images/npa/21910/20240821111943_HL0324M_67.jpg', '/listing-media/sam/hl0324/08.webp', 'image/webp', 42050, 785, 600, 80, false, true);

    INSERT INTO public.listing_sources (
        listing_id, source_type, publisher_name, source_url,
        reference_code, captured_at, notes
    ) VALUES (
        property_listing_id,
        'editorial_import',
        'บริษัท บริหารสินทรัพย์สุขุมวิท จำกัด (SAM)',
        'https://www.sam.or.th/site/npa/detail.php?id=21910&keyref=6004858',
        'HL0324',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA page id 21910. The page showed direct-purchase status and an announced sale price of THB 2,680,000 for a single-storey detached house numbered 234/164 in Greenview Home Soi 14, Nong Han, San Sai, Chiang Mai. Title deed no. 106376 covers 56.3 sq.wah / 225.2 sq.m. The source lists three bedrooms and two bathrooms and identifies the registered transferred structure as a single-storey masonry residence numbered 234/164. The square plot has approximately fifteen metres of east-side project-road frontage and approximately fifteen metres of depth. Greenview Home Soi 14 is described as an internal concrete road in an authorized allocated development, approximately six metres wide within an approximately eight-metre right of way. The source identifies yellow planning zoning, residential surroundings and convenient transport. The public gallery has two exterior property photographs, two access photographs, three site diagrams and one navigation map; it does not show the interior. Usable area, parking count, building age, occupancy, flood history, common fees, internal utility condition and other encumbrances are not published. Property images display 25 June 2024. Administrator coordinates are approximately 0.28 metres from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all eight unique source property, access, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Single-Storey House in Greenview Home, San Sai, THB 2.68M',
        E'A single-storey detached house numbered 234/164 in Greenview Home Soi 14, Nong Han, San Sai, Chiang Mai. Title deed no. 106376, one document, covers 56.3 sq.wah (225.2 sq.m.). SAM lists three bedrooms and two bathrooms and identifies the registered transferred structure as a single-storey masonry residence numbered 234/164.\n\nThe square plot has approximately fifteen metres of east-side frontage on the internal development road and approximately fifteen metres of depth. Buyers should verify the title, survey, boundaries, measurements, building registration, approved plans, permits and all structures included in the transfer against current conditions.\n\nGreenview Home Soi 14 is described as an internal concrete road in an authorized allocated development, approximately six metres wide within an approximately eight-metre right of way. SAM identifies yellow planning zoning and residential surroundings and describes convenient transport. Buyers should confirm current planning and building requirements, utility service, development rules and common fees.\n\nSAM directions use Chiang Mai-Phrao Highway 1001 from Chiang Dao toward central Chiang Mai, passing Mae Jo Town Municipality, Mae Jo Market, Ban Mae Jo School, Maejo University and the Maejo University intersection. Turn right into Soi 16, Sahakorn Nikhom 1 Community, then right into Greenview Home and follow the internal road to Soi 14. The property is on the right. The source map shows approximately 480 metres from the main-road area to the property.\n\nThe SAM page listed the property for direct purchase at an announced THB 2,680,000 when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, offer procedures, current price, promotions, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: HL0324. MapxProp does not collect deposits or represent SAM.\n\nProperty photos display 25 June 2024, and conditions may have changed. The public gallery shows exterior and access views but no interior. The source does not publish usable area, parking count, building age, occupancy, flood history, common fees, internal electrical and plumbing condition or other encumbrances. Buyers should inspect the interior, structure, roof, cracks, moisture, termites, electrical and plumbing systems, drainage, boundaries, development rules, common fees, taxes, costs and every current term before deciding.',
        '234/164, Greenview Home Soi 14',
        'Access from Chiang Mai-Phrao Highway 1001 through Soi 16, Sahakorn Nikhom 1 Community',
        'Greenview Home internal road, Soi 14',
        'Nong Han',
        'San Sai',
        'Chiang Mai',
        'SAM House in Greenview Home, San Sai, THB 2.68M',
        'Official SAM asset HL0324: single-storey house with three bedrooms and two bathrooms on 56.3 sq.wah in Greenview Home, San Sai. Direct-sale price THB 2.68M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset HL0324 detached house single storey 234/164 Greenview Home Soi 14 Nong Han San Sai Chiang Mai Highway 1001 56.3 sq.wah 225.2 sq.m. 3 bedrooms 2 bathrooms title deed 106376 THB 2680000')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=21910&keyref=6004858'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=21910&keyref=6004858',
            'The official SAM NPA page identifies SAM as the asset holder and direct-sale contact for HL0324. Specifications, title deed, registered house, images, rounded coordinates, announced price, direct-purchase status, road measurements and planning-zone wording come from that page.',
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
        '20941ebc-126f-4ee5-acad-8c0895de4121',
        jsonb_build_object(
            'reference_code', 'HL0324',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'residence',
            'discovery_channels', jsonb_build_array('homes'),
            'title_document_count', 1,
            'registered_floor_count', 1,
            'bedroom_count', 3,
            'bathroom_count', 2,
            'source_public_gallery_has_interior_photos', false,
            'source_image_count', 8
        )
    );
END $$;

COMMIT;
