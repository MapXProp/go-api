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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing 1P0006';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing 1P0006';
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
        custom_unit_number,
        title,
        description,
        sale_price,
        price_negotiable,
        land_area_sqm,
        usable_area_sqm,
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
        '0b7f9677-7804-45e4-887f-7b74cbb8f98b',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'shophouse',
        'mixed',
        'sale',
        'whole_property',
        '388',
        'ขายตรง SAM อาคารพาณิชย์ 3 ชั้น ต่อเติมเป็น 5 ชั้น ถนนเจริญกรุง ใกล้ MRT วัดมังกร ราคา 34.946 ล้านบาท',
        E'อาคารพาณิชย์เลขที่ 388 ถนนเจริญกรุง แขวงจักรวรรดิ เขตสัมพันธวงศ์ กรุงเทพมหานคร บนที่ดิน 23 ตร.ว. (92 ตร.ม.) โฉนดที่ดินเลขที่ 2786 จำนวน 1 ฉบับ มี 7 ห้องนอน 3 ห้องน้ำ และพื้นที่ใช้สอยรวมประมาณ 374 ตร.ม. เหมาะสำหรับพิจารณาใช้เป็นที่อยู่อาศัย หน้าร้าน สำนักงาน หรือใช้งานแบบผสม ทั้งนี้ต้องตรวจข้อกำหนดและความเหมาะสมกับกิจการจริงก่อนซื้อ

ข้อควรตรวจสอบสำคัญ: รายการรับโอนกรรมสิทธิ์ของ SAM ระบุสิ่งปลูกสร้างเป็นอาคารพาณิชย์ 3 ชั้น เลขที่ 388 แต่ข้อมูลการสำรวจสภาพทรัพย์ระบุว่าเป็นตึกแถว 3 ชั้นที่ต่อเติมเป็น 5 ชั้น ผู้ซื้อต้องให้ SAM สำนักงานเขต และสำนักงานที่ดินยืนยันทะเบียนอาคาร แบบแปลน ใบอนุญาต ความถูกต้องของส่วนต่อเติม พื้นที่ใช้สอย และรายการสิ่งปลูกสร้างที่จะโอน ไม่ควรถือว่าชั้นที่ 4–5 ได้รับอนุญาตเพียงเพราะปรากฏในสภาพจริงหรือชุดภาพ

ที่ดินเป็นรูปหลายเหลี่ยม ด้านทิศเหนือติดถนนเจริญกรุง หน้ากว้างประมาณ 3 เมตร และลึกสูงสุดประมาณ 18 เมตร ถนนเจริญกรุงเป็นทางสาธารณประโยชน์ ผิวจราจรลาดยางกว้างประมาณ 12 เมตร เขตทางกว้างประมาณ 18 เมตร ทรัพย์ตั้งอยู่ในย่านพาณิชยกรรม เขตผังเมืองสีแดง และหน้า SAM ระบุว่ามีระบบสาธารณูปโภคครบครัน

ทำเลอยู่ตรงข้ามเสือป่าพลาซ่า ห่างสถานี MRT วัดมังกรประมาณ 300 เมตร การเข้าถึงตามข้อมูล SAM ใช้ถนนเจริญกรุงจากถนนมหาไชยมุ่งหน้าหัวลำโพง ผ่านแยกถนนวรจักรและแยกถนนมหาจักร ถึงซอยเจริญกรุง 12 แล้วตรงประมาณ 40 เมตร ทรัพย์อยู่ด้านขวามือ สถานที่ใกล้เคียงที่ SAM ระบุ ได้แก่ ย่านเยาวราช วัดมังกรกมลาวาส วัดชัยชนะสงคราม และโรงพยาบาลกลาง

หน้า SAM ระบุสถานะ “ซื้อตรง” และราคาประกาศขาย 34,946,000 บาท ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน ค่าใช้จ่าย สถานะการครอบครอง และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ 1P0006 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM

