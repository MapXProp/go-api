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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing HL0817';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing HL0817';
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
        '46bda336-5681-41cd-9692-023b2fe21a34',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'house',
        'residence',
        'sale',
        'whole_property',
        'บ้านโนนสะอาด',
        '8/1, 224',
        'ขายตรง SAM บ้านเดี่ยวชั้นเดียว 2 หลัง รวม 5 ห้องนอน 5 ห้องน้ำ ติด ทล.2045 ร้อยเอ็ด ราคา 3.333 ล้านบาท',
        E'บ้านเดี่ยวชั้นเดียว 2 หลัง เลขที่ 8/1 และ 224 ในโครงการบ้านโนนสะอาด ถนนสายร้อยเอ็ด-วาปีปทุม (ทล.2045) ตำบลขอนแก่น อำเภอเมืองร้อยเอ็ด จังหวัดร้อยเอ็ด บนโฉนดที่ดินเลขที่ 66096 จำนวน 1 ฉบับ เนื้อที่ 1 งาน 32 ตร.ว. หรือ 132 ตร.ว. (528 ตร.ม.) หน้า SAM ระบุรวม 5 ห้องนอน 5 ห้องน้ำ และเขตพื้นที่สีเขียว\n\nที่ดินเป็นรูปสี่เหลี่ยมคางหมู ด้านทิศใต้ติดถนน หน้ากว้างประมาณ 16 เมตร และลึกสุดประมาณ 32 เมตร ผู้ซื้อควรตรวจโฉนด รังวัด รูปแปลง แนวเขต ระยะหน้ากว้าง ความลึก ตำแหน่งอาคาร และทางเข้าออกจริงก่อนเสนอซื้อ\n\nข้อควรตรวจสำคัญ: รายการรับโอนกรรมสิทธิ์สิ่งปลูกสร้างของ SAM ประกอบด้วยบ้านพักอาศัยตึกชั้นเดียวเลขที่ 8/1 โรงจอด 2 รายการ บ้านพักอาศัยตึกชั้นเดียวเลขที่ 224 และโรงจอดรถอีก 1 รายการ รวม 5 รายการ ขณะที่ข้อมูลสำรวจสภาพทรัพย์อธิบายเพียงบ้านเดี่ยวชั้นเดียวเลขที่ 8/1 และ 224 จำนวน 2 หลัง SAM ระบุว่าจะโอนกรรมสิทธิ์ตามข้อมูลรายการสิ่งปลูกสร้างที่จดทะเบียนรับโอนทางทะเบียนเท่านั้น ผู้ซื้อต้องตรวจทะเบียนอาคาร รายการจดทะเบียน ตำแหน่ง จำนวนและสภาพโรงจอด แบบแปลน ใบอนุญาต และสิ่งปลูกสร้างที่จะได้รับโอนให้ตรงกับสภาพจริง\n\nถนนผ่านหน้าทรัพย์คือถนนสายร้อยเอ็ด-วาปีปทุม (ทล.2045) ซึ่ง SAM ระบุว่าเป็นทางสาธารณประโยชน์ ผิวจราจรลาดยางกว้างประมาณ 20 เมตร เขตทางกว้างประมาณ 40 เมตร ทรัพย์อยู่ในย่านที่อยู่อาศัยและมีสาธารณูปโภคครบครันตามต้นทาง แต่ผู้ซื้อควรตรวจแนวเขตทาง จุดกลับรถ ทางเข้าออก น้ำประปา ไฟฟ้า การระบายน้ำ และข้อจำกัดการเชื่อมทางหลวงกับหน่วยงานที่เกี่ยวข้อง\n\nการเดินทางตาม SAM ใช้ถนนสายร้อยเอ็ด-วาปีปทุม (ทล.2045) จากตัวเมืองร้อยเอ็ดมุ่งหน้าอำเภอวาปีปทุม ผ่านร้านร้อยเอ็ดสแตนเลส และจงกุลพาณิชย์ ขายสเตนเลส สาขาร้อยเอ็ด แล้วจะพบทรัพย์อยู่ด้านขวามือ\n\nหน้า SAM แสดงสถานะ “ซื้อตรง” และราคาประกาศขาย 3,333,000 บาท ไม่ใช่การประมูลในสถานะที่ตรวจสอบเมื่อวันที่ 10 กันยายน 2569 ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะการครอบครอง และวิธีจำหน่ายล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ HL0817 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nชุดภาพต้นทางไม่มีภาพภายในบ้าน มีภาพหน้าทรัพย์และแนวถนนที่แสดงวันที่ 4 มกราคม 2566 และ 2 มีนาคม 2566 พร้อมผังบ้าน ผังแปลง และแผนที่ สภาพจริงอาจเปลี่ยนแปลง จึงไม่สามารถยืนยันสภาพภายใน ห้องนอน ห้องน้ำ ครัว ระบบไฟฟ้า-ประปา หลังคา หรือโรงจอดได้ ผู้ซื้อควรนัดตรวจบ้านทั้ง 2 หลัง โครงสร้าง หลังคา รอยร้าว ความชื้น ปลวก ระบบไฟฟ้าและประปา ห้องน้ำ โรงจอด การระบายน้ำ น้ำท่วม การครอบครอง ภาระผูกพัน ภาษี ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        3333000,
        false,
        528,
        5,
        5,
        1,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'บ้านเลขที่ 8/1 และ 224 บ้านโนนสะอาด',
        'ติดถนนสายร้อยเอ็ด-วาปีปทุม (ทล.2045)',
        'ถนนสายร้อยเอ็ด-วาปีปทุม (ทล.2045)',
        NULL,
        16.012814959155516,
        103.600656148199,
        'ร้อยเอ็ด',
        'เมืองร้อยเอ็ด',
        'ขอนแก่น',
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
        'sam-direct-sale-two-single-storey-houses-highway-2045-roi-et-hl0817'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 3333000, 'total', 'THB', false
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
            'project_name', 'บ้านโนนสะอาด',
            'listed_unit_numbers', jsonb_build_array('8/1', '224'),
            'title_document_type', 'chanote',
            'title_deed_number', '66096',
            'title_document_count', 1,
            'land_area_rai', 0,
            'land_area_ngan', 1,
            'land_area_square_wah_remainder', 32,
            'land_area_square_wah', 132,
            'land_area_sqm', 528,
            'plot_count', 1,
            'house_count', 2,
            'bedroom_count_total', 5,
            'bathroom_count_total', 5,
            'registered_house_floor_count', 1,
            'registered_structure_count', 5,
            'registered_house_count', 2,
            'registered_parking_structure_count', 3,
            'registered_transfer_structures', jsonb_build_array(
                'บ้านพักอาศัยตึกชั้นเดียว เลขที่ 8/1',
                'โรงจอด',
                'โรงจอด',
                'บ้านพักอาศัยตึกชั้นเดียว เลขที่ 224',
                'โรงจอดรถ'
            ),
            'surveyed_structure_description', 'บ้านเดี่ยวชั้นเดียว เลขที่ 8/1 และบ้านเดี่ยวชั้นเดียว เลขที่ 224',
            'transfer_limited_to_registered_acquisition_records', true,
            'plot_shape', 'trapezoid',
            'south_road_frontage_m_approx', 16,
            'maximum_depth_m_approx', 32
        ) || jsonb_build_object(
            'front_road_name', 'ถนนสายร้อยเอ็ด-วาปีปทุม (ทล.2045)',
            'front_road_legal_status_th', 'ทางสาธารณประโยชน์',
            'front_road_surface', 'asphalt',
            'front_road_width_m_approx', 20,
            'front_right_of_way_width_m_approx', 40,
            'zoning_color_th', 'สีเขียว ตามหน้า SAM',
            'surrounding_area_use_th', 'ย่านที่อยู่อาศัย สาธารณูปโภคครบครัน',
            'mixed_use_classification', false,
            'mixed_use_exclusion_basis', 'SAM ระบุเป็นบ้านเดี่ยวในย่านที่อยู่อาศัยและไม่ได้ระบุว่าเป็น Mixed Use',
            'usable_area_not_published', true,
            'interior_photos_not_published', true,
            'room_distribution_between_houses_not_published', true,
            'building_age_not_published', true,
            'utilities_specifications_not_published', true,
            'occupancy_status_not_published', true,
            'other_encumbrances_not_published', true,
            'parking_structures_require_registry_and_condition_verification', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'computed_price_per_square_wah', 25250,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_property_photo_dates_displayed', jsonb_build_array('2023-01-04', '2023-03-02'),
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '16.012853,103.600641',
            'administrator_coordinate_distance_from_source_m_approx', 4.53
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for HL0817. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนสายร้อยเอ็ด-วาปีปทุม (ทล.2045)', 'Roi Et-Wapi Pathum Highway 2045', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ร้านร้อยเอ็ดสแตนเลส', 'Roi Et Stainless Shop', 'landmark', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'จงกุลพาณิชย์ ขายสเตนเลส สาขาร้อยเอ็ด', 'Jongkul Panit Stainless, Roi Et Branch', 'landmark', NULL, NULL, NULL, 30, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '3,333,000 บาท — โปรดตรวจสอบราคาล่าสุดและโปรโมชั่นกับ SAM', 'THB 3,333,000 — confirm the latest price and promotions with SAM', 'unspecified', 3333000, 'THB', 20),
        (property_listing_id, 'registered_structures', 'สิ่งปลูกสร้างตามรายการรับโอน', 'Structures in acquisition records', 'บ้านพักอาศัยชั้นเดียวเลขที่ 8/1 และ 224 พร้อมโรงจอด 2 รายการและโรงจอดรถ 1 รายการ รวม 5 รายการ', 'Single-storey houses 8/1 and 224 plus two garage entries and one carport entry, totaling five registered structures', 'buyer', 5, 'structures', 30),
        (property_listing_id, 'registered_transfer_basis', 'หลักเกณฑ์รายการสิ่งปลูกสร้างที่จะโอน', 'Registered transfer basis', 'SAM ระบุว่าจะโอนตามรายการสิ่งปลูกสร้างที่จดทะเบียนรับโอนทางทะเบียนเท่านั้น ต้องเทียบทะเบียนกับสภาพจริง โดยเฉพาะโรงจอด 3 รายการ', 'SAM states that transfer follows its registered acquisition records only; compare those records with current conditions, especially the three parking structures', 'buyer', NULL, '', 40),
        (property_listing_id, 'highway_frontage', 'ถนนหน้าทรัพย์', 'Highway frontage', 'ติดถนนสายร้อยเอ็ด-วาปีปทุม (ทล.2045) ผิวลาดยางกว้างประมาณ 20 เมตร เขตทางประมาณ 40 เมตร', 'Fronts Roi Et-Wapi Pathum Highway 2045, described as an approximately twenty-metre asphalt road within an approximately forty-metre right of way', 'unspecified', 20, 'metres', 50),
        (property_listing_id, 'interior_photo_caveat', 'ภาพภายในบ้าน', 'Interior-photo caveat', 'ชุดภาพต้นทางไม่มีภาพภายในบ้านทั้ง 2 หลัง ต้องตรวจห้องนอน ห้องน้ำ ครัว ระบบไฟฟ้า-ประปา หลังคา และสภาพซ่อมจริง', 'The source gallery does not show either house interior; inspect bedrooms, bathrooms, kitchens, utilities, roofs and repair condition in person', 'buyer', NULL, '', 60),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนด แนวเขต บ้านทั้ง 2 หลัง จำนวนห้อง รายการโรงจอด ทะเบียนอาคาร ทางเข้าออกทางหลวง ระบบไฟฟ้า-ประปา การครอบครอง ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Verify title, boundaries, both houses, room counts, parking structures, building records, highway access, utilities, possession, encumbrances, costs and latest terms', 'buyer', NULL, '', 70)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'บ้านเดี่ยว 2 หลังติดทางหลวง 2045', 'บ้านเดี่ยวชั้นเดียวเลขที่ 8/1 และ 224 รหัส SAM HL0817 ติดถนนร้อยเอ็ด-วาปีปทุม', 'https://npa.sam.or.th/site/images/npa/23165/20260328230124_HL0817P1_69.jpg', '/listing-media/sam/hl0817/01.webp', 'image/webp', 20564, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมหน้าทรัพย์จากแนวถนน', 'ภาพมุมกว้างหน้าบ้านทั้งสองหลังและแนวรั้วติดถนนสายร้อยเอ็ด-วาปีปทุม', 'https://npa.sam.or.th/site/images/npa/23165/HL0817P4_69.jpg', '/listing-media/sam/hl0817/02.webp', 'image/webp', 14118, 714, 309, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวถนนหน้าทรัพย์', 'ภาพถนนสายร้อยเอ็ด-วาปีปทุมและลูกศรแสดงตำแหน่งบ้าน SAM HL0817', 'https://npa.sam.or.th/site/images/npa/23165/HL0817P3_69.jpg', '/listing-media/sam/hl0817/03.webp', 'image/webp', 17120, 715, 327, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'floor_plan', 'ผังบ้านเลขที่ 8/1 และ 224', 'ผังต้นทางแสดงการจัดห้องของบ้านพักอาศัยชั้นเดียวเลขที่ 8/1 และ 224', 'https://npa.sam.or.th/site/images/npa/23165/HL0817C3_69.jpg', '/listing-media/sam/hl0817/04.webp', 'image/webp', 20226, 785, 600, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังตำแหน่งบ้าน 2 หลังบนแปลง', 'ผังต้นทางแสดงตำแหน่งบ้านพักอาศัยชั้นเดียว 2 หลังบนโฉนดเลขที่ 66096', 'https://npa.sam.or.th/site/images/npa/23165/20260328230124_HL0817C2_69.jpg', '/listing-media/sam/hl0817/05.webp', 'image/webp', 12230, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังแปลงรูปสี่เหลี่ยมคางหมู', 'ผังต้นทางแสดงโฉนดเลขที่ 66096 และด้านใต้ติดถนนสายร้อยเอ็ด-วาปีปทุม', 'https://npa.sam.or.th/site/images/npa/23165/20260328230124_HL0817C1_69.jpg', '/listing-media/sam/hl0817/06.webp', 'image/webp', 8568, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปบ้านโนนสะอาด', 'แผนที่ต้นทางแสดงเส้นทางบนถนนร้อยเอ็ด-วาปีปทุมไปยังบ้านโนนสะอาด รหัส HL0817', 'https://npa.sam.or.th/site/images/npa/23165/20260328230124_HL0817M_69 (66).jpg', '/listing-media/sam/hl0817/07.webp', 'image/webp', 29044, 785, 600, 70, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=23165&keyref=6004425',
        'HL0817',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 3,333,000 for two single-storey detached houses numbered 8/1 and 224 in Ban Non Sa-at on Roi Et-Wapi Pathum Highway 2045, Khon Kaen Subdistrict, Mueang Roi Et. Title deed 66096 covers 1 ngan 32 sq.wah / 132 sq.wah / 528 sq.m. The source lists five bedrooms and five bathrooms in total but does not publish their distribution between the two houses. The trapezoidal plot has approximately sixteen metres of southern road frontage and a maximum depth of approximately thirty-two metres. SAM acquisition records list five structures: two masonry residences, two entries described as garages and one carport/garage. Survey information describes the two houses only, and SAM states that transfer follows its registered acquisition records. Buyers must reconcile the registered list, actual structures and the condition of all three parking structures. Highway 2045 is described as a public asphalt road approximately twenty metres wide within an approximately forty-metre right of way. The source identifies green planning zoning and residential surroundings with utilities. The gallery does not show house interiors. Source property photos display 4 January 2023 and 2 March 2023. Administrator coordinates are approximately 4.53 metres from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all seven unique source exterior, road, floor-plan, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Two Single-Storey Houses, 5 Beds, Highway 2045, Roi Et, THB 3.333M',
        E'Two single-storey detached houses numbered 8/1 and 224 in Ban Non Sa-at on Roi Et-Wapi Pathum Highway 2045, Khon Kaen Subdistrict, Mueang Roi Et. Title deed 66096 covers 1 ngan 32 sq.wah, or 132 sq.wah (528 sq.m.). SAM lists five bedrooms and five bathrooms in total and identifies green planning zoning.\n\nThe trapezoidal plot has approximately sixteen metres of southern road frontage and a maximum depth of approximately thirty-two metres. Buyers should verify the title deed, survey, plot shape, boundaries, measurements, building positions and actual access before offering.\n\nImportant structure-record caveat: SAM''s acquisition records list a single-storey masonry residence numbered 8/1, two garage entries, a single-storey masonry residence numbered 224 and one further carport/garage entry, totaling five structures. Its survey description identifies the two houses only. SAM states that transfer follows the structures in its registered acquisition records. Buyers must compare building records, registered entries, plans, permits, the number and condition of all parking structures and current physical conditions.\n\nThe property fronts Roi Et-Wapi Pathum Highway 2045, which SAM describes as a public asphalt road approximately twenty metres wide within an approximately forty-metre right of way. The surrounding area is residential and has full utilities according to the source. Buyers should verify highway access, turning arrangements, right-of-way boundaries, water, electricity, drainage and any road-connection restrictions.\n\nSAM''s directions use Highway 2045 from central Roi Et toward Wapi Pathum, passing Roi Et Stainless Shop and Jongkul Panit Stainless, Roi Et Branch. The property is on the right.\n\nThe SAM page listed the property for direct purchase at an announced THB 3,333,000 when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, offer procedures, current price, promotions, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: HL0817. MapxProp does not collect deposits or represent SAM in the transaction.\n\nThe source gallery does not show either house interior. Exterior and road photos display 4 January 2023 and 2 March 2023, so current condition may differ. Interior condition, room distribution, kitchens, electrical and plumbing systems, roofs and parking structures cannot be confirmed. Buyers should inspect both houses, structure, roofs, cracks, moisture, termites, utilities, bathrooms, parking structures, drainage, flooding, possession, encumbrances, taxes, costs and every current term before deciding.',
        'Houses 8/1 and 224, Ban Non Sa-at',
        'Fronting Roi Et-Wapi Pathum Highway 2045',
        'Roi Et-Wapi Pathum Highway 2045',
        'Khon Kaen',
        'Mueang Roi Et',
        'Roi Et',
        'SAM Two Single-Storey Houses on Highway 2045, Roi Et, THB 3.333M',
        'Official SAM NPA asset HL0817: two single-storey houses with 5 bedrooms and 5 bathrooms on 528 sq.m. Direct-sale price THB 3.333M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset HL0817 two single storey detached houses 8/1 224 Ban Non Sa-at Khon Kaen Subdistrict Mueang Roi Et Roi Et Wapi Pathum Highway 2045 5 bedrooms 5 bathrooms 132 sq.wah 528 sq.m. title deed 66096 THB 3333000')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=23165&keyref=6004425'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=23165&keyref=6004425',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for HL0817. Specifications, title deed, house and registered parking-structure list, transfer basis, images, rounded coordinates, announced price, direct-purchase status, highway measurements, room totals and planning-zone wording come from that record.',
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
        '46bda336-5681-41cd-9692-023b2fe21a34',
        jsonb_build_object(
            'reference_code', 'HL0817',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'residence',
            'discovery_channels', jsonb_build_array('homes'),
            'title_document_count', 1,
            'house_count', 2,
            'bedroom_count_total', 5,
            'bathroom_count_total', 5,
            'registered_structure_count', 5,
            'parking_structure_registry_review_required', true,
            'interior_inspection_required', true,
            'source_image_count', 7
        )
    );
END $$;

COMMIT;
