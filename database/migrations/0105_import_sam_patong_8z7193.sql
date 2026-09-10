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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing 8Z7193';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing 8Z7193';
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
        '665c01c6-d957-4445-abc5-08fd8e74d72a',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'shophouse',
        'mixed',
        'sale',
        'whole_property',
        'ทรัพย์แสนล้าน',
        '56/28',
        'ขายตรง SAM อาคารพาณิชย์ 4 ชั้นพร้อมดาดฟ้า ป่าตอง ภูเก็ต 20 ตร.ว. ราคา 7.582 ล้านบาท',
        E'อาคารพาณิชย์เลขที่ 56/28 โครงการทรัพย์แสนล้าน ถนนราชปาทานุสรณ์ ตำบลป่าตอง อำเภอกะทู้ จังหวัดภูเก็ต เอกสารสิทธิ์เป็น น.ส.3ก. เลขที่ 7718 จำนวน 1 ฉบับ เนื้อที่ 20 ตร.ว. (80 ตร.ม.) หน้า SAM ระบุเขตสีส้ม

ที่ดินเป็นรูปหลายเหลี่ยม ด้านทิศใต้ติดถนนกว้างประมาณ 10 เมตร ลึกสุดประมาณ 15 เมตร รายการรับโอนกรรมสิทธิ์ของ SAM ระบุเป็นตึกแถว 4 ชั้น เลขที่ 56/28 ส่วนผลสำรวจสภาพระบุอาคารพาณิชย์ 4 ชั้นพร้อมชั้นดาดฟ้า หน้า SAM ไม่ได้เผยแพร่พื้นที่ใช้สอย จำนวนห้องนอน ที่จอดรถ อายุอาคาร หรือรายละเอียดระบบไฟฟ้าและประปา ผู้ซื้อควรให้ SAM สำนักงานเทศบาล และสำนักงานที่ดินยืนยันทะเบียนอาคาร ดาดฟ้า แบบอาคาร ใบอนุญาต การต่อเติม การใช้อาคาร ระบบดับเพลิง และรายการที่จะโอน

สิทธิทางเข้าออกเป็นประเด็นสำคัญ: SAM ระบุว่าโฉนดที่ดินเลขที่ 12718 และ น.ส.3ก. เลขที่ 1584 กับ 5169 ตกอยู่ในภาระจำยอมเรื่องทางเดิน ทางรถยนต์ ไฟฟ้า ประปา และสาธารณูปโภคต่าง ๆ ให้แก่แปลงทรัพย์สิน ผู้ซื้อควรตรวจสารบัญจดทะเบียน ขอบเขตภาระจำยอม ความกว้างทาง ผู้รับประโยชน์ สิทธิรถยนต์ การบำรุงรักษา และการใช้ทางจริงให้เป็นที่พอใจก่อนเสนอซื้อ

เอกสารสิทธิ์ของแปลงที่ขายเป็น น.ส.3ก. ซึ่งหน้า SAM เตือนว่าตำแหน่ง รูปแปลง ระยะ เนื้อที่ แนวเขต และสาระสำคัญอาจคลาดเคลื่อนจากภาพที่แสดง ผู้ซื้อควรขอคัดเอกสาร ตรวจระวาง ตรวจหมุดแนวเขต และให้สำนักงานที่ดินยืนยันตำแหน่งกับพิกัดจริงก่อนตัดสินใจ

MapxProp จัดอาคารพาณิชย์ประเภทตึกแถวเป็น Mixed Use เพื่อให้ค้นพบได้ทั้งหมวดที่อยู่อาศัยและธุรกิจ แต่การจัดหมวดนี้ไม่ใช่การรับรองว่าพักอาศัยหรือประกอบกิจการทุกประเภทได้ ผู้ซื้อต้องตรวจผังเมืองเขตสีส้ม การใช้อาคาร ทางเข้าออก ป้าย ที่จอดรถ ระบบดับเพลิง และใบอนุญาตสำหรับกิจการที่ต้องการกับหน่วยงานที่เกี่ยวข้อง