ภาพสภาพทรัพย์ในหน้าต้นทางแสดงวันที่ 15 กุมภาพันธ์ 2568 สภาพจริงอาจเปลี่ยนแปลง หน้า SAM ไม่ระบุสถานะผู้ใช้ประโยชน์ ที่จอดรถ อายุอาคาร หรือภาระผูกพันอื่น ผู้ซื้อควรนัดตรวจทรัพย์ ตรวจโครงสร้างและความปลอดภัยของอาคาร 5 ชั้น ทางหนีไฟ ระบบไฟฟ้าและสาธารณูปโภค การครอบครอง ทางเข้าออก ภาระผูกพัน ทะเบียนอาคาร ส่วนต่อเติม การใช้ประโยชน์ และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        34946000,
        false,
        92,
        374,
        7,
        3,
        5,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        '388',
        'ตรงข้ามเสือป่าพลาซ่า ใกล้สถานี MRT วัดมังกรประมาณ 300 เมตร',
        'ถนนเจริญกรุง',
        NULL,
        13.74391117,
        100.50768522,
        'กรุงเทพมหานคร',
        'สัมพันธวงศ์',
        'จักรวรรดิ',
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
        'sam-direct-sale-five-storey-shophouse-charoen-krung-wat-mangkon-1p0006'
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
        property_listing_id, 'sale', 34946000, 'total', 'THB', false
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
            'listed_unit_number', '388',
            'title_document_type', 'chanote',
            'title_deed_number', '2786',
            'title_document_count', 1,
            'land_area_square_wah', 23,
            'land_area_sqm', 92,
            'bedroom_count', 7,
            'bathroom_count', 3,
            'usable_area_sqm_approx', 374,
            'registered_transfer_description', 'อาคารพาณิชย์ 3 ชั้น เลขที่ 388',
            'registered_address_number', '388',
            'registered_floor_count', 3,
            'surveyed_structure_description', 'ตึกแถว 3 ชั้น ต่อเติมเป็น 5 ชั้น',
            'surveyed_floor_count', 5,
            'floor_count_discrepancy_requires_verification', true,
            'extension_permit_status_not_published', true,
            'building_plan_status_not_published', true,
            'plot_shape', 'polygon',
            'north_road_frontage_m', 3,
            'maximum_depth_m', 18,
            'front_road_name', 'ถนนเจริญกรุง',
            'front_road_legal_status_th', 'ทางสาธารณประโยชน์',
            'front_road_surface', 'asphalt',
            'front_road_width_m', 12,
            'front_right_of_way_width_m', 18
        ) || jsonb_build_object(
            'zoning_color_th', 'สีแดง ตามหน้า SAM',
            'surrounding_area_use_th', 'ย่านพาณิชยกรรม',
            'source_states_utilities_available', true,
            'distance_to_mrt_wat_mangkon_m_approx', 300,
            'opposite_landmark', 'เสือป่าพลาซ่า',
            'mixed_use_classification', true,
            'mixed_use_basis', 'อาคารพาณิชย์มี 7 ห้องนอน 3 ห้องน้ำ อยู่ในย่านพาณิชยกรรม และผู้ดูแลระบบกำหนดให้รองรับทั้งที่อยู่อาศัยและธุรกิจ',
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'computed_price_per_square_wah', 1519391.30,
            'source_does_not_publish_price_per_square_wah', true,
            'occupancy_status_not_published', true,
            'parking_information_not_published', true,
            'building_age_not_published', true,
            'other_encumbrances_not_published', true,
            'source_information_date_not_published', true,
            'source_property_photo_date_displayed', '2025-02-15',
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-09',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '13.7438076,100.5076438',
            'administrator_coordinate_distance_from_source_m_approx', 12.36
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 1P0006. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนเจริญกรุง', 'Charoen Krung Road', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'สถานี MRT วัดมังกร', 'Wat Mangkon MRT Station', 'transit', 300, NULL, NULL, 20, true),
        (property_listing_id, 'เสือป่าพลาซ่า', 'Suea Pa Plaza', 'shopping', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'ย่านเยาวราช', 'Yaowarat', 'landmark', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'วัดมังกรกมลาวาส', 'Wat Mangkon Kamalawat', 'landmark', NULL, NULL, NULL, 50, false),
        (property_listing_id, 'วัดชัยชนะสงคราม', 'Wat Chai Chana Songkhram', 'landmark', NULL, NULL, NULL, 60, false),
        (property_listing_id, 'โรงพยาบาลกลาง', 'BMA General Hospital', 'healthcare', NULL, NULL, NULL, 70, false)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '34,946,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 34,946,000 — confirm the latest price with SAM', 'unspecified', 34946000, 'THB', 20),
        (property_listing_id, 'title_document', 'เอกสารสิทธิ์', 'Title document', 'โฉนดที่ดินเลขที่ 2786 จำนวน 1 ฉบับ เนื้อที่ 23 ตร.ว.', 'One title deed, no. 2786, covering 23 sq.wah', 'unspecified', 1, 'documents', 30),
        (property_listing_id, 'registered_vs_surveyed_structure', 'ชั้นตามทะเบียนและสภาพสำรวจ', 'Registered and surveyed floors', 'รายการรับโอนระบุอาคารพาณิชย์ 3 ชั้น แต่สภาพสำรวจระบุต่อเติมเป็น 5 ชั้น ต้องตรวจทะเบียนและใบอนุญาตส่วนต่อเติม', 'Acquisition records identify three storeys, while the survey reports an extension to five; verify registration and extension permits', 'buyer', 5, 'floors', 40),
        (property_listing_id, 'usable_area', 'พื้นที่ใช้สอยโดยประมาณ', 'Approximate usable area', 'ประมาณ 374 ตร.ม. ตามข้อมูลสำรวจของ SAM — โปรดตรวจสอบและวัดจริง', 'Approximately 374 sq.m. per the SAM survey; verify by inspection and measurement', 'buyer', 374, 'sqm', 50),
        (property_listing_id, 'mixed_use', 'ลักษณะการใช้งาน', 'Use classification', 'MapxProp จัดเป็น Mixed use สำหรับค้นหาได้ทั้งหมวดที่อยู่อาศัยและธุรกิจ การใช้จริงต้องตรวจข้อกำหนดอาคารและกิจการ', 'MapxProp classifies the listing as mixed use for both homes and business discovery; verify building and business-use requirements', 'buyer', NULL, '', 60),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนด แนวเขต ทะเบียนอาคาร แบบแปลน ใบอนุญาตส่วนต่อเติม โครงสร้าง ทางหนีไฟ การครอบครอง ทางเข้าออก สาธารณูปโภค ภาระผูกพัน การใช้ประโยชน์ ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Verify title, boundaries, building registration, plans, extension permits, structure, fire escape, possession, access, utilities, encumbrances, permitted use, costs and current terms', 'buyer', NULL, '', 70)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ด้านหน้าอาคารพาณิชย์เลขที่ 388', 'อาคารพาณิชย์ SAM รหัส 1P0006 ริมถนนเจริญกรุง ตรงข้ามเสือป่าพลาซ่า', 'https://npa.sam.or.th/site/images/npa/10694/20260202102945_1P0006P2_69.jpg', '/listing-media/sam/1p0006/01.webp', 'image/webp', 37688, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังอาคารชั้นที่ 1', 'ผังต้นทางแสดงพื้นที่อาคารพาณิชย์ชั้นที่ 1 และส่วนต่อเติม', 'https://npa.sam.or.th/site/images/npa/10694/C1.jpg', '/listing-media/sam/1p0006/02.webp', 'image/webp', 17490, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังอาคารชั้นที่ 2–3', 'ผังต้นทางแสดงพื้นที่อาคารพาณิชย์ชั้นที่ 2 และชั้นที่ 3', 'https://npa.sam.or.th/site/images/npa/10694/C2.jpg', '/listing-media/sam/1p0006/03.webp', 'image/webp', 18116, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังอาคารชั้นที่ 4', 'ผังต้นทางแสดงพื้นที่อาคารชั้นที่ 4 ซึ่งเป็นส่วนที่ต้องตรวจสอบสถานะการต่อเติม', 'https://npa.sam.or.th/site/images/npa/10694/C3.jpg', '/listing-media/sam/1p0006/04.webp', 'image/webp', 27224, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังอาคารชั้นที่ 5', 'ผังต้นทางแสดงพื้นที่อาคารชั้นที่ 5 ซึ่งเป็นส่วนที่ต้องตรวจสอบสถานะการต่อเติม', 'https://npa.sam.or.th/site/images/npa/10694/C4.jpg', '/listing-media/sam/1p0006/05.webp', 'image/webp', 19306, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมกว้างหน้าอาคาร', 'ภาพมุมกว้างแสดงอาคารพาณิชย์เลขที่ 388 และแนวถนนเจริญกรุง', 'https://npa.sam.or.th/site/images/npa/10694/1P0006P3_69.jpg', '/listing-media/sam/1p0006/06.webp', 'image/webp', 44264, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'อาคารและแนวถนนหน้าแปลง', 'ภาพอาคารพาณิชย์ริมถนนเจริญกรุงในย่านสัมพันธวงศ์', 'https://npa.sam.or.th/site/images/npa/10694/1P0006P1_69.jpg', '/listing-media/sam/1p0006/07.webp', 'image/webp', 39294, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ด้านหน้าและทางเท้า', 'ภาพด้านหน้าอาคาร ทางเท้า และสภาพแวดล้อมริมถนนเจริญกรุง', 'https://npa.sam.or.th/site/images/npa/10694/1P0006P4_69.jpg', '/listing-media/sam/1p0006/08.webp', 'image/webp', 40910, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บริเวณข้างอาคาร', 'ภาพทางและสภาพแวดล้อมบริเวณข้างอาคารพาณิชย์ SAM 1P0006', 'https://npa.sam.or.th/site/images/npa/10694/1P0006P5_69.jpg', '/listing-media/sam/1p0006/09.webp', 'image/webp', 23780, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงภายในอาคาร', 'ภาพโถงทางเดินและสภาพภายในอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/10694/1P0006P6_69.jpg', '/listing-media/sam/1p0006/10.webp', 'image/webp', 13784, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเดินภายใน', 'ภาพทางเดินภายในอาคารมองออกไปทางด้านหน้า', 'https://npa.sam.or.th/site/images/npa/10694/1P0006P9_69.jpg', '/listing-media/sam/1p0006/11.webp', 'image/webp', 14050, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่บริการภายใน', 'ภาพพื้นที่ภายในพร้อมเคาน์เตอร์และบันได', 'https://npa.sam.or.th/site/images/npa/10694/1P0006P11_69.jpg', '/listing-media/sam/1p0006/12.webp', 'image/webp', 11914, 450, 450, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่โถงและหน้าต่าง', 'ภาพพื้นที่โถงภายในอาคารพร้อมหน้าต่างด้านหน้า', 'https://npa.sam.or.th/site/images/npa/10694/1P0006P12_69.jpg', '/listing-media/sam/1p0006/13.webp', 'image/webp', 11692, 450, 450, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงใกล้บันได', 'ภาพพื้นที่ภายในชั้นอาคารและทางขึ้นลงบันได', 'https://npa.sam.or.th/site/images/npa/10694/1P0006P13_69.jpg', '/listing-media/sam/1p0006/14.webp', 'image/webp', 10516, 450, 450, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องภายในอาคาร', 'ภาพห้องภายในอาคารพาณิชย์พร้อมหน้าต่างและพื้นกระเบื้อง', 'https://npa.sam.or.th/site/images/npa/10694/1P0006P15_69.jpg', '/listing-media/sam/1p0006/15.webp', 'image/webp', 11902, 450, 450, 150, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวห้องและทางเดิน', 'ภาพแนวห้องและทางเดินภายในอาคาร', 'https://npa.sam.or.th/site/images/npa/10694/1P0006P16_69.jpg', '/listing-media/sam/1p0006/16.webp', 'image/webp', 13292, 450, 450, 160, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำภายในอาคาร', 'ภาพสภาพห้องน้ำและพื้นที่เปียกภายในอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/10694/1P0006P18_69.jpg', '/listing-media/sam/1p0006/17.webp', 'image/webp', 10264, 450, 450, 170, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ห้องแนวยาว', 'ภาพพื้นที่ห้องภายในอาคารในแนวยาว', 'https://npa.sam.or.th/site/images/npa/10694/1P0006P21_69.jpg', '/listing-media/sam/1p0006/18.webp', 'image/webp', 12306, 450, 450, 180, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเดินและประตูห้อง', 'ภาพทางเดินภายในพร้อมประตูเชื่อมพื้นที่แต่ละส่วน', 'https://npa.sam.or.th/site/images/npa/10694/1P0006P22_69.jpg', '/listing-media/sam/1p0006/19.webp', 'image/webp', 12664, 450, 450, 190, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำและอ่างอาบน้ำ', 'ภาพห้องน้ำภายในอาคารพร้อมอ่างอาบน้ำ', 'https://npa.sam.or.th/site/images/npa/10694/1P0006P24_69.jpg', '/listing-media/sam/1p0006/20.webp', 'image/webp', 15346, 450, 450, 200, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องด้านหลังอาคาร', 'ภาพห้องและพื้นที่ใช้สอยบริเวณด้านหลังอาคาร', 'https://npa.sam.or.th/site/images/npa/10694/1P0006P28_69.jpg', '/listing-media/sam/1p0006/21.webp', 'image/webp', 15076, 450, 450, 210, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ชั้นบนหลังคาคลุม', 'ภาพพื้นที่ชั้นบนและโครงสร้างหลังคาคลุมของอาคาร', 'https://npa.sam.or.th/site/images/npa/10694/1P0006P29_69.jpg', '/listing-media/sam/1p0006/22.webp', 'image/webp', 25434, 450, 450, 220, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังรูปแปลงที่ดิน', 'ผังต้นทางแสดงรูปแปลงที่ดินหลายเหลี่ยม โฉนดเลขที่ 2786 และขนาดแนวเขต', 'https://npa.sam.or.th/site/images/npa/10694/20170718165140_1P0006C1_60.jpg', '/listing-media/sam/1p0006/23.webp', 'image/webp', 9324, 450, 450, 230, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังอาคารบนแปลง', 'ผังต้นทางแสดงตำแหน่งอาคารพาณิชย์และส่วนต่อเติมบนแปลงที่ดิน', 'https://npa.sam.or.th/site/images/npa/10694/20170718165140_1P0006C2_60.jpg', '/listing-media/sam/1p0006/24.webp', 'image/webp', 10906, 450, 450, 240, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปทรัพย์', 'แผนที่ต้นทางแสดงตำแหน่งทรัพย์ 1P0006 บนถนนเจริญกรุง ใกล้เยาวราชและสถานี MRT วัดมังกร', 'https://npa.sam.or.th/site/images/npa/10694/20170718165140_1P0006M1_60.jpg', '/listing-media/sam/1p0006/25.webp', 'image/webp', 38776, 785, 600, 250, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=10694&keyref=6004080',
        '1P0006',
        '2026-09-09 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 34,946,000 for a shophouse at 388 Charoen Krung Road on title deed no. 2786 covering 23 sq.wah / 92 sq.m. SAM publishes seven bedrooms, three bathrooms and approximately 374 sq.m. of usable area. The acquisition record identifies a three-storey commercial building, while the condition survey reports a three-storey row building extended to five storeys; extension registration, plans and permits are not published and require verification. The polygonal plot has approximately three meters of north-facing frontage and a maximum depth of approximately 18 meters. Charoen Krung Road is described as a public asphalt road approximately 12 meters wide within an approximately 18-meter right of way. The source identifies a red planning zone, a commercial district, full utilities and Wat Mangkon MRT Station approximately 300 meters away. Occupancy, parking, building age and other encumbrances are not published. Source property photos display 15 February 2025. Administrator coordinates are approximately 12.36 meters from the source coordinates and are used for the listing. MapxProp stores optimized copies of all 25 unique source property, floor-plan, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Five-Storey Shophouse on Charoen Krung Road near Wat Mangkon MRT, THB 34.946M',
        E'A commercial shophouse at 388 Charoen Krung Road, Chakkrawat, Samphanthawong, Bangkok, on 23 sq.wah (92 sq.m.) of land under title deed no. 2786. SAM publishes seven bedrooms, three bathrooms and approximately 374 sq.m. of usable area. The property may be considered for residential, retail, office or mixed use, subject to verification of building and business-use requirements.

