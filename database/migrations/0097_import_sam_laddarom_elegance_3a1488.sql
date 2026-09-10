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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing 3A1488';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing 3A1488';
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
        'd40a0683-c3a1-49b3-89c3-82f1411e2675',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'house',
        'residence',
        'sale',
        'whole_property',
        'ลัดดารมย์ อิลิแกนซ์',
        '199/99',
        'ขายตรง SAM บ้านเดี่ยว 2 ชั้น ลัดดารมย์ อิลิแกนซ์ เชียงใหม่ 182.5 ตร.ว. ราคา 15.103 ล้านบาท',
        E'บ้านเดี่ยว 2 ชั้น เลขที่ 199/99 หมู่ 2 ในหมู่บ้านลัดดารมย์ อิลิแกนซ์ ถนนสมโภชน์เชียงใหม่ 700 ปี ตำบลท่าศาลา อำเภอเมืองเชียงใหม่ จังหวัดเชียงใหม่ บนที่ดินโฉนดเลขที่ 115147 จำนวน 1 ฉบับ เนื้อที่ 1 งาน 82.5 ตร.ว. หรือ 182.5 ตร.ว. (730 ตร.ม.)

ที่ดินเป็นรูปหลายเหลี่ยมและติดถนน 2 ด้าน ด้านทิศใต้กว้างประมาณ 38 เมตร ด้านทิศเหนือกว้างประมาณ 16 เมตร และลึกสุดประมาณ 29 เมตร ถนนหน้าทรัพย์คือถนนภายในหมู่บ้านลัดดารมย์ อิลิแกนซ์ ซอย 4/6 เป็นทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว ผิวจราจรคอนกรีตกว้างประมาณ 8 เมตร เขตทางกว้างประมาณ 10 เมตร ผู้ซื้อควรตรวจแนวเขต ทางเข้าออกจริง และกฎการใช้ถนนหรือพื้นที่ส่วนกลางของโครงการก่อนเสนอซื้อ

รายการรับโอนกรรมสิทธิ์ของ SAM ระบุสิ่งปลูกสร้างเป็นบ้านพักอาศัยตึก 2 ชั้น เลขที่ 199/99 หน้า SAM ไม่ได้เผยแพร่พื้นที่ใช้สอย จำนวนห้องนอน ห้องน้ำ ที่จอดรถ อายุอาคาร รายละเอียดระบบไฟฟ้า-ประปา หรือสภาพภายใน ผู้ซื้อควรให้ SAM สำนักงานที่ดิน และหน่วยงานท้องถิ่นยืนยันทะเบียนอาคาร แบบแปลน ใบอนุญาต ขอบเขต และรายการสิ่งปลูกสร้างที่จะโอน พร้อมนัดตรวจสภาพจริงและประเมินค่าซ่อม

สำคัญ: SAM ระบุว่ามีผู้ใช้ประโยชน์ในทรัพย์สินและขายตามสภาพ ผู้ซื้อควรตรวจทรัพย์ก่อนเสนอซื้อ และอาจต้องเจรจาหรือดำเนินการทางกฎหมายเพื่อเข้าครอบครองด้วยค่าใช้จ่ายของผู้ซื้อเอง ไม่สามารถใช้ประเด็นการครอบครองเป็นเหตุยกเลิกการเสนอซื้อหรือสัญญา และไม่สามารถเรียกร้องจาก SAM ได้ ข้อมูลรายละเอียดส่วนนี้ระบุ ณ วันที่ 23 สิงหาคม 2566 จึงต้องสอบถามสถานะปัจจุบันโดยตรง

หน้า SAM ระบุค่าส่วนกลางประมาณ 50,370 บาทต่อปี โดยเป็นข้อมูล ณ วันที่ 7 พฤษภาคม 2567 ตัวเลขนี้ไม่ใช่การยืนยันยอดค้างชำระหรืออัตราปัจจุบัน ผู้ซื้อต้องขอหนังสือรับรองจากนิติบุคคลหรือผู้ดูแลโครงการเพื่อตรวจอัตราค่าส่วนกลาง ยอดค้าง ค่าปรับ เงื่อนไขการโอน และผู้รับผิดชอบค่าใช้จ่ายทั้งหมด

