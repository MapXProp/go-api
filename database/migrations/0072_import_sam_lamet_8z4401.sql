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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing 8Z4401';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing 8Z4401';
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
        'cb7c12cb-0cff-430c-9519-3fca4130bc82',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'land',
        'mixed',
        'sale',
        'land_plot',
        'ขายตรง SAM ที่ดินเปล่า 14 ไร่ 1 งาน ติดถนนเอเชีย ทล.41 ไชยา ราคา 27.657 ล้านบาท',
        E'ที่ดินเปล่า ติดถนนสายเอเชีย (ทล.41) ตอนไชยา-พุนพิน ตำบลเลม็ด อำเภอไชยา จังหวัดสุราษฎร์ธานี เอกสารสิทธิ์ น.ส.3 เลขที่ 356 จำนวน 1 ฉบับ เนื้อที่ 14 ไร่ 1 งาน หรือ 5,700 ตร.ว. (22,800 ตร.ม.)\n\nแปลงที่ดินรูปคล้ายสี่เหลี่ยมผืนผ้า ด้านทิศตะวันตกติดถนน หน้ากว้างประมาณ 65 เมตร ลึกประมาณ 380 เมตร และด้านทิศตะวันออกติดพรุน้ำประมาณ 57 เมตร ถนนหน้าทรัพย์เป็นทางสาธารณประโยชน์ ผิวจราจรลาดยางกว้างประมาณ 18 เมตร เขตทางกว้างประมาณ 80 เมตร อยู่ในเขตผังเมืองสีเขียว ย่านที่อยู่อาศัยและเกษตรกรรม\n\nสำคัญ: เอกสารสิทธิ์เป็น น.ส.3 ตำแหน่งที่ตั้ง รูปแปลง ระยะ เนื้อที่ แนวเขต และรายละเอียดสำคัญอาจคลาดเคลื่อนจากข้อมูลที่แสดง ผู้สนใจต้องตรวจสอบเอกสารสิทธิ์ ตำแหน่งจริง แนวเขต เนื้อที่ และนัดรังวัดกับหน่วยงานที่เกี่ยวข้องให้เป็นที่พอใจก่อนเสนอซื้อ รวมถึงตรวจสอบการเข้าถึง ภาระผูกพัน ผังเมือง การใช้ประโยชน์ และสภาพพื้นที่ติดพรุน้ำด้วยตนเอง\n\nการเดินทางใช้ถนนสายเอเชีย (ทล.41) ช่วงไชยา-พุนพิน จากอำเภอท่าชนะมุ่งหน้าท่าฉาง ผ่านสี่แยกป่าเว สี่แยกไชยา เทสโก้ โลตัสไชยา และโรงเรียนเพชรผดุงเวียงไชย ไปทางสวนโมกขพลาราม บริเวณหลักกิโลเมตรที่ 135 ทรัพย์อยู่ด้านซ้ายมือ สถานที่ใกล้เคียงที่ SAM ระบุ ได้แก่ สวนโมกขพลาราม โรงเรียนกาญจนาภิเษกวิทยาลัย สุราษฎร์ธานี โรงเรียนเพชรผดุงเวียงไชยา และเทสโก้ โลตัสไชยา\n\nหน้า SAM ระบุสถานะ “ซื้อตรง” และราคาประกาศขาย 27,657,000 บาท หรือประมาณ 4,852 บาทต่อ ตร.ว. ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคา ค่าใช้จ่าย และเงื่อนไขล่าสุด โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ 8Z4401 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nหน้าต้นทางไม่ระบุผลรังวัดล่าสุด ระดับถมดิน ระบบสาธารณูปโภค สถานะผู้ใช้ประโยชน์ ภาระผูกพัน หรือข้อกำหนดพัฒนาที่ดินโดยละเอียด ภาพทรัพย์ต้นทางมีวันที่กำกับ 19 กันยายน 2565 ผู้ซื้อควรนัดตรวจพื้นที่และตรวจสอบข้อมูลล่าสุดกับ SAM และหน่วยงานราชการก่อนตัดสินใจ',
        27657000,
        false,
        22800,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'ที่ดินติดถนนสายเอเชีย (ทล.41)',
        'ตอนไชยา-พุนพิน บริเวณหลัก กม.135',
        'ถนนสายเอเชีย (ทล.41)',
        NULL,
        9.35828784,
        99.17262388,
        'สุราษฎร์ธานี',
        'ไชยา',
        'เลม็ด',
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
        'sam-direct-sale-vacant-land-lamet-chaiya-surat-thani-8z4401'
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
        property_listing_id, 'sale', 27657000, 'total', 'THB', false
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
            'vacant_land', true,
            'land_area_rai', 14,
            'land_area_ngan', 1,
            'land_area_square_wah', 0,
            'land_area_total_square_wah', 5700,
            'land_area_sqm', 22800,
            'document_type_th', 'น.ส.3',
            'document_number', '356',
            'title_document_count', 1,
            'document_location_accuracy_warning', true,
            'survey_and_boundary_verification_required', true,
            'plot_shape', 'near_rectangle',
            'west_road_frontage_m', 65,
            'maximum_depth_m', 380,
            'east_wetland_frontage_m', 57,
            'east_boundary_feature_th', 'พรุน้ำ',
            'front_road_name', 'ถนนสายเอเชีย (ทล.41) ตอนไชยา-พุนพิน',
            'access_type', 'public_road',
            'front_road_surface', 'asphalt',
            'front_road_width_m', 18,
            'front_right_of_way_width_m', 80,
            'zoning_color_th', 'สีเขียว',
            'surrounding_area_use_th', 'ที่อยู่อาศัยและเกษตรกรรม',
            'price_per_square_wah', 4852,
            'price_per_square_wah_currency', 'THB',
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-09',
            'source_photo_date_displayed', '2022-09-19',
            'occupancy_status_not_published', true,
            'utilities_not_published', true,
            'land_fill_level_not_published', true,
            'encumbrance_information_not_published', true,
            'latest_survey_result_not_published', true,
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '9.358120,99.172592',
            'administrator_coordinate_distance_from_source_m_approx', 19
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z4401. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนสายเอเชีย (ทล.41)', 'Asian Highway 2 / Highway 41', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'สวนโมกขพลาราม', 'Suan Mokkhaphalaram', 'landmark', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'โรงเรียนกาญจนาภิเษกวิทยาลัย สุราษฎร์ธานี', 'Kanchanapisek Wittayalai Surat Thani School', 'education', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'โรงเรียนเพชรผดุงเวียงไชยา', 'Phet Phadung Wiang Chaiya School', 'education', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'เทสโก้ โลตัสไชยา', 'Lotus Chaiya', 'shopping', NULL, NULL, NULL, 50, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '27,657,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 27,657,000 — confirm the latest price with SAM', 'unspecified', 27657000, 'THB', 20),
        (property_listing_id, 'title_document', 'เอกสารสิทธิ์', 'Title document', 'น.ส.3 เลขที่ 356 จำนวน 1 ฉบับ', 'Nor Sor 3 no. 356, one document', 'unspecified', NULL, '', 30),
        (property_listing_id, 'survey_and_boundary_verification', 'การตรวจสอบตำแหน่งและแนวเขต', 'Location and boundary verification', 'ตำแหน่ง รูปแปลง ระยะ เนื้อที่ และแนวเขตของเอกสาร น.ส.3 อาจคลาดเคลื่อน ผู้ซื้อต้องตรวจสอบและรังวัดก่อนเสนอซื้อ', 'The location, plot shape, dimensions, area, and boundaries shown for the Nor Sor 3 document may vary; the buyer must verify and arrange a survey before submitting an offer', 'buyer', NULL, '', 40),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ผู้ซื้อต้องตรวจสอบสภาพพื้นที่ติดพรุน้ำ การเข้าถึง ภาระผูกพัน ผังเมือง สาธารณูปโภค และเงื่อนไขล่าสุดด้วยตนเอง', 'The buyer must independently verify the wetland boundary, access, encumbrances, zoning, utilities, and current terms', 'buyer', NULL, '', 50)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ที่ดินติดถนนสายเอเชีย', 'แนวหน้าที่ดินเปล่ารหัส 8Z4401 ติดถนนสายเอเชีย ทล.41 ช่วงไชยา-พุนพิน', 'https://npa.sam.or.th/site/images/npa/11627/20240815084651_P1.jpg', '/listing-media/sam/8z4401/01.webp', 'image/webp', 30278, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ป้ายหน้าทรัพย์', 'ป้ายประกาศขายที่ดิน 14 ไร่ของ SAM บริเวณหน้าแปลง', 'https://npa.sam.or.th/site/images/npa/11627/8Z4401P3_66.jpg', '/listing-media/sam/8z4401/02.webp', 'image/webp', 28468, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'สภาพพื้นที่ด้านใน', 'สภาพพื้นที่ดินเปล่ามีพืชพรรณและต้นไม้บริเวณภายในแปลง', 'https://npa.sam.or.th/site/images/npa/11627/8Z4401P5_66.jpg', '/listing-media/sam/8z4401/03.webp', 'image/webp', 36282, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่โล่งและสวนมะพร้าว', 'มุมมองพื้นที่โล่งภายในแปลงและต้นมะพร้าวโดยรอบ', 'https://npa.sam.or.th/site/images/npa/11627/8Z4401P8_66.jpg', '/listing-media/sam/8z4401/04.webp', 'image/webp', 42272, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมกว้างภายในแปลง', 'ภาพมุมกว้างของที่ดินเปล่าและสภาพแวดล้อมภายในแปลง', 'https://npa.sam.or.th/site/images/npa/11627/8Z4401P9_66.jpg', '/listing-media/sam/8z4401/05.webp', 'image/webp', 23256, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังรูปแปลงที่ดิน', 'ผัง น.ส.3 เลขที่ 356 แสดงหน้ากว้างติดถนนประมาณ 65 เมตร ลึกประมาณ 380 เมตร และด้านติดพรุน้ำประมาณ 57 เมตร', 'https://npa.sam.or.th/site/images/npa/11627/20160412155747_8Z4401C1_59.jpg', '/listing-media/sam/8z4401/06.webp', 'image/webp', 6888, 450, 450, 60, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=11627&keyref=',
        '8Z4401',
        '2026-09-09 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 27,657,000 (THB 4,852 per sq.wah) for vacant land measuring 14 rai 1 ngan, or 5,700 sq.wah / 22,800 sq.m. The land document is Nor Sor 3 no. 356, one document. SAM warns that the indicated location, plot shape, dimensions, land area, boundaries, and other material particulars of this document type may vary and must be independently verified. The source describes approximately 65 meters of west-side Highway 41 frontage, approximately 380 meters maximum depth, and approximately 57 meters adjoining a wetland on the east. Source coordinates are 9.358120,99.172592; administrator-supplied coordinates approximately 19 meters away are used. Source property photos display 19 September 2022. Occupancy, utilities, land-fill level, encumbrances, and a current survey result are not published. One exact duplicate source photo and SAM''s schematic area map were excluded; MapxProp stores optimized copies of five unique property photos and the plot diagram without adding a MapxProp watermark.'
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
        'SAM Direct Sale: 14 Rai 1 Ngan Vacant Land on Highway 41, Chaiya, THB 27.657M',
        E'Vacant land fronting Asian Highway 2 / Highway 41 on the Chaiya-Phunphin section in Lamet, Chaiya, Surat Thani. Nor Sor 3 document no. 356, one document, covers 14 rai 1 ngan, equivalent to 5,700 sq.wah or 22,800 sq.m.\n\nThe near-rectangular plot has approximately 65 meters of west-side road frontage, a maximum depth of approximately 380 meters, and approximately 57 meters adjoining a wetland on the east. The road is a public asphalt highway with an approximately 18-meter carriageway in an approximately 80-meter right of way. The source identifies green zoning in a residential and agricultural area.\n\nImportant: this is a Nor Sor 3 land document. SAM warns that the displayed location, plot shape, dimensions, land area, boundaries, and other material details may vary. Prospective buyers must independently verify the document, actual location, boundaries and area, and arrange an appropriate survey before submitting an offer. Buyers should also verify access, encumbrances, zoning, permitted use, drainage, and conditions associated with the wetland boundary.\n\nAccess is via Highway 41 from Tha Chana toward Tha Chang, passing Pa We Intersection, Chaiya Intersection, Lotus Chaiya, and Phet Phadung Wiang Chaiya School. Continue toward Suan Mokkhaphalaram near kilometer marker 135; the property is on the left. Other nearby places listed by SAM include Kanchanapisek Wittayalai Surat Thani School.\n\nThe SAM page lists the property for direct purchase at an announced sale price of THB 27,657,000, approximately THB 4,852 per sq.wah. It is not an auction. Contact SAM directly to confirm availability, the offer procedure, current price, expenses, and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: 8Z4401. MapxProp does not collect deposits or represent SAM in the transaction.\n\nThe source does not publish a current survey result, land-fill level, utilities, occupancy, encumbrances, or detailed development controls. The source property photos display 19 September 2022. Buyers should inspect the site and verify all current information with SAM and the relevant authorities before deciding.',
        'Land fronting Asian Highway 2 / Highway 41',
        'Chaiya-Phunphin Section, near Km 135',
        'Asian Highway 2 / Highway 41',
        'Lamet',
        'Chaiya',
        'Surat Thani',
        'SAM Direct-Sale Land on Highway 41, Chaiya, THB 27.657M',
        'Official SAM asset 8Z4401: 14 rai 1 ngan of vacant Nor Sor 3 land on Highway 41 in Lamet, Chaiya. Direct-sale price THB 27.657M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset 8Z4401 vacant land Lamet Chaiya Surat Thani Highway 41 Asian Highway 14 rai 1 ngan 5700 sq.wah 22800 sq.m. Nor Sor 3 number 356 THB 27657000')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=11627&keyref='
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=11627&keyref=',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z4401. The specifications, images, rounded source coordinates, announced price, direct-purchase status, Nor Sor 3 warning, and access information come from that record.',
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
        'cb7c12cb-0cff-430c-9519-3fca4130bc82',
        jsonb_build_object(
            'reference_code', '8Z4401',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'document_type', 'nor_sor_3',
            'survey_warning', true
        )
    );
END $$;

COMMIT;