Important building-record caveat: SAM''s acquisition record identifies a three-storey commercial building numbered 388, while its condition survey describes a three-storey row building extended to five storeys. Buyers must ask SAM, the district office and the Land Office to confirm building registration, approved plans, permits, legality of the extensions, usable area and every structure included in the transfer. The fourth and fifth storeys should not be assumed to be permitted merely because they exist physically or appear in the source images.

The polygonal plot has approximately three meters of north-facing frontage on Charoen Krung Road and a maximum depth of approximately 18 meters. Charoen Krung Road is a public asphalt road approximately 12 meters wide within an approximately 18-meter right of way. SAM identifies a red planning zone, a commercial district and complete utilities.

The property is opposite Suea Pa Plaza and approximately 300 meters from Wat Mangkon MRT Station. SAM''s directions approach along Charoen Krung Road from Maha Chai Road toward Hua Lamphong, passing Worachak and Maha Chak intersections, then continuing about 40 meters beyond Charoen Krung Soi 12. Nearby destinations listed by SAM include Yaowarat, Wat Mangkon Kamalawat, Wat Chai Chana Songkhram and BMA General Hospital.

The SAM page lists the property for direct purchase at an announced price of THB 34,946,000. It is not an auction. Contact SAM directly to confirm availability, offer procedures, current price, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: 1P0006. MapxProp does not collect deposits or represent SAM in the transaction.

