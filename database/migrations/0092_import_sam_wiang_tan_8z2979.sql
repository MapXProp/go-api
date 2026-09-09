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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing 8Z2979';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing 8Z2979';
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
        'a4a421d5-f6c7-459a-8824-63226ed73d51',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'factory',
        'business',
        'sale',
        'whole_property',
        'ขายตรง SAM โรงงานพร้อมที่ดิน 14 แปลง ติด ทล.11 ห้างฉัตร ลำปาง 70-0-69 ไร่ ราคา 60.949 ล้านบาท',
        E'โรงงานพร้อมที่ดิน 14 แปลง เนื้อที่รวม 70 ไร่ 69 ตร.ว. หรือ 28,069 ตร.ว. (112,276 ตร.ม.) ติดถนนสายลำปาง-เชียงใหม่ ทางหลวงหมายเลข 11 ตำบลเวียงตาล อำเภอห้างฉัตร จังหวัดลำปาง เอกสารสิทธิ์เป็นโฉนดที่ดิน 14 ฉบับ เลขที่ 18115, 18244, 21558, 21559, 22552, 22595, 23998, 33488, 33489, 33491, 33492, 33493, 33494 และ 33495

ที่ดินแต่ละแปลงมีเนื้อที่ตั้งแต่ 2 งาน 12 ตร.ว. ถึง 14 ไร่ 2 งาน 83 ตร.ว. ด้านทิศเหนือติดทางหลวงหมายเลข 11 หน้ากว้างประมาณ 208 เมตร ลึกสูงสุดประมาณ 620 เมตร แปลงทั้งหมดไม่ได้ติดต่อกัน เนื่องจากมีลำเหมืองสาธารณประโยชน์ซึ่ง SAM ระบุว่าไม่มีสภาพแล้วคั่นอยู่ ผู้ซื้อต้องตรวจแนวเขต สถานะลำเหมือง และสิทธิผ่านทางกับหน่วยงานที่เกี่ยวข้อง

ที่ดินบางส่วนมีสภาพเป็นบ่อน้ำ ขนาดประมาณ 60 x 60 เมตร คิดเป็นเนื้อที่ประมาณ 2 ไร่ 1 งาน SAM ระบุว่ารายการสิ่งปลูกสร้างที่รับโอนกรรมสิทธิ์ทางทะเบียนคือโรงงานอุตสาหกรรม ส่วนสิ่งปลูกสร้างอื่นที่เห็นในทรัพย์ยังไม่พบหลักฐานยืนยันว่าเป็นส่วนควบของที่ดินหรือไม่ การโอนให้ผู้ซื้อจึงทำได้ตามรายการที่ SAM จดทะเบียนรับโอนเท่านั้น ต้องตรวจทะเบียนสิ่งปลูกสร้าง สภาพอาคาร และสิทธิในอาคารทุกหลังกับ SAM และสำนักงานที่ดินก่อนเสนอซื้อ

ถนนสายลำปาง-เชียงใหม่ (ทล.11) เป็นทางสาธารณประโยชน์ ผิวจราจรลาดยางกว้างประมาณ 20 เมตร เขตทางกว้างประมาณ 50 เมตร ทรัพย์อยู่บริเวณหลักกิโลเมตร 478+500 ฝั่งจากลำปางมุ่งหน้าลำพูน ตรงข้ามกาดต้นเงิน หน้า SAM แสดงเขตพื้นที่เป็นสีชมพู การจัดเป็นโรงงานใน MapxProp อ้างอิงประเภททรัพย์และรายการสิ่งปลูกสร้างของ SAM ไม่ใช่การรับรองว่าใบอนุญาตโรงงานหรือการใช้ประโยชน์อุตสาหกรรมยังใช้ได้ ผู้ซื้อต้องตรวจผังเมือง ข้อกำหนดสิ่งแวดล้อม ใบอนุญาต และกิจการที่ต้องการกับหน่วยงานโดยตรง

ข้อควรตรวจสอบสำคัญ: SAM ระบุว่าโฉนดทั้งหมดออกตามมาตรา 58 ตรี แห่งประมวลกฎหมายที่ดิน โดยใช้เนื้อที่ตาม น.ส.3 ก. หากมีการรังวัดสอบเขต เนื้อที่อาจเพิ่มหรือลดจากที่ระบุไว้อย่างมีนัยสำคัญ ผู้ซื้อควรรังวัดหรือสอบเขตและตรวจเอกสารสิทธิ์ทั้ง 14 ฉบับก่อนตัดสินใจ

