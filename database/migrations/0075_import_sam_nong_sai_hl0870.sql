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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing HL0870';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing HL0870';
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
        '32f7ee29-eb1b-4c07-80ba-f8b5aade1e4c',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'detached_house',
        'residential',
        'sale',
        'whole_property',
        'เดอะ เนจอร์ ลิฟวิ่งโฮม',
        'ขายตรง SAM บ้านเดี่ยวชั้นเดียว เดอะ เนจอร์ ลิฟวิ่งโฮม พุนพิน 40 ตร.ว. ราคา 1.4 ล้านบาท',
        E'บ้านเดี่ยวชั้นเดียว เลขที่ 55/13 หมู่บ้านเดอะ เนจอร์ ลิฟวิ่งโฮม ถนนสายหนองไทร-บ้านยางงาม ตำบลหนองไทร อำเภอพุนพิน จังหวัดสุราษฎร์ธานี มี 2 ห้องนอน 2 ห้องน้ำ บนที่ดิน 40 ตร.ว. (160 ตร.ม.) โฉนดที่ดินเลขที่ 44878 จำนวน 1 ฉบับ\n\nแปลงที่ดินรูปคล้ายสี่เหลี่ยมขนมเปียกปูน ด้านทิศเหนือติดถนนภายในหมู่บ้าน หน้ากว้างประมาณ 10 เมตร ลึกประมาณ 16 เมตร SAM ระบุสิ่งปลูกสร้างที่รับโอนเป็นบ้านพักอาศัยตึกชั้นเดียว เลขที่ 55/13 ถนนหน้าทรัพย์เป็นทางสาธารณประโยชน์ ผิวจราจรคอนกรีตกว้างประมาณ 6 เมตร เขตทางกว้างประมาณ 8 เมตร อยู่ในเขตผังเมืองสีเขียว ย่านที่อยู่อาศัยและเกษตรกรรม การเดินทางสะดวก\n\nข้อควรตรวจสอบ: SAM ระบุว่าทรัพย์อยู่ในเขตปลอดภัยในการเดินอากาศตามประกาศกระทรวงคมนาคม พ.ศ.2535 สำหรับบริเวณใกล้เคียงสนามบินหัวเตย ตำบลหนองไทร อำเภอพุนพิน ผู้ซื้อต้องตรวจสอบข้อจำกัดที่เกี่ยวข้องกับการต่อเติม ความสูงอาคาร และการใช้ประโยชน์กับหน่วยงานที่รับผิดชอบก่อนเสนอซื้อ\n\nผังแบบแปลนต้นทางมีตัวเลขกำกับ 76.40 ภายในตัวบ้านและ 21.00 บริเวณส่วนโล่ง แต่หน้า SAM ไม่ได้ระบุหน่วยหรือยืนยันว่าเป็นพื้นที่ใช้สอย จึงไม่ได้นำตัวเลขดังกล่าวมากรอกเป็นพื้นที่ใช้สอย ผู้ซื้อควรขอเอกสารแบบแปลนและรายละเอียดอาคารจาก SAM เพื่อตรวจสอบอีกครั้ง\n\nการเดินทางจากถนนสายเอเชีย (ทล.41) บริเวณทางแยกต่างระดับท่าเรือมุ่งหน้าอำเภอไชยา ผ่านแยกหนองจรีและสหกรณ์สุราษฎร์ธานี เลี้ยวซ้ายเข้าถนนสายหนองไทร-บ้านยางงามประมาณ 1.5 กิโลเมตร เลี้ยวขวาเข้าถนนยางงาม 5 ประมาณ 700 เมตร ถึงห้าแยกให้เลี้ยวซ้ายไปหมู่บ้านเดอะ เนจอร์ ลิฟวิ่งโฮมประมาณ 400 เมตร แล้วเลี้ยวซ้ายเข้าถนนภายในหมู่บ้านอีกประมาณ 20 เมตร ทรัพย์อยู่ด้านขวามือ สถานที่ใกล้เคียงที่ SAM ระบุ ได้แก่ สหกรณ์สุราษฎร์ธานี วัดยางงาม และท่าอากาศยานนานาชาติสุราษฎร์ธานี\n\nหน้า SAM ระบุสถานะ “ซื้อตรง” และราคาประกาศขาย 1,400,000 บาท ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย สถานะผู้ครอบครอง สภาพบ้าน ขั้นตอนเสนอซื้อ ราคา ค่าใช้จ่าย และเงื่อนไขล่าสุด โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ HL0870 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nหน้าต้นทางไม่ระบุพื้นที่ใช้สอยอย่างยืนยันได้ ที่จอดรถ อายุอาคาร สถานะผู้ใช้ประโยชน์ ภาระผูกพัน หรือสภาพระบบไฟฟ้าและประปาภายใน ภาพตัวบ้านและภายในมีวันที่กำกับ 25 มีนาคม 2568 ผู้ซื้อควรนัดตรวจบ้าน ตรวจเอกสารสิทธิ์ รายการสิ่งปลูกสร้าง แนวเขต และข้อจำกัดเขตการบินก่อนตัดสินใจ',
        1400000,
        false,
        160,
        2,
        2,
        1,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'บ้านเลขที่ 55/13 หมู่บ้านเดอะ เนจอร์ ลิฟวิ่งโฮม',
        'ถนนสายหนองไทร-บ้านยางงาม',
        'ถนนสายหนองไทร-บ้านยางงาม',
        NULL,
        9.11454320,
        99.14079611,
        'สุราษฎร์ธานี',
        'พุนพิน',
        'หนองไทร',
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
        'sam-direct-sale-single-storey-house-the-nature-living-home-nong-sai-phunphin-hl0870'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 1400000, 'total', 'THB', false
    )
    ON CONFLICT (listing_id, offer_type) DO UPDATE SET
        amount = EXCLUDED.amount,
        price_unit = EXCLUDED.price_unit,
        currency_code = EXCLUDED.currency_code,
        is_negotiable = EXCLUDED.is_negotiable,
        updated_at = now();

    INSERT INTO public.listing_discovery_channels (
        listing_id, channel_code, source, is_featured
    ) VALUES (
        property_listing_id, 'homes', 'editorial', false
    )
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
            'project_name', 'เดอะ เนจอร์ ลิฟวิ่งโฮม',
            'house_number', '55/13',
            'land_area_square_wah', 40,
            'land_area_total_square_wah', 40,
            'land_area_sqm', 160,
            'title_deed_number', '44878',
            'title_document_count', 1,
            'floor_count', 1,
            'bedroom_count', 2,
            'bathroom_count', 2,
            'registered_transferred_structure_count', 1,
            'registered_transferred_structure', 'บ้านพักอาศัยตึกชั้นเดียว เลขที่ 55/13',
            'plot_shape', 'rhombus_like',
            'north_road_frontage_m', 10,
            'maximum_depth_m', 16,
            'front_road_name', 'ถนนภายในหมู่บ้านเดอะ เนจอร์ ลิฟวิ่งโฮม',
            'access_type', 'public_road',
            'front_road_surface', 'concrete',
            'front_road_width_m', 6,
            'front_right_of_way_width_m', 8,
            'zoning_color_th', 'สีเขียว',
            'surrounding_area_use_th', 'ที่อยู่อาศัยและเกษตรกรรม',
            'aviation_safety_zone', true,
            'aviation_safety_zone_airport_th', 'สนามบินหัวเตย',
            'aviation_safety_zone_announcement_year_be', 2535,
            'aviation_restrictions_require_buyer_verification', true,
            'source_floor_plan_main_area_annotation', 76.40,
            'source_floor_plan_open_area_annotation', 21.00,
            'source_floor_plan_annotation_unit_not_published', true,
            'usable_area_not_confirmed', true,
            'parking_information_not_published', true,
            'building_age_not_published', true,
            'occupancy_status_not_published', true,
            'internal_utilities_condition_not_published', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-09',
            'source_property_photo_date_displayed', '2025-03-25',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '9.114516,99.140818',
            'administrator_coordinate_distance_from_source_m_approx', 3.9
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for HL0870. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนสายเอเชีย (ทล.41)', 'Asian Highway 2 / Highway 41', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ท่าอากาศยานนานาชาติสุราษฎร์ธานี', 'Surat Thani International Airport', 'transit', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'สหกรณ์สุราษฎร์ธานี', 'Surat Thani Cooperative', 'landmark', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'วัดยางงาม', 'Wat Yang Ngam', 'landmark', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'ถนนสายหนองไทร-บ้านยางงาม', 'Nong Sai-Ban Yang Ngam Road', 'road', NULL, NULL, NULL, 50, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '1,400,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 1,400,000 — confirm the latest price with SAM', 'unspecified', 1400000, 'THB', 20),
        (property_listing_id, 'title_and_structure', 'เอกสารสิทธิ์และสิ่งปลูกสร้าง', 'Title and structure', 'โฉนดเลขที่ 44878 จำนวน 1 ฉบับ พร้อมบ้านพักอาศัยตึกชั้นเดียวเลขที่ 55/13', 'Title deed no. 44878, one document, with single-storey residence no. 55/13', 'unspecified', NULL, '', 30),
        (property_listing_id, 'aviation_safety_zone', 'เขตปลอดภัยในการเดินอากาศ', 'Aviation safety zone', 'ทรัพย์อยู่ในเขตปลอดภัยในการเดินอากาศใกล้สนามบินหัวเตยตามประกาศ พ.ศ.2535 ผู้ซื้อต้องตรวจสอบข้อจำกัดก่อนต่อเติมหรือเปลี่ยนการใช้ประโยชน์', 'The property is within the Hua Toei Airport aviation safety zone under a 1992 announcement; buyers must verify restrictions before alterations or changes of use', 'buyer', NULL, '', 40),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ผู้ซื้อต้องตรวจสอบสภาพบ้าน พื้นที่ใช้สอยจริง สถานะผู้ครอบครอง เอกสารสิทธิ์ แนวเขต ภาระผูกพัน และเงื่อนไขล่าสุดด้วยตนเอง', 'The buyer must independently verify the house condition, actual usable area, occupancy, title, boundaries, encumbrances, and current terms', 'buyer', NULL, '', 50)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ด้านหน้าบ้าน', 'บ้านเดี่ยวชั้นเดียวเลขที่ 55/13 ในหมู่บ้านเดอะ เนจอร์ ลิฟวิ่งโฮม', 'https://npa.sam.or.th/site/images/npa/23302/20260527103343_HL0870P3_69.jpg', '/listing-media/sam/hl0870/01.webp', 'image/webp', 14072, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้าจากถนนสายเอเชีย', 'จุดเลี้ยวจากถนนสายเอเชีย ทล.41 เข้าถนนสายหนองไทร-บ้านยางงาม', 'https://npa.sam.or.th/site/images/npa/23302/HL0870P1_69.jpg', '/listing-media/sam/hl0870/02.webp', 'image/webp', 16650, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้าหมู่บ้าน', 'จุดเลี้ยวเข้าสู่หมู่บ้านเดอะ เนจอร์ ลิฟวิ่งโฮม', 'https://npa.sam.or.th/site/images/npa/23302/HL0870P2_69.jpg', '/listing-media/sam/hl0870/03.webp', 'image/webp', 19116, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บ้านและถนนภายในหมู่บ้าน', 'มุมกว้างด้านหน้าบ้านและถนนคอนกรีตภายในหมู่บ้าน', 'https://npa.sam.or.th/site/images/npa/23302/HL0870P4_69.jpg', '/listing-media/sam/hl0870/04.webp', 'image/webp', 16230, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวหน้าบ้านอีกมุม', 'แนวรั้วและด้านหน้าบ้านเดี่ยวชั้นเดียวมองตามแนวถนนหมู่บ้าน', 'https://npa.sam.or.th/site/images/npa/23302/HL0870P5_69.jpg', '/listing-media/sam/hl0870/05.webp', 'image/webp', 14492, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ส่วนหน้าหลังคาคลุม', 'พื้นที่ส่วนหน้าของบ้านพร้อมหลังคาคลุมและทางเข้าตัวบ้าน', 'https://npa.sam.or.th/site/images/npa/23302/HL0870P6_69.jpg', '/listing-media/sam/hl0870/06.webp', 'image/webp', 22524, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงภายในบ้าน', 'พื้นที่โถงภายในบ้านตามภาพต้นทาง SAM', 'https://npa.sam.or.th/site/images/npa/23302/HL0870P7_69.jpg', '/listing-media/sam/hl0870/07.webp', 'image/webp', 5312, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอน', 'ห้องนอนภายในบ้านพร้อมหน้าต่างตามภาพต้นทาง', 'https://npa.sam.or.th/site/images/npa/23302/HL0870P8_69.jpg', '/listing-media/sam/hl0870/08.webp', 'image/webp', 5472, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ห้องภายใน', 'มุมมองพื้นที่ห้องภายในบ้านและช่องแสงธรรมชาติ', 'https://npa.sam.or.th/site/images/npa/23302/HL0870P9_69.jpg', '/listing-media/sam/hl0870/09.webp', 'image/webp', 6454, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ครัว', 'พื้นที่ครัวภายในบ้านตามภาพต้นทาง SAM', 'https://npa.sam.or.th/site/images/npa/23302/HL0870P10_69.jpg', '/listing-media/sam/hl0870/10.webp', 'image/webp', 5596, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำ', 'ห้องน้ำภายในบ้านพร้อมสุขภัณฑ์ตามภาพต้นทาง', 'https://npa.sam.or.th/site/images/npa/23302/HL0870P12_69.jpg', '/listing-media/sam/hl0870/11.webp', 'image/webp', 10530, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังสิ่งปลูกสร้างในแปลง', 'ผังแสดงบ้านชั้นเดียวภายในแนวที่ดินและถนนหมู่บ้านด้านหน้า', 'https://npa.sam.or.th/site/images/npa/23302/20260527103343_HL0870C1_69.jpg', '/listing-media/sam/hl0870/12.webp', 'image/webp', 14644, 450, 450, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังรูปแปลงที่ดิน', 'ผังโฉนดเลขที่ 44878 แสดงแนวแปลงกว้างประมาณ 10 เมตรและลึกประมาณ 16 เมตร', 'https://npa.sam.or.th/site/images/npa/23302/20260527103343_HL0870C2_69.jpg', '/listing-media/sam/hl0870/13.webp', 'image/webp', 10630, 450, 450, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แบบแปลนบ้านชั้นเดียว', 'แบบแปลนต้นทางแสดงโถง ห้องครัว ห้องนอน 2 ห้อง ห้องน้ำ 2 ห้อง และส่วนโล่ง', 'https://npa.sam.or.th/site/images/npa/23302/HL0870C3_69.jpg', '/listing-media/sam/hl0870/14.webp', 'image/webp', 5930, 450, 450, 140, false, true);

    INSERT INTO public.listing_sources (
        listing_id, source_type, publisher_name, source_url,
        reference_code, captured_at, notes
    ) VALUES (
        property_listing_id,
        'editorial_import',
        'บริษัท บริหารสินทรัพย์สุขุมวิท จำกัด (SAM)',
        'https://www.sam.or.th/site/npa/detail.php?id=23302&keyref=',
        'HL0870',
        '2026-09-09 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 1,400,000 for a single-storey detached house, no. 55/13, with two bedrooms and two bathrooms on title deed no. 44878 covering 40 sq.wah / 160 sq.m. The source describes a rhombus-like plot with approximately 10 meters of north-side road frontage and approximately 16 meters of depth on a public concrete village road approximately 6 meters wide within an 8-meter right of way. SAM states that the property lies within the 1992 Hua Toei Airport aviation safety zone. The source floor-plan image contains numeric annotations 76.40 and 21.00 but the page does not publish their unit or confirm usable area, so no usable-area value is asserted. Source coordinates are 9.114516,99.140818; administrator-supplied coordinates approximately 3.9 meters away are used. Property and interior photos display 25 March 2025. Parking, building age, occupancy, encumbrances, and internal utility condition are not published. SAM''s schematic area map was excluded; MapxProp stores optimized copies of eleven source photos and three diagrams without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Single-Storey House at The Nature Living Home, Phunphin, THB 1.4M',
        E'Single-storey detached house, no. 55/13, in The Nature Living Home village on Nong Sai-Ban Yang Ngam Road, Nong Sai, Phunphin, Surat Thani. The house has two bedrooms and two bathrooms. Title deed no. 44878 covers 40 sq.wah or 160 sq.m.\n\nThe rhombus-like plot has approximately 10 meters of north-side village-road frontage and a maximum depth of approximately 16 meters. SAM identifies the transferred structure as a single-storey masonry residence, no. 55/13. The public concrete village road is approximately 6 meters wide within an approximately 8-meter right of way. The source identifies green zoning in a residential and agricultural area.\n\nImportant: SAM states that the property is within the aviation safety zone near Hua Toei Airport under a 1992 Ministry of Transport announcement. Buyers must verify restrictions affecting building alterations, height, and permitted use with the responsible authorities before submitting an offer.\n\nThe source floor-plan image contains the numeric annotations 76.40 within the house and 21.00 in the open area, but the SAM page does not state their units or confirm that they represent usable area. These figures are therefore not published as verified usable area. Buyers should request the building plan and structure records from SAM for confirmation.\n\nAccess is from Highway 41 toward Chaiya, passing Nong Chari Intersection and the Surat Thani Cooperative. Turn left onto Nong Sai-Ban Yang Ngam Road for approximately 1.5 kilometers, right onto Yang Ngam 5 Road for approximately 700 meters, then left toward The Nature Living Home for approximately 400 meters. Turn left onto the internal village road for approximately 20 meters; the property is on the right. Nearby places listed by SAM include Wat Yang Ngam and Surat Thani International Airport.\n\nThe SAM page lists the property for direct purchase at an announced sale price of THB 1,400,000. It is not an auction. Contact SAM directly to confirm availability, current occupancy, house condition, offer procedure, current price, expenses, and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: HL0870. MapxProp does not collect deposits or represent SAM in the transaction.\n\nThe source does not confirm usable area, parking, building age, occupancy, encumbrances, or internal electrical and plumbing condition. Property and interior photos display 25 March 2025. Buyers should inspect the house and verify the title, registered structure, boundaries, aviation-zone restrictions, and current conditions before deciding.',
        'House No. 55/13, The Nature Living Home',
        'Nong Sai-Ban Yang Ngam Road',
        'Nong Sai-Ban Yang Ngam Road',
        'Nong Sai',
        'Phunphin',
        'Surat Thani',
        'SAM Direct-Sale House at The Nature Living Home, Phunphin',
        'Official SAM asset HL0870: a two-bedroom, two-bathroom single-storey house on 40 sq.wah in Nong Sai, Phunphin. Direct-sale price THB 1.4M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset HL0870 single storey detached house The Nature Living Home Nong Sai Phunphin Surat Thani 40 sq.wah 160 sq.m. 2 bedrooms 2 bathrooms title deed 44878 THB 1400000 aviation safety zone')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=23302&keyref='
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=23302&keyref=',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for HL0870. The specifications, images, rounded source coordinates, announced price, direct-purchase status, structure record, and aviation-zone warning come from that record.',
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
        '32f7ee29-eb1b-4c07-80ba-f8b5aade1e4c',
        jsonb_build_object(
            'reference_code', 'HL0870',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'aviation_safety_zone_warning', true,
            'usable_area_unconfirmed', true
        )
    );
END $$;

COMMIT;
