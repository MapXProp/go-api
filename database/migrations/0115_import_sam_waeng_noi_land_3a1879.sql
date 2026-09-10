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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing 3A1879';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing 3A1879';
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
        'e8da9a00-82de-4552-bf96-7d7cc5dd368f',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'land',
        'residence',
        'sale',
        'land_plot',
        'ขายตรง SAM ที่ดินเปล่า 4 แปลงติดกัน มีบ่อน้ำ แวงน้อย ขอนแก่น 3-2-0 ไร่ ราคา 3.372 ล้านบาท',
        E'ที่ดินเปล่าจำนวน 4 แปลงติดกัน ตำบลแวงน้อย อำเภอแวงน้อย จังหวัดขอนแก่น เอกสารสิทธิ์เป็นโฉนดที่ดินเลขที่ 22360, 22362, 22363 และ 22364 จำนวน 4 ฉบับ เนื้อที่รวม 3 ไร่ 2 งาน หรือ 1,400 ตร.ว. (5,600 ตร.ม.) ราคาตามหน้า SAM คิดเป็น 2,409 บาทต่อตารางวา\n\nที่ดินเป็นรูปคล้ายสี่เหลี่ยมผืนผ้า ด้านทิศเหนือติดถนนกว้างประมาณ 60 เมตร ลึกสุดประมาณ 95 เมตร และระดับที่ดินเฉลี่ยต่ำกว่าถนนประมาณ 0.2 เมตร ผู้ซื้อควรตรวจโฉนดทั้ง 4 ฉบับ รังวัด แนวเขต การติดต่อกันของแต่ละแปลง ระยะหน้ากว้าง ความลึก ระดับดิน การถมดิน และการระบายน้ำจริงก่อนเสนอซื้อ\n\nภายในที่ดินมีบ่อน้ำ 2 บ่อ ลึกประมาณ 1.5 เมตร บ่อแรกขนาดประมาณ 6 x 40 เมตร และบ่อที่สองประมาณ 15 x 40 เมตร รวมพื้นที่บ่อประมาณ 0-2-10 ไร่ หรือ 210 ตร.ว. (840 ตร.ม.) ผู้ซื้อควรตรวจตำแหน่ง ขนาด ความลึก คุณภาพดิน ความปลอดภัย การระบายน้ำ สิทธิใช้น้ำ และต้นทุนถมหรือปรับพื้นที่ให้เหมาะกับแผนการใช้ประโยชน์\n\nถนนผ่านหน้าทรัพย์คือซอยเทศบาล 12 ซึ่ง SAM ระบุว่าเป็นทางสาธารณประโยชน์ ผิวจราจรคอนกรีตกว้างประมาณ 5 เมตร เขตทางกว้างประมาณ 6 เมตร ควรให้ SAM สำนักงานที่ดิน และหน่วยงานท้องถิ่นยืนยันแนวเขต สถานะทางสาธารณะ ทางเข้าออก และเขตทางจริง\n\nหน้า SAM ระบุว่าทรัพย์อยู่ในย่านที่อยู่อาศัยและเกษตรกรรม และคร่อมผังเมืองเขตพื้นที่สีชมพูประเภทชุมชนกับสีเขียวประเภทชนบทและเกษตรกรรม MapxProp จึงจัดไว้ในหมวดที่อยู่อาศัย พร้อมกรณีใช้งานด้านเกษตรกรรม ไม่ได้จัดเป็น Mixed Use หรือหมวดธุรกิจ ข้อความเรื่องย่านและสีผังเมืองไม่ใช่การรับรองว่าสามารถก่อสร้างหรือทำเกษตรตามแผนได้ ผู้ซื้อต้องตรวจตำแหน่งแนวแบ่งสีผังเมือง ข้อกำหนดการใช้ที่ดิน กฎหมายอาคาร การแบ่งแปลง ทางเข้าออก แหล่งน้ำ สาธารณูปโภค และใบอนุญาตกับหน่วยงานที่เกี่ยวข้องโดยตรง\n\nสถานที่สำคัญที่ SAM ระบุ ได้แก่ โรงเรียนแวงน้อยศึกษา สถานีตำรวจภูธรอำเภอแวงน้อย และที่ว่าการอำเภอแวงน้อย การเดินทางตาม SAM ใช้ถนนสายเมืองพล-ท่านางแนว (ทล.2065) จากอำเภอพลมุ่งหน้าอำเภอคอนสวรรค์ ผ่านสำนักงานเทศบาลตำบลแวงน้อย โรงเรียนชุมชนบ้านโคกสี่ สำนักงานที่ดินแวงน้อย และที่ว่าการอำเภอแวงน้อย ถึงแยกสำนักงานสาธารณสุขอำเภอแวงน้อย เลี้ยวขวาเข้าถนนสายบ้านศรีเมือง-บ้านน้ำซับประมาณ 600 เมตร แล้วเลี้ยวซ้ายเข้าซอยเทศบาล 12 อีกประมาณ 180 เมตร ทรัพย์อยู่ด้านซ้ายมือ\n\nหน้า SAM แสดงสถานะ “ซื้อตรง” และราคาประกาศขาย 3,372,000 บาท ไม่ใช่การประมูลในสถานะที่ตรวจสอบเมื่อวันที่ 10 กันยายน 2569 ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะการครอบครอง และวิธีจำหน่ายล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ 3A1879 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nภาพสภาพทรัพย์ต้นทางแสดงวันที่ 15 สิงหาคม 2566 สภาพจริงอาจเปลี่ยนแปลง ผู้ซื้อควรนัดตรวจพื้นที่ วัชพืช บ่อน้ำ ระดับดิน การถมดิน การระบายน้ำ น้ำท่วม แนวเขต ทางเข้าออก สาธารณูปโภค การครอบครอง ภาระผูกพัน ภาษี ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        3372000,
        false,
        5600,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'ที่ดินเปล่า 4 แปลงติดกัน ซอยเทศบาล 12',
        'เข้าจากถนนสายบ้านศรีเมือง-บ้านน้ำซับ',
        'ซอยเทศบาล 12',
        NULL,
        15.810573788770663,
        102.41397025983282,
        'ขอนแก่น',
        'แวงน้อย',
        'แวงน้อย',
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
        'sam-direct-sale-four-land-plots-ponds-waeng-noi-khon-kaen-3a1879'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES
        (property_listing_id, 'residential'),
        (property_listing_id, 'agriculture')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 3372000, 'total', 'THB', false
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
        'land',
        1,
        jsonb_build_object(
            'source_property_category', 'ที่ดินเปล่า',
            'title_document_type', 'chanote',
            'title_deed_numbers', jsonb_build_array('22360', '22362', '22363', '22364'),
            'title_document_count', 4,
            'land_area_rai', 3,
            'land_area_ngan', 2,
            'land_area_square_wah_remainder', 0,
            'land_area_square_wah', 1400,
            'land_area_sqm', 5600,
            'plot_count', 4,
            'plots_contiguous', true,
            'vacant_land', true,
            'structures_present', false,
            'plot_shape', 'approximately_rectangular',
            'north_road_frontage_m_approx', 60,
            'maximum_depth_m_approx', 95,
            'average_land_level_below_road_m_approx', 0.2,
            'pond_count', 2,
            'pond_depth_m_approx', 1.5,
            'pond_dimensions_m_approx', jsonb_build_array(jsonb_build_array(6, 40), jsonb_build_array(15, 40)),
            'pond_total_area_square_wah_approx', 210,
            'pond_total_area_sqm_approx', 840,
            'front_road_name', 'ซอยเทศบาล 12',
            'front_road_legal_status_th', 'ทางสาธารณประโยชน์',
            'front_road_surface', 'concrete',
            'front_road_width_m_approx', 5,
            'front_right_of_way_width_m_approx', 6
        ) || jsonb_build_object(
            'zoning_colors_th', jsonb_build_array('สีชมพู ประเภทชุมชน', 'สีเขียว ประเภทชนบทและเกษตรกรรม'),
            'surrounding_area_use_th', 'ย่านที่อยู่อาศัยและเกษตรกรรม',
            'mixed_use_classification', false,
            'mixed_use_exclusion_basis', 'SAM ระบุการใช้โดยรอบเป็นที่อยู่อาศัยและเกษตรกรรม ไม่ได้ระบุพาณิชยกรรมหรือ Mixed Use',
            'residential_classification', true,
            'agriculture_use_case', true,
            'zoning_boundary_requires_verification', true,
            'intended_use_requires_independent_verification', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'price_per_square_wah', 2409,
            'computed_exact_price_per_square_wah', 2408.57,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_property_photo_date_displayed', '2023-08-15',
            'occupancy_status_not_published', true,
            'utilities_information_not_published', true,
            'flood_history_not_published', true,
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '15.810574,102.413972',
            'administrator_coordinate_distance_from_source_m_approx', 0.188
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 3A1879. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ซอยเทศบาล 12', 'Thetsaban Soi 12', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ถนนสายบ้านศรีเมือง-บ้านน้ำซับ', 'Ban Si Mueang-Ban Nam Sap Road', 'road', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'ถนนสายเมืองพล-ท่านางแนว (ทล.2065)', 'Mueang Phon-Tha Nang Naeo Highway 2065', 'road', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'โรงเรียนแวงน้อยศึกษา', 'Waeng Noi Suksa School', 'education', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'สถานีตำรวจภูธรอำเภอแวงน้อย', 'Waeng Noi Police Station', 'government', NULL, NULL, NULL, 50, true),
        (property_listing_id, 'ที่ว่าการอำเภอแวงน้อย', 'Waeng Noi District Office', 'government', NULL, NULL, NULL, 60, true),
        (property_listing_id, 'สำนักงานเทศบาลตำบลแวงน้อย', 'Waeng Noi Subdistrict Municipality Office', 'government', NULL, NULL, NULL, 70, false),
        (property_listing_id, 'โรงเรียนชุมชนบ้านโคกสี่', 'Ban Khok Si Community School', 'education', NULL, NULL, NULL, 80, false),
        (property_listing_id, 'สำนักงานที่ดินแวงน้อย', 'Waeng Noi Land Office', 'government', NULL, NULL, NULL, 90, false),
        (property_listing_id, 'สำนักงานสาธารณสุขอำเภอแวงน้อย', 'Waeng Noi District Public Health Office', 'government', NULL, NULL, NULL, 100, false)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '3,372,000 บาท หรือ 2,409 บาท/ตร.ว. — โปรดตรวจสอบราคาล่าสุดและโปรโมชั่นกับ SAM', 'THB 3,372,000 or THB 2,409 per sq.wah — confirm the latest price and promotions with SAM', 'unspecified', 3372000, 'THB', 20),
        (property_listing_id, 'four_contiguous_plots', 'ที่ดิน 4 แปลงติดกัน', 'Four contiguous plots', 'โฉนดเลขที่ 22360, 22362, 22363 และ 22364 เนื้อที่รวม 3 ไร่ 2 งาน — ตรวจรังวัดและแนวเขตทุกแปลง', 'Title deeds 22360, 22362, 22363 and 22364 total 3 rai 2 ngan — verify the survey and boundaries of every plot', 'buyer', 4, 'plots', 30),
        (property_listing_id, 'ponds', 'บ่อน้ำภายในที่ดิน', 'Ponds on the land', 'มีบ่อน้ำ 2 บ่อ ลึกประมาณ 1.5 เมตร ขนาดประมาณ 6 x 40 เมตร และ 15 x 40 เมตร รวมพื้นที่ประมาณ 210 ตร.ว.', 'Two ponds approximately 1.5 metres deep, measuring about 6 x 40 metres and 15 x 40 metres, with a combined area of about 210 sq.wah', 'buyer', 210, 'sq.wah', 40),
        (property_listing_id, 'land_level', 'ระดับที่ดิน', 'Land level', 'ระดับที่ดินเฉลี่ยต่ำกว่าถนนประมาณ 0.2 เมตร — ตรวจระดับจริง การถมดิน การระบายน้ำ และน้ำท่วม', 'Average land level is approximately 0.2 metres below the road — verify actual levels, filling, drainage and flooding', 'buyer', 0.2, 'metres', 50),
        (property_listing_id, 'public_road', 'ถนนหน้าทรัพย์', 'Frontage road', 'ซอยเทศบาล 12 เป็นทางสาธารณประโยชน์ ผิวคอนกรีตกว้างประมาณ 5 เมตร เขตทางประมาณ 6 เมตร', 'Thetsaban Soi 12 is described as a public-utility concrete road approximately five metres wide in a six-metre right of way', 'unspecified', 5, 'metres', 60),
        (property_listing_id, 'zoning_review', 'ตรวจผังเมืองสองเขต', 'Dual-zone planning review', 'SAM ระบุทั้งสีชมพูประเภทชุมชนและสีเขียวประเภทชนบทและเกษตรกรรม ต้องตรวจแนวแบ่งเขตและข้อกำหนดปัจจุบันก่อนวางแผนใช้ที่ดิน', 'SAM identifies both pink community and green rural-agricultural zones; verify the boundary and current controls before planning any use', 'buyer', NULL, '', 70),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนดทั้ง 4 ฉบับ รังวัด แนวเขต บ่อน้ำ ระดับดิน การถม การระบายน้ำ น้ำท่วม ทางเข้าออก ผังเมือง สาธารณูปโภค การครอบครอง ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Verify all four title deeds, survey, boundaries, ponds, land level, filling, drainage, flooding, access, planning, utilities, possession, encumbrances, costs and latest terms', 'buyer', NULL, '', 80)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'หน้าที่ดินติดซอยเทศบาล 12', 'หน้าที่ดินเปล่า SAM รหัส 3A1879 จำนวน 4 แปลงติดกัน ตำบลแวงน้อย ขอนแก่น', 'https://npa.sam.or.th/site/images/npa/20377/P1_66.jpg', '/listing-media/sam/3a1879/01.webp', 'image/webp', 34038, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวหน้าที่ดินริมถนน', 'ภาพแนวหน้าที่ดินและถนนซอยเทศบาล 12 พร้อมลูกศรแสดงตำแหน่งทรัพย์', 'https://npa.sam.or.th/site/images/npa/20377/20230921101601_P3_66.jpg', '/listing-media/sam/3a1879/02.webp', 'image/webp', 40958, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ถนนผ่านหน้าทรัพย์', 'ภาพถนนคอนกรีตซอยเทศบาล 12 บริเวณหน้าที่ดิน SAM 3A1879', 'https://npa.sam.or.th/site/images/npa/20377/P2_66.jpg', '/listing-media/sam/3a1879/03.webp', 'image/webp', 33344, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'สภาพภายในที่ดิน', 'ภาพสภาพพื้นที่ วัชพืช และต้นไม้ภายในที่ดินเปล่า 4 แปลง', 'https://npa.sam.or.th/site/images/npa/20377/P4_66.jpg', '/listing-media/sam/3a1879/04.webp', 'image/webp', 52384, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังที่ดิน 4 แปลงติดกัน', 'ผังต้นทางแสดงที่ดิน 4 แปลงติดกัน หน้ากว้างประมาณ 60 เมตร และลึกสุดประมาณ 95 เมตร', 'https://npa.sam.or.th/site/images/npa/20377/20230118112259_3A1879C1_66.jpg', '/listing-media/sam/3a1879/05.webp', 'image/webp', 9634, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังตำแหน่งบ่อน้ำ 2 บ่อ', 'ผังต้นทางแสดงตำแหน่งและขนาดโดยประมาณของบ่อน้ำ 2 บ่อภายในที่ดิน', 'https://npa.sam.or.th/site/images/npa/20377/20230118112259_3A1879C2_66.jpg', '/listing-media/sam/3a1879/06.webp', 'image/webp', 16592, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปทรัพย์', 'แผนที่ต้นทางแสดงเส้นทางจากถนนสายเมืองพล-ท่านางแนวและถนนบ้านศรีเมือง-บ้านน้ำซับไปยังทรัพย์ 3A1879', 'https://npa.sam.or.th/site/images/npa/20377/20230118112259_3A1879M1_66.jpg', '/listing-media/sam/3a1879/07.webp', 'image/webp', 39004, 785, 600, 70, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=20377&keyref=6004425',
        '3A1879',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 3,372,000, or THB 2,409 per sq.wah, for four contiguous vacant-land plots under title deeds 22360, 22362, 22363 and 22364 in Waeng Noi, Khon Kaen. Announced area is 3 rai 2 ngan / 1,400 sq.wah / 5,600 sq.m. The approximately rectangular property has about sixty metres of northern road frontage and a maximum depth of about ninety-five metres. Average land level is approximately 0.2 metres below the road. Two approximately 1.5-metre-deep ponds measure about 6 x 40 metres and 15 x 40 metres, totaling approximately 210 sq.wah / 840 sq.m. Thetsaban Soi 12 is described as a public-utility concrete road approximately five metres wide within an approximately six-metre right of way. SAM identifies pink community and green rural-agricultural planning zones and describes residential and agricultural surroundings. MapxProp classifies the listing for residential discovery with residential and agriculture use cases, not mixed use or business discovery. Buyers must independently verify the exact zoning boundary, title deeds, survey, ponds, land levels, road access, drainage, flooding, utilities, possession and transaction terms. Source property photos display 15 August 2023. Administrator coordinates are approximately 0.188 metres from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all seven unique source property, plot-plan, pond-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Four Contiguous Land Plots with Ponds, Waeng Noi, THB 3.372M',
        E'Four contiguous vacant-land plots in Waeng Noi, Waeng Noi, Khon Kaen, under title deeds 22360, 22362, 22363 and 22364. The announced total area is 3 rai 2 ngan, or 1,400 sq.wah (5,600 sq.m.). The SAM page lists THB 2,409 per sq.wah.\n\nThe approximately rectangular property has about sixty metres of northern road frontage and a maximum depth of about ninety-five metres. Average land level is approximately 0.2 metres below the road. Buyers should verify all four title deeds, survey, contiguous boundaries, frontage, depth, actual levels, fill requirements and drainage before offering.\n\nThere are two ponds approximately 1.5 metres deep. Their approximate dimensions are 6 x 40 metres and 15 x 40 metres, with a combined area of about 210 sq.wah (840 sq.m.). Buyers should verify their positions, dimensions, depth, soil conditions, safety, drainage, water rights and the cost of filling or modifying the site for the intended use.\n\nThe property fronts Thetsaban Soi 12, which SAM describes as a public-utility concrete road approximately five metres wide within an approximately six-metre right of way. Buyers should ask SAM, the Land Office and local authorities to confirm boundaries, public-road status, actual access and the right of way.\n\nSAM describes the surroundings as residential and agricultural and identifies two planning zones: pink community and green rural-agricultural. MapxProp therefore places the listing in homes discovery with residential and agriculture use cases, not mixed use or business discovery. These descriptions do not guarantee construction or agricultural use. Buyers must confirm the exact planning-zone boundary, current land-use controls, building regulations, subdivision rules, access, water sources, utilities and permits directly with the relevant authorities.\n\nNearby places named by SAM include Waeng Noi Suksa School, Waeng Noi Police Station and Waeng Noi District Office. SAM''s directions use Mueang Phon-Tha Nang Naeo Highway 2065 from Phon toward Khon Sawan, passing Waeng Noi Subdistrict Municipality Office, Ban Khok Si Community School, the Waeng Noi Land Office and Waeng Noi District Office. At the District Public Health Office junction, turn right onto Ban Si Mueang-Ban Nam Sap Road for approximately 600 metres, then left into Thetsaban Soi 12 for approximately 180 metres. The property is on the left.\n\nThe SAM page listed the property for direct purchase at an announced THB 3,372,000 when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, offer procedures, current price, promotions, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: 3A1879. MapxProp does not collect deposits or represent SAM in the transaction.\n\nSource property photos display 15 August 2023. Conditions may have changed. Buyers should inspect vegetation, ponds, land level, filling, drainage, flooding, boundaries, access, utilities, possession, encumbrances, taxes, costs and every current term before deciding.',
        'Four contiguous land plots on Thetsaban Soi 12',
        'Access from Ban Si Mueang-Ban Nam Sap Road',
        'Thetsaban Soi 12',
        'Waeng Noi',
        'Waeng Noi',
        'Khon Kaen',
        'SAM Four Land Plots with Ponds in Waeng Noi, THB 3.372M',
        'Official SAM NPA asset 3A1879: four contiguous vacant-land plots totaling 5,600 sq.m. with two ponds in Waeng Noi. Direct-sale price THB 3.372M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset 3A1879 four contiguous vacant land plots ponds Waeng Noi Khon Kaen title deeds 22360 22362 22363 22364 3 rai 2 ngan 1400 sq.wah 5600 sq.m. residential agriculture THB 3372000 Thetsaban Soi 12')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=20377&keyref=6004425'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=20377&keyref=6004425',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 3A1879. Specifications, title deeds, plot count, pond details, land level, images, rounded coordinates, announced price, direct-purchase status, road measurements, planning-zone wording and surrounding-use description come from that record.',
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
        'e8da9a00-82de-4552-bf96-7d7cc5dd368f',
        jsonb_build_object(
            'reference_code', '3A1879',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'residence',
            'discovery_channels', jsonb_build_array('homes'),
            'title_document_count', 4,
            'plot_count', 4,
            'pond_count', 2,
            'zoning_boundary_review_required', true,
            'land_level_review_required', true,
            'mixed_use_classification', false,
            'source_image_count', 7
        )
    );
END $$;

COMMIT;
