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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing HL0763';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing HL0763';
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
        'bada7450-ecea-44b2-9ce8-04978c4d2328',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'detached_house',
        'residence',
        'sale',
        'whole_property',
        'อรสิริน 11',
        '188/48',
        'ขายตรง SAM บ้านเดี่ยว 2 ชั้น อรสิริน 11 สันทราย 3 ห้องนอน 2 ห้องน้ำ ราคา 2.6 ล้านบาท',
        E'บ้านเดี่ยว 2 ชั้น เลขที่ 188/48 ในหมู่บ้านอรสิริน 11 ตำบลหนองหาร อำเภอสันทราย จังหวัดเชียงใหม่ บนโฉนดที่ดินเลขที่ 94696 จำนวน 1 ฉบับ เนื้อที่ 50.8 ตร.ว. (203.2 ตร.ม.) หน้า SAM ระบุ 3 ห้องนอน 2 ห้องน้ำ และรายการรับโอนกรรมสิทธิ์ระบุสิ่งปลูกสร้างเป็นบ้านพักอาศัยตึกสองชั้น เลขที่ 188/48\n\nที่ดินรูปสี่เหลี่ยมผืนผ้า ด้านติดถนนโครงการกว้างประมาณ 14 เมตร และลึกสุดประมาณ 14.5 เมตร แปลนต้นทางแสดงพื้นที่ชั้น 1 จำนวน 49.60 ตร.ม. พื้นที่จอดรถ 16.20 ตร.ม. เฉลียงหรือระเบียง 2 จุดประมาณ 2.60 และ 3.60 ตร.ม. และพื้นที่ชั้น 2 จำนวน 60.25 ตร.ม. ตัวเลขเหล่านี้เป็นข้อความกำกับในแปลน ไม่ใช่พื้นที่ใช้สอยรวมที่ SAM รับรอง ผู้ซื้อควรตรวจแบบแปลน ทะเบียนอาคาร ใบอนุญาต ขนาดจริง และรายการสิ่งปลูกสร้างที่จะได้รับโอน\n\nถนนผ่านหน้าทรัพย์เป็นถนนคอนกรีตภายในหมู่บ้านอรสิริน 11 ซอย 4 ซึ่ง SAM ระบุว่าเป็นทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว ผิวจราจรกว้างประมาณ 8 เมตร และเขตทางประมาณ 11 เมตร ทรัพย์อยู่ในเขตผังเมืองสีส้ม ย่านที่อยู่อาศัย SAM ระบุว่ามีสาธารณูปโภคครบครันและการคมนาคมสะดวก แต่ผู้ซื้อควรตรวจสภาพและเงื่อนไขการใช้บริการจริงกับโครงการและหน่วยงานที่เกี่ยวข้อง\n\nการเดินทางตาม SAM ใช้ถนนเชียงใหม่-พร้าว (ทล.1001) จากมหาวิทยาลัยแม่โจ้มุ่งหน้าอำเภอพร้าว ผ่านศูนย์วิจัยและพัฒนาประมงน้ำจืดเชียงใหม่ สำนักงานเทศบาลเมืองแม่โจ้ และสำนักงานเกษตรอำเภอสันทราย แล้วเลี้ยวซ้ายเข้าซอย 4 ชุมชนแม่โจ้ใหม่ประมาณ 200 เมตร ตรงเข้าหมู่บ้านอรสิริน 11 เลี้ยวซ้ายและขวาเข้าซอย 4 รวมประมาณ 320 เมตร ทรัพย์อยู่ด้านขวามือ\n\nหน้า SAM แสดงสถานะ “ซื้อตรง” และราคาประกาศขาย 2,600,000 บาท ณ วันที่ตรวจสอบ 10 กันยายน 2569 ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะผู้ครอบครอง และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ HL0763 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nภาพทรัพย์ต้นทางแสดงวันที่ 26 พฤศจิกายน 2568 สภาพจริงอาจเปลี่ยนแปลง หน้า SAM ไม่ได้เผยแพร่พื้นที่ใช้สอยรวม จำนวนที่จอดรถ อายุอาคาร สถานะผู้ครอบครอง ประวัติน้ำท่วม ค่าส่วนกลาง หรือภาระผูกพันอื่น ผู้ซื้อควรนัดตรวจโครงสร้าง หลังคา รอยร้าว ความชื้น ปลวก ระบบไฟฟ้าและประปา การระบายน้ำ แนวเขต กฎโครงการ ค่าส่วนกลาง ภาษี ค่าใช้จ่าย และเอกสารทั้งหมดก่อนตัดสินใจ\n\nหมายเหตุภาพต้นทาง: ชื่อไฟล์แผนที่ของ SAM มีรหัส 8Z6687 อยู่ในวงเล็บ และหน้า SAM ระบุว่ามีทรัพย์รหัส 8Z6687 อยู่ในโครงการเดียวกัน จึงบันทึกภาพนี้เป็นแผนที่ร่วมของโครงการ ไม่ใช่หลักฐานว่ารหัสทรัพย์ปัจจุบันเปลี่ยนแปลง เมื่อติดต่อ SAM ให้ใช้อ้างอิงรหัส HL0763 และหน้า id 22906',
        2600000,
        false,
        203.2,
        3,
        2,
        2,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        '188/48 หมู่บ้านอรสิริน 11',
        'ซอย 4; เข้าจากถนนเชียงใหม่-พร้าว (ทล.1001) ผ่านซอย 4 ชุมชนแม่โจ้ใหม่',
        'ถนนภายในหมู่บ้านอรสิริน 11 ซอย 4',
        NULL,
        18.902200382770296,
        99.00076793410621,
        'เชียงใหม่',
        'สันทราย',
        'หนองหาร',
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
        'sam-direct-sale-two-storey-house-ornsirin-11-san-sai-hl0763'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 2600000, 'total', 'THB', false
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
            'official_page_reference_code', 'HL0763',
            'source_gallery_filename_reference_code', 'HL0763',
            'source_page_id', 22906,
            'project_name', 'อรสิริน 11',
            'project_soi', 'ซอย 4',
            'listed_unit_number', '188/48',
            'title_document_type', 'chanote',
            'title_deed_number', '94696',
            'title_document_count', 1,
            'land_area_rai', 0,
            'land_area_ngan', 0,
            'land_area_square_wah_remainder', 50.8,
            'land_area_square_wah', 50.8,
            'land_area_sqm', 203.2,
            'bedroom_count', 3,
            'bathroom_count', 2,
            'registered_transfer_description', 'บ้านพักอาศัยตึกสองชั้น เลขที่ 188/48',
            'registered_floor_count', 2,
            'plot_count', 1,
            'plot_shape', 'rectangle',
            'road_frontage_m', 14,
            'maximum_depth_m', 14.5,
            'front_road_name', 'ถนนภายในหมู่บ้านอรสิริน 11 ซอย 4',
            'source_address_road_name', 'ถนนสายเชียงใหม่-พร้าว (ทล.1001)',
            'front_road_legal_status_th', 'ทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว',
            'front_road_surface', 'concrete',
            'front_road_width_m_approx', 8,
            'front_right_of_way_width_m_approx', 11,
            'zoning_color_th', 'สีส้ม',
            'surrounding_area_use_th', 'ย่านที่อยู่อาศัย',
            'mixed_use_classification', false,
            'mixed_use_exclusion_basis', 'SAM ระบุประเภททรัพย์เป็นบ้านเดี่ยวในโครงการที่อยู่อาศัยและไม่ได้ระบุการใช้เชิงธุรกิจหรือ Mixed Use',
            'residential_classification', true,
            'utilities_described_as_complete_by_source', true,
            'transport_described_as_convenient_by_source', true,
            'building_permit_authority_th', 'เทศบาลเมืองแม่โจ้'
        ) || jsonb_build_object(
            'ground_floor_area_annotation_sqm', 49.60,
            'second_floor_area_annotation_sqm', 60.25,
            'computed_two_floor_area_from_plan_annotations_sqm', 109.85,
            'covered_parking_area_annotation_sqm', 16.20,
            'terrace_area_annotations_sqm', jsonb_build_array(2.60, 3.60),
            'plan_area_annotations_are_not_published_total_usable_area', true,
            'usable_area_not_published', true,
            'parking_count_not_published', true,
            'building_age_not_published', true,
            'occupancy_status_not_published', true,
            'flood_history_not_published', true,
            'common_fee_information_not_published', true,
            'other_encumbrances_not_published', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'computed_price_per_square_wah', 51181.10,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_property_photo_date_displayed', '2025-11-26',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '18.902203,99.000770',
            'administrator_coordinate_distance_from_source_m_approx', 0.36,
            'online_pin_not_boundary_evidence', true,
            'nearby_sam_asset_codes', jsonb_build_array('8Z6687'),
            'source_map_filename', '20251218143318_HL0763M_68 (8Z6687).jpg',
            'source_map_filename_shared_asset_reference_code', '8Z6687',
            'source_reference_code_discrepancy', true,
            'shared_map_with_same_project_asset', true
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
        'The official SAM NPA page identifies SAM as the asset holder and direct-sale contact for HL0763. Its map filename also contains 8Z6687, which the page identifies as another SAM asset in the same development; buyers should quote current asset HL0763 and page id 22906. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนเชียงใหม่-พร้าว (ทล.1001)', 'Chiang Mai-Phrao Highway 1001', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ซอย 4 ชุมชนแม่โจ้ใหม่', 'Soi 4, Mae Jo Mai Community', 'road', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'มหาวิทยาลัยแม่โจ้', 'Maejo University', 'education', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'สำนักงานเกษตรอำเภอสันทราย', 'San Sai District Agricultural Office', 'government', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'สำนักงานเทศบาลเมืองแม่โจ้', 'Mae Jo Town Municipality Office', 'government', NULL, NULL, NULL, 50, true),
        (property_listing_id, 'ศูนย์วิจัยและพัฒนาประมงน้ำจืดเชียงใหม่', 'Chiang Mai Inland Fisheries Research and Development Center', 'government', NULL, NULL, NULL, 60, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '2,600,000 บาท — โปรดตรวจสอบราคาล่าสุดและโปรโมชั่นกับ SAM', 'THB 2,600,000 — confirm the latest price and promotions with SAM', 'unspecified', 2600000, 'THB', 20),
        (property_listing_id, 'title_and_registered_house', 'เอกสารสิทธิ์และบ้านตามรายการรับโอน', 'Title and registered house', 'โฉนดเลขที่ 94696 จำนวน 1 ฉบับ เนื้อที่ 50.8 ตร.ว. พร้อมบ้านพักอาศัยตึกสองชั้น เลขที่ 188/48', 'Title deed no. 94696, one document, covering 50.8 sq.wah with a registered two-storey masonry residence numbered 188/48', 'unspecified', NULL, '', 30),
        (property_listing_id, 'rooms', 'ห้องนอนและห้องน้ำ', 'Bedrooms and bathrooms', 'SAM ระบุ 3 ห้องนอน 2 ห้องน้ำ', 'SAM lists three bedrooms and two bathrooms', 'unspecified', NULL, '', 40),
        (property_listing_id, 'plot_dimensions', 'ขนาดแนวแปลง', 'Plot dimensions', 'แปลงรูปสี่เหลี่ยมผืนผ้า หน้ากว้างติดถนนประมาณ 14 เมตร ลึกสุดประมาณ 14.5 เมตร', 'Rectangular plot with approximately fourteen metres of road frontage and a maximum depth of approximately 14.5 metres', 'unspecified', 14, 'metres', 50),
        (property_listing_id, 'plan_area_annotations', 'ตัวเลขพื้นที่ในแปลน', 'Areas annotated on plans', 'แปลนระบุชั้น 1 จำนวน 49.60 ตร.ม. ชั้น 2 จำนวน 60.25 ตร.ม. ที่จอดรถ 16.20 ตร.ม. และเฉลียงหรือระเบียง 2.60 กับ 3.60 ตร.ม. ต้องตรวจขนาดจริงและนิยามพื้นที่กับ SAM', 'Plans annotate 49.60 sq.m. on the ground floor, 60.25 sq.m. on the second floor, 16.20 sq.m. for covered parking and terraces or balconies of 2.60 and 3.60 sq.m.; verify measurements and definitions with SAM', 'buyer', NULL, '', 60),
        (property_listing_id, 'internal_project_road', 'ถนนภายในโครงการ', 'Internal development road', 'ถนนหมู่บ้านอรสิริน 11 ซอย 4 เป็นทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว ผิวคอนกรีตกว้างประมาณ 8 เมตร เขตทางประมาณ 11 เมตร', 'Ornsirin 11 Soi 4 is an internal road in an authorized allocated development, with an approximately eight-metre concrete carriageway in an eleven-metre right of way', 'unspecified', 8, 'metres', 70),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนด แนวเขต ทะเบียนอาคาร แบบแปลน ใบอนุญาต สภาพบ้าน ระบบไฟฟ้า-ประปา น้ำท่วม การครอบครอง ภาระผูกพัน กฎโครงการ ค่าส่วนกลาง ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Verify title, boundaries, building registration, plans, permits, house condition, electrical and plumbing systems, flooding, possession, encumbrances, development rules, common fees, costs and latest terms', 'buyer', NULL, '', 80)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'บ้านเดี่ยว 2 ชั้น เลขที่ 188/48', 'บ้านเดี่ยว 2 ชั้น เลขที่ 188/48 หมู่บ้านอรสิริน 11 สันทราย รหัส SAM HL0763', 'https://npa.sam.or.th/site/images/npa/22906/20251218143318_HL0763P4_68.jpg', '/listing-media/sam/hl0763/01.webp', 'image/webp', 34846, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมบ้านจากถนนในโครงการ', 'มุมบ้านและแนวรั้วจากถนนภายในหมู่บ้านอรสิริน 11', 'https://npa.sam.or.th/site/images/npa/22906/HL0763P3_68.jpg', '/listing-media/sam/hl0763/02.webp', 'image/webp', 26598, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ด้านหน้าแปลงและแนวถนน', 'ภาพด้านหน้าแปลงบ้านเลขที่ 188/48 และถนนคอนกรีตในโครงการ', 'https://npa.sam.or.th/site/images/npa/22906/HL0763P5_68.jpg', '/listing-media/sam/hl0763/03.webp', 'image/webp', 31620, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ลานและทางเข้าบ้าน', 'ภาพบริเวณลาน ทางเข้าบ้าน และประตูกระจกชั้นล่าง', 'https://npa.sam.or.th/site/images/npa/22906/HL0763P6_68.jpg', '/listing-media/sam/hl0763/04.webp', 'image/webp', 26132, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงภายในชั้นล่าง', 'ภาพโถงภายในบ้านชั้นล่างพร้อมช่องครัวและประตูกระจก', 'https://npa.sam.or.th/site/images/npa/22906/HL0763P7_68.jpg', '/listing-media/sam/hl0763/05.webp', 'image/webp', 10684, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'จุดเลี้ยวจากถนนเชียงใหม่-พร้าว', 'ภาพจุดเลี้ยวจากถนนเชียงใหม่-พร้าว ทล.1001 เข้าซอย 4 ชุมชนแม่โจ้ใหม่', 'https://npa.sam.or.th/site/images/npa/22906/HL0763P1_68.jpg', '/listing-media/sam/hl0763/06.webp', 'image/webp', 22822, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้าหมู่บ้านอรสิริน 11', 'ภาพซอย 4 ชุมชนแม่โจ้ใหม่บริเวณทางเข้าหมู่บ้านอรสิริน 11', 'https://npa.sam.or.th/site/images/npa/22906/HL0763P2_68.jpg', '/listing-media/sam/hl0763/07.webp', 'image/webp', 20026, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'แปลนบ้านชั้น 1', 'แปลนต้นทาง SAM แสดงโถง ครัว ห้องน้ำ บันได ที่จอดรถ และเฉลียงของชั้น 1', 'https://npa.sam.or.th/site/images/npa/22906/HL0763C4_68.jpg', '/listing-media/sam/hl0763/08.webp', 'image/webp', 8996, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'แปลนบ้านชั้น 2', 'แปลนต้นทาง SAM แสดง 3 ห้องนอน 1 ห้องน้ำ และโถงบันไดของชั้น 2', 'https://npa.sam.or.th/site/images/npa/22906/HL0763C5_68.jpg', '/listing-media/sam/hl0763/09.webp', 'image/webp', 7986, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังตำแหน่งบ้านในอรสิริน 11', 'ผังโครงการต้นทางแสดงตำแหน่งแปลงบ้านภายในหมู่บ้านอรสิริน 11 และระยะจากทางเข้า', 'https://npa.sam.or.th/site/images/npa/22906/HL0763C3_68.jpg', '/listing-media/sam/hl0763/10.webp', 'image/webp', 22330, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังแปลงโฉนดเลขที่ 94696', 'ผังต้นทางแสดงแปลงสี่เหลี่ยมผืนผ้า หน้ากว้างประมาณ 14 เมตรและลึกประมาณ 14.5 เมตร', 'https://npa.sam.or.th/site/images/npa/22906/20251218143318_HL0763C1_68.jpg', '/listing-media/sam/hl0763/11.webp', 'image/webp', 13154, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังบ้านบนแปลงเลขที่ 188/48', 'ผังต้นทางแสดงตำแหน่งบ้านสองชั้นเลขที่ 188/48 ระหว่างบ้านเลขที่ 188/47 และ 188/49', 'https://npa.sam.or.th/site/images/npa/22906/20251218143318_HL0763C2_68.jpg', '/listing-media/sam/hl0763/12.webp', 'image/webp', 17346, 450, 450, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปอรสิริน 11', 'แผนที่ต้นทาง SAM แสดงเส้นทางจากถนนเชียงใหม่-พร้าว ทล.1001 ผ่านซอย 4 ชุมชนแม่โจ้ใหม่ไปหมู่บ้านอรสิริน 11', 'https://npa.sam.or.th/site/images/npa/22906/20251218143318_HL0763M_68 (8Z6687).jpg', '/listing-media/sam/hl0763/13.webp', 'image/webp', 32614, 785, 600, 130, false, true);

    INSERT INTO public.listing_sources (
        listing_id, source_type, publisher_name, source_url,
        reference_code, captured_at, notes
    ) VALUES (
        property_listing_id,
        'editorial_import',
        'บริษัท บริหารสินทรัพย์สุขุมวิท จำกัด (SAM)',
        'https://www.sam.or.th/site/npa/detail.php?id=22906&keyref=6004858',
        'HL0763',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA page id 22906. The page showed direct-purchase status and an announced sale price of THB 2,600,000 for a two-storey detached house numbered 188/48 in Ornsirin 11, Nong Han, San Sai, Chiang Mai. Title deed no. 94696 covers 50.8 sq.wah / 203.2 sq.m. The source lists three bedrooms and two bathrooms and identifies the registered transferred structure as a two-storey masonry residence numbered 188/48. The rectangular plot has approximately fourteen metres of project-road frontage and a maximum depth of approximately 14.5 metres. Ornsirin 11 Soi 4 is described as an internal concrete road in an authorized allocated development, approximately eight metres wide within an approximately eleven-metre right of way. The source identifies orange planning zoning, residential surroundings, complete utilities and convenient transport. Floor plans annotate 49.60 sq.m. on the ground floor and 60.25 sq.m. on the second floor, plus 16.20 sq.m. for covered parking and terrace or balcony annotations of 2.60 and 3.60 sq.m.; these annotations are recorded for transparency but are not treated as a source-published total usable area. Parking count, building age, occupancy, flood history, common fees and other encumbrances are not published. Property images display 26 November 2025. Administrator coordinates are approximately 0.36 metres from the rounded source coordinates and are used for the listing. The SAM map filename contains alternate asset code 8Z6687, and the page identifies 8Z6687 as another asset in the same project; MapxProp treats the image as a shared project map and retains HL0763 as the current listing reference. MapxProp stores optimized copies of all thirteen unique source property, access, floor-plan, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Two-Storey House in Ornsirin 11, San Sai, THB 2.6M',
        E'A two-storey detached house numbered 188/48 in Ornsirin 11, Nong Han, San Sai, Chiang Mai. Title deed no. 94696, one document, covers 50.8 sq.wah (203.2 sq.m.). SAM lists three bedrooms and two bathrooms and identifies the registered transferred structure as a two-storey masonry residence numbered 188/48.\n\nThe rectangular plot has approximately fourteen metres of frontage on the internal development road and a maximum depth of approximately 14.5 metres. Source plans annotate 49.60 sq.m. on the ground floor and 60.25 sq.m. on the second floor, plus 16.20 sq.m. of covered parking and terrace or balcony areas of 2.60 and 3.60 sq.m. These are plan annotations rather than a source-published total usable area. Buyers should verify measurements, building registration, approved plans, permits, boundaries and all structures included in the transfer.\n\nOrnsirin 11 Soi 4 is described as an internal concrete road in an authorized allocated development, approximately eight metres wide within an approximately eleven-metre right of way. SAM identifies orange planning zoning and residential surroundings and describes complete utilities and convenient transport. Buyers should confirm present utility service, project rules and all applicable planning and building requirements.\n\nSAM directions use Chiang Mai-Phrao Highway 1001 from Maejo University toward Phrao, passing the Chiang Mai Inland Fisheries Research and Development Center, Mae Jo Town Municipality and the San Sai District Agricultural Office. Turn left into Soi 4, Mae Jo Mai Community, continue approximately 200 metres into Ornsirin 11, then turn left and right into Soi 4. The total route inside is approximately 320 metres, and the property is on the right.\n\nThe SAM page listed the property for direct purchase at an announced THB 2,600,000 when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, offer procedures, current price, promotions, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: HL0763. MapxProp does not collect deposits or represent SAM.\n\nProperty photos display 26 November 2025, and conditions may have changed. The source does not publish a total usable area, parking count, building age, occupancy, flood history, common fees or other encumbrances. Buyers should inspect the structure, roof, cracks, moisture, termites, electrical and plumbing systems, drainage, boundaries, development rules, common fees, taxes, costs and every current term before deciding.\n\nSource-media note: the current page and property images use HL0763, while the navigation-map filename also contains 8Z6687. The SAM page identifies 8Z6687 as another asset in the same development, so the map is treated as shared project navigation rather than evidence that this asset code changed. Quote HL0763 and page id 22906 when contacting SAM.',
        '188/48, Ornsirin 11',
        'Soi 4; access from Chiang Mai-Phrao Highway 1001 through Soi 4, Mae Jo Mai Community',
        'Ornsirin 11 internal road, Soi 4',
        'Nong Han',
        'San Sai',
        'Chiang Mai',
        'SAM House in Ornsirin 11, San Sai, THB 2.6M',
        'Official SAM asset HL0763: two-storey house with three bedrooms and two bathrooms on 50.8 sq.wah in Ornsirin 11, San Sai. Direct-sale price THB 2.6M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset HL0763 detached house two storey 188/48 Ornsirin 11 Nong Han San Sai Chiang Mai Highway 1001 50.8 sq.wah 203.2 sq.m. 3 bedrooms 2 bathrooms title deed 94696 THB 2600000')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=22906&keyref=6004858'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=22906&keyref=6004858',
            'The official SAM NPA page identifies SAM as the asset holder and direct-sale contact for HL0763. Specifications, title deed, registered house, images, rounded coordinates, announced price, direct-purchase status, road measurements, planning-zone wording and the same-project 8Z6687 map reference come from that page.',
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
        'bada7450-ecea-44b2-9ce8-04978c4d2328',
        jsonb_build_object(
            'reference_code', 'HL0763',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'residence',
            'discovery_channels', jsonb_build_array('homes'),
            'title_document_count', 1,
            'registered_floor_count', 2,
            'bedroom_count', 3,
            'bathroom_count', 2,
            'source_reference_discrepancy', true,
            'shared_map_asset_code', '8Z6687',
            'source_image_count', 13
        )
    );
END $$;

COMMIT;
