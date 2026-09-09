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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing BL0125';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing BL0125';
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
        '3d3dd067-4357-46c2-accf-c66d24c49dc5',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'factory',
        'business',
        'sale',
        'whole_property',
        'พรรณทิวาวิลล่า',
        '111, 111/1',
        'ขายตรง SAM โรงงาน/โกดัง พรรณทิวาวิลล่า หางดง เชียงใหม่ 5-3-30 ไร่ ราคา 19.941 ล้านบาท',
        E'โรงงานและโกดังพร้อมที่ดิน 6 โฉนดในหมู่บ้านพรรณทิวาวิลล่า ตำบลบ้านแหวน อำเภอหางดง จังหวัดเชียงใหม่ เนื้อที่รวม 5 ไร่ 3 งาน 30 ตร.ว. หรือ 2,330 ตร.ว. (9,320 ตร.ม.) โฉนดที่ดินเลขที่ 15730, 19139, 43989, 45794, 45795 และ 45796 จำนวน 6 ฉบับ หน้า SAM ระบุเขตพื้นที่สีเหลืองและตั้งอยู่ในย่านที่อยู่อาศัย

แปลงที่ดินเป็นรูปหลายเหลี่ยม ด้านทิศตะวันตกติดถนน กว้างประมาณ 112.5 เมตร ลึกสุดประมาณ 303.5 เมตร ถนนหน้าทรัพย์เป็นซอยหมู่บ้านพรรณทิวาวิลล่า ผิวคอนกรีตกว้างประมาณ 4 เมตร เขตทางกว้างประมาณ 5 เมตร SAM ระบุว่าเป็นทางภายในโครงการที่แบ่งแยกที่ดินไว้เพื่อใช้เป็นทางเข้าออก มีการใช้โดยสงบ เปิดเผย และไม่มีการปิดกั้นมานานกว่า 10 ปี แต่ผู้ซื้อยังต้องตรวจสอบกรรมสิทธิ์ถนน ภาระจำยอม สิทธิผ่านทาง ผู้มีสิทธิใช้ และการเข้าถึงจริงให้เป็นที่พอใจก่อนเสนอซื้อ

รายการรับโอนกรรมสิทธิ์ของ SAM ระบุว่าโฉนดเลขที่ 15730, 45794, 45795 และ 45796 ไม่มีสิ่งปลูกสร้าง โฉนดเลขที่ 43989 มีโรงเก็บของไม่ปรากฏเลขที่ 2 หลังและโกดังเก็บของไม่ปรากฏเลขที่ 1 หลัง ส่วนโฉนดเลขที่ 19139 มีบ้านพักอาศัยตึกชั้นเดียวไม่ปรากฏเลขที่ อาคารตึกชั้นเดียวเลขที่ 111/1 โกดังเก็บของเลขที่ 111 และอาคารห้องน้ำ 2 หลัง

ผลสำรวจสภาพของ SAM ระบุอาคารโกดังเก็บสินค้าและข้อความ “ทา เฟอร์นิเจอร์” ชั้นเดียว 2 หลัง บ้านพักคนงานชั้นเดียว 1 หลัง อาคารเก็บของชั้นเดียว 2 หลัง อาคารห้องน้ำ 2 หลัง และอาคารพักอาศัย/โรงจอดรถชั้นเดียว 1 หลัง โดยอาคารพักอาศัย/โรงจอดรถปลูกสร้างคร่อมลำเหมืองสาธารณประโยชน์ ผู้ซื้อต้องตรวจสอบทะเบียนอาคาร แนวเขต ลำเหมือง การรุกล้ำ การอนุญาต และสิ่งปลูกสร้างที่จะโอนให้ตรงกับสภาพจริงก่อนเสนอซื้อ

สำคัญ: SAM ระบุว่ามีผู้ใช้ประโยชน์ในทรัพย์และขายตามสภาพ ผู้ซื้อควรตรวจทรัพย์ก่อนเสนอซื้อ และอาจต้องเจรจาหรือดำเนินการทางกฎหมายเพื่อเข้าครอบครองด้วยค่าใช้จ่ายของผู้ซื้อเอง ไม่สามารถใช้ประเด็นการครอบครองเป็นเหตุยกเลิกการเสนอซื้อหรือสัญญา และไม่สามารถเรียกร้องจาก SAM ได้ ข้อมูลรายละเอียดระบุ ณ วันที่ 10 มิถุนายน 2569 จึงต้องสอบถามสถานะล่าสุดโดยตรง

