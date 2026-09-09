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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing 4T0362';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing 4T0362';
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
        title,
        description,
        sale_price,
        price_negotiable,
        land_area_sqm,
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
        '46ea87ad-2fae-4c2c-9573-65c0652ca549',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'land',
        'mixed',
        'sale',
        'land_plot',
        'ขายตรง SAM ที่ดิน 8 แปลงติดถนน 4 ด้าน วัดเกต เมืองเชียงใหม่ 4-1-32 ไร่ ราคา 101.996 ล้านบาท',
        E'ที่ดิน 8 แปลงติดต่อกัน ใช้ประโยชน์ร่วมกัน เนื้อที่รวม 4 ไร่ 1 งาน 32 ตร.ว. หรือ 1,732 ตร.ว. (6,928 ตร.ม.) ถนนรัตนโกสินทร์ ตำบลวัดเกต อำเภอเมืองเชียงใหม่ จังหวัดเชียงใหม่ เอกสารสิทธิ์เป็นโฉนดที่ดิน 8 ฉบับ เลขที่ 14281, 75698, 75699, 75700, 75701, 75702, 75703 และ 75704

SAM ระบุว่าแปลงเป็นรูปหลายเหลี่ยมและติดถนนหลายด้าน ได้แก่ แนวติดถนนตรัสวงศ์ประมาณ 77 เมตร แนวติดถนนดอยสะเก็ดเก่าหรือถนนรัตนโกสินทร์ประมาณ 93 เมตร แนวติดทางสาธารณประโยชน์ประมาณ 79 เมตร และแนวด้านเหนือยาวประมาณ 101 เมตร โดยช่วงที่ติดทางสาธารณประโยชน์ประมาณ 50 เมตร

สิ่งปลูกสร้างที่ SAM ระบุว่าได้รับโอนกรรมสิทธิ์ประกอบด้วย สนามฟุตบอลขนาด 36 x 45 เมตร ร้านกาแฟ ร้านอาหารชั้นเดียว บ้านพักอาศัยตึกชั้นเดียว สนามฟุตบอลขนาด 22 x 38 เมตร และสำนักงานพร้อมร้านค้าตึก 2 ชั้น โดยข้อมูลการสำรวจของ SAM ระบุว่าสนามฟุตบอลทั้ง 2 สนามถูกรื้อถอนแล้ว นอกจากนี้อาจมีสิ่งปลูกสร้างส่วนอื่นซึ่งยังไม่พบหลักฐานว่าเป็นส่วนควบของที่ดิน การโอนจะเป็นไปตามรายการที่ SAM จดทะเบียนรับโอนกรรมสิทธิ์เท่านั้น ผู้ซื้อจึงต้องตรวจรายการสิ่งปลูกสร้างและสถานะปัจจุบันกับ SAM และสำนักงานที่ดินก่อนเสนอซื้อ

ถนนตรัสวงศ์เป็นทางสาธารณประโยชน์ ผิวจราจรลาดยางกว้างประมาณ 8 เมตร เขตทางประมาณ 12 เมตร ส่วนถนนรัตนโกสินทร์เป็นทางสาธารณประโยชน์ ผิวจราจรลาดยางกว้างประมาณ 12 เมตร เขตทางประมาณ 22 เมตร ทำเลอยู่ใกล้โรงพยาบาลแมคคอร์มิค สถานีขนส่งผู้โดยสารเชียงใหม่ (อาเขต) ศาลอุทธรณ์ภาค 5 เซ็นทรัลเชียงใหม่ และสถานีรถไฟเชียงใหม่

หน้า SAM ระบุเขตพื้นที่เป็น “เขตสีเหลืองและเส้นทแยงสีขาว” ผู้ซื้อควรนำเลขโฉนด แนวเขต และแผนการใช้ประโยชน์ไปตรวจสอบผังเมืองรวมและข้อกำหนดควบคุมอาคารฉบับปัจจุบันกับหน่วยงานท้องถิ่นโดยตรงก่อนเสนอซื้อ การจัดหมวดใน MapxProp เป็นแบบอยู่อาศัยและธุรกิจจากลักษณะทำเลและรายการสิ่งปลูกสร้าง ไม่ใช่การรับรองว่าสามารถใช้หรือพัฒนาได้ทุกประเภท

หน้า SAM ระบุสถานะ “ซื้อตรง” และราคาประกาศขาย 101,996,000 บาท หรือ 58,889 บาท/ตร.ว. ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน ค่าใช้จ่าย สถานะการครอบครอง และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ 4T0362 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM

