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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing HL0947';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing HL0947';
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
        'ddd84f42-0482-4293-832d-c0edeaa07a10',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'detached_house',
        'residential',
        'sale',
        'whole_property',
        'ขายตรง SAM บ้านเดี่ยวชั้นเดียว วังไผ่ เมืองชุมพร 1 งาน 70 ตร.ว. ราคา 2.383 ล้านบาท',
        E'บ้านพักอาศัยตึกชั้นเดียว เลขที่ 246/2 ถนนสายนาแร่-สนามกีฬา ตำบลวังไผ่ อำเภอเมืองชุมพร จังหวัดชุมพร บนที่ดิน 1 งาน 70 ตร.ว. (170 ตร.ว. หรือ 680 ตร.ม.) โฉนดเลขที่ 70815 จำนวน 1 ฉบับ\n\nที่ดินรูปคล้ายสี่เหลี่ยมผืนผ้า ด้านทิศตะวันออกติดถนนสายนาแร่-สนามกีฬา หน้ากว้างประมาณ 26 เมตร ลึกสุดประมาณ 27 เมตร ถนนเป็นทางสาธารณประโยชน์ ผิวคอนกรีตกว้างประมาณ 5 เมตร เขตทางประมาณ 9 เมตร อยู่ในเขตผังเมืองสีเขียว ย่านที่อยู่อาศัยและเกษตรกรรม\n\nข้อมูลการรับโอนกรรมสิทธิ์ของ SAM ระบุสิ่งปลูกสร้างเป็นบ้านพักอาศัยตึกชั้นเดียวเลขที่ 246/2 และครัวไม่มีเลขที่ ส่วนผลสำรวจระบุบ้านพักอาศัยตึกชั้นเดียวและสิ่งปลูกสร้างเพิ่มเติมอีก 2 รายการ โดยสิ่งปลูกสร้างเพิ่มเติมทั้ง 2 รายการชำรุดทรุดโทรม ผังต้นทางระบุว่าไม่สามารถเข้าสำรวจภายในและไม่สามารถวัดขนาดอาคารได้ ผู้ซื้อจึงต้องตรวจสอบทะเบียนอาคาร ขอบเขต รายการที่จะโอน และสภาพจริงอย่างละเอียดก่อนเสนอซื้อ\n\nสำคัญ: SAM ระบุว่ามีผู้ใช้ประโยชน์ในทรัพย์สินและขายตามสภาพ ผู้ซื้อต้องตรวจสอบทรัพย์ก่อนเสนอซื้อ และอาจต้องเจรจาหรือดำเนินการทางกฎหมายเพื่อเข้าครอบครองด้วยค่าใช้จ่ายของผู้ซื้อเอง ไม่สามารถใช้ประเด็นการครอบครองเป็นเหตุยกเลิกการเสนอซื้อหรือสัญญา หรือเรียกร้องจาก SAM ได้ ข้อมูลหน้าต้นทางส่วนนี้ระบุ ณ วันที่ 4 สิงหาคม 2569 จึงต้องสอบถามสถานะล่าสุดกับ SAM\n\nการเดินทางจากถนนสายชุมพร-ระนอง (ทล.327) ฝั่งระนองมุ่งหน้าตัวเมืองชุมพร ผ่านแยกปฐมพร สำนักงานที่ดินวังไผ่ วัดคอออม วิทยาลัยการอาชีพชุมพร และวัดอุทัยธรรม จากนั้นเลี้ยวเข้าถนนสุขาภิบาลและถนนสายนาแร่-สนามกีฬา รวมประมาณ 1.3 กิโลเมตร ทรัพย์อยู่ด้านซ้ายมือ สถานที่สำคัญที่ SAM ระบุใกล้เคียง ได้แก่ วัดอุทัยธรรม โรงเรียนวัดดอนเมือง และวัดดอนเมือง\n\nหน้า SAM ระบุสถานะ “ซื้อตรง” และราคาประกาศขาย 2,383,000 บาท ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย สถานะผู้ใช้ประโยชน์ ขั้นตอนเสนอซื้อ รายการสิ่งปลูกสร้างที่จะโอน ค่าใช้จ่าย และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ HL0947 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nหน้าต้นทางไม่ระบุพื้นที่ใช้สอย จำนวนห้องนอน ห้องน้ำ ที่จอดรถ อายุอาคาร หรือสภาพภายใน ภาพต้นทางมีวันที่กำกับ 16 เมษายน 2569 ผู้ซื้อจึงควรนัดตรวจทรัพย์และตรวจสอบข้อมูล เอกสารสิทธิ์ ภาระผูกพัน แนวเขต และข้อกำหนดการใช้ประโยชน์ก่อนตัดสินใจ',
        2383000,
        false,
        680,
        1,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sale@sam.or.th',
        '@samline',
        true,
        true,
        'บ้านเลขที่ 246/2',
        'ย่านถนนสายนาแร่-สนามกีฬา',
        'ถนนสายนาแร่-สนามกีฬา',
        '86000',
        10.51651191,
        99.13352708,
        'ชุมพร',
        'เมืองชุมพร',
        'วังไผ่',
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
        'sam-direct-sale-single-storey-house-wang-phai-chumphon-hl0947'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 2383000, 'total', 'THB', false
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
        'detached_house',
        1,
        jsonb_build_object(
            'source_property_category', 'บ้านเดี่ยว',
            'house_number', '246/2',
            'land_area_ngan', 1,
            'land_area_square_wah', 70,
            'land_area_total_square_wah', 170,
            'land_area_sqm', 680,
            'title_deed_number', '70815',
            'title_document_count', 1,
            'floor_count', 1,
            'registered_transferred_structure_count', 2,
            'registered_transferred_structures', jsonb_build_array(
                'บ้านพักอาศัยตึกชั้นเดียว เลขที่ 246/2',
                'ครัว ไม่มีเลขที่'
            ),
            'surveyed_structure_count', 3,
            'surveyed_structure_description', 'บ้านพักอาศัยตึกชั้นเดียวและสิ่งปลูกสร้างเพิ่มเติมอีก 2 รายการ',
            'additional_surveyed_structure_count', 2,
            'additional_surveyed_structures_dilapidated', true,
            'interior_inspection_unavailable', true,
            'building_measurement_unavailable', true,
            'structure_records_require_buyer_review', true,
            'plot_shape', 'near_rectangle',
            'east_road_frontage_m', 26,
            'maximum_depth_m', 27,
            'zoning_color_th', 'สีเขียว',
            'access_type', 'public_road',
            'front_road_name', 'ถนนสายนาแร่-สนามกีฬา',
            'front_road_surface', 'concrete',
            'front_road_width_m', 5,
            'front_right_of_way_width_m', 9,
            'property_has_current_user', true,
            'occupancy_information_dated_on', '2026-08-04',
            'sold_as_is', true,
            'buyer_responsible_for_obtaining_possession', true,
            'usable_area_not_published', true,
            'bedroom_count_not_published', true,
            'bathroom_count_not_published', true,
            'parking_information_not_published', true,
            'building_age_not_published', true,
            'interior_condition_not_published', true,
            'source_photo_date_displayed', '2026-04-16',
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'source_status_at_import', 'direct_purchase',
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for HL0947. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนสายชุมพร-ระนอง (ทล.327)', 'Chumphon-Ranong Road (Highway 327)', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'วิทยาลัยการอาชีพชุมพร', 'Chumphon Industrial and Community Education College', 'education', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'วัดอุทัยธรรม', 'Wat Uthai Tham', 'landmark', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'โรงเรียนวัดดอนเมือง', 'Wat Don Mueang School', 'education', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'วัดดอนเมือง', 'Wat Don Mueang', 'landmark', NULL, NULL, NULL, 50, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '2,383,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 2,383,000 — confirm the latest price with SAM', 'unspecified', 2383000, 'THB', 20),
        (property_listing_id, 'occupancy_and_possession', 'ผู้ใช้ประโยชน์และการเข้าครอบครอง', 'Current user and possession', 'มีผู้ใช้ประโยชน์ในทรัพย์ ผู้ซื้อรับผิดชอบการเจรจาหรือดำเนินการทางกฎหมายและค่าใช้จ่ายเพื่อเข้าครอบครองเอง', 'The property has a current user; the buyer is responsible for negotiations or legal action and the costs of obtaining possession', 'buyer', NULL, '', 30),
        (property_listing_id, 'structure_records_and_condition', 'รายการและสภาพสิ่งปลูกสร้าง', 'Structure records and condition', 'รายการรับโอนระบุบ้านชั้นเดียวและครัว ส่วนผลสำรวจพบสิ่งปลูกสร้างเพิ่มเติม 2 รายการที่ชำรุดทรุดโทรม และไม่สามารถสำรวจภายในหรือวัดขนาดอาคารได้ ผู้ซื้อต้องตรวจสอบเอกสารกับสภาพจริง', 'Acquisition records identify a single-storey house and kitchen; the survey found two additional dilapidated structures and could not inspect interiors or measure the buildings. Buyers must verify records against actual conditions.', 'unspecified', NULL, '', 40),
        (property_listing_id, 'sold_as_is', 'สภาพการขาย', 'Sale condition', 'ขายตามสภาพที่เป็นอยู่ ผู้ซื้อต้องตรวจสอบทรัพย์ก่อนเสนอซื้อ', 'Sold as is; buyers must inspect the property before submitting an offer', 'unspecified', NULL, '', 50)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ด้านหน้าบ้านและแนวเขต', 'บ้านพักอาศัยชั้นเดียวเลขที่ 246/2 พร้อมแนวเขตติดถนนสายนาแร่-สนามกีฬา', 'https://npa.sam.or.th/site/images/npa/23275/20260513112814_HL0947P2_69.jpg', '/listing-media/sam/hl0947/01.webp', 'image/webp', 23482, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บ้านและพื้นที่ด้านหน้า', 'ภาพมุมกว้างของบ้านชั้นเดียวและพื้นที่สวนด้านหน้าทรัพย์', 'https://npa.sam.or.th/site/images/npa/23275/HL0947P3_69.jpg', '/listing-media/sam/hl0947/02.webp', 'image/webp', 20272, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวถนนหน้าทรัพย์', 'ภาพบ้านและแนวที่ดินริมถนนคอนกรีตสายนาแร่-สนามกีฬา', 'https://npa.sam.or.th/site/images/npa/23275/HL0947P4_69.jpg', '/listing-media/sam/hl0947/03.webp', 'image/webp', 20032, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมด้านข้างแปลง', 'ภาพแนวเขตและสิ่งปลูกสร้างด้านข้างของบ้าน', 'https://npa.sam.or.th/site/images/npa/23275/HL0947P5_69.jpg', '/listing-media/sam/hl0947/04.webp', 'image/webp', 17358, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้าจากถนนชุมพร-ระนอง', 'จุดเลี้ยวจากถนนสายชุมพร-ระนองทางหลวง 327 เข้าถนนสายนาแร่-สนามกีฬา', 'https://npa.sam.or.th/site/images/npa/23275/HL0947P1_69.jpg', '/listing-media/sam/hl0947/05.webp', 'image/webp', 21172, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังรูปแปลงที่ดิน', 'ผังโฉนดเลขที่ 70815 แสดงแนวถนนและขนาดแปลงโดยประมาณ', 'https://npa.sam.or.th/site/images/npa/23275/20260513112814_HL0947C2_69.jpg', '/listing-media/sam/hl0947/06.webp', 'image/webp', 11272, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังสิ่งปลูกสร้าง', 'ผังแสดงบ้านพักอาศัยชั้นเดียวและสิ่งปลูกสร้างเพิ่มเติม 2 รายการในแปลง', 'https://npa.sam.or.th/site/images/npa/23275/20260513112814_HL0947C1_69.jpg', '/listing-media/sam/hl0947/07.webp', 'image/webp', 18510, 450, 450, 70, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?ref=71603629&id=23275',
        'HL0947',
        '2026-09-09 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 2,383,000 for a single-storey detached house on 170 sq.wah. The page states that the property has a current user and is sold as is; the buyer bears responsibility and costs for obtaining possession. SAM acquisition records identify the house and a kitchen, while the survey identifies two additional dilapidated structures. The source diagram states that interiors could not be inspected and building dimensions could not be measured. Source property information is dated 4 August 2026, while the source photos display 16 April 2026. Usable area, room counts, parking, building age, and interior condition are not published. Administrator-supplied coordinates are within approximately one meter of the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all seven source property and diagram images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Single-Storey House in Wang Phai, Chumphon, 170 Sq.Wah, THB 2.383M',
        E'Single-storey detached house, no. 246/2, on Na Rae-Sanam Kila Road in Wang Phai, Mueang Chumphon, Chumphon. Title deed no. 70815 covers 1 ngan 70 sq.wah (170 sq.wah or 680 sq.m.).\n\nThe near-rectangular plot has approximately 26 meters of east-facing road frontage and a maximum depth of approximately 27 meters. Na Rae-Sanam Kila Road is a public concrete road approximately 5 meters wide within an approximately 9-meter right of way. The source identifies green zoning in a residential and agricultural area.\n\nSAM''s acquisition record identifies a single-storey residence, no. 246/2, and an unnumbered kitchen. The condition survey describes the house and two additional structures, both of which are dilapidated. The source diagram states that interiors could not be inspected and the building dimensions could not be measured. Buyers must verify building records, transfer scope, boundaries, and actual conditions before submitting an offer.\n\nImportant: SAM states that the property has a current user and is sold as is. The buyer must inspect before submitting an offer and may need to negotiate or take legal action to obtain possession at the buyer''s own cost. Occupancy cannot be used to cancel an offer or agreement or to make claims against SAM. This source information is dated 4 August 2026, so the current status must be reconfirmed.\n\nAccess is from Chumphon-Ranong Road (Highway 327) toward Chumphon, passing Pathom Phon Intersection, the Wang Phai Land Office, Wat Kho Om, Chumphon Industrial and Community Education College, and Wat Uthai Tham. Turn onto Sukhaphiban Road and then Na Rae-Sanam Kila Road; the property is on the left after approximately 1.3 kilometers. Nearby destinations listed by SAM include Wat Uthai Tham, Wat Don Mueang School, and Wat Don Mueang.\n\nThe SAM page lists the property as direct purchase with an announced sale price of THB 2,383,000. It is not an auction. Contact SAM directly to confirm availability, current occupancy, offer procedures, structures included in the transfer, expenses, and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: HL0947. MapxProp does not collect deposits or represent SAM in the transaction.\n\nThe source does not publish usable area, bedroom or bathroom counts, parking, building age, or interior condition. The source photos display 16 April 2026. Buyers should arrange an inspection and verify title documents, encumbrances, boundaries, permitted use, and property condition before deciding.',
        'House No. 246/2',
        'Na Rae-Sanam Kila Road Area',
        'Na Rae-Sanam Kila Road',
        'Wang Phai',
        'Mueang Chumphon',
        'Chumphon',
        'SAM Direct-Sale House in Wang Phai, Chumphon, THB 2.383M',
        'Official SAM NPA asset HL0947: a single-storey house on 680 sq.m. in Wang Phai, Chumphon. Direct-sale price THB 2.383M; current user and dilapidated ancillary structures disclosed.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset HL0947 single storey detached house Wang Phai Mueang Chumphon Chumphon Na Rae Sanam Kila 1 ngan 70 sq.wah 170 sq.wah 680 sq.m. title deed 70815 THB 2383000')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?ref=71603629&id=23275'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?ref=71603629&id=23275',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for HL0947. The specifications, images, rounded coordinates, announced price, direct-purchase status, occupancy warning, and structure-condition notes come from that record.',
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
        'ddd84f42-0482-4293-832d-c0edeaa07a10',
        jsonb_build_object(
            'reference_code', 'HL0947',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'occupancy_warning', true,
            'dilapidated_ancillary_structures', true
        )
    );
END $$;

COMMIT;
