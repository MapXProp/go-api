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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing LL0068';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing LL0068';
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
        '23201f49-1cbc-4468-9318-6021333a3271',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'land',
        'mixed',
        'sale',
        'land_plot',
        'ขายตรง SAM ที่ดินเปล่า 5 แปลงติดถนน 3 ด้าน รอบเวียง เมืองเชียงราย 11-2-69.6 ไร่ ราคา 83.246 ล้านบาท',
        E'ที่ดินเปล่า 5 แปลงติดต่อกัน เนื้อที่ประกาศรวม 11 ไร่ 2 งาน 69.6 ตร.ว. หรือ 4,669.6 ตร.ว. (18,678.4 ตร.ม.) ตำบลรอบเวียง อำเภอเมืองเชียงราย จังหวัดเชียงราย เอกสารสิทธิ์เป็นโฉนดที่ดิน 5 ฉบับ เลขที่ 1117, 1169, 1900, 4755 และ 30523

แปลงที่ดินเป็นรูปหลายเหลี่ยม ติดถนนสาธารณะ 3 ด้าน ด้านทิศเหนือยาวประมาณ 207 เมตร โดยส่วนที่ติดถนนกว้างประมาณ 17.5 เมตร ด้านทิศตะวันตกยาวประมาณ 180 เมตร โดยส่วนที่ติดถนนกว้างประมาณ 4.5 เมตร และด้านทิศตะวันออกยาวประมาณ 210 เมตร โดยส่วนที่ติดถนนกว้างประมาณ 9 เมตร ระดับที่ดินเสมอถนนหน้าทรัพย์ตามข้อมูลของ SAM

ทางสาธารณประโยชน์ที่ผ่านหน้าทรัพย์ ได้แก่ ถนนประตูเชียงใหม่ ซอย 1 ผิวจราจรคอนกรีตกว้างประมาณ 4 เมตร ถนนซอยราชโยธา ซอย 1/1 ผิวจราจรคอนกรีตกว้างประมาณ 5 เมตร และซอยสามัคคี ผิวจราจรคอนกรีตกว้างประมาณ 3.5 เมตร ทรัพย์อยู่ในย่านที่อยู่อาศัย การเดินทางสะดวก ใกล้วัดมิ่งเมือง ที่ว่าการอำเภอเมืองเชียงราย และวิทยาลัยพาณิชยการเชียงราย หน้า SAM แสดงเขตพื้นที่เป็นสีชมพู ผู้ซื้อต้องตรวจสอบผังเมืองและข้อกำหนดการใช้ประโยชน์ปัจจุบันกับหน่วยงานท้องถิ่นโดยตรง

ข้อควรตรวจสอบสำคัญ: สำหรับโฉนดเลขที่ 30523 หน้าเอกสารสิทธิ์ระบุเนื้อที่ 0-0-97.5 แต่รายการจดทะเบียนระบุ 0-0-87.5 โดยราคาประกาศอ้างอิงเนื้อที่ตามหน้าเอกสารสิทธิ์ คือ 0-0-97.5 ส่วนโฉนดเลขที่ 1117 มีที่ดินบางส่วนสภาพเป็นถนนซอยสามัคคี กว้างประมาณ 3.50 x 4.50 เมตร คิดเป็นเนื้อที่ประมาณ 3.9 ตร.ว. ผู้ซื้อควรตรวจเอกสารสิทธิ์ รายการจดทะเบียน เนื้อที่จริง แนวเขต และสภาพถนนกับ SAM และสำนักงานที่ดินก่อนเสนอซื้อ

หน้า SAM ระบุสถานะ “ซื้อตรง” และราคาประกาศขาย 83,246,000 บาท หรือ 17,827 บาท/ตร.ว. ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน ค่าใช้จ่าย สถานะการครอบครอง และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ LL0068 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM

