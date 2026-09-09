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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing TL0342';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing TL0342';
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
        '63582c25-a677-4b1c-850e-ed4d21e83587',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'townhouse',
        'residential',
        'sale',
        'whole_property',
        'บ้านสวย-แยกป่าไม้',
        '88/64',
        'ขายตรง SAM ทาวน์เฮ้าส์ 2 ชั้น บ้านสวย-แยกป่าไม้ บางกุ้ง 20.7 ตร.ว. ราคา 2.748 ล้านบาท',
        E'ทาวน์เฮ้าส์ 2 ชั้น เลขที่ 88/64 ในหมู่บ้านบ้านสวย-แยกป่าไม้ ถนนกาญจนวิถี ตำบลบางกุ้ง อำเภอเมืองสุราษฎร์ธานี จังหวัดสุราษฎร์ธานี มี 3 ห้องนอน 3 ห้องน้ำ บนที่ดิน 20.7 ตร.ว. (82.8 ตร.ม.) โฉนดที่ดินเลขที่ 116082 จำนวน 1 ฉบับ โดยรายการรับโอนกรรมสิทธิ์ของ SAM ระบุสิ่งปลูกสร้างเป็นทาวน์เฮ้าส์ 2 ชั้น เลขที่ 88/64\n\nแปลงที่ดินรูปสี่เหลี่ยมผืนผ้า ด้านทิศตะวันตกติดถนนกว้างประมาณ 5.7 เมตร และลึกประมาณ 14.5 เมตร ถนนหน้าทรัพย์เป็นถนนภายในหมู่บ้านบ้านสวย-แยกป่าไม้ ซึ่ง SAM ระบุว่าเป็นทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว ผิวจราจรคอนกรีตกว้างประมาณ 6 เมตร เขตทางกว้างประมาณ 8 เมตร ตัวบ้านมีพื้นที่จอดรถใต้ชายคาด้านหน้า พื้นที่นั่งเล่น ครัว บันได ห้องนอน และห้องน้ำตามชุดภาพต้นทาง ทั้งนี้ควรตรวจสภาพและขนาดพื้นที่จริงอีกครั้ง\n\nการเดินทางใช้ถนนกาญจนวิถี จากตัวเมืองสุราษฎร์ธานีมุ่งหน้าแยกบางกุ้ง ผ่านสำนักงานขนส่งจังหวัดสุราษฎร์ธานี แล้วเลี้ยวซ้ายเข้าถนนภายในหมู่บ้านบ้านสวย-แยกป่าไม้ประมาณ 80 เมตร จะพบทรัพย์อยู่ด้านขวามือ SAM ระบุว่าทรัพย์อยู่ในย่านที่อยู่อาศัยและการคมนาคมสะดวก สถานที่ใกล้เคียง ได้แก่ สำนักงานป่าไม้จังหวัดสุราษฎร์ธานี สำนักงานขนส่งจังหวัดสุราษฎร์ธานี และวัดโพหวาย อยู่ในเขตผังเมืองสีชมพู\n\nหน้า SAM ระบุสถานะ “ซื้อตรง” และราคาประกาศขาย 2,748,000 บาท ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน ค่าใช้จ่าย สถานะการครอบครอง และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ TL0342 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nหน้าต้นทางไม่ระบุพื้นที่ใช้สอย อายุอาคาร สถานะผู้ใช้ประโยชน์ สาธารณูปโภค ภาระผูกพันอื่น หรือวันที่ของข้อมูลรายละเอียด ภาพภายนอกชุดแรกระบุวันที่ 24 กรกฎาคม 2567 ส่วนภาพภายนอกและภายในชุดใหม่ระบุวันที่ 19 มีนาคม 2568 ผู้ซื้อควรนัดตรวจทรัพย์และตรวจสอบสภาพปัจจุบัน เอกสารสิทธิ์ ทะเบียนอาคาร ขอบเขตแปลง กฎโครงการ สถานะการครอบครอง ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        2748000,
        false,
        82.8,
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
        '88/64 หมู่บ้านบ้านสวย-แยกป่าไม้',
        'เข้าจากถนนกาญจนวิถีประมาณ 80 เมตร',
        'กาญจนวิถี',
        NULL,
        9.15602049,
        99.34173971,
        'สุราษฎร์ธานี',
        'เมืองสุราษฎร์ธานี',
        'บางกุ้ง',
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
        'sam-direct-sale-townhouse-baan-suay-yak-pa-mai-bang-kung-tl0342'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 2748000, 'total', 'THB', false
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
            'project_name', 'บ้านสวย-แยกป่าไม้',
            'listed_unit_number', '88/64',
            'title_document_type', 'chanote',
            'title_deed_number', '116082',
            'title_document_count', 1,
            'land_area_square_wah', 20.7,
            'land_area_sqm', 82.8,
            'floor_count', 2,
            'bedroom_count', 3,
            'bathroom_count', 3,
            'unit_count', 1,
            'plot_shape', 'rectangle',
            'west_road_frontage_m', 5.7,
            'maximum_depth_m', 14.5,
            'registered_transfer_description', 'ทาวน์เฮ้าส์ 2 ชั้น เลขที่ 88/64',
            'registered_address_number', '88/64',
            'covered_front_parking_visible_in_source_photos', true,
            'usable_area_not_published', true,
            'building_age_not_published', true
        ) || jsonb_build_object(
            'access_type', 'authorized_land_allocation_project_road',
            'front_road_name', 'ถนนภายในหมู่บ้านบ้านสวย-แยกป่าไม้',
            'front_road_surface', 'concrete',
            'front_road_width_m', 6,
            'front_right_of_way_width_m', 8,
            'main_access_road', 'ถนนกาญจนวิถี',
            'distance_from_main_road_m_approx', 80,
            'zoning_color_th', 'สีชมพู',
            'surrounding_area_use_th', 'ที่อยู่อาศัย',
            'source_states_convenient_transportation', true,
            'occupancy_status_not_published', true,
            'utilities_information_not_published', true,
            'other_encumbrances_not_published', true,
            'source_information_date_not_published', true,
            'source_exterior_photo_dates_displayed', jsonb_build_array('2024-07-24', '2025-03-19'),
            'source_interior_photo_date_displayed', '2025-03-19',
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-09',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '9.156023,99.341741',
            'administrator_coordinate_distance_from_source_m_approx', 0.31
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for TL0342. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนกาญจนวิถี', 'Kanchanawithi Road', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'สำนักงานป่าไม้จังหวัดสุราษฎร์ธานี', 'Surat Thani Provincial Forestry Office', 'government', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'สำนักงานขนส่งจังหวัดสุราษฎร์ธานี', 'Surat Thani Provincial Transport Office', 'government', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'วัดโพหวาย', 'Wat Pho Wai', 'landmark', NULL, NULL, NULL, 40, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '2,748,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 2,748,000 — confirm the latest price with SAM', 'unspecified', 2748000, 'THB', 20),
        (property_listing_id, 'registered_structure', 'สิ่งปลูกสร้างตามรายการรับโอน', 'Structure in acquisition records', 'รายการรับโอนของ SAM ระบุทาวน์เฮ้าส์ 2 ชั้น เลขที่ 88/64 บนโฉนดเลขที่ 116082', 'SAM''s acquisition record identifies a two-storey townhouse numbered 88/64 on title deed no. 116082', 'unspecified', NULL, '', 30),
        (property_listing_id, 'project_road', 'ถนนหน้าทรัพย์', 'Road in front of the property', 'ถนนภายในหมู่บ้านบ้านสวย-แยกป่าไม้เป็นทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว ผิวคอนกรีตกว้างประมาณ 6 เมตร เขตทางประมาณ 8 เมตร', 'The internal Baan Suay–Yak Pa Mai road is in an authorized land-allocation project, with an approximately six-meter concrete carriageway within an approximately eight-meter right of way', 'unspecified', NULL, '', 40),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนเสนอซื้อ', 'Buyer due diligence', 'ผู้ซื้อต้องตรวจสอบสภาพปัจจุบัน โฉนด ทะเบียนอาคาร ขอบเขต กฎโครงการ สถานะการครอบครอง สาธารณูปโภค ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขล่าสุดกับ SAM', 'Buyers must verify current condition, title and building records, boundaries, project rules, possession, utilities, encumbrances, expenses and current terms with SAM', 'buyer', NULL, '', 50)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ด้านหน้าทาวน์เฮ้าส์ 2 ชั้น', 'ทาวน์เฮ้าส์ 2 ชั้น เลขที่ 88/64 บ้านสวย-แยกป่าไม้ รหัส SAM TL0342', 'https://npa.sam.or.th/site/images/npa/21987/20250319141739_TL0342P2_67.jpg', '/listing-media/sam/tl0342/01.webp', 'image/webp', 25982, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ประตูกระจกด้านหน้าบ้าน', 'พื้นที่หน้าทาวน์เฮ้าส์และประตูกระจกบานเลื่อนของบ้านเลขที่ 88/64', 'https://npa.sam.or.th/site/images/npa/21987/TL0342P4_68.jpg', '/listing-media/sam/tl0342/02.webp', 'image/webp', 14220, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ด้านหลังบ้าน', 'ลานคอนกรีตและพื้นที่ด้านหลังทาวน์เฮ้าส์', 'https://npa.sam.or.th/site/images/npa/21987/TL0342P5_68.jpg', '/listing-media/sam/tl0342/03.webp', 'image/webp', 27742, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ชั้นล่างและครัว', 'พื้นที่โล่งชั้นล่างพร้อมเคาน์เตอร์และชุดครัวด้านหลัง', 'https://npa.sam.or.th/site/images/npa/21987/TL0342P6_68.jpg', '/listing-media/sam/tl0342/04.webp', 'image/webp', 8458, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บันไดจากชั้นล่าง', 'บันไดภายในทาวน์เฮ้าส์มองจากพื้นที่ชั้นล่าง', 'https://npa.sam.or.th/site/images/npa/21987/TL0342P7_68.jpg', '/listing-media/sam/tl0342/05.webp', 'image/webp', 9018, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องภายในบ้าน', 'ห้องภายในทาวน์เฮ้าส์พร้อมหน้าต่างและพื้นกระเบื้อง', 'https://npa.sam.or.th/site/images/npa/21987/TL0342P9_68.jpg', '/listing-media/sam/tl0342/06.webp', 'image/webp', 9308, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บันไดเชื่อมชั้นบน', 'บันไดและราวจับภายในทาวน์เฮ้าส์ 2 ชั้น', 'https://npa.sam.or.th/site/images/npa/21987/TL0342P10_68.jpg', '/listing-media/sam/tl0342/07.webp', 'image/webp', 10668, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนพร้อมหน้าต่าง', 'ห้องนอนภายในทาวน์เฮ้าส์พร้อมหน้าต่างและพื้นกระเบื้อง', 'https://npa.sam.or.th/site/images/npa/21987/TL0342P11_68.jpg', '/listing-media/sam/tl0342/08.webp', 'image/webp', 7912, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนอีกมุมหนึ่ง', 'ห้องนอนภายในบ้านพร้อมช่องแสงด้านข้าง', 'https://npa.sam.or.th/site/images/npa/21987/TL0342P12_68.jpg', '/listing-media/sam/tl0342/09.webp', 'image/webp', 7866, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ชั้นบนติดระเบียง', 'พื้นที่ภายในชั้นบนพร้อมประตูกระจกออกสู่ระเบียง', 'https://npa.sam.or.th/site/images/npa/21987/TL0342P14_68.jpg', '/listing-media/sam/tl0342/10.webp', 'image/webp', 11368, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำพร้อมพื้นที่อาบน้ำ', 'ห้องน้ำภายในพร้อมโถสุขภัณฑ์ อ่างล้างหน้า และพื้นที่อาบน้ำ', 'https://npa.sam.or.th/site/images/npa/21987/TL0342P13_68.jpg', '/listing-media/sam/tl0342/11.webp', 'image/webp', 10434, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำภายในบ้าน', 'ห้องน้ำภายในทาวน์เฮ้าส์พร้อมโถสุขภัณฑ์และอ่างล้างหน้า', 'https://npa.sam.or.th/site/images/npa/21987/TL0342P8_68.jpg', '/listing-media/sam/tl0342/12.webp', 'image/webp', 12806, 450, 450, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้าหมู่บ้านจากถนนกาญจนวิถี', 'ภาพทางเข้าหมู่บ้านบ้านสวย-แยกป่าไม้จากถนนกาญจนวิถี', 'https://npa.sam.or.th/site/images/npa/21987/TL0342P1_67.jpg', '/listing-media/sam/tl0342/13.webp', 'image/webp', 27760, 450, 450, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังแปลง 20.7 ตารางวา', 'ผังโฉนดเลขที่ 116082 แสดงแปลงหน้ากว้างประมาณ 5.7 เมตรและลึกประมาณ 14.5 เมตร', 'https://npa.sam.or.th/site/images/npa/21987/20240925090207_TL0342C2_67.jpg', '/listing-media/sam/tl0342/14.webp', 'image/webp', 15536, 450, 450, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังตำแหน่งทาวน์เฮ้าส์บนแปลง', 'ผังต้นทางแสดงทาวน์เฮ้าส์ 2 ชั้น เลขที่ 88/64 และอาคารข้างเคียง', 'https://npa.sam.or.th/site/images/npa/21987/20240925090207_TL0342C1_67.jpg', '/listing-media/sam/tl0342/15.webp', 'image/webp', 15456, 450, 450, 150, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แผนที่การเดินทางไปบ้านสวย-แยกป่าไม้', 'แผนที่ต้นทางแสดงเส้นทางจากถนนกาญจนวิถีไปยังหมู่บ้านบ้านสวย-แยกป่าไม้และสถานที่ใกล้เคียง', 'https://npa.sam.or.th/site/images/npa/21987/20240925090207_TL0342M_67.jpg', '/listing-media/sam/tl0342/16.webp', 'image/webp', 45702, 785, 600, 160, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=21987',
        'TL0342',
        '2026-09-09 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 2,748,000 for a two-storey townhouse numbered 88/64 with three bedrooms and three bathrooms in Baan Suay–Yak Pa Mai on title deed no. 116082 covering 20.7 sq.wah / 82.8 sq.m. The rectangular plot has approximately 5.7 meters of western road frontage and a maximum depth of approximately 14.5 meters. The property fronts an authorized land-allocation project road with an approximately six-meter concrete carriageway within an approximately eight-meter right of way and lies about 80 meters from Kanchanawithi Road. The page does not publish usable area, building age, occupancy, utilities, other encumbrances or the information date. The first exterior photo displays 24 July 2024; newer exterior and interior photos display 19 March 2025. Administrator-supplied coordinates are approximately 0.31 meters from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all sixteen unique source property, interior, access, plot and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Two-Storey Townhouse in Baan Suay–Yak Pa Mai, THB 2.748M',
        E'Two-storey townhouse numbered 88/64 in Baan Suay–Yak Pa Mai, Kanchanawithi Road, Bang Kung, Mueang Surat Thani, Surat Thani. The house has three bedrooms and three bathrooms on 20.7 sq.wah (82.8 sq.m.) of land under title deed no. 116082. SAM''s acquisition record describes a two-storey townhouse numbered 88/64.\n\nThe rectangular plot has approximately 5.7 meters of western road frontage and a maximum depth of approximately 14.5 meters. The property fronts the internal Baan Suay–Yak Pa Mai road, which SAM identifies as being within an authorized land-allocation project. Its concrete carriageway is approximately six meters wide within an approximately eight-meter right of way. Source photos show covered front parking, living space, a kitchen, stairs, bedrooms and bathrooms; buyers should verify condition and measurements in person.\n\nAccess is from Kanchanawithi Road, travelling from central Surat Thani toward Bang Kung intersection. Pass the Surat Thani Provincial Transport Office, turn left into the Baan Suay–Yak Pa Mai internal road and continue for approximately 80 meters; the property is on the right. SAM describes the area as residential with convenient transport and pink zoning. Nearby places listed by SAM include the Surat Thani Provincial Forestry Office, the Surat Thani Provincial Transport Office and Wat Pho Wai.\n\nThe SAM page lists the property as direct purchase with an announced sale price of THB 2,748,000. It is not an auction. Contact SAM directly to confirm availability, offer procedures, current price, expenses, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: TL0342. MapxProp does not collect deposits or represent SAM in the transaction.\n\nThe source does not publish usable area, building age, occupancy, utilities, other encumbrances or a date for the detailed property information. The first exterior photo displays 24 July 2024, while the newer exterior and interior photos display 19 March 2025. Buyers should arrange an inspection and verify current condition, title and building records, plot boundaries, project rules, possession, encumbrances, expenses and all terms before deciding.',
        '88/64, Baan Suay–Yak Pa Mai',
        'Approximately 80 m from Kanchanawithi Road',
        'Kanchanawithi Road',
        'Bang Kung',
        'Mueang Surat Thani',
        'Surat Thani',
        'SAM Direct-Sale Townhouse in Baan Suay–Yak Pa Mai, THB 2.748M',
        'Official SAM NPA asset TL0342: two-storey townhouse with 3 bedrooms and 3 bathrooms on 82.8 sq.m. Direct-sale price THB 2.748M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset TL0342 two storey townhouse Baan Suay Yak Pa Mai Bang Kung Mueang Surat Thani Kanchanawithi Road 20.7 sq.wah 82.8 sq.m. title deed 116082 three bedrooms three bathrooms THB 2748000 address 88/64')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=21987'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=21987',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for TL0342. The specifications, images, rounded coordinates, announced price, direct-purchase status and authorized project-road details come from that record.',
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
        '63582c25-a677-4b1c-850e-ed4d21e83587',
        jsonb_build_object(
            'reference_code', 'TL0342',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'authorized_land_allocation_project_road', true
        )
    );
END $$;

COMMIT;
