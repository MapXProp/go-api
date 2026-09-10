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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing LL0072';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing LL0072';
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
        'e793ff4a-9ffa-4255-8773-52e3807dec13',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'land',
        'mixed',
        'sale',
        'land_plot',
        'ขายตรง SAM ที่ดินเปล่าติดถนนเชียงใหม่-ฮอด สันป่าตอง 2-0-78 ไร่ ราคา 13.17 ล้านบาท',
        E'ที่ดินเปล่ารูปตัวแอล ตำบลสันกลาง อำเภอสันป่าตอง จังหวัดเชียงใหม่ เอกสารสิทธิ์เป็นโฉนดที่ดินเลขที่ 8205 จำนวน 1 ฉบับ เนื้อที่ 2 ไร่ 78 ตร.ว. หรือ 878 ตร.ว. (3,512 ตร.ม.)

SAM ระบุว่าด้านทิศตะวันตกติดถนน กว้างประมาณ 38 เมตร ด้านทิศตะวันออกติดลำเหมืองสาธารณประโยชน์ กว้างประมาณ 15 เมตร และลึกสุดประมาณ 102 เมตร ผู้ซื้อควรตรวจโฉนด รังวัด รูปแปลง แนวเขต ลำเหมือง ระยะหน้ากว้างและความลึกจริงกับสำนักงานที่ดินก่อนเสนอซื้อ

ถนนผ่านหน้าทรัพย์คือถนนสายเชียงใหม่-ฮอด (ทล.108) ซึ่งหน้า SAM ระบุว่าเป็นทางสาธารณประโยชน์ ผิวจราจรคอนกรีตกว้างประมาณ 16 เมตร เขตทางกว้างประมาณ 30 เมตร การเดินทางจากอำเภอหางดงมุ่งหน้าอำเภอดอยหล่อ ผ่านวัดศรีล้อมและโรงพยาบาลสัตว์เชียงใหม่-สันป่าตอง ถึงบริเวณหลัก กม.20+140 จะพบทรัพย์อยู่ด้านซ้ายมือ

สถานที่ใกล้เคียงที่ SAM ระบุ ได้แก่ สำนักงานเขตพื้นที่การศึกษาประถมศึกษาเชียงใหม่ เขต 4 วัดคันธาราม (วัดทุ่งอ้อ) และกาดหารแก้ว

หน้า SAM ระบุเขตพื้นที่สีขาวมีกรอบมีเส้นทแยงสีเขียว และระบุชัดว่าทรัพย์ตั้งอยู่ในย่านที่อยู่อาศัยและพาณิชยกรรม MapxProp จึงจัดเป็น Mixed Use และแสดงในทั้งหมวดที่อยู่อาศัยและธุรกิจ อย่างไรก็ตาม ข้อความเรื่องย่านและสีผังเมืองไม่ใช่การรับรองว่าสามารถก่อสร้างหรือประกอบกิจการตามแผนได้ ผู้ซื้อต้องตรวจผังเมืองปัจจุบัน กฎหมายควบคุมอาคาร ทางเข้าออก การระบายน้ำ ที่จอดรถ สาธารณูปโภค และใบอนุญาตกับหน่วยงานที่เกี่ยวข้องโดยตรง

หน้า SAM แสดงสถานะ “ซื้อตรง” ราคาประกาศขาย 13,170,000 บาท หรือ 15,000 บาทต่อตารางวา ไม่ใช่การประมูลในสถานะที่ตรวจสอบเมื่อวันที่ 10 กันยายน 2569 ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะการครอบครอง และวิธีจำหน่ายล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ LL0072 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM

