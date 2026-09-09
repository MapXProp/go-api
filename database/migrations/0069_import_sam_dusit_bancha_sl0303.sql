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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing SL0303';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing SL0303';
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
        '3bc59986-837b-43ca-a6d0-424984561172',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'shophouse',
        'mixed',
        'sale',
        'whole_property',
        'ขายตรง SAM อาคารพาณิชย์ 3 ชั้น 2 คูหา ดุสิตบัญชา ชุมพร ราคา 2.984 ล้านบาท',
        E'อาคารพาณิชย์ 3 ชั้น จำนวน 2 คูหา เจาะทะลุถึงกัน ในโครงการดุสิตบัญชา เลขที่ 55/33 และ 55/34 ตำบลบ้านนา อำเภอเมืองชุมพร จังหวัดชุมพร ที่ดินรวม 43.8 ตร.ว. (175.2 ตร.ม.) เอกสารสิทธิ์เป็นโฉนดเลขที่ 29995 และ 30035 จำนวน 2 ฉบับ\n\nแปลงที่ดินรูปสี่เหลี่ยมผืนผ้า ด้านทิศใต้ติดถนนภายในโครงการดุสิตบัญชา หน้ากว้างประมาณ 8 เมตร ลึกสุดประมาณ 21.9 เมตร อยู่ในเขตผังเมืองสีชมพู ถนนหน้าทรัพย์เป็นทางสาธารณประโยชน์ ผิวคอนกรีตกว้างประมาณ 20 เมตร เขตทางประมาณ 24 เมตร เหมาะสำหรับพิจารณาใช้เป็นหน้าร้าน สำนักงาน ที่พักอาศัย หรือการใช้งานแบบผสม ทั้งนี้ผู้ซื้อต้องตรวจสอบข้อกำหนดและความเหมาะสมกับกิจการจริง\n\nข้อมูลการรับโอนกรรมสิทธิ์ของ SAM ระบุสิ่งปลูกสร้างเป็นตึกแถวสามชั้นเลขที่ 55/33 และตึกแถวสามชั้นเลขที่ 55/34 ส่วนการสำรวจสภาพระบุเป็นอาคารพาณิชย์ 3 ชั้น จำนวน 2 คูหาเจาะทะลุถึงกัน ผู้ซื้อควรตรวจสอบเอกสารสิทธิ์ ทะเบียนอาคาร ขอบเขต และสภาพจริงก่อนเสนอซื้อ\n\nสำคัญ: SAM ระบุว่ามีผู้ใช้ประโยชน์ในทรัพย์สินและขายตามสภาพ ผู้ซื้อต้องตรวจสอบทรัพย์ก่อนเสนอซื้อ และอาจต้องเจรจาหรือดำเนินการทางกฎหมายเพื่อเข้าครอบครองด้วยค่าใช้จ่ายของผู้ซื้อเอง ไม่สามารถใช้ประเด็นการครอบครองเป็นเหตุยกเลิกการเสนอซื้อหรือสัญญา หรือเรียกร้องจาก SAM ได้ ข้อมูลหน้าต้นทางส่วนนี้ระบุ ณ วันที่ 4 สิงหาคม 2569 จึงต้องสอบถามสถานะล่าสุดกับ SAM\n\nการเดินทางจากถนนสายเอเชีย (ทล.41) ฝั่งอำเภอท่าแซะมุ่งหน้าอำเภอหลังสวน ผ่านสี่แยกปฐมพรและการไฟฟ้าส่วนภูมิภาคจังหวัดชุมพร ถึงบริเวณ กม. 1+956 แล้วเลี้ยวเข้าถนนดุสิตบัญชาประมาณ 160 เมตร ทรัพย์อยู่ด้านซ้ายมือ สถานที่สำคัญที่ SAM ระบุใกล้เคียง ได้แก่ สำนักงานที่ดินจังหวัดชุมพร สำนักงานเขตพื้นที่การศึกษาชุมพร เขต 1 วัดถ้ำเขาขุนกระทิง และไปรษณีย์ไทยจังหวัดชุมพร\n\nหน้า SAM ระบุสถานะ “ซื้อตรง” และราคาประกาศขาย 2,984,000 บาท ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย สถานะผู้ใช้ประโยชน์ ขั้นตอนเสนอซื้อ ค่าใช้จ่าย และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ SL0303 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nหน้าต้นทางไม่ระบุพื้นที่ใช้สอยภายใน จำนวนห้องนอน ห้องน้ำ ที่จอดรถ ระบบสาธารณูปโภค หรือสภาพภายในโดยละเอียด ภาพต้นทางมีวันที่กำกับ 30 ตุลาคม 2566 ผู้ซื้อจึงควรนัดตรวจทรัพย์และตรวจสอบข้อมูล เอกสารสิทธิ์ ภาระผูกพัน แนวเขต และข้อกำหนดการใช้ประโยชน์ก่อนตัดสินใจ',
        2984000,
        false,
        175.2,
        3,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sale@sam.or.th',
        '@samline',
        true,
        true,
        '55/33 และ 55/34 โครงการดุสิตบัญชา',
        'ใกล้ถนนสายเอเชีย (ทล.41)',
        'ถนนดุสิตบัญชา',
        '86190',
        10.49356531,
        99.12303225,
        'ชุมพร',
        'เมืองชุมพร',
        'บ้านนา',
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
        'sam-direct-sale-two-unit-shophouse-dusit-bancha-chumphon-sl0303'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES
        (property_listing_id, 'residential'),
        (property_listing_id, 'retail')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 2984000, 'total', 'THB', false
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
        (property_listing_id, 'business', 'editorial', false),
        (property_listing_id, 'homes', 'editorial', false)
    ON CONFLICT (listing_id, channel_code) DO UPDATE SET
        source = EXCLUDED.source,
        is_featured = EXCLUDED.is_featured,
        updated_at = now();

    INSERT INTO public.listing_category_details (
        listing_id, category_code, schema_version, details, is_minimum_submission
    ) VALUES (
        property_listing_id,
        'shophouse',
        1,
        jsonb_build_object(
            'source_property_category', 'อาคารพาณิชย์',
            'project_name', 'ดุสิตบัญชา',
            'land_area_square_wah', 43.8,
            'land_area_sqm', 175.2,
            'title_deed_numbers', jsonb_build_array('29995', '30035'),
            'title_document_count', 2,
            'floor_count', 3,
            'unit_count', 2,
            'units_connected_internally', true,
            'registered_transferred_structure_count', 2,
            'registered_transferred_structures', jsonb_build_array(
                'ตึกแถวสามชั้น เลขที่ 55/33',
                'ตึกแถวสามชั้น เลขที่ 55/34'
            ),
            'surveyed_structure_count', 2,
            'surveyed_structure_description', 'อาคารพาณิชย์ 3 ชั้น จำนวน 2 คูหา เจาะทะลุถึงกัน',
            'structure_records_require_buyer_review', true,
            'plot_shape', 'rectangle',
            'south_road_frontage_m', 8,
            'maximum_depth_m', 21.9,
            'zoning_color_th', 'สีชมพู',
            'access_type', 'public_road',
            'front_road_name', 'ถนนภายในโครงการดุสิตบัญชา',
            'front_road_surface', 'concrete',
            'front_road_width_m', 20,
            'front_right_of_way_width_m', 24,
            'property_has_current_user', true,
            'occupancy_information_dated_on', '2026-08-04',
            'sold_as_is', true,
            'buyer_responsible_for_obtaining_possession', true,
            'usable_area_not_published', true,
            'bedroom_count_not_published', true,
            'bathroom_count_not_published', true,
            'parking_information_not_published', true,
            'interior_condition_not_published', true,
            'source_photo_date_displayed', '2023-10-30',
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for SL0303. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนสายเอเชีย (ทล.41)', 'Asian Highway (Highway 41)', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'สำนักงานที่ดินจังหวัดชุมพร', 'Chumphon Provincial Land Office', 'government', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'สำนักงานเขตพื้นที่การศึกษาชุมพร เขต 1', 'Chumphon Primary Educational Service Area Office 1', 'education', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'วัดถ้ำเขาขุนกระทิง', 'Wat Tham Khao Khun Krathing', 'landmark', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'ไปรษณีย์ไทยจังหวัดชุมพร', 'Thailand Post, Chumphon', 'government', NULL, NULL, NULL, 50, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '2,984,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 2,984,000 — confirm the latest price with SAM', 'unspecified', 2984000, 'THB', 20),
        (property_listing_id, 'occupancy_and_possession', 'ผู้ใช้ประโยชน์และการเข้าครอบครอง', 'Current user and possession', 'มีผู้ใช้ประโยชน์ในทรัพย์ ผู้ซื้อรับผิดชอบการเจรจาหรือดำเนินการทางกฎหมายและค่าใช้จ่ายเพื่อเข้าครอบครองเอง', 'The property has a current user; the buyer is responsible for negotiations or legal action and the costs of obtaining possession', 'buyer', NULL, '', 30),
        (property_listing_id, 'registered_structure_transfer', 'สิ่งปลูกสร้างตามรายการรับโอน', 'Structures in acquisition records', 'รายการรับโอนระบุตึกแถวสามชั้นเลขที่ 55/33 และ 55/34 ส่วนผลสำรวจระบุอาคารพาณิชย์ 3 ชั้น 2 คูหาเจาะทะลุถึงกัน ผู้ซื้อต้องตรวจสอบเอกสารกับสภาพจริง', 'Acquisition records identify two three-storey shophouses, while the survey describes two internally connected commercial units; buyers must verify records against actual conditions', 'unspecified', NULL, '', 40),
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ด้านหน้าอาคารพาณิชย์ 2 คูหา', 'อาคารพาณิชย์ 3 ชั้น 2 คูหาเลขที่ 55/33 และ 55/34 ในโครงการดุสิตบัญชา', 'https://npa.sam.or.th/site/images/npa/23402/20260625155113_SL0303P2_69.jpg', '/listing-media/sam/sl0303/01.webp', 'image/webp', 21962, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวถนนหน้าอาคาร', 'ภาพมุมกว้างแสดงอาคารพาณิชย์ 2 คูหาและถนนคอนกรีตภายในโครงการดุสิตบัญชา', 'https://npa.sam.or.th/site/images/npa/23402/SL0303P3_69.jpg', '/listing-media/sam/sl0303/02.webp', 'image/webp', 14954, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'อาคารและสภาพแวดล้อมอีกมุม', 'ภาพอาคารพาณิชย์ 3 ชั้นและสภาพแวดล้อมของถนนภายในโครงการ', 'https://npa.sam.or.th/site/images/npa/23402/SL0303P4_69.jpg', '/listing-media/sam/sl0303/03.webp', 'image/webp', 16872, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้าจากถนนสายเอเชีย', 'จุดเลี้ยวจากถนนสายเอเชียทางหลวงหมายเลข 41 เข้าถนนภายในโครงการดุสิตบัญชา', 'https://npa.sam.or.th/site/images/npa/23402/SL0303P1_69.jpg', '/listing-media/sam/sl0303/04.webp', 'image/webp', 20534, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังตำแหน่งแปลงและโฉนด', 'ผังแสดงตำแหน่งโฉนดเลขที่ 29995 และ 30035 ในโครงการดุสิตบัญชา', 'https://npa.sam.or.th/site/images/npa/23402/20260625155113_SL0303C2_69.jpg', '/listing-media/sam/sl0303/05.webp', 'image/webp', 17644, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังสิ่งปลูกสร้าง', 'ผังแสดงอาคารพาณิชย์ 3 ชั้น 2 คูหาที่เจาะทะลุถึงกัน', 'https://npa.sam.or.th/site/images/npa/23402/20260625155113_SL0303C1_69.jpg', '/listing-media/sam/sl0303/06.webp', 'image/webp', 18014, 450, 450, 60, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=23402',
        'SL0303',
        '2026-09-09 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 2,984,000 for two internally connected three-storey shophouse units on 43.8 sq.wah. The page states that the property has a current user and is sold as is; the buyer bears responsibility and costs for obtaining possession. Source property information is dated 4 August 2026, while the source photos display 30 October 2023, so availability, occupancy, price, and condition require reconfirmation. Building usable area, room counts, parking, utilities, and detailed interior condition are not published. Administrator-supplied coordinates are within approximately seven meters of the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all six source property and diagram images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Two Connected 3-Storey Shophouses in Dusit Bancha, Chumphon, THB 2.984M',
        E'Two internally connected three-storey commercial shophouse units in the Dusit Bancha project, numbered 55/33 and 55/34, in Ban Na, Mueang Chumphon, Chumphon. The two title deeds, nos. 29995 and 30035, cover 43.8 sq.wah (175.2 sq.m.) of land.\n\nThe rectangular plot has approximately 8 meters of south-facing road frontage and a maximum depth of approximately 21.9 meters. The source identifies pink zoning. The public concrete road within the project is approximately 20 meters wide within an approximately 24-meter right of way. The property may be considered for retail, office, residential, or mixed use, subject to the buyer independently confirming suitability and applicable requirements.\n\nSAM''s acquisition record identifies two three-storey shophouses, nos. 55/33 and 55/34. The condition survey describes two internally connected three-storey commercial units. Buyers must verify the title deeds, building records, boundaries, and actual conditions before submitting an offer.\n\nImportant: SAM states that the property has a current user and is sold as is. The buyer must inspect before submitting an offer and may need to negotiate or take legal action to obtain possession at the buyer''s own cost. Occupancy cannot be used to cancel an offer or agreement or to make claims against SAM. This source information is dated 4 August 2026, so the current status must be reconfirmed.\n\nAccess is from Asian Highway 41 toward Lang Suan, past Pathom Phon Intersection and the Provincial Electricity Authority''s Chumphon office. At approximately km 1+956, turn onto the Dusit Bancha project road and continue for approximately 160 meters; the property is on the left. Nearby destinations listed by SAM include the Chumphon Provincial Land Office, Chumphon Primary Educational Service Area Office 1, Wat Tham Khao Khun Krathing, and Thailand Post in Chumphon.\n\nThe SAM page lists the property as direct purchase with an announced sale price of THB 2,984,000. It is not an auction. Contact SAM directly to confirm availability, current occupancy, offer procedures, expenses, and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: SL0303. MapxProp does not collect deposits or represent SAM in the transaction.\n\nThe source does not publish internal usable area, bedroom or bathroom counts, parking, utilities, or detailed interior condition. The source photos display 30 October 2023. Buyers should arrange an inspection and verify title documents, encumbrances, boundaries, permitted use, and property condition before deciding.',
        '55/33 and 55/34, Dusit Bancha Project',
        'Near Asian Highway 41',
        'Dusit Bancha Road',
        'Ban Na',
        'Mueang Chumphon',
        'Chumphon',
        'SAM Direct-Sale 3-Storey Shophouses in Chumphon, THB 2.984M',
        'Official SAM NPA asset SL0303: two connected three-storey shophouses on 43.8 sq.wah in Dusit Bancha, Chumphon. Direct-sale price THB 2.984M; current user disclosed.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset SL0303 two connected shophouses commercial building Dusit Bancha Ban Na Mueang Chumphon Chumphon 43.8 sq.wah 175.2 sq.m. title deeds 29995 30035 THB 2984000')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=23402'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=23402',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for SL0303. The specifications, images, rounded coordinates, announced price, direct-purchase status, occupancy warning, and building descriptions come from that record.',
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
        '3bc59986-837b-43ca-a6d0-424984561172',
        jsonb_build_object(
            'reference_code', 'SL0303',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'occupancy_warning', true
        )
    );
END $$;

COMMIT;
