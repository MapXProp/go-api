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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing 8Z7379';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing 8Z7379';
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
        '94501616-ccc9-45fc-9c9b-7ee0ccfb58d6',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'detached_house',
        'residence',
        'sale',
        'whole_property',
        'เดอะเซลิโอ',
        '324/107',
        'ขายตรง SAM บ้านเดี่ยวชั้นเดียว เดอะเซลิโอ หางดง 3 ห้องนอน 2 ห้องน้ำ ราคา 2.839 ล้านบาท',
        E'บ้านเดี่ยวชั้นเดียว เลขที่ 324/107 ในโครงการเดอะเซลิโอ ตำบลสันผักหวาน อำเภอหางดง จังหวัดเชียงใหม่ โฉนดที่ดินเลขที่ 71012 จำนวน 1 ฉบับ เนื้อที่ 63 ตร.ว. (252 ตร.ม.) หน้า SAM ระบุ 3 ห้องนอน 2 ห้องน้ำ และรายการรับโอนกรรมสิทธิ์ระบุสิ่งปลูกสร้างเป็นบ้านพักอาศัยตึกชั้นเดียว เลขที่ 324/107\n\nที่ดินรูปสี่เหลี่ยมผืนผ้าเป็นแปลงมุมติดถนน 2 ด้าน ด้านทิศตะวันตกกว้างประมาณ 15 เมตร ด้านทิศใต้กว้างประมาณ 17 เมตร และลึกประมาณ 17 เมตร ผู้ซื้อควรตรวจโฉนด แนวเขต ขนาดจริง ทิศทาง ทางเข้าออก ทะเบียนอาคาร แบบแปลน ใบอนุญาต และรายการสิ่งปลูกสร้างที่จะได้รับโอน\n\nถนนผ่านหน้าทรัพย์เป็นซอยภายในหมู่บ้านเดอะเซลิโอ ซึ่ง SAM ระบุว่าเป็นทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว ผิวจราจรคอนกรีตกว้างประมาณ 6 เมตร และเขตทางกว้างประมาณ 8 เมตร ทรัพย์อยู่ในเขตผังเมืองสีเขียวและย่านที่อยู่อาศัย SAM ระบุว่ามีสาธารณูปโภคครบครันและการคมนาคมสะดวก\n\nSAM ระบุข้อมูลค่าส่วนกลาง ณ วันที่ 7 พฤษภาคม 2567 ประมาณ 7,560 บาทต่อปี ข้อมูลนี้มีวันที่อ้างอิงเก่า ผู้ซื้อต้องยืนยันยอดค้างชำระ อัตราปัจจุบัน ผู้รับผิดชอบ และกฎโครงการกับ SAM และนิติบุคคลหรือผู้ดูแลโครงการก่อนซื้อ\n\nการเดินทางตาม SAM ใช้ถนนรอบเมืองเชียงใหม่ (ทล.121) จากอำเภอสารภีมุ่งหน้าแยกสะเมิง ผ่านวัดท่าใหม่อิ ถึงบริเวณหลักกิโลเมตรที่ 3 เลี้ยวซ้ายเข้าโครงการเดอะเซลิโอประมาณ 430 เมตร แล้วเลี้ยวขวาเข้าซอยภายในโครงการประมาณ 15 เมตร ทรัพย์อยู่ด้านซ้ายมือ หน้า SAM ยังระบุว่าทรัพย์ห่างจากวัดใหม่ท่าอิประมาณ 1.85 กิโลเมตร\n\nหน้า SAM แสดงสถานะ “ซื้อตรง” และราคาประกาศขาย 2,839,000 บาท ณ วันที่ตรวจสอบ 10 กันยายน 2569 ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะผู้ครอบครอง และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ 8Z7379 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nภาพตัวบ้านและภาพภายในต้นทางแสดงวันที่ 17 กรกฎาคม 2567 สภาพจริงอาจเปลี่ยนแปลง หน้า SAM ไม่ได้เผยแพร่พื้นที่ใช้สอย จำนวนที่จอดรถ อายุอาคาร สถานะผู้ครอบครอง ประวัติน้ำท่วม สภาพระบบไฟฟ้า-ประปาภายใน ยอดค่าส่วนกลางปัจจุบัน หรือภาระผูกพันอื่น ผู้ซื้อควรนัดตรวจภายใน โครงสร้าง หลังคา รอยร้าว ความชื้น ปลวก ระบบไฟฟ้าและประปา การระบายน้ำ แนวเขต กฎโครงการ ค่าส่วนกลาง ภาษี ค่าใช้จ่าย และเอกสารทั้งหมดก่อนตัดสินใจ',
        2839000,
        false,
        252,
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
        '324/107 หมู่บ้านเดอะเซลิโอ',
        'เข้าจากถนนรอบเมืองเชียงใหม่ (ทล.121) บริเวณหลักกิโลเมตรที่ 3',
        'ถนนรอบเมืองเชียงใหม่ (ทล.121)',
        NULL,
        18.716767199557715,
        98.97429885240896,
        'เชียงใหม่',
        'หางดง',
        'สันผักหวาน',
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
        'sam-direct-sale-single-storey-house-the-celio-hang-dong-8z7379'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 2839000, 'total', 'THB', false
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
        'detached_house',
        1,
        jsonb_build_object(
            'source_property_category', 'บ้านเดี่ยว',
            'official_page_reference_code', '8Z7379',
            'source_gallery_filename_reference_code', '8Z7379',
            'source_page_id', 17710,
            'project_name', 'เดอะเซลิโอ',
            'listed_unit_number', '324/107',
            'title_document_type', 'chanote',
            'title_deed_number', '71012',
            'title_document_count', 1,
            'land_area_rai', 0,
            'land_area_ngan', 0,
            'land_area_square_wah_remainder', 63,
            'land_area_square_wah', 63,
            'land_area_sqm', 252,
            'bedroom_count', 3,
            'bathroom_count', 2,
            'registered_transfer_description', 'บ้านพักอาศัยตึกชั้นเดียว เลขที่ 324/107',
            'registered_floor_count', 1,
            'plot_count', 1,
            'plot_shape', 'rectangle',
            'corner_plot_two_road_frontages', true,
            'west_road_frontage_m_approx', 15,
            'south_road_frontage_m_approx', 17,
            'maximum_depth_m_approx', 17,
            'front_road_name', 'ซอยภายในหมู่บ้านเดอะเซลิโอ',
            'source_address_road_name', 'ถนนรอบเมืองเชียงใหม่ (ทล.121)',
            'front_road_legal_status_th', 'ทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว',
            'front_road_surface', 'concrete',
            'front_road_width_m_approx', 6,
            'front_right_of_way_width_m_approx', 8,
            'zoning_color_th', 'สีเขียว',
            'surrounding_area_use_th', 'ย่านที่อยู่อาศัย',
            'mixed_use_classification', false,
            'mixed_use_exclusion_basis', 'SAM ระบุประเภททรัพย์เป็นบ้านเดี่ยวและย่านโดยรอบเป็นที่อยู่อาศัย ไม่ได้ระบุการใช้เชิงธุรกิจหรือ Mixed Use',
            'residential_classification', true,
            'utilities_described_as_complete_by_source', true,
            'transport_described_as_convenient_by_source', true
        ) || jsonb_build_object(
            'common_fee_amount_thb_per_year_approx', 7560,
            'common_fee_information_as_of', '2024-05-07',
            'common_fee_requires_current_confirmation', true,
            'usable_area_not_published', true,
            'parking_count_not_published', true,
            'building_age_not_published', true,
            'occupancy_status_not_published', true,
            'flood_history_not_published', true,
            'internal_utilities_condition_not_published', true,
            'other_encumbrances_not_published', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'computed_price_per_square_wah', 45063.49,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_property_photo_date_displayed', '2024-07-17',
            'source_video_url', 'https://www.youtube.com/watch?v=lXkOHvvC9_U&list=PLEasGlVospOqXpSgegjOOgRaF7nk9c-dS&index=1&t=13s',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '18.7168002,98.9743628',
            'administrator_coordinate_distance_from_source_m_approx', 7.67,
            'online_pin_not_boundary_evidence', true
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
        listing_id, role_code, authority_source_code, organization_name,
        organization_registration_no, verification_status, verification_note,
        verified_at, verified_by_user_id, organization_id, contact_user_id
    ) VALUES (
        property_listing_id,
        'developer_investor_representative',
        'investor_asset_holder',
        'บริษัท บริหารสินทรัพย์สุขุมวิท จำกัด (SAM)',
        '0105543033809',
        'authority_verified',
        'The official SAM NPA page identifies SAM as the asset holder and direct-sale contact for 8Z7379. Specifications, title deed, registered house, source images, rounded coordinates, announced price, direct-purchase status, road measurements, common-fee information and planning-zone wording come from that page. MapxProp does not collect deposits or represent SAM in the transaction.',
        now(), admin_user_id, sam_organization_id, NULL
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
        (property_listing_id, 'ถนนรอบเมืองเชียงใหม่ (ทล.121)', 'Chiang Mai Ring Road, Highway 121', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'วัดใหม่ท่าอิ', 'Wat Mai Tha I', 'landmark', 1850, NULL, NULL, 20, true),
        (property_listing_id, 'แยกสะเมิง', 'Samoeng Intersection', 'landmark', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'หมู่บ้านเดอะเซลิโอ', 'The Celio', 'landmark', NULL, NULL, NULL, 40, true)
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
        (property_listing_id, 'sale_method', 'วิธีซื้อ', 'Purchase method', 'ซื้อตรงจาก SAM — ติดต่อ SAM เพื่อเสนอซื้อ', 'Direct purchase from SAM — contact SAM to submit an offer', 'unspecified', NULL, '', 10),
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '2,839,000 บาท — โปรดตรวจสอบราคาล่าสุดและโปรโมชั่นกับ SAM', 'THB 2,839,000 — confirm the latest price and promotions with SAM', 'unspecified', 2839000, 'THB', 20),
        (property_listing_id, 'title_and_registered_structure', 'เอกสารสิทธิ์และสิ่งปลูกสร้างตามรายการรับโอน', 'Title and registered structure', 'โฉนดเลขที่ 71012 จำนวน 1 ฉบับ เนื้อที่ 63 ตร.ว. พร้อมบ้านพักอาศัยตึกชั้นเดียว เลขที่ 324/107', 'Title deed no. 71012, one document, covering 63 sq.wah with a registered single-storey masonry residence numbered 324/107', 'unspecified', NULL, '', 30),
        (property_listing_id, 'rooms', 'ห้องนอนและห้องน้ำ', 'Bedrooms and bathrooms', 'SAM ระบุ 3 ห้องนอน 2 ห้องน้ำ', 'SAM lists three bedrooms and two bathrooms', 'unspecified', NULL, '', 40),
        (property_listing_id, 'corner_plot_dimensions', 'แปลงมุมและขนาดแนวแปลง', 'Corner plot and dimensions', 'แปลงรูปสี่เหลี่ยมผืนผ้าติดถนน 2 ด้าน ทิศตะวันตกกว้างประมาณ 15 เมตร ทิศใต้กว้างประมาณ 17 เมตร ลึกประมาณ 17 เมตร', 'Rectangular corner plot fronting two roads, approximately fifteen metres on the west, seventeen metres on the south and seventeen metres deep', 'unspecified', NULL, '', 50),
        (property_listing_id, 'internal_project_road', 'ถนนภายในโครงการ', 'Internal development road', 'ซอยในเดอะเซลิโอเป็นทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว ผิวคอนกรีตกว้างประมาณ 6 เมตร เขตทางประมาณ 8 เมตร', 'The Celio internal soi is a road in an authorized allocated development, with an approximately six-metre concrete carriageway in an eight-metre right of way', 'unspecified', 6, 'metres', 60),
        (property_listing_id, 'common_fee', 'ค่าส่วนกลาง', 'Common fee', 'SAM ระบุประมาณ 7,560 บาทต่อปี ณ วันที่ 7 พฤษภาคม 2567 ต้องยืนยันยอดและอัตราปัจจุบันอีกครั้ง', 'SAM stated approximately THB 7,560 per year as of 7 May 2024; confirm the current rate and any outstanding amount', 'unspecified', 7560, 'THB_per_year', 70),
        (property_listing_id, 'source_photo_date', 'วันที่ภาพทรัพย์', 'Property photo date', 'ภาพตัวบ้านและภายในต้นทางแสดงวันที่ 17 กรกฎาคม 2567 สภาพปัจจุบันอาจเปลี่ยนแปลง', 'Source house and interior photos display 17 July 2024; present condition may differ', 'buyer', NULL, '', 80),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนด แนวเขต บ้านตามรายการรับโอน ทะเบียนอาคาร แบบแปลน ใบอนุญาต สภาพภายใน ระบบไฟฟ้า-ประปา น้ำท่วม การครอบครอง ภาระผูกพัน กฎโครงการ ค่าส่วนกลาง ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Verify title, boundaries, the registered house, building records, plans, permits, interior condition, electrical and plumbing systems, flooding, possession, encumbrances, development rules, common fees, costs and latest terms', 'buyer', NULL, '', 90)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'บ้านเดี่ยวชั้นเดียว เลขที่ 324/107', 'บ้านเดี่ยวชั้นเดียวเลขที่ 324/107 ในเดอะเซลิโอ หางดง รหัส SAM 8Z7379', 'https://npa.sam.or.th/site/images/npa/17710/20241227142234_8Z7379P2_67.jpg', '/listing-media/sam/8z7379/01.webp', 'image/webp', 21712, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมบ้านและถนนด้านข้าง', 'ภาพบ้านแปลงมุมเลขที่ 324/107 กับถนนคอนกรีตด้านข้าง', 'https://npa.sam.or.th/site/images/npa/17710/8Z7379P3_67.jpg', '/listing-media/sam/8z7379/02.webp', 'image/webp', 20906, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมบ้านจากถนนอีกด้าน', 'ภาพแนวบ้าน รั้ว และถนนอีกด้านของแปลงมุมในเดอะเซลิโอ', 'https://npa.sam.or.th/site/images/npa/17710/8Z7379P4_67.jpg', '/listing-media/sam/8z7379/03.webp', 'image/webp', 25156, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ข้างบ้าน', 'ภาพพื้นที่ดินและทางเดินบริเวณข้างบ้านเลขที่ 324/107', 'https://npa.sam.or.th/site/images/npa/17710/8Z7379P5_67.jpg', '/listing-media/sam/8z7379/04.webp', 'image/webp', 29162, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ประตูด้านข้างและพื้นที่บริการ', 'ภาพประตูด้านข้างบ้านพร้อมพื้นที่ปูกระเบื้องและส่วนบริการ', 'https://npa.sam.or.th/site/images/npa/17710/8Z7379P6_67.jpg', '/listing-media/sam/8z7379/05.webp', 'image/webp', 12544, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเดินข้างบ้าน', 'ภาพทางเดินแคบและแนวกำแพงบริเวณด้านข้างบ้าน', 'https://npa.sam.or.th/site/images/npa/17710/8Z7379P7_67.jpg', '/listing-media/sam/8z7379/06.webp', 'image/webp', 17746, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ชานบ้านและพื้นที่ในร่ม', 'ภาพชานบ้านยกระดับและพื้นที่ในร่มด้านหน้าหรือด้านข้างตัวบ้าน', 'https://npa.sam.or.th/site/images/npa/17710/8Z7379P8_67.jpg', '/listing-media/sam/8z7379/07.webp', 'image/webp', 11138, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องโถงภายในบ้าน มุมที่หนึ่ง', 'ภาพห้องโถงปูกระเบื้องภายในบ้านพร้อมวอลล์เปเปอร์', 'https://npa.sam.or.th/site/images/npa/17710/8Z7379P9_67.jpg', '/listing-media/sam/8z7379/08.webp', 'image/webp', 11666, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องโถงภายในบ้าน มุมที่สอง', 'ภาพห้องโถงภายในบ้าน มองไปยังหน้าต่างและประตูกระจก', 'https://npa.sam.or.th/site/images/npa/17710/8Z7379P10_67.jpg', '/listing-media/sam/8z7379/09.webp', 'image/webp', 10662, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'เคาน์เตอร์ครัว', 'ภาพเคาน์เตอร์ครัวพร้อมอ่างล้างและตู้เก็บของภายในบ้าน', 'https://npa.sam.or.th/site/images/npa/17710/8Z7379P11_67.jpg', '/listing-media/sam/8z7379/10.webp', 'image/webp', 11040, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอน มุมที่หนึ่ง', 'ภาพห้องนอนภายในบ้านพร้อมหน้าต่างสองด้าน', 'https://npa.sam.or.th/site/images/npa/17710/8Z7379P12_67.jpg', '/listing-media/sam/8z7379/11.webp', 'image/webp', 8548, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอน มุมที่สอง', 'ภาพห้องนอนภายในบ้านพร้อมหน้าต่างและพื้นกระเบื้อง', 'https://npa.sam.or.th/site/images/npa/17710/8Z7379P13_67.jpg', '/listing-media/sam/8z7379/12.webp', 'image/webp', 8478, 450, 450, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำห้องที่หนึ่ง', 'ภาพห้องน้ำพร้อมสุขภัณฑ์ อ่างล้างหน้า และกระจก', 'https://npa.sam.or.th/site/images/npa/17710/8Z7379P14_67.jpg', '/listing-media/sam/8z7379/13.webp', 'image/webp', 7606, 450, 450, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำห้องที่สอง', 'ภาพห้องน้ำอีกห้องพร้อมสุขภัณฑ์และอ่างล้างหน้า', 'https://npa.sam.or.th/site/images/npa/17710/8Z7379P15_67.jpg', '/listing-media/sam/8z7379/14.webp', 'image/webp', 7904, 450, 450, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'จุดเลี้ยวเข้าเดอะเซลิโอจากทางหลวง 121', 'ภาพจุดเลี้ยวจากถนนรอบเมืองเชียงใหม่ ทล.121 เข้าหมู่บ้านเดอะเซลิโอ', 'https://npa.sam.or.th/site/images/npa/17710/8Z7379P1_65.jpg', '/listing-media/sam/8z7379/15.webp', 'image/webp', 19040, 450, 450, 150, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังแปลงมุมและตัวบ้าน', 'ผังต้นทางแสดงแปลงโฉนดเลขที่ 71012 ติดถนนจัดสรรด้านตะวันตกและใต้ พร้อมตัวบ้านชั้นเดียว', 'https://npa.sam.or.th/site/images/npa/17710/20191011112110_8Z7379C1_62.jpg', '/listing-media/sam/8z7379/16.webp', 'image/webp', 12000, 450, 450, 160, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปเดอะเซลิโอ', 'แผนที่ต้นทาง SAM แสดงเส้นทางจากถนนรอบเมืองเชียงใหม่ ทล.121 เข้าหมู่บ้านเดอะเซลิโอ', 'https://npa.sam.or.th/site/images/npa/17710/20241212140614_8Z7379M1_65.jpg', '/listing-media/sam/8z7379/17.webp', 'image/webp', 27796, 785, 600, 170, false, true);

    INSERT INTO public.listing_sources (
        listing_id, source_type, publisher_name, source_url,
        reference_code, captured_at, notes
    ) VALUES (
        property_listing_id,
        'editorial_import',
        'บริษัท บริหารสินทรัพย์สุขุมวิท จำกัด (SAM)',
        'https://www.sam.or.th/site/npa/detail.php?id=17710&keyref=6004858',
        '8Z7379',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA page id 17710. The page showed direct-purchase status and an announced sale price of THB 2,839,000 for a single-storey detached house numbered 324/107 in The Celio, San Phak Wan, Hang Dong, Chiang Mai. Title deed no. 71012 covers 63 sq.wah / 252 sq.m. The source lists three bedrooms and two bathrooms and identifies the registered transferred structure as a single-storey masonry residence numbered 324/107. The rectangular corner plot fronts two roads, approximately fifteen metres on the west and seventeen metres on the south, with a maximum depth of approximately seventeen metres. The Celio internal soi is described as a concrete road in an authorized allocated development, approximately six metres wide within an approximately eight-metre right of way. The source identifies green planning zoning, residential surroundings, complete utilities and convenient transport. SAM reported an approximate annual common fee of THB 7,560 as of 7 May 2024; buyers must confirm the current rate, arrears, responsibility and development rules. Usable area, parking count, building age, occupancy, flood history, internal utility condition and other encumbrances are not published. House and interior photos display 17 July 2024. Administrator coordinates are approximately 7.67 metres from the rounded source coordinates and are used for the listing. The official page links a source video. MapxProp stores optimized copies of all seventeen unique source property, interior, access, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Single-Storey House in The Celio, Hang Dong, THB 2.839M',
        E'A single-storey detached house numbered 324/107 in The Celio, San Phak Wan, Hang Dong, Chiang Mai. Title deed no. 71012, one document, covers 63 sq.wah (252 sq.m.). SAM lists three bedrooms and two bathrooms and identifies the registered transferred structure as a single-storey masonry residence numbered 324/107.\n\nThe rectangular corner plot fronts two roads. The west side is approximately fifteen metres wide, the south side approximately seventeen metres wide, and the maximum depth approximately seventeen metres. Buyers should verify the title, survey, boundaries, measurements, directions, access, building registration, approved plans, permits and transferred structure.\n\nThe Celio internal soi is described as a concrete road in an authorized allocated development, approximately six metres wide within an approximately eight-metre right of way. SAM identifies green planning zoning and residential surroundings and describes complete utilities and convenient transport.\n\nSAM reported an approximate common fee of THB 7,560 per year as of 7 May 2024. This dated figure is not necessarily current. Buyers should confirm the present rate, arrears, payer responsibility, rules and services with SAM and the development manager.\n\nSAM directions use Chiang Mai Ring Road, Highway 121, from Saraphi toward Samoeng Intersection. Pass Wat Tha Mai I and, around kilometre three, turn left into The Celio for approximately 430 metres. Turn right into the internal soi for approximately fifteen metres; the property is on the left. The source also states the property is approximately 1.85 kilometres from Wat Mai Tha I.\n\nThe SAM page listed the property for direct purchase at an announced THB 2,839,000 when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, offer procedures, current price, promotions, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: 8Z7379. MapxProp does not collect deposits or represent SAM.\n\nSource house and interior photos display 17 July 2024, and conditions may have changed. The source does not publish usable area, parking count, building age, occupancy, flood history, current common-fee balance, internal electrical and plumbing condition or other encumbrances. Buyers should inspect the interior, structure, roof, cracks, moisture, termites, electrical and plumbing systems, drainage, boundaries, development rules, common fees, taxes, costs and every current term before deciding.',
        '324/107, The Celio',
        'Access from Chiang Mai Ring Road, Highway 121, near kilometre three',
        'Chiang Mai Ring Road, Highway 121',
        'San Phak Wan',
        'Hang Dong',
        'Chiang Mai',
        'SAM House in The Celio, Hang Dong, THB 2.839M',
        'Official SAM asset 8Z7379: single-storey detached house with three bedrooms and two bathrooms on a 63 sq.wah corner plot in The Celio. Direct-sale price THB 2.839M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset 8Z7379 detached house single storey 324/107 The Celio San Phak Wan Hang Dong Chiang Mai Highway 121 63 sq.wah 252 sq.m. 3 bedrooms 2 bathrooms title deed 71012 THB 2839000')
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
        SELECT 1 FROM public.organization_verifications
        WHERE organization_id = sam_organization_id
          AND verification_type = 'listing_authority'
          AND status = 'verified'
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=17710&keyref=6004858'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=17710&keyref=6004858',
            'The official SAM NPA page identifies SAM as the asset holder and direct-sale contact for 8Z7379. Specifications, title deed, registered single-storey house, images, video link, rounded coordinates, announced price, direct-purchase status, road measurements, common-fee information and planning-zone wording come from that page.',
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
        '94501616-ccc9-45fc-9c9b-7ee0ccfb58d6',
        jsonb_build_object(
            'reference_code', '8Z7379',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'residence',
            'discovery_channels', jsonb_build_array('homes'),
            'title_document_count', 1,
            'registered_floor_count', 1,
            'bedroom_count', 3,
            'bathroom_count', 2,
            'corner_plot_two_road_frontages', true,
            'common_fee_information_as_of', '2024-05-07',
            'source_video_available', true,
            'source_image_count', 17
        )
    );
END $$;

COMMIT;