การเดินทางตาม SAM ใช้ถนนพระบารมี (ทล.4029) จากหาดกมลามุ่งหน้าวัดสุวรรณคีรีวงศ์ ผ่านโรงเรียนวัดสุวรรณคีรีวงศ์ ถึงแยกวัดสุวรรณคีรีวงศ์ แล้วเลี้ยวขวาเข้าถนนพิศิษฐ์กรณีย์ ต่อด้วยเลี้ยวขวาเข้าถนนราชปาทานุสรณ์ประมาณ 290 เมตร เลี้ยวซ้ายเข้าซอยดับเพลิงประมาณ 94 เมตร จากนั้นเลี้ยวขวาไปสุดซอย ทรัพย์อยู่ด้านขวามือ

หน้า SAM แสดงสถานะ “ซื้อตรง” และราคาประกาศขาย 7,582,000 บาท ไม่ใช่การประมูลในสถานะที่ตรวจสอบเมื่อวันที่ 10 กันยายน 2569 ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะการครอบครอง และวิธีจำหน่ายล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ 8Z7193 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM

ภาพทรัพย์และภาพภายในต้นทางแสดงวันที่ 15 สิงหาคม 2566 สภาพจริงอาจเปลี่ยนแปลง ภาพแสดงห้องหลายชั้น ห้องน้ำ บันได และดาดฟ้า โดยบางบริเวณมีร่องรอยความชื้นหรือการเสื่อมสภาพที่ควรตรวจในสถานที่จริง ผู้ซื้อควรนัดตรวจโครงสร้าง หลังคา ดาดฟ้า รอยร้าว การรั่วซึม ความชื้น ปลวก บันได ห้องน้ำ ระบบไฟฟ้า ประปา ระบบดับเพลิง การครอบครอง ภาระผูกพัน ภาษี ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        7582000,
        false,
        80,
        4,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'อาคารพาณิชย์เลขที่ 56/28 โครงการทรัพย์แสนล้าน',
        'ถนนราชปาทานุสรณ์ เข้าทางซอยดับเพลิง',
        'ถนนราชปาทานุสรณ์',
        NULL,
        7.89878422,
        98.30670478,
        'ภูเก็ต',
        'กะทู้',
        'ป่าตอง',
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
        'sam-direct-sale-shophouse-ratchapathanuson-patong-phuket-8z7193'
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
        property_listing_id, 'sale', 7582000, 'total', 'THB', false
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
        'shophouse',
        1,
        jsonb_build_object(
            'source_property_category', 'อาคารพาณิชย์',
            'project_name', 'ทรัพย์แสนล้าน',
            'title_document_type', 'nor_sor_3_kor',
            'title_document_type_th', 'น.ส.3ก.',
            'title_document_numbers', jsonb_build_array('7718'),
            'title_document_count', 1,
            'land_area_rai', 0,
            'land_area_ngan', 0,
            'land_area_square_wah_remainder', 20,
            'land_area_square_wah', 20,
            'land_area_sqm', 80,
            'plot_count', 1,
            'unit_count', 1,
            'building_number', '56/28',
            'registered_building_type_th', 'ตึกแถว',
            'registered_storeys', 4,
            'surveyed_building_type_th', 'อาคารพาณิชย์ 4 ชั้นพร้อมชั้นดาดฟ้า',
            'displayed_full_storeys', 4,
            'roof_deck_reported', true,
            'usable_area_not_published', true,
            'bedroom_count_not_published', true,
            'parking_space_count_not_published', true,
            'building_age_not_published', true,
            'plot_shape', 'polygon',
            'south_frontage_m_approx', 10,
            'maximum_depth_m_approx', 15
        ) || jsonb_build_object(
            'address_road_name', 'ถนนราชปาทานุสรณ์',
            'access_soi_name', 'ซอยดับเพลิง',
            'access_servient_title_deed_numbers', jsonb_build_array('12718'),
            'access_servient_nor_sor_3_kor_numbers', jsonb_build_array('1584', '5169'),
            'registered_easement_benefits_property', true,
            'registered_easement_purposes_th', jsonb_build_array('ทางเดิน', 'ทางรถยนต์', 'ไฟฟ้า', 'ประปา', 'สาธารณูปโภค'),
            'easement_scope_requires_buyer_verification', true,
            'nor_sor_3_kor_location_and_area_accuracy_warning', true,
            'zoning_color_th', 'เขตสีส้ม ตามหน้า SAM',
            'mixed_use_classification', true,
            'mixed_use_classification_basis', 'MapxProp จัดอาคารพาณิชย์ประเภทตึกแถวเป็นการใช้งานผสมเพื่อการค้นหา โดยผู้ซื้อต้องตรวจการใช้อาคารที่อนุญาตจริง',
            'intended_use_requires_independent_verification', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'computed_price_per_square_wah', 379100,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_information_date_not_published', true,
            'source_property_photo_date_displayed', '2023-08-15',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '7.898786,98.306706',
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z7193. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนพระบารมี (ทล.4029)', 'Phra Barami Highway 4029', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ถนนพิศิษฐ์กรณีย์', 'Phisit Korani Road', 'road', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'ถนนราชปาทานุสรณ์', 'Ratchapathanuson Road', 'road', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'ซอยดับเพลิง', 'Soi Fire Station', 'road', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'วัดสุวรรณคีรีวงศ์', 'Wat Suwan Khiri Wong', 'landmark', NULL, NULL, NULL, 50, true),
        (property_listing_id, 'โรงเรียนวัดสุวรรณคีรีวงศ์', 'Wat Suwan Khiri Wong School', 'education', NULL, NULL, NULL, 60, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '7,582,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 7,582,000 — confirm the latest price with SAM', 'unspecified', 7582000, 'THB', 20),
        (property_listing_id, 'title_document_due_diligence', 'การตรวจสอบเอกสารสิทธิ์', 'Title-document due diligence', 'เอกสารสิทธิ์เป็น น.ส.3ก. เลขที่ 7718 ตำแหน่ง รูปแปลง ระยะ เนื้อที่ และแนวเขตอาจคลาดเคลื่อน ต้องตรวจสอบก่อนเสนอซื้อ', 'The land document is Nor Sor 3 Kor no. 7718; location, shape, dimensions, area and boundaries may vary and must be verified before offering', 'buyer', 1, 'documents', 30),
        (property_listing_id, 'registered_structure', 'สิ่งปลูกสร้างตามทะเบียน', 'Registered structure', 'ตึกแถว 4 ชั้น เลขที่ 56/28; ผลสำรวจระบุอาคารพาณิชย์ 4 ชั้นพร้อมดาดฟ้า ต้องตรวจทะเบียนและส่วนดาดฟ้าให้ตรงกัน', 'Four-storey shophouse no. 56/28; the survey reports a four-storey commercial building with roof deck, requiring reconciliation with the register', 'buyer', 4, 'storeys', 40),
        (property_listing_id, 'registered_easement', 'ภาระจำยอมทางเข้าออกและสาธารณูปโภค', 'Registered access and utility easement', 'SAM ระบุโฉนด 12718 และ น.ส.3ก. 1584, 5169 มีภาระจำยอมให้แปลงทรัพย์สำหรับทางเดิน รถยนต์ ไฟฟ้า ประปา และสาธารณูปโภค ต้องตรวจสารบัญจดทะเบียนและการใช้จริง', 'SAM says title deed 12718 and Nor Sor 3 Kor 1584 and 5169 are burdened for the property with pedestrian, vehicle, electricity, water and utility easements; verify the register and actual use', 'buyer', 3, 'documents', 50),
        (property_listing_id, 'mixed_use_review', 'การใช้เพื่ออยู่อาศัยและธุรกิจ', 'Residential and business use review', 'MapxProp จัดตึกแถวเป็น Mixed Use เพื่อการค้นหา แต่ผู้ซื้อต้องตรวจผังเมือง การใช้อาคาร ระบบดับเพลิง ที่จอดรถ ป้าย และใบอนุญาตสำหรับการใช้งานที่ต้องการ', 'MapxProp classifies the shophouse as mixed use for discovery, but buyers must verify planning, approved use, fire safety, parking, signage and licences', 'buyer', NULL, '', 60),
        (property_listing_id, 'roof_deck_and_condition', 'ดาดฟ้าและสภาพอาคาร', 'Roof deck and building condition', 'ผลสำรวจระบุชั้นดาดฟ้า และภาพวันที่ 15 สิงหาคม 2566 แสดงบางบริเวณที่ควรตรวจความชื้น การรั่วซึม และการซ่อมแซมในสถานที่จริง', 'The survey reports a roof deck, and photos dated 15 August 2023 show areas requiring on-site moisture, leakage and repair inspection', 'buyer', NULL, '', 70),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจ น.ส.3ก. รังวัด อาคาร ดาดฟ้า ทางเข้าออก ภาระจำยอม ผังเมือง การใช้อาคาร ระบบดับเพลิง ไฟฟ้า ประปา การครอบครอง ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Verify the Nor Sor 3 Kor, survey, building, roof deck, access, easements, planning, approved use, fire safety, utilities, possession, encumbrances, costs and current terms', 'buyer', NULL, '', 80)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'อาคารพาณิชย์ 4 ชั้น ป่าตอง', 'ภาพด้านหน้าอาคารพาณิชย์ SAM รหัส 8Z7193 เลขที่ 56/28 ป่าตอง ภูเก็ต', 'https://npa.sam.or.th/site/images/npa/17145/20240702153852_8Z7193P3_66.jpg', '/listing-media/sam/8z7193/01.webp', 'image/webp', 24046, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ด้านหน้าอาคารจากมุมซอย', 'ภาพด้านหน้าและด้านข้างอาคารพาณิชย์ 4 ชั้นในโครงการทรัพย์แสนล้าน', 'https://npa.sam.or.th/site/images/npa/17145/8Z7193P2_66.jpg', '/listing-media/sam/8z7193/02.webp', 'image/webp', 29158, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ประตูม้วนด้านหน้าอาคาร', 'ภาพหน้าทรัพย์และประตูม้วนของอาคารพาณิชย์เลขที่ 56/28', 'https://npa.sam.or.th/site/images/npa/17145/8Z7193P4_66.jpg', '/listing-media/sam/8z7193/03.webp', 'image/webp', 25450, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงทางเข้าและบันได', 'ภาพโถงทางเข้าอาคารพร้อมบันไดขึ้นชั้นบน', 'https://npa.sam.or.th/site/images/npa/17145/8Z7193P6_66.jpg', '/listing-media/sam/8z7193/04.webp', 'image/webp', 11598, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ภายในชั้นล่าง', 'ภาพพื้นที่ภายในอาคารพาณิชย์บริเวณชั้นล่าง', 'https://npa.sam.or.th/site/images/npa/17145/8Z7193P7_66.jpg', '/listing-media/sam/8z7193/05.webp', 'image/webp', 12544, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำภายในอาคาร', 'ภาพห้องน้ำภายในอาคารพาณิชย์ SAM 8Z7193', 'https://npa.sam.or.th/site/images/npa/17145/8Z7193P8_66.jpg', '/listing-media/sam/8z7193/06.webp', 'image/webp', 8980, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเชื่อมภายในและประตู', 'ภาพทางเชื่อมภายในอาคารพร้อมประตูเหล็ก', 'https://npa.sam.or.th/site/images/npa/17145/8Z7193P9_66.jpg', '/listing-media/sam/8z7193/07.webp', 'image/webp', 8654, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องด้านหน้าพร้อมประตูเหล็ก', 'ภาพห้องภายในด้านหน้าพร้อมประตูเหล็กแบบพับ', 'https://npa.sam.or.th/site/images/npa/17145/8Z7193P10_66.jpg', '/listing-media/sam/8z7193/08.webp', 'image/webp', 14354, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องภายในพร้อมหน้าต่าง', 'ภาพห้องภายในอาคารพาณิชย์พร้อมหน้าต่าง', 'https://npa.sam.or.th/site/images/npa/17145/8Z7193P11_66.jpg', '/listing-media/sam/8z7193/09.webp', 'image/webp', 11880, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำอีกชั้น', 'ภาพห้องน้ำภายในอาคารพาณิชย์อีกชั้น', 'https://npa.sam.or.th/site/images/npa/17145/8Z7193P12_66.jpg', '/listing-media/sam/8z7193/10.webp', 'image/webp', 8916, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บันไดภายในอาคาร', 'ภาพบันไดเชื่อมระหว่างชั้นของอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/17145/8Z7193P13_66.jpg', '/listing-media/sam/8z7193/11.webp', 'image/webp', 10666, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องและทางออกด้านหน้า', 'ภาพห้องภายในพร้อมทางออกและประตูเหล็กด้านหน้า', 'https://npa.sam.or.th/site/images/npa/17145/8Z7193P14_66.jpg', '/listing-media/sam/8z7193/12.webp', 'image/webp', 13116, 450, 450, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ห้องภายใน', 'ภาพพื้นที่ห้องภายในอาคารพาณิชย์เลขที่ 56/28', 'https://npa.sam.or.th/site/images/npa/17145/8Z7193P17_66.jpg', '/listing-media/sam/8z7193/13.webp', 'image/webp', 12244, 450, 450, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำและร่องรอยสภาพใช้งาน', 'ภาพห้องน้ำภายในที่ควรตรวจสภาพสุขภัณฑ์และความชื้น', 'https://npa.sam.or.th/site/images/npa/17145/8Z7193P18_66.jpg', '/listing-media/sam/8z7193/14.webp', 'image/webp', 11008, 450, 450, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องด้านหน้าชั้นบน', 'ภาพห้องชั้นบนพร้อมหน้าต่างและประตูด้านหน้า', 'https://npa.sam.or.th/site/images/npa/17145/8Z7193P20_66.jpg', '/listing-media/sam/8z7193/15.webp', 'image/webp', 14004, 450, 450, 150, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำชั้นบน', 'ภาพห้องน้ำบริเวณชั้นบนของอาคารพาณิชย์', 'https://npa.sam.or.th/site/images/npa/17145/8Z7193P21_66.jpg', '/listing-media/sam/8z7193/16.webp', 'image/webp', 9016, 450, 450, 160, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องภายในอีกมุม', 'ภาพห้องภายในพร้อมประตูและหน้าต่างอีกมุมหนึ่ง', 'https://npa.sam.or.th/site/images/npa/17145/8Z7193P23_66.jpg', '/listing-media/sam/8z7193/17.webp', 'image/webp', 10888, 450, 450, 170, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำเพิ่มเติม', 'ภาพห้องน้ำเพิ่มเติมภายในอาคารพาณิชย์ 4 ชั้น', 'https://npa.sam.or.th/site/images/npa/17145/8Z7193P25_66.jpg', '/listing-media/sam/8z7193/18.webp', 'image/webp', 10060, 450, 450, 180, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงชั้นบนและทางออกดาดฟ้า', 'ภาพโถงบันไดชั้นบนและช่องทางออกไปพื้นที่ดาดฟ้า', 'https://npa.sam.or.th/site/images/npa/17145/8Z7193P27_66.jpg', '/listing-media/sam/8z7193/19.webp', 'image/webp', 13758, 450, 450, 190, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ดาดฟ้าอาคาร', 'ภาพพื้นที่ดาดฟ้าและทิวทัศน์โดยรอบของอาคารพาณิชย์ป่าตอง', 'https://npa.sam.or.th/site/images/npa/17145/8Z7193P28_66.jpg', '/listing-media/sam/8z7193/20.webp', 'image/webp', 30682, 450, 450, 200, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้าซอยดับเพลิง', 'ภาพจุดเลี้ยวจากถนนราชปาทานุสรณ์เข้าสู่ซอยดับเพลิง', 'https://npa.sam.or.th/site/images/npa/17145/8Z7193P1_65.jpg', '/listing-media/sam/8z7193/21.webp', 'image/webp', 31962, 450, 450, 210, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังตำแหน่งแปลง น.ส.3ก.', 'ผังต้นทางแสดงตำแหน่งแปลง น.ส.3ก. เลขที่ 7718 และเส้นทางเข้าออก', 'https://npa.sam.or.th/site/images/npa/17145/20190626162407_8Z7193C1_62.jpg', '/listing-media/sam/8z7193/22.webp', 'image/webp', 18228, 450, 450, 220, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังอาคารบนแปลง', 'ผังต้นทางแสดงตำแหน่งอาคารพาณิชย์ 4 ชั้นบนที่ดิน 20 ตารางวา', 'https://npa.sam.or.th/site/images/npa/17145/20190626162407_8Z7193C2_62.jpg', '/listing-media/sam/8z7193/23.webp', 'image/webp', 17430, 450, 450, 230, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปทรัพย์', 'แผนที่ต้นทางแสดงเส้นทางถนนพระบารมี ถนนพิศิษฐ์กรณีย์ ถนนราชปาทานุสรณ์ และซอยดับเพลิงไปยัง 8Z7193', 'https://npa.sam.or.th/site/images/npa/17145/20190626162407_8Z7193M1_62.jpg', '/listing-media/sam/8z7193/24.webp', 'image/webp', 50748, 785, 600, 240, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=17145&keyref=6004389',
        '8Z7193',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 7,582,000 for a four-storey shophouse with roof deck, numbered 56/28 in the Sap Saen Lan project on Ratchapathanuson Road, Patong, Kathu, Phuket. Nor Sor 3 Kor no. 7718 covers 20 sq.wah / 80 sq.m. The polygonal plot has approximately ten metres of southern road frontage and a maximum depth of approximately fifteen metres. SAM states that title deed 12718 and Nor Sor 3 Kor documents 1584 and 5169 are burdened in favour of the subject property for pedestrian and vehicle access, electricity, water and utilities, but instructs buyers to verify access rights. SAM also gives its standard warning that the position, shape, dimensions, area and boundaries shown for Nor Sor 3 Kor land can vary. The source shows orange planning zoning but does not publish the approved building use. MapxProp classifies the shophouse as mixed use for residential and business discovery, subject to independent verification of permitted use. Usable area, bedroom count, parking, age and utility specifications are not published. Source property photos display 15 August 2023 and show rooms, bathrooms, stairs and the roof deck, with some areas requiring moisture and condition inspection. Administrator coordinates are approximately 0.24 metres from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all twenty-four unique source property, interior, access, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: 4-Storey Shophouse with Roof Deck in Patong, THB 7.582M',
        E'Four-storey shophouse numbered 56/28 in the Sap Saen Lan project on Ratchapathanuson Road, Patong, Kathu, Phuket. Nor Sor 3 Kor no. 7718 covers 20 sq.wah (80 sq.m.). SAM shows orange planning zoning.

