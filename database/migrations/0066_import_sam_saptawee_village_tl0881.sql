BEGIN;

DO $$
DECLARE
    admin_user_id bigint;
    sam_organization_id bigint;
    saptawee_project_id bigint;
    property_listing_id bigint;
BEGIN
    SELECT id INTO admin_user_id
    FROM public.auth_users
    WHERE lower(email) = 'mapxprop@gmail.com'
      AND deleted_at IS NULL
    ORDER BY id
    LIMIT 1;

    IF admin_user_id IS NULL THEN
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing TL0881';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing TL0881';
    END IF;

    INSERT INTO public.property_projects (
        public_project_id,
        slug,
        project_category,
        name_th,
        name_en,
        supported_property_types,
        description_th,
        description_en,
        address_line1,
        road,
        subdistrict_name,
        district_name,
        province_name,
        postal_code,
        latitude,
        longitude,
        source_url,
        verification_status,
        verification_note,
        metadata
    ) VALUES (
        '9e5df2f2-d219-4a32-b3fd-273ccc6564d5',
        'saptawee-village-pracha-uthit-90',
        'housing_estate',
        'ทรัพย์ทวี วิลเลจ',
        'Saptawee Village Pracha Uthit 90',
        ARRAY['townhouse'],
        'โครงการทาวน์โฮมในซอยประชาอุทิศ 90 ตำบลนาเกลือ อำเภอพระสมุทรเจดีย์ จังหวัดสมุทรปราการ ถนนภายในโครงการเป็นถนนคอนกรีตกว้างประมาณ 6 เมตร เขตทางประมาณ 8 เมตร',
        'A townhouse development off Pracha Uthit Soi 90 in Na Kluea, Phra Samut Chedi, Samut Prakan. The internal concrete road is approximately 6 meters wide within an 8-meter right of way.',
        '888 ทรัพย์ทวี วิลเลจ ซอยประชาอุทิศ 90',
        'ถนนประชาอุทิศ',
        'นาเกลือ',
        'พระสมุทรเจดีย์',
        'สมุทรปราการ',
        '10290',
        13.5827571,
        100.5038942,
        'https://www.sam.or.th/site/npa/detail.php?id=23627',
        'source_checked',
        'Project name, location, housing type, and internal-road details were cross-checked against the official SAM TL0881 record and matching public project records. Coordinates use the administrator-supplied property position as an approximate project point.',
        jsonb_build_object(
            'location_precision', 'approximate_project_point_from_listed_unit',
            'known_home_types', jsonb_build_array('two_storey_townhouse'),
            'alternate_english_spelling', 'Suptawee Village',
            'internal_road_surface', 'concrete',
            'internal_road_width_m', 6,
            'internal_right_of_way_width_m', 8
        )
    )
    ON CONFLICT (slug) DO UPDATE SET
        project_category = EXCLUDED.project_category,
        name_th = EXCLUDED.name_th,
        name_en = EXCLUDED.name_en,
        supported_property_types = EXCLUDED.supported_property_types,
        description_th = EXCLUDED.description_th,
        description_en = EXCLUDED.description_en,
        address_line1 = EXCLUDED.address_line1,
        road = EXCLUDED.road,
        subdistrict_name = EXCLUDED.subdistrict_name,
        district_name = EXCLUDED.district_name,
        province_name = EXCLUDED.province_name,
        postal_code = EXCLUDED.postal_code,
        latitude = EXCLUDED.latitude,
        longitude = EXCLUDED.longitude,
        source_url = EXCLUDED.source_url,
        verification_status = EXCLUDED.verification_status,
        verification_note = EXCLUDED.verification_note,
        metadata = EXCLUDED.metadata,
        is_active = true,
        deleted_at = NULL,
        updated_at = now()
    RETURNING id INTO saptawee_project_id;

    INSERT INTO public.property_project_aliases (
        project_id, locale, alias_name, alias_type
    ) VALUES
        (saptawee_project_id, 'th', 'ทรัพย์ทวี วิลเลจ', 'official'),
        (saptawee_project_id, 'th', 'ทรัพย์ทวีวิลเลจ', 'alternate'),
        (saptawee_project_id, 'th', 'ทรัพย์ทวี วิลเลจ ประชาอุทิศ 90', 'alternate'),
        (saptawee_project_id, 'en', 'Saptawee Village Pracha Uthit 90', 'official'),
        (saptawee_project_id, 'en', 'Suptawee Village', 'alternate')
    ON CONFLICT (project_id, locale, normalized_alias) DO NOTHING;

    INSERT INTO public.listings (
        public_listing_id,
        user_id,
        organization_id,
        created_by_user_id,
        published_by_user_id,
        project_id,
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
        'f555d350-ded5-41e5-ab2a-83bcdf213587',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        saptawee_project_id,
        'townhouse',
        'residence',
        'sale',
        'whole_property',
        'ทรัพย์ทวี วิลเลจ',
        '888/223',
        'ทรัพย์ประมูล SAM ทาวน์เฮ้าส์ 2 ชั้น ทรัพย์ทวี วิลเลจ 19.5 ตร.ว. ราคาอ้างอิง 1.47 ล้านบาท',
        E'ทาวน์เฮ้าส์ 2 ชั้น เลขที่ 888/223 ในโครงการทรัพย์ทวี วิลเลจ ถนนบุญเลิศพัฒนา ตำบลนาเกลือ อำเภอพระสมุทรเจดีย์ จังหวัดสมุทรปราการ\n\nที่ดิน 19.5 ตร.ว. (78 ตร.ม.) รูปสี่เหลี่ยมผืนผ้า หน้ากว้างประมาณ 6 เมตร ลึกประมาณ 13 เมตร เอกสารสิทธิ์โฉนดที่ดินเลขที่ 40153 จำนวน 1 ฉบับ ด้านทิศเหนือติดถนนคอนกรีตภายในโครงการซึ่งกว้างประมาณ 6 เมตร เขตทางประมาณ 8 เมตร และอยู่ในเขตผังเมืองสีเหลือง\n\nการเดินทางจากถนนประชาอุทิศมุ่งหน้าไปวัดคู่สร้าง ผ่านโรงเรียนวัดทุ่งครุและวัดทุ่งครุ บริเวณบิ๊กซี ฟู้ดเพลส ประชาอุทิศ เข้าซอยประชาอุทิศ 90 ประมาณ 3.4 กม. เลี้ยวเข้าถนนบุญเลิศพัฒนาประมาณ 770 เมตร แล้วเข้าโครงการอีกประมาณ 400 เมตร ทรัพย์อยู่ด้านขวามือ\n\nสำคัญ: หน้า SAM ระบุราคาประกาศ 1,470,000 บาท และสถานะ “ประมูล” ไม่ใช่ราคาซื้อได้ทันที รอบที่เผยแพร่เปิดลงทะเบียนและยื่นซองวันที่ 1–15 กันยายน 2569 และกำหนดเปิดซองวันที่ 22 กันยายน 2569 เวลา 10.00 น. ณ สำนักงานใหญ่ SAM พร้อมถ่ายทอดสด ตามข้อมูลที่ตรวจสอบเมื่อ 9 กันยายน 2569 ราคาบน MapxProp จึงเป็นราคาอ้างอิงจากประกาศ ไม่ใช่ราคาขายสุดท้าย\n\nผู้สนใจต้องติดต่อ SAM โดยตรงก่อนดำเนินการ โดยเฉพาะการยื่นซองทาง EMS และควรตรวจสอบสถานะทรัพย์ เอกสาร ขั้นตอน สถานที่ และเงื่อนไขล่าสุด: ฝ่ายบริหารการจำหน่ายทรัพย์ NPA โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ TL0881 ทั้งนี้ MapxProp ไม่ได้รับยื่นซองและไม่ได้เป็นตัวแทนของ SAM ในการประมูล\n\nผู้ซื้อควรตรวจสอบสภาพทรัพย์ เอกสารสิทธิ์ สิ่งปลูกสร้าง ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขทั้งหมดกับ SAM ก่อนตัดสินใจ',
        1470000,
        false,
        78,
        2,
        'ฝ่ายบริหารการจำหน่ายทรัพย์ NPA — SAM',
        '026861888',
        '1443',
        'sale@sam.or.th',
        '@samline',
        true,
        true,
        '888/223 ทรัพย์ทวี วิลเลจ',
        'ซอยประชาอุทิศ 90',
        'ถนนบุญเลิศพัฒนา',
        '10290',
        13.58275715,
        100.50389422,
        'สมุทรปราการ',
        'พระสมุทรเจดีย์',
        'นาเกลือ',
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
        'sam-auction-townhouse-saptawee-village-tl0881'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 1470000, 'total', 'THB', false
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
        'townhouse',
        1,
        jsonb_build_object(
            'land_area_square_wah', 19.5,
            'storey_count', 2,
            'source_property_category', 'ทาวน์เฮ้าส์',
            'legal_building_description', 'ทาวน์เฮ้าส์สองชั้น เลขที่ 888/223',
            'title_deed_number', '40153',
            'title_document_count', 1,
            'plot_shape', 'rectangle',
            'frontage_m', 6,
            'maximum_depth_m', 13,
            'road_facing_direction', 'north',
            'zoning_color_th', 'สีเหลือง',
            'front_road_surface', 'concrete',
            'front_road_width_m', 6,
            'front_right_of_way_width_m', 8,
            'purchase_method', 'sealed_bid_auction',
            'published_price_kind', 'announced_reference_price',
            'auction_registration_starts_on', '2026-09-01',
            'auction_registration_ends_on', '2026-09-15',
            'auction_opening_at', '2026-09-22T10:00:00+07:00',
            'auction_opening_venue', 'SAM headquarters',
            'auction_livestream_announced', true,
            'auction_round_status_at_import', 'registration_open',
            'source_status_at_import', 'auction',
            'status_checked_on', '2026-09-09'
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
        'The official SAM NPA record identifies SAM as the asset holder and sole direct contact for TL0881. MapxProp does not collect bids or represent SAM in the auction.',
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
        (property_listing_id, 'ถนนวงแหวนรอบนอก', 'Outer Ring Road', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ทางด่วนเฉลิมพระเกียรติ', 'Chaloem Phra Kiat Expressway', 'road', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'โรงพยาบาลส่งเสริมสุขภาพตำบลคลองกระออม', 'Khlong Kra Om Subdistrict Health Promoting Hospital', 'healthcare', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'โลตัส โกเฟรช บ้านคลองสวน สมุทรปราการ', 'Lotus''s Go Fresh Ban Khlong Suan Samut Prakan', 'shopping', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'มินิบิ๊กซี ประชาอุทิศ 90', 'Mini Big C Pracha Uthit 90', 'shopping', NULL, NULL, NULL, 50, true),
        (property_listing_id, 'โรงเรียนสารสาสน์วิเทศศึกษา', 'Sarasas Witaed Suksa School', 'education', NULL, NULL, NULL, 60, false),
        (property_listing_id, 'โรงเรียนสารสาสน์ประชาอุทิศพิทยาคาร', 'Sarasas Pracha Uthit Pitthayakarn School', 'education', NULL, NULL, NULL, 70, false)
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
        (property_listing_id, 'sale_method', 'วิธีจำหน่าย', 'Sale method', 'ประมูลยื่นซอง — ติดต่อ SAM โดยตรง', 'Sealed-bid auction — contact SAM directly', 'unspecified', NULL, '', 10),
        (property_listing_id, 'announced_reference_price', 'ราคาประกาศอ้างอิง', 'Announced reference price', '1,470,000 บาท (ไม่ใช่ราคาขายสุดท้าย)', 'THB 1,470,000 (not the final sale price)', 'unspecified', 1470000, 'THB', 20),
        (property_listing_id, 'auction_registration_period', 'ช่วงลงทะเบียนและยื่นซอง', 'Registration and bid-submission period', '1–15 กันยายน 2569 (เปิดรับ ณ วันที่ตรวจสอบ 9 กันยายน 2569)', '1–15 September 2026 (open on the 9 September 2026 review date)', 'unspecified', NULL, '', 30),
        (property_listing_id, 'auction_ems_submission', 'การยื่นซองทาง EMS', 'EMS bid submission', 'ต้องติดต่อเจ้าหน้าที่ SAM ก่อนดำเนินการ', 'Contact a SAM officer before submitting by EMS', 'unspecified', NULL, '', 40),
        (property_listing_id, 'auction_opening', 'กำหนดเปิดซอง', 'Bid opening', '22 กันยายน 2569 เวลา 10.00 น. ณ สำนักงานใหญ่ SAM พร้อมถ่ายทอดสดตามประกาศ', '22 September 2026 at 10:00 at SAM headquarters, with a livestream announced by SAM', 'unspecified', NULL, '', 50)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ด้านหน้าทรัพย์', 'ด้านหน้าทาวน์เฮ้าส์ 2 ชั้น เลขที่ 888/223 ทรัพย์ทวี วิลเลจ', 'https://npa.sam.or.th/site/images/npa/23627/20260831125148_TL0881P2_69.jpg', '/listing-media/sam/tl0881/01.webp', 'image/webp', 44556, 720, 540, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ถนนหน้าทรัพย์', 'มุมถนนคอนกรีตภายในโครงการและตำแหน่งทาวน์เฮ้าส์', 'https://npa.sam.or.th/site/images/npa/23627/TL0881P1_69.jpg', '/listing-media/sam/tl0881/02.webp', 'image/webp', 53724, 720, 400, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บริเวณชั้นล่างด้านหน้า', 'ประตูทางเข้าและหน้าต่างชั้นล่างของทาวน์เฮ้าส์', 'https://npa.sam.or.th/site/images/npa/23627/TL0881P3_69.jpg', '/listing-media/sam/tl0881/03.webp', 'image/webp', 43234, 720, 540, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมด้านข้างหน้าทรัพย์', 'ผนังและหน้าต่างชั้นล่างด้านหน้าทาวน์เฮ้าส์', 'https://npa.sam.or.th/site/images/npa/23627/TL0881P4_69.jpg', '/listing-media/sam/tl0881/04.webp', 'image/webp', 64246, 720, 540, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ด้านหน้าชั้นสอง', 'ระเบียงและหน้าต่างชั้นสองของทาวน์เฮ้าส์', 'https://npa.sam.or.th/site/images/npa/23627/TL0881P5_69.jpg', '/listing-media/sam/tl0881/05.webp', 'image/webp', 38524, 720, 540, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังตำแหน่งทรัพย์ในโครงการ', 'ผังโครงการทรัพย์ทวี วิลเลจ แสดงตำแหน่งทาวน์เฮ้าส์', 'https://npa.sam.or.th/site/images/npa/23627/TL0881C1_69.jpg', '/listing-media/sam/tl0881/06.webp', 'image/webp', 36748, 785, 600, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังรูปแปลงที่ดิน', 'ผังโฉนดเลขที่ 40153 แสดงหน้ากว้าง 6 เมตรและความลึก 13 เมตร', 'https://npa.sam.or.th/site/images/npa/23627/20260831125148_TL0881C2_69.jpg', '/listing-media/sam/tl0881/07.webp', 'image/webp', 11028, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังตำแหน่งสิ่งปลูกสร้าง', 'ผังตำแหน่งทาวน์เฮ้าส์ 2 ชั้นภายในแปลงทรัพย์', 'https://npa.sam.or.th/site/images/npa/23627/20260831125148_TL0881C3_69.jpg', '/listing-media/sam/tl0881/08.webp', 'image/webp', 13670, 450, 450, 80, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=23627',
        'TL0881',
        '2026-09-09 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed auction status and a THB 1,470,000 announced price. Registration and sealed-bid submission were open from 1 to 15 September 2026, with bid opening scheduled for 22 September 2026 at 10:00 at SAM headquarters. The registration round was open at capture time. Interested parties must contact SAM directly, including before any EMS submission. Administrator-supplied coordinates differ from the rounded source coordinates by less than one meter and are used for the listing. MapxProp stores optimized copies of all eight source property and diagram images without adding a MapxProp watermark.'
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
        'SAM Auction Asset: Two-Storey Townhouse at Saptawee Village, 19.5 sq.wah, THB 1.47M Reference Price',
        E'Two-storey townhouse, house no. 888/223, at Saptawee Village on Bun Loet Phatthana Road, Na Kluea, Phra Samut Chedi, Samut Prakan.\n\nThe rectangular 19.5 sq.wah (78 sq.m.) plot has approximately 6 meters of frontage and a maximum depth of 13 meters. It has one title deed, no. 40153. The north side faces the project''s concrete road, approximately 6 meters wide within an 8-meter right of way. The source identifies the zoning color as yellow.\n\nAccess is from Pracha Uthit Road via Pracha Uthit Soi 90 and Bun Loet Phatthana Road. Nearby destinations listed by SAM include the Outer Ring Road, Chaloem Phra Kiat Expressway, Khlong Kra Om Subdistrict Health Promoting Hospital, Lotus''s Go Fresh Ban Khlong Suan, Mini Big C Pracha Uthit 90, and two Sarasas schools.\n\nImportant: SAM lists an announced price of THB 1,470,000 and the status as “auction.” This is not an immediate-purchase or final sale price. The published round accepts registrations and sealed bids from 1 to 15 September 2026. Bid opening is scheduled for 22 September 2026 at 10:00 at SAM headquarters, with a livestream announced by SAM. Registration was open on MapxProp''s 9 September 2026 capture date.\n\nInterested parties must contact SAM directly before proceeding, especially before submitting a bid by EMS, and should confirm current availability, documents, process, venue, and latest terms. SAM NPA Asset Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: TL0881. MapxProp does not accept bids or represent SAM in the auction.\n\nBuyers should verify the property condition, title documents, structures, encumbrances, expenses, and all terms with SAM before making a decision.',
        '888/223 Saptawee Village',
        'Pracha Uthit Soi 90',
        'Bun Loet Phatthana Road',
        'Na Kluea',
        'Phra Samut Chedi',
        'Samut Prakan',
        'SAM Auction Townhouse, Saptawee Village, THB 1.47M Reference Price',
        'Official SAM NPA asset TL0881: a two-storey townhouse on 19.5 sq.wah in Saptawee Village. THB 1.47M is the auction reference price; registration closes 15 September 2026.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM auction asset TL0881 two-storey townhouse Saptawee Suptawee Village Pracha Uthit 90 Na Kluea Phra Samut Chedi Samut Prakan 19.5 sq.wah 78 sq.m. THB 1470000 reference price')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=23627'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=23627',
            'The official SAM NPA record identifies SAM as the asset holder and direct sales contact for TL0881. The property specifications, images, coordinates, announced reference price, auction method, and published schedule come from that record.',
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
        'f555d350-ded5-41e5-ab2a-83bcdf213587',
        jsonb_build_object(
            'reference_code', 'TL0881',
            'sale_method', 'sealed_bid_auction',
            'auction_round_status_at_import', 'registration_open'
        )
    );
END $$;

COMMIT;
