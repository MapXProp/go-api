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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing HL0054';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing HL0054';
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
        'e4d8b1d3-ec94-400f-afa1-e0787554ad3f',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'house',
        'residence',
        'sale',
        'whole_property',
        'กุลพันธ์วิลล์ 8',
        '99/54-55',
        'ขายตรง SAM บ้านเดี่ยวพร้อมสิ่งปลูกสร้าง 3 หลัง กุลพันธ์วิลล์ 8 หางดง 2-1-64 ไร่ ราคา 28.77 ล้านบาท',
        E'บ้านเดี่ยวพร้อมที่ดิน 3 โฉนดในหมู่บ้านกุลพันธ์วิลล์ 8 เลขที่ 99/54-55 ตำบลหนองควาย อำเภอหางดง จังหวัดเชียงใหม่ เนื้อที่รวม 2 ไร่ 1 งาน 64 ตร.ว. หรือ 964 ตร.ว. (3,856 ตร.ม.) โฉนดที่ดินเลขที่ 44806, 65589 และ 48050 จำนวน 3 ฉบับ อยู่ในย่านที่อยู่อาศัย เขตผังเมืองสีเหลือง

รายการที่ SAM จดทะเบียนรับโอนกรรมสิทธิ์ประกอบด้วย 1) บ้านพักอาศัยตึก 2 ชั้น เลขที่ 99/54-55 2) บ้านตึกชั้นเดียวไม่ปรากฏเลขที่ และ 3) บ้านพักอาศัยครึ่งตึกครึ่งไม้ 2 ชั้นไม่ปรากฏเลขที่ ผู้ซื้อต้องตรวจเอกสารสิทธิ์ ทะเบียนอาคาร เลขที่อาคาร ขอบเขต และสภาพของสิ่งปลูกสร้างทั้ง 3 รายการก่อนเสนอซื้อ หน้า SAM ไม่ระบุพื้นที่ใช้สอย จำนวนห้องนอน ห้องน้ำ ที่จอดรถ อายุอาคาร สาธารณูปโภค หรือสถานะผู้ใช้ประโยชน์

แปลงที่ดินเป็นรูปหลายเหลี่ยม ด้านทิศตะวันออกติดถนน หน้ากว้างประมาณ 39 เมตร และลึกสูงสุดประมาณ 132 เมตร ถนนผ่านหน้าทรัพย์คือหมู่บ้านกุลพันธ์วิลล์ 8 ซอย 5 ผิวจราจรคอนกรีตกว้างประมาณ 8 เมตร เขตทางกว้างประมาณ 10 เมตร

ข้อควรตรวจสอบสำคัญ: SAM ระบุว่าถนนหมู่บ้านกุลพันธ์วิลล์ 8 ซอย 5 เป็นทางภายในโครงการที่ไม่ได้ขออนุญาตจัดสรร แต่แบ่งไว้เพื่อใช้เป็นทางเข้าออกสำหรับที่ดินแปลงย่อยและมีการใช้เปิดเผยมานานกว่า 10 ปี ข้อความนี้ไม่ใช่การรับรองสิทธิทางกฎหมาย ผู้ซื้อต้องให้ SAM สำนักงานที่ดิน เจ้าของทาง และผู้เกี่ยวข้องยืนยันกรรมสิทธิ์ถนน ภาระจำยอม สิทธิผ่านทาง ผู้มีสิทธิใช้ทาง ค่าใช้จ่าย และการเข้าออกที่ใช้ได้จริงก่อนเสนอซื้อ

