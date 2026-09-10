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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing HL0263';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing HL0263';
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
        '117d1306-3d5a-4246-aded-68098016cf8a',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'house',
        'residence',
        'sale',
        'whole_property',
        'วี พร็อพเพอร์ตี้ ร.8',
        '888/8',
        'ขายตรง SAM บ้านเดี่ยว 2 ชั้น 3 ห้องนอน 3 ห้องน้ำ แปลงหัวมุม วี พร็อพเพอร์ตี้ ร.8 ขอนแก่น ราคา 4.231 ล้านบาท',
        E'บ้านเดี่ยว 2 ชั้น เลขที่ 888/8 ในหมู่บ้านวี พร็อพเพอร์ตี้ ร.8 ถนนสีหราชเดโชไชย ตำบลบ้านเป็ด อำเภอเมืองขอนแก่น จังหวัดขอนแก่น บนโฉนดที่ดินเลขที่ 286144 จำนวน 1 ฉบับ เนื้อที่ 67.2 ตร.ว. (268.8 ตร.ม.) หน้า SAM ระบุ 3 ห้องนอน 3 ห้องน้ำ และเขตพื้นที่สีชมพู

ที่ดินมีรูปคล้ายสี่เหลี่ยมผืนผ้าและติดถนน 2 ด้าน โดยด้านทิศใต้กว้างประมาณ 16 เมตร ด้านทิศตะวันออกกว้างประมาณ 16 เมตร และลึกประมาณ 17 เมตร จึงมีลักษณะเป็นแปลงหัวมุม รายการรับโอนกรรมสิทธิ์ของ SAM ระบุสิ่งปลูกสร้างเป็นบ้านพักอาศัยตึก 2 ชั้น เลขที่ 888/8 หน้า SAM ไม่ได้เผยแพร่พื้นที่ใช้สอย จำนวนที่จอดรถ อายุอาคาร รายละเอียดระบบไฟฟ้า-ประปา หรือสถานะการครอบครอง ผู้ซื้อควรตรวจทะเบียนอาคาร แบบแปลน ใบอนุญาต ขอบเขต สิ่งปลูกสร้าง และสภาพจริงก่อนเสนอซื้อ

ถนนผ่านหน้าทรัพย์คือถนนหมู่บ้านวี พร็อพเพอร์ตี้ ร.8 ซอย 4 ซึ่ง SAM ระบุว่าเป็นทางสาธารณประโยชน์ ผิวจราจรคอนกรีตกว้างประมาณ 6 เมตร และเขตทางกว้างประมาณ 8 เมตร ผู้ซื้อควรให้ SAM สำนักงานที่ดิน และหน่วยงานท้องถิ่นยืนยันแนวเขต ทางเข้าออกจริง สถานะทางสาธารณะ การระบายน้ำ และข้อกำหนดของโครงการ

หน้า SAM ระบุว่าทรัพย์ตั้งอยู่ในย่านที่อยู่อาศัยและการคมนาคมสะดวก MapxProp จึงจัดเป็นหมวดที่อยู่อาศัย ไม่ได้จัดเป็น Mixed Use การใช้เพื่อประกอบธุรกิจต้องตรวจผังเมือง ข้อบังคับโครงการ กฎหมายอาคาร ที่จอดรถ ป้าย และใบอนุญาตที่เกี่ยวข้องด้วยตนเอง

การเดินทางตาม SAM ใช้ถนนมะลิวัลย์ (ทล.12) จากอำเภอชุมแพมุ่งหน้าตัวเมืองขอนแก่น ผ่านโกลบอลเฮ้าส์ สถาบันพัฒนาฝีมือแรงงาน ภาค 6 ขอนแก่น วัดโมกขวนาราม และโรงเรียนอนุบาลบารมี แล้วเลี้ยวซ้ายเข้าถนนสีหราชเดโชไชยประมาณ 1.8 กิโลเมตร เลี้ยวซ้ายเข้าซอยนวลหงประมาณ 500 เมตร จากนั้นเลี้ยวซ้ายเข้าทางหมู่บ้านวี พร็อพเพอร์ตี้ ร.8 อีกประมาณ 100 เมตร ทรัพย์อยู่ด้านขวามือบริเวณปากซอย 4 สถานที่ใกล้เคียงที่ SAM ระบุ ได้แก่ สนามบินนานาชาติขอนแก่นและค่ายสีหราชเดโชไชย