หน้า SAM ระบุเขตพื้นที่สีส้ม อยู่ในย่านพาณิชยกรรมและเดินทางสะดวก แต่ประเภททรัพย์เป็นบ้านเดี่ยวในโครงการที่อยู่อาศัย MapxProp จึงจัดในหมวดที่อยู่อาศัย ไม่ได้จัดเป็น Mixed Use และข้อความเรื่องย่านพาณิชยกรรมไม่ใช่การรับรองว่าสามารถประกอบธุรกิจได้ ผู้ซื้อที่ต้องการใช้เชิงพาณิชย์ต้องตรวจผังเมือง ข้อบังคับโครงการ นิติบุคคล กฎหมายอาคาร ที่จอดรถ ป้าย และใบอนุญาตกิจการเอง

การเดินทางตาม SAM ใช้ถนนเชียงใหม่-ลำปางจากจังหวัดลำปางมุ่งหน้าดอยสุเทพ ผ่านบริเวณ กม.553 ถึงสถานีตำรวจทางหลวง 4 กองกำกับการ 5 เลี้ยวขวาเข้าถนนเชียงใหม่-บ้านสหกรณ์ (ทล.1317) แล้วเลี้ยวซ้ายเข้าถนนสมโภชน์เชียงใหม่ 700 ปีประมาณ 350 เมตร ถึงบริเวณสหกรณ์ออมทรัพย์ครูเชียงใหม่ จำกัด จากนั้นเลี้ยวขวาเข้าหมู่บ้านลัดดารมย์ อิลิแกนซ์ อีกประมาณ 680 เมตร สถานที่ใกล้เคียงที่ SAM ระบุ ได้แก่ วัดศรีบัวเงิน สหกรณ์ออมทรัพย์ครูเชียงใหม่ จำกัด และสำนักงานเทศบาลตำบลท่าศาลา

หน้า SAM ระบุสถานะ “ซื้อตรง” และราคาประกาศขาย 15,103,000 บาท ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย ค่าส่วนกลาง สถานะผู้ใช้ประโยชน์ การเข้าครอบครอง และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ 3A1488 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM

ภาพสภาพทรัพย์ในหน้าต้นทางแสดงวันที่ 25 มกราคม 2566 สภาพจริงอาจเปลี่ยนแปลง ผู้ซื้อควรนัดตรวจโครงสร้าง หลังคา รอยร้าว ความชื้น ปลวก ระบบไฟฟ้าและประปา การระบายน้ำ น้ำท่วม ดิน แนวเขต การครอบครอง ภาระผูกพัน ค่าใช้จ่ายส่วนกลาง ภาษี และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        15103000,
        false,
        730,
        2,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        '199/99 หมู่ 2 หมู่บ้านลัดดารมย์ อิลิแกนซ์',
        'ใกล้ถนนสมโภชน์เชียงใหม่ 700 ปีและถนนเชียงใหม่-บ้านสหกรณ์ (ทล.1317)',
        'ถนนภายในหมู่บ้านลัดดารมย์ อิลิแกนซ์ ซอย 4/6',
        NULL,
        18.76376457,
        99.04021056,
        'เชียงใหม่',
        'เมืองเชียงใหม่',
        'ท่าศาลา',
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
        'sam-direct-sale-house-laddarom-elegance-chiang-mai-3a1488'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 15103000, 'total', 'THB', false
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
        'house',
        1,
        jsonb_build_object(
            'source_property_category', 'บ้านเดี่ยว',
            'project_name', 'ลัดดารมย์ อิลิแกนซ์',
            'listed_unit_number', '199/99',
            'listed_moo', '2',
            'title_document_type', 'chanote',
            'title_deed_number', '115147',
            'title_document_count', 1,
            'land_area_rai', 0,
            'land_area_ngan', 1,
            'land_area_square_wah_remainder', 82.5,
            'land_area_square_wah', 182.5,
            'land_area_sqm', 730,
            'registered_transfer_description', 'บ้านพักอาศัยตึก 2 ชั้น เลขที่ 199/99',
            'registered_floor_count', 2,
            'plot_shape', 'polygon',
            'road_frontage_side_count', 2,
            'south_side_width_m', 38,
            'north_side_width_m', 16,
            'maximum_depth_m', 29,
            'front_road_name', 'ถนนภายในหมู่บ้านลัดดารมย์ อิลิแกนซ์ ซอย 4/6',
            'front_road_legal_status_th', 'ทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว',
            'front_road_surface', 'concrete',
            'front_road_width_m', 8,
            'front_right_of_way_width_m', 10,
            'zoning_color_th', 'สีส้ม ตามหน้า SAM'
        ) || jsonb_build_object(
            'surrounding_area_use_th', 'ย่านพาณิชยกรรม',
            'mixed_use_classification', false,
            'mixed_use_exclusion_basis', 'SAM ระบุประเภททรัพย์เป็นบ้านเดี่ยวในโครงการที่อยู่อาศัยและไม่ได้ระบุว่าเป็น Mixed Use',
            'commercial_use_requires_independent_verification', true,
            'property_has_current_user', true,
            'occupancy_information_dated_on', '2023-08-23',
            'sold_as_is', true,
            'buyer_responsible_for_obtaining_possession', true,
            'annual_common_fee_thb_approx', 50370,
            'common_fee_information_dated_on', '2024-05-07',
            'common_fee_current_rate_and_arrears_require_confirmation', true,
            'usable_area_not_published', true,
            'bedroom_count_not_published', true,
            'bathroom_count_not_published', true,
            'parking_information_not_published', true,
            'building_age_not_published', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'computed_price_per_square_wah', 82756.16,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_information_date', '2023-08-23',
            'source_property_photo_date_displayed', '2023-01-25',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '18.763772,99.040178',
            'administrator_coordinate_distance_from_source_m_approx', 3.53
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 3A1488. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนสมโภชน์เชียงใหม่ 700 ปี', 'Somphot Chiang Mai 700 Pi Road', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ถนนเชียงใหม่-บ้านสหกรณ์ (ทล.1317)', 'Chiang Mai-Ban Sahakon Highway 1317', 'road', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'วัดศรีบัวเงิน', 'Wat Si Bua Ngoen', 'landmark', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'สหกรณ์ออมทรัพย์ครูเชียงใหม่ จำกัด', 'Chiang Mai Teachers Savings Cooperative Limited', 'landmark', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'สำนักงานเทศบาลตำบลท่าศาลา', 'Tha Sala Subdistrict Municipality Office', 'government', NULL, NULL, NULL, 50, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '15,103,000 บาท — โปรดตรวจสอบราคาล่าสุดและโปรโมชั่นกับ SAM', 'THB 15,103,000 — confirm the latest price and promotions with SAM', 'unspecified', 15103000, 'THB', 20),
        (property_listing_id, 'occupancy_and_possession', 'ผู้ใช้ประโยชน์และการเข้าครอบครอง', 'Current user and possession', 'SAM ระบุว่ามีผู้ใช้ประโยชน์ในทรัพย์ ผู้ซื้อรับผิดชอบการเจรจาหรือดำเนินการทางกฎหมายและค่าใช้จ่ายเพื่อเข้าครอบครองเอง', 'SAM states that the property has a current user; the buyer is responsible for negotiations or legal action and the costs of obtaining possession', 'buyer', NULL, '', 30),
        (property_listing_id, 'annual_common_fee', 'ค่าส่วนกลาง', 'Annual common fee', 'ประมาณ 50,370 บาทต่อปี ตามข้อมูล ณ 7 พฤษภาคม 2567 — ตรวจอัตราปัจจุบัน ยอดค้าง ค่าปรับ และผู้ชำระกับโครงการ', 'Approximately THB 50,370 per year based on information dated 7 May 2024 — confirm the current rate, arrears, penalties and payer with the development', 'unspecified', 50370, 'THB/year', 40),
        (property_listing_id, 'internal_project_road', 'ถนนภายในโครงการ', 'Internal development road', 'ซอย 4/6 เป็นทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว ผิวคอนกรีตกว้างประมาณ 8 เมตร เขตทางประมาณ 10 เมตร', 'Soi 4/6 is an internal road in an authorized allocated development, with an approximately eight-metre concrete carriageway in a ten-metre right of way', 'unspecified', 8, 'metres', 50),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนด แนวเขต ทะเบียนอาคาร สภาพบ้าน ระบบไฟฟ้า-ประปา การครอบครอง ภาระผูกพัน ค่าส่วนกลาง กฎโครงการ ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Verify title, boundaries, building registration, house condition, electrical and plumbing systems, possession, encumbrances, common fees, development rules, costs and latest terms', 'buyer', NULL, '', 60)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'บ้านเดี่ยว 2 ชั้น เลขที่ 199/99', 'บ้านเดี่ยว SAM รหัส 3A1488 เลขที่ 199/99 ในลัดดารมย์ อิลิแกนซ์ เชียงใหม่', 'https://npa.sam.or.th/site/images/npa/20971/20230807131604_3A1488P4_66.jpg', '/listing-media/sam/3a1488/01.webp', 'image/webp', 42248, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ด้านหน้าบ้านและประตูรั้ว', 'ภาพด้านหน้าบ้านสองชั้นและประตูรั้วภายในหมู่บ้านลัดดารมย์ อิลิแกนซ์', 'https://npa.sam.or.th/site/images/npa/20971/3A1488P2_66.jpg', '/listing-media/sam/3a1488/02.webp', 'image/webp', 44642, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บ้านและแนวถนนด้านข้าง', 'ภาพบ้านเลขที่ 199/99 และแนวถนนภายในโครงการที่ติดทรัพย์สองด้าน', 'https://npa.sam.or.th/site/images/npa/20971/3A1488P3_66.jpg', '/listing-media/sam/3a1488/03.webp', 'image/webp', 45798, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้าหมู่บ้านจากถนน 700 ปี', 'ภาพจุดเลี้ยวจากถนนสมโภชน์เชียงใหม่ 700 ปีเข้าสู่หมู่บ้านลัดดารมย์ อิลิแกนซ์', 'https://npa.sam.or.th/site/images/npa/20971/3A1488P1_66.jpg', '/listing-media/sam/3a1488/04.webp', 'image/webp', 31226, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังแปลงที่ดินติดถนน 2 ด้าน', 'ผังต้นทางแสดงรูปแปลงหลายเหลี่ยม โฉนดเลขที่ 115147 และแนวถนนสองด้าน', 'https://npa.sam.or.th/site/images/npa/20971/20230807131604_3A1488C2_66.jpg', '/listing-media/sam/3a1488/05.webp', 'image/webp', 12120, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังบ้าน 2 ชั้นบนแปลง', 'ผังต้นทางแสดงตำแหน่งบ้านพักอาศัยตึก 2 ชั้นบนที่ดิน 182.5 ตารางวา', 'https://npa.sam.or.th/site/images/npa/20971/20230807131604_3A1488C3_66.jpg', '/listing-media/sam/3a1488/06.webp', 'image/webp', 13768, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปทรัพย์', 'แผนที่ต้นทางแสดงเส้นทางไปบ้าน SAM 3A1488 ในลัดดารมย์ อิลิแกนซ์ ท่าศาลา เชียงใหม่', 'https://npa.sam.or.th/site/images/npa/20971/20230807131604_3A1488M1_66.jpg', '/listing-media/sam/3a1488/07.webp', 'image/webp', 48154, 785, 600, 70, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=20971&keyref=6004388',
        '3A1488',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 15,103,000 for a two-storey detached house numbered 199/99 in Laddarom Elegance, Tha Sala, Mueang Chiang Mai. Title deed no. 115147 covers 1 ngan 82.5 sq.wah / 182.5 sq.wah / 730 sq.m. The polygonal plot fronts roads on two sides, with an approximately 38-metre southern side, sixteen-metre northern side and maximum depth of approximately 29 metres. Laddarom Elegance Soi 4/6 is described as an internal concrete road in an authorized allocated development, approximately eight metres wide within an approximately ten-metre right of way. SAM identifies the transferred structure as a two-storey masonry residence numbered 199/99. The source identifies orange planning zoning and a commercial surrounding area, but the asset is classified as a residential house rather than mixed use because SAM does not state mixed use. SAM states that the property has a current user and that the buyer bears the responsibility and costs of obtaining possession; detailed information is dated 23 August 2023. The source reports an approximate annual common fee of THB 50,370 based on information dated 7 May 2024; this is not confirmation of the current rate or arrears. Usable area, bedrooms, bathrooms, parking, building age and internal systems are not published. Source property photos display 25 January 2023. Administrator coordinates are approximately 3.53 metres from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all seven unique source property, access, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Two-Storey House in Laddarom Elegance, Chiang Mai, THB 15.103M',
        E'A two-storey detached house numbered 199/99, Moo 2, in Laddarom Elegance on Somphot Chiang Mai 700 Pi Road, Tha Sala, Mueang Chiang Mai. The property stands on title deed no. 115147 with 1 ngan 82.5 sq.wah, or 182.5 sq.wah (730 sq.m.) of land.