การเดินทางตามหน้า SAM ใช้ถนนสายหางดง-สะเมิง (ทล.3269) จากอำเภอสะเมิงมุ่งหน้าอำเภอสารภี ผ่านวัดสหัสสคุณและโรงพยาบาลสาธารณสุขตำบลบ้านต้นเกว๋น ถึงแยกถนนเลี่ยงเมืองสันป่าตอง-หางดง (ชม.3035) ตรงไปประมาณ 480 เมตร แล้วเลี้ยวซ้ายเข้าทางเข้าหมู่บ้านกุลพันธ์วิลล์ 8 ประมาณ 190 เมตร ทรัพย์อยู่ด้านขวามือ สถานที่ใกล้เคียงที่ SAM ระบุ ได้แก่ เทศบาลตำบลหนองควาย วัดร้อยจันทร์ และวัดสหัสสคุณ (วัดพันเตา)

หน้า SAM ระบุสถานะ “ซื้อตรง” และราคาประกาศขาย 28,770,000 บาท ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน ค่าใช้จ่าย สถานะการครอบครอง สิทธิใช้ทาง และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ HL0054 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM

ภาพสภาพทรัพย์ในหน้าต้นทางแสดงวันที่ 27 มีนาคม 2567 สภาพจริงอาจเปลี่ยนแปลง ผู้ซื้อควรนัดตรวจทรัพย์ ตรวจโครงสร้างอาคารทุกหลัง ระบบไฟฟ้าและสาธารณูปโภค การระบายน้ำ น้ำท่วม ดิน แนวเขต การครอบครอง ทางเข้าออก ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        28770000,
        false,
        3856,
        2,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        '99/54-55 หมู่บ้านกุลพันธ์วิลล์ 8',
        'ใกล้ถนนเลี่ยงเมืองเชียงใหม่รอบนอก (ทล.121)',
        'หมู่บ้านกุลพันธ์วิลล์ 8 ซอย 5',
        NULL,
        18.72586286,
        98.93172801,
        'เชียงใหม่',
        'หางดง',
        'หนองควาย',
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
        'sam-direct-sale-house-kulphan-ville-8-hang-dong-chiang-mai-hl0054'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 28770000, 'total', 'THB', false
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
            'project_name', 'กุลพันธ์วิลล์ 8',
            'listed_unit_number', '99/54-55',
            'title_document_type', 'chanote',
            'title_deed_numbers', jsonb_build_array('44806', '65589', '48050'),
            'title_document_count', 3,
            'plot_count', 3,
            'land_area_rai', 2,
            'land_area_ngan', 1,
            'land_area_square_wah_remainder', 64,
            'land_area_square_wah', 964,
            'land_area_sqm', 3856,
            'registered_transferred_structure_count', 3,
            'main_registered_structure', 'บ้านพักอาศัยตึก 2 ชั้น เลขที่ 99/54-55',
            'secondary_registered_structure_1', 'บ้านตึกชั้นเดียว ไม่ปรากฏเลขที่',
            'secondary_registered_structure_2', 'บ้านพักอาศัยครึ่งตึกครึ่งไม้ 2 ชั้น ไม่ปรากฏเลขที่',
            'maximum_floor_count', 2,
            'bedroom_count_not_published', true,
            'bathroom_count_not_published', true,
            'usable_area_not_published', true,
            'parking_information_not_published', true,
            'building_age_not_published', true,
            'plot_shape', 'polygon',
            'east_road_frontage_m', 39,
            'maximum_depth_m', 132,
            'front_road_name', 'หมู่บ้านกุลพันธ์วิลล์ 8 ซอย 5',
            'front_road_surface', 'concrete'
        ) || jsonb_build_object(
            'front_road_width_m', 8,
            'front_right_of_way_width_m', 10,
            'internal_project_road', true,
            'project_not_registered_as_authorized_land_allocation', true,
            'road_reserved_for_subdivided_plot_access', true,
            'source_states_open_use_over_ten_years', true,
            'legal_access_right_not_confirmed', true,
            'access_right_requires_buyer_verification', true,
            'zoning_color_th', 'สีเหลือง ตามหน้า SAM',
            'surrounding_area_use_th', 'ย่านที่อยู่อาศัย',
            'source_states_convenient_transportation', true,
            'occupancy_status_not_published', true,
            'utilities_information_not_published', true,
            'other_encumbrances_not_published', true,
            'source_information_date_not_published', true,
            'source_property_photo_date_displayed', '2024-03-27',
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'computed_price_per_square_wah', 29844.40,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-09',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '18.725888,98.931796',
            'administrator_coordinate_distance_from_source_m_approx', 7.69
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for HL0054. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนเลี่ยงเมืองเชียงใหม่รอบนอก (ทล.121)', 'Chiang Mai Outer Ring Road Highway 121', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'เทศบาลตำบลหนองควาย', 'Nong Khwai Subdistrict Municipality', 'government', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'วัดร้อยจันทร์', 'Wat Roi Chan', 'landmark', NULL, NULL, NULL, 30, false),
        (property_listing_id, 'วัดสหัสสคุณ (วัดพันเตา)', 'Wat Sahatsakhun (Wat Phan Tao)', 'landmark', NULL, NULL, NULL, 40, false),
        (property_listing_id, 'โรงพยาบาลสาธารณสุขตำบลบ้านต้นเกว๋น', 'Ban Ton Kwen Subdistrict Public Health Hospital', 'healthcare', NULL, NULL, NULL, 50, false)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '28,770,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 28,770,000 — confirm the latest price with SAM', 'unspecified', 28770000, 'THB', 20),
        (property_listing_id, 'title_documents', 'เอกสารสิทธิ์', 'Title documents', 'โฉนดที่ดินเลขที่ 44806, 65589 และ 48050 จำนวน 3 ฉบับ เนื้อที่รวม 2 ไร่ 1 งาน 64 ตร.ว.', 'Three title deeds, nos. 44806, 65589 and 48050, totalling 2 rai 1 ngan 64 sq.wah', 'unspecified', 3, 'documents', 30),
        (property_listing_id, 'registered_structures', 'สิ่งปลูกสร้างที่รับโอน', 'Registered structures', 'SAM ระบุรายการรับโอน 3 หลัง ได้แก่ บ้านตึก 2 ชั้นเลขที่ 99/54-55 บ้านตึกชั้นเดียว และบ้านครึ่งตึกครึ่งไม้ 2 ชั้น', 'SAM lists three transferred structures: a two-storey masonry house no. 99/54-55, a one-storey masonry house, and a two-storey half-masonry half-timber house', 'buyer', 3, 'items', 40),
        (property_listing_id, 'access_right', 'สิทธิใช้ทางเข้าออก', 'Access rights', 'ถนนในโครงการไม่ได้ขออนุญาตจัดสรร แม้ระบุว่าเปิดใช้เข้าออกแปลงย่อยมานานกว่า 10 ปี ต้องตรวจกรรมสิทธิ์ถนน ภาระจำยอม และสิทธิใช้ทางก่อนซื้อ', 'The project road was not created under an authorized land allocation; although reported in open use for more than ten years, road ownership, servitude and access rights must be verified', 'buyer', NULL, '', 50),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนดทั้ง 3 ฉบับ แนวเขต สิ่งปลูกสร้าง ทะเบียนอาคาร สภาพอาคาร การครอบครอง ทางเข้าออก กรรมสิทธิ์ถนน ภาระจำยอม สาธารณูปโภค น้ำท่วม ดิน ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Verify all three title deeds, boundaries, structures, building records, condition, possession, access, road ownership, servitude, utilities, flooding, soil, encumbrances, costs and current terms', 'buyer', NULL, '', 60)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'บ้านหลักและซุ้มทางเข้า', 'บ้านพักอาศัยตึก 2 ชั้น SAM รหัส HL0054 ในกุลพันธ์วิลล์ 8 หางดง เชียงใหม่', 'https://npa.sam.or.th/site/images/npa/21223/20260105144119_HL0054P2_67.jpg', '/listing-media/sam/hl0054/01.webp', 'image/webp', 34676, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้าและอาคารชั้นเดียว', 'ภาพทางเข้าภายในแปลงและบ้านตึกชั้นเดียวส่วนหนึ่งของทรัพย์', 'https://npa.sam.or.th/site/images/npa/21223/HL0054P3_67.jpg', '/listing-media/sam/hl0054/02.webp', 'image/webp', 49180, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'สวนและสิ่งปลูกสร้างภายใน', 'ภาพสวนและสิ่งปลูกสร้างหลายหลังภายในที่ดิน 2 ไร่ 1 งาน 64 ตารางวา', 'https://npa.sam.or.th/site/images/npa/21223/HL0054P4_67.jpg', '/listing-media/sam/hl0054/03.webp', 'image/webp', 45724, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงรับแขกพื้นหิน', 'ภาพโถงรับแขกภายในบ้านหลักพร้อมประตูและหน้าต่างบานใหญ่', 'https://npa.sam.or.th/site/images/npa/21223/HL0054P5_67.jpg', '/listing-media/sam/hl0054/04.webp', 'image/webp', 18662, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่นั่งเล่นภายใน', 'ภาพพื้นที่นั่งเล่นภายในบ้านหลักและองค์ประกอบตกแต่ง', 'https://npa.sam.or.th/site/images/npa/21223/HL0054P6_67.jpg', '/listing-media/sam/hl0054/05.webp', 'image/webp', 17790, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงบันได', 'ภาพโถงภายในและบันไดขึ้นชั้นสองของบ้านหลัก', 'https://npa.sam.or.th/site/images/npa/21223/HL0054P7_67.jpg', '/listing-media/sam/hl0054/06.webp', 'image/webp', 14546, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องโถงพื้นไม้', 'ภาพห้องโถงขนาดใหญ่พื้นไม้พร้อมหน้าต่างรอบด้าน', 'https://npa.sam.or.th/site/images/npa/21223/HL0054P8_67.jpg', '/listing-media/sam/hl0054/07.webp', 'image/webp', 20546, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องภายในบ้าน', 'ภาพห้องภายในบ้านพร้อมพื้นไม้และช่องแสง', 'https://npa.sam.or.th/site/images/npa/21223/HL0054P9_67.jpg', '/listing-media/sam/hl0054/08.webp', 'image/webp', 13372, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องพักพร้อมหน้าต่าง', 'ภาพห้องพักภายในบ้านหลักพร้อมหน้าต่างหลายด้าน', 'https://npa.sam.or.th/site/images/npa/21223/HL0054P10_67.jpg', '/listing-media/sam/hl0054/09.webp', 'image/webp', 15060, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องแนวยาวภายใน', 'ภาพห้องแนวยาวภายในบ้านและช่องเปิดเชื่อมพื้นที่', 'https://npa.sam.or.th/site/images/npa/21223/HL0054P11_67.jpg', '/listing-media/sam/hl0054/10.webp', 'image/webp', 12892, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงชั้นบน', 'ภาพโถงชั้นบนข้างราวบันไดและประตูห้อง', 'https://npa.sam.or.th/site/images/npa/21223/HL0054P13_67.jpg', '/listing-media/sam/hl0054/11.webp', 'image/webp', 14804, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บันไดและชานพัก', 'ภาพบันไดไม้และชานพักภายในบ้านสองชั้น', 'https://npa.sam.or.th/site/images/npa/21223/HL0054P16_67.jpg', '/listing-media/sam/hl0054/12.webp', 'image/webp', 13742, 450, 450, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำภายในบ้าน', 'ภาพห้องน้ำภายในพร้อมเคาน์เตอร์ อ่างล้างหน้า และสุขภัณฑ์', 'https://npa.sam.or.th/site/images/npa/21223/HL0054P12_67.jpg', '/listing-media/sam/hl0054/13.webp', 'image/webp', 17398, 450, 450, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำพร้อมอ่างอาบน้ำ', 'ภาพห้องน้ำภายในบ้านพร้อมอ่างอาบน้ำและสุขภัณฑ์', 'https://npa.sam.or.th/site/images/npa/21223/HL0054P14_67.jpg', '/listing-media/sam/hl0054/14.webp', 'image/webp', 18616, 450, 450, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ครัวและบริการ', 'ภาพพื้นที่ครัวและส่วนบริการภายในบ้าน', 'https://npa.sam.or.th/site/images/npa/21223/HL0054P15_67.jpg', '/listing-media/sam/hl0054/15.webp', 'image/webp', 18448, 450, 450, 150, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ถนนเลี่ยงเมืองและทางเข้าหมู่บ้าน', 'ภาพถนนเลี่ยงเมืองเชียงใหม่รอบนอกและทางเข้าหมู่บ้านกุลพันธ์วิลล์ 8', 'https://npa.sam.or.th/site/images/npa/21223/HL0054P1_67.jpg', '/listing-media/sam/hl0054/16.webp', 'image/webp', 22446, 450, 450, 160, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังแปลงและถนนทางเข้า', 'ผังต้นทางแสดงรูปแปลง ที่ตั้งทรัพย์ และแนวถนนภายในโครงการที่ต้องตรวจสิทธิใช้ทาง', 'https://npa.sam.or.th/site/images/npa/21223/HL0054C2_67.jpg', '/listing-media/sam/hl0054/17.webp', 'image/webp', 24564, 450, 450, 170, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังตำแหน่งแปลงในบริเวณ', 'ผังต้นทางแสดงตำแหน่งที่ดินสามแปลงภายในบริเวณหมู่บ้าน', 'https://npa.sam.or.th/site/images/npa/21223/20240919153251_HL0054C3_67.jpg', '/listing-media/sam/hl0054/18.webp', 'image/webp', 20876, 450, 450, 180, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังสิ่งปลูกสร้าง 3 หลัง', 'ผังต้นทางแสดงบ้านพักอาศัยตึก 2 ชั้น บ้านตึกชั้นเดียว และบ้านครึ่งตึกครึ่งไม้ 2 ชั้น', 'https://npa.sam.or.th/site/images/npa/21223/20240919153251_HL0054C1_67.jpg', '/listing-media/sam/hl0054/19.webp', 'image/webp', 19742, 450, 450, 190, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปทรัพย์', 'แผนที่ต้นทางแสดงเส้นทางไปบ้าน SAM HL0054 ในกุลพันธ์วิลล์ 8 หนองควาย หางดง', 'https://npa.sam.or.th/site/images/npa/21223/20240919153251_HL0054CM_67.jpg', '/listing-media/sam/hl0054/20.webp', 'image/webp', 68104, 785, 600, 200, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=21223&keyref=6004080',
        'HL0054',
        '2026-09-09 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 28,770,000 for a detached-house property in Kulphan Ville 8 under title deeds 44806, 65589 and 48050, totalling 2 rai 1 ngan 64 sq.wah / 964 sq.wah / 3,856 sq.m. SAM lists three transferred structures: a two-storey masonry house no. 99/54-55, an unnumbered one-storey masonry house, and an unnumbered two-storey half-masonry half-timber house. The polygonal plot has approximately 39 meters of east-facing road frontage and a maximum depth of approximately 132 meters. The internal concrete road is approximately eight meters wide within an approximately ten-meter right of way. SAM states that the road is within a project that did not obtain land-allocation authorization, was reserved for subdivided-plot access and has been openly used for more than ten years. Legal access, road ownership, servitude and actual rights require buyer verification. The source identifies a yellow planning zone and a residential area. Bedrooms, bathrooms, usable area, parking, building age, utilities, occupancy and other encumbrances are not published. Source property photos display 27 March 2024. Administrator coordinates are approximately 7.69 meters from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all 20 unique source property, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: House with Three Structures in Kulphan Ville 8, Hang Dong, THB 28.77M',
        E'A detached-house property on three title deeds in Kulphan Ville 8, no. 99/54-55, Nong Khwai, Hang Dong, Chiang Mai. The combined land area is 2 rai 1 ngan 64 sq.wah, or 964 sq.wah (3,856 sq.m.), under title deeds 44806, 65589 and 48050. SAM identifies a yellow planning zone in a residential area.

