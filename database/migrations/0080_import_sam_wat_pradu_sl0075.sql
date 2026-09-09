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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing SL0075';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing SL0075';
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
        '1f20cba4-680b-478b-ad80-cafe0f763589',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'shophouse',
        'mixed',
        'sale',
        'whole_property',
        NULL,
        '189/7',
        'ขายตรง SAM อาคารพาณิชย์ 3 ชั้น วัดประดู่ เมืองสุราษฎร์ฯ 23 ตร.ว. ราคา 5.078 ล้านบาท',
        E'อาคารพาณิชย์ 3 ชั้น เลขที่ 189/7 หมู่ 1 ตำบลวัดประดู่ อำเภอเมืองสุราษฎร์ธานี จังหวัดสุราษฎร์ธานี บนที่ดิน 23 ตร.ว. (92 ตร.ม.) โฉนดที่ดินเลขที่ 108758 จำนวน 1 ฉบับ โดยรายการรับโอนกรรมสิทธิ์ของ SAM ระบุสิ่งปลูกสร้างเป็นตึกแถว 3 ชั้น เลขที่ 189/7\n\nแปลงที่ดินรูปสี่เหลี่ยมผืนผ้า หน้ากว้างทางทิศเหนือประมาณ 4.5 เมตร และลึกประมาณ 20 เมตร ชุดภาพต้นทางแสดงอาคารอยู่ในแนวอาคารพาณิชย์ติดกัน ภายในมีพื้นที่โล่งหลายส่วน ห้องน้ำ บันได และพื้นที่ด้านหลัง ทั้งนี้ SAM ไม่ได้ระบุจำนวนห้องนอน จำนวนห้องน้ำ พื้นที่ใช้สอย ที่จอดรถ หรืออายุอาคาร จึงไม่ควรสรุปจำนวนจากภาพเพียงอย่างเดียว\n\nข้อควรตรวจสอบสำคัญ: ด้านหน้าทรัพย์ติดถนนภายในซึ่ง SAM ระบุว่าเป็นทางส่วนบุคคลที่จดทะเบียนภาระจำยอม ผิวถนนคอนกรีตกว้างประมาณ 5 เมตร เขตทางประมาณ 6 เมตร และ SAM แนะนำให้ผู้ซื้อตรวจสอบสิทธิการเข้าออกก่อนเสนอซื้อ ผู้ซื้อควรให้ SAM และสำนักงานที่ดินยืนยันขอบเขตภาระจำยอม ผู้มีสิทธิใช้ทาง ภาระค่าบำรุงรักษา ทางเข้าออกที่ใช้ได้จริง และเงื่อนไขอื่นทั้งหมด\n\nการเดินทางใช้ถนนสุราษฎร์ธานี-กองบิน 7 (ทล.417) จากแยกบางใหญ่มุ่งหน้าอำเภอพุนพิน ผ่านโลตัส สุราษฎร์ธานี เซ็นทรัล สุราษฎร์ธานี และโฮมโปร สุราษฎร์ธานี ทรัพย์อยู่ด้านซ้ายตรงข้ามโชว์รูมฮอนด้าไดมอนด์สุราษฎร์ สถานที่ใกล้เคียงที่ SAM ระบุ ได้แก่ โรงพยาบาลกรุงเทพสุราษฎร์ โฮมโปร สุราษฎร์ธานี วัดสุนทรนิวาส สำนักงานเทศบาลตำบลวัดประดู่ และเซ็นทรัล สุราษฎร์ธานี บริเวณโดยรอบเป็นย่านที่อยู่อาศัยและพาณิชยกรรม อยู่ในผังเมืองสีชมพู และ SAM ระบุว่าการเดินทางสะดวกพร้อมสาธารณูปโภค\n\nหน้า SAM ระบุสถานะ “ซื้อตรง” และราคาประกาศขาย 5,078,000 บาท ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน ค่าใช้จ่าย สถานะการครอบครอง สิทธิทางเข้าออก และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ SL0075 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nหน้าต้นทางไม่ระบุวันที่ของข้อมูลรายละเอียด สถานะผู้ใช้ประโยชน์ พื้นที่ใช้สอย ที่จอดรถ อายุอาคาร หรือภาระผูกพันอื่น ภาพภายนอกระบุวันที่ 17 เมษายน 2567 และภาพภายในระบุวันที่ 11 พฤศจิกายน 2567 ผู้ซื้อควรนัดตรวจทรัพย์และตรวจสอบสภาพปัจจุบัน เอกสารสิทธิ์ ทะเบียนอาคาร ทางภาระจำยอม สาธารณูปโภค และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        5078000,
        false,
        92,
        NULL,
        NULL,
        3,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        '189/7 หมู่ 1',
        'ตรงข้ามโชว์รูมฮอนด้าไดมอนด์สุราษฎร์',
        'ถนนสุราษฎร์ธานี-กองบิน 7 (ทล.417)',
        NULL,
        9.12036736,
        99.29346988,
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
        'sam-direct-sale-three-storey-shophouse-wat-pradu-surat-thani-sl0075'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES
        (property_listing_id, 'retail'),
        (property_listing_id, 'office'),
        (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 5078000, 'total', 'THB', false
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
        (property_listing_id, 'business', 'editorial', false),
        (property_listing_id, 'homes', 'editorial', false)
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
            'listed_unit_number', '189/7',
            'title_document_type', 'chanote',
            'title_deed_number', '108758',
            'title_document_count', 1,
            'land_area_square_wah', 23,
            'land_area_sqm', 92,
            'floor_count', 3,
            'unit_count', 1,
            'plot_shape', 'rectangle',
            'north_road_frontage_m', 4.5,
            'maximum_depth_m', 20,
            'registered_transfer_description', 'ตึกแถว 3 ชั้น เลขที่ 189/7',
            'registered_address_number', '189/7',
            'bedroom_count_not_published', true,
            'bathroom_count_not_published', true,
            'usable_area_not_published', true,
            'parking_information_not_published', true,
            'building_age_not_published', true
        ) || jsonb_build_object(
            'access_type', 'private_road_with_registered_servitude',
            'front_road_legal_status_th', 'ทางส่วนบุคคลที่จดทะเบียนภาระจำยอม',
            'front_road_surface', 'concrete',
            'front_road_width_m', 5,
            'front_right_of_way_width_m', 6,
            'right_of_way_access_requires_buyer_verification', true,
            'main_access_road', 'ถนนสุราษฎร์ธานี-กองบิน 7 (ทล.417)',
            'zoning_color_th', 'สีชมพู',
            'surrounding_area_use_th', 'ที่อยู่อาศัยและพาณิชยกรรม',
            'source_states_convenient_transportation', true,
            'source_states_utilities_available', true,
            'occupancy_status_not_published', true,
            'other_encumbrances_not_published', true,
            'source_information_date_not_published', true,
            'source_exterior_photo_date_displayed', '2024-04-17',
            'source_interior_photo_date_displayed', '2024-11-11',
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-09',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '9.120368,99.293469',
            'administrator_coordinate_distance_from_source_m_approx', 0.12
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for SL0075. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนสุราษฎร์ธานี-กองบิน 7 (ทล.417)', 'Surat Thani–Wing 7 Road (Highway 417)', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'โรงพยาบาลกรุงเทพสุราษฎร์', 'Bangkok Hospital Surat', 'healthcare', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'โฮมโปร สุราษฎร์ธานี', 'HomePro Surat Thani', 'shopping', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'เซ็นทรัล สุราษฎร์ธานี', 'Central Surat Thani', 'shopping', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'วัดสุนทรนิวาส', 'Wat Suntharanivas', 'landmark', NULL, NULL, NULL, 50, true),
        (property_listing_id, 'สำนักงานเทศบาลตำบลวัดประดู่', 'Wat Pradu Subdistrict Municipality Office', 'government', NULL, NULL, NULL, 60, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '5,078,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 5,078,000 — confirm the latest price with SAM', 'unspecified', 5078000, 'THB', 20),
        (property_listing_id, 'registered_structure', 'สิ่งปลูกสร้างตามรายการรับโอน', 'Structure in acquisition records', 'รายการรับโอนของ SAM ระบุตึกแถว 3 ชั้น เลขที่ 189/7 บนโฉนดเลขที่ 108758', 'SAM''s acquisition record identifies a three-storey row building numbered 189/7 on title deed no. 108758', 'unspecified', NULL, '', 30),
        (property_listing_id, 'private_road_servitude', 'ทางเข้าออกและภาระจำยอม', 'Access and registered servitude', 'หน้าทรัพย์ติดทางส่วนบุคคลที่จดทะเบียนภาระจำยอม ผู้ซื้อต้องตรวจสอบสิทธิการเข้าออกและเงื่อนไขกับ SAM และสำนักงานที่ดินก่อนเสนอซื้อ', 'The property fronts a private road with a registered servitude; buyers must verify access rights and conditions with SAM and the Land Office before making an offer', 'buyer', NULL, '', 40),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนเสนอซื้อ', 'Buyer due diligence', 'ผู้ซื้อต้องตรวจสอบสภาพปัจจุบัน โฉนด ทะเบียนอาคาร ขอบเขตภาระจำยอม ผู้มีสิทธิใช้ทาง สถานะการครอบครอง สาธารณูปโภค ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขล่าสุดกับ SAM', 'Buyers must verify current condition, title and building records, servitude boundaries and beneficiaries, possession, utilities, encumbrances, expenses and current terms with SAM', 'buyer', NULL, '', 50)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ด้านหน้าอาคารพาณิชย์ 3 ชั้น', 'อาคารพาณิชย์ 3 ชั้น เลขที่ 189/7 วัดประดู่ รหัส SAM SL0075', 'https://npa.sam.or.th/site/images/npa/21676/20240806111735_SL0075P2_67.jpg', '/listing-media/sam/sl0075/01.webp', 'image/webp', 34834, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมด้านหน้าใกล้ตัวอาคาร', 'ภาพด้านหน้าอาคารพาณิชย์ 3 ชั้นและแนวห้องชุดติดกัน รหัส SL0075', 'https://npa.sam.or.th/site/images/npa/21676/SL0075P3_67.jpg', '/listing-media/sam/sl0075/02.webp', 'image/webp', 34666, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องภายในพร้อมช่องแสง', 'ห้องภายในอาคารพาณิชย์พร้อมพื้นกระเบื้องและช่องแสงด้านหลัง', 'https://npa.sam.or.th/site/images/npa/21676/P1_67.jpg', '/listing-media/sam/sl0075/03.webp', 'image/webp', 7524, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ภายในติดกระจกด้านหน้า', 'พื้นที่โล่งภายในอาคารพาณิชย์พร้อมแนวกระจกด้านหน้า', 'https://npa.sam.or.th/site/images/npa/21676/P2_67.jpg', '/listing-media/sam/sl0075/04.webp', 'image/webp', 7832, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำภายใน', 'ห้องน้ำภายในอาคารพาณิชย์พร้อมโถสุขภัณฑ์และอ่างล้างหน้า', 'https://npa.sam.or.th/site/images/npa/21676/P3_67.jpg', '/listing-media/sam/sl0075/05.webp', 'image/webp', 7650, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำพร้อมพื้นที่อาบน้ำ', 'ห้องน้ำภายในพร้อมโถสุขภัณฑ์ อ่างล้างหน้า และพื้นที่อาบน้ำ', 'https://npa.sam.or.th/site/images/npa/21676/P4_67.jpg', '/listing-media/sam/sl0075/06.webp', 'image/webp', 9284, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่โล่งภายในอาคาร', 'พื้นที่ภายในอาคารพาณิชย์พร้อมกระจกหลายด้านและพื้นกระเบื้อง', 'https://npa.sam.or.th/site/images/npa/21676/P5_67.jpg', '/listing-media/sam/sl0075/07.webp', 'image/webp', 7548, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บันไดภายในอาคาร', 'บันไดเชื่อมแต่ละชั้นของอาคารพาณิชย์ 3 ชั้น', 'https://npa.sam.or.th/site/images/npa/21676/P6_67.jpg', '/listing-media/sam/sl0075/08.webp', 'image/webp', 11430, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำอีกจุดหนึ่ง', 'ห้องน้ำภายในอาคารพาณิชย์พร้อมพื้นที่อาบน้ำ', 'https://npa.sam.or.th/site/images/npa/21676/P8_67.jpg', '/listing-media/sam/sl0075/09.webp', 'image/webp', 6144, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงภายในและบันได', 'พื้นที่โถงภายในอาคารพาณิชย์มองไปยังบันได', 'https://npa.sam.or.th/site/images/npa/21676/P9_67.jpg', '/listing-media/sam/sl0075/10.webp', 'image/webp', 7756, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ชั้นล่างด้านหน้า', 'พื้นที่โล่งชั้นล่างพร้อมแนวตู้และกระจกด้านหน้าอาคาร', 'https://npa.sam.or.th/site/images/npa/21676/P10_67.jpg', '/listing-media/sam/sl0075/11.webp', 'image/webp', 9500, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่โล่งอีกมุมหนึ่ง', 'พื้นที่โล่งภายในอาคารพาณิชย์และแนวตู้ด้านข้าง', 'https://npa.sam.or.th/site/images/npa/21676/P11_67.jpg', '/listing-media/sam/sl0075/12.webp', 'image/webp', 7380, 450, 450, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ด้านหลังมีหลังคาคลุม', 'พื้นที่ด้านหลังอาคารพาณิชย์พร้อมหลังคาเมทัลชีท', 'https://npa.sam.or.th/site/images/npa/21676/P7_67.jpg', '/listing-media/sam/sl0075/13.webp', 'image/webp', 18288, 450, 450, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้าจากถนน ทล.417', 'ภาพทางเข้าทรัพย์จากถนนสุราษฎร์ธานี-กองบิน 7 ทางหลวงหมายเลข 417', 'https://npa.sam.or.th/site/images/npa/21676/SL0075P1_67.jpg', '/listing-media/sam/sl0075/14.webp', 'image/webp', 13010, 450, 450, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังแปลง 23 ตารางวา', 'ผังโฉนดเลขที่ 108758 แสดงแปลงกว้างประมาณ 4.5 เมตรและลึกประมาณ 20 เมตร', 'https://npa.sam.or.th/site/images/npa/21676/20240806111735_SL0075C1_67.jpg', '/listing-media/sam/sl0075/15.webp', 'image/webp', 11140, 450, 450, 150, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังตำแหน่งอาคารบนแปลง', 'ผังต้นทางแสดงอาคารพาณิชย์ 3 ชั้น เลขที่ 189/7 บนแปลงที่ดิน', 'https://npa.sam.or.th/site/images/npa/21676/20240806111735_SL0075C2_67.jpg', '/listing-media/sam/sl0075/16.webp', 'image/webp', 16348, 450, 450, 160, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แผนที่การเดินทางและสถานที่ใกล้เคียง', 'แผนที่ต้นทางแสดงตำแหน่งทรัพย์ใกล้ถนน ทล.417 และสถานที่สำคัญในวัดประดู่', 'https://npa.sam.or.th/site/images/npa/21676/20240813094439_SL0075M_67%20(New).jpg', '/listing-media/sam/sl0075/17.webp', 'image/webp', 47484, 785, 600, 170, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=21676',
        'SL0075',
        '2026-09-09 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 5,078,000 for one three-storey shophouse numbered 189/7 on title deed no. 108758 covering 23 sq.wah / 92 sq.m. The rectangular plot has approximately 4.5 meters of northern road frontage and a depth of approximately 20 meters. The property fronts a private concrete road with a registered servitude; the carriageway is approximately five meters wide within an approximately six-meter right of way, and SAM explicitly advises buyers to verify ingress and egress rights before making an offer. The page does not publish bedroom or bathroom counts, usable area, parking, building age, occupancy, other encumbrances or the information date. Exterior photos display 17 April 2024 and interior photos display 11 November 2024. Administrator-supplied coordinates are approximately 0.12 meters from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all seventeen source property, interior, access, plot and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Three-Storey Shophouse in Wat Pradu, Surat Thani, THB 5.078M',
        E'Three-storey shophouse numbered 189/7, Moo 1, Wat Pradu, Mueang Surat Thani, Surat Thani, on 23 sq.wah (92 sq.m.) of land under title deed no. 108758. SAM''s acquisition record describes a three-storey row building numbered 189/7.\n\nThe rectangular plot has approximately 4.5 meters of northern frontage and a depth of approximately 20 meters. Source photos show the unit in an attached commercial-building row, with several open interior areas, sanitary facilities, stairs and a rear covered area. SAM does not publish bedroom or bathroom counts, usable area, parking or building age, so counts should not be inferred from the photographs alone.\n\nImportant access issue: the property fronts an internal private road that SAM describes as subject to a registered servitude. The concrete carriageway is approximately five meters wide within an approximately six-meter right of way. SAM advises buyers to verify ingress and egress rights before submitting an offer. Buyers should ask SAM and the Land Office to confirm the servitude boundaries, beneficiaries, maintenance obligations, practical access and all related conditions.\n\nAccess is from Surat Thani–Wing 7 Road (Highway 417), travelling from Bang Yai intersection toward Phunphin past Lotus Surat Thani, Central Surat Thani and HomePro Surat Thani. The property is on the left opposite the Honda Diamond Surat showroom. Nearby places listed by SAM include Bangkok Hospital Surat, HomePro Surat Thani, Wat Suntharanivas, the Wat Pradu Subdistrict Municipality Office and Central Surat Thani. SAM describes the surrounding area as residential and commercial, with pink zoning, convenient transport and utilities.\n\nThe SAM page lists the property as direct purchase with an announced sale price of THB 5,078,000. It is not an auction. Contact SAM directly to confirm availability, offer procedures, current price, expenses, possession, access rights and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: SL0075. MapxProp does not collect deposits or represent SAM in the transaction.\n\nThe source does not publish an information date, possession status, usable area, parking, building age or other encumbrances. Exterior photos display 17 April 2024 and interior photos display 11 November 2024. Buyers should arrange an inspection and verify current condition, title and building records, the registered servitude, utilities and all terms before deciding.',
        '189/7, Moo 1',
        'Opposite Honda Diamond Surat showroom',
        'Surat Thani–Wing 7 Road (Highway 417)',
        'Wat Pradu',
        'Mueang Surat Thani',
        'Surat Thani',
        'SAM Direct-Sale Three-Storey Shophouse in Wat Pradu, THB 5.078M',
        'Official SAM NPA asset SL0075: three-storey shophouse on 92 sq.m. Direct-sale price THB 5.078M; registered-servitude access disclosed.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset SL0075 three storey shophouse commercial building Wat Pradu Mueang Surat Thani Highway 417 23 sq.wah 92 sq.m. title deed 108758 THB 5078000 address 189/7 private road registered servitude')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=21676'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=21676',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for SL0075. The specifications, images, rounded coordinates, announced price, direct-purchase status and registered-servitude access warning come from that record.',
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
        '1f20cba4-680b-478b-ad80-cafe0f763589',
        jsonb_build_object(
            'reference_code', 'SL0075',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'private_road_with_registered_servitude', true,
            'access_rights_require_buyer_verification', true
        )
    );
END $$;

COMMIT;
