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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing 1T0085';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing 1T0085';
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
        'dc3fd30b-66a1-44a3-858c-ec82386e229f',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'land',
        'mixed',
        'sale',
        'land_plot',
        'ขายตรง SAM ที่ดิน 9 แปลงติดกัน ถนนตลาดใหม่ เมืองสุราษฎร์ฯ 3-2-15.1 ไร่ ราคา 75.053 ล้านบาท',
        E'ที่ดินเปล่า 9 แปลงติดต่อกัน เนื้อที่รวม 3 ไร่ 2 งาน 15.1 ตร.ว. หรือ 1,415.1 ตร.ว. (5,660.4 ตร.ม.) ติดถนนตลาดใหม่และซอยตลาดใหม่ 19 ตำบลตลาด อำเภอเมืองสุราษฎร์ธานี จังหวัดสุราษฎร์ธานี เอกสารสิทธิ์เป็นโฉนดที่ดิน 9 ฉบับ เลขที่ 646, 1721, 1759, 4625, 4626, 4627, 4628, 10430 และ 10431

แปลงที่ดินมีรูปหลายเหลี่ยม ด้านทิศตะวันตกติดถนนตลาดใหม่ประมาณ 22.5 เมตร ด้านทิศใต้ยาวรวมประมาณ 265.5 เมตร โดยช่วงที่ติดซอยตลาดใหม่ 19 ยาวประมาณ 51.5 เมตร และมีความลึกสูงสุดประมาณ 190 เมตร จึงมีหน้าถนนสองด้านตามข้อมูลของ SAM

ถนนตลาดใหม่เป็นทางสาธารณประโยชน์ ผิวจราจรลาดยางกว้างประมาณ 12 เมตร เขตทางประมาณ 15 เมตร ส่วนซอยตลาดใหม่ 19 เป็นทางสาธารณประโยชน์ ผิวจราจรลาดยางกว้างประมาณ 6 เมตร เขตทางประมาณ 8 เมตร ทรัพย์อยู่ในย่านที่อยู่อาศัยและพาณิชยกรรม ใกล้ศาลหลักเมืองสุราษฎร์ธานี โรงเรียนเทศบาล 1 ตลาดสดเทศบาล และสถานีตำรวจภูธรเมืองสุราษฎร์ธานี

ข้อควรตรวจสอบสำคัญ: หน้า SAM ระบุว่าทรัพย์อยู่ใน “บริเวณที่ 3” ตามเทศบัญญัติเทศบาลนครสุราษฎร์ธานี เรื่องกำหนดบริเวณห้ามก่อสร้าง ดัดแปลง ใช้หรือเปลี่ยนการใช้อาคารบางชนิดหรือบางประเภท พ.ศ. 2552 และมีเทศบัญญัติแก้ไขเพิ่มเติม พ.ศ. 2561 ผู้ซื้อควรนำเลขโฉนด แนวเขต และแบบโครงการที่ต้องการไปตรวจสอบกับเทศบาลนครสุราษฎร์ธานีโดยตรง เพื่อยืนยันข้อกำหนดฉบับปัจจุบัน ประเภทอาคาร การใช้ประโยชน์ ระยะร่น ทางเข้า-ออก และการขออนุญาตก่อนเสนอซื้อ ข้อมูลนี้ไม่ใช่การรับรองว่าสามารถพัฒนาโครงการประเภทใดได้

หน้า SAM ระบุสถานะ “ซื้อตรง” และราคาประกาศขาย 75,053,000 บาท หรือประมาณ 53,037 บาท/ตร.ว. ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน ค่าใช้จ่าย สถานะการครอบครอง และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ 1T0085 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM

