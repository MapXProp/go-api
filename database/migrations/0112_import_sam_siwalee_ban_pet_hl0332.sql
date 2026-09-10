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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing HL0332';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing HL0332';
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
        '71871f86-a059-4ffb-ac2a-a4598f6e1c33',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'house',
        'residence',
        'sale',
        'whole_property',
        'สีวลี',
        '11/91',
        'ขายตรง SAM บ้านเดี่ยว 2 ชั้น หมู่บ้านสีวลี บ้านเป็ด 56.2 ตร.ว. ราคา 3.825 ล้านบาท — มีผู้ใช้ประโยชน์',
        E'บ้านเดี่ยว 2 ชั้น เลขที่ 11/91 ในหมู่บ้านสีวลี ซอย 6 ถนนศรีจันทร์ ตำบลบ้านเป็ด อำเภอเมืองขอนแก่น จังหวัดขอนแก่น บนที่ดินโฉนดเลขที่ 250549 จำนวน 1 ฉบับ เนื้อที่ 56.2 ตร.ว. (224.8 ตร.ม.) อยู่ในเขตผังเมืองสีชมพูตามหน้า SAM\n\nที่ดินมีรูปคล้ายสี่เหลี่ยมผืนผ้า ด้านทิศใต้ติดถนน หน้ากว้างประมาณ 13 เมตร และลึกสุดประมาณ 17.5 เมตร รายการรับโอนกรรมสิทธิ์ของ SAM ระบุสิ่งปลูกสร้างเป็นบ้านพักอาศัยตึก 2 ชั้น เลขที่ 11/91 ผู้ซื้อควรตรวจทะเบียนอาคาร แบบแปลน ใบอนุญาต ขอบเขตแปลง และรายการสิ่งปลูกสร้างที่จะได้รับโอนให้ตรงกับสภาพจริง\n\nสำคัญ: SAM ระบุว่ามีผู้ใช้ประโยชน์ในทรัพย์สินและขายตามสภาพ ผู้ซื้อควรตรวจทรัพย์ก่อนเสนอซื้อ และอาจต้องเจรจาหรือดำเนินการทางกฎหมายเพื่อเข้าครอบครองด้วยค่าใช้จ่ายของผู้ซื้อเอง SAM ระบุว่าประเด็นการครอบครองไม่เป็นเหตุให้ยกเลิกการเสนอซื้อหรือสัญญาจะซื้อจะขาย และไม่สามารถใช้สิทธิเรียกร้องต่อ SAM ได้ ข้อมูลรายละเอียดหน้า SAM แสดงวันที่ 31 กรกฎาคม 2569 แต่ผู้ซื้อต้องสอบถามสถานะผู้ใช้ประโยชน์และการเข้าครอบครองล่าสุดโดยตรง\n\nถนนผ่านหน้าทรัพย์เป็นถนนหมู่บ้านสีวลี ซอย 6 ซึ่ง SAM ระบุว่าเป็นทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว ผิวจราจรคอนกรีตกว้างประมาณ 6 เมตร และเขตทางกว้างประมาณ 8 เมตร ทรัพย์อยู่ในย่านที่อยู่อาศัยและการคมนาคมสะดวก ใกล้โรงเรียนบ้านโคกฟันโปง บึงหนองโคตร และเทศบาลตำบลบ้านเป็ด\n\nชุดภาพต้นทางมีภาพสระว่ายน้ำ ห้องออกกำลังกาย ลานออกกำลังกายกลางแจ้ง และพื้นที่สวนริมบึง ซึ่งถูกระบุเป็นพื้นที่ส่วนกลาง ภาพเหล่านี้ไม่ใช่การรับรองสิทธิใช้บริการ สภาพปัจจุบัน เวลาเปิด อัตราค่าส่วนกลาง ยอดค้าง หรือเงื่อนไขของโครงการ ผู้ซื้อต้องตรวจสอบกับผู้ดูแลโครงการและ SAM ก่อนเสนอซื้อ\n\nการเดินทางตาม SAM ใช้ถนนศรีจันทร์จากเซ็นทรัล ขอนแก่น มุ่งหน้าไปทางสำนักงานที่ดินบ้านเป็ด ผ่านโรงพยาบาลกรุงเทพขอนแก่น ตลาดบ้านคำไฮ และบึงหนองโคตร จากนั้นเลี้ยวซ้ายเข้าหมู่บ้านสีวลีและซอย 6 รวมประมาณ 520 เมตร ทรัพย์อยู่ด้านซ้ายมือ\n\nหน้า SAM แสดงสถานะ “ซื้อตรง” และราคาประกาศขาย 3,825,000 บาท ณ วันที่ตรวจสอบ 10 กันยายน 2569 ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะผู้ใช้ประโยชน์ การเข้าครอบครอง และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ HL0332 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nหน้าต้นทางไม่เผยแพร่พื้นที่ใช้สอย จำนวนห้องนอน ห้องน้ำ ที่จอดรถ อายุอาคาร ระบบไฟฟ้า-ประปา ค่าส่วนกลาง หรือภาระผูกพันอื่น ภาพหน้าทรัพย์แสดงวันที่ 7 กุมภาพันธ์ 2569 สภาพจริงอาจเปลี่ยนแปลง ผู้ซื้อควรนัดตรวจโครงสร้าง หลังคา รอยร้าว ความชื้น ปลวก ระบบไฟฟ้าและประปา การระบายน้ำ น้ำท่วม แนวเขต กฎโครงการ การครอบครอง ภาระผูกพัน ค่าส่วนกลาง ภาษี ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        3825000,
        false,
        224.8,
        2,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        '11/91 หมู่บ้านสีวลี ซอย 6',
        'เข้าจากทางเข้าหมู่บ้านสีวลีและซอย 6 รวมประมาณ 520 เมตร',
        'ศรีจันทร์',
        NULL,
        16.43545223586351,
        102.7868300655078,
        'ขอนแก่น',
        'เมืองขอนแก่น',
        'บ้านเป็ด',
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
        'sam-direct-sale-two-storey-house-siwalee-ban-pet-khon-kaen-hl0332'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 3825000, 'total', 'THB', false
    )
    ON CONFLICT (listing_id, offer_type) DO UPDATE SET
        amount = EXCLUDED.amount,
        price_unit = EXCLUDED.price_unit,
        currency_code = EXCLUDED.currency_code,
        is_negotiable = EXCLUDED.is_negotiable,
        updated_at = now();

    INSERT INTO public.listing_discovery_channels (
        listing_id, channel_code, source, is_featured
    ) VALUES (property_listing_id, 'homes', 'editorial', false)
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
            'project_name', 'สีวลี',
            'project_soi', 'ซอย 6',
            'listed_unit_number', '11/91',
            'title_document_type', 'chanote',
            'title_deed_number', '250549',
            'title_document_count', 1,
            'land_area_rai', 0,
            'land_area_ngan', 0,
            'land_area_square_wah_remainder', 56.2,
            'land_area_square_wah', 56.2,
            'land_area_sqm', 224.8,
            'registered_transfer_description', 'บ้านพักอาศัยตึก 2 ชั้น เลขที่ 11/91',
            'registered_floor_count', 2,
            'plot_shape', 'near_rectangle',
            'south_road_frontage_m', 13,
            'maximum_depth_m', 17.5,
            'front_road_name', 'ถนนหมู่บ้านสีวลี ซอย 6',
            'front_road_legal_status_th', 'ทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว',
            'front_road_surface', 'concrete',
            'front_road_width_m', 6,
            'front_right_of_way_width_m', 8,
            'zoning_color_th', 'สีชมพู ตามหน้า SAM'
        ) || jsonb_build_object(
            'surrounding_area_use_th', 'ย่านที่อยู่อาศัย',
            'mixed_use_classification', false,
            'mixed_use_exclusion_basis', 'SAM ระบุประเภททรัพย์เป็นบ้านเดี่ยวในโครงการที่อยู่อาศัยและไม่ได้ระบุว่าเป็น Mixed Use',
            'property_has_current_user', true,
            'source_property_details_date', '2026-07-31',
            'sold_as_is', true,
            'buyer_responsible_for_obtaining_possession', true,
            'possession_issue_not_cancellation_basis_per_source', true,
            'common_area_photos_published', true,
            'source_common_area_photos_show', jsonb_build_array('swimming_pool', 'indoor_fitness_room', 'outdoor_exercise_area', 'waterside_garden'),
            'common_area_access_and_fees_require_confirmation', true,
            'usable_area_not_published', true,
            'bedroom_count_not_published', true,
            'bathroom_count_not_published', true,
            'parking_information_not_published', true,
            'building_age_not_published', true,
            'utilities_information_not_published', true,
            'common_fee_information_not_published', true,
            'other_encumbrances_not_published', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'computed_price_per_square_wah', 68060.50,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_property_photo_date_displayed', '2026-02-07',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '16.435480,102.786828',
            'administrator_coordinate_distance_from_source_m_approx', 3.10
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for HL0332. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนศรีจันทร์', 'Srichan Road', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'บึงหนองโคตร', 'Bueng Nong Khot', 'landmark', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'โรงเรียนบ้านโคกฟันโปง', 'Ban Khok Fan Pong School', 'education', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'เทศบาลตำบลบ้านเป็ด', 'Ban Pet Subdistrict Municipality', 'government', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'โรงพยาบาลกรุงเทพขอนแก่น', 'Bangkok Hospital Khon Kaen', 'healthcare', NULL, NULL, NULL, 50, true),
        (property_listing_id, 'ตลาดบ้านคำไฮ', 'Ban Kham Hai Market', 'shopping', NULL, NULL, NULL, 60, true),
        (property_listing_id, 'เซ็นทรัล ขอนแก่น', 'Central Khon Kaen', 'shopping', NULL, NULL, NULL, 70, false),
        (property_listing_id, 'สำนักงานที่ดินบ้านเป็ด', 'Ban Pet Land Office', 'government', NULL, NULL, NULL, 80, false)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '3,825,000 บาท — โปรดตรวจสอบราคาล่าสุดและโปรโมชั่นกับ SAM', 'THB 3,825,000 — confirm the latest price and promotions with SAM', 'unspecified', 3825000, 'THB', 20),
        (property_listing_id, 'occupancy_and_possession', 'ผู้ใช้ประโยชน์และการเข้าครอบครอง', 'Current user and possession', 'SAM ระบุว่ามีผู้ใช้ประโยชน์ในทรัพย์ ผู้ซื้อรับผิดชอบการเจรจาหรือดำเนินการทางกฎหมายและค่าใช้จ่ายเพื่อเข้าครอบครองเอง โดยใช้การครอบครองเป็นเหตุยกเลิกหรือเรียกร้องต่อ SAM ไม่ได้', 'SAM states that the property has a current user; the buyer bears negotiations or legal action and the costs of obtaining possession, and possession cannot be used to cancel or claim against SAM', 'buyer', NULL, '', 30),
        (property_listing_id, 'registered_structure', 'สิ่งปลูกสร้างตามรายการรับโอน', 'Structure in acquisition records', 'รายการรับโอนของ SAM ระบุบ้านพักอาศัยตึก 2 ชั้น เลขที่ 11/91 บนโฉนดเลขที่ 250549', 'SAM''s acquisition record identifies a two-storey masonry residence numbered 11/91 on title deed no. 250549', 'unspecified', NULL, '', 40),
        (property_listing_id, 'internal_project_road', 'ถนนภายในโครงการ', 'Internal development road', 'หมู่บ้านสีวลี ซอย 6 เป็นทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว ผิวคอนกรีตกว้างประมาณ 6 เมตร เขตทางประมาณ 8 เมตร', 'Siwalee Village Soi 6 is an internal road in an authorized allocated development, with an approximately six-metre concrete carriageway in an eight-metre right of way', 'unspecified', 6, 'metres', 50),
        (property_listing_id, 'common_area_due_diligence', 'พื้นที่ส่วนกลาง', 'Common-area due diligence', 'ต้นทางมีภาพสระว่ายน้ำ ห้องออกกำลังกาย ลานออกกำลังกาย และสวนริมบึง แต่ต้องตรวจสิทธิใช้บริการ สภาพปัจจุบัน ค่าส่วนกลาง ยอดค้าง และเงื่อนไขกับโครงการ', 'The source includes pool, fitness, outdoor exercise and waterside garden photos, but access rights, current condition, fees, arrears and development terms must be verified', 'buyer', NULL, '', 60),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนด แนวเขต ทะเบียนอาคาร สภาพบ้าน ระบบไฟฟ้า-ประปา การครอบครอง ภาระผูกพัน ค่าส่วนกลาง กฎโครงการ ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Verify title, boundaries, building registration, house condition, electrical and plumbing systems, possession, encumbrances, common fees, development rules, costs and latest terms', 'buyer', NULL, '', 70)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'บ้านเดี่ยว 2 ชั้น เลขที่ 11/91', 'บ้านเดี่ยว 2 ชั้น เลขที่ 11/91 หมู่บ้านสีวลี บ้านเป็ด รหัส SAM HL0332', 'https://npa.sam.or.th/site/images/npa/22999/20260210111929_HL0332P10_69.jpg', '/listing-media/sam/hl0332/01.webp', 'image/webp', 23772, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บ้านและถนนภายในซอย 6', 'ภาพบ้านเดี่ยวเลขที่ 11/91 และแนวถนนคอนกรีตภายในหมู่บ้านสีวลี ซอย 6', 'https://npa.sam.or.th/site/images/npa/22999/HL0332P6_69.jpg', '/listing-media/sam/hl0332/02.webp', 'image/webp', 27680, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมบ้านจากแนวถนน', 'ภาพมุมบ้านเดี่ยว 2 ชั้นจากถนนภายในหมู่บ้านสีวลี', 'https://npa.sam.or.th/site/images/npa/22999/HL0332P7_69.jpg', '/listing-media/sam/hl0332/03.webp', 'image/webp', 22382, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ประตูรั้วและด้านหน้าบ้าน', 'ภาพประตูรั้ว ลานหน้าบ้าน และตัวบ้านสองชั้นเลขที่ 11/91', 'https://npa.sam.or.th/site/images/npa/22999/HL0332P8_69.jpg', '/listing-media/sam/hl0332/04.webp', 'image/webp', 24962, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'amenity', 'สระว่ายน้ำส่วนกลาง', 'ภาพพื้นที่ส่วนกลางของโครงการที่ต้นทางระบุและแสดงสระว่ายน้ำ', 'https://npa.sam.or.th/site/images/npa/22999/HL0332P2_69.jpg', '/listing-media/sam/hl0332/05.webp', 'image/webp', 41102, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'amenity', 'ห้องออกกำลังกายส่วนกลาง', 'ภาพพื้นที่ส่วนกลางของโครงการที่แสดงอุปกรณ์ออกกำลังกายในอาคาร', 'https://npa.sam.or.th/site/images/npa/22999/HL0332P3_69.jpg', '/listing-media/sam/hl0332/06.webp', 'image/webp', 27156, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'amenity', 'ลานออกกำลังกายกลางแจ้ง', 'ภาพพื้นที่ส่วนกลางที่แสดงอุปกรณ์ออกกำลังกายกลางแจ้งและบึง', 'https://npa.sam.or.th/site/images/npa/22999/HL0332P4_69.jpg', '/listing-media/sam/hl0332/07.webp', 'image/webp', 22980, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'amenity', 'สวนและบึงส่วนกลาง', 'ภาพพื้นที่สวน ทางเดิน และบึงภายในโครงการสีวลี', 'https://npa.sam.or.th/site/images/npa/22999/HL0332P5_69.jpg', '/listing-media/sam/hl0332/08.webp', 'image/webp', 28374, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'access', 'ทางเข้าหมู่บ้านสีวลี', 'ภาพจุดเลี้ยวเข้าสู่หมู่บ้านสีวลีจากแนวถนนศรีจันทร์', 'https://npa.sam.or.th/site/images/npa/22999/HL0332P1_69.jpg', '/listing-media/sam/hl0332/09.webp', 'image/webp', 15716, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังแปลงที่ดิน 56.2 ตารางวา', 'ผังต้นทางแสดงแปลงรูปคล้ายสี่เหลี่ยมผืนผ้า หน้ากว้างประมาณ 13 เมตรและลึกสุดประมาณ 17.5 เมตร', 'https://npa.sam.or.th/site/images/npa/22999/20260210111929_HL0332C2_69.jpg', '/listing-media/sam/hl0332/10.webp', 'image/webp', 13732, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังบ้าน 2 ชั้นบนแปลง', 'ผังต้นทางแสดงตำแหน่งบ้านพักอาศัย 2 ชั้นบนที่ดินเลขที่ 11/91', 'https://npa.sam.or.th/site/images/npa/22999/20260210111929_HL0332C1_69.jpg', '/listing-media/sam/hl0332/11.webp', 'image/webp', 13992, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปหมู่บ้านสีวลี', 'แผนที่ต้นทางแสดงเส้นทางจากถนนศรีจันทร์และบึงหนองโคตรไปยังหมู่บ้านสีวลี บ้านเป็ด', 'https://npa.sam.or.th/site/images/npa/22999/20260210111929_HL0332M_69(HL0332).jpg', '/listing-media/sam/hl0332/12.webp', 'image/webp', 40918, 785, 600, 120, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=22999&keyref=6004425',
        'HL0332',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 3,825,000 for a two-storey detached house numbered 11/91 in Siwalee Village Soi 6, Ban Pet, Mueang Khon Kaen. Title deed no. 250549 covers 56.2 sq.wah / 224.8 sq.m. The near-rectangular plot has approximately thirteen metres of southern road frontage and a maximum depth of approximately 17.5 metres. SAM identifies the transferred structure as a two-storey masonry residence numbered 11/91. Siwalee Village Soi 6 is described as an internal concrete road in an authorized allocated development, approximately six metres wide within an approximately eight-metre right of way. The source identifies pink planning zoning and a residential surrounding area. Crucially, SAM states that the property has a current user, is sold as is and that the buyer bears negotiations or legal action and the costs of obtaining possession; possession cannot be used as a cancellation or claim basis. The property details display a date of 31 July 2026. The source publishes common-area photos showing a pool, indoor fitness room, outdoor exercise area and waterside garden, but does not confirm access rights, current condition, fees or arrears. Usable area, bedrooms, bathrooms, parking, building age, utilities, common fees and other encumbrances are not published. Source property photos display 7 February 2026. Administrator coordinates are approximately 3.10 metres from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all twelve unique source property, common-area, access, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Two-Storey House in Siwalee Village, Ban Pet, THB 3.825M — Current User',
        E'A two-storey detached house numbered 11/91 in Siwalee Village Soi 6 on Srichan Road, Ban Pet, Mueang Khon Kaen. Title deed no. 250549 covers 56.2 sq.wah (224.8 sq.m.) of land. The SAM page identifies pink planning zoning.\n\nThe near-rectangular plot has approximately thirteen metres of southern road frontage and a maximum depth of approximately 17.5 metres. SAM''s acquisition record identifies a two-storey masonry residence numbered 11/91. Buyers should verify building registration, approved plans, permits, boundaries and every structure included in the transfer against current conditions.\n\nImportant possession caveat: SAM states that the property has a current user and is sold as is. The buyer may need to negotiate or take legal action to obtain possession at the buyer''s own cost. SAM says possession cannot be used to cancel an offer or sale agreement or as a basis for claims against SAM. The property details display a date of 31 July 2026, but current use and possession must be confirmed directly.\n\nSiwalee Village Soi 6 is an internal concrete road in an authorized allocated development, approximately six metres wide within an approximately eight-metre right of way. SAM describes the surrounding area as residential with convenient transport. Nearby places listed by SAM include Ban Khok Fan Pong School, Bueng Nong Khot and Ban Pet Subdistrict Municipality.\n\nThe source includes common-area photos showing a swimming pool, indoor fitness room, outdoor exercise equipment and a waterside garden. These images do not guarantee access rights, current condition, opening times, common fees, arrears or development terms. Buyers must verify all of these with the development manager and SAM.\n\nSAM''s directions use Srichan Road from Central Khon Kaen toward the Ban Pet Land Office, passing Bangkok Hospital Khon Kaen, Ban Kham Hai Market and Bueng Nong Khot. Turn left into Siwalee Village and Soi 6 and continue for approximately 520 metres. The property is on the left.\n\nThe SAM page listed the property for direct purchase at an announced THB 3,825,000 when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, offer procedures, current price, promotions, costs, current user, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: HL0332. MapxProp does not collect deposits or represent SAM in the transaction.\n\nThe source does not publish usable area, bedroom or bathroom counts, parking, building age, utility specifications, common fees or other encumbrances. Property photos display 7 February 2026, and conditions may have changed. Buyers should inspect the structure, roof, cracks, moisture, termites, electrical and plumbing systems, drainage, flooding, boundaries, development rules, possession, encumbrances, common fees, taxes, costs and every current term before deciding.',
        '11/91, Siwalee Village Soi 6',
        'Approximately 520 m inside the Siwalee Village entrance and Soi 6',
        'Srichan Road',
        'Ban Pet',
        'Mueang Khon Kaen',
        'Khon Kaen',
        'SAM House in Siwalee Village, Ban Pet, THB 3.825M — Current User',
        'Official SAM NPA asset HL0332: two-storey house on 224.8 sq.m. in Siwalee Village, Ban Pet. Direct-sale price THB 3.825M; current-user caveat disclosed.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset HL0332 detached house two storey 11/91 Siwalee Village Soi 6 Ban Pet Mueang Khon Kaen Srichan Road 56.2 sq.wah 224.8 sq.m. title deed 250549 THB 3825000 current user possession pool fitness common area')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=22999&keyref=6004425'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=22999&keyref=6004425',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for HL0332. Specifications, title deed, registered house, images, rounded coordinates, announced price, direct-purchase status, current-user and possession caveat, road measurements and planning-zone wording come from that record.',
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
        '71871f86-a059-4ffb-ac2a-a4598f6e1c33',
        jsonb_build_object(
            'reference_code', 'HL0332',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'residence',
            'discovery_channels', jsonb_build_array('homes'),
            'title_document_count', 1,
            'registered_floor_count', 2,
            'current_user_and_possession_review_required', true,
            'common_area_access_and_fee_review_required', true,
            'source_image_count', 12
        )
    );
END $$;

COMMIT;
