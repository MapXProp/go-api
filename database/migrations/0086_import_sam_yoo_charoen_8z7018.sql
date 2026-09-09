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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing 8Z7018';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing 8Z7018';
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
        bedroom_count,
        bathroom_count,
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
        '3d15154f-11a8-4aed-837b-8bf86da9f282',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'house',
        'residential',
        'sale',
        'whole_property',
        'หมู่บ้านอยู่เจริญ',
        '9/140',
        'ขายตรง SAM บ้านเดี่ยวชั้นเดียวพร้อมส่วนต่อเติม หมู่บ้านอยู่เจริญ วัดประดู่ 130.3 ตร.ว. ราคา 3.537 ล้านบาท',
        E'บ้านเดี่ยวชั้นเดียวพร้อมส่วนต่อเติม เลขที่ 9/140 ในหมู่บ้านอยู่เจริญ ถนนวัตตจารีราษฎร์ ตำบลวัดประดู่ อำเภอเมืองสุราษฎร์ธานี จังหวัดสุราษฎร์ธานี มี 3 ห้องนอน 2 ห้องน้ำ บนที่ดิน 1 งาน 30.3 ตร.ว. หรือ 130.3 ตร.ว. (521.2 ตร.ม.) โฉนดที่ดินเลขที่ 100060 จำนวน 1 ฉบับ

ที่ดินรูปหลายเหลี่ยม ด้านทิศตะวันออกกว้างประมาณ 16.5 เมตร ลึกสุดประมาณ 33 เมตร ถนนหน้าทรัพย์คือซอยหมู่บ้านอยู่เจริญ เป็นทางสาธารณประโยชน์ ผิวจราจรคอนกรีตกว้างประมาณ 6 เมตร เขตทางประมาณ 8 เมตร ทรัพย์อยู่ในเขตผังเมืองสีชมพูและย่านที่อยู่อาศัย

ข้อควรตรวจสอบสำคัญ: รายการรับโอนกรรมสิทธิ์ของ SAM ระบุสิ่งปลูกสร้าง 3 รายการ ได้แก่ บ้านพักอาศัยตึกชั้นเดียวเลขที่ 9/140 อาคารโรงงานผนังก่ออิฐชั้นเดียว และอาคารโรงงานสภาพเปิดโล่งชั้นเดียว แต่ข้อมูลสำรวจสภาพทรัพย์พบลักษณะเป็นบ้านพักอาศัยชั้นเดียวพร้อมส่วนต่อเติมแบบส่วนโล่งหลังคาคลุม SAM ระบุว่าจะโอนสิ่งปลูกสร้างตามรายการที่จดทะเบียนรับโอนทางทะเบียนเท่านั้น ผู้ซื้อจึงต้องตรวจทะเบียนอาคาร รายการที่จะโอน ตรวจว่าอาคารโรงงานทั้งสองหลังยังมีอยู่จริงหรือไม่ และเปรียบเทียบกับสภาพหน้างานก่อนเสนอซื้อ

ภาพทรัพย์ชุดล่าสุดที่แสดงวันที่ 9 เมษายน 2567 แสดงตัวบ้านชั้นเดียว ลานดิน พื้นที่โล่งหลังคาคลุม ทางเดินรอบอาคาร และห้องภายในหลายมุม พื้นที่ภายในค่อนข้างโปร่ง แต่ส่วนต่อเติมและบางจุดภายนอกเห็นคราบ รอยเก่า และร่องรอยการใช้งาน ผู้ซื้อควรให้ผู้เชี่ยวชาญตรวจโครงสร้าง หลังคา ความชื้น ระบบไฟฟ้า-ประปา และงบซ่อมปรับปรุงจากสภาพจริง

