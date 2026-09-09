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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing BL0080';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing BL0080';
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
        '605bcc52-becb-4e2c-9fad-2b0c26b44bca',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'warehouse',
        'business',
        'sale',
        'whole_property',
        'ขายตรง SAM โรงงาน/โกดังห้องเย็น บางริ้น ระนอง 2 ไร่ 3 งาน 82 ตร.ว. ราคา 20.042 ล้านบาท',
        E'โรงงานและโกดังห้องเย็นในตำบลบางริ้น อำเภอเมืองระนอง จังหวัดระนอง บนที่ดิน 2 ไร่ 3 งาน 82 ตร.ว. (4,728 ตร.ม.) ใกล้ถนนเพชรเกษม (ทล.4)\n\nที่ดินโฉนดเลขที่ 13414 จำนวน 1 ฉบับ รูปคล้ายสี่เหลี่ยมผืนผ้า ด้านทิศเหนือติดซอยริมคลองบางริ้น หน้ากว้างประมาณ 61 เมตร ลึกสุดประมาณ 90 เมตร อยู่ในเขตผังเมืองสีเขียว ถนนหน้าทรัพย์เป็นทางสาธารณประโยชน์ ผิวคอนกรีตกว้างประมาณ 5 เมตร เขตทางประมาณ 6 เมตร ผู้ซื้อควรตรวจสอบความเหมาะสมสำหรับรถบรรทุกและการใช้งานจริงด้วยตนเอง\n\nรายการสิ่งปลูกสร้างที่ SAM จดทะเบียนรับโอนมี 6 รายการ ได้แก่ อาคารห้องเย็นชั้นเดียว 4 หลัง บ้านพักอาศัยตึกชั้นเดียว 1 หลัง และอาคารสำนักงาน 1 หลัง ส่วนข้อมูลสำรวจสภาพทรัพย์ระบุรูปแบบอาคาร 7 รายการ ได้แก่ ห้องเย็น 3 หลัง บ้านพักคนงาน สำนักงานพร้อมที่พักอาศัย อาคารคอนกรีตเสริมเหล็กชั้นเดียว และอาคารหลังคาคลุมชั้นเดียว การโอนกรรมสิทธิ์จะอ้างอิงเฉพาะรายการสิ่งปลูกสร้างที่ SAM จดทะเบียนรับโอน ผู้ซื้อจึงต้องตรวจสอบทะเบียนอาคาร ขอบเขต และสภาพจริงก่อนเสนอซื้อ\n\nสำคัญ: SAM ระบุว่ามีผู้ใช้ประโยชน์ในทรัพย์สินและขายตามสภาพ ผู้ซื้อต้องตรวจสอบทรัพย์ก่อนเสนอซื้อ และอาจต้องเจรจาหรือดำเนินการทางกฎหมายเพื่อเข้าครอบครองด้วยค่าใช้จ่ายของผู้ซื้อเอง โดยไม่สามารถใช้ประเด็นการครอบครองเป็นเหตุยกเลิกการเสนอซื้อหรือสัญญา และไม่สามารถเรียกร้องจาก SAM ได้ ข้อมูลส่วนนี้ในหน้าต้นทางระบุ ณ วันที่ 24 มิถุนายน 2568 จึงควรสอบถามสถานะล่าสุดกับ SAM\n\nเดินทางจากถนนเพชรเกษม (ทล.4) ฝั่งอำเภอกะเปอร์มุ่งหน้าเมืองระนอง ผ่านสำนักงานเขตพื้นที่การศึกษาระนอง โรงเรียนบ้านพรรั้ง กองกำกับการตำรวจภูธรจังหวัดระนอง และโรงเรียนบ้านบางริ้น เลี้ยวเข้าซอยริมคลองบางริ้นประมาณ 670 เมตร ทรัพย์อยู่ด้านซ้ายมือ ใกล้พิสูจน์หลักฐานจังหวัดระนอง โรงพยาบาลส่งเสริมสุขภาพตำบลบางริ้น และโครงการชลประทานระนอง สำนักงานชลประทานที่ 14\n\nหน้า SAM ระบุสถานะ “ซื้อตรง” และราคาประกาศขาย 20,042,000 บาท ลดจากราคาประกาศเดิม 20,896,000 บาท ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อตรวจสอบว่ายังพร้อมขาย สถานะผู้ใช้ประโยชน์ ขั้นตอนเสนอซื้อ รายการสิ่งปลูกสร้างที่จะโอน ค่าใช้จ่าย และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ BL0080 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nไม่มีข้อมูลพื้นที่ใช้สอยอาคาร กำลังไฟฟ้า ใบอนุญาตโรงงาน ความสูงอาคาร ระบบทำความเย็น หรือขนาดรถบรรทุกที่เข้าถึงได้ในหน้าต้นทาง ผู้ซื้อควรตรวจสอบข้อมูลเหล่านี้ รวมถึงเอกสารสิทธิ์ สภาพทรัพย์ ภาระผูกพัน แนวเขต และข้อกำหนดการใช้ประโยชน์ที่ดินก่อนตัดสินใจ',
        20042000,
        false,
        4728,
        1,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sale@sam.or.th',
        '@samline',
        true,
        true,
        'ซอยริมคลองบางริ้น',
        'ใกล้ถนนเพชรเกษม (ทล.4)',
        'ซอยริมคลองบางริ้น',
        '85000',
        9.91914507,
        98.62376890,
        'ระนอง',
        'เมืองระนอง',
        'บางริ้น',
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
        'sam-direct-sale-cold-storage-warehouse-bang-rin-ranong-bl0080'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES
        (property_listing_id, 'storage'),
        (property_listing_id, 'industrial')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 20042000, 'total', 'THB', false
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
        property_listing_id, 'business', 'editorial', false
    )
    ON CONFLICT (listing_id, channel_code) DO UPDATE SET
        source = EXCLUDED.source,
        is_featured = EXCLUDED.is_featured,
        updated_at = now();

    INSERT INTO public.listing_category_details (
        listing_id, category_code, schema_version, details, is_minimum_submission
    ) VALUES (
        property_listing_id,
        'warehouse',
        1,
        jsonb_build_object(
            'land_area_rai', 2,
            'land_area_ngan', 3,
            'land_area_square_wah', 82,
            'warehouse_type', 'cold_storage',
            'source_property_category', 'โรงงาน/โกดัง',
            'title_deed_number', '13414',
            'title_document_count', 1,
            'plot_shape', 'near_rectangle',
            'north_road_frontage_m', 61,
            'maximum_depth_m', 90,
            'zoning_color_th', 'สีเขียว',
            'access_type', 'public_road',
            'front_road_name', 'ซอยริมคลองบางริ้น',
            'front_road_surface', 'concrete',
            'front_road_width_m', 5,
            'front_right_of_way_width_m', 6,
            'registered_transferred_structure_count', 6,
            'registered_transferred_structures', jsonb_build_array(
                'อาคารห้องเย็นชั้นเดียว หลังที่ 1',
                'อาคารห้องเย็นชั้นเดียว หลังที่ 2',
                'อาคารห้องเย็นชั้นเดียว หลังที่ 3',
                'อาคารห้องเย็นชั้นเดียว หลังที่ 4',
                'บ้านพักอาศัยตึกชั้นเดียว',
                'อาคารสำนักงาน'
            ),
            'surveyed_structure_count', 7,
            'surveyed_structures', jsonb_build_array(
                'อาคารห้องเย็นชั้นเดียว หลังที่ 1',
                'อาคารบ้านพักคนงานชั้นเดียว',
                'อาคารสำนักงานและพักอาศัยชั้นเดียว',
                'อาคารห้องเย็นชั้นเดียว หลังที่ 2',
                'อาคารห้องเย็นชั้นเดียว หลังที่ 3',
                'อาคารคอนกรีตเสริมเหล็กชั้นเดียว',
                'อาคารหลังคาคลุมชั้นเดียว'
            ),
            'transfer_limited_to_registered_structures', true,
            'structure_records_require_buyer_review', true,
            'property_has_current_user', true,
            'occupancy_information_dated_on', '2025-06-24',
            'sold_as_is', true,
            'buyer_responsible_for_obtaining_possession', true,
            'usable_area_not_published', true,
            'power_specification_not_published', true,
            'factory_or_warehouse_licence_not_published', true,
            'truck_access_not_published', true,
            'purchase_method', 'direct_purchase_from_sam',
            'previous_announced_sale_price_thb', 20896000,
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for BL0080. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนเพชรเกษม (ทล.4)', 'Phet Kasem Road (Highway 4)', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'โรงเรียนบ้านบางริ้น', 'Ban Bang Rin School', 'education', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'พิสูจน์หลักฐานจังหวัดระนอง', 'Ranong Provincial Forensic Science Office', 'government', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'โรงพยาบาลส่งเสริมสุขภาพตำบลบางริ้น', 'Bang Rin Subdistrict Health Promoting Hospital', 'healthcare', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'โครงการชลประทานระนอง สำนักงานชลประทานที่ 14', 'Ranong Irrigation Project, Regional Irrigation Office 14', 'government', NULL, NULL, NULL, 50, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '20,042,000 บาท ลดจากราคาประกาศเดิม 20,896,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 20,042,000, reduced from the previous announced price of THB 20,896,000 — confirm the latest price with SAM', 'unspecified', 20042000, 'THB', 20),
        (property_listing_id, 'occupancy_and_possession', 'ผู้ใช้ประโยชน์และการเข้าครอบครอง', 'Current user and possession', 'มีผู้ใช้ประโยชน์ในทรัพย์ ผู้ซื้อรับผิดชอบการเจรจาหรือดำเนินการทางกฎหมายและค่าใช้จ่ายเพื่อเข้าครอบครองเอง', 'The property has a current user; the buyer is responsible for negotiations or legal action and the costs of obtaining possession', 'buyer', NULL, '', 30),
        (property_listing_id, 'registered_structure_transfer', 'ขอบเขตสิ่งปลูกสร้างที่โอน', 'Registered structures included in transfer', 'SAM จะโอนเฉพาะรายการสิ่งปลูกสร้างที่จดทะเบียนรับโอนกรรมสิทธิ์ไว้ ผู้ซื้อต้องตรวจสอบรายการกับสภาพจริง', 'SAM will transfer only the structures registered in its ownership records; buyers must reconcile those records with actual conditions', 'unspecified', NULL, '', 40),
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ด้านหน้าทรัพย์ริมซอย', 'ด้านหน้าโรงงานและโกดังห้องเย็นริมซอยริมคลองบางริ้น', 'https://npa.sam.or.th/site/images/npa/22458/20250410123950_BL0080P3_68.jpg', '/listing-media/sam/bl0080/01.webp', 'image/webp', 21240, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวเขตด้านหน้าอีกมุม', 'อาคารและแนวเขตโรงงานโกดังริมถนนคอนกรีต', 'https://npa.sam.or.th/site/images/npa/22458/BL0080P4_68.jpg', '/listing-media/sam/bl0080/02.webp', 'image/webp', 19460, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมด้านข้างแปลง', 'มุมด้านข้างแปลงและอาคารภายในทรัพย์', 'https://npa.sam.or.th/site/images/npa/22458/BL0080P2_68.jpg', '/listing-media/sam/bl0080/03.webp', 'image/webp', 22346, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'อาคารห้องเย็น', 'อาคารโกดังห้องเย็นชั้นเดียวภายในทรัพย์', 'https://npa.sam.or.th/site/images/npa/22458/BL0080P5_68.jpg', '/listing-media/sam/bl0080/04.webp', 'image/webp', 22684, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้าจากถนนเพชรเกษม', 'จุดเลี้ยวจากถนนเพชรเกษมเข้าสู่ซอยริมคลองบางริ้น', 'https://npa.sam.or.th/site/images/npa/22458/BL0080P1_68.jpg', '/listing-media/sam/bl0080/05.webp', 'image/webp', 16458, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังรูปแปลงที่ดิน', 'ผังโฉนดเลขที่ 13414 แสดงหน้ากว้างประมาณ 61 เมตรและลึกประมาณ 90 เมตร', 'https://npa.sam.or.th/site/images/npa/22458/20250410123950_BL0080C1_68.jpg', '/listing-media/sam/bl0080/06.webp', 'image/webp', 13714, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังสิ่งปลูกสร้าง', 'ผังแสดงตำแหน่งอาคารห้องเย็น บ้านพักคนงาน สำนักงาน และอาคารประกอบภายในแปลง', 'https://npa.sam.or.th/site/images/npa/22458/20250410123950_BL0080C2_68.jpg', '/listing-media/sam/bl0080/07.webp', 'image/webp', 22256, 450, 450, 70, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=22458',
        'BL0080',
        '2026-09-09 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed a direct-purchase status and an announced sale price of THB 20,042,000, reduced from THB 20,896,000 in SAM publication 5.2/2569. The page states that the property has a current user and is sold as is; the buyer bears responsibility and costs for obtaining possession. Occupancy and condition notes are dated 24 June 2025 and require reconfirmation. SAM also distinguishes six registered transferred structures from seven surveyed structure descriptions and will transfer only registered structures. Building areas, electrical capacity, cooling-system condition, licences, clear height, and truck access are not published. Administrator-supplied coordinates are within approximately two meters of the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all seven source property and diagram images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Cold-Storage Warehouse Complex in Bang Rin, Ranong, 2 Rai 3 Ngan 82 Sq.Wah, THB 20.042M',
        E'Factory and cold-storage warehouse complex in Bang Rin, Mueang Ranong, Ranong, on 2 rai 3 ngan 82 sq.wah (4,728 sq.m.) of land near Phet Kasem Road (Highway 4).\n\nTitle deed no. 13414 covers a near-rectangular plot. The north side fronts Rim Khlong Bang Rin Soi for approximately 61 meters, with a maximum depth of approximately 90 meters. The source identifies green zoning. The public concrete road in front is approximately 5 meters wide within a 6-meter right of way. Buyers should independently verify its suitability for their required truck size and operations.\n\nSAM''s registered acquisition records list six structures: four single-storey cold-storage buildings, one single-storey residence, and one office building. The condition survey instead describes seven structures: three cold-storage buildings, worker accommodation, a combined office and residence, a single-storey reinforced-concrete building, and a single-storey roofed structure. SAM states that the transfer will cover only structures registered in its ownership records. Buyers must reconcile the building records, boundaries, and actual condition before submitting an offer.\n\nImportant: SAM states that the property has a current user and is sold as is. The buyer must inspect before submitting an offer and may need to negotiate or take legal action to obtain possession at the buyer''s own cost. Occupancy cannot be used to cancel an offer or agreement or to make claims against SAM. This source note is dated 24 June 2025, so the current status must be reconfirmed.\n\nAccess is from Phet Kasem Road via Rim Khlong Bang Rin Soi, approximately 670 meters to the property. Nearby destinations listed by SAM include Ban Bang Rin School, the Ranong Provincial Forensic Science Office, Bang Rin Subdistrict Health Promoting Hospital, and the Ranong Irrigation Project.\n\nThe SAM page lists the property as “direct purchase” with an announced sale price of THB 20,042,000, reduced from the previous announced price of THB 20,896,000. It is not an auction. Contact SAM directly to confirm availability, the current user, offer procedure, structures included in the transfer, expenses, and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: BL0080. MapxProp does not collect deposits or represent SAM in the transaction.\n\nThe source does not publish building floor area, electrical capacity, factory or warehouse licences, clear height, cooling-system condition, or supported truck size. Buyers should verify these items along with title documents, encumbrances, boundaries, zoning, and property condition before deciding.',
        'Rim Khlong Bang Rin Soi',
        'Near Phet Kasem Road (Highway 4)',
        'Rim Khlong Bang Rin Soi',
        'Bang Rin',
        'Mueang Ranong',
        'Ranong',
        'SAM Direct-Sale Cold-Storage Warehouse in Bang Rin, Ranong, THB 20.042M',
        'Official SAM NPA asset BL0080: a direct-sale cold-storage warehouse complex on 4,728 sq.m. in Bang Rin, Ranong. Announced price THB 20.042M; property has a current user.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset BL0080 factory warehouse cold storage Bang Rin Mueang Ranong Ranong Phet Kasem Rim Khlong Bang Rin 2 rai 3 ngan 82 sq.wah 4728 sq.m. THB 20042000')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=22458'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=22458',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for BL0080. The specifications, images, rounded coordinates, announced price, direct-purchase status, occupancy warning, and registered-structure limitation come from that record.',
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
        '605bcc52-becb-4e2c-9fad-2b0c26b44bca',
        jsonb_build_object(
            'reference_code', 'BL0080',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'occupancy_warning', true
        )
    );
END $$;

COMMIT;
