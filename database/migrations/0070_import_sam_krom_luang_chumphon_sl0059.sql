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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing SL0059';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing SL0059';
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
        '8486eccd-3f91-4da7-941a-b1bdba40e698',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'shophouse',
        'mixed',
        'sale',
        'whole_property',
        'ขายตรง SAM อาคารพาณิชย์หัวมุม 4 ชั้นพร้อมชั้นลอย 4 คูหา ถนนกรมหลวงชุมพร 27.891 ล้านบาท',
        E'อาคารพาณิชย์หัวมุม 4 ชั้นพร้อมชั้นลอย จำนวน 4 คูหา มีการใช้ประโยชน์ร่วมกันและเจาะทะลุภายใน ตั้งอยู่ริมถนนกรมหลวงชุมพร ตำบลท่าตะเภา อำเภอเมืองชุมพร จังหวัดชุมพร ที่ดิน 4 แปลงติดกันรวม 1 งาน (100 ตร.ว. หรือ 400 ตร.ม.) โฉนดเลขที่ 57371, 57372, 57373 และ 57374 จำนวน 4 ฉบับ\n\nจุดเด่นคือเป็นแปลงรูปสี่เหลี่ยมผืนผ้าติดถนน 2 ด้าน ด้านทิศใต้ติดถนนกรมหลวงชุมพรยาวประมาณ 16.5 เมตร และด้านทิศตะวันออกติดทางสาธารณประโยชน์ยาวประมาณ 24.5 เมตร ถนนกรมหลวงชุมพรเป็นทางสาธารณประโยชน์ ผิวลาดยางกว้างประมาณ 12 เมตร เขตทางประมาณ 16 เมตร ทำเลอยู่ในย่านที่อยู่อาศัยและพาณิชยกรรม เขตผังเมืองสีชมพู มีศักยภาพด้านหน้าร้าน สำนักงาน ที่พักอาศัย หรือการใช้งานแบบผสม ทั้งนี้ผู้ซื้อต้องตรวจสอบข้อกำหนดและความเหมาะสมกับกิจการจริง\n\nข้อมูลการรับโอนกรรมสิทธิ์ของ SAM ระบุเป็นตึกแถวสี่ชั้น เลขที่ 25/55 และ 25/56 จำนวน 4 คูหา ส่วนการสำรวจสภาพระบุเป็นอาคารพาณิชย์ 4 ชั้นพร้อมชั้นลอย จำนวน 4 คูหา ไม่ติดเลขที่ มีการใช้ประโยชน์ร่วมกันและเจาะทะลุถึงกัน ผู้ซื้อควรตรวจสอบเอกสารสิทธิ์ ทะเบียนอาคาร เลขที่อาคาร ขอบเขต และสภาพจริงก่อนเสนอซื้อ\n\nสำคัญ: SAM ระบุว่ามีผู้ใช้ประโยชน์ในทรัพย์สินและขายตามสภาพ ผู้ซื้อต้องตรวจสอบทรัพย์ก่อนเสนอซื้อ และอาจต้องเจรจาหรือดำเนินการทางกฎหมายเพื่อเข้าครอบครองด้วยค่าใช้จ่ายของผู้ซื้อเอง ไม่สามารถใช้ประเด็นการครอบครองเป็นเหตุยกเลิกการเสนอซื้อหรือสัญญา หรือเรียกร้องจาก SAM ได้ ข้อมูลหน้าต้นทางส่วนนี้ระบุ ณ วันที่ 9 กันยายน 2568 จึงต้องสอบถามสถานะล่าสุดกับ SAM\n\nการเดินทางใช้ถนนกรมหลวงชุมพร จากถนนนวมินท์ร่วมใจมุ่งหน้าอนุสถานกรมหลวงชุมพร ถึงแยกถนนศาลาแดงแล้วตรงไปประมาณ 260 เมตร ผ่านโอเชี่ยนมอลล์ จะพบทรัพย์อยู่ด้านซ้ายมือ สถานที่สำคัญที่ SAM ระบุใกล้เคียง ได้แก่ ชุมพรไนท์พลาซ่า ห้างสรรพสินค้าโอเชี่ยนมอลล์ โรงพยาบาลชุมพรเขตอุดมศักดิ์ และสถานีรถไฟชุมพร\n\nหน้า SAM ระบุสถานะ “ซื้อตรง” และราคาประกาศขาย 27,891,000 บาท ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย สถานะผู้ใช้ประโยชน์ ขั้นตอนเสนอซื้อ ค่าใช้จ่าย และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ SL0059 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nหน้าต้นทางไม่ระบุพื้นที่ใช้สอยภายใน จำนวนห้องนอน ห้องน้ำ ที่จอดรถ ระบบสาธารณูปโภค หรือสภาพภายในโดยละเอียด ภาพต้นทางมีวันที่กำกับ 18 สิงหาคม 2567 ผู้ซื้อจึงควรนัดตรวจทรัพย์และตรวจสอบข้อมูล เอกสารสิทธิ์ ภาระผูกพัน แนวเขต และข้อกำหนดการใช้ประโยชน์ก่อนตัดสินใจ',
        27891000,
        false,
        400,
        4,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sale@sam.or.th',
        '@samline',
        true,
        true,
        'ตึกแถวเลขที่ 25/55 และ 25/56',
        'ติดถนน 2 ด้าน',
        'ถนนกรมหลวงชุมพร',
        '86000',
        10.50109048,
        99.17990145,
        'ชุมพร',
        'เมืองชุมพร',
        'ท่าตะเภา',
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
        'sam-direct-sale-four-unit-corner-shophouse-krom-luang-chumphon-sl0059'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES
        (property_listing_id, 'retail'),
        (property_listing_id, 'office'),
        (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 27891000, 'total', 'THB', false
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
            'land_area_ngan', 1,
            'land_area_square_wah', 100,
            'land_area_sqm', 400,
            'title_deed_numbers', jsonb_build_array('57371', '57372', '57373', '57374'),
            'title_document_count', 4,
            'floor_count', 4,
            'has_mezzanine', true,
            'unit_count', 4,
            'units_connected_internally', true,
            'units_used_together', true,
            'registered_transfer_description', 'ตึกแถวสี่ชั้น เลขที่ 25/55 และ 25/56 จำนวน 4 คูหา',
            'registered_address_numbers', jsonb_build_array('25/55', '25/56'),
            'registered_transferred_shophouse_unit_count', 4,
            'surveyed_structure_description', 'อาคารพาณิชย์ 4 ชั้นพร้อมชั้นลอย จำนวน 4 คูหา ไม่ติดเลขที่ มีการใช้ประโยชน์ร่วมกันและเจาะทะลุถึงกัน',
            'surveyed_shophouse_unit_count', 4,
            'structure_records_require_buyer_review', true,
            'plot_shape', 'rectangle',
            'corner_plot', true,
            'road_frontage_side_count', 2,
            'south_road_frontage_m', 16.5,
            'east_public_road_frontage_m', 24.5,
            'zoning_color_th', 'สีชมพู',
            'access_type', 'public_road',
            'front_road_name', 'ถนนกรมหลวงชุมพร',
            'front_road_surface', 'asphalt',
            'front_road_width_m', 12,
            'front_right_of_way_width_m', 16,
            'secondary_road_type', 'public_benefit_road',
            'property_has_current_user', true,
            'occupancy_information_dated_on', '2025-09-09',
            'sold_as_is', true,
            'buyer_responsible_for_obtaining_possession', true,
            'usable_area_not_published', true,
            'bedroom_count_not_published', true,
            'bathroom_count_not_published', true,
            'parking_information_not_published', true,
            'interior_condition_not_published', true,
            'source_photo_date_displayed', '2024-08-18',
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for SL0059. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนกรมหลวงชุมพร', 'Krom Luang Chumphon Road', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ชุมพรไนท์พลาซ่า', 'Chumphon Night Plaza', 'shopping', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'ห้างสรรพสินค้าโอเชี่ยนมอลล์', 'Ocean Mall Chumphon', 'shopping', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'โรงพยาบาลชุมพรเขตอุดมศักดิ์', 'Chumphon Khet Udomsak Hospital', 'healthcare', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'สถานีรถไฟชุมพร', 'Chumphon Railway Station', 'transit', NULL, NULL, NULL, 50, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '27,891,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 27,891,000 — confirm the latest price with SAM', 'unspecified', 27891000, 'THB', 20),
        (property_listing_id, 'occupancy_and_possession', 'ผู้ใช้ประโยชน์และการเข้าครอบครอง', 'Current user and possession', 'มีผู้ใช้ประโยชน์ในทรัพย์ ผู้ซื้อรับผิดชอบการเจรจาหรือดำเนินการทางกฎหมายและค่าใช้จ่ายเพื่อเข้าครอบครองเอง', 'The property has a current user; the buyer is responsible for negotiations or legal action and the costs of obtaining possession', 'buyer', NULL, '', 30),
        (property_listing_id, 'registered_structure_transfer', 'สิ่งปลูกสร้างตามรายการรับโอน', 'Structures in acquisition records', 'รายการรับโอนระบุตึกแถวสี่ชั้นเลขที่ 25/55 และ 25/56 จำนวน 4 คูหา ส่วนผลสำรวจระบุอาคารพาณิชย์ 4 ชั้นพร้อมชั้นลอย 4 คูหาไม่ติดเลขที่ ผู้ซื้อต้องตรวจสอบเอกสารกับสภาพจริง', 'Acquisition records identify four four-storey shophouse units under two address numbers, while the survey describes four units with mezzanines and no displayed numbers; buyers must verify records against actual conditions', 'unspecified', NULL, '', 40),
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ด้านหน้าอาคารพาณิชย์หัวมุม', 'อาคารพาณิชย์ 4 ชั้นพร้อมชั้นลอย 4 คูหาติดถนนกรมหลวงชุมพร', 'https://npa.sam.or.th/site/images/npa/21951/20240829172433_SL0059P1_67.jpg', '/listing-media/sam/sl0059/01.webp', 'image/webp', 30346, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวถนนด้านข้าง', 'ภาพมุมหัวแปลงแสดงอาคารพาณิชย์และถนนสาธารณประโยชน์ด้านตะวันออก', 'https://npa.sam.or.th/site/images/npa/21951/SL0059P2_67.jpg', '/listing-media/sam/sl0059/02.webp', 'image/webp', 37898, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ด้านหลังและด้านข้างอาคาร', 'ภาพอาคารพาณิชย์ 4 ชั้นจากมุมด้านหลังและทางสาธารณประโยชน์', 'https://npa.sam.or.th/site/images/npa/21951/SL0059P3_67.jpg', '/listing-media/sam/sl0059/03.webp', 'image/webp', 37470, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังแปลงติดถนนสองด้าน', 'ผังที่ดินโฉนด 4 แปลง แสดงหน้ากว้างถนนกรมหลวงชุมพรประมาณ 16.5 เมตรและด้านตะวันออกประมาณ 24.5 เมตร', 'https://npa.sam.or.th/site/images/npa/21951/20240829172433_SL0059C1_67.jpg', '/listing-media/sam/sl0059/04.webp', 'image/webp', 19910, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังสิ่งปลูกสร้างสี่คูหา', 'ผังแสดงอาคารพาณิชย์ 4 ชั้นพร้อมชั้นลอย 4 คูหาและแนวถนนสองด้าน', 'https://npa.sam.or.th/site/images/npa/21951/20240829172433_SL0059C2_67.jpg', '/listing-media/sam/sl0059/05.webp', 'image/webp', 18966, 450, 450, 50, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=21951',
        'SL0059',
        '2026-09-09 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 27,891,000 for four connected four-storey shophouse units with mezzanines on four adjoining title deeds totaling 100 sq.wah. The corner plot fronts two roads. The page states that the property has a current user and is sold as is; the buyer bears responsibility and costs for obtaining possession. Source property information is dated 9 September 2025, while the source photos display 18 August 2024, so availability, occupancy, price, and condition require reconfirmation. Building usable area, room counts, parking, utilities, and detailed interior condition are not published. Administrator-supplied coordinates are within approximately five meters of the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all five source property and diagram images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Four-Unit Corner Shophouse Building on Krom Luang Chumphon Road, THB 27.891M',
        E'Corner commercial building comprising four internally connected four-storey shophouse units with mezzanines on Krom Luang Chumphon Road, Tha Taphao, Mueang Chumphon, Chumphon. Four adjoining title deeds, nos. 57371, 57372, 57373, and 57374, cover a total of 1 ngan (100 sq.wah or 400 sq.m.).\n\nA key feature is frontage on two roads. The rectangular plot has approximately 16.5 meters of south frontage on Krom Luang Chumphon Road and approximately 24.5 meters of east frontage on a public-benefit road. Krom Luang Chumphon Road is a public asphalt road approximately 12 meters wide within an approximately 16-meter right of way. The source identifies pink zoning in a convenient residential and commercial area. The property may be considered for retail, office, residential, or mixed use, subject to independent verification of suitability and applicable requirements.\n\nSAM''s acquisition record describes four four-storey shophouse units under address numbers 25/55 and 25/56. The condition survey describes four commercial units with mezzanines, no displayed address numbers, shared use, and internal connections. Buyers must verify the title deeds, building records, address numbers, boundaries, and actual conditions before submitting an offer.\n\nImportant: SAM states that the property has a current user and is sold as is. The buyer must inspect before submitting an offer and may need to negotiate or take legal action to obtain possession at the buyer''s own cost. Occupancy cannot be used to cancel an offer or agreement or to make claims against SAM. This source information is dated 9 September 2025, so the current status must be reconfirmed.\n\nAccess is via Krom Luang Chumphon Road from Nawamin Ruam Jai Road toward the Prince of Chumphon Monument. Continue through the Sala Daeng Road intersection for approximately 260 meters, passing Ocean Mall; the property is on the left. Nearby destinations listed by SAM include Chumphon Night Plaza, Ocean Mall, Chumphon Khet Udomsak Hospital, and Chumphon Railway Station.\n\nThe SAM page lists the property as direct purchase with an announced sale price of THB 27,891,000. It is not an auction. Contact SAM directly to confirm availability, current occupancy, offer procedures, expenses, and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: SL0059. MapxProp does not collect deposits or represent SAM in the transaction.\n\nThe source does not publish internal usable area, bedroom or bathroom counts, parking, utilities, or detailed interior condition. The source photos display 18 August 2024. Buyers should arrange an inspection and verify title documents, encumbrances, boundaries, permitted use, and property condition before deciding.',
        'Shophouses 25/55 and 25/56',
        'Two-road corner plot',
        'Krom Luang Chumphon Road',
        'Tha Taphao',
        'Mueang Chumphon',
        'Chumphon',
        'SAM Direct-Sale Four-Unit Corner Shophouse in Chumphon, THB 27.891M',
        'Official SAM NPA asset SL0059: four connected shophouse units with mezzanines on a 400 sq.m. two-road corner plot. Direct-sale price THB 27.891M; current user disclosed.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset SL0059 four connected corner shophouses commercial building Krom Luang Chumphon Road Tha Taphao Mueang Chumphon Chumphon 1 ngan 100 sq.wah 400 sq.m. title deeds 57371 57372 57373 57374 THB 27891000')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=21951'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=21951',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for SL0059. The specifications, images, rounded coordinates, announced price, direct-purchase status, occupancy warning, and building descriptions come from that record.',
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
        '8486eccd-3f91-4da7-941a-b1bdba40e698',
        jsonb_build_object(
            'reference_code', 'SL0059',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'corner_plot', true,
            'occupancy_warning', true
        )
    );
END $$;

COMMIT;
