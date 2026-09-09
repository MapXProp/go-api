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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing BL0015';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing BL0015';
    END IF;

    INSERT INTO public.listings (
        public_listing_id,
        user_id,
        organization_id,
        created_by_user_id,
        published_by_user_id,
        property_type_code,
        accommodation_model,
        usage_type,
        listing_type,
        listing_scope,
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
        'cc39260f-3146-4138-903b-ea2fdef7ad9a',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'apartment',
        'standard',
        'residential',
        'sale',
        'whole_property',
        '142/6',
        'ขายตรง SAM อพาร์ทเมนต์ 3 ชั้น ซอยกาญจนวิถี 5 เมืองสุราษฎร์ฯ 88.2 ตร.ว. ราคา 6.855 ล้านบาท',
        E'อพาร์ทเมนต์ อาคาร คสล. 3 ชั้น เลขที่ 142/6 บนที่ดิน 88.2 ตร.ว. (352.8 ตร.ม.) ในซอยกาญจนวิถี 5 ถนนกาญจนวิถี ตำบลบางกุ้ง อำเภอเมืองสุราษฎร์ธานี จังหวัดสุราษฎร์ธานี โฉนดที่ดินเลขที่ 66239 จำนวน 1 ฉบับ

รายการรับโอนกรรมสิทธิ์ของ SAM ระบุสิ่งปลูกสร้างเป็นบ้านพักอาศัยตึก 3 ชั้น เลขที่ 142/6 ขณะที่ข้อมูลสำรวจสภาพทรัพย์ระบุเป็นอาคาร คสล. 3 ชั้น และหน้าประกาศจัดประเภทเป็นอพาร์ทเมนต์ ผู้ซื้อควรตรวจสอบทะเบียนอาคาร ใบอนุญาต จำนวนห้องที่ได้รับอนุญาต การใช้ประโยชน์ปัจจุบัน และความสอดคล้องระหว่างเอกสารกับสภาพจริงก่อนเสนอซื้อ

ที่ดินรูปหลายเหลี่ยม ด้านทิศตะวันตกติดซอยกาญจนวิถี 5 หน้ากว้างประมาณ 23.3 เมตร และลึกสุดประมาณ 46.7 เมตร SAM ระบุว่าที่ดินบางส่วนมีสภาพเป็นตะเข็บและเป็นทางเข้า-ออกของที่ดินแปลงข้างเคียง ยาวประมาณ 14.6 เมตร กว้างประมาณ 1.3 เมตร คิดเป็นพื้นที่ประมาณ 4.7 ตร.ว. ผู้ซื้อควรตรวจสอบแนวเขต สิทธิทาง ภาระจำยอม และการใช้ทางจริงกับ SAM สำนักงานที่ดิน และเจ้าของแปลงที่เกี่ยวข้อง

ถนนหน้าทรัพย์เป็นซอยกาญจนวิถี 5 ซึ่งเป็นทางสาธารณประโยชน์ ผิวจราจรลาดยางกว้างประมาณ 5 เมตร เขตทางประมาณ 7 เมตร ทรัพย์อยู่ในเขตผังเมืองสีชมพูและย่านที่อยู่อาศัย การเดินทางจากถนนกาญจนวิถีเข้าซอยกาญจนวิถี 5 ประมาณ 30 เมตร ทรัพย์อยู่ด้านซ้ายมือ สถานที่ใกล้เคียงที่ SAM ระบุ ได้แก่ ดูโฮม สาขาสุราษฎร์ธานี สหไทยการ์เด้น พลาซ่า โรงเรียนเทพมิตรศึกษา สำนักงานขนส่งจังหวัดสุราษฎร์ธานี และสำนักจัดการทรัพยากรป่าไม้ที่ 11

ข้อควรทราบสำคัญ: SAM ระบุว่ามีผู้ใช้ประโยชน์ในทรัพย์และขายตามสภาพ ผู้ซื้อต้องตรวจสอบทรัพย์ก่อนเสนอซื้อ และอาจต้องเจรจาหรือดำเนินการทางกฎหมายเพื่อเข้าครอบครองด้วยค่าใช้จ่ายของผู้ซื้อเอง โดยไม่สามารถใช้ประเด็นการครอบครองเป็นเหตุยกเลิกการเสนอซื้อหรือสัญญา หรือเรียกร้องจาก SAM ได้ ข้อมูลส่วนนี้ระบุ ณ วันที่ 14 พฤษภาคม 2567 จึงต้องสอบถามสถานะล่าสุดกับ SAM นอกจากนี้หน้าต้นทางระบุว่าทรัพย์ยังไม่พร้อมให้เข้าชมและให้ติดต่อ SAM เพื่อขอรายละเอียด

หน้า SAM ระบุสถานะ “ซื้อตรง” และราคาประกาศขาย 6,855,000 บาท ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย สถานะผู้ใช้ประโยชน์ การนัดชม ขั้นตอนเสนอซื้อ ราคา ค่าใช้จ่าย การเข้าครอบครอง และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ BL0015 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM

หน้าต้นทางไม่ระบุพื้นที่ใช้สอย จำนวนห้องพัก จำนวนห้องน้ำ ที่จอดรถ อายุอาคาร รายได้หรือสัญญาเช่า ใบอนุญาตประกอบกิจการ ระบบสาธารณูปโภค ภาระผูกพันอื่น หรือสภาพภายใน ผู้ซื้อควรตรวจโฉนด ทะเบียนและใบอนุญาตอาคาร แนวเขต สิทธิทาง สถานะผู้ใช้ประโยชน์ สัญญาเช่า รายได้จริง ระบบอาคาร ความปลอดภัยอัคคีภัย สภาพโครงสร้าง ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        6855000,
        false,
        352.8,
        3,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'อาคาร คสล. 3 ชั้น เลขที่ 142/6',
        'ซอยกาญจนวิถี 5 ห่างจากถนนกาญจนวิถีประมาณ 30 เมตร',
        'กาญจนวิถี',
        NULL,
        9.15138320,
        99.33779434,
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
        'sam-direct-sale-three-storey-apartment-kanchanawithi-5-bang-kung-bl0015'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 6855000, 'total', 'THB', false
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
        (property_listing_id, 'homes', 'editorial', false),
        (property_listing_id, 'business', 'editorial', false)
    ON CONFLICT (listing_id, channel_code) DO UPDATE SET
        source = EXCLUDED.source,
        is_featured = EXCLUDED.is_featured,
        updated_at = now();

    INSERT INTO public.listing_category_details (
        listing_id, category_code, schema_version, details, is_minimum_submission
    ) VALUES (
        property_listing_id,
        'apartment',
        1,
        jsonb_build_object(
            'source_property_category', 'อพาร์ทเมนท์',
            'accommodation_model', 'standard',
            'title_document_type', 'chanote',
            'title_deed_number', '66239',
            'title_document_count', 1,
            'land_area_square_wah', 88.2,
            'land_area_sqm', 352.8,
            'floor_count', 3,
            'building_count', 1,
            'registered_address_number', '142/6',
            'registered_transfer_description', 'บ้านพักอาศัยตึกสามชั้น เลขที่ 142/6',
            'surveyed_structure_description', 'อาคาร คสล. 3 ชั้น เลขที่ 142/6',
            'source_listing_use_description', 'อพาร์ทเมนท์',
            'building_records_and_use_require_buyer_confirmation', true,
            'plot_shape', 'polygon',
            'west_road_frontage_m', 23.3,
            'maximum_depth_m', 46.7,
            'narrow_land_strip_length_m', 14.6,
            'narrow_land_strip_width_m', 1.3,
            'narrow_land_strip_area_square_wah_approx', 4.7,
            'narrow_land_strip_used_for_neighboring_plot_access_according_to_source', true,
            'access_rights_and_easements_require_buyer_confirmation', true,
            'access_type', 'public_road',
            'front_road_name', 'ซอยกาญจนวิถี 5',
            'front_road_surface', 'asphalt'
        ) || jsonb_build_object(
            'front_road_width_m', 5,
            'front_right_of_way_width_m', 7,
            'distance_from_kanchanawithi_road_m_approx', 30,
            'zoning_color_th', 'สีชมพู',
            'surrounding_area_use_th', 'ที่อยู่อาศัย',
            'source_states_convenient_transportation', true,
            'property_has_current_user', true,
            'occupancy_information_dated_on', '2024-05-14',
            'sold_as_is', true,
            'buyer_responsible_for_obtaining_possession', true,
            'source_visit_status', 'not_ready_for_viewing_contact_sam',
            'source_information_date', '2024-05-14',
            'source_photo_date_not_published', true,
            'usable_area_not_published', true,
            'rental_unit_count_not_published', true,
            'bathroom_count_not_published', true,
            'parking_information_not_published', true,
            'building_age_not_published', true,
            'rental_income_not_published', true,
            'lease_information_not_published', true,
            'business_license_information_not_published', true,
            'utilities_information_not_published', true,
            'other_encumbrances_not_published', true,
            'interior_condition_not_published', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-09',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '9.151383,99.337794',
            'administrator_coordinate_distance_from_source_m_approx', 0.044
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for BL0015. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ดูโฮม สาขาสุราษฎร์ธานี', 'Dohome Surat Thani', 'shopping', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'สหไทยการ์เด้น พลาซ่า สุราษฎร์ธานี', 'Sahathai Garden Plaza Surat Thani', 'shopping', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'โรงเรียนเทพมิตรศึกษา', 'Thep Mitr Suksa School', 'education', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'สำนักงานขนส่งจังหวัดสุราษฎร์ธานี', 'Surat Thani Provincial Transport Office', 'government', NULL, NULL, NULL, 50, true),
        (property_listing_id, 'สำนักจัดการทรัพยากรป่าไม้ที่ 11', 'Forest Resource Management Office 11', 'government', NULL, NULL, NULL, 60, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '6,855,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 6,855,000 — confirm the latest price with SAM', 'unspecified', 6855000, 'THB', 20),
        (property_listing_id, 'occupancy_and_possession', 'ผู้ใช้ประโยชน์และการเข้าครอบครอง', 'Current user and possession', 'มีผู้ใช้ประโยชน์ในทรัพย์ ผู้ซื้อรับผิดชอบการเจรจาหรือดำเนินการทางกฎหมายและค่าใช้จ่ายเพื่อเข้าครอบครองเอง', 'The property has a current user; the buyer is responsible for negotiations or legal action and the costs of obtaining possession', 'buyer', NULL, '', 30),
        (property_listing_id, 'sold_as_is', 'สภาพการขาย', 'Sale condition', 'ขายตามสภาพที่เป็นอยู่ ผู้ซื้อต้องตรวจสอบทรัพย์ก่อนเสนอซื้อ', 'Sold as is; buyers must inspect the property before submitting an offer', 'unspecified', NULL, '', 40),
        (property_listing_id, 'neighbor_access_strip', 'ส่วนที่ดินใช้เป็นทางเข้า-ออกแปลงข้างเคียง', 'Land strip used for neighboring access', 'SAM ระบุพื้นที่ลักษณะเป็นตะเข็บประมาณ 4.7 ตร.ว. ใช้เป็นทางเข้า-ออกของแปลงข้างเคียง ต้องตรวจสอบแนวเขต สิทธิทาง และภาระจำยอม', 'SAM reports an approximately 4.7-sq.wah narrow strip used for access to a neighboring plot; verify boundaries, access rights and easements', 'buyer', 4.7, 'sq_wah', 50),
        (property_listing_id, 'viewing_status', 'สถานะการเข้าชม', 'Viewing status', 'หน้าต้นทางระบุว่ายังไม่พร้อมให้เข้าชม กรุณาติดต่อ SAM เพื่อยืนยันสถานะและนัดหมาย', 'The source page says the property is not ready for viewing; contact SAM to confirm status and appointments', 'unspecified', NULL, '', 60),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนด ทะเบียนและใบอนุญาตอาคาร จำนวนห้อง แนวเขต สิทธิทาง ผู้ใช้ประโยชน์ สัญญาเช่า รายได้ ระบบอาคาร อัคคีภัย โครงสร้าง ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Verify the title deed, building records and permits, room count, boundaries, access rights, current users, leases, income, building and fire-safety systems, structure, encumbrances, costs and latest terms', 'buyer', NULL, '', 70)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'อาคารอพาร์ทเมนต์ 3 ชั้น BL0015', 'ภาพมุมอาคาร คสล. 3 ชั้น เลขที่ 142/6 ในซอยกาญจนวิถี 5', 'https://npa.sam.or.th/site/images/npa/22378/20250221111212_BL0015P4_68.jpg', '/listing-media/sam/bl0015/01.webp', 'image/webp', 31002, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ด้านหน้าอาคารเลขที่ 142/6', 'ภาพด้านหน้าอาคารอพาร์ทเมนต์ 3 ชั้นและทางเข้าสู่ตัวอาคาร', 'https://npa.sam.or.th/site/images/npa/22378/BL0015P3_68.jpg', '/listing-media/sam/bl0015/02.webp', 'image/webp', 37816, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ด้านข้างอาคารติดซอย', 'ภาพด้านข้างอาคารอพาร์ทเมนต์ 3 ชั้นบริเวณซอยกาญจนวิถี 5', 'https://npa.sam.or.th/site/images/npa/22378/BL0015P2_68.jpg', '/listing-media/sam/bl0015/03.webp', 'image/webp', 28416, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้าซอยกาญจนวิถี 5', 'ภาพถนนกาญจนวิถีและทางเลี้ยวเข้าสู่ซอยกาญจนวิถี 5', 'https://npa.sam.or.th/site/images/npa/22378/BL0015P1_68.jpg', '/listing-media/sam/bl0015/04.webp', 'image/webp', 25472, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังแปลงที่ดิน 88.2 ตารางวา', 'ผังแปลงรูปหลายเหลี่ยมแสดงหน้ากว้าง ความลึก และส่วนตะเข็บที่ใช้เป็นทางเข้า-ออกแปลงข้างเคียง', 'https://npa.sam.or.th/site/images/npa/22378/20250221111928_BL0015C1_68.jpg', '/listing-media/sam/bl0015/05.webp', 'image/webp', 16208, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังตำแหน่งอาคารบนแปลง', 'ผังแสดงตำแหน่งอาคาร คสล. 3 ชั้นบนแปลงและอาคารพักอาศัยข้างเคียง', 'https://npa.sam.or.th/site/images/npa/22378/20250221111212_BL0015C2_68.jpg', '/listing-media/sam/bl0015/06.webp', 'image/webp', 15634, 450, 450, 60, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=22378',
        'BL0015',
        '2026-09-09 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 6,855,000 for an apartment property comprising one three-storey reinforced-concrete building numbered 142/6 on title deed no. 66239, covering 88.2 sq.wah / 352.8 sq.m. The transfer record describes a three-storey residential building, while the condition survey describes a three-storey reinforced-concrete building and the listing category is apartment; buyers must confirm building records, permits, current use and authorized room count. The polygonal plot has approximately 23.3 meters of western road frontage and maximum depth of approximately 46.7 meters. SAM reports that an approximately 14.6-by-1.3-meter narrow strip, approximately 4.7 sq.wah, is used as access for a neighboring plot; boundaries, access rights and any easement require verification. The property fronts public asphalt Soi Kanchanawithi 5, with an approximately five-meter carriageway within a seven-meter right of way, about 30 meters from Kanchanawithi Road. The source flags a current user, states that the asset is sold as is, and places responsibility and costs for obtaining possession on the buyer. These property and occupancy details are dated 14 May 2024. The page also says the property is not ready for viewing and instructs interested parties to contact SAM. Usable area, rental unit and bathroom counts, parking, building age, income, leases, business licences, utilities, other encumbrances, interior condition and source photo dates are not published. Administrator-supplied coordinates are approximately 0.044 meters from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all six unique source property and plot images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Three-Storey Apartment Building in Soi Kanchanawithi 5, THB 6.855M',
        E'Three-storey reinforced-concrete apartment building numbered 142/6 on 88.2 sq.wah (352.8 sq.m.) of land in Soi Kanchanawithi 5, Kanchanawithi Road, Bang Kung, Mueang Surat Thani, Surat Thani. The property is held under title deed no. 66239.\n\nSAM''s transfer record describes the structure as a three-storey residential building numbered 142/6, while its condition survey describes a three-storey reinforced-concrete building and the source page categorizes the asset as an apartment. Buyers should verify the building registration, permits, authorized room count, current use and consistency between documents and actual conditions before submitting an offer.\n\nThe polygonal plot has approximately 23.3 meters of western frontage on Soi Kanchanawithi 5 and a maximum depth of approximately 46.7 meters. SAM reports that part of the land is a narrow strip used for access to a neighboring plot. The strip is approximately 14.6 meters long and 1.3 meters wide, covering approximately 4.7 sq.wah. Buyers should verify surveyed boundaries, access rights, any registered easement and actual use with SAM, the Land Office and the relevant neighboring owner.\n\nSoi Kanchanawithi 5 is a public asphalt road with an approximately five-meter carriageway within an approximately seven-meter right of way. The property is approximately 30 meters from Kanchanawithi Road in a pink-zoned residential area. Nearby places listed by SAM include Dohome Surat Thani, Sahathai Garden Plaza, Thep Mitr Suksa School, the Surat Thani Provincial Transport Office and Forest Resource Management Office 11.\n\nImportant: SAM flags a current user and states that the property is sold as is. The buyer must inspect before submitting an offer and may need to negotiate or take legal action to obtain possession at the buyer''s own cost. Occupancy cannot be used to cancel an offer or agreement or to make claims against SAM. This source information is dated 14 May 2024, so current possession status must be reconfirmed. The source page also says the property is not ready for viewing and instructs interested parties to contact SAM.\n\nThe SAM page lists the property as direct purchase with an announced sale price of THB 6,855,000. It is not an auction. Contact SAM directly to confirm availability, current user and viewing status, offer procedures, current price, possession costs and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: BL0015. MapxProp does not collect deposits or represent SAM in the transaction.\n\nThe source does not publish usable area, rental unit or bathroom counts, parking, building age, income, leases, business licences, utilities, other encumbrances or detailed interior condition. Buyers should verify the title deed, building records and permits, boundaries, access rights, current users, leases, income, building and fire-safety systems, structure, encumbrances, expenses and every term before deciding.',
        'Three-storey reinforced-concrete building no. 142/6',
        'Soi Kanchanawithi 5, approximately 30 m from Kanchanawithi Road',
        'Kanchanawithi Road',
        'Bang Kung',
        'Mueang Surat Thani',
        'Surat Thani',
        'SAM Direct-Sale Apartment Building in Mueang Surat Thani, THB 6.855M',
        'Official SAM NPA asset BL0015: three-storey apartment building on 352.8 sq.m. Direct-sale price THB 6.855M; current user and neighboring-access-strip warnings disclosed.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset BL0015 three storey apartment building 142/6 Soi Kanchanawithi 5 Kanchanawithi Road Bang Kung Mueang Surat Thani 88.2 sq.wah 352.8 sq.m. title deed 66239 THB 6855000 current user occupied neighboring access strip')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=22378'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=22378',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for BL0015. The specifications, images, rounded coordinates, announced price, direct-purchase status, current-user warning, viewing status and neighboring-access-strip note come from that record.',
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
        'cc39260f-3146-4138-903b-ea2fdef7ad9a',
        jsonb_build_object(
            'reference_code', 'BL0015',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'occupancy_warning', true,
            'neighbor_access_strip_warning', true,
            'viewing_status_requires_sam_confirmation', true
        )
    );
END $$;

COMMIT;