ภาพทรัพย์ต้นทางแสดงวันที่ 31 มกราคม 2568 สภาพจริงอาจเปลี่ยนแปลง ผู้ซื้อควรนัดตรวจทรัพย์ รังวัดหรือสอบเขต ตรวจโฉนดและรายการจดทะเบียน ทางเข้า-ออก ผังเมือง สาธารณูปโภค น้ำท่วม การระบายน้ำ ดิน ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        83246000,
        false,
        18678.4,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'ที่ดินเปล่า 5 แปลงติดต่อกัน',
        'ติดถนนประตูเชียงใหม่ ซอย 1 ถนนซอยราชโยธา ซอย 1/1 และซอยสามัคคี',
        'ถนนราชโยธา',
        NULL,
        19.90571795,
        99.82428075,
        'เชียงราย',
        'เมืองเชียงราย',
        'รอบเวียง',
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
        'sam-direct-sale-five-plot-land-rop-wiang-chiang-rai-ll0068'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 83246000, 'total', 'THB', false
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
            'title_deed_numbers', jsonb_build_array('1117', '1169', '1900', '4755', '30523'),
            'title_document_count', 5,
            'land_area_rai', 11,
            'land_area_ngan', 2,
            'land_area_square_wah_remainder', 69.6,
            'land_area_square_wah', 4669.6,
            'land_area_sqm', 18678.4,
            'plot_count', 5,
            'plots_contiguous', true,
            'vacant_land', true,
            'structures_present', false,
            'plot_shape', 'polygon',
            'road_frontage_side_count', 3,
            'north_boundary_m', 207,
            'north_road_frontage_m', 17.5,
            'west_boundary_m', 180,
            'west_road_frontage_m', 4.5,
            'east_boundary_m', 210,
            'east_road_frontage_m', 9,
            'maximum_depth_m', 210,
            'land_level_relative_to_front_road', 'same_level',
            'access_type', 'public_roads_three_sides',
            'primary_access_road_name', 'ถนนประตูเชียงใหม่ ซอย 1',
            'primary_access_road_surface', 'concrete',
            'primary_access_road_width_m', 4
        ) || jsonb_build_object(
            'secondary_access_road_name', 'ถนนซอยราชโยธา ซอย 1/1',
            'secondary_access_road_surface', 'concrete',
            'secondary_access_road_width_m', 5,
            'tertiary_access_road_name', 'ซอยสามัคคี',
            'tertiary_access_road_surface', 'concrete',
            'tertiary_access_road_width_m', 3.5,
            'zoning_color_th', 'สีชมพู ตามหน้า SAM',
            'zoning_confirmation_required', true,
            'surrounding_area_use_th', 'ย่านที่อยู่อาศัย',
            'title_deed_30523_area_discrepancy', true,
            'title_deed_30523_front_page_square_wah', 97.5,
            'title_deed_30523_registration_entry_square_wah', 87.5,
            'announced_area_uses_title_front_page', true,
            'computed_total_if_registration_entry_used_square_wah', 4659.6,
            'computed_total_if_registration_entry_used_sqm', 18638.4,
            'title_deed_1117_road_portion_reported', true,
            'title_deed_1117_road_portion_width_m', 3.5,
            'title_deed_1117_road_portion_length_m', 4.5,
            'title_deed_1117_road_portion_square_wah', 3.9,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'price_per_square_wah', 17827,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-09',
            'source_information_date_not_published', true,
            'source_photo_date_displayed', '2025-01-31',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '19.905718,99.824283',
            'administrator_coordinate_distance_from_source_m_approx', 0.24
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for LL0068. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนราชโยธา', 'Ratchayotha Road', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ถนนประตูเชียงใหม่ ซอย 1', 'Pratu Chiang Mai Road Soi 1', 'road', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'วัดมิ่งเมือง', 'Wat Ming Mueang', 'landmark', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'ที่ว่าการอำเภอเมืองเชียงราย', 'Mueang Chiang Rai District Office', 'government', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'วิทยาลัยพาณิชยการเชียงราย', 'Chiang Rai Commercial College', 'education', NULL, NULL, NULL, 50, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '83,246,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 83,246,000 — confirm the latest price with SAM', 'unspecified', 83246000, 'THB', 20),
        (property_listing_id, 'price_per_square_wah', 'ราคาต่อตารางวา', 'Price per square wah', '17,827 บาท/ตร.ว. ตามหน้าต้นทาง', 'THB 17,827 per sq.wah as shown by the source', 'unspecified', 17827, 'THB/sq_wah', 30),
        (property_listing_id, 'title_documents', 'เอกสารสิทธิ์', 'Title documents', 'โฉนดที่ดิน 5 ฉบับ สำหรับที่ดิน 5 แปลงติดต่อกัน', 'Five title deeds for five contiguous land plots', 'unspecified', 5, 'documents', 40),
        (property_listing_id, 'title_deed_30523_area', 'เนื้อที่โฉนด 30523', 'Title deed 30523 area', 'หน้าโฉนดระบุ 97.5 ตร.ว. แต่รายการจดทะเบียนระบุ 87.5 ตร.ว. ราคาประกาศอ้างอิงเนื้อที่หน้าโฉนด ต้องตรวจสอบก่อนซื้อ', 'The title front page states 97.5 sq.wah while the registration entry states 87.5 sq.wah; the announced area uses the front-page figure and must be verified', 'buyer', NULL, '', 50),
        (property_listing_id, 'title_deed_1117_road_portion', 'ส่วนที่เป็นถนนในโฉนด 1117', 'Road portion within title deed 1117', 'SAM ระบุว่าประมาณ 3.9 ตร.ว. มีสภาพเป็นถนนซอยสามัคคี ต้องตรวจสอบแนวเขตและสิทธิการใช้ทาง', 'SAM reports approximately 3.9 sq.wah is physically part of Soi Samakkhi; verify boundaries and road rights', 'buyer', 3.9, 'sq_wah', 60),
        (property_listing_id, 'zoning_review', 'ตรวจสอบผังเมือง', 'Zoning review', 'หน้า SAM แสดงเขตสีชมพู ต้องยืนยันข้อกำหนดปัจจุบันและแผนการใช้ประโยชน์กับหน่วยงานท้องถิ่น', 'SAM shows a pink zone; confirm current controls and the intended use with local authorities', 'buyer', NULL, '', 70),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนด รายการจดทะเบียน เนื้อที่จริง แนวเขต ทางเข้า-ออก ผังเมือง สาธารณูปโภค น้ำท่วม ดิน ภาระผูกพัน ค่าใช้จ่าย สถานะการครอบครอง และเงื่อนไขล่าสุดก่อนเสนอซื้อ', 'Verify title deeds, registration entries, actual area, boundaries, access, planning, utilities, flooding, soil, encumbrances, costs, possession and current terms before offering', 'buyer', NULL, '', 80)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ที่ดินติดถนนสามด้าน รอบเวียง เชียงราย', 'หน้าที่ดินเปล่า 5 แปลงของ SAM รหัส LL0068 ติดถนนสาธารณะในรอบเวียง เชียงราย', 'https://npa.sam.or.th/site/images/npa/22696/20250918110426_LL0068P2_68.jpg', '/listing-media/sam/ll0068/01.webp', 'image/webp', 16924, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวรั้วด้านข้างทรัพย์', 'ภาพแนวรั้วและถนนสาธารณะด้านข้างที่ดิน SAM รหัส LL0068', 'https://npa.sam.or.th/site/images/npa/22696/LL0068P3_68.jpg', '/listing-media/sam/ll0068/02.webp', 'image/webp', 14598, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมหัวแปลงติดถนน', 'ภาพมุมหัวแปลงและแนวรั้วของที่ดิน 5 แปลงติดต่อกัน รอบเวียง', 'https://npa.sam.or.th/site/images/npa/22696/LL0068P4_68.jpg', '/listing-media/sam/ll0068/03.webp', 'image/webp', 13332, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่โล่งภายในแปลง', 'ภาพพื้นที่โล่งและสภาพพืชพรรณภายในทรัพย์ SAM LL0068', 'https://npa.sam.or.th/site/images/npa/22696/LL0068P5_68.jpg', '/listing-media/sam/ll0068/04.webp', 'image/webp', 20170, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ส่วนที่มีสภาพเป็นถนน', 'ภาพส่วนหนึ่งของที่ดินซึ่งต้นทางระบุว่ามีสภาพเป็นถนนซอยสามัคคี', 'https://npa.sam.or.th/site/images/npa/22696/LL0068P6_68.jpg', '/listing-media/sam/ll0068/05.webp', 'image/webp', 30174, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวถนนผ่านทรัพย์', 'ภาพแนวทางซึ่งต้นทางระบุว่าเป็นส่วนหนึ่งของทรัพย์รหัส LL0068', 'https://npa.sam.or.th/site/images/npa/22696/LL0068P7_68.jpg', '/listing-media/sam/ll0068/06.webp', 'image/webp', 26516, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ด้านในของทรัพย์', 'ภาพสภาพพื้นที่ด้านในของที่ดินเปล่า 5 แปลง รอบเวียง เชียงราย', 'https://npa.sam.or.th/site/images/npa/22696/LL0068P8_68.jpg', '/listing-media/sam/ll0068/07.webp', 'image/webp', 20780, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่โล่งตอนกลางแปลง', 'ภาพแนวพื้นที่โล่งและพืชพรรณตอนกลางแปลงที่ดิน SAM LL0068', 'https://npa.sam.or.th/site/images/npa/22696/LL0068P9_68.jpg', '/listing-media/sam/ll0068/08.webp', 'image/webp', 22464, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'หน้าที่ดินอีกด้านหนึ่ง', 'ภาพแนวหน้าที่ดินอีกด้านซึ่งติดถนนสาธารณะในย่านรอบเวียง', 'https://npa.sam.or.th/site/images/npa/22696/LL0068P10_68.jpg', '/listing-media/sam/ll0068/09.webp', 'image/webp', 17202, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้าจากถนนราชโยธา', 'ภาพถนนราชโยธาบริเวณแยกเข้าถนนประตูเชียงใหม่ ซอย 1 ไปยังทรัพย์ LL0068', 'https://npa.sam.or.th/site/images/npa/22696/LL0068P1_68.jpg', '/listing-media/sam/ll0068/10.webp', 'image/webp', 19170, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังที่ดิน 5 แปลงติดถนน 3 ด้าน', 'ผังต้นทางแสดงโฉนด 5 แปลง แนวถนนสามด้าน และส่วนที่มีสภาพเป็นซอยสามัคคี', 'https://npa.sam.or.th/site/images/npa/22696/20250918110426_LL0068C1_68.jpg', '/listing-media/sam/ll0068/11.webp', 'image/webp', 31178, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปทรัพย์', 'แผนที่ต้นทางแสดงตำแหน่งทรัพย์ LL0068 ถนนราชโยธา และสถานที่สำคัญในเมืองเชียงราย', 'https://npa.sam.or.th/site/images/npa/22696/20250918110426_LL0068M_68(TL0195).jpg', '/listing-media/sam/ll0068/12.webp', 'image/webp', 50930, 785, 600, 120, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=22696&keyref=6004080',
        'LL0068',
        '2026-09-09 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 83,246,000, or THB 17,827 per sq.wah, for five contiguous vacant-land plots under title deeds 1117, 1169, 1900, 4755 and 30523. Announced total area is 11 rai 2 ngan 69.6 sq.wah / 4,669.6 sq.wah / 18,678.4 sq.m. SAM reports a material area discrepancy for title deed 30523: its front page states 97.5 sq.wah while the registration entry states 87.5 sq.wah; the announced sale area follows the front-page figure. SAM also reports that approximately 3.9 sq.wah within title deed 1117 is physically part of Soi Samakkhi. The polygonal property fronts public concrete roads on three sides and SAM shows a pink planning zone. Buyers must independently verify title documents, registered area, surveyed area, boundaries, road rights, current planning controls and all transaction terms. Property photos display 31 January 2025. Administrator coordinates are approximately 0.24 meters from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all 12 unique source property, plot and navigation images; no MapxProp watermark was added.'
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
        'SAM Direct Sale: Five Contiguous Plots with Three-Side Road Access, Chiang Rai, THB 83.246M',
        E'Five contiguous vacant-land plots totalling an announced 11 rai 2 ngan 69.6 sq.wah, or 4,669.6 sq.wah (18,678.4 sq.m.), in Rop Wiang, Mueang Chiang Rai, Chiang Rai. The property comprises five title deeds: 1117, 1169, 1900, 4755 and 30523.