หน้า SAM แสดงสถานะ “ซื้อตรง” และราคาประกาศขาย 4,231,000 บาท ไม่ใช่การประมูลในสถานะที่ตรวจสอบเมื่อวันที่ 10 กันยายน 2569 ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะการครอบครอง และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ HL0263 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM

ภาพสภาพบ้านและภายในในหน้าต้นทางแสดงวันที่ 8 กรกฎาคม 2569 สภาพจริงอาจเปลี่ยนแปลง ผู้ซื้อควรนัดตรวจโครงสร้าง หลังคา รอยร้าว ความชื้น ปลวก ห้องน้ำ ระบบไฟฟ้าและประปา การระบายน้ำ น้ำท่วม ดิน แนวเขต ทางเข้าออก การครอบครอง ภาระผูกพัน ภาษี ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        4231000,
        false,
        268.8,
        2,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'บ้านเลขที่ 888/8 หมู่บ้านวี พร็อพเพอร์ตี้ ร.8',
        'ปากซอย 4 ใกล้ถนนสีหราชเดโชไชย',
        'ถนนหมู่บ้านวี พร็อพเพอร์ตี้ ร.8 ซอย 4',
        NULL,
        16.45803643,
        102.79215086,
        'ขอนแก่น',
        'เมืองขอนแก่น',
        'บ้านเป็ด',
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
        'sam-direct-sale-corner-house-v-property-r8-khon-kaen-hl0263'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 4231000, 'total', 'THB', false
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
        'house',
        1,
        jsonb_build_object(
            'source_property_category', 'บ้านเดี่ยว',
            'project_name', 'วี พร็อพเพอร์ตี้ ร.8',
            'listed_unit_number', '888/8',
            'title_document_type', 'chanote',
            'title_deed_number', '286144',
            'title_document_count', 1,
            'land_area_rai', 0,
            'land_area_ngan', 0,
            'land_area_square_wah_remainder', 67.2,
            'land_area_square_wah', 67.2,
            'land_area_sqm', 268.8,
            'floor_count', 2,
            'bedroom_count', 3,
            'bathroom_count', 3,
            'unit_count', 1,
            'registered_transfer_description', 'บ้านพักอาศัยตึกสองชั้น เลขที่ 888/8',
            'registered_floor_count', 2,
            'plot_shape', 'approximately_rectangular',
            'road_frontage_side_count', 2,
            'south_side_width_m', 16,
            'east_side_width_m', 16,
            'maximum_depth_m', 17,
            'corner_plot', true,
            'front_road_name', 'ถนนหมู่บ้านวี พร็อพเพอร์ตี้ ร.8 ซอย 4',
            'front_road_legal_status_th', 'ทางสาธารณประโยชน์',
            'front_road_surface', 'concrete',
            'front_road_width_m', 6,
            'front_right_of_way_width_m', 8
        ) || jsonb_build_object(
            'zoning_color_th', 'สีชมพู ตามหน้า SAM',
            'surrounding_area_use_th', 'ย่านที่อยู่อาศัย',
            'source_states_convenient_transportation', true,
            'mixed_use_classification', false,
            'commercial_use_requires_independent_verification', true,
            'source_photos_show_covered_vehicle_area', true,
            'parking_count_not_published', true,
            'usable_area_not_published', true,
            'building_age_not_published', true,
            'utilities_information_not_published', true,
            'occupancy_status_not_published', true,
            'other_encumbrances_not_published', true,
            'source_information_date_not_published', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'computed_price_per_square_wah', 62961.31,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_property_photo_date_displayed', '2026-07-08',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '16.458040,102.792150',
            'administrator_coordinate_distance_from_source_m_approx', 0.41
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for HL0263. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนมะลิวัลย์ (ทล.12)', 'Maliwan Road (Highway 12)', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ถนนสีหราชเดโชไชย', 'Siharat Decho Chai Road', 'road', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'สนามบินนานาชาติขอนแก่น', 'Khon Kaen International Airport', 'transit', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'ค่ายสีหราชเดโชไชย', 'Siharat Decho Chai Camp', 'landmark', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'โกลบอลเฮ้าส์ ขอนแก่น', 'Global House Khon Kaen', 'shopping', NULL, NULL, NULL, 50, false),
        (property_listing_id, 'สถาบันพัฒนาฝีมือแรงงาน ภาค 6 ขอนแก่น', 'Khon Kaen Institute for Skill Development Region 6', 'government', NULL, NULL, NULL, 60, false),
        (property_listing_id, 'วัดโมกขวนาราม', 'Wat Mok Khawanaram', 'landmark', NULL, NULL, NULL, 70, false),
        (property_listing_id, 'โรงเรียนอนุบาลบารมี', 'Baramee Kindergarten', 'education', NULL, NULL, NULL, 80, false)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '4,231,000 บาท — โปรดตรวจสอบราคาล่าสุดและโปรโมชั่นกับ SAM', 'THB 4,231,000 — confirm the latest price and promotions with SAM', 'unspecified', 4231000, 'THB', 20),
        (property_listing_id, 'published_room_count', 'จำนวนห้องตามประกาศ', 'Published room count', '3 ห้องนอน 3 ห้องน้ำ ตามหน้า SAM', 'Three bedrooms and three bathrooms according to the SAM page', 'unspecified', NULL, '', 30),
        (property_listing_id, 'corner_public_road_plot', 'แปลงหัวมุมและถนน', 'Corner plot and road', 'ติดถนน 2 ด้าน; ซอย 4 เป็นทางสาธารณประโยชน์ ผิวคอนกรีตกว้างประมาณ 6 เมตร เขตทางประมาณ 8 เมตร', 'Fronts roads on two sides; Soi 4 is described as a public-utility concrete road approximately six metres wide in an eight-metre right of way', 'unspecified', 6, 'metres', 40),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนด แนวเขต ทางเข้าออก ทะเบียนอาคาร แบบและใบอนุญาต สภาพบ้าน การครอบครอง ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Verify title, boundaries, access, building registration, plans and permits, house condition, possession, encumbrances, costs and latest terms', 'buyer', NULL, '', 50)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'บ้านเดี่ยว 2 ชั้น เลขที่ 888/8', 'บ้านเดี่ยว SAM รหัส HL0263 เลขที่ 888/8 ในหมู่บ้านวี พร็อพเพอร์ตี้ ร.8 ขอนแก่น', 'https://npa.sam.or.th/site/images/npa/22353/20260717141908_HL0263P3_69.jpg', '/listing-media/sam/hl0263/01.webp', 'image/webp', 35260, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่จอดรถมีหลังคาข้างบ้าน', 'ภาพพื้นที่มีหลังคาคลุมข้างบ้านและทางเข้าสู่ตัวบ้าน', 'https://npa.sam.or.th/site/images/npa/22353/HL0263P5_69.jpg', '/listing-media/sam/hl0263/02.webp', 'image/webp', 100102, 1024, 768, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงภายในบ้านชั้นล่าง', 'ภาพโถงภายในบ้านชั้นล่าง พื้นกระเบื้องและหน้าต่างด้านข้าง', 'https://npa.sam.or.th/site/images/npa/22353/HL0263P6_69.jpg', '/listing-media/sam/hl0263/03.webp', 'image/webp', 49596, 1024, 768, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนั่งเล่นและประตูหน้าบ้าน', 'ภาพห้องนั่งเล่นชั้นล่างพร้อมหน้าต่างและประตูเปิดสู่ด้านนอก', 'https://npa.sam.or.th/site/images/npa/22353/HL0263P7_69.jpg', '/listing-media/sam/hl0263/04.webp', 'image/webp', 98578, 1024, 768, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องภายในชั้นบน', 'ภาพห้องภายในชั้นบน พื้นกระเบื้อง หน้าต่าง และประตูไม้', 'https://npa.sam.or.th/site/images/npa/22353/HL0263P8_69.jpg', '/listing-media/sam/hl0263/05.webp', 'image/webp', 36628, 768, 1024, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องภายในพร้อมหน้าต่าง', 'ภาพห้องภายในบ้านพร้อมหน้าต่างสองด้าน', 'https://npa.sam.or.th/site/images/npa/22353/HL0263P10_69.jpg', '/listing-media/sam/hl0263/06.webp', 'image/webp', 58034, 768, 1024, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องพื้นลายไม้', 'ภาพห้องภายในชั้นบน พื้นลายไม้และหน้าต่างสองด้าน', 'https://npa.sam.or.th/site/images/npa/22353/HL0263P11_69.jpg', '/listing-media/sam/hl0263/07.webp', 'image/webp', 64780, 768, 1024, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงทางเดินชั้นบน', 'ภาพโถงทางเดินและประตูห้องภายในชั้นบน', 'https://npa.sam.or.th/site/images/npa/22353/HL0263P14_69.jpg', '/listing-media/sam/hl0263/08.webp', 'image/webp', 63804, 768, 1024, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำพร้อมอ่างล้างหน้า', 'ภาพห้องน้ำภายในบ้านพร้อมสุขภัณฑ์และอ่างล้างหน้า', 'https://npa.sam.or.th/site/images/npa/22353/HL0263P13_69.jpg', '/listing-media/sam/hl0263/09.webp', 'image/webp', 48386, 768, 1024, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำอีกห้อง', 'ภาพห้องน้ำภายในบ้านพร้อมสุขภัณฑ์และช่องแสง', 'https://npa.sam.or.th/site/images/npa/22353/HL0263P9_69.jpg', '/listing-media/sam/hl0263/10.webp', 'image/webp', 52712, 768, 1024, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'access', 'ทางเข้าจากถนนสีหราชเดโชไชย', 'ภาพจุดเลี้ยวจากถนนสีหราชเดโชไชยเข้าสู่ซอยนวลหง', 'https://npa.sam.or.th/site/images/npa/22353/HL0263P1_68.jpg', '/listing-media/sam/hl0263/11.webp', 'image/webp', 16472, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'access', 'ทางเข้าหมู่บ้านวี พร็อพเพอร์ตี้ ร.8', 'ภาพทางเข้าหมู่บ้านวี พร็อพเพอร์ตี้ ร.8 จากถนนในพื้นที่', 'https://npa.sam.or.th/site/images/npa/22353/HL0263P2_68.jpg', '/listing-media/sam/hl0263/12.webp', 'image/webp', 18602, 450, 450, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังแปลงหัวมุมติดถนน 2 ด้าน', 'ผังต้นทางแสดงโฉนดเลขที่ 286144 และแนวถนนด้านทิศใต้กับทิศตะวันออก', 'https://npa.sam.or.th/site/images/npa/22353/20250207105122_HL0263C2_68.jpg', '/listing-media/sam/hl0263/13.webp', 'image/webp', 8204, 450, 450, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังบ้าน 2 ชั้นบนที่ดิน 67.2 ตารางวา', 'ผังต้นทางแสดงตำแหน่งบ้านพักอาศัยตึก 2 ชั้นเลขที่ 888/8 บนแปลงหัวมุม', 'https://npa.sam.or.th/site/images/npa/22353/20250207105122_HL0263C1_68.jpg', '/listing-media/sam/hl0263/14.webp', 'image/webp', 11172, 450, 450, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปทรัพย์', 'แผนที่ต้นทางแสดงเส้นทางไปบ้าน SAM HL0263 ในบ้านเป็ด เมืองขอนแก่น', 'https://npa.sam.or.th/site/images/npa/22353/20250207105122_HL0263M_68(3A1945).jpg', '/listing-media/sam/hl0263/15.webp', 'image/webp', 45204, 785, 600, 150, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=22353&keyref=6004425',
        'HL0263',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 4,231,000 for a two-storey detached house numbered 888/8 in V Property R.8, Ban Pet, Mueang Khon Kaen. Title deed no. 286144 covers 67.2 sq.wah / 268.8 sq.m. SAM publishes three bedrooms and three bathrooms. The approximately rectangular corner plot fronts roads on two sides, measuring approximately sixteen metres on both its southern and eastern sides with a depth of approximately seventeen metres. SAM identifies the transferred structure as a two-storey masonry residence numbered 888/8. V Property R.8 Soi 4 is described as a public-utility concrete road approximately six metres wide within an approximately eight-metre right of way. The source identifies pink planning zoning, a residential area and convenient transportation. MapxProp classifies the asset as a residential house rather than mixed use. Usable area, parking count, building age, utility specifications, occupancy and other encumbrances are not published. Source property and interior photos display 8 July 2026. Administrator coordinates are approximately 0.41 metres from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all fifteen unique source property, interior, access, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Corner Two-Storey House in V Property R.8, Khon Kaen, THB 4.231M',
        E'A two-storey detached house numbered 888/8 in V Property R.8 on Siharat Decho Chai Road, Ban Pet, Mueang Khon Kaen. Title deed no. 286144 covers 67.2 sq.wah (268.8 sq.m.). SAM publishes three bedrooms, three bathrooms and pink planning zoning.