ภาพสภาพทรัพย์หนึ่งภาพบนหน้าต้นทางแสดงวันที่ 18 พฤศจิกายน 2565 ส่วนภาพอื่นไม่แสดงวันที่ถ่าย สภาพจริงอาจเปลี่ยนแปลง ผู้ซื้อควรนัดตรวจพื้นที่ วัชพืช ดิน การระบายน้ำ น้ำท่วม แนวเขต ลำเหมือง ทางเข้าออก สาธารณูปโภค ภาระผูกพัน ภาษี ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        13170000,
        false,
        3512,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'ที่ดินเปล่าติดถนนสายเชียงใหม่-ฮอด (ทล.108)',
        'บริเวณหลัก กม.20+140',
        'ถนนสายเชียงใหม่-ฮอด (ทล.108)',
        NULL,
        18.64668104,
        98.90333524,
        'เชียงใหม่',
        'สันป่าตอง',
        'สันกลาง',
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
        'sam-direct-sale-mixed-use-land-highway-108-san-pa-tong-ll0072'
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
        property_listing_id, 'sale', 13170000, 'total', 'THB', false
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
            'title_deed_numbers', jsonb_build_array('8205'),
            'title_document_count', 1,
            'land_area_rai', 2,
            'land_area_ngan', 0,
            'land_area_square_wah_remainder', 78,
            'land_area_square_wah', 878,
            'land_area_sqm', 3512,
            'plot_count', 1,
            'vacant_land', true,
            'structures_present', false,
            'plot_shape', 'L-shaped',
            'road_frontage_side_count', 1,
            'west_road_frontage_m_approx', 38,
            'east_public_irrigation_canal_frontage_m_approx', 15,
            'maximum_depth_m_approx', 102,
            'public_irrigation_canal_boundary', true,
            'front_road_name', 'ถนนสายเชียงใหม่-ฮอด (ทล.108)',
            'front_road_legal_status_th', 'ทางสาธารณประโยชน์',
            'front_road_surface', 'concrete',
            'front_road_width_m_approx', 16,
            'front_right_of_way_width_m_approx', 30
        ) || jsonb_build_object(
            'zoning_color_th', 'สีขาวมีกรอบมีเส้นทแยงสีเขียว ตามหน้า SAM',
            'surrounding_area_use_th', 'ย่านที่อยู่อาศัยและพาณิชยกรรม',
            'mixed_use_classification', true,
            'mixed_use_classification_basis', 'SAM ระบุว่าทรัพย์ตั้งอยู่ในย่านที่อยู่อาศัยและพาณิชยกรรม',
            'intended_use_requires_independent_verification', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'price_per_square_wah', 15000,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_information_date_not_published', true,
            'source_property_photo_dates_displayed', jsonb_build_array('2022-11-18'),
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '18.646685,98.903339',
            'administrator_coordinate_distance_from_source_m_approx', 0.59
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for LL0072. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนสายเชียงใหม่-ฮอด (ทล.108)', 'Chiang Mai-Hot Highway 108', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'สำนักงานเขตพื้นที่การศึกษาประถมศึกษาเชียงใหม่ เขต 4', 'Chiang Mai Primary Educational Service Area Office 4', 'government', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'วัดคันธาราม (วัดทุ่งอ้อ)', 'Wat Kantharam (Wat Thung O)', 'landmark', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'กาดหารแก้ว', 'Kad Han Kaeo', 'shopping', NULL, NULL, NULL, 40, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '13,170,000 บาท หรือ 15,000 บาท/ตร.ว. — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 13,170,000 or THB 15,000 per sq.wah — confirm the latest price with SAM', 'unspecified', 13170000, 'THB', 20),
        (property_listing_id, 'land_shape_and_boundary', 'รูปแปลงและแนวเขต', 'Plot shape and boundaries', 'ที่ดินรูปตัวแอล ด้านตะวันตกติดถนนประมาณ 38 เมตร ด้านตะวันออกติดลำเหมืองสาธารณะประมาณ 15 เมตร ลึกสุดประมาณ 102 เมตร', 'L-shaped land with about 38 metres on the western road side, about 15 metres on the eastern public-canal side and maximum depth about 102 metres', 'buyer', NULL, '', 30),
        (property_listing_id, 'highway_frontage', 'ถนนหน้าทรัพย์', 'Road frontage', 'ติดถนนสายเชียงใหม่-ฮอด (ทล.108) หน้า SAM ระบุผิวคอนกรีตกว้างประมาณ 16 เมตร เขตทางประมาณ 30 เมตร', 'Fronts Chiang Mai-Hot Highway 108; SAM describes an approximately sixteen-metre concrete carriageway within an approximately thirty-metre right of way', 'unspecified', 16, 'metres', 40),
        (property_listing_id, 'mixed_use_review', 'การใช้เพื่ออยู่อาศัยและธุรกิจ', 'Residential and business use review', 'SAM ระบุว่าย่านนี้เป็นที่อยู่อาศัยและพาณิชยกรรม แต่ผู้ซื้อต้องตรวจผังเมือง กฎหมายอาคาร ทางเข้าออก ที่จอดรถ และใบอนุญาตสำหรับโครงการที่ต้องการ', 'SAM describes residential and commercial surroundings, but buyers must verify planning, building control, access, parking and permits for the intended project', 'buyer', NULL, '', 50),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนด รังวัด พื้นที่จริง แนวเขต ลำเหมือง ทางเข้าออก ผังเมือง การระบายน้ำ น้ำท่วม สาธารณูปโภค ภาระผูกพัน ค่าใช้จ่าย สถานะการครอบครอง และเงื่อนไขล่าสุด', 'Verify title deed, survey, actual area, boundaries, canal, access, planning, drainage, flooding, utilities, encumbrances, costs, possession and current terms', 'buyer', NULL, '', 60)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'หน้าที่ดินติดถนนเชียงใหม่-ฮอด', 'หน้าที่ดินเปล่า SAM รหัส LL0072 ติดถนนสายเชียงใหม่-ฮอด ทล.108', 'https://npa.sam.or.th/site/images/npa/22392/20250305160842_LL0072P5_68.jpg', '/listing-media/sam/ll0072/01.webp', 'image/webp', 23584, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวหน้าทรัพย์บนทางหลวง 108', 'ภาพแนวที่ดินเปล่าริมถนนสายเชียงใหม่-ฮอด พร้อมลูกศรชี้ตำแหน่งทรัพย์', 'https://npa.sam.or.th/site/images/npa/22392/LL0072P4_68.jpg', '/listing-media/sam/ll0072/02.webp', 'image/webp', 24858, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมหน้าที่ดินและแนวถนน', 'ภาพหน้าที่ดิน SAM LL0072 และแนวถนนสายเชียงใหม่-ฮอด ลงวันที่ 18 พฤศจิกายน 2565', 'https://npa.sam.or.th/site/images/npa/22392/LL0072P2_68.jpg', '/listing-media/sam/ll0072/03.webp', 'image/webp', 22590, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังที่ดินรูปตัวแอล', 'ผังต้นทางแสดงโฉนดเลขที่ 8205 แนวถนนเชียงใหม่-ฮอดและลำเหมืองสาธารณประโยชน์', 'https://npa.sam.or.th/site/images/npa/22392/20250305160842_LL0072C1_68.jpg', '/listing-media/sam/ll0072/04.webp', 'image/webp', 13252, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปทรัพย์', 'แผนที่ต้นทางแสดงเส้นทางถนนสายเชียงใหม่-ฮอดไปยังที่ดิน SAM LL0072 ตำบลสันกลาง', 'https://npa.sam.or.th/site/images/npa/22392/20250305160842_LL0072M_68.jpg', '/listing-media/sam/ll0072/05.webp', 'image/webp', 35012, 785, 600, 50, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=22392&keyref=6004388',
        'LL0072',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 13,170,000, or THB 15,000 per sq.wah, for one L-shaped vacant-land plot under title deed 8205. Announced area is 2 rai 78 sq.wah / 878 sq.wah / 3,512 sq.m. SAM describes approximately thirty-eight metres along the western road side, approximately fifteen metres along the eastern public-irrigation-canal side and a maximum depth of approximately 102 metres. Chiang Mai-Hot Highway 108 is described as a public concrete road approximately sixteen metres wide within an approximately thirty-metre right of way. SAM shows a white planning zone with a green diagonal border and explicitly describes the surroundings as residential and commercial; MapxProp therefore classifies the listing as mixed use and includes it in both homes and business discovery. This classification does not guarantee any intended construction or business use. Buyers must independently verify title, survey, boundaries, canal, road access, current planning controls, permits and transaction terms. One source property photo displays 18 November 2022; the remaining property photos do not display a capture date. Administrator coordinates are approximately 0.59 metres from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all five unique source property, plot-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Mixed-Use Land on Highway 108, San Pa Tong, THB 13.17M',
        E'One L-shaped vacant-land plot in San Klang, San Pa Tong, Chiang Mai, under title deed 8205. The announced area is 2 rai 78 sq.wah, or 878 sq.wah (3,512 sq.m.).

SAM describes approximately thirty-eight metres along the western road side, approximately fifteen metres along the eastern public-irrigation-canal side and a maximum depth of approximately 102 metres. Buyers should verify the title deed, survey, plot shape, boundaries, canal and all measurements with the Land Office before offering.

The property fronts Chiang Mai-Hot Highway 108. SAM describes it as a public concrete road approximately sixteen metres wide within an approximately thirty-metre right of way. From Hang Dong, travel toward Doi Lo, pass Wat Si Lom and Chiang Mai-San Pa Tong Animal Hospital, then continue to around kilometre 20+140; the property is on the left.

Nearby places named by SAM include Chiang Mai Primary Educational Service Area Office 4, Wat Kantharam (Wat Thung O) and Kad Han Kaeo.

The source shows a white planning zone with a green diagonal border and explicitly states that the property is in a residential and commercial area. MapxProp therefore classifies the listing as mixed use and includes it in both homes and business discovery. This classification and the planning colour do not guarantee any intended construction, residential project or commercial operation. Buyers must confirm current planning controls, building regulations, access, drainage, parking, utilities and permits directly with the relevant authorities.

The SAM page listed the property for direct purchase at an announced THB 13,170,000, or THB 15,000 per sq.wah, when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, the current sale method, offer procedures, price, promotions, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: LL0072. MapxProp does not collect deposits or represent SAM in the transaction.

One source property photo displays 18 November 2022, while the other property photos do not display a capture date. Conditions may have changed. Buyers should arrange an inspection and verify vegetation, soil, drainage, flooding, boundaries, canal, access, utilities, encumbrances, taxes, costs and every current term before deciding.',
        'Vacant land on Chiang Mai-Hot Highway 108, San Klang',
        'Near kilometre 20+140',
        'Chiang Mai-Hot Highway 108',
        'San Klang',
        'San Pa Tong',
        'Chiang Mai',
        'SAM Mixed-Use Land on Highway 108, San Pa Tong, THB 13.17M',
        'Official SAM NPA asset LL0072: 3,512 sq.m. of L-shaped vacant land on Highway 108, classified for residential and business discovery. Direct-sale price THB 13.17M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset LL0072 mixed use vacant land San Klang San Pa Tong Chiang Mai Chiang Mai Hot Highway 108 2 rai 78 sq.wah 878 sq.wah 3512 sq.m. title deed 8205 residential commercial THB 13170000')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=22392&keyref=6004388'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=22392&keyref=6004388',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for LL0072. Specifications, title deed, images, rounded coordinates, announced price, direct-purchase status, road measurements, canal boundary, planning-zone wording and surrounding-use description come from that record.',
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
        'e793ff4a-9ffa-4255-8773-52e3807dec13',
        jsonb_build_object(
            'reference_code', 'LL0072',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'mixed',
            'discovery_channels', jsonb_build_array('homes', 'business'),
            'title_document_count', 1,
            'plot_count', 1,
            'public_irrigation_canal_boundary', true,
            'zoning_review_required', true,
            'source_image_count', 5
        )
    );
END $$;

COMMIT;
