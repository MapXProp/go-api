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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing CL0043';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing CL0043';
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
        '0e029d71-e59b-40eb-912c-7ba26c538938',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'condo',
        'residence',
        'sale',
        'single_unit',
        'เดอะ เอสบล็อค คอนโดมิเนียม',
        '888/27',
        'ขายตรง SAM คอนโด The S Block ชั้น 2 บ้านเป็ด 72.30 ตร.ม. 1 ห้องนอน ราคา 3.55 ล้านบาท',
        E'ห้องชุดพักอาศัยเลขที่ 888/27 ชั้น 2 อาคารเลขที่ 888/8 โครงการเดอะ เอสบล็อค คอนโดมิเนียม ถนนศรีจันทร์ ตำบลบ้านเป็ด อำเภอเมืองขอนแก่น จังหวัดขอนแก่น พื้นที่ 72.30 ตร.ม. มี 1 ห้องนอน 1 ห้องน้ำ หนังสือกรรมสิทธิ์ห้องชุดเลขที่ 888/27 จำนวน 1 ฉบับ ราคาตามหน้า SAM คิดเป็นประมาณ 49,101 บาท/ตร.ม.\n\nอาคารชุดจดทะเบียนเลขที่ 11/2557 โครงการมี 1 อาคาร สูง 7 ชั้น รวม 60 ห้องชุด มีลิฟต์โดยสาร 2 ชุดต่ออาคาร อัตราส่วนกรรมสิทธิ์ในทรัพย์ส่วนกลางของห้องคือ 72.30 ส่วน ใน 3,455.91 ส่วน ผู้ซื้อควรตรวจหนังสือกรรมสิทธิ์ ตำแหน่งและขอบเขตห้อง ทรัพย์ส่วนกลาง ข้อบังคับนิติบุคคล และทะเบียนอาคารชุดฉบับปัจจุบันก่อนเสนอซื้อ\n\nSAM ระบุสิ่งอำนวยความสะดวกของอาคาร ได้แก่ สระว่ายน้ำ ฟิตเนส เจ้าหน้าที่รักษาความปลอดภัย 24 ชั่วโมง กล้องวงจรปิด บัตรเข้า-ออก เครื่องตรวจจับความร้อน เครื่องตรวจจับควัน สัญญาณเตือนไฟไหม้ ทางหนีไฟ สายฉีดน้ำดับเพลิง ถังดับเพลิง และระบบสปริงเกลอร์ ชุดภาพต้นทางยังแสดงที่จอดรถ ล็อบบี้ ตู้จดหมาย และโถงลิฟต์ ผู้ซื้อควรตรวจว่าสิ่งอำนวยความสะดวก ระบบอัคคีภัย และสิทธิใช้พื้นที่ส่วนกลางยังอยู่ในสภาพใช้งานและเป็นไปตามข้อบังคับปัจจุบัน\n\nข้อมูล ณ วันที่ 23 กันยายน 2568 ระบุค่าส่วนกลางประมาณ 2,530.50 บาทต่อเดือน ตัวเลขนี้ไม่ใช่การยืนยันอัตราปัจจุบันหรือยอดค้าง ผู้ซื้อต้องขอหนังสือรับรองจากนิติบุคคลอาคารชุดเพื่อตรวจอัตราค่าส่วนกลาง ยอดค้าง ค่าปรับ เงินกองทุน เงื่อนไขการโอน และผู้รับผิดชอบค่าใช้จ่ายทั้งหมด\n\nสำคัญ: ชุดภาพต้นทางไม่มีภาพภายในห้อง 888/27 มีเฉพาะภาพอาคาร ทางเดินหน้าห้อง พื้นที่จอดรถ พื้นที่ส่วนกลาง ทางเข้า และผังชั้น จึงไม่สามารถยืนยันสภาพภายใน เฟอร์นิเจอร์ ทิศหรือวิวของห้อง ระบบไฟฟ้า-ประปาภายใน สถานะการครอบครอง หรือค่าใช้จ่ายซ่อม ผู้ซื้อควรนัดตรวจห้องจริงก่อนตัดสินใจ\n\nการเดินทางตาม SAM ใช้ถนนศรีจันทร์จากแยกถนนมิตรภาพ (ทล.2) มุ่งหน้าแยกบ้านเป็ด ผ่านโรงพยาบาลขอนแก่นราม ศูนย์วิจัยข้าว และวัดจอมศรี แล้วเลี้ยวซ้ายเข้าถนนรอบบึงหนองโคตรและทางเข้าเดอะ เอสบล็อค คอนโดมิเนียม อาคารอยู่ด้านขวามือ\n\nหน้า SAM แสดงสถานะ “ซื้อตรง” และราคาประกาศขาย 3,550,000 บาท ณ วันที่ตรวจสอบ 10 กันยายน 2569 ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าส่วนกลาง สถานะห้อง การเข้าชม ค่าใช้จ่าย และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ CL0043 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nหน้าต้นทางไม่ระบุสถานะเฟอร์นิเจอร์ ที่จอดรถประจำห้อง อายุอาคาร สถานะการครอบครอง ยอดค้างค่าส่วนกลาง เงินกองทุน หรือภาระผูกพันอื่น ภาพพื้นที่อาคารและส่วนกลางแสดงวันที่ 23 กันยายน 2568 สภาพจริงอาจเปลี่ยนแปลง ผู้ซื้อควรตรวจสภาพภายในห้อง ระบบอาคาร อัคคีภัย ลิฟต์ ที่จอดรถ การครอบครอง ภาระผูกพัน ข้อบังคับนิติบุคคล ค่าส่วนกลาง เงินกองทุน ภาษี ค่าใช้จ่ายวันโอน และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        3550000,
        false,
        72.30,
        1,
        1,
        7,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'ห้อง 888/27 ชั้น 2 อาคาร 888/8 เดอะ เอสบล็อค คอนโดมิเนียม',
        'เข้าจากถนนรอบบึงหนองโคตร',
        'ศรีจันทร์',
        NULL,
        16.432474935681245,
        102.80739301604181,
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
        'sam-direct-sale-the-s-block-condo-ban-pet-khon-kaen-cl0043'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 3550000, 'total', 'THB', false
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
        'condo',
        1,
        jsonb_build_object(
            'source_property_category', 'ห้องชุดพักอาศัย',
            'project_name', 'เดอะ เอสบล็อค คอนโดมิเนียม',
            'listed_unit_number', '888/27',
            'building_number', '888/8',
            'unit_floor', 2,
            'title_document_type', 'condominium_unit_title',
            'condominium_unit_title_number', '888/27',
            'title_document_count', 1,
            'unit_area_sqm', 72.30,
            'bedroom_count', 1,
            'bathroom_count', 1,
            'price_per_sqm', 49101,
            'condominium_registration_number', '11/2557',
            'common_property_ownership_numerator', 72.30,
            'common_property_ownership_denominator', 3455.91,
            'project_building_count', 1,
            'project_total_floors', 7,
            'project_total_units', 60,
            'passenger_elevators_per_building', 2,
            'monthly_common_fee_thb_approx', 2530.50,
            'common_fee_information_date', '2025-09-23'
        ) || jsonb_build_object(
            'source_amenities', jsonb_build_array('swimming_pool', 'fitness', '24_hour_security', 'cctv', 'access_card', 'heat_detector', 'smoke_detector', 'fire_alarm', 'fire_escape', 'fire_hose', 'fire_extinguisher', 'sprinkler'),
            'source_photos_show_parking_area', true,
            'source_photos_show_lobby', true,
            'source_photos_show_mailboxes', true,
            'source_photos_show_elevator_lobby', true,
            'source_photos_do_not_show_unit_interior', true,
            'interior_condition_not_published', true,
            'furnishing_status_not_published', true,
            'unit_orientation_not_published', true,
            'unit_view_not_published', true,
            'assigned_parking_not_published', true,
            'building_age_not_published', true,
            'occupancy_status_not_published', true,
            'common_fee_arrears_not_published', true,
            'sinking_fund_information_not_published', true,
            'other_encumbrances_not_published', true,
            'zoning_information_not_published', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_property_and_common_area_photo_date_displayed', '2025-09-23',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '16.432473,102.807393',
            'administrator_coordinate_distance_from_source_m_approx', 0.22
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for CL0043. MapxProp does not collect deposits or represent SAM in the transaction.',
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

    INSERT INTO public.listing_amenities (listing_id, amenity_code)
    VALUES
        (property_listing_id, 'elevator'),
        (property_listing_id, 'fitness'),
        (property_listing_id, 'parking'),
        (property_listing_id, 'security'),
        (property_listing_id, 'swimming_pool')
    ON CONFLICT (listing_id, amenity_code) DO NOTHING;

    INSERT INTO public.listing_nearby_places (
        listing_id, place_name_th, place_name_en, place_type_code,
        distance_meters, latitude, longitude, sort_order, is_highlight
    ) VALUES
        (property_listing_id, 'ถนนศรีจันทร์', 'Srichan Road', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ถนนมิตรภาพ (ทล.2)', 'Mittraphap Road, Highway 2', 'road', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'บึงหนองโคตร', 'Bueng Nong Khot', 'landmark', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'โรงพยาบาลขอนแก่นราม', 'Khon Kaen Ram Hospital', 'healthcare', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'ศูนย์วิจัยข้าวขอนแก่น', 'Khon Kaen Rice Research Center', 'government', NULL, NULL, NULL, 50, true),
        (property_listing_id, 'วัดจอมศรี', 'Wat Chom Si', 'landmark', NULL, NULL, NULL, 60, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '3,550,000 บาท หรือประมาณ 49,101 บาท/ตร.ม. — โปรดตรวจสอบราคาล่าสุดและโปรโมชั่นกับ SAM', 'THB 3,550,000, approximately THB 49,101 per sq.m. — confirm the latest price and promotions with SAM', 'unspecified', 3550000, 'THB', 20),
        (property_listing_id, 'monthly_common_fee', 'ค่าส่วนกลาง', 'Monthly common fee', 'ประมาณ 2,530.50 บาท/เดือน ตามข้อมูล ณ 23 กันยายน 2568 — ตรวจอัตราปัจจุบัน ยอดค้าง ค่าปรับ เงินกองทุน และผู้ชำระกับนิติบุคคล', 'Approximately THB 2,530.50 per month based on information dated 23 September 2025 — confirm the current rate, arrears, penalties, sinking fund and payer with the juristic office', 'unspecified', 2530.50, 'THB/month', 30),
        (property_listing_id, 'common_property_share', 'อัตราส่วนกรรมสิทธิ์ส่วนกลาง', 'Common-property ownership share', '72.30 ส่วน ใน 3,455.91 ส่วน — ตรวจหนังสือกรรมสิทธิ์และข้อบังคับนิติบุคคลฉบับปัจจุบัน', '72.30 shares out of 3,455.91 — verify the current unit title and condominium regulations', 'unspecified', 72.30, 'shares', 40),
        (property_listing_id, 'building_information', 'ข้อมูลอาคารชุด', 'Condominium building information', '1 อาคาร สูง 7 ชั้น รวม 60 ห้องชุด ลิฟต์โดยสาร 2 ชุด/อาคาร ทะเบียนอาคารชุดเลขที่ 11/2557', 'One seven-storey building with 60 units and two passenger lifts; condominium registration no. 11/2557', 'unspecified', 60, 'units', 50),
        (property_listing_id, 'interior_photo_caveat', 'ภาพภายในห้อง', 'Unit-interior photo caveat', 'ชุดภาพต้นทางไม่มีภาพภายในห้อง 888/27 ต้องนัดตรวจสภาพห้อง เฟอร์นิเจอร์ ระบบไฟฟ้า-ประปา ทิศ วิว และค่าใช้จ่ายซ่อมจริง', 'The source gallery does not show the interior of unit 888/27; inspect condition, furnishings, utilities, orientation, view and repair costs in person', 'buyer', NULL, '', 60),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจหนังสือกรรมสิทธิ์ ตำแหน่งห้อง สภาพภายใน ระบบอาคาร อัคคีภัย ลิฟต์ ที่จอดรถ การครอบครอง ภาระผูกพัน ข้อบังคับ ค่าส่วนกลาง เงินกองทุน ค่าใช้จ่ายวันโอน และเงื่อนไขล่าสุด', 'Verify the unit title, unit position, interior, building and fire-safety systems, lifts, parking, possession, encumbrances, regulations, common fees, sinking fund, transfer costs and latest terms', 'buyer', NULL, '', 70)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'อาคารเดอะ เอสบล็อค คอนโดมิเนียม', 'อาคารเดอะ เอสบล็อค คอนโดมิเนียม บ้านเป็ด ที่ตั้งห้อง SAM รหัส CL0043', 'https://npa.sam.or.th/site/images/npa/23524/20260731211324_CL0043P2_69.jpg', '/listing-media/sam/cl0043/01.webp', 'image/webp', 27528, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเดินหน้าห้องชุด 888/27', 'ทางเดินชั้น 2 พร้อมลูกศรแสดงตำแหน่งห้องชุดเลขที่ 888/27', 'https://npa.sam.or.th/site/images/npa/23524/CL0043P12_69.jpg', '/listing-media/sam/cl0043/02.webp', 'image/webp', 15180, 720, 540, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ตำแหน่งประตูห้องบนชั้น 2', 'โถงทางเดินพร้อมลูกศรแสดงประตูห้องชุด SAM CL0043 บนชั้น 2', 'https://npa.sam.or.th/site/images/npa/23524/CL0043P13_69.jpg', '/listing-media/sam/cl0043/03.webp', 'image/webp', 12912, 720, 540, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'amenity', 'พื้นที่จอดรถของอาคาร', 'ภาพลานและหลังคาที่จอดรถบริเวณเดอะ เอสบล็อค คอนโดมิเนียม', 'https://npa.sam.or.th/site/images/npa/23524/CL0043P4_69.jpg', '/listing-media/sam/cl0043/04.webp', 'image/webp', 54464, 720, 540, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'amenity', 'ล็อบบี้และพื้นที่นั่งพัก', 'ภาพล็อบบี้ส่วนกลางพร้อมพื้นที่นั่งพักของอาคารชุด', 'https://npa.sam.or.th/site/images/npa/23524/CL0043P5_69.jpg', '/listing-media/sam/cl0043/05.webp', 'image/webp', 38502, 720, 540, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'amenity', 'สระว่ายน้ำส่วนกลาง', 'ภาพสระว่ายน้ำและพื้นที่พักผ่อนส่วนกลางของโครงการ', 'https://npa.sam.or.th/site/images/npa/23524/CL0043P6_69.jpg', '/listing-media/sam/cl0043/06.webp', 'image/webp', 91436, 720, 540, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'amenity', 'ห้องฟิตเนสส่วนกลาง', 'ภาพห้องออกกำลังกายติดสระว่ายน้ำของเดอะ เอสบล็อค คอนโดมิเนียม', 'https://npa.sam.or.th/site/images/npa/23524/CL0043P7_69.jpg', '/listing-media/sam/cl0043/07.webp', 'image/webp', 51672, 720, 540, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'amenity', 'ตู้จดหมายและโถงทางเข้า', 'ภาพตู้จดหมายและประตูกระจกบริเวณโถงส่วนกลางของอาคาร', 'https://npa.sam.or.th/site/images/npa/23524/CL0043P8_69.jpg', '/listing-media/sam/cl0043/08.webp', 'image/webp', 24132, 720, 540, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'amenity', 'พื้นที่รับรองส่วนกลาง', 'ภาพพื้นที่รับรองพร้อมโต๊ะ เก้าอี้ และเคาน์เตอร์ภายในอาคารชุด', 'https://npa.sam.or.th/site/images/npa/23524/CL0043P9_69.jpg', '/listing-media/sam/cl0043/09.webp', 'image/webp', 34164, 720, 540, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'amenity', 'โถงลิฟต์โดยสาร', 'ภาพโถงลิฟต์โดยสารและทางเดินส่วนกลางภายในอาคาร', 'https://npa.sam.or.th/site/images/npa/23524/CL0043P10_69.jpg', '/listing-media/sam/cl0043/10.webp', 'image/webp', 16030, 720, 540, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'access', 'ทางเข้าจากถนนรอบบึงหนองโคตร', 'ภาพจุดเลี้ยวจากถนนรอบบึงหนองโคตรเข้าสู่เดอะ เอสบล็อค คอนโดมิเนียม', 'https://npa.sam.or.th/site/images/npa/23524/CL0043P1_69.jpg', '/listing-media/sam/cl0043/11.webp', 'image/webp', 17560, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังชั้นและตำแหน่งห้อง 888/27', 'ผังต้นทางแสดงตำแหน่งห้องชุดเลขที่ 888/27 บนชั้น 2 ใกล้โถงลิฟต์และทางหนีไฟ', 'https://npa.sam.or.th/site/images/npa/23524/20260731211324_CL0043C_69.jpg', '/listing-media/sam/cl0043/12.webp', 'image/webp', 40592, 785, 600, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไป The S Block', 'แผนที่ต้นทางแสดงเส้นทางจากถนนมิตรภาพและถนนศรีจันทร์ไปยังเดอะ เอสบล็อค คอนโดมิเนียม บ้านเป็ด', 'https://npa.sam.or.th/site/images/npa/23524/20260731211324_CL0043M_69 (3A0968).jpg', '/listing-media/sam/cl0043/13.webp', 'image/webp', 52744, 785, 600, 130, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=23524&keyref=6004425',
        'CL0043',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 3,550,000, or THB 49,101 per sq.m., for residential condominium unit 888/27 on floor 2 of building 888/8 at The S Block Condominium, Ban Pet, Mueang Khon Kaen. Condominium unit title no. 888/27 covers 72.30 sq.m. and the source lists one bedroom and one bathroom. Condominium registration no. 11/2557 covers one seven-storey building with sixty units and two passenger lifts. The unit has a common-property ownership ratio of 72.30 shares out of 3,455.91. Source information dated 23 September 2025 reports an approximate monthly common fee of THB 2,530.50, which is not confirmation of the current rate or arrears. Published amenities include a pool, fitness room, 24-hour security, CCTV, access card and multiple fire-safety systems. Crucially, the source gallery does not show the interior of unit 888/27; it shows the building, corridor and unit-door position, parking and common areas, access, floor plan and navigation map. Furnishing, interior condition, orientation, view, assigned parking, building age, occupancy, common-fee arrears, sinking fund, zoning and other encumbrances are not published. Source building and common-area photos display 23 September 2025. Administrator coordinates are approximately 0.22 metres from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all thirteen unique source images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: The S Block Condo, Floor 2, 72.30 Sq.m., One Bedroom, THB 3.55M',
        E'Residential condominium unit 888/27 on floor 2 of building 888/8 at The S Block Condominium on Srichan Road, Ban Pet, Mueang Khon Kaen. Condominium unit title no. 888/27 covers 72.30 sq.m. The source lists one bedroom and one bathroom. The announced price equates to approximately THB 49,101 per sq.m.\n\nThe condominium is registered under no. 11/2557. The project has one seven-storey building with sixty units and two passenger lifts. The unit''s common-property ownership ratio is 72.30 shares out of 3,455.91. Buyers should verify the current unit title, unit position and boundaries, common-property records, juristic-person regulations and condominium registration before offering.\n\nSAM lists a swimming pool, fitness room, 24-hour security, CCTV, access card, heat and smoke detectors, fire alarm, fire escape, fire hose, fire extinguishers and sprinkler system. Source photos also show parking, the lobby, mailboxes and lift lobby. Buyers should verify that amenities, fire-safety systems and access rights remain available and compliant with current regulations.\n\nInformation dated 23 September 2025 reports an approximate monthly common fee of THB 2,530.50. This is not confirmation of the current fee or outstanding balance. Buyers must obtain written confirmation from the condominium juristic office covering the current rate, arrears, penalties, sinking fund, transfer requirements and responsible payer.\n\nImportant photo caveat: the source gallery does not show the interior of unit 888/27. It only shows the building, the corridor and unit-door position, parking, common areas, access and floor plan. The interior condition, furnishing, orientation, view, internal electrical and plumbing systems, occupancy and repair budget cannot be confirmed. Buyers should arrange an in-person inspection before deciding.\n\nSAM''s directions use Srichan Road from the Mittraphap Road (Highway 2) intersection toward Ban Pet, passing Khon Kaen Ram Hospital, the Rice Research Center and Wat Chom Si. Turn left onto the road around Bueng Nong Khot and into The S Block Condominium; the building is on the right.\n\nThe SAM page listed the unit for direct purchase at an announced THB 3,550,000 when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, offer procedures, current price, promotions, common fees, unit status, viewing, costs and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: CL0043. MapxProp does not collect deposits or represent SAM in the transaction.\n\nThe source does not publish furnishing status, assigned parking, building age, occupancy, common-fee arrears, sinking fund, zoning or other encumbrances. Building and common-area photos display 23 September 2025, and conditions may have changed. Buyers should inspect the unit interior, building systems, fire safety, lifts, parking, possession, encumbrances, regulations, common fees, sinking fund, taxes, transfer costs and every current term before deciding.',
        'Unit 888/27, Floor 2, Building 888/8, The S Block Condominium',
        'Access from the road around Bueng Nong Khot',
        'Srichan Road',
        'Ban Pet',
        'Mueang Khon Kaen',
        'Khon Kaen',
        'SAM The S Block Condo, 72.30 Sq.m., THB 3.55M',
        'Official SAM NPA asset CL0043: floor-2 condo at The S Block, Ban Pet, 72.30 sq.m., 1 bedroom and 1 bathroom. Direct-sale price THB 3.55M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset CL0043 residential condominium unit 888/27 floor 2 building 888/8 The S Block Condominium Ban Pet Mueang Khon Kaen Srichan Road 72.30 sq.m. one bedroom one bathroom THB 3550000 49101 per sqm common fee pool fitness elevator')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=23524&keyref=6004425'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=23524&keyref=6004425',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for CL0043. Unit specifications, title, room count, floor, building and common-property information, amenities, common-fee wording, images, rounded coordinates, announced price and direct-purchase status come from that record.',
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
        '0e029d71-e59b-40eb-912c-7ba26c538938',
        jsonb_build_object(
            'reference_code', 'CL0043',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'residence',
            'discovery_channels', jsonb_build_array('homes'),
            'title_document_count', 1,
            'unit_floor', 2,
            'project_total_floors', 7,
            'bedroom_count', 1,
            'bathroom_count', 1,
            'common_fee_review_required', true,
            'unit_interior_inspection_required', true,
            'source_image_count', 13
        )
    );
END $$;

COMMIT;