The approximately rectangular corner plot fronts roads on two sides. Its southern and eastern sides are each approximately sixteen metres wide, with a depth of approximately seventeen metres. SAM''s acquisition record identifies a two-storey masonry residence numbered 888/8. The source does not publish usable area, parking count, building age, electrical and plumbing specifications, occupancy or other encumbrances. Buyers should verify the building registration, approved plans, permits, boundaries, included structures and current condition before offering.

The frontage road is V Property R.8 Soi 4. SAM describes it as a public-utility concrete road approximately six metres wide within an approximately eight-metre right of way. Buyers should ask SAM, the Land Office and local authorities to confirm boundaries, actual ingress and egress, public-road status, drainage and development requirements.

SAM describes the location as a residential area with convenient transportation. MapxProp therefore lists it under homes rather than mixed use. Anyone considering commercial activity must independently verify zoning, development rules, building control, parking, signage and business licences.

SAM''s directions use Maliwan Road Highway 12 toward central Khon Kaen, passing Global House, the Khon Kaen Institute for Skill Development Region 6, Wat Mok Khawanaram and Baramee Kindergarten. Turn left onto Siharat Decho Chai Road and continue approximately 1.8 kilometres, turn left into Soi Nuan Hong for approximately 500 metres, then turn left into V Property R.8 for another 100 metres. The property is on the right at the mouth of Soi 4. Nearby places named by SAM include Khon Kaen International Airport and Siharat Decho Chai Camp.