SAM describes the polygonal property as fronting public roads on three sides. The northern boundary is approximately 207 meters with about 17.5 meters of road frontage; the western boundary is approximately 180 meters with about 4.5 meters of frontage; and the eastern boundary is approximately 210 meters with about nine meters of frontage. The land is reported to be level with the front road.

Access roads are Pratu Chiang Mai Road Soi 1, a public concrete road approximately four meters wide; Ratchayotha Road Soi 1/1, a public concrete road approximately five meters wide; and Soi Samakkhi, a public concrete road approximately 3.5 meters wide. SAM describes the surroundings as a residential area with convenient transport, near Wat Ming Mueang, Mueang Chiang Rai District Office and Chiang Rai Commercial College. The SAM page shows a pink planning zone. Buyers must confirm current planning, building-control and intended-use requirements directly with the relevant local authorities.

Important title-area caveat: for title deed 30523, SAM says the title front page states 97.5 sq.wah while the registration entry states 87.5 sq.wah. The announced sale area uses the front-page figure. SAM also says part of title deed 1117, approximately 3.5 by 4.5 meters or 3.9 sq.wah, is physically part of Soi Samakkhi. Buyers should verify the title documents, registration entries, actual surveyed area, boundaries and road rights with SAM and the Land Office before offering.

The SAM page lists the property for direct purchase at an announced price of THB 83,246,000, or THB 17,827 per sq.wah. It is not an auction. Contact SAM directly to confirm availability, offer procedures, current price, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: LL0068. MapxProp does not collect deposits or represent SAM in the transaction.