Source property photos display 15 February 2025, and conditions may have changed. The page does not publish occupancy, parking, building age or other encumbrances. Buyers should inspect the five-storey structure, fire escape, electrical and utility systems, possession, access, encumbrances, building registration, extensions, permitted use, costs and every current term before deciding.',
        '388',
        'Opposite Suea Pa Plaza, approximately 300 meters from Wat Mangkon MRT Station',
        'Charoen Krung Road',
        'Chakkrawat',
        'Samphanthawong',
        'Bangkok',
        'SAM Mixed-Use Shophouse near Wat Mangkon MRT, THB 34.946M',
        'Official SAM NPA asset 1P0006: Charoen Krung shophouse with 7 bedrooms, 3 bathrooms and approximately 374 sq.m. of usable area. Direct-sale price THB 34.946M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset 1P0006 mixed use shophouse commercial building 388 Charoen Krung Road Chakkrawat Samphanthawong Bangkok Yaowarat Wat Mangkon MRT Suea Pa Plaza 23 sq.wah 92 sq.m. 374 sq.m. usable area title deed 2786 seven bedrooms three bathrooms three storeys extended to five storeys THB 34946000')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=10694&keyref=6004080'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=10694&keyref=6004080',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 1P0006. Specifications, title deed, images, rounded coordinates, announced price, direct-purchase status, road measurements, nearby places and the registered-versus-surveyed floor-count discrepancy come from that record.',
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
        '0b7f9677-7804-45e4-887f-7b74cbb8f98b',
        jsonb_build_object(
            'reference_code', '1P0006',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'mixed',
            'discovery_channels', jsonb_build_array('business', 'homes'),
            'title_document_count', 1,
            'floor_count_discrepancy_review_required', true,
            'extension_permit_review_required', true,
            'source_image_count', 25
        )
    );
END $$;

COMMIT;