The polygonal plot has approximately ten metres of southern road frontage and a maximum depth of approximately fifteen metres. SAM''s registered acquisition schedule describes a four-storey shophouse, while its condition survey describes a four-storey commercial building with roof deck. The source does not publish usable area, bedroom count, parking, building age, or electrical and plumbing specifications. Buyers should ask SAM, the municipality and the Land Office to verify building registration, roof deck, plans, permits, alterations, approved use, fire safety and everything included in transfer.

Access rights are a material issue. SAM states that title deed 12718 and Nor Sor 3 Kor documents 1584 and 5169 are burdened in favour of the subject property for pedestrian access, vehicle access, electricity, water and utilities. Buyers must inspect the registration records and verify the easement route, width, beneficiaries, vehicle rights, maintenance responsibilities and actual access before offering.

The property''s land document is Nor Sor 3 Kor. SAM warns that the displayed location, plot shape, dimensions, area, boundaries and other material details may vary. Buyers should obtain document copies, inspect the cadastral sheet and boundary markers and ask the Land Office to confirm that the document and coordinates match the actual site.

MapxProp classifies the shophouse as mixed use so it can be discovered in both homes and business. This does not guarantee residential use or every commercial use. Buyers must confirm current orange-zone planning, approved building use, access, signage, parking, fire safety and licences for the intended use.