ภาพหน้าทรัพย์ต้นทางแสดงวันที่ 9 เมษายน 2566 และภาพภายในหลายภาพแสดงวันที่ 4 มีนาคม 2565 สภาพจริงอาจเปลี่ยนแปลง ผู้ซื้อควรนัดตรวจทรัพย์ ตรวจโฉนด แนวเขต สิ่งปลูกสร้าง ผังเมือง ทางเข้า-ออก สาธารณูปโภค น้ำท่วม การระบายน้ำ ดิน ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        101996000,
        false,
        6928,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'ที่ดิน 8 แปลงติดต่อกัน พร้อมสิ่งปลูกสร้างตามรายการของ SAM',
        'ติดถนนรัตนโกสินทร์ ถนนตรัสวงศ์ และทางสาธารณประโยชน์',
        'ถนนรัตนโกสินทร์',
        NULL,
        18.80197102,
        99.01132836,
        'เชียงใหม่',
        'เมืองเชียงใหม่',
        'วัดเกต',
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
        'sam-direct-sale-eight-plot-land-wat-ket-chiang-mai-4t0362'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES
        (property_listing_id, 'residential'),
        (property_listing_id, 'office'),
        (property_listing_id, 'retail'),
        (property_listing_id, 'food_service')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 101996000, 'total', 'THB', false
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
        'land',
        1,
        jsonb_build_object(
            'source_property_category', 'ที่ดินเปล่า',
            'sam_markets_as_vacant_land', true,
            'title_document_type', 'chanote',
            'title_deed_numbers', jsonb_build_array('14281', '75698', '75699', '75700', '75701', '75702', '75703', '75704'),
            'title_document_count', 8,
            'land_area_rai', 4,
            'land_area_ngan', 1,
            'land_area_square_wah_remainder', 32,
            'land_area_square_wah', 1732,
            'land_area_sqm', 6928,
            'plot_count', 8,
            'plots_contiguous', true,
            'plots_used_together', true,
            'vacant_land', false,
            'structures_present', true,
            'registered_structure_item_count', 6,
            'football_field_count_reported', 2,
            'football_fields_reported_demolished', true,
            'coffee_shop_reported', true,
            'single_storey_restaurant_reported', true,
            'single_storey_house_reported', true,
            'two_storey_office_and_shop_reported', true,
            'other_structures_title_status_uncertain', true,
            'transfer_limited_to_sam_registered_items', true,
            'plot_shape', 'polygon',
            'road_frontage_side_count_reported', 4,
            'tratsawong_road_frontage_m', 77,
            'old_doi_saket_rattanakosin_road_frontage_m', 93,
            'public_road_boundary_m', 79,
            'north_boundary_m', 101,
            'north_public_road_frontage_m', 50
        ) || jsonb_build_object(
            'primary_front_road_name', 'ถนนรัตนโกสินทร์',
            'primary_front_road_surface', 'asphalt',
            'primary_front_road_width_m', 12,
            'primary_front_right_of_way_width_m', 22,
            'secondary_front_road_name', 'ถนนตรัสวงศ์',
            'secondary_front_road_surface', 'asphalt',
            'secondary_front_road_width_m', 8,
            'secondary_front_right_of_way_width_m', 12,
            'zoning_color_th', 'เขตสีเหลืองและเส้นทแยงสีขาว ตามหน้า SAM',
            'zoning_confirmation_required', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'price_per_square_wah', 58889,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-09',
            'source_information_date_not_published', true,
            'source_cover_photo_date_displayed', '2023-04-09',
            'source_interior_photo_date_displayed', '2022-03-04',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '18.801972,99.011329',
            'administrator_coordinate_distance_from_source_m_approx', 0.08
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 4T0362. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนรัตนโกสินทร์', 'Rattanakosin Road', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ถนนตรัสวงศ์', 'Tratsawong Road', 'road', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'โรงพยาบาลแมคคอร์มิค', 'McCormick Hospital', 'healthcare', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'สถานีขนส่งผู้โดยสารเชียงใหม่ (อาเขต)', 'Chiang Mai Arcade Bus Terminal', 'transit', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'ศาลอุทธรณ์ภาค 5', 'Court of Appeal Region 5', 'government', NULL, NULL, NULL, 50, true),
        (property_listing_id, 'เซ็นทรัลเชียงใหม่', 'Central Chiangmai', 'shopping', NULL, NULL, NULL, 60, true),
        (property_listing_id, 'สถานีรถไฟเชียงใหม่', 'Chiang Mai Railway Station', 'transit', NULL, NULL, NULL, 70, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '101,996,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 101,996,000 — confirm the latest price with SAM', 'unspecified', 101996000, 'THB', 20),
        (property_listing_id, 'price_per_square_wah', 'ราคาต่อตารางวา', 'Price per square wah', '58,889 บาท/ตร.ว. ตามหน้าต้นทาง', 'THB 58,889 per sq.wah as shown by the source', 'unspecified', 58889, 'THB/sq_wah', 30),
        (property_listing_id, 'title_documents', 'เอกสารสิทธิ์', 'Title documents', 'โฉนดที่ดิน 8 ฉบับ สำหรับที่ดิน 8 แปลงติดต่อกัน', 'Eight title deeds for eight contiguous land plots', 'unspecified', 8, 'documents', 40),
        (property_listing_id, 'registered_structures', 'สิ่งปลูกสร้างที่รับโอน', 'Registered structures', 'SAM ระบุรายการรับโอน 6 รายการ และระบุว่าสนามฟุตบอล 2 สนามถูกรื้อถอนแล้ว ต้องยืนยันรายการและสภาพปัจจุบันก่อนซื้อ', 'SAM lists six transferred structure items and reports that both football fields have been demolished; confirm the registered items and current condition before purchase', 'buyer', 6, 'items', 50),
        (property_listing_id, 'other_structures', 'สิ่งปลูกสร้างอื่น', 'Other structures', 'SAM ระบุว่าสิ่งปลูกสร้างส่วนอื่นบางรายการยังไม่พบหลักฐานว่าเป็นส่วนควบ การโอนทำได้เฉพาะรายการที่ SAM จดทะเบียนรับโอน', 'SAM states that title status for some other structures is unconfirmed and transfer is limited to items registered to SAM', 'buyer', NULL, '', 60),
        (property_listing_id, 'zoning_review', 'ตรวจสอบผังเมือง', 'Zoning review', 'หน้า SAM ระบุเขตสีเหลืองและเส้นทแยงสีขาว ต้องยืนยันข้อกำหนดปัจจุบันและการใช้ประโยชน์ที่ต้องการกับหน่วยงานท้องถิ่น', 'SAM shows a yellow zone with white diagonal lines; confirm current controls and the intended use with local authorities', 'buyer', NULL, '', 70),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนด แนวเขต สิ่งปลูกสร้าง ทางเข้า-ออก ผังเมือง สาธารณูปโภค น้ำท่วม ดิน ภาระผูกพัน ค่าใช้จ่าย สถานะการครอบครอง และเงื่อนไขล่าสุดก่อนเสนอซื้อ', 'Verify title deeds, boundaries, structures, access, planning, utilities, flooding, soil, encumbrances, costs, possession and current terms before offering', 'buyer', NULL, '', 80)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'หน้าทรัพย์ติดถนนรัตนโกสินทร์', 'หน้าที่ดินและสิ่งปลูกสร้างของทรัพย์ SAM รหัส 4T0362 ติดถนนรัตนโกสินทร์ วัดเกต เชียงใหม่', 'https://npa.sam.or.th/site/images/npa/13955/20231227154103_4T0362P1_66.jpg', '/listing-media/sam/4t0362/01.webp', 'image/webp', 42844, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมมองหน้าทรัพย์จากฝั่งตรงข้าม', 'ภาพหน้าทรัพย์รหัส 4T0362 จากฝั่งตรงข้ามถนนรัตนโกสินทร์', 'https://npa.sam.or.th/site/images/npa/13955/1.jpg', '/listing-media/sam/4t0362/02.webp', 'image/webp', 36538, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวถนนหน้าทรัพย์', 'ภาพถนนรัตนโกสินทร์และแนวหน้าทรัพย์ SAM วัดเกต เชียงใหม่', 'https://npa.sam.or.th/site/images/npa/13955/3.jpg', '/listing-media/sam/4t0362/03.webp', 'image/webp', 34860, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ลานและสิ่งปลูกสร้างภายใน', 'ภาพลานกว้างและอาคารภายในที่ดิน 8 แปลงรหัส 4T0362', 'https://npa.sam.or.th/site/images/npa/13955/4.jpg', '/listing-media/sam/4t0362/04.webp', 'image/webp', 34188, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'อาคารสองชั้นภายในทรัพย์', 'ภาพอาคารสองชั้นและพื้นที่ใช้งานภายในทรัพย์ SAM รหัส 4T0362', 'https://npa.sam.or.th/site/images/npa/13955/5.jpg', '/listing-media/sam/4t0362/05.webp', 'image/webp', 33826, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่โล่งภายในแปลง', 'ภาพพื้นที่โล่งภายในที่ดิน 8 แปลง เนื้อที่รวม 4 ไร่ 1 งาน 32 ตารางวา', 'https://npa.sam.or.th/site/images/npa/13955/6.jpg', '/listing-media/sam/4t0362/06.webp', 'image/webp', 36886, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'อาคารหลังคาคลุมภายในทรัพย์', 'ภาพอาคารหลังคาคลุมและลานภายในทรัพย์วัดเกต เชียงใหม่', 'https://npa.sam.or.th/site/images/npa/13955/7.jpg', '/listing-media/sam/4t0362/07.webp', 'image/webp', 46988, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ลานด้านในและแนวอาคาร', 'ภาพลานด้านในและแนวอาคารของทรัพย์ SAM รหัส 4T0362', 'https://npa.sam.or.th/site/images/npa/13955/8.jpg', '/listing-media/sam/4t0362/08.webp', 'image/webp', 40192, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ลานโล่งฝั่งอาคารพักอาศัย', 'ภาพลานโล่งและอาคารโดยรอบภายในทรัพย์ 4T0362', 'https://npa.sam.or.th/site/images/npa/13955/9.jpg', '/listing-media/sam/4t0362/09.webp', 'image/webp', 36074, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่แปลงตอนกลาง', 'ภาพพื้นที่แปลงตอนกลางของที่ดิน 8 แปลงติดต่อกันในวัดเกต', 'https://npa.sam.or.th/site/images/npa/13955/10.jpg', '/listing-media/sam/4t0362/10.webp', 'image/webp', 37414, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวอาคารและพื้นที่ว่าง', 'ภาพแนวอาคารและพื้นที่ว่างภายในทรัพย์ SAM เมืองเชียงใหม่', 'https://npa.sam.or.th/site/images/npa/13955/11.jpg', '/listing-media/sam/4t0362/11.webp', 'image/webp', 37914, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'สิ่งปลูกสร้างด้านใน', 'ภาพสิ่งปลูกสร้างและทางสัญจรภายในที่ดินรหัส 4T0362', 'https://npa.sam.or.th/site/images/npa/13955/12.jpg', '/listing-media/sam/4t0362/12.webp', 'image/webp', 30624, 450, 450, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางสาธารณประโยชน์ด้านหลังทรัพย์', 'ภาพทางสาธารณประโยชน์และแนวด้านหลังของทรัพย์ SAM วัดเกต', 'https://npa.sam.or.th/site/images/npa/13955/13.jpg', '/listing-media/sam/4t0362/13.webp', 'image/webp', 30766, 450, 450, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังแปลงและสิ่งปลูกสร้าง', 'ผังประกอบแสดงที่ดิน 8 แปลง แนวถนน และตำแหน่งสิ่งปลูกสร้างตามข้อมูล SAM', 'https://npa.sam.or.th/site/images/npa/13955/20180801132815_4T0362C2_61.jpg', '/listing-media/sam/4t0362/14.webp', 'image/webp', 34192, 450, 450, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังโฉนดที่ดิน 8 แปลง', 'ผังแสดงโฉนดที่ดิน 8 แปลงติดต่อกันและแนวเขตรอบทรัพย์รหัส 4T0362', 'https://npa.sam.or.th/site/images/npa/13955/20180801132950_4T0362C1_61.jpg', '/listing-media/sam/4t0362/15.webp', 'image/webp', 29370, 450, 450, 150, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปทรัพย์', 'แผนที่ต้นทางแสดงตำแหน่งทรัพย์ 4T0362 ถนนรัตนโกสินทร์และสถานที่สำคัญในเชียงใหม่', 'https://npa.sam.or.th/site/images/npa/13955/20180801133727_4T0362M1_61.jpg', '/listing-media/sam/4t0362/16.webp', 'image/webp', 58538, 785, 600, 160, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'แผนผังเขตพื้นที่จากต้นทาง', 'แผนผังสีเขตพื้นที่จากหน้า SAM สำหรับทรัพย์รหัส 4T0362 ผู้ซื้อต้องตรวจสอบข้อกำหนดปัจจุบันกับหน่วยงานท้องถิ่น', 'https://npa.sam.or.th/site/images/npa/13955/4T0362C3_67.jpg', '/listing-media/sam/4t0362/17.webp', 'image/webp', 34606, 450, 450, 170, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=13955&keyref=6004080',
        '4T0362',
        '2026-09-09 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 101,996,000, or THB 58,889 per sq.wah, for eight contiguous plots under title deeds 14281, 75698, 75699, 75700, 75701, 75702, 75703 and 75704. Total area is 4 rai 1 ngan 32 sq.wah / 1,732 sq.wah / 6,928 sq.m. SAM describes road frontage on multiple sides and lists six transferred structure items, while stating that both football fields were demolished and that the title status of some other structures is unconfirmed. The source classifies the property as vacant land for search purposes, but the listing is stored with structures present so buyers see the conveyance caveat. The source shows a yellow planning zone with white diagonal lines; no permitted use is asserted. Administrator coordinates differ by approximately 0.08 meters from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all 17 unique source property, plot, zoning and navigation images; no MapxProp watermark was added.'
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
        'SAM Direct Sale: Eight-Plot Landholding on Rattanakosin Road, Chiang Mai, THB 101.996M',
        E'Eight contiguous plots used together, totalling 4 rai 1 ngan 32 sq.wah, or 1,732 sq.wah (6,928 sq.m.), on Rattanakosin Road in Wat Ket, Mueang Chiang Mai, Chiang Mai. The property comprises eight title deeds: 14281, 75698, 75699, 75700, 75701, 75702, 75703 and 75704.