SAM''s registered acquisition records list three structures: (1) a two-storey masonry residence numbered 99/54-55, (2) an unnumbered one-storey masonry house, and (3) an unnumbered two-storey half-masonry half-timber residence. Buyers should verify all three title deeds, building registrations, addresses, boundaries and current condition before submitting an offer. The source does not publish usable area, bedroom or bathroom counts, parking, building age, utilities or occupancy.

The polygonal plot has approximately 39 meters of east-facing road frontage and a maximum depth of approximately 132 meters. The frontage is on Kulphan Ville 8 Soi 5, an internal concrete road approximately eight meters wide within an approximately ten-meter right of way.

Important access caveat: SAM states that Kulphan Ville 8 Soi 5 is an internal project road in a project that did not obtain land-allocation authorization. The road was reserved for access to subdivided plots and has reportedly been openly used for more than ten years. This does not itself confirm a legal access right. Buyers must ask SAM, the Land Office, the road owner and relevant parties to confirm road ownership, registered servitude, eligible users, maintenance costs and practical access before offering.

SAM''s directions use Hang Dong–Samoeng Road (Highway 3269), passing Wat Sahatsakhun and Ban Ton Kwen Subdistrict Public Health Hospital, then the San Pa Tong–Hang Dong Bypass intersection. Continue about 480 meters, turn left into Kulphan Ville 8 and proceed about 190 meters; the property is on the right. Nearby destinations listed by SAM include Nong Khwai Subdistrict Municipality, Wat Roi Chan and Wat Sahatsakhun (Wat Phan Tao).