The polygonal plot fronts roads on two sides. Its southern side is approximately 38 metres wide, northern side approximately sixteen metres wide, and maximum depth approximately 29 metres. Laddarom Elegance Soi 4/6 is an internal concrete road in an authorized allocated development, approximately eight metres wide within an approximately ten-metre right of way. Buyers should verify boundaries, actual ingress and egress and development rules before offering.

SAM''s registered acquisition record identifies a two-storey masonry residence numbered 199/99. The source does not publish usable area, bedroom or bathroom counts, parking, building age, electrical and plumbing specifications or interior condition. Buyers should ask SAM, the Land Office and local authorities to confirm building registration, approved plans, permits, boundaries and every structure included in the transfer, and arrange an in-person condition inspection.

Important possession caveat: SAM states that the property has a current user and is sold as is. The buyer may need to negotiate or take legal action to obtain possession at the buyer''s own cost. SAM says possession cannot be used to cancel an offer or sale agreement or as a basis for claims against SAM. This detailed information is dated 23 August 2023, so current conditions must be confirmed directly.

SAM reports an approximate common fee of THB 50,370 per year based on information dated 7 May 2024. This is not confirmation of the current fee rate or outstanding balance. Buyers must obtain written confirmation from the development manager covering the current rate, arrears, penalties, transfer requirements and the responsible payer.

