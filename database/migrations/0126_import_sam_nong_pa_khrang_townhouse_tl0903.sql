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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing TL0903';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing TL0903';
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
        '60cd5457-cb55-4ee3-8d3b-0c2394f6d0e1',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'townhouse',
        'residence',
        'sale',
        'whole_property',
        NULL,
        '84/4',
        'ขายตรง SAM ทาวน์เฮ้าส์ 2 ชั้น หนองป่าครั่ง เมืองเชียงใหม่ 2 ห้องนอน ราคา 2.737 ล้านบาท',
        E'ทาวน์เฮ้าส์ 2 ชั้น เลขที่ 84/4 ตำบลหนองป่าครั่ง อำเภอเมืองเชียงใหม่ จังหวัดเชียงใหม่ บนโฉนดที่ดินเลขที่ 131144 จำนวน 1 ฉบับ เนื้อที่ 22.9 ตร.ว. (91.6 ตร.ม.) หน้า SAM ระบุ 2 ห้องนอน 2 ห้องน้ำ และรายการรับโอนกรรมสิทธิ์ระบุสิ่งปลูกสร้างเป็นทาวน์เฮ้าส์สองชั้น เลขที่ 84/4\n\nที่ดินเป็นรูปสี่เหลี่ยมผืนผ้า ด้านทิศเหนือติดถนน หน้ากว้างประมาณ 6 เมตร ลึกประมาณ 15.3 เมตร ผู้ซื้อควรตรวจโฉนด แนวเขต ขนาดจริง ทะเบียนอาคาร แบบแปลน ใบอนุญาต และยืนยันสิ่งปลูกสร้างที่จะได้รับโอนกับ SAM\n\nถนนผ่านหน้าทรัพย์เป็นทางส่วนบุคคลที่มีการจดภาระจำยอมแล้ว ผิวจราจรคอนกรีตกว้างประมาณ 6 เมตร และเขตทางกว้างประมาณ 8 เมตร SAM กำชับให้ผู้สนใจตรวจสอบสิทธิในการใช้ทางให้เป็นที่พึงพอใจก่อนเสนอซื้อ จึงควรตรวจเอกสารภาระจำยอม ขอบเขต ผู้มีสิทธิใช้ทาง ภาระบำรุงรักษา และการเข้าถึงจริงกับสำนักงานที่ดินและ SAM\n\nหน้า SAM ระบุเขตผังเมืองสีส้ม ทรัพย์อยู่ในย่านที่อยู่อาศัย มีสาธารณูปโภคครบครัน และใกล้สำนักงานเทศบาลตำบลหนองป่าครั่ง วัดบวกครกน้อย และวัดบวกครกหลวง ผู้ซื้อควรตรวจข้อกำหนดผังเมือง การใช้อาคาร และสภาพระบบสาธารณูปโภคปัจจุบันเพิ่มเติม\n\nการเดินทางตาม SAM ใช้ถนนสายเชียงใหม่-ออนหลวย (ทล.1006) จากสะพานนวรัฐมุ่งหน้าแยกบวกครกศิวิไล ผ่านแยกหนองประทีป แล้วเลี้ยวซ้ายเข้าซอยบ้านบวกครกน้อยประมาณ 400 เมตร เลี้ยวขวาประมาณ 120 เมตร จากนั้นเลี้ยวขวาเข้าซอย 6/1 และเลี้ยวขวาเข้าซอยที่ตั้งทรัพย์สิน รวมประมาณ 85 เมตร จะพบทาวน์เฮ้าส์อยู่ด้านซ้ายมือ\n\nหน้า SAM แสดงสถานะ “ซื้อตรง” และราคาประกาศขาย 2,737,000 บาท ณ วันที่ตรวจสอบ 10 กันยายน 2569 ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะผู้ครอบครอง และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ TL0903 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nภาพทรัพย์และภายในต้นทางแสดงวันที่ 20 มีนาคม 2569 สภาพจริงอาจเปลี่ยนแปลง หน้า SAM ไม่ได้เผยแพร่พื้นที่ใช้สอย จำนวนที่จอดรถ อายุอาคาร สถานะผู้ครอบครอง ประวัติน้ำท่วม ค่าส่วนกลาง สภาพระบบไฟฟ้า-ประปาภายใน หรือภาระผูกพันอื่น ผู้ซื้อควรนัดตรวจทั้งสองชั้น โครงสร้าง หลังคา ระเบียง บันได ห้องน้ำ รอยร้าว ความชื้น ปลวก ระบบไฟฟ้าและประปา การระบายน้ำ แนวเขต สิทธิทางเข้า ภาษี ค่าใช้จ่าย และเอกสารทั้งหมดก่อนตัดสินใจ',
        2737000,
        false,
        91.6,
        2,
        2,
        2,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        '84/4',
        'เข้าจากถนนสายเชียงใหม่-ออนหลวย (ทล.1006) ผ่านซอยบ้านบวกครกน้อยและซอย 6/1',
        'ซอยส่วนบุคคลที่จดภาระจำยอมแล้ว',
        NULL,
        18.784785278512565,
        99.03743569906136,
        'เชียงใหม่',
        'เมืองเชียงใหม่',
        'หนองป่าครั่ง',
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
        'sam-direct-sale-two-storey-townhouse-nong-pa-khrang-chiang-mai-tl0903'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 2737000, 'total', 'THB', false
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
            'official_page_reference_code', 'TL0903',
            'source_gallery_filename_reference_code', 'TL0903',
            'source_page_id', 23251,
            'listed_unit_number', '84/4',
            'title_document_type', 'chanote',
            'title_deed_number', '131144',
            'title_document_count', 1,
            'land_area_rai', 0,
            'land_area_ngan', 0,
            'land_area_square_wah_remainder', 22.9,
            'land_area_square_wah', 22.9,
            'land_area_sqm', 91.6,
            'bedroom_count', 2,
            'bathroom_count', 2,
            'registered_transfer_description', 'ทาวน์เฮ้าส์สองชั้น เลขที่ 84/4',
            'registered_floor_count', 2,
            'plot_count', 1,
            'plot_shape', 'rectangle',
            'north_road_frontage_m_approx', 6,
            'maximum_depth_m_approx', 15.3,
            'front_road_name', 'ซอยส่วนบุคคลที่จดภาระจำยอมแล้ว',
            'source_address_road_name', 'ถนนสายเชียงใหม่-ออนหลวย (ทล.1006)',
            'front_road_legal_status_th', 'ทางส่วนบุคคลที่มีการจดภาระจำยอมแล้ว',
            'front_road_surface', 'concrete',
            'front_road_width_m_approx', 6,
            'front_right_of_way_width_m_approx', 8,
            'access_right_requires_buyer_confirmation', true,
            'zoning_color_th', 'สีส้ม',
            'surrounding_area_use_th', 'ย่านที่อยู่อาศัย',
            'mixed_use_classification', false,
            'mixed_use_exclusion_basis', 'SAM ระบุประเภททรัพย์เป็นทาวน์เฮ้าส์และย่านโดยรอบเป็นที่อยู่อาศัย ไม่ได้ระบุการใช้เชิงธุรกิจหรือ Mixed Use',
            'residential_classification', true,
            'utilities_described_as_complete_by_source', true
        ) || jsonb_build_object(
            'usable_area_not_published', true,
            'parking_count_not_published', true,
            'building_age_not_published', true,
            'occupancy_status_not_published', true,
            'flood_history_not_published', true,
            'common_fee_information_not_published', true,
            'internal_utilities_condition_not_published', true,
            'other_encumbrances_not_published', true,
            'source_public_gallery_has_interior_photos', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'computed_price_per_square_wah', 119519.65,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_property_photo_date_displayed', '2026-03-20',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '18.784785,99.037436',
            'administrator_coordinate_distance_from_source_m_approx', 0.04,
            'online_pin_not_boundary_evidence', true,
            'source_reference_code_discrepancy', false
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
        'The official SAM NPA page identifies SAM as the asset holder and direct-sale contact for TL0903. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนสายเชียงใหม่-ออนหลวย (ทล.1006)', 'Chiang Mai-On Luai Highway 1006', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ซอยบ้านบวกครกน้อย', 'Ban Buak Krok Noi Soi', 'road', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'สำนักงานเทศบาลตำบลหนองป่าครั่ง', 'Nong Pa Khrang Subdistrict Municipality Office', 'government', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'วัดบวกครกน้อย', 'Wat Buak Krok Noi', 'landmark', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'วัดบวกครกหลวง', 'Wat Buak Krok Luang', 'landmark', NULL, NULL, NULL, 50, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '2,737,000 บาท — โปรดตรวจสอบราคาล่าสุดและโปรโมชั่นกับ SAM', 'THB 2,737,000 — confirm the latest price and promotions with SAM', 'unspecified', 2737000, 'THB', 20),
        (property_listing_id, 'title_and_registered_structure', 'เอกสารสิทธิ์และสิ่งปลูกสร้างตามรายการรับโอน', 'Title and registered structure', 'โฉนดเลขที่ 131144 จำนวน 1 ฉบับ เนื้อที่ 22.9 ตร.ว. พร้อมทาวน์เฮ้าส์สองชั้น เลขที่ 84/4', 'Title deed no. 131144, one document, covering 22.9 sq.wah with a registered two-storey townhouse numbered 84/4', 'unspecified', NULL, '', 30),
        (property_listing_id, 'rooms', 'ห้องนอนและห้องน้ำ', 'Bedrooms and bathrooms', 'SAM ระบุ 2 ห้องนอน 2 ห้องน้ำ', 'SAM lists two bedrooms and two bathrooms', 'unspecified', NULL, '', 40),
        (property_listing_id, 'plot_dimensions', 'ขนาดแนวแปลง', 'Plot dimensions', 'แปลงรูปสี่เหลี่ยมผืนผ้า ด้านทิศเหนือติดถนนกว้างประมาณ 6 เมตร ลึกประมาณ 15.3 เมตร', 'Rectangular plot with approximately six metres of north-side road frontage and approximately 15.3 metres of depth', 'unspecified', 6, 'metres', 50),
        (property_listing_id, 'private_easement_road', 'ถนนส่วนบุคคลและสิทธิทางเข้า', 'Private road and access rights', 'ถนนผ่านหน้าทรัพย์เป็นทางส่วนบุคคลที่มีการจดภาระจำยอมแล้ว ผิวคอนกรีตกว้างประมาณ 6 เมตร เขตทางประมาณ 8 เมตร ต้องตรวจสอบสิทธิในการใช้ทางก่อนเสนอซื้อ', 'The frontage road is a private road with a registered easement, an approximately six-metre concrete carriageway and an approximately eight-metre right of way; verify access rights before making an offer', 'buyer', 6, 'metres', 60),
        (property_listing_id, 'source_photo_date', 'วันที่ภาพต้นทาง', 'Source photo date', 'ภาพทรัพย์และภายในแสดงวันที่ 20 มีนาคม 2569 สภาพจริงอาจเปลี่ยนแปลง', 'Property and interior photos display 20 March 2026; current conditions may differ', 'unspecified', NULL, '', 70),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนด แนวเขต ภาระจำยอมและสิทธิทางเข้า ทะเบียนอาคาร แบบแปลน ใบอนุญาต สภาพทั้งสองชั้น ระบบไฟฟ้า-ประปา น้ำท่วม การครอบครอง ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Verify title, boundaries, easement and access rights, building records, plans, permits, both-floor condition, electrical and plumbing systems, flooding, possession, encumbrances, costs and latest terms', 'buyer', NULL, '', 80)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ทาวน์เฮ้าส์ 2 ชั้น เลขที่ 84/4', 'ทาวน์เฮ้าส์ 2 ชั้น เลขที่ 84/4 หนองป่าครั่ง เมืองเชียงใหม่ รหัส SAM TL0903', 'https://npa.sam.or.th/site/images/npa/23251/20260429093215_TL0903P5_69.jpg', '/listing-media/sam/tl0903/01.webp', 'image/webp', 21342, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ชั้นล่างมองจากด้านหน้า', 'ภาพภายในชั้นล่างของทาวน์เฮ้าส์เลขที่ 84/4 มองจากประตูด้านหน้าไปด้านหลัง', 'https://npa.sam.or.th/site/images/npa/23251/TL0903P7_69.jpg', '/listing-media/sam/tl0903/02.webp', 'image/webp', 7980, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ชั้นล่างและบันได', 'ภาพภายในชั้นล่างบริเวณด้านหลังและบันไดขึ้นชั้นสอง', 'https://npa.sam.or.th/site/images/npa/23251/TL0903P8_69.jpg', '/listing-media/sam/tl0903/03.webp', 'image/webp', 11416, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนด้านหน้าชั้นสอง', 'ภาพห้องนอนด้านหน้าชั้นสองพร้อมประตูกระจกออกสู่ระเบียง', 'https://npa.sam.or.th/site/images/npa/23251/TL0903P10_69.jpg', '/listing-media/sam/tl0903/04.webp', 'image/webp', 16098, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนอีกห้อง', 'ภาพห้องนอนอีกห้องบนชั้นสองของทาวน์เฮ้าส์', 'https://npa.sam.or.th/site/images/npa/23251/TL0903P11_69.jpg', '/listing-media/sam/tl0903/05.webp', 'image/webp', 13630, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ระเบียงชั้นสอง', 'ภาพระเบียงชั้นสองและพื้นที่ด้านหลังทาวน์เฮ้าส์', 'https://npa.sam.or.th/site/images/npa/23251/TL0903P13_69.jpg', '/listing-media/sam/tl0903/06.webp', 'image/webp', 42986, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำภายในทาวน์เฮ้าส์', 'ภาพห้องน้ำภายในทาวน์เฮ้าส์เลขที่ 84/4', 'https://npa.sam.or.th/site/images/npa/23251/TL0903P9_69.jpg', '/listing-media/sam/tl0903/07.webp', 'image/webp', 14452, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'จุดเลี้ยวจากถนนสายเชียงใหม่-ออนหลวย', 'ภาพจุดเลี้ยวจากถนนสายเชียงใหม่-ออนหลวย ทล.1006 เข้าซอยบ้านบวกครกน้อย', 'https://npa.sam.or.th/site/images/npa/23251/TL0903P1_69.jpg', '/listing-media/sam/tl0903/08.webp', 'image/webp', 19754, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'เส้นทางในซอยบ้านบวกครกน้อย', 'ภาพเส้นทางในซอยบ้านบวกครกน้อยบริเวณจุดเลี้ยวเข้าซอยไม่มีชื่อ', 'https://npa.sam.or.th/site/images/npa/23251/TL0903P2_69.jpg', '/listing-media/sam/tl0903/09.webp', 'image/webp', 20482, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'จุดเลี้ยวเข้าซอย 6/1', 'ภาพจุดเลี้ยวจากซอยไม่มีชื่อเข้าสู่ซอย 6/1 ตามเส้นทางของ SAM', 'https://npa.sam.or.th/site/images/npa/23251/TL0903P3_69.jpg', '/listing-media/sam/tl0903/10.webp', 'image/webp', 16614, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ซอยส่วนบุคคลใกล้ทรัพย์', 'ภาพซอยส่วนบุคคลที่จดภาระจำยอมแล้วบริเวณทางเข้าสู่ทาวน์เฮ้าส์', 'https://npa.sam.or.th/site/images/npa/23251/TL0903P4_69.jpg', '/listing-media/sam/tl0903/11.webp', 'image/webp', 29188, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังพื้นทาวน์เฮ้าส์สองชั้น', 'ผังพื้นต้นทาง SAM แสดงการจัดพื้นที่ชั้นล่างและชั้นบนของทาวน์เฮ้าส์', 'https://npa.sam.or.th/site/images/npa/23251/TL0903C3_69.jpg', '/listing-media/sam/tl0903/12.webp', 'image/webp', 20878, 450, 450, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังแปลงโฉนดเลขที่ 131144', 'ผังต้นทางแสดงแปลงสี่เหลี่ยมผืนผ้าหน้ากว้างประมาณ 6 เมตรและลึกประมาณ 15.3 เมตร', 'https://npa.sam.or.th/site/images/npa/23251/20260429093215_TL0903C1_69.jpg', '/listing-media/sam/tl0903/13.webp', 'image/webp', 24908, 450, 450, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ตำแหน่งทาวน์เฮ้าส์บนแปลง', 'ผังต้นทางแสดงตำแหน่งอาคารทาวน์เฮ้าส์สองชั้นบนแปลงและซอยด้านทิศเหนือ', 'https://npa.sam.or.th/site/images/npa/23251/20260429093215_TL0903C2_69.jpg', '/listing-media/sam/tl0903/14.webp', 'image/webp', 25328, 450, 450, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปทาวน์เฮ้าส์ TL0903', 'แผนที่ต้นทาง SAM แสดงเส้นทางจากถนนสายเชียงใหม่-ออนหลวยผ่านซอยบ้านบวกครกน้อยไปยังทรัพย์', 'https://npa.sam.or.th/site/images/npa/23251/20260429093215_TL0903M_69.jpg', '/listing-media/sam/tl0903/15.webp', 'image/webp', 42564, 785, 600, 150, false, true);

    INSERT INTO public.listing_sources (
        listing_id, source_type, publisher_name, source_url,
        reference_code, captured_at, notes
    ) VALUES (
        property_listing_id,
        'editorial_import',
        'บริษัท บริหารสินทรัพย์สุขุมวิท จำกัด (SAM)',
        'https://www.sam.or.th/site/npa/detail.php?id=23251&keyref=6004858',
        'TL0903',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA page id 23251. The page showed direct-purchase status and an announced sale price of THB 2,737,000 for a two-storey townhouse numbered 84/4 in Nong Pa Khrang, Mueang Chiang Mai, Chiang Mai. Title deed no. 131144 covers 22.9 sq.wah / 91.6 sq.m. The source lists two bedrooms and two bathrooms and identifies the registered transferred structure as a two-storey townhouse numbered 84/4. The rectangular plot has approximately six metres of north-side road frontage and approximately 15.3 metres of depth. The frontage road is a private road with a registered easement, an approximately six-metre concrete carriageway and an approximately eight-metre right of way; SAM explicitly advises buyers to verify access rights before making an offer. The source identifies orange planning zoning, residential surroundings and complete utilities. Usable area, parking count, building age, occupancy, flood history, common fees, internal utility condition and other encumbrances are not published. Property and interior photos visibly display 20 March 2026. The public gallery has seven property and interior photographs, four access photographs, three site or floor diagrams and one navigation map. Administrator coordinates are approximately 0.04 metres from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all fifteen unique source property, interior, access, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Two-Storey Townhouse in Nong Pa Khrang, Chiang Mai, THB 2.737M',
        E'A two-storey townhouse numbered 84/4 in Nong Pa Khrang, Mueang Chiang Mai, Chiang Mai. Title deed no. 131144, one document, covers 22.9 sq.wah (91.6 sq.m.). SAM lists two bedrooms and two bathrooms and identifies the registered transferred structure as a two-storey townhouse numbered 84/4.\n\nThe rectangular plot has approximately six metres of north-side road frontage and approximately 15.3 metres of depth. Buyers should verify the title, survey, boundaries, measurements, building registration, approved plans, permits and all structures included in the transfer against current conditions.\n\nThe frontage road is a private road with a registered easement. SAM describes an approximately six-metre concrete carriageway within an approximately eight-metre right of way and explicitly advises prospective buyers to verify that the access right is satisfactory before making an offer. Buyers should inspect the easement registration, extent, eligible users, maintenance obligations and actual access with the Land Office and SAM.\n\nSAM identifies orange planning zoning, residential surroundings and complete utilities. Nearby places named by SAM include Nong Pa Khrang Subdistrict Municipality Office, Wat Buak Krok Noi and Wat Buak Krok Luang. Buyers should confirm current planning and building requirements, permitted use and utility condition.\n\nSAM directions use Chiang Mai-On Luai Highway 1006 from Nawarat Bridge toward Buak Krok Siwilai Intersection, passing Nong Prathip Intersection. Turn left into Ban Buak Krok Noi Soi for approximately 400 metres, turn right for approximately 120 metres, then right into Soi 6/1 and right again into the property lane. Continue approximately 85 metres; the property is on the left.\n\nThe SAM page listed the property for direct purchase at an announced THB 2,737,000 when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, offer procedures, current price, promotions, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: TL0903. MapxProp does not collect deposits or represent SAM.\n\nProperty and interior photos display 20 March 2026, and conditions may have changed. The source does not publish usable area, parking count, building age, occupancy, flood history, common fees, internal electrical and plumbing condition or other encumbrances. Buyers should inspect both floors, structure, roof, balcony, stairs, bathrooms, cracks, moisture, termites, electrical and plumbing systems, drainage, boundaries, access rights, taxes, costs and every current term before deciding.',
        '84/4',
        'Access from Chiang Mai-On Luai Highway 1006 through Ban Buak Krok Noi Soi and Soi 6/1',
        'Private easement lane',
        'Nong Pa Khrang',
        'Mueang Chiang Mai',
        'Chiang Mai',
        'SAM Townhouse in Nong Pa Khrang, Chiang Mai, THB 2.737M',
        'Official SAM asset TL0903: two-storey townhouse with two bedrooms and two bathrooms on 22.9 sq.wah in Nong Pa Khrang, Chiang Mai. Direct-sale price THB 2.737M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset TL0903 townhouse two storey 84/4 Nong Pa Khrang Mueang Chiang Mai Chiang Mai Highway 1006 22.9 sq.wah 91.6 sq.m. 2 bedrooms 2 bathrooms title deed 131144 private easement road THB 2737000')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=23251&keyref=6004858'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=23251&keyref=6004858',
            'The official SAM NPA page identifies SAM as the asset holder and direct-sale contact for TL0903. Specifications, title deed, registered townhouse, images, rounded coordinates, announced price, direct-purchase status, easement wording, road measurements and planning-zone wording come from that page.',
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
        '60cd5457-cb55-4ee3-8d3b-0c2394f6d0e1',
        jsonb_build_object(
            'reference_code', 'TL0903',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'residence',
            'discovery_channels', jsonb_build_array('homes'),
            'title_document_count', 1,
            'registered_floor_count', 2,
            'bedroom_count', 2,
            'bathroom_count', 2,
            'private_easement_road_reported', true,
            'source_public_gallery_has_interior_photos', true,
            'source_image_count', 15
        )
    );
END $$;

COMMIT;