The SAM page listed the property for direct purchase at an announced THB 4,231,000 when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, offer procedures, current price, promotions, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: HL0263. MapxProp does not collect deposits or represent SAM in the transaction.

Source property and interior photos display 8 July 2026, and conditions may have changed. Buyers should inspect the structure, roof, cracks, moisture, termites, bathrooms, electrical and plumbing systems, drainage, flooding, soil, boundaries, access, possession, encumbrances, taxes, costs and every current term before deciding.',
        'House 888/8 in V Property R.8',
        'At the mouth of Soi 4 near Siharat Decho Chai Road',
        'V Property R.8 Soi 4',
        'Ban Pet',
        'Mueang Khon Kaen',
        'Khon Kaen',
        'SAM Corner House in V Property R.8, Khon Kaen, THB 4.231M',
        'Official SAM NPA asset HL0263: corner two-storey house with 3 bedrooms and 3 bathrooms on 268.8 sq.m. Direct-sale price THB 4.231M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset HL0263 detached corner house two storey 888/8 V Property R.8 Ban Pet Mueang Khon Kaen Siharat Decho Chai Road 67.2 sq.wah 268.8 sq.m. title deed 286144 three bedrooms three bathrooms THB 4231000')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=22353&keyref=6004425'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=22353&keyref=6004425',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for HL0263. Specifications, room counts, title deed, registered house, images, rounded coordinates, announced price, direct-purchase status, road measurements, planning-zone wording and residential-area context come from that record.',
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
        '117d1306-3d5a-4246-aded-68098016cf8a',
        jsonb_build_object(
            'reference_code', 'HL0263',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'residence',
            'discovery_channels', jsonb_build_array('homes'),
            'title_document_count', 1,
            'registered_floor_count', 2,
            'bedroom_count', 3,
            'bathroom_count', 3,
            'corner_plot', true,
            'public_road_review_required', true,
            'commercial_use_review_required', true,
            'source_image_count', 15
        )
    );
END $$;

COMMIT;