SAM''s directions use Phra Barami Highway 4029 from Kamala Beach toward Wat Suwan Khiri Wong, passing Wat Suwan Khiri Wong School. At the temple junction, turn right onto Phisit Korani Road, then right onto Ratchapathanuson Road for approximately 290 metres. Turn left into Soi Fire Station for approximately 94 metres, then right and continue to the end. The property is on the right.

The SAM page listed the property for direct purchase at an announced THB 7,582,000 when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, offer procedures, current price, promotions, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: 8Z7193. MapxProp does not collect deposits or represent SAM in the transaction.

Source property photos display 15 August 2023 and conditions may have changed. They show rooms on multiple floors, bathrooms, stairs and the roof deck, with some areas requiring on-site moisture or deterioration inspection. Buyers should inspect the structure, roofs, roof deck, cracks, leaks, moisture, termites, stairs, bathrooms, electrical and plumbing systems, fire safety, possession, encumbrances, taxes, costs and every current term before deciding.',
        'Shophouse 56/28 in Sap Saen Lan, Patong',
        'Ratchapathanuson Road, access via Soi Fire Station',
        'Ratchapathanuson Road',
        'Patong',
        'Kathu',
        'Phuket',
        'SAM 4-Storey Shophouse with Roof Deck in Patong, THB 7.582M',
        'Official SAM NPA asset 8Z7193: a four-storey mixed-use shophouse with roof deck on 80 sq.m. in Patong, Phuket. Direct-sale price THB 7.582M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset 8Z7193 four storey mixed use shophouse commercial building roof deck 56/28 Sap Saen Lan Ratchapathanuson Road Patong Kathu Phuket Soi Fire Station Nor Sor 3 Kor 7718 20 sq.wah 80 sq.m. THB 7582000 easement access electricity water utilities orange zone')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=17145&keyref=6004389'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=17145&keyref=6004389',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z7193. Specifications, Nor Sor 3 Kor document, registered and surveyed building details, images, rounded coordinates, announced price, direct-purchase status, easement details, access directions, Nor Sor 3 Kor accuracy warning and planning-zone wording come from that record.',
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
        '665c01c6-d957-4445-abc5-08fd8e74d72a',
        jsonb_build_object(
            'reference_code', '8Z7193',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'mixed',
            'discovery_channels', jsonb_build_array('homes', 'business'),
            'title_document_type', 'nor_sor_3_kor',
            'title_document_count', 1,
            'unit_count', 1,
            'registered_storeys', 4,
            'roof_deck_review_required', true,
            'easement_review_required', true,
            'title_accuracy_review_required', true,
            'source_image_count', 24
        )
    );
END $$;

COMMIT;