การเดินทางตาม SAM ใช้ถนนสายแยก ทล.108-บ้านน้ำโท้ง (ชม.ถ.1-0034) จากถนนเชียงใหม่-ฮอด (ทล.108) มุ่งหน้าตลาดน้ำโท้ง ผ่านวัดกำแพงงามและการไฟฟ้าส่วนภูมิภาคอำเภอหางดง ถึงประมาณ กม.1+500 แล้วเลี้ยวซ้ายเข้าหมู่บ้านพรรณทิวาวิลล่าประมาณ 270 เมตร ทรัพย์อยู่ด้านขวามือ สถานที่ใกล้เคียงที่ SAM ระบุ ได้แก่ การไฟฟ้าส่วนภูมิภาคอำเภอหางดง วัดสันทราย และที่ว่าการอำเภอหางดง

หน้า SAM ระบุสถานะ “ซื้อตรง” และราคาประกาศขาย 19,941,000 บาท ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะผู้ใช้ประโยชน์ การเข้าครอบครอง สิทธิใช้ทาง และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ BL0125 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM

ภาพทรัพย์ในหน้าต้นทางแสดงวันที่ 26 ธันวาคม 2568 สภาพจริงอาจเปลี่ยนแปลง หน้า SAM ไม่ระบุพื้นที่ใช้สอยอาคาร กำลังไฟฟ้า ใบอนุญาตโรงงาน ความสูงอาคาร ระบบป้องกันอัคคีภัย การรับน้ำหนักพื้น หรือขนาดรถบรรทุกที่เข้าถึงได้ ผู้ซื้อควรนัดตรวจโครงสร้าง หลังคา ระบบไฟฟ้าและสาธารณูปโภค การระบายน้ำ น้ำท่วม ดิน แนวเขต ภาระผูกพัน ผังเมือง ใบอนุญาต และความเหมาะสมกับกิจการก่อนตัดสินใจ',
        19941000,
        false,
        9320,
        1,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'โรงงาน/โกดัง หมู่บ้านพรรณทิวาวิลล่า',
        'จากถนนเชียงใหม่-ฮอด (ทล.108) ผ่านถนนสายแยก ทล.108-บ้านน้ำโท้ง',
        'ซอยหมู่บ้านพรรณทิวาวิลล่า',
        NULL,
        18.69172460,
        98.93399211,
        'เชียงใหม่',
        'หางดง',
        'บ้านแหวน',
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
        'sam-direct-sale-factory-warehouse-phantiva-villa-hang-dong-chiang-mai-bl0125'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES
        (property_listing_id, 'industrial'),
        (property_listing_id, 'storage')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 19941000, 'total', 'THB', false
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
        property_listing_id, 'business', 'editorial', false
    )
    ON CONFLICT (listing_id, channel_code) DO UPDATE SET
        source = EXCLUDED.source,
        is_featured = EXCLUDED.is_featured,
        updated_at = now();

    INSERT INTO public.listing_category_details (
        listing_id, category_code, schema_version, details, is_minimum_submission
    ) VALUES (
        property_listing_id,
        'factory',
        1,
        jsonb_build_object(
            'source_property_category', 'โรงงาน/โกดัง',
            'project_name', 'พรรณทิวาวิลล่า',
            'title_document_type', 'chanote',
            'title_deed_numbers', jsonb_build_array('15730', '19139', '43989', '45794', '45795', '45796'),
            'title_document_count', 6,
            'plot_count', 6,
            'land_area_rai', 5,
            'land_area_ngan', 3,
            'land_area_square_wah_remainder', 30,
            'land_area_square_wah', 2330,
            'land_area_sqm', 9320,
            'plot_shape', 'polygon',
            'west_road_frontage_m', 112.5,
            'maximum_depth_m', 303.5,
            'front_road_name', 'ซอยหมู่บ้านพรรณทิวาวิลล่า',
            'front_road_surface', 'concrete',
            'front_road_width_m', 4,
            'front_right_of_way_width_m', 5,
            'access_type', 'internal_project_road',
            'access_reportedly_open_over_ten_years', true,
            'access_right_requires_buyer_verification', true,
            'zoning_color_th', 'สีเหลือง ตามหน้า SAM',
            'source_area_context', 'ย่านที่อยู่อาศัย',
            'registered_title_deeds_without_structures', jsonb_build_array('15730', '45794', '45795', '45796'),
            'registered_structure_title_deed_43989', jsonb_build_array('โรงเก็บของไม่ปรากฏเลขที่ หลังที่ 1', 'โรงเก็บของไม่ปรากฏเลขที่ หลังที่ 2', 'โกดังเก็บของไม่ปรากฏเลขที่'),
            'registered_structure_title_deed_19139', jsonb_build_array('บ้านพักอาศัยตึกชั้นเดียวไม่ปรากฏเลขที่', 'อาคารตึกชั้นเดียวเลขที่ 111/1', 'โกดังเก็บของเลขที่ 111', 'อาคารห้องน้ำ หลังที่ 1', 'อาคารห้องน้ำ หลังที่ 2'),
            'registered_structure_count', 8
        ) || jsonb_build_object(
            'surveyed_structure_count', 8,
            'surveyed_structures', jsonb_build_array('อาคารโกดังเก็บสินค้าและงานเฟอร์นิเจอร์ชั้นเดียว หลังที่ 1', 'อาคารโกดังเก็บสินค้าและงานเฟอร์นิเจอร์ชั้นเดียว หลังที่ 2', 'บ้านพักคนงานชั้นเดียว', 'อาคารเก็บของชั้นเดียว หลังที่ 1', 'อาคารเก็บของชั้นเดียว หลังที่ 2', 'อาคารห้องน้ำ หลังที่ 1', 'อาคารห้องน้ำ หลังที่ 2', 'อาคารพักอาศัย/โรงจอดรถชั้นเดียว'),
            'residence_and_garage_crosses_public_irrigation_channel', true,
            'building_registration_and_encroachment_review_required', true,
            'property_has_current_user', true,
            'occupancy_information_dated_on', '2026-06-10',
            'sold_as_is', true,
            'buyer_responsible_for_obtaining_possession', true,
            'usable_area_not_published', true,
            'power_specification_not_published', true,
            'factory_or_warehouse_licence_not_published', true,
            'fire_safety_system_not_published', true,
            'floor_load_not_published', true,
            'truck_access_not_published', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'computed_price_per_square_wah', 8558.37,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-09',
            'source_gallery_photo_date_displayed', '2025-12-26',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '18.691715,98.933996',
            'administrator_coordinate_distance_from_source_m_approx', 1.14
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for BL0125. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนเชียงใหม่-ฮอด (ทล.108)', 'Chiang Mai-Hot Highway 108', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'การไฟฟ้าส่วนภูมิภาคอำเภอหางดง', 'Provincial Electricity Authority Hang Dong Office', 'government', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'วัดสันทราย', 'Wat San Sai', 'landmark', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'ที่ว่าการอำเภอหางดง', 'Hang Dong District Office', 'government', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'ตลาดน้ำโท้ง', 'Nam Thong Market', 'shopping', NULL, NULL, NULL, 50, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '19,941,000 บาท — โปรดตรวจสอบราคาล่าสุดและโปรโมชั่นกับ SAM', 'THB 19,941,000 — confirm the latest price and promotions with SAM', 'unspecified', 19941000, 'THB', 20),
        (property_listing_id, 'occupancy_and_possession', 'ผู้ใช้ประโยชน์และการเข้าครอบครอง', 'Current user and possession', 'มีผู้ใช้ประโยชน์ในทรัพย์ ผู้ซื้อรับผิดชอบการเจรจาหรือดำเนินการทางกฎหมายและค่าใช้จ่ายเพื่อเข้าครอบครองเอง', 'The property has a current user; the buyer is responsible for negotiations or legal action and the costs of obtaining possession', 'buyer', NULL, '', 30),
        (property_listing_id, 'access_right_review', 'สิทธิใช้ทางเข้าออก', 'Access-right review', 'ถนนหน้าทรัพย์เป็นทางภายในโครงการที่มีการใช้มานานกว่า 10 ปี แต่ผู้ซื้อต้องตรวจกรรมสิทธิ์ถนน ภาระจำยอม และสิทธิผ่านทางก่อนเสนอซื้อ', 'The frontage road is an internal project road reportedly used for more than ten years, but buyers must verify road ownership, servitude and legal access before offering', 'buyer', NULL, '', 40),
        (property_listing_id, 'irrigation_channel_and_structure', 'อาคารคร่อมลำเหมือง', 'Structure crossing irrigation channel', 'SAM ระบุว่าอาคารพักอาศัย/โรงจอดรถปลูกสร้างคร่อมลำเหมืองสาธารณประโยชน์ ต้องตรวจแนวเขต การรุกล้ำ และการอนุญาตกับหน่วยงาน', 'SAM states that a residence/garage crosses a public irrigation channel; verify boundaries, encroachment and approvals with the authorities', 'buyer', NULL, '', 50),
        (property_listing_id, 'registered_structures', 'รายการสิ่งปลูกสร้าง', 'Registered structures', 'ตรวจรายการสิ่งปลูกสร้างตามโฉนดทั้ง 6 ฉบับให้ตรงกับผลสำรวจและสภาพจริงก่อนเสนอซื้อ', 'Reconcile registered structures on all six title deeds with the survey and actual conditions before offering', 'buyer', 6, 'documents', 60),
        (property_listing_id, 'sold_as_is', 'สภาพการขาย', 'Sale condition', 'ขายตามสภาพที่เป็นอยู่ ผู้ซื้อต้องตรวจทรัพย์ เอกสาร การครอบครอง ภาระผูกพัน ใบอนุญาต และค่าใช้จ่ายทั้งหมดเอง', 'Sold as is; buyers must independently inspect the property, documents, possession, encumbrances, licences and all expenses', 'buyer', NULL, '', 70)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'โรงงานและโกดังพรรณทิวาวิลล่า', 'ภาพหน้าทรัพย์โรงงานและโกดัง SAM รหัส BL0125 ในพรรณทิวาวิลล่า หางดง เชียงใหม่', 'https://npa.sam.or.th/site/images/npa/23063/20260305134048_BL0125P5_69.jpg', '/listing-media/sam/bl0125/01.webp', 'image/webp', 14128, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวกำแพงและทางเข้าทรัพย์', 'ภาพแนวกำแพงด้านหน้าและทางเข้าบริเวณโรงงานโกดัง BL0125', 'https://npa.sam.or.th/site/images/npa/23063/BL0125P2_69.jpg', '/listing-media/sam/bl0125/02.webp', 'image/webp', 16328, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวอาคารโกดังด้านข้าง', 'ภาพอาคารโกดังและแนวรั้วด้านข้างติดซอยหมู่บ้านพรรณทิวาวิลล่า', 'https://npa.sam.or.th/site/images/npa/23063/BL0125P3_69.jpg', '/listing-media/sam/bl0125/03.webp', 'image/webp', 17998, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ขอบเขตทรัพย์ริมถนน', 'ภาพขอบเขตโรงงานและโกดังริมถนนภายในโครงการ', 'https://npa.sam.or.th/site/images/npa/23063/BL0125P4_69.jpg', '/listing-media/sam/bl0125/04.webp', 'image/webp', 15970, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ลานภายในและอาคารโกดัง', 'ภาพลานภายในแปลงพร้อมอาคารโกดังหลายหลัง', 'https://npa.sam.or.th/site/images/npa/23063/BL0125P6_69.jpg', '/listing-media/sam/bl0125/05.webp', 'image/webp', 18230, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'อาคารใช้งานภายในทรัพย์', 'ภาพอาคารและพื้นที่ใช้งานภายในโรงงานโกดังพรรณทิวาวิลล่า', 'https://npa.sam.or.th/site/images/npa/23063/BL0125P7_69.jpg', '/listing-media/sam/bl0125/06.webp', 'image/webp', 20654, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวกำแพงและโกดังด้านใน', 'ภาพแนวกำแพงและอาคารโกดังบริเวณด้านในของทรัพย์', 'https://npa.sam.or.th/site/images/npa/23063/BL0125P8_69.jpg', '/listing-media/sam/bl0125/07.webp', 'image/webp', 20850, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ส่วนโล่งหลังคาคลุม', 'ภาพอาคารส่วนโล่งหลังคาคลุมภายในทรัพย์ SAM BL0125', 'https://npa.sam.or.th/site/images/npa/23063/BL0125P9_69.jpg', '/listing-media/sam/bl0125/08.webp', 'image/webp', 19050, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'อาคารเก็บของภายใน', 'ภาพอาคารเก็บของและพื้นที่โดยรอบภายในแปลง', 'https://npa.sam.or.th/site/images/npa/23063/BL0125P10_69.jpg', '/listing-media/sam/bl0125/09.webp', 'image/webp', 20428, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'อาคารโกดังและลานด้านข้าง', 'ภาพอาคารโกดังและลานด้านข้างตามสภาพต้นทาง SAM', 'https://npa.sam.or.th/site/images/npa/23063/BL0125P11_69.jpg', '/listing-media/sam/bl0125/10.webp', 'image/webp', 25988, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'อาคารชั้นเดียวภายในทรัพย์', 'ภาพอาคารชั้นเดียวและพื้นที่ใช้งานภายในทรัพย์ BL0125', 'https://npa.sam.or.th/site/images/npa/23063/BL0125P12_69.jpg', '/listing-media/sam/bl0125/11.webp', 'image/webp', 18480, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้าหมู่บ้านพรรณทิวาวิลล่า', 'ภาพเส้นทางจากถนนสายแยก ทล.108-บ้านน้ำโท้งเข้าสู่หมู่บ้านพรรณทิวาวิลล่า', 'https://npa.sam.or.th/site/images/npa/23063/BL0125P1_69.jpg', '/listing-media/sam/bl0125/12.webp', 'image/webp', 18508, 450, 450, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังตำแหน่งทรัพย์ในโครงการ', 'ผังต้นทางแสดงตำแหน่งทรัพย์และแนวทางเข้าภายในพรรณทิวาวิลล่า', 'https://npa.sam.or.th/site/images/npa/23063/BL0125C3_69.jpg', '/listing-media/sam/bl0125/13.webp', 'image/webp', 18558, 450, 450, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังที่ดิน 6 โฉนด', 'ผังต้นทางแสดงรูปแปลงและหมายเลขที่ดินของทรัพย์ 6 โฉนด', 'https://npa.sam.or.th/site/images/npa/23063/20260305134048_BL0125C2_69.jpg', '/listing-media/sam/bl0125/14.webp', 'image/webp', 21208, 450, 450, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังสิ่งปลูกสร้างและลำเหมือง', 'ผังต้นทางแสดงอาคารโกดัง บ้านพัก อาคารเก็บของ ห้องน้ำ และแนวลำเหมืองในแปลง', 'https://npa.sam.or.th/site/images/npa/23063/20260305134048_BL0125C1_69.jpg', '/listing-media/sam/bl0125/15.webp', 'image/webp', 24536, 450, 450, 150, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปทรัพย์', 'แผนที่ต้นทางแสดงเส้นทางจากถนนเชียงใหม่-ฮอดไปโรงงานโกดัง SAM BL0125 ในหางดง', 'https://npa.sam.or.th/site/images/npa/23063/20260305134048_BL0125M_69(3A1552).jpg', '/listing-media/sam/bl0125/16.webp', 'image/webp', 44768, 785, 600, 160, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=23063&keyref=6004080',
        'BL0125',
        '2026-09-09 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 19,941,000 for a factory/warehouse property in Phantiva Villa, Ban Waen, Hang Dong, Chiang Mai. Six title deeds numbered 15730, 19139, 43989, 45794, 45795 and 45796 cover 5 rai 3 ngan 30 sq.wah / 2,330 sq.wah / 9,320 sq.m. The polygonal plot has approximately 112.5 metres of western road frontage and a maximum depth of approximately 303.5 metres. The internal concrete project road is approximately four metres wide within an approximately five-metre right of way. SAM says the road was reserved for access to subdivided plots and has been openly used without obstruction for more than ten years, but legal access requires buyer verification. The registered schedule identifies no structures on four deeds, three storage buildings on deed 43989 and five structures on deed 19139. The condition survey identifies eight structures, including warehouses, worker accommodation, storage buildings, two toilet buildings and a residence/garage crossing a public irrigation channel. SAM states that the property has a current user and that the buyer bears the responsibility and costs of obtaining possession. Detailed source information is dated 10 June 2026, and property photos display 26 December 2025. The source identifies yellow planning zoning and a residential area. Usable area, power supply, factory or warehouse licences, fire-safety systems, floor loading and truck access are not published. Administrator coordinates are approximately 1.14 metres from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all 16 unique source property, access, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Factory and Warehouses in Phantiva Villa, Hang Dong, THB 19.941M',
        E'A factory and warehouse property on six title deeds in Phantiva Villa, Ban Waen, Hang Dong, Chiang Mai. The combined land area is 5 rai 3 ngan 30 sq.wah, or 2,330 sq.wah (9,320 sq.m.), under title deeds 15730, 19139, 43989, 45794, 45795 and 45796. SAM shows yellow planning zoning and describes the surrounding area as residential.

The polygonal plot has approximately 112.5 metres of western road frontage and a maximum depth of approximately 303.5 metres. The frontage is on a Phantiva Villa internal concrete road approximately four metres wide within an approximately five-metre right of way. SAM says this internal road was separated for access to subdivided plots and has been openly used without obstruction for more than ten years. This does not itself confirm a legal access right. Buyers must verify road ownership, registered servitude, eligible users, maintenance costs and practical access before offering.

SAM''s registered acquisition records identify no structures on deeds 15730, 45794, 45795 and 45796. Deed 43989 lists two unnumbered storage buildings and one unnumbered warehouse. Deed 19139 lists an unnumbered one-storey masonry residence, one-storey building no. 111/1, warehouse no. 111 and two toilet buildings.

The SAM condition survey identifies two one-storey warehouse/furniture-work buildings, one worker residence, two storage buildings, two toilet buildings and one one-storey residence/garage. SAM states that the residence/garage crosses a public irrigation channel. Buyers must reconcile building registrations with actual conditions and verify boundaries, the irrigation channel, potential encroachment and all required approvals with SAM, the Land Office and relevant authorities.

Important possession caveat: SAM states that the property has a current user and is sold as is. The buyer may need to negotiate or take legal action to obtain possession at the buyer''s own cost. SAM says possession cannot be used to cancel an offer or sale agreement or as a basis for claims against SAM. The detailed source information is dated 10 June 2026, so current conditions must be confirmed directly.

SAM''s directions use the Highway 108-Ban Nam Thong branch road from the Chiang Mai-Hot Highway 108, passing Wat Kamphaeng Ngam and the Provincial Electricity Authority Hang Dong Office. Around kilometre 1+500, turn left into Phantiva Villa and continue about 270 metres; the property is on the right. Nearby places listed by SAM include the PEA Hang Dong Office, Wat San Sai and Hang Dong District Office.

The SAM page lists the property for direct purchase at an announced price of THB 19,941,000. It is not an auction. Contact SAM directly to confirm availability, offer procedures, current price, promotions, costs, current user, possession, access rights and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: BL0125. MapxProp does not collect deposits or represent SAM in the transaction.

Source property photos display 26 December 2025, and conditions may have changed. The source does not publish usable area, power specifications, factory or warehouse licences, building height, fire-safety systems, floor loading or truck access. Buyers should inspect the structures, roof, power and utilities, drainage, flooding, soil, boundaries, encumbrances, planning rules, licences, possession, costs and every current term before deciding.',
        'Factory and warehouses in Phantiva Villa',
        'Access from Chiang Mai-Hot Highway 108 via the Highway 108-Ban Nam Thong branch road',
        'Phantiva Villa internal road',
        'Ban Waen',
        'Hang Dong',
        'Chiang Mai',
        'SAM Factory and Warehouses in Hang Dong, THB 19.941M',
        'Official SAM NPA asset BL0125: factory and warehouses on six title deeds totalling 9,320 sq.m. in Phantiva Villa, Hang Dong. Direct-sale price THB 19.941M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset BL0125 factory warehouse storage Phantiva Villa Ban Waen Hang Dong Chiang Mai Highway 108 5 rai 3 ngan 30 sq.wah 2330 sq.wah 9320 sq.m. title deeds 15730 19139 43989 45794 45795 45796 THB 19941000 current user possession access road irrigation channel')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=23063&keyref=6004080'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=23063&keyref=6004080',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for BL0125. Specifications, title deeds, structures, images, rounded coordinates, announced price, direct-purchase status, possession caveat, road measurements, access-right caveat and irrigation-channel issue come from that record.',
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
        '3d3dd067-4357-46c2-accf-c66d24c49dc5',
        jsonb_build_object(
            'reference_code', 'BL0125',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'title_document_count', 6,
            'registered_structure_count', 8,
            'surveyed_structure_count', 8,
            'current_user_and_possession_review_required', true,
            'access_right_review_required', true,
            'irrigation_channel_review_required', true,
            'factory_licence_review_required', true,
            'source_image_count', 16
        )
    );
END $$;

COMMIT;
