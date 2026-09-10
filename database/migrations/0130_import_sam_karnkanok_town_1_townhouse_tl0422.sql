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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing TL0422';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing TL0422';
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
        '7431be56-8a85-4471-9b0b-9d3e867f2d46',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'townhouse',
        'residence',
        'sale',
        'whole_property',
        'กาญจน์กนกทาวน์ 1',
        '58/32',
        'ขายตรง SAM ทาวน์เฮ้าส์ 2 ชั้นหลังมุม กาญจน์กนกทาวน์ 1 สารภี 119.6 ตร.ว. ราคา 3.262 ล้านบาท',
        E'ทาวน์เฮ้าส์ 2 ชั้นหลังมุม เลขที่ 58/32 ในโครงการกาญจน์กนกทาวน์ 1 ตำบลหนองผึ้ง อำเภอสารภี จังหวัดเชียงใหม่ โฉนดที่ดินเลขที่ 635 จำนวน 1 ฉบับ เนื้อที่ 1 งาน 19.6 ตร.ว. หรือรวม 119.6 ตร.ว. (478.4 ตร.ม.) รายการรับโอนกรรมสิทธิ์ของ SAM ระบุสิ่งปลูกสร้างเป็นทาวน์เฮ้าส์สองชั้นเลขที่ 58/32 พร้อมโรงจอดรถ\n\nที่ดินเป็นรูปหลายเหลี่ยม ด้านทิศใต้กว้างประมาณ 21.5 เมตร โดยส่วนที่ติดถนนกว้างประมาณ 8 เมตร และลึกสุดประมาณ 27.75 เมตร ผังต้นทางแสดงแปลงรูปหลายเหลี่ยมที่มีด้านอื่นประมาณ 17.5, 24 และ 13.5 เมตร ผู้ซื้อควรตรวจโฉนด แนวเขต ขนาดจริง ทิศทาง ทางเข้าออก ทะเบียนอาคาร แบบแปลน ใบอนุญาต และยืนยันว่าทาวน์เฮ้าส์กับโรงจอดรถอยู่ในรายการที่จะได้รับโอนครบถ้วน\n\nถนนผ่านหน้าทรัพย์เป็นถนนหมู่บ้านซอย 4 ภายในกาญจน์กนกทาวน์ 1 ซึ่ง SAM ระบุว่าเป็นทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว ผิวจราจรคอนกรีตกว้างประมาณ 6 เมตร และเขตทางกว้างประมาณ 8 เมตร ทรัพย์อยู่ในเขตผังเมืองสีเหลืองและย่านที่อยู่อาศัย\n\nการเดินทางตาม SAM ใช้ถนนเลียบทางรถไฟเชียงใหม่-ลำพูน จากจังหวัดลำพูนมุ่งหน้าตัวเมืองเชียงใหม่ ผ่านแยกถนนสายเลี่ยงเมืองเชียงใหม่ (ทล.121) เลี้ยวซ้ายเข้าทางเข้าหมู่บ้านกาญจน์กนกทาวน์ 1 ประมาณ 70 เมตร จากนั้นเลี้ยวซ้ายเข้าหมู่บ้านและถนนซอย 4 รวมประมาณ 300 เมตร ทรัพย์อยู่ด้านขวามือ สถานที่ใกล้เคียงที่ SAM ระบุ ได้แก่ วัดเชียงแสน วัดสันคือ และวัดผางยอย\n\nหน้า SAM แสดงสถานะ “ซื้อตรง” และราคาประกาศขาย 3,262,000 บาท ณ วันที่ตรวจสอบ 10 กันยายน 2569 ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะผู้ครอบครอง และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ TL0422 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nภาพตัวบ้านต้นทางแสดงวันที่ 18 ตุลาคม 2567 และแสดงสิ่งของจำนวนหนึ่งบริเวณบ้านในวันถ่าย แต่ไม่ใช่หลักฐานยืนยันสถานะผู้ครอบครองปัจจุบัน SAM ไม่มีภาพภายในและไม่ได้เผยแพร่จำนวนห้องนอน ห้องน้ำ พื้นที่ใช้สอย จำนวนที่จอดรถ อายุอาคาร สถานะผู้ครอบครอง ประวัติน้ำท่วม ค่าส่วนกลาง สภาพระบบไฟฟ้า-ประปาภายใน หรือภาระผูกพันอื่น ผู้ซื้อควรนัดตรวจภายใน โครงสร้าง หลังคา รอยร้าว ความชื้น ปลวก ระบบไฟฟ้าและประปา การระบายน้ำ แนวเขต กฎโครงการ ค่าส่วนกลาง ภาษี ค่าใช้จ่าย และเอกสารทั้งหมดก่อนตัดสินใจ\n\nหมายเหตุภาพต้นทาง: ชื่อไฟล์แผนที่ของ SAM มีรหัส 4T0973 อยู่ในวงเล็บ แม้หน้าและภาพทรัพย์ใช้รหัส TL0422 อีกทั้งภาพทางเข้าและแผนที่มีชื่อบ้านเชียงแสนประกอบเส้นทาง ขณะที่หน้ารายละเอียดระบุโครงการกาญจน์กนกทาวน์ 1 เมื่อติดต่อ SAM ให้ใช้อ้างอิงรหัส TL0422 และหน้า id 22240 พร้อมขอให้ยืนยันความเกี่ยวข้องของรหัสและชื่อสถานที่ในภาพแผนที่',
        3262000,
        false,
        478.4,
        NULL,
        NULL,
        2,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        '58/32 หมู่บ้านกาญจน์กนกทาวน์ 1 ซอย 4',
        'เข้าจากถนนเลียบทางรถไฟเชียงใหม่-ลำพูน ผ่านแยกถนนสายเลี่ยงเมืองเชียงใหม่ (ทล.121)',
        'ถนนเลียบทางรถไฟเชียงใหม่-ลำพูน',
        NULL,
        18.744857012954157,
        99.02404989432002,
        'เชียงใหม่',
        'สารภี',
        'หนองผึ้ง',
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
        'sam-direct-sale-two-storey-townhouse-karnkanok-town-1-saraphi-tl0422'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 3262000, 'total', 'THB', false
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
        'townhouse',
        1,
        jsonb_build_object(
            'source_property_category', 'ทาวน์เฮ้าส์',
            'official_page_reference_code', 'TL0422',
            'source_gallery_filename_reference_code', 'TL0422',
            'source_page_id', 22240,
            'project_name', 'กาญจน์กนกทาวน์ 1',
            'listed_unit_number', '58/32',
            'title_document_type', 'chanote',
            'title_deed_number', '635',
            'title_document_count', 1,
            'land_area_rai', 0,
            'land_area_ngan', 1,
            'land_area_square_wah_remainder', 19.6,
            'land_area_square_wah', 119.6,
            'land_area_sqm', 478.4,
            'registered_transfer_description', 'ทาวน์เฮ้าส์สองชั้น เลขที่ 58/32, โรงจอดรถ',
            'registered_floor_count', 2,
            'registered_garage_reported', true,
            'plot_count', 1,
            'plot_shape', 'polygon',
            'end_unit_classification', true,
            'south_side_width_m_approx', 21.5,
            'south_road_frontage_m_approx', 8,
            'maximum_depth_m_approx', 27.75,
            'front_road_name', 'ถนนหมู่บ้านกาญจน์กนกทาวน์ 1 ซอย 4',
            'source_address_road_name', 'ถนนเลียบทางรถไฟเชียงใหม่-ลำพูน',
            'front_road_legal_status_th', 'ทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว',
            'front_road_surface', 'concrete',
            'front_road_width_m_approx', 6,
            'front_right_of_way_width_m_approx', 8,
            'zoning_color_th', 'สีเหลือง',
            'surrounding_area_use_th', 'ย่านที่อยู่อาศัย',
            'mixed_use_classification', false,
            'mixed_use_exclusion_basis', 'SAM ระบุประเภททรัพย์เป็นทาวน์เฮ้าส์และย่านโดยรอบเป็นที่อยู่อาศัย ไม่ได้ระบุการใช้เชิงธุรกิจหรือ Mixed Use',
            'residential_classification', true
        ) || jsonb_build_object(
            'bedroom_count_not_published', true,
            'bathroom_count_not_published', true,
            'usable_area_not_published', true,
            'parking_count_not_published', true,
            'building_age_not_published', true,
            'occupancy_status_not_published', true,
            'flood_history_not_published', true,
            'common_fee_information_not_published', true,
            'internal_utilities_condition_not_published', true,
            'other_encumbrances_not_published', true,
            'source_interior_images_not_published', true,
            'source_images_show_household_items', true,
            'source_images_are_not_current_occupancy_evidence', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'computed_price_per_square_wah', 27274.25,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_property_photo_date_displayed', '2024-10-18',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '18.744872,99.024036',
            'administrator_coordinate_distance_from_source_m_approx', 2.22,
            'online_pin_not_boundary_evidence', true,
            'source_map_filename', '20241127144704_TL0422M_67(4T0973).jpg',
            'source_map_filename_alternate_reference_code', '4T0973',
            'source_reference_code_discrepancy', true,
            'source_access_image_and_map_reference_ban_chiang_saen', true,
            'alternate_reference_and_place_relationship_require_sam_confirmation', true
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
        'The official SAM NPA page identifies SAM as the asset holder and direct-sale contact for TL0422. Specifications, title deed, registered townhouse and garage, source images, rounded coordinates, announced price, direct-purchase status, road measurements and planning-zone wording come from that page. The map filename also contains 4T0973, and an access image and the map reference Ban Chiang Saen while the page identifies Karnkanok Town 1; buyers should quote TL0422 and page id 22240 and ask SAM to confirm those source-media references. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนเลียบทางรถไฟเชียงใหม่-ลำพูน', 'Chiang Mai-Lamphun Railway Frontage Road', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ถนนสายเลี่ยงเมืองเชียงใหม่ (ทล.121)', 'Chiang Mai Ring Road, Highway 121', 'road', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'วัดเชียงแสน', 'Wat Chiang Saen', 'landmark', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'วัดสันคือ', 'Wat San Khue', 'landmark', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'วัดผางยอย', 'Wat Phang Yoi', 'landmark', NULL, NULL, NULL, 50, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '3,262,000 บาท — โปรดตรวจสอบราคาล่าสุดและโปรโมชั่นกับ SAM', 'THB 3,262,000 — confirm the latest price and promotions with SAM', 'unspecified', 3262000, 'THB', 20),
        (property_listing_id, 'title_and_registered_structures', 'เอกสารสิทธิ์และสิ่งปลูกสร้างตามรายการรับโอน', 'Title and registered structures', 'โฉนดเลขที่ 635 จำนวน 1 ฉบับ เนื้อที่ 1 งาน 19.6 ตร.ว. พร้อมทาวน์เฮ้าส์สองชั้นเลขที่ 58/32 และโรงจอดรถ', 'Title deed no. 635, one document, covering 1 ngan 19.6 sq.wah with a registered two-storey townhouse numbered 58/32 and a garage', 'unspecified', NULL, '', 30),
        (property_listing_id, 'plot_dimensions', 'รูปแปลงและขนาดแนวแปลง', 'Plot shape and dimensions', 'แปลงรูปหลายเหลี่ยม ด้านทิศใต้กว้างประมาณ 21.5 เมตร ส่วนติดถนนประมาณ 8 เมตร และลึกสุดประมาณ 27.75 เมตร', 'Polygonal plot with an approximately 21.5-metre south side, approximately eight metres of road frontage and a maximum depth of approximately 27.75 metres', 'unspecified', 8, 'metres', 40),
        (property_listing_id, 'internal_project_road', 'ถนนภายในโครงการ', 'Internal development road', 'ถนนหมู่บ้านกาญจน์กนกทาวน์ 1 ซอย 4 เป็นทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว ผิวคอนกรีตกว้างประมาณ 6 เมตร เขตทางประมาณ 8 เมตร', 'Karnkanok Town 1 Soi 4 is a road in an authorized allocated development, with an approximately six-metre concrete carriageway in an eight-metre right of way', 'unspecified', 6, 'metres', 50),
        (property_listing_id, 'source_photo_and_occupancy', 'วันที่ภาพและสถานะการครอบครอง', 'Photo date and occupancy', 'ภาพวันที่ 18 ตุลาคม 2567 แสดงสิ่งของบริเวณบ้าน แต่ SAM ไม่ระบุสถานะผู้ครอบครองปัจจุบัน ต้องตรวจสอบกับ SAM และตรวจสถานที่จริง', 'Photos dated 18 October 2024 show household items at the property, but SAM does not publish current occupancy; confirm it with SAM and inspect the property', 'buyer', NULL, '', 60),
        (property_listing_id, 'source_media_discrepancy', 'ข้อสังเกตภาพแผนที่ต้นทาง', 'Source-media discrepancy', 'ชื่อไฟล์แผนที่มีรหัส 4T0973 และภาพเส้นทางมีชื่อบ้านเชียงแสน ขณะที่หน้าทรัพย์ใช้รหัส TL0422 และโครงการกาญจน์กนกทาวน์ 1 โปรดยืนยันกับ SAM', 'The map filename contains 4T0973 and route media reference Ban Chiang Saen, while the property page uses TL0422 and Karnkanok Town 1; confirm the relationship with SAM', 'buyer', NULL, '', 70),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนด แนวเขต ทาวน์เฮ้าส์และโรงจอดรถตามรายการรับโอน ทะเบียนอาคาร แบบแปลน ใบอนุญาต สภาพภายใน จำนวนห้อง ระบบไฟฟ้า-ประปา น้ำท่วม การครอบครอง ภาระผูกพัน กฎโครงการ ค่าส่วนกลาง ค่าใช้จ่าย และเงื่อนไขล่าสุด', 'Verify title, boundaries, the registered townhouse and garage, building records, plans, permits, interior condition, room counts, electrical and plumbing systems, flooding, possession, encumbrances, development rules, common fees, costs and latest terms', 'buyer', NULL, '', 80)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ทาวน์เฮ้าส์ 2 ชั้นหลังมุม เลขที่ 58/32', 'ทาวน์เฮ้าส์ 2 ชั้นหลังมุมเลขที่ 58/32 กาญจน์กนกทาวน์ 1 สารภี รหัส SAM TL0422', 'https://npa.sam.or.th/site/images/npa/22240/20241127144704_TL0422P3_67.jpg', '/listing-media/sam/tl0422/01.webp', 'image/webp', 23718, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'จุดเลี้ยวจากถนนเลียบทางรถไฟ', 'ภาพจุดเลี้ยวจากถนนเลียบทางรถไฟเชียงใหม่-ลำพูนเข้าซอยบ้านเชียงแสนตามคำกำกับต้นทาง', 'https://npa.sam.or.th/site/images/npa/22240/TL0422P1_67.jpg', '/listing-media/sam/tl0422/02.webp', 'image/webp', 22346, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้ากาญจน์กนกทาวน์ 1', 'ภาพจุดเลี้ยวเข้าซอยหมู่บ้านกาญจน์กนกทาวน์ 1 จากถนนในพื้นที่', 'https://npa.sam.or.th/site/images/npa/22240/TL0422P2_67.jpg', '/listing-media/sam/tl0422/03.webp', 'image/webp', 18734, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังแปลงรูปหลายเหลี่ยม', 'ผังต้นทางแสดงแปลงรูปหลายเหลี่ยมติดถนนซอย 4 พร้อมแนวติดถนนประมาณ 8 เมตรและด้านลึกประมาณ 27.75 เมตร', 'https://npa.sam.or.th/site/images/npa/22240/20241127144704_TL0422C2_67.jpg', '/listing-media/sam/tl0422/04.webp', 'image/webp', 12922, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังตำแหน่งทาวน์เฮ้าส์บนแปลง', 'ผังต้นทางแสดงตำแหน่งทาวน์เฮ้าส์ 2 ชั้นจำนวน 1 คูหาภายในแปลงรูปหลายเหลี่ยม', 'https://npa.sam.or.th/site/images/npa/22240/20241127144704_TL0422C1_67.jpg', '/listing-media/sam/tl0422/05.webp', 'image/webp', 16064, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปกาญจน์กนกทาวน์ 1', 'แผนที่ต้นทาง SAM แสดงเส้นทางจากถนนเลียบทางรถไฟเชียงใหม่-ลำพูนเข้าพื้นที่ทรัพย์ โดยชื่อไฟล์มีรหัส 4T0973', 'https://npa.sam.or.th/site/images/npa/22240/20241127144704_TL0422M_67(4T0973).jpg', '/listing-media/sam/tl0422/06.webp', 'image/webp', 60296, 785, 600, 60, false, true);

    INSERT INTO public.listing_sources (
        listing_id, source_type, publisher_name, source_url,
        reference_code, captured_at, notes
    ) VALUES (
        property_listing_id,
        'editorial_import',
        'บริษัท บริหารสินทรัพย์สุขุมวิท จำกัด (SAM)',
        'https://www.sam.or.th/site/npa/detail.php?id=22240&keyref=6004858',
        'TL0422',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA page id 22240. The page showed direct-purchase status and an announced sale price of THB 3,262,000 for a two-storey end-unit townhouse numbered 58/32 in Karnkanok Town 1, Nong Phueng, Saraphi, Chiang Mai. Title deed no. 635 covers 1 ngan 19.6 sq.wah, or 119.6 sq.wah / 478.4 sq.m. The registered transferred structures are described as a two-storey townhouse numbered 58/32 and a garage. The polygonal plot has an approximately 21.5-metre south side, an approximately eight-metre road-fronting section and a maximum depth of approximately 27.75 metres. Karnkanok Town 1 Soi 4 is described as a concrete road in an authorized allocated development, approximately six metres wide within an approximately eight-metre right of way. The source identifies yellow planning zoning and residential surroundings. Bedroom count, bathroom count, usable area, parking count, building age, occupancy, flood history, common fees, internal utility condition and other encumbrances are not published, and there are no interior images. The exterior property photo displays 18 October 2024 and shows household items, which is not treated as current occupancy evidence. Administrator coordinates are approximately 2.22 metres from the rounded source coordinates and are used for the listing. The navigation-map filename also contains alternate asset code 4T0973; an access image and the map reference Ban Chiang Saen while the page identifies Karnkanok Town 1. MapxProp retains TL0422 as the current reference and records the media discrepancy for SAM confirmation. MapxProp stores optimized copies of all six unique source property, access, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Two-Storey End Townhouse in Karnkanok Town 1, THB 3.262M',
        E'A two-storey end-unit townhouse numbered 58/32 in Karnkanok Town 1, Nong Phueng, Saraphi, Chiang Mai. Title deed no. 635, one document, covers 1 ngan 19.6 sq.wah, equivalent to 119.6 sq.wah or 478.4 sq.m. SAM identifies the registered transferred structures as a two-storey townhouse numbered 58/32 and a garage.\n\nThe polygonal plot has an approximately 21.5-metre south side, of which approximately eight metres fronts the road, and a maximum depth of approximately 27.75 metres. The source plot plan also shows other sides of approximately 17.5, 24 and 13.5 metres. Buyers should verify the title, survey, boundaries, measurements, directions, access, building registration, approved plans, permits and that both the townhouse and garage are included in the transfer.\n\nKarnkanok Town 1 Soi 4 is described as a concrete road in an authorized allocated development, approximately six metres wide within an approximately eight-metre right of way. SAM identifies yellow planning zoning and residential surroundings.\n\nSAM directions use the Chiang Mai-Lamphun railway frontage road from Lamphun toward central Chiang Mai. Pass the Chiang Mai Ring Road, Highway 121, intersection and turn left toward Karnkanok Town 1 for approximately seventy metres. Then turn left into the development and Soi 4 for a combined approximately 300 metres; the property is on the right. Nearby places listed by SAM include Wat Chiang Saen, Wat San Khue and Wat Phang Yoi.\n\nThe SAM page listed the property for direct purchase at an announced THB 3,262,000 when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, offer procedures, current price, promotions, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: TL0422. MapxProp does not collect deposits or represent SAM.\n\nThe exterior property photo displays 18 October 2024 and shows household items at the property on that date, but this does not establish current occupancy. SAM publishes no interior images and does not state bedroom count, bathroom count, usable area, parking count, building age, occupancy, flood history, common fees, internal electrical and plumbing condition or other encumbrances. Buyers should inspect the interior, structure, roof, cracks, moisture, termites, electrical and plumbing systems, drainage, boundaries, development rules, common fees, taxes, costs and every current term before deciding.\n\nSource-media note: the navigation-map filename also contains 4T0973, and an access image and the map reference Ban Chiang Saen while the property page identifies Karnkanok Town 1. Quote TL0422 and page id 22240 when contacting SAM and ask SAM to confirm these media references.',
        '58/32, Karnkanok Town 1, Soi 4',
        'Access from the Chiang Mai-Lamphun railway frontage road via the Highway 121 intersection',
        'Chiang Mai-Lamphun Railway Frontage Road',
        'Nong Phueng',
        'Saraphi',
        'Chiang Mai',
        'SAM End Townhouse in Karnkanok Town 1, THB 3.262M',
        'Official SAM asset TL0422: two-storey end townhouse with a garage on 119.6 sq.wah in Karnkanok Town 1, Saraphi. Direct-sale price THB 3.262M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset TL0422 townhouse two storey end unit 58/32 Karnkanok Town 1 Soi 4 Nong Phueng Saraphi Chiang Mai railway frontage road 119.6 sq.wah 478.4 sq.m. garage title deed 635 THB 3262000')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=22240&keyref=6004858'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=22240&keyref=6004858',
            'The official SAM NPA page identifies SAM as the asset holder and direct-sale contact for TL0422. Specifications, title deed, registered townhouse and garage, images, rounded coordinates, announced price, direct-purchase status, road measurements, planning-zone wording and source-media discrepancies come from that page.',
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
        '7431be56-8a85-4471-9b0b-9d3e867f2d46',
        jsonb_build_object(
            'reference_code', 'TL0422',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'residence',
            'discovery_channels', jsonb_build_array('homes'),
            'title_document_count', 1,
            'registered_floor_count', 2,
            'registered_garage_reported', true,
            'bedroom_count_published', false,
            'bathroom_count_published', false,
            'source_interior_images_published', false,
            'source_reference_discrepancy', true,
            'alternate_reference_code_in_map_filename', '4T0973',
            'source_image_count', 6
        )
    );
END $$;

COMMIT;