The source shows orange planning zoning and describes the surrounding area as commercial, but the asset itself is a detached house in a residential development. MapxProp therefore lists it only under homes, not mixed use. Anyone considering commercial activity must independently verify zoning, development rules, building control, signage, parking and business licences.

SAM''s directions use the Chiang Mai-Lampang Road toward Doi Suthep, then Chiang Mai-Ban Sahakon Highway 1317 and Somphot Chiang Mai 700 Pi Road. From the Chiang Mai Teachers Savings Cooperative, turn into Laddarom Elegance and continue approximately 680 metres. Nearby places listed by SAM include Wat Si Bua Ngoen, Chiang Mai Teachers Savings Cooperative and Tha Sala Subdistrict Municipality Office.

The SAM page lists the property for direct purchase at an announced price of THB 15,103,000. It is not an auction. Contact SAM directly to confirm availability, offer procedures, current price, promotions, common fees, current user, possession, costs and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: 3A1488. MapxProp does not collect deposits or represent SAM in the transaction.

Source property photos display 25 January 2023, and conditions may have changed. Buyers should inspect the structure, roof, cracks, moisture, termites, electrical and plumbing systems, drainage, flooding, soil, boundaries, possession, encumbrances, common fees, taxes and every current term before deciding.',
        '199/99, Moo 2, Laddarom Elegance',
        'Near Somphot Chiang Mai 700 Pi Road and Chiang Mai-Ban Sahakon Highway 1317',
        'Laddarom Elegance Soi 4/6',
        'Tha Sala',
        'Mueang Chiang Mai',
        'Chiang Mai',
        'SAM House in Laddarom Elegance, Chiang Mai, THB 15.103M',
        'Official SAM NPA asset 3A1488: two-storey house on 730 sq.m. in Laddarom Elegance, Chiang Mai. Direct-sale price THB 15.103M; current-user caveat disclosed.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset 3A1488 detached house two storey 199/99 Laddarom Elegance Tha Sala Mueang Chiang Mai Somphot Chiang Mai 700 Pi Road Highway 1317 1 ngan 82.5 sq.wah 182.5 sq.wah 730 sq.m. title deed 115147 THB 15103000 current user possession common fee')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=20971&keyref=6004388'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=20971&keyref=6004388',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 3A1488. Specifications, title deed, registered house, images, rounded coordinates, announced price, direct-purchase status, possession caveat, common-fee wording, road measurements and planning-zone wording come from that record.',
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
        'd40a0683-c3a1-49b3-89c3-82f1411e2675',
        jsonb_build_object(
            'reference_code', '3A1488',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'residence',
            'discovery_channels', jsonb_build_array('homes'),
            'title_document_count', 1,
            'registered_floor_count', 2,
            'current_user_and_possession_review_required', true,
            'common_fee_review_required', true,
            'commercial_use_review_required', true,
            'source_image_count', 7
        )
    );
END $$;

COMMIT;