SAM describes the polygonal holding as having road access on several sides: approximately 77 meters along Tratsawong Road, approximately 93 meters along Old Doi Saket Road or Rattanakosin Road, approximately 79 meters along a public road and an approximately 101-meter northern boundary, of which about 50 meters adjoins a public road.

Structures that SAM says it acquired comprise a 36 x 45-meter football field, a coffee shop, a single-storey restaurant, a single-storey residence, a 22 x 38-meter football field, and a two-storey office and shop building. SAM also reports that both football fields have been demolished. Other structures may exist without confirmed evidence that they form part of the land, and conveyance is limited to the items registered as transferred to SAM. Buyers should verify the registered items and current condition with SAM and the Land Office before offering.

Tratsawong Road is described as a public asphalt road with an approximately eight-meter carriageway within an approximately 12-meter right of way. Rattanakosin Road is described as a public asphalt road with an approximately 12-meter carriageway within an approximately 22-meter right of way. Nearby places listed by SAM include McCormick Hospital, Chiang Mai Arcade Bus Terminal, Court of Appeal Region 5, Central Chiangmai and Chiang Mai Railway Station.

The SAM page shows the planning designation as a yellow zone with white diagonal lines. Buyers should take the title-deed numbers, surveyed boundaries and intended use to the relevant local authorities to confirm current planning and building-control requirements before offering. MapxProp places the listing in both residential and business discovery because of its location and reported structures; this is not a representation that every use or development is permitted.