หน้าต้นทางไม่ระบุวันที่ของข้อมูลรายละเอียด ระบบสาธารณูปโภค ระดับและการถมดิน ประวัติน้ำท่วม สภาพดิน สถานะการครอบครอง หรือภาระผูกพันอื่น ภาพทรัพย์ต้นทางมีวันที่กำกับ 6 สิงหาคม 2567 ผู้ซื้อควรนัดตรวจทรัพย์ รังวัดหรือสอบเขต ตรวจเอกสารสิทธิ์ แนวถนน กฎหมายผังเมืองและควบคุมอาคาร สาธารณูปโภค การระบายน้ำ น้ำท่วม ดิน ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        75053000,
        false,
        5660.4,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'ที่ดินเปล่า 9 แปลงติดกัน',
        'ติดถนนตลาดใหม่และซอยตลาดใหม่ 19',
        'ถนนตลาดใหม่',
        NULL,
        9.13998065,
        99.32387388,
        'สุราษฎร์ธานี',
        'เมืองสุราษฎร์ธานี',
        'ตลาด',
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
        'sam-direct-sale-nine-plot-land-talat-mai-surat-thani-1t0085'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES
        (property_listing_id, 'residential'),
        (property_listing_id, 'retail'),
        (property_listing_id, 'office')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 75053000, 'total', 'THB', false
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
            'title_document_type', 'chanote',
            'title_deed_numbers', jsonb_build_array('646', '1721', '1759', '4625', '4626', '4627', '4628', '10430', '10431'),
            'title_document_count', 9,
            'land_area_rai', 3,
            'land_area_ngan', 2,
            'land_area_square_wah_remainder', 15.1,
            'land_area_square_wah', 1415.1,
            'land_area_sqm', 5660.4,
            'plot_count', 9,
            'plots_contiguous', true,
            'vacant_land', true,
            'structures_present', false,
            'plot_shape', 'polygon',
            'road_frontage_side_count', 2,
            'west_road_frontage_m', 22.5,
            'south_boundary_total_m', 265.5,
            'soi_talat_mai_19_frontage_m', 51.5,
            'maximum_depth_m', 190,
            'access_type', 'public_roads_two_sides',
            'primary_front_road_name', 'ถนนตลาดใหม่',
            'primary_front_road_surface', 'asphalt',
            'primary_front_road_width_m', 12,
            'primary_front_right_of_way_width_m', 15
        ) || jsonb_build_object(
            'secondary_front_road_name', 'ซอยตลาดใหม่ 19',
            'secondary_front_road_surface', 'asphalt',
            'secondary_front_road_width_m', 6,
            'secondary_front_right_of_way_width_m', 8,
            'zoning_color_th', 'สีชมพู',
            'surrounding_area_use_th', 'ที่อยู่อาศัยและพาณิชยกรรม',
            'sam_reports_municipal_building_control_area', 'บริเวณที่ 3',
            'sam_reports_municipal_bylaw_year_be', 2552,
            'official_amending_bylaw_year_be', 2561,
            'municipal_rule_review_required', true,
            'development_use_not_confirmed', true,
            'utilities_information_not_published', true,
            'land_level_information_not_published', true,
            'land_fill_information_not_published', true,
            'flood_history_not_published', true,
            'soil_condition_not_published', true,
            'occupancy_status_not_published', true,
            'other_encumbrances_not_published', true,
            'source_information_date_not_published', true,
            'source_photo_date_displayed', '2024-08-06',
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'price_per_square_wah', 53037,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-09',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '9.139983,99.323873',
            'administrator_coordinate_distance_from_source_m_approx', 0.28
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 1T0085. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนตลาดใหม่', 'Talat Mai Road', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ศาลหลักเมืองสุราษฎร์ธานี', 'Surat Thani City Pillar Shrine', 'landmark', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'โรงเรียนเทศบาล 1', 'Municipal School 1', 'education', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'ตลาดสดเทศบาลนครสุราษฎร์ธานี', 'Surat Thani Municipal Fresh Market', 'shopping', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'สถานีตำรวจภูธรเมืองสุราษฎร์ธานี', 'Mueang Surat Thani Police Station', 'government', NULL, NULL, NULL, 50, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '75,053,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 75,053,000 — confirm the latest price with SAM', 'unspecified', 75053000, 'THB', 20),
        (property_listing_id, 'price_per_square_wah', 'ราคาเฉลี่ยต่อตารางวา', 'Price per square wah', 'ประมาณ 53,037 บาท/ตร.ว. ตามหน้าต้นทาง', 'Approximately THB 53,037 per sq.wah as shown by the source', 'unspecified', 53037, 'THB/sq_wah', 30),
        (property_listing_id, 'title_documents', 'เอกสารสิทธิ์', 'Title documents', 'โฉนดที่ดิน 9 ฉบับ สำหรับที่ดิน 9 แปลงติดต่อกัน', 'Nine title deeds for nine contiguous land plots', 'unspecified', 9, 'documents', 40),
        (property_listing_id, 'municipal_building_control', 'ข้อกำหนดควบคุมอาคาร', 'Municipal building control', 'SAM ระบุว่าอยู่ในบริเวณที่ 3 ตามเทศบัญญัติ พ.ศ. 2552 และมีฉบับแก้ไข พ.ศ. 2561 ต้องยืนยันข้อกำหนดปัจจุบันและโครงการที่ต้องการกับเทศบาลนครสุราษฎร์ธานี', 'SAM reports Area 3 under the 2009 municipal bylaw; a 2018 amendment exists. Confirm current consolidated rules and the proposed project with Surat Thani City Municipality', 'buyer', NULL, '', 50),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนด แนวเขต หน้าถนน การใช้ประโยชน์อาคาร สาธารณูปโภค น้ำท่วม การระบายน้ำ ดิน การถมดิน ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขล่าสุดก่อนเสนอซื้อ', 'Verify title deeds, boundaries, frontage, permitted building use, utilities, flooding, drainage, soil, fill, encumbrances, costs and latest terms before offering', 'buyer', NULL, '', 60)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ที่ดินติดถนนตลาดใหม่ รหัส 1T0085', 'ที่ดินเปล่า 9 แปลงของ SAM ติดถนนตลาดใหม่ เมืองสุราษฎร์ธานี', 'https://npa.sam.or.th/site/images/npa/4971/20260105111351_1T0085P4_67.jpg', '/listing-media/sam/1t0085/01.webp', 'image/webp', 32440, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวที่ดินด้านใน', 'ภาพแนวยาวภายในที่ดินเปล่า 9 แปลงติดต่อกัน รหัส 1T0085', 'https://npa.sam.or.th/site/images/npa/4971/1T0085P5_67.jpg', '/listing-media/sam/1t0085/02.webp', 'image/webp', 36526, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่โล่งภายในแปลง', 'ภาพมุมกว้างของพื้นที่โล่งภายในแปลงที่ดิน SAM ถนนตลาดใหม่', 'https://npa.sam.or.th/site/images/npa/4971/1T0085P6_67.jpg', '/listing-media/sam/1t0085/03.webp', 'image/webp', 44412, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวขอบเขตที่ดิน', 'ภาพแนวขอบเขตและทางภายในบริเวณที่ดิน 9 แปลงติดต่อกัน', 'https://npa.sam.or.th/site/images/npa/4971/1T0085P7_67.jpg', '/listing-media/sam/1t0085/04.webp', 'image/webp', 38604, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมมองพื้นที่ไปทางวัด', 'ภาพพื้นที่โล่งของทรัพย์ 1T0085 มองเห็นอาคารวัดในบริเวณใกล้เคียง', 'https://npa.sam.or.th/site/images/npa/4971/1T0085P8_67.jpg', '/listing-media/sam/1t0085/05.webp', 'image/webp', 35288, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่กว้างภายในทรัพย์', 'ภาพมุมกว้างของที่ดินเปล่าเนื้อที่รวม 3 ไร่ 2 งาน 15.1 ตารางวา', 'https://npa.sam.or.th/site/images/npa/4971/1T0085P9_67.jpg', '/listing-media/sam/1t0085/06.webp', 'image/webp', 35294, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'สภาพแวดล้อมใจกลางเมือง', 'ภาพทรัพย์และสภาพแวดล้อมย่านที่อยู่อาศัยและพาณิชยกรรมในเมืองสุราษฎร์ธานี', 'https://npa.sam.or.th/site/images/npa/4971/1T0085P10_67.jpg', '/listing-media/sam/1t0085/07.webp', 'image/webp', 34948, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวทรัพย์ติดซอยตลาดใหม่ 19', 'ภาพแนวรั้วและถนนบริเวณซอยตลาดใหม่ 19 ซึ่งติดกับทรัพย์', 'https://npa.sam.or.th/site/images/npa/4971/1T0085P11_67.jpg', '/listing-media/sam/1t0085/08.webp', 'image/webp', 30678, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังที่ดิน 9 แปลงติดต่อกัน', 'ผังแสดงโฉนด 9 แปลง รูปหลายเหลี่ยม แนวถนนตลาดใหม่และซอยตลาดใหม่ 19', 'https://npa.sam.or.th/site/images/npa/4971/20160817181658_1T0085C1_59.jpg', '/listing-media/sam/1t0085/09.webp', 'image/webp', 18078, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แผนที่การเดินทางไปทรัพย์', 'แผนที่ต้นทางแสดงตำแหน่งทรัพย์ 1T0085 ถนนตลาดใหม่ และสถานที่สำคัญใจกลางเมืองสุราษฎร์ธานี', 'https://npa.sam.or.th/site/images/npa/4971/20180430165422_1T0085M1_60.jpg', '/listing-media/sam/1t0085/10.webp', 'image/webp', 34914, 785, 600, 100, false, true);

    INSERT INTO public.listing_sources (
        listing_id,
        source_type,
        publisher_name,
        source_url,
        reference_code,
        captured_at,
        notes
    ) VALUES
        (
            property_listing_id,
            'editorial_import',
            'บริษัท บริหารสินทรัพย์สุขุมวิท จำกัด (SAM)',
            'https://www.sam.or.th/site/npa/detail.php?id=4971',
            '1T0085',
            '2026-09-09 00:00:00+07',
            'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 75,053,000, or THB 53,037 per sq.wah, for nine contiguous vacant-land plots under title deeds 646, 1721, 1759, 4625, 4626, 4627, 4628, 10430 and 10431. Total area is 3 rai 2 ngan 15.1 sq.wah / 1,415.1 sq.wah / 5,660.4 sq.m. The polygonal holding has approximately 22.5 meters of western frontage on Talat Mai Road, an approximately 265.5-meter southern boundary including approximately 51.5 meters fronting Soi Talat Mai 19, and a maximum depth of approximately 190 meters. SAM reports public asphalt access from two sides: Talat Mai Road with an approximately 12-meter carriageway within a 15-meter right of way, and Soi Talat Mai 19 with an approximately six-meter carriageway within an eight-meter right of way. SAM also reports that the asset lies in Area 3 under Surat Thani City Municipality building-control bylaw B.E. 2552; buyers must independently confirm the current consolidated rules and proposed use with the municipality. The source does not publish its detailed information date, utilities, land level or fill, flood history, soil condition, occupancy or other encumbrances. Property photos display 6 August 2024. Administrator-supplied coordinates are approximately 0.28 meters from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all ten unique source property, plot and navigation images; one exact duplicate source image was omitted and no MapxProp watermark was added.'
        ),
        (
            property_listing_id,
            'public_post',
            'เทศบาลนครสุราษฎร์ธานี',
            'https://www.suratcity.go.th/web/index.php/th/content_page/item/8006-art-legislation-define-structure-2552-2020-th',
            'surat-thani-building-control-bylaw-2552',
            '2026-09-09 00:00:00+07',
            'Official municipality page documenting the 2009 building-control bylaw. SAM, not this municipality page, is the source for the statement that asset 1T0085 lies in Area 3. Buyers must obtain parcel-specific confirmation from the municipality.'
        ),
        (
            property_listing_id,
            'public_post',
            'ราชกิจจานุเบกษา',
            'https://ratchakitcha.soc.go.th/documents/17064453.pdf',
            'surat-thani-building-control-amendment-2561',
            '2026-09-09 00:00:00+07',
            'Official Royal Gazette publication of the 2018 amending bylaw. Its inclusion documents that an amendment exists and does not assert a particular effect on this parcel or on Area 3; buyers must confirm the consolidated current requirements with Surat Thani City Municipality.'
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
        'SAM Direct Sale: Nine Contiguous Plots on Talat Mai Road, Surat Thani, THB 75.053M',
        E'Nine contiguous vacant-land plots totalling 3 rai 2 ngan 15.1 sq.wah, or 1,415.1 sq.wah (5,660.4 sq.m.), fronting Talat Mai Road and Soi Talat Mai 19 in Talat, Mueang Surat Thani, Surat Thani. The property comprises nine title deeds: 646, 1721, 1759, 4625, 4626, 4627, 4628, 10430 and 10431.\n\nThe polygonal holding has approximately 22.5 meters of western frontage on Talat Mai Road. Its southern boundary totals approximately 265.5 meters, including an approximately 51.5-meter section fronting Soi Talat Mai 19, and maximum depth is approximately 190 meters. SAM therefore reports public-road frontage on two sides.\n\nTalat Mai Road is a public asphalt road with an approximately 12-meter carriageway within an approximately 15-meter right of way. Soi Talat Mai 19 is a public asphalt road with an approximately six-meter carriageway within an approximately eight-meter right of way. The property is in a residential and commercial city area near Surat Thani City Pillar Shrine, Municipal School 1, the municipal fresh market and Mueang Surat Thani Police Station.\n\nImportant due diligence: SAM reports that the property is in Area 3 under the Surat Thani City Municipality bylaw restricting construction, alteration, use or change of use of certain buildings, B.E. 2552 (2009). An official amendment was published in B.E. 2561 (2018). Buyers should take the title-deed numbers, surveyed boundaries and their proposed plans directly to Surat Thani City Municipality to confirm the current consolidated requirements, permitted building types and uses, setbacks, access and approval process before offering. This listing does not represent that any particular development is permitted.\n\nThe SAM page lists the property as direct purchase with an announced sale price of THB 75,053,000, approximately THB 53,037 per sq.wah. It is not an auction. Contact SAM directly to confirm availability, offer procedures, current price, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: 1T0085. MapxProp does not collect deposits or represent SAM in the transaction.\n\nThe source does not publish a date for its detailed information, utilities, land level or fill, flood history, soil condition, occupancy or other encumbrances. Source property photos display 6 August 2024. Buyers should arrange an inspection and verify title deeds, surveyed boundaries, road frontage, planning and building-control rules, utilities, drainage, flooding, soil, encumbrances, expenses and every term before deciding.',
        'Nine contiguous vacant-land plots',
        'Fronting Talat Mai Road and Soi Talat Mai 19',
        'Talat Mai Road',
        'Talat',
        'Mueang Surat Thani',
        'Surat Thani',
        'SAM Direct-Sale Land on Talat Mai Road, Surat Thani, THB 75.053M',
        'Official SAM NPA asset 1T0085: nine contiguous plots totalling 5,660.4 sq.m. with two-road frontage. Direct-sale price THB 75.053M; municipal rules require confirmation.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset 1T0085 nine contiguous vacant land plots Talat Mai Road Soi Talat Mai 19 Talat Mueang Surat Thani 3 rai 2 ngan 15.1 sq.wah 1415.1 sq.wah 5660.4 sq.m. title deeds 646 1721 1759 4625 4626 4627 4628 10430 10431 THB 75053000 municipal building control Area 3')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=4971'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=4971',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 1T0085. The specifications, title-deed numbers, images, rounded coordinates, announced price, direct-purchase status, road measurements and Area 3 municipal-control note come from that record.',
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
        'dc3fd30b-66a1-44a3-858c-ec82386e229f',
        jsonb_build_object(
            'reference_code', '1T0085',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'title_document_count', 9,
            'municipal_rule_review_required', true,
            'duplicate_source_image_omitted', true
        )
    );
END $$;

COMMIT;