การเดินทางใช้ถนนสายสุราษฎร์ธานี-พุนพิน (ทล.401) จากสี่แยกตาปานมุ่งหน้าอำเภอพุนพิน ผ่านโลตัส สาขาสุราษฎร์ธานี สี่แยกท่ากูบ และอินเด็กซ์ ลิฟวิ่งมอลล์ เลี้ยวขวาเข้าถนนวัตตจารีราษฎร์ข้างโชว์รูมสยามนิสสันประมาณ 140 เมตร แล้วเลี้ยวขวาเข้าซอยหมู่บ้านอยู่เจริญ ทรัพย์อยู่ภายในโครงการ สถานที่ใกล้เคียงที่ SAM ระบุ ได้แก่ โรงพยาบาลกรุงเทพสุราษฎร์ สถานีขนส่งสุราษฎร์ธานี และเซ็นทรัล สุราษฎร์ธานี

หน้า SAM ระบุสถานะ “ซื้อตรง” และราคาประกาศขาย 3,537,000 บาท ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน รายการสิ่งปลูกสร้างที่จะโอน สถานะการครอบครอง ค่าใช้จ่าย และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ 8Z7018 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM

หน้าต้นทางไม่ระบุพื้นที่ใช้สอย จำนวนที่จอดรถ อายุอาคาร สถานะผู้ใช้ประโยชน์ ระบบสาธารณูปโภค ภาระผูกพันอื่น หรือวันที่ของข้อมูลรายละเอียด ผู้ซื้อควรนัดตรวจทรัพย์และตรวจสอบสภาพปัจจุบัน โฉนด แนวเขต ทะเบียนและการมีอยู่จริงของสิ่งปลูกสร้าง การต่อเติม การครอบครอง ระบบอาคาร ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        3537000,
        false,
        521.2,
        3,
        2,
        1,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        '9/140 หมู่บ้านอยู่เจริญ',
        'เข้าจากถนนวัตตจารีราษฎร์ทางซอยหมู่บ้านอยู่เจริญ',
        'วัตตจารีราษฎร์',
        NULL,
        9.11217918,
        99.29281018,
        'สุราษฎร์ธานี',
        'เมืองสุราษฎร์ธานี',
        'วัดประดู่',
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
        'sam-direct-sale-single-storey-house-yoo-charoen-wat-pradu-8z7018'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 3537000, 'total', 'THB', false
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
            'project_name', 'หมู่บ้านอยู่เจริญ',
            'listed_unit_number', '9/140',
            'title_document_type', 'chanote',
            'title_deed_number', '100060',
            'title_document_count', 1,
            'land_area_ngan', 1,
            'land_area_square_wah_remainder', 30.3,
            'land_area_square_wah', 130.3,
            'land_area_sqm', 521.2,
            'floor_count', 1,
            'bedroom_count', 3,
            'bathroom_count', 2,
            'plot_shape', 'polygon',
            'east_side_width_m', 16.5,
            'maximum_depth_m', 33,
            'registered_structure_count', 3,
            'registered_structures', jsonb_build_array(
                'บ้านพักอาศัยตึกชั้นเดียว เลขที่ 9/140',
                'อาคารโรงงานผนังก่ออิฐชั้นเดียว',
                'อาคารโรงงานสภาพเปิดโล่งชั้นเดียว'
            ),
            'surveyed_structure_description', 'บ้านพักอาศัยชั้นเดียวพร้อมส่วนต่อเติมแบบส่วนโล่งหลังคาคลุม',
            'transfer_limited_to_registered_structures', true,
            'registered_and_surveyed_structures_require_reconciliation', true,
            'factory_buildings_physical_presence_requires_confirmation', true,
            'source_photos_show_covered_open_extension', true,
            'source_photos_show_yard_and_walkways', true
        ) || jsonb_build_object(
            'source_photos_show_some_staining_and_maintenance_needs', true,
            'access_type', 'public_road',
            'front_road_name', 'ซอยหมู่บ้านอยู่เจริญ',
            'front_road_surface', 'concrete',
            'front_road_width_m', 6,
            'front_right_of_way_width_m', 8,
            'main_access_road', 'ถนนวัตตจารีราษฎร์',
            'distance_along_wattajareerat_road_before_village_turn_m_approx', 140,
            'zoning_color_th', 'สีชมพู',
            'surrounding_area_use_th', 'ที่อยู่อาศัย',
            'source_states_convenient_transportation', true,
            'usable_area_not_published', true,
            'parking_information_not_published', true,
            'building_age_not_published', true,
            'occupancy_status_not_published', true,
            'utilities_information_not_published', true,
            'other_encumbrances_not_published', true,
            'source_information_date_not_published', true,
            'source_recent_property_photo_date_displayed', '2024-04-09',
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-09',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '9.112180,99.292811',
            'administrator_coordinate_distance_from_source_m_approx', 0.128
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z7018. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนสายสุราษฎร์ธานี-พุนพิน (ทล.401)', 'Surat Thani–Phunphin Road (Highway 401)', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'โรงพยาบาลกรุงเทพสุราษฎร์', 'Bangkok Hospital Surat', 'healthcare', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'สถานีขนส่งผู้โดยสารจังหวัดสุราษฎร์ธานี', 'Surat Thani Bus Terminal', 'transit', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'เซ็นทรัล สุราษฎร์ธานี', 'Central Surat Thani', 'shopping', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'โลตัส สุราษฎร์ธานี', 'Lotus’s Surat Thani', 'shopping', NULL, NULL, NULL, 50, true),
        (property_listing_id, 'อินเด็กซ์ ลิฟวิ่งมอลล์ สุราษฎร์ธานี', 'Index Living Mall Surat Thani', 'shopping', NULL, NULL, NULL, 60, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '3,537,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 3,537,000 — confirm the latest price with SAM', 'unspecified', 3537000, 'THB', 20),
        (property_listing_id, 'registered_structures_only', 'สิ่งปลูกสร้างที่จะโอน', 'Structures included in transfer', 'SAM จะโอนตามรายการจดทะเบียนที่มีบ้านและอาคารโรงงาน 2 หลัง แต่ผลสำรวจพบเพียงบ้านพร้อมส่วนต่อเติม ต้องตรวจทะเบียนและการมีอยู่จริงของทุกอาคาร', 'SAM will transfer the registered schedule listing a house and two factory buildings, while the survey found only a house with an extension; verify registrations and whether every building physically exists', 'buyer', NULL, '', 30),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนด แนวเขต ทะเบียนและสภาพจริงของสิ่งปลูกสร้าง การต่อเติม โครงสร้าง หลังคา ความชื้น ระบบไฟฟ้า-ประปา การครอบครอง ภาระผูกพัน ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Verify the title deed, boundaries, registered and actual structures, extensions, structure, roof, moisture, electrical and plumbing systems, possession, encumbrances, costs and latest terms', 'buyer', NULL, '', 40)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'บ้านเดี่ยวชั้นเดียว 8Z7018', 'บ้านเดี่ยวชั้นเดียวเลขที่ 9/140 พร้อมส่วนต่อเติมในหมู่บ้านอยู่เจริญ', 'https://npa.sam.or.th/site/images/npa/16934/20240627104828_8Z7018P1_67.jpg', '/listing-media/sam/8z7018/01.webp', 'image/webp', 26940, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้าถนนวัตตจารีราษฎร์', 'ภาพทางเลี้ยวจากถนนสายสุราษฎร์ธานี-พุนพินเข้าสู่ถนนวัตตจารีราษฎร์', 'https://npa.sam.or.th/site/images/npa/16934/8Z7018P1_65.jpg', '/listing-media/sam/8z7018/02.webp', 'image/webp', 30142, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ลานดินและพื้นที่รอบบ้าน', 'ภาพลานดินกว้างและพื้นที่ระหว่างตัวบ้านกับแนวรั้ว', 'https://npa.sam.or.th/site/images/npa/16934/8Z7018P2_67.jpg', '/listing-media/sam/8z7018/03.webp', 'image/webp', 29902, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ส่วนโล่งหลังคาคลุม', 'ภาพพื้นที่ต่อเติมแบบส่วนโล่งหลังคาคลุมข้างบ้าน', 'https://npa.sam.or.th/site/images/npa/16934/8Z7018P3_67.jpg', '/listing-media/sam/8z7018/04.webp', 'image/webp', 30394, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเดินใต้หลังคาต่อเติม', 'ภาพทางเดินบริเวณส่วนต่อเติมข้างบ้านที่เห็นคราบและร่องรอยใช้งาน', 'https://npa.sam.or.th/site/images/npa/16934/8Z7018P4_67.jpg', '/listing-media/sam/8z7018/05.webp', 'image/webp', 18334, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเดินและลานข้างบ้าน', 'ภาพทางเดินภายนอกและพื้นที่ลานข้างตัวบ้าน', 'https://npa.sam.or.th/site/images/npa/16934/8Z7018P5_67.jpg', '/listing-media/sam/8z7018/06.webp', 'image/webp', 26122, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องภายในพร้อมหน้าต่างสองด้าน', 'ภาพห้องภายในบ้านพื้นกระเบื้องพร้อมหน้าต่างรับแสงสองด้าน', 'https://npa.sam.or.th/site/images/npa/16934/8Z7018P6_67.jpg', '/listing-media/sam/8z7018/07.webp', 'image/webp', 11304, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ภายในเชื่อมทางออก', 'ภาพห้องภายในบ้านพร้อมประตูเชื่อมออกสู่บริเวณด้านนอก', 'https://npa.sam.or.th/site/images/npa/16934/8Z7018P7_67.jpg', '/listing-media/sam/8z7018/08.webp', 'image/webp', 13138, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องภายในอีกมุมหนึ่ง', 'ภาพห้องภายในบ้านพร้อมหน้าต่างและประตูเชื่อมไปยังห้องข้างเคียง', 'https://npa.sam.or.th/site/images/npa/16934/8Z7018P8_67.jpg', '/listing-media/sam/8z7018/09.webp', 'image/webp', 13272, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังตำแหน่งทรัพย์ในหมู่บ้าน', 'ผังแสดงตำแหน่งแปลงทรัพย์ภายในหมู่บ้านอยู่เจริญและเส้นทางเข้า', 'https://npa.sam.or.th/site/images/npa/16934/20190613094155_8Z7018C1_62.jpg', '/listing-media/sam/8z7018/10.webp', 'image/webp', 26120, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังบ้านและส่วนต่อเติมบนแปลง', 'ผังแสดงบ้านพักอาศัยชั้นเดียวและส่วนต่อเติมแบบส่วนโล่งหลังคาคลุมบนแปลงที่ดิน', 'https://npa.sam.or.th/site/images/npa/16934/20190618093426_8Z7018C2_62.jpg', '/listing-media/sam/8z7018/11.webp', 'image/webp', 17670, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แผนที่การเดินทางไปหมู่บ้านอยู่เจริญ', 'แผนที่ต้นทางแสดงเส้นทางจากถนน ทล.401 ผ่านถนนวัตตจารีราษฎร์ไปยังหมู่บ้านอยู่เจริญ', 'https://npa.sam.or.th/site/images/npa/16934/20190618093426_8Z7018M_62.jpg', '/listing-media/sam/8z7018/12.webp', 'image/webp', 59626, 785, 600, 120, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=16934',
        '8Z7018',
        '2026-09-09 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 3,537,000 for a one-storey detached house numbered 9/140 with three bedrooms and two bathrooms in Yoo Charoen Village, on title deed no. 100060 covering 1 ngan 30.3 sq.wah / 130.3 sq.wah / 521.2 sq.m. The polygonal plot has an approximately 16.5-meter eastern side and maximum depth of approximately 33 meters. The property fronts public concrete Yoo Charoen Village Soi, with an approximately six-meter carriageway within an eight-meter right of way. SAM''s registered acquisition schedule lists three structures: the house, one single-storey brick-walled factory building and one single-storey open factory building. The survey instead identifies a one-storey residence with a covered open extension. SAM states that transfer will follow its registered acquisition schedule, so buyers must verify building registrations and whether both factory buildings physically exist. Source property photos displaying 9 April 2024 show a yard, covered extension, walkways and interior rooms, with some staining and maintenance needs visible around the extension and exterior. The page does not publish usable area, parking count, building age, occupancy, utilities, other encumbrances or its detailed information date. Administrator-supplied coordinates are approximately 0.128 meters from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all twelve unique source property, interior, access, plot and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: One-Storey House with Extension in Yoo Charoen Village, THB 3.537M',
        E'One-storey detached house with a covered open extension, numbered 9/140, in Yoo Charoen Village on Wattajareerat Road, Wat Pradu, Mueang Surat Thani, Surat Thani. The house has three bedrooms and two bathrooms on 1 ngan 30.3 sq.wah, or 130.3 sq.wah (521.2 sq.m.), under title deed no. 100060.\n\nThe polygonal plot has an approximately 16.5-meter eastern side and a maximum depth of approximately 33 meters. It fronts public concrete Yoo Charoen Village Soi, with an approximately six-meter carriageway within an approximately eight-meter right of way. The property is in pink zoning within a residential area.\n\nImportant building-record issue: SAM''s registered acquisition schedule lists three structures: a one-storey residential building numbered 9/140, a single-storey brick-walled factory building and a single-storey open factory building. Its condition survey instead found a one-storey residence with a covered open extension. SAM states that it will transfer structures according to its registered acquisition schedule. Buyers must check the building registrations, transfer schedule, whether both factory buildings still physically exist and consistency with actual conditions before submitting an offer.\n\nSource property photos displaying 9 April 2024 show the one-storey house, a dirt yard, covered open extension, walkways and several interior rooms. The interiors appear open, while some extension and exterior areas show staining, age and signs of use. Buyers should have the structure, roof, moisture, electrical and plumbing systems and renovation budget inspected in person by qualified specialists.\n\nAccess is from Surat Thani–Phunphin Road (Highway 401), travelling from Ta Pan intersection toward Phunphin past Lotus Surat Thani, Tha Kub intersection and Index Living Mall. Turn right onto Wattajareerat Road beside the Siam Nissan showroom, continue approximately 140 meters, then turn right into Yoo Charoen Village Soi. Nearby places listed by SAM include Bangkok Hospital Surat, Surat Thani Bus Terminal and Central Surat Thani.\n\nThe SAM page lists the property as direct purchase with an announced sale price of THB 3,537,000. It is not an auction. Contact SAM directly to confirm availability, offer procedures, current price, structures included, possession, expenses and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: 8Z7018. MapxProp does not collect deposits or represent SAM in the transaction.\n\nThe source does not publish usable area, parking count, building age, occupancy, utilities, other encumbrances or a date for its detailed information. Buyers should arrange an inspection and verify current condition, title and boundaries, registered and actual structures, extensions, possession, building systems, encumbrances, expenses and every term before deciding.',
        '9/140, Yoo Charoen Village',
        'Access from Wattajareerat Road via Yoo Charoen Village Soi',
        'Wattajareerat Road',
        'Wat Pradu',
        'Mueang Surat Thani',
        'Surat Thani',
        'SAM Direct-Sale House in Yoo Charoen Village, Surat Thani, THB 3.537M',
        'Official SAM NPA asset 8Z7018: one-storey house with 3 bedrooms and 2 bathrooms on 521.2 sq.m. Direct-sale price THB 3.537M; building-record discrepancy disclosed.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset 8Z7018 one storey detached house Yoo Charoen Village Wattajareerat Road Wat Pradu Mueang Surat Thani 130.3 sq.wah 521.2 sq.m. title deed 100060 three bedrooms two bathrooms THB 3537000 covered extension registered factory buildings')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=16934'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=16934',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 8Z7018. The specifications, images, rounded coordinates, announced price, direct-purchase status, road measurements and registered-versus-surveyed structure discrepancy come from that record.',
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
        '3d15154f-11a8-4aed-837b-8bf86da9f282',
        jsonb_build_object(
            'reference_code', '8Z7018',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'registered_structure_count', 3,
            'registered_and_surveyed_structures_require_reconciliation', true,
            'condition_review_disclosed', true
        )
    );
END $$;

COMMIT;