หน้า SAM ระบุสถานะ “ซื้อตรง” และราคาประกาศขาย 60,949,000 บาท ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน ค่าใช้จ่าย สถานะการครอบครอง และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ 8Z2979 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM

ภาพทรัพย์ส่วนใหญ่ในหน้าต้นทางแสดงวันที่ 20 ตุลาคม 2564 สภาพจริงอาจเปลี่ยนแปลง ผู้ซื้อควรนัดตรวจทรัพย์ ตรวจโครงสร้างอาคาร ระบบไฟฟ้าและสาธารณูปโภค กำลังไฟ ทางเข้ารถบรรทุก บ่อน้ำ การระบายน้ำ น้ำท่วม ดิน ภาระผูกพัน การครอบครอง ใบอนุญาตโรงงานและสิ่งแวดล้อม ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        60949000,
        false,
        112276,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'โรงงานพร้อมที่ดิน 14 แปลง',
        'ติดถนนสายลำปาง-เชียงใหม่ (ทล.11) บริเวณ กม.478+500 ตรงข้ามกาดต้นเงิน',
        'ถนนสายลำปาง-เชียงใหม่ (ทล.11)',
        NULL,
        18.32031130,
        99.33453434,
        'ลำปาง',
        'ห้างฉัตร',
        'เวียงตาล',
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
        'sam-direct-sale-factory-highway-11-wiang-tan-lampang-8z2979'
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
        property_listing_id, 'sale', 60949000, 'total', 'THB', false
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
            'title_document_type', 'chanote',
            'title_deed_numbers', jsonb_build_array('18115', '18244', '21558', '21559', '22552', '22595', '23998', '33488', '33489', '33491', '33492', '33493', '33494', '33495'),
            'title_document_count', 14,
            'land_area_rai', 70,
            'land_area_ngan', 0,
            'land_area_square_wah_remainder', 69,
            'land_area_square_wah', 28069,
            'land_area_sqm', 112276,
            'plot_count', 14,
            'plots_all_contiguous', false,
            'minimum_plot_area_rai', 0,
            'minimum_plot_area_ngan', 2,
            'minimum_plot_area_square_wah', 12,
            'maximum_plot_area_rai', 14,
            'maximum_plot_area_ngan', 2,
            'maximum_plot_area_square_wah', 83,
            'north_highway_frontage_m', 208,
            'maximum_depth_m', 620,
            'front_road_name', 'ถนนสายลำปาง-เชียงใหม่ (ทล.11)',
            'front_road_surface', 'asphalt',
            'front_road_width_m', 20,
            'front_right_of_way_width_m', 50,
            'highway_kilometre_marker', '478+500',
            'opposite_landmark', 'กาดต้นเงิน'
        ) || jsonb_build_object(
            'public_irrigation_channel_separates_plots', true,
            'public_irrigation_channel_reported_without_visible_condition', true,
            'pond_present', true,
            'pond_approx_width_m', 60,
            'pond_approx_length_m', 60,
            'pond_approx_area_rai', 2,
            'pond_approx_area_ngan', 1,
            'pond_approx_area_square_wah', 0,
            'registered_transferred_structure_count', 1,
            'registered_transferred_structure', 'โรงงานอุตสาหกรรม',
            'other_structures_present', true,
            'other_structures_title_status_uncertain', true,
            'transfer_limited_to_sam_registered_items', true,
            'zoning_color_th', 'สีชมพู ตามหน้า SAM',
            'zoning_confirmation_required', true,
            'factory_use_and_licence_not_confirmed', true,
            'title_deeds_issued_under_land_code_section_58_ter', true,
            'title_area_based_on_nor_sor_3_kor', true,
            'material_area_change_after_resurvey_possible', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'computed_price_per_square_wah', 2171.40,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-09',
            'source_gallery_photo_date_displayed', '2021-10-20',
            'duplicate_source_image_omitted', true,
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '18.320525,99.334227',
            'administrator_coordinate_distance_from_source_m_approx', 40.21
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z2979. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนสายลำปาง-เชียงใหม่ (ทล.11)', 'Lampang-Chiang Mai Highway 11', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'กาดต้นเงิน', 'Kad Ton Ngoen Market', 'shopping', NULL, NULL, NULL, 20, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '60,949,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 60,949,000 — confirm the latest price with SAM', 'unspecified', 60949000, 'THB', 20),
        (property_listing_id, 'title_documents', 'เอกสารสิทธิ์', 'Title documents', 'โฉนดที่ดิน 14 ฉบับ ซึ่ง SAM ระบุว่าออกตามมาตรา 58 ตรี และใช้เนื้อที่ตาม น.ส.3 ก.', 'Fourteen title deeds that SAM says were issued under Section 58 ter using areas from Nor Sor 3 Kor documents', 'unspecified', 14, 'documents', 30),
        (property_listing_id, 'plot_separation', 'การติดต่อกันของแปลง', 'Plot continuity', 'แปลงไม่ได้ติดต่อกันทั้งหมด มีลำเหมืองสาธารณประโยชน์ซึ่งระบุว่าไม่มีสภาพแล้วคั่น ต้องตรวจแนวเขตและสิทธิผ่านทาง', 'The plots are not all contiguous and are separated by a public irrigation channel reported as no longer physically visible; verify boundaries and access rights', 'buyer', NULL, '', 40),
        (property_listing_id, 'pond_area', 'พื้นที่บ่อน้ำ', 'Pond area', 'ที่ดินบางส่วนเป็นบ่อน้ำประมาณ 60 x 60 เมตร หรือประมาณ 2 ไร่ 1 งาน', 'Part of the land is a pond measuring about 60 by 60 meters, approximately 2 rai 1 ngan', 'buyer', 3600, 'sqm', 50),
        (property_listing_id, 'registered_structures', 'สิ่งปลูกสร้างที่รับโอน', 'Registered structures', 'SAM ระบุรายการรับโอนเป็นโรงงานอุตสาหกรรม ส่วนสิ่งปลูกสร้างอื่นยังไม่ยืนยันสถานะ การโอนจำกัดตามรายการที่ SAM จดทะเบียนรับโอน', 'SAM lists an industrial factory as the registered transferred structure; other structures have unconfirmed title status and transfer is limited to SAM-registered items', 'buyer', 1, 'items', 60),
        (property_listing_id, 'survey_area_risk', 'ความเสี่ยงเนื้อที่หลังรังวัด', 'Surveyed-area risk', 'SAM ระบุว่าเนื้อที่อาจเพิ่มหรือลดอย่างมีนัยสำคัญเมื่อรังวัดสอบเขต ผู้ซื้อต้องตรวจสอบก่อนเสนอซื้อ', 'SAM states that a boundary survey may materially increase or decrease the stated area; verify before offering', 'buyer', NULL, '', 70),
        (property_listing_id, 'zoning_and_factory_licence', 'ผังเมืองและใบอนุญาตโรงงาน', 'Planning and factory licence', 'หน้า SAM แสดงเขตสีชมพู ต้องตรวจผังเมือง ใบอนุญาตโรงงาน สิ่งแวดล้อม และกิจการที่ต้องการกับหน่วยงานโดยตรง', 'SAM shows a pink zone; verify planning, factory licensing, environmental requirements and the intended activity directly with authorities', 'buyer', NULL, '', 80),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนด แนวเขต ลำเหมือง บ่อน้ำ สิ่งปลูกสร้าง สภาพอาคาร การครอบครอง ทางเข้า-ออก ไฟฟ้า สาธารณูปโภค น้ำท่วม ดิน ภาระผูกพัน ใบอนุญาต ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Verify title deeds, boundaries, irrigation channel, pond, structures, building condition, possession, access, power, utilities, flooding, soil, encumbrances, permits, costs and current terms', 'buyer', NULL, '', 90)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'โรงงานและที่ดินติดทางหลวงหมายเลข 11', 'ภาพหน้าทรัพย์โรงงาน SAM รหัส 8Z2979 ติดถนนสายลำปาง-เชียงใหม่ ห้างฉัตร ลำปาง', 'https://npa.sam.or.th/site/images/npa/10200/20260105111750_8Z2979P1_62.JPG', '/listing-media/sam/8z2979/01.webp', 'image/webp', 36532, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวที่ดินและทางภายใน', 'ภาพแนวที่ดินและทางภายในบริเวณทรัพย์ SAM 8Z2979', 'https://npa.sam.or.th/site/images/npa/10200/8Z2979P1_65.jpg', '/listing-media/sam/8z2979/02.webp', 'image/webp', 35242, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวเขตทรัพย์ด้านทางเข้า', 'ภาพแนวเขตและทางเข้าบริเวณโรงงานพร้อมที่ดิน 14 แปลง', 'https://npa.sam.or.th/site/images/npa/10200/8Z2979P2_65.jpg', '/listing-media/sam/8z2979/03.webp', 'image/webp', 38914, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่โล่งหน้าอาคาร', 'ภาพพื้นที่โล่งและอาคารภายในทรัพย์โรงงาน ห้างฉัตร ลำปาง', 'https://npa.sam.or.th/site/images/npa/10200/8Z2979P3_65.jpg', '/listing-media/sam/8z2979/04.webp', 'image/webp', 29048, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวถนนและขอบเขตที่ดิน', 'ภาพแนวถนนและขอบเขตส่วนหนึ่งของทรัพย์ SAM รหัส 8Z2979', 'https://npa.sam.or.th/site/images/npa/10200/8Z2979P4_65.jpg', '/listing-media/sam/8z2979/05.webp', 'image/webp', 31562, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ภายในทรัพย์', 'ภาพสภาพพื้นที่ภายในโรงงานและที่ดิน 70 ไร่ 69 ตารางวา', 'https://npa.sam.or.th/site/images/npa/10200/8Z2979P5_65.jpg', '/listing-media/sam/8z2979/06.webp', 'image/webp', 33910, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่และอาคารประกอบ', 'ภาพพื้นที่และอาคารประกอบภายในทรัพย์โรงงานของ SAM', 'https://npa.sam.or.th/site/images/npa/10200/8Z2979P6_65.jpg', '/listing-media/sam/8z2979/07.webp', 'image/webp', 40828, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บริเวณภายในโรงงาน', 'ภาพบริเวณภายในและสภาพสิ่งปลูกสร้างของทรัพย์ 8Z2979', 'https://npa.sam.or.th/site/images/npa/10200/8Z2979P7_65.jpg', '/listing-media/sam/8z2979/08.webp', 'image/webp', 48520, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ลานและสิ่งปลูกสร้าง', 'ภาพลานและสิ่งปลูกสร้างภายในทรัพย์โรงงาน เวียงตาล', 'https://npa.sam.or.th/site/images/npa/10200/8Z2979P8_65.jpg', '/listing-media/sam/8z2979/09.webp', 'image/webp', 52770, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่รอบอาคาร', 'ภาพพื้นที่รอบอาคารภายในทรัพย์ SAM ห้างฉัตร ลำปาง', 'https://npa.sam.or.th/site/images/npa/10200/8Z2979P9_65.jpg', '/listing-media/sam/8z2979/10.webp', 'image/webp', 43024, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่โล่งภายในแปลง', 'ภาพพื้นที่โล่งภายในที่ดิน 14 แปลงของทรัพย์ 8Z2979', 'https://npa.sam.or.th/site/images/npa/10200/8Z2979P10_65.jpg', '/listing-media/sam/8z2979/11.webp', 'image/webp', 57474, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บริเวณที่ดินด้านใน', 'ภาพบริเวณที่ดินด้านในของโรงงานพร้อมที่ดินติด ทล.11', 'https://npa.sam.or.th/site/images/npa/10200/8Z2979P11_65.jpg', '/listing-media/sam/8z2979/12.webp', 'image/webp', 34772, 450, 450, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวพื้นที่ภายใน', 'ภาพแนวพื้นที่ภายในทรัพย์โรงงานและโกดัง SAM 8Z2979', 'https://npa.sam.or.th/site/images/npa/10200/8Z2979P12_65.jpg', '/listing-media/sam/8z2979/13.webp', 'image/webp', 38488, 450, 450, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ลานกว้างและโครงสร้าง', 'ภาพลานกว้างและโครงสร้างภายในทรัพย์โรงงาน เวียงตาล', 'https://npa.sam.or.th/site/images/npa/10200/8Z2979P13_65.jpg', '/listing-media/sam/8z2979/14.webp', 'image/webp', 42948, 450, 450, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ด้านข้างอาคาร', 'ภาพพื้นที่ด้านข้างอาคารของทรัพย์ SAM รหัส 8Z2979', 'https://npa.sam.or.th/site/images/npa/10200/8Z2979P14_65.jpg', '/listing-media/sam/8z2979/15.webp', 'image/webp', 41550, 450, 450, 150, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'อาคารภายในทรัพย์', 'ภาพอาคารและสภาพแวดล้อมภายในโรงงานพร้อมที่ดิน 14 แปลง', 'https://npa.sam.or.th/site/images/npa/10200/8Z2979P15_65.jpg', '/listing-media/sam/8z2979/16.webp', 'image/webp', 37306, 450, 450, 160, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวอาคารโรงงาน', 'ภาพแนวอาคารโรงงานตามสภาพในหน้าต้นทาง SAM', 'https://npa.sam.or.th/site/images/npa/10200/8Z2979P16_65.jpg', '/listing-media/sam/8z2979/17.webp', 'image/webp', 36206, 450, 450, 170, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ภายในอาคารโรงงาน', 'ภาพภายในอาคารโรงงานของทรัพย์รหัส 8Z2979', 'https://npa.sam.or.th/site/images/npa/10200/8Z2979P17_65.jpg', '/listing-media/sam/8z2979/18.webp', 'image/webp', 36654, 450, 450, 180, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ใช้งานภายในอาคาร', 'ภาพพื้นที่ใช้งานภายในอาคารโครงสร้างหลังคาเหล็ก', 'https://npa.sam.or.th/site/images/npa/10200/8Z2979P18_65.jpg', '/listing-media/sam/8z2979/19.webp', 'image/webp', 35860, 450, 450, 190, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงภายในโรงงาน', 'ภาพโถงและเสาโครงสร้างภายในอาคารโรงงาน', 'https://npa.sam.or.th/site/images/npa/10200/8Z2979P19_65.jpg', '/listing-media/sam/8z2979/20.webp', 'image/webp', 36736, 450, 450, 200, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'สภาพภายในอาคาร', 'ภาพสภาพพื้น ผนัง และหลังคาภายในอาคารของทรัพย์ SAM', 'https://npa.sam.or.th/site/images/npa/10200/8Z2979P20_65.jpg', '/listing-media/sam/8z2979/21.webp', 'image/webp', 38768, 450, 450, 210, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ใต้หลังคาคลุม', 'ภาพพื้นที่ใต้หลังคาคลุมภายในทรัพย์โรงงาน 8Z2979', 'https://npa.sam.or.th/site/images/npa/10200/8Z2979P21_65.jpg', '/listing-media/sam/8z2979/22.webp', 'image/webp', 34858, 450, 450, 220, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ส่วนโล่งหลังคาคลุม', 'ภาพส่วนโล่งหลังคาคลุมและพื้นคอนกรีตภายในทรัพย์', 'https://npa.sam.or.th/site/images/npa/10200/8Z2979P22_65.jpg', '/listing-media/sam/8z2979/23.webp', 'image/webp', 39390, 450, 450, 230, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังที่ดิน 14 แปลงและสิ่งปลูกสร้าง', 'ผังต้นทางแสดงที่ดิน 14 แปลง แนวทางหลวง ลำเหมือง บ่อน้ำ และตำแหน่งสิ่งปลูกสร้าง', 'https://npa.sam.or.th/site/images/npa/10200/20220120130612_8Z2979C1n1_64.jpg', '/listing-media/sam/8z2979/24.webp', 'image/webp', 33456, 450, 450, 240, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปทรัพย์', 'แผนที่ต้นทางแสดงตำแหน่งทรัพย์ 8Z2979 บนทางหลวงหมายเลข 11 บริเวณกาดต้นเงิน', 'https://npa.sam.or.th/site/images/npa/10200/20170915085759_8Z2979M1_60.jpg', '/listing-media/sam/8z2979/25.webp', 'image/webp', 23580, 785, 600, 250, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=10200&keyref=6004080',
        '8Z2979',
        '2026-09-09 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 60,949,000 for an industrial factory on fourteen title-deed plots totalling 70 rai 69 sq.wah / 28,069 sq.wah / 112,276 sq.m. The northern boundary fronts Highway 11 for approximately 208 meters and the maximum depth is approximately 620 meters. The plots are not all contiguous because a public irrigation channel, reported as having no current physical condition, separates them. Part of the property is a pond measuring approximately 60 by 60 meters or about 2 rai 1 ngan. SAM states that the registered transferred structure is an industrial factory and that title status for other structures is unconfirmed; conveyance is limited to items registered to SAM. SAM also states that all title deeds were issued under Section 58 ter using areas from Nor Sor 3 Kor documents and that a boundary survey could materially change the stated area. The source shows a pink planning zone; factory use and licensing are not confirmed. Most source gallery photos display 20 October 2021. Administrator coordinates are approximately 40.21 meters from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all 25 unique source property, plot and navigation images; one exact duplicate source image was omitted and no MapxProp watermark was added.'
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
        'SAM Direct Sale: Factory on 14 Plots Fronting Highway 11, Lampang, THB 60.949M',
        E'An industrial factory on fourteen title-deed plots totalling 70 rai 69 sq.wah, or 28,069 sq.wah (112,276 sq.m.), fronting the Lampang-Chiang Mai Highway 11 in Wiang Tan, Hang Chat, Lampang. The title deeds are 18115, 18244, 21558, 21559, 22552, 22595, 23998, 33488, 33489, 33491, 33492, 33493, 33494 and 33495.

Individual plots range from 2 ngan 12 sq.wah to 14 rai 2 ngan 83 sq.wah. The northern boundary fronts Highway 11 for approximately 208 meters and maximum depth is approximately 620 meters. The plots are not all contiguous because a public irrigation channel, which SAM reports no longer has a visible physical condition, separates them. Buyers must verify boundaries, the channel status and access rights with the relevant authorities.

Part of the land is a pond measuring approximately 60 by 60 meters, or about 2 rai 1 ngan. SAM states that the registered transferred structure is an industrial factory. Other structures visible on the property have unconfirmed status as fixtures, and conveyance is limited to the items registered as transferred to SAM. Buyers should verify every registered structure and current building condition with SAM and the Land Office before offering.

Highway 11 is described as a public asphalt road with an approximately 20-meter carriageway within an approximately 50-meter right of way. The property is around kilometre marker 478+500, opposite Kad Ton Ngoen, on the Lampang-to-Lamphun side. The SAM page shows a pink planning zone. MapxProp classifies this as a factory based on SAM''s asset type and registered structure; this is not confirmation that factory use, a factory licence or environmental approvals remain valid. Confirm all intended activities with the authorities.

Important title caveat: SAM says all fourteen deeds were issued under Section 58 ter of the Land Code using areas from Nor Sor 3 Kor documents. A boundary survey may materially increase or decrease the stated area. Buyers should arrange a survey and verify all fourteen deeds before deciding.

The SAM page lists the property for direct purchase at an announced price of THB 60,949,000. It is not an auction. Contact SAM directly to confirm availability, offer procedures, current price, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: 8Z2979. MapxProp does not collect deposits or represent SAM in the transaction.

Most source gallery photos display 20 October 2021. Conditions may have changed. Buyers should inspect the buildings, power and utilities, truck access, pond, drainage, flooding, soil, encumbrances, possession, factory and environmental permits, costs and every current term before deciding.',
        'Industrial factory on fourteen title-deed plots',
        'Fronting Highway 11 near kilometre marker 478+500, opposite Kad Ton Ngoen',
        'Lampang-Chiang Mai Highway 11',
        'Wiang Tan',
        'Hang Chat',
        'Lampang',
        'SAM Direct-Sale Factory on Highway 11, Lampang, THB 60.949M',
        'Official SAM NPA asset 8Z2979: factory on fourteen plots totalling 112,276 sq.m. with approximately 208 metres of Highway 11 frontage. Direct-sale price THB 60.949M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset 8Z2979 industrial factory warehouse fourteen plots Highway 11 Lampang Chiang Mai Road Wiang Tan Hang Chat Lampang 70 rai 69 sq.wah 28069 sq.wah 112276 sq.m. title deeds 18115 18244 21558 21559 22552 22595 23998 33488 33489 33491 33492 33493 33494 33495 THB 60949000')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=10200&keyref=6004080'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=10200&keyref=6004080',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z2979. Specifications, title-deed numbers, images, rounded coordinates, announced price, direct-purchase status, road measurements, plot-separation caveat, pond, transferred-structure caveat, Section 58 ter note and planning-zone wording come from that record.',
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
        'a4a421d5-f6c7-459a-8824-63226ed73d51',
        jsonb_build_object(
            'reference_code', '8Z2979',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'title_document_count', 14,
            'plot_separation_review_required', true,
            'registered_structure_review_required', true,
            'survey_area_review_required', true,
            'factory_licence_review_required', true,
            'source_image_count', 25,
            'duplicate_source_image_omitted', true
        )
    );
END $$;

COMMIT;