The SAM page lists the property for direct purchase at an announced price of THB 101,996,000, or THB 58,889 per sq.wah. It is not an auction. Contact SAM directly to confirm availability, offer procedures, current price, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: 4T0362. MapxProp does not collect deposits or represent SAM in the transaction.

The source cover photo displays 9 April 2023, while several interior photos display 4 March 2022. Conditions may have changed. Buyers should arrange an inspection and verify title deeds, boundaries, structures, planning, access, utilities, flooding, drainage, soil, encumbrances, expenses and every current term before deciding.',
        'Eight contiguous plots with SAM-listed structures',
        'Fronting Rattanakosin Road, Tratsawong Road and public roads',
        'Rattanakosin Road',
        'Wat Ket',
        'Mueang Chiang Mai',
        'Chiang Mai',
        'SAM Direct-Sale Land on Rattanakosin Road, Chiang Mai, THB 101.996M',
        'Official SAM NPA asset 4T0362: eight contiguous plots totalling 6,928 sq.m. with multi-side road access and registered structures. Direct-sale price THB 101.996M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset 4T0362 eight contiguous plots land Rattanakosin Road Tratsawong Road Wat Ket Mueang Chiang Mai 4 rai 1 ngan 32 sq.wah 1732 sq.wah 6928 sq.m. title deeds 14281 75698 75699 75700 75701 75702 75703 75704 THB 101996000')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=13955&keyref=6004080'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=13955&keyref=6004080',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 4T0362. Specifications, title-deed numbers, images, rounded coordinates, announced price, direct-purchase status, road measurements, structure caveats and planning-zone wording come from that record.',
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
        '46ea87ad-2fae-4c2c-9573-65c0652ca549',
        jsonb_build_object(
            'reference_code', '4T0362',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'title_document_count', 8,
            'structure_title_review_required', true,
            'zoning_review_required', true,
            'source_image_count', 17
        )
    );
END $$;

COMMIT;
