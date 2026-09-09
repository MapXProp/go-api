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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing HL0063';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing HL0063';
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
        'f300a20e-a8de-44d4-b5e7-ba6f00ee61d5',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'house',
        'residential',
        'sale',
        'whole_property',
        'ศุภาลัย การ์เด้นวิลล์',
        '66/72',
        'ขายตรง SAM บ้านเดี่ยว 2 ชั้น ศุภาลัย การ์เด้นวิลล์ วัดประดู่ 75 ตร.ว. ราคา 4.593 ล้านบาท',
        E'บ้านเดี่ยว 2 ชั้น เลขที่ 66/72 หมู่ 3 ในหมู่บ้านศุภาลัย การ์เด้นวิลล์ ตำบลวัดประดู่ อำเภอเมืองสุราษฎร์ธานี จังหวัดสุราษฎร์ธานี มี 3 ห้องนอน 3 ห้องน้ำ บนที่ดิน 75 ตร.ว. (300 ตร.ม.) โฉนดที่ดินเลขที่ 110634 จำนวน 1 ฉบับ โดยรายการรับโอนกรรมสิทธิ์ของ SAM ระบุสิ่งปลูกสร้างเป็นบ้านพักอาศัยตึก 2 ชั้น เลขที่ 66/72\n\nแปลงที่ดินรูปสี่เหลี่ยมผืนผ้า ด้านทิศเหนือติดถนนกว้างประมาณ 15 เมตร และลึกประมาณ 20 เมตร ถนนหน้าทรัพย์เป็นถนนหมู่บ้านศุภาลัย การ์เด้นวิลล์ ซึ่ง SAM ระบุว่าเป็นทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว ผิวจราจรคอนกรีตกว้างประมาณ 8 เมตร เขตทางกว้างประมาณ 10 เมตร ชุดภาพต้นทางแสดงบ้านมีพื้นที่ภายในโปร่ง หน้าต่างหลายด้าน ระเบียง และลานรอบบ้าน แต่ภาพภายในชุดวันที่ 21 กันยายน 2568 แสดงคราบและร่องรอยการใช้งานบางจุด ผู้ซื้อควรตรวจเรื่องความชื้น งานระบบ และรายการซ่อมปรับปรุงกับผู้เชี่ยวชาญจากสภาพจริง\n\nการเดินทางใช้ถนนสายสุราษฎร์ธานี-พุนพิน (ทล.401) จากสี่แยกบางใหญ่มุ่งหน้าอำเภอพุนพิน ผ่านโลตัส สี่แยกท่ากูบ คลองท่ากูบ อินเด็กซ์ ลิฟวิ่งมอลล์ และการประปาส่วนภูมิภาคเขต 4 แล้วเลี้ยวซ้ายเข้าหมู่บ้านศุภาลัย การ์เด้นวิลล์ เดินทางภายในโครงการรวมประมาณ 316 เมตร จะพบทรัพย์อยู่ด้านซ้ายมือ SAM ระบุว่าทรัพย์อยู่ในย่านที่อยู่อาศัยและการคมนาคมสะดวก สถานที่ใกล้เคียง ได้แก่ สถานีขนส่ง (บขส.) สำนักงานเทศบาลตำบลวัดประดู่ และวัดมะปริง อยู่ในเขตผังเมืองสีชมพู\n\nหน้า SAM ระบุสถานะ “ซื้อตรง” และราคาประกาศขาย 4,593,000 บาท ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน ค่าใช้จ่าย สถานะการครอบครอง และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ HL0063 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nหน้าต้นทางไม่ระบุพื้นที่ใช้สอย จำนวนที่จอดรถ อายุอาคาร สถานะผู้ใช้ประโยชน์ สาธารณูปโภค ภาระผูกพันอื่น หรือวันที่ของข้อมูลรายละเอียด ภาพภายนอกชุดแรกระบุวันที่ 28 กันยายน 2566 ส่วนภาพภายในชุดใหม่ระบุวันที่ 21 กันยายน 2568 ผู้ซื้อควรนัดตรวจทรัพย์และตรวจสอบสภาพปัจจุบัน เอกสารสิทธิ์ ทะเบียนอาคาร ขอบเขตแปลง กฎโครงการ งานระบบ ความชื้น รายการซ่อม สถานะการครอบครอง ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        4593000,
        false,
        300,
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
        '66/72 หมู่ 3 หมู่บ้านศุภาลัย การ์เด้นวิลล์',
        'เข้าจากถนนสายสุราษฎร์ธานี-พุนพิน (ทล.401) ประมาณ 316 เมตร',
        'สายสุราษฎร์ธานี-พุนพิน (ทล.401)',
        NULL,
        9.10936752,
        99.28380671,
        'สุราษฎร์ธานี',
        'เมืองสุราษฎร์ธานี',
        'วัดประดู่',
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
        'sam-direct-sale-detached-house-supalai-garden-ville-wat-pradu-hl0063'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 4593000, 'total', 'THB', false
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
        'house',
        1,
        jsonb_build_object(
            'source_property_category', 'บ้านเดี่ยว',
            'project_name', 'ศุภาลัย การ์เด้นวิลล์',
            'listed_unit_number', '66/72',
            'title_document_type', 'chanote',
            'title_deed_number', '110634',
            'title_document_count', 1,
            'land_area_square_wah', 75,
            'land_area_sqm', 300,
            'floor_count', 2,
            'bedroom_count', 3,
            'bathroom_count', 3,
            'unit_count', 1,
            'plot_shape', 'rectangle',
            'north_road_frontage_m', 15,
            'maximum_depth_m', 20,
            'registered_transfer_description', 'บ้านพักอาศัยตึก 2 ชั้น เลขที่ 66/72',
            'registered_address_number', '66/72',
            'source_photos_show_balcony', true,
            'source_photos_show_yard_around_house', true,
            'source_photos_show_visible_staining_and_maintenance_needs', true
        ) || jsonb_build_object(
            'usable_area_not_published', true,
            'parking_information_not_published', true,
            'building_age_not_published', true,
            'access_type', 'authorized_land_allocation_project_road',
            'front_road_name', 'ถนนหมู่บ้านศุภาลัย การ์เด้นวิลล์',
            'front_road_surface', 'concrete',
            'front_road_width_m', 8,
            'front_right_of_way_width_m', 10,
            'main_access_road', 'ถนนสายสุราษฎร์ธานี-พุนพิน (ทล.401)',
            'distance_from_main_road_m_approx', 316,
            'zoning_color_th', 'สีชมพู',
            'surrounding_area_use_th', 'ที่อยู่อาศัย',
            'source_states_convenient_transportation', true,
            'occupancy_status_not_published', true,
            'utilities_information_not_published', true,
            'other_encumbrances_not_published', true,
            'source_information_date_not_published', true,
            'source_exterior_photo_date_displayed', '2023-09-28',
            'source_interior_photo_date_displayed', '2025-09-21',
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-09',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '9.109368,99.283807',
            'administrator_coordinate_distance_from_source_m_approx', 0.06
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for HL0063. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนสายสุราษฎร์ธานี-พุนพิน (ทล.401)', 'Surat Thani–Phunphin Road (Highway 401)', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'สถานีขนส่งผู้โดยสารจังหวัดสุราษฎร์ธานี', 'Surat Thani Bus Terminal', 'transit', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'สำนักงานเทศบาลตำบลวัดประดู่', 'Wat Pradu Subdistrict Municipality Office', 'government', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'วัดมะปริง', 'Wat Mapring', 'landmark', NULL, NULL, NULL, 40, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '4,593,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 4,593,000 — confirm the latest price with SAM', 'unspecified', 4593000, 'THB', 20),
        (property_listing_id, 'registered_structure', 'สิ่งปลูกสร้างตามรายการรับโอน', 'Structure in acquisition records', 'รายการรับโอนของ SAM ระบุบ้านพักอาศัยตึก 2 ชั้น เลขที่ 66/72 บนโฉนดเลขที่ 110634', 'SAM''s acquisition record identifies a two-storey residential building numbered 66/72 on title deed no. 110634', 'unspecified', NULL, '', 30),
        (property_listing_id, 'project_road', 'ถนนหน้าทรัพย์', 'Road in front of the property', 'ถนนหมู่บ้านศุภาลัย การ์เด้นวิลล์เป็นทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว ผิวคอนกรีตกว้างประมาณ 8 เมตร เขตทางประมาณ 10 เมตร', 'The Supalai Garden Ville road is in an authorized land-allocation project, with an approximately eight-meter concrete carriageway within an approximately ten-meter right of way', 'unspecified', NULL, '', 40),
        (property_listing_id, 'condition_review', 'ตรวจสภาพและรายการซ่อม', 'Condition and repair review', 'ภาพภายในวันที่ 21 กันยายน 2568 แสดงคราบและร่องรอยการใช้งานบางจุด ผู้ซื้อควรตรวจความชื้น งานระบบ และประเมินค่าซ่อมจากสภาพจริง', 'Interior photos dated 21 September 2025 show staining and signs of use in some areas; buyers should inspect moisture and building systems and assess repair costs in person', 'buyer', NULL, '', 50),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนเสนอซื้อ', 'Buyer due diligence', 'ผู้ซื้อต้องตรวจสอบสภาพปัจจุบัน โฉนด ทะเบียนอาคาร ขอบเขต กฎโครงการ สถานะการครอบครอง สาธารณูปโภค ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขล่าสุดกับ SAM', 'Buyers must verify current condition, title and building records, boundaries, project rules, possession, utilities, encumbrances, expenses and current terms with SAM', 'buyer', NULL, '', 60)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ด้านหน้าบ้านเดี่ยว 2 ชั้น', 'บ้านเดี่ยว 2 ชั้น เลขที่ 66/72 ศุภาลัย การ์เด้นวิลล์ รหัส SAM HL0063', 'https://npa.sam.or.th/site/images/npa/21261/20260403161620_HL0063P3_67.jpg', '/listing-media/sam/hl0063/01.webp', 'image/webp', 31976, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมด้านหน้าและแนวรั้ว', 'ภาพด้านหน้าบ้านเดี่ยว 2 ชั้นพร้อมรั้วและถนนภายในโครงการ', 'https://npa.sam.or.th/site/images/npa/21261/HL0063P4_67.jpg', '/listing-media/sam/hl0063/02.webp', 'image/webp', 34442, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่นั่งเล่นชั้นล่าง', 'พื้นที่นั่งเล่นชั้นล่างพร้อมหน้าต่างและประตูกระจก', 'https://npa.sam.or.th/site/images/npa/21261/HL0063P7_69.jpg', '/listing-media/sam/hl0063/03.webp', 'image/webp', 25938, 720, 540, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ภายในอีกมุมหนึ่ง', 'พื้นที่ภายในชั้นล่างพร้อมเสาตกแต่งและช่องแสง', 'https://npa.sam.or.th/site/images/npa/21261/HL0063P8_69.jpg', '/listing-media/sam/hl0063/04.webp', 'image/webp', 26616, 720, 540, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องติดลานด้านข้าง', 'ห้องภายในบ้านพร้อมประตูกระจกเชื่อมลานด้านข้าง', 'https://npa.sam.or.th/site/images/npa/21261/HL0063P9_69.jpg', '/listing-media/sam/hl0063/05.webp', 'image/webp', 34912, 720, 540, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องด้านล่างและร่องรอยที่ควรตรวจ', 'ห้องภายในชั้นล่างมีช่องแสงและร่องรอยบริเวณผนังบางจุดที่ควรตรวจสภาพจริง', 'https://npa.sam.or.th/site/images/npa/21261/HL0063P10_69.jpg', '/listing-media/sam/hl0063/06.webp', 'image/webp', 60724, 720, 540, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงภายในและประตูห้อง', 'โถงภายในบ้านพร้อมประตูกระจกและทางเชื่อมไปยังห้องต่าง ๆ', 'https://npa.sam.or.th/site/images/npa/21261/HL0063P11_69.jpg', '/listing-media/sam/hl0063/07.webp', 'image/webp', 17648, 720, 540, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนพร้อมหน้าต่างหลายด้าน', 'ห้องนอนภายในบ้านพร้อมหน้าต่างรับแสงหลายด้าน', 'https://npa.sam.or.th/site/images/npa/21261/HL0063P12_69.jpg', '/listing-media/sam/hl0063/08.webp', 'image/webp', 22108, 720, 540, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงบันไดชั้นบน', 'พื้นที่โถงบันไดชั้นบนพร้อมโคมไฟและผนังตกแต่ง', 'https://npa.sam.or.th/site/images/npa/21261/HL0063P13_69.jpg', '/listing-media/sam/hl0063/09.webp', 'image/webp', 23336, 720, 540, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนมุมหน้าบ้าน', 'ห้องนอนขนาดใหญ่พร้อมหน้าต่างหลายด้านและพื้นกระเบื้อง', 'https://npa.sam.or.th/site/images/npa/21261/HL0063P15_69.jpg', '/listing-media/sam/hl0063/10.webp', 'image/webp', 30104, 720, 540, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนอีกห้องหนึ่ง', 'ห้องนอนภายในบ้านพร้อมหน้าต่างสองด้าน', 'https://npa.sam.or.th/site/images/npa/21261/HL0063P16_69.jpg', '/listing-media/sam/hl0063/11.webp', 'image/webp', 19132, 720, 540, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องติดระเบียงด้านหน้า', 'ห้องชั้นบนพร้อมประตูกระจกออกสู่ระเบียงหน้าบ้าน', 'https://npa.sam.or.th/site/images/npa/21261/HL0063P18_69.jpg', '/listing-media/sam/hl0063/12.webp', 'image/webp', 34242, 720, 540, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำภายในบ้าน', 'ห้องน้ำพร้อมโถสุขภัณฑ์และอ่างล้างหน้า', 'https://npa.sam.or.th/site/images/npa/21261/HL0063P17_69.jpg', '/listing-media/sam/hl0063/13.webp', 'image/webp', 31682, 720, 540, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้าหมู่บ้านจากถนน ทล.401', 'ภาพทางเข้าหมู่บ้านศุภาลัย การ์เด้นวิลล์จากถนนสุราษฎร์ธานี-พุนพิน ทางหลวงหมายเลข 401', 'https://npa.sam.or.th/site/images/npa/21261/HL0063P1_67.jpg', '/listing-media/sam/hl0063/14.webp', 'image/webp', 23224, 450, 450, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังตำแหน่งในโครงการ', 'ผังโครงการศุภาลัย การ์เด้นวิลล์แสดงตำแหน่งทรัพย์และระยะทางประมาณ 316 เมตรจากทางเข้า', 'https://npa.sam.or.th/site/images/npa/21261/HL0063C3_67.jpg', '/listing-media/sam/hl0063/15.webp', 'image/webp', 24158, 450, 450, 150, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังแปลง 75 ตารางวา', 'ผังโฉนดเลขที่ 110634 แสดงแปลงกว้างประมาณ 15 เมตรและลึกประมาณ 20 เมตร', 'https://npa.sam.or.th/site/images/npa/21261/20240227100159_HL0063C2_67.jpg', '/listing-media/sam/hl0063/16.webp', 'image/webp', 11736, 450, 450, 160, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังตำแหน่งบ้านบนแปลง', 'ผังต้นทางแสดงบ้านเดี่ยว 2 ชั้น เลขที่ 66/72 และบ้านข้างเคียง', 'https://npa.sam.or.th/site/images/npa/21261/20240227100159_HL0063C1_67.jpg', '/listing-media/sam/hl0063/17.webp', 'image/webp', 17688, 450, 450, 170, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แผนที่การเดินทางไปศุภาลัย การ์เด้นวิลล์', 'แผนที่ต้นทางแสดงเส้นทางจากถนน ทล.401 ไปยังหมู่บ้านศุภาลัย การ์เด้นวิลล์และสถานที่ใกล้เคียง', 'https://npa.sam.or.th/site/images/npa/21261/20240227100159_HL0063M_67(3A1860).jpg', '/listing-media/sam/hl0063/18.webp', 'image/webp', 61954, 785, 600, 180, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=21261',
        'HL0063',
        '2026-09-09 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 4,593,000 for a two-storey detached house numbered 66/72 with three bedrooms and three bathrooms in Supalai Garden Ville on title deed no. 110634 covering 75 sq.wah / 300 sq.m. The rectangular plot has approximately 15 meters of northern road frontage and a maximum depth of approximately 20 meters. The property fronts an authorized land-allocation project road with an approximately eight-meter concrete carriageway within an approximately ten-meter right of way and lies about 316 meters from Highway 401. The page does not publish usable area, parking count, building age, occupancy, utilities, other encumbrances or the information date. Exterior photos display 28 September 2023 and interior photos display 21 September 2025; the newer photos show staining and maintenance needs in some areas, so buyers should inspect moisture, building systems and repair requirements. Administrator-supplied coordinates are approximately 0.06 meters from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all eighteen unique source property, interior, access, project-plan, plot and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Two-Storey House in Supalai Garden Ville, THB 4.593M',
        E'Two-storey detached house numbered 66/72, Moo 3, in Supalai Garden Ville, Wat Pradu, Mueang Surat Thani, Surat Thani. The house has three bedrooms and three bathrooms on 75 sq.wah (300 sq.m.) of land under title deed no. 110634. SAM''s acquisition record describes a two-storey residential building numbered 66/72.\n\nThe rectangular plot has approximately 15 meters of northern road frontage and a maximum depth of approximately 20 meters. The property fronts the Supalai Garden Ville road, which SAM identifies as being within an authorized land-allocation project. Its concrete carriageway is approximately eight meters wide within an approximately ten-meter right of way. Source photos show open interior space, windows on multiple sides, a balcony and a yard around the house. Interior photos dated 21 September 2025 show staining and signs of use in some areas; buyers should have moisture, building systems and repair requirements inspected in person.\n\nAccess is from Surat Thani–Phunphin Road (Highway 401), travelling from Bang Yai intersection toward Phunphin past Lotus, Tha Kub intersection and canal, Index Living Mall and Provincial Waterworks Authority Region 4. Turn left into Supalai Garden Ville and continue approximately 316 meters; the property is on the left. SAM describes the area as residential with convenient transport and pink zoning. Nearby places listed by SAM include Surat Thani Bus Terminal, the Wat Pradu Subdistrict Municipality Office and Wat Mapring.\n\nThe SAM page lists the property as direct purchase with an announced sale price of THB 4,593,000. It is not an auction. Contact SAM directly to confirm availability, offer procedures, current price, expenses, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: HL0063. MapxProp does not collect deposits or represent SAM in the transaction.\n\nThe source does not publish usable area, parking count, building age, occupancy, utilities, other encumbrances or a date for the detailed property information. Exterior photos display 28 September 2023, while newer interior photos display 21 September 2025. Buyers should arrange an inspection and verify current condition, title and building records, plot boundaries, project rules, building systems, moisture, repairs, possession, encumbrances, expenses and all terms before deciding.',
        '66/72, Moo 3, Supalai Garden Ville',
        'Approximately 316 m from Surat Thani–Phunphin Road (Highway 401)',
        'Surat Thani–Phunphin Road (Highway 401)',
        'Wat Pradu',
        'Mueang Surat Thani',
        'Surat Thani',
        'SAM Direct-Sale House in Supalai Garden Ville, THB 4.593M',
        'Official SAM NPA asset HL0063: two-storey detached house with 3 bedrooms and 3 bathrooms on 300 sq.m. Direct-sale price THB 4.593M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset HL0063 two storey detached house Supalai Garden Ville Wat Pradu Mueang Surat Thani Highway 401 75 sq.wah 300 sq.m. title deed 110634 three bedrooms three bathrooms THB 4593000 address 66/72')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=21261'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=21261',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for HL0063. The specifications, images, rounded coordinates, announced price, direct-purchase status, authorized project-road details and visible condition observations come from that record.',
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
        'f300a20e-a8de-44d4-b5e7-ba6f00ee61d5',
        jsonb_build_object(
            'reference_code', 'HL0063',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'authorized_land_allocation_project_road', true,
            'condition_review_disclosed', true
        )
    );
END $$;

COMMIT;