Source property photos display 31 January 2025. Conditions may have changed. Buyers should arrange an inspection and verify title deeds, registration entries, surveyed area, boundaries, access, planning, utilities, flooding, drainage, soil, encumbrances, expenses and every current term before deciding.',
        'Five contiguous vacant-land plots',
        'Fronting Pratu Chiang Mai Road Soi 1, Ratchayotha Road Soi 1/1 and Soi Samakkhi',
        'Ratchayotha Road',
        'Rop Wiang',
        'Mueang Chiang Rai',
        'Chiang Rai',
        'SAM Direct-Sale Land with Three-Side Road Access, Chiang Rai, THB 83.246M',
        'Official SAM NPA asset LL0068: five contiguous vacant-land plots totalling 18,678.4 sq.m. with three-side road access. Direct-sale price THB 83.246M; verify the title-area discrepancy.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset LL0068 five contiguous vacant land plots Rop Wiang Mueang Chiang Rai Ratchayotha Road Pratu Chiang Mai Road Soi 1 Soi Samakkhi 11 rai 2 ngan 69.6 sq.wah 4669.6 sq.wah 18678.4 sq.m. title deeds 1117 1169 1900 4755 30523 THB 83246000')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=22696&keyref=6004080'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=22696&keyref=6004080',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for LL0068. Specifications, title-deed numbers, images, rounded coordinates, announced price, direct-purchase status, road measurements, title-area discrepancy and planning-zone wording come from that record.',
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
        '23201f49-1cbc-4468-9318-6021333a3271',
        jsonb_build_object(
            'reference_code', 'LL0068',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'title_document_count', 5,
            'title_area_discrepancy_review_required', true,
            'road_portion_review_required', true,
            'zoning_review_required', true,
            'source_image_count', 12
        )
    );
END $$;

COMMIT;