The SAM page lists the property for direct purchase at an announced price of THB 28,770,000. It is not an auction. Contact SAM directly to confirm availability, offer procedures, current price, costs, possession, access rights and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: HL0054. MapxProp does not collect deposits or represent SAM in the transaction.

Source property photos display 27 March 2024, and conditions may have changed. Buyers should inspect all structures, electrical and utility systems, drainage, flooding, soil, boundaries, possession, access, encumbrances, expenses and every current term before deciding.',
        '99/54-55, Kulphan Ville 8',
        'Near Chiang Mai Outer Ring Road Highway 121',
        'Kulphan Ville 8 Soi 5',
        'Nong Khwai',
        'Hang Dong',
        'Chiang Mai',
        'SAM House on 3,856 sq.m. in Kulphan Ville 8, THB 28.77M',
        'Official SAM NPA asset HL0054: house property with three registered structures on 3,856 sq.m. in Kulphan Ville 8, Hang Dong. Direct-sale price THB 28.77M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset HL0054 detached house three structures Kulphan Ville 8 99/54-55 Nong Khwai Hang Dong Chiang Mai outer ring road Highway 121 2 rai 1 ngan 64 sq.wah 964 sq.wah 3856 sq.m. title deeds 44806 65589 48050 THB 28770000 access road servitude')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=21223&keyref=6004080'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=21223&keyref=6004080',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for HL0054. Specifications, title deeds, registered structures, images, rounded coordinates, announced price, direct-purchase status, road measurements and the access-right caveat come from that record.',
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
        'e4d8b1d3-ec94-400f-afa1-e0787554ad3f',
        jsonb_build_object(
            'reference_code', 'HL0054',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'title_document_count', 3,
            'registered_structure_count', 3,
            'access_right_review_required', true,
            'source_image_count', 20
        )
    );
END $$;

COMMIT;
