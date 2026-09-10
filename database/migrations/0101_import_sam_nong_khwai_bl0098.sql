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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing BL0098';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing BL0098';
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
        '41c036c7-e7d9-4670-93c8-728653ba7d89',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'office',
        'business',
        'sale',
        'whole_property',
        'ขายตรง SAM อาคารสำนักงาน 2 ชั้นพร้อมชั้นลอย ริมถนนหางดง-สะเมิง เชียงใหม่ ราคา 11.993 ล้านบาท',
        E'อาคารสำนักงานพร้อมที่ดิน ตำบลหนองควาย อำเภอหางดง จังหวัดเชียงใหม่ เอกสารสิทธิ์เป็นโฉนดที่ดินเลขที่ 52563 จำนวน 1 ฉบับ เนื้อที่ 1 งาน 83 ตร.ว. หรือ 183 ตร.ว. (732 ตร.ม.) ราคาประกาศขาย 11,993,000 บาท

SAM ระบุว่ารายการสิ่งปลูกสร้างที่รับโอนกรรมสิทธิ์ประกอบด้วยอาคารสำนักงานตึก 2 ชั้นครึ่ง ไม่มีเลขที่ โรงจอดรถขนาด 4.5 x 16.6 เมตร และโรงจอดรถขนาด 27 x 4 เมตร ส่วนข้อมูลสำรวจสภาพทรัพย์อธิบายอาคารสำนักงานเป็น 2 ชั้นพร้อมชั้นลอย ไม่ติดเลขที่ SAM จะโอนกรรมสิทธิ์ตามรายการสิ่งปลูกสร้างที่จดทะเบียนรับโอนทางทะเบียนเท่านั้น ผู้ซื้อต้องให้ SAM และสำนักงานที่ดินยืนยันจำนวนชั้น ชั้นลอย โรงจอดรถ แบบอาคาร ใบอนุญาต และสิ่งปลูกสร้างที่รวมในการโอน

ที่ดินเป็นรูปสี่เหลี่ยมด้านไม่เท่าและ SAM ระบุว่าติดถนน 2 ด้าน ด้านทิศตะวันตกกว้างประมาณ 21.5 เมตร ด้านทิศเหนือยาวลึกสุดประมาณ 40 เมตร และด้านทิศใต้ติดลำเหมืองสาธารณประโยชน์กว้างประมาณ 34 เมตร ตามผังโฉนดลำเหมืองคั่นระหว่างทรัพย์กับถนนสายหางดง-สะเมิง (ทล.1269) ผู้ซื้อควรตรวจโฉนด รังวัด แนวเขต ลำเหมือง และสภาพทางเข้าออกจริงก่อนเสนอซื้อ

ประเด็นสำคัญเรื่องทางเข้าออก: SAM ระบุว่าเคยยื่นขออนุญาตทำทางเชื่อมกับทางหลวงตามหนังสือแขวงการทางเชียงใหม่ที่ 2 เลขที่ คค.0615.2/บ.4/1708 ลงวันที่ 18 กันยายน 2549 แต่จากการสอบถามฝ่ายสารสนเทศของแขวงการทาง คำขอยังไม่ได้เข้าสู่การตรวจสอบการก่อสร้างเพื่อออกหนังสือเชื่อมทางเข้าออกกับทางหลวงเป็นการถาวร ผู้สนใจต้องตรวจสถานะและยื่นเอกสารกับหมวดทางหลวงสารภีก่อนใช้หรือพัฒนาทรัพย์

ถนนสายหางดง-สะเมิง (ทล.1269) หน้า SAM ระบุว่าเป็นทางสาธารณประโยชน์ ผิวลาดยางกว้างประมาณ 6 เมตร เขตทางกว้างประมาณ 8 เมตร การเดินทางจากอำเภอสะเมิงมุ่งหน้าแยกสะเมิง ผ่านวัดวุฑฒิราษฎร์ (วัดบ้านฟ่อน) และโรงเรียนบ้านฟ่อน จะพบทรัพย์อยู่ด้านซ้ายมือ สถานที่ใกล้เคียงที่ SAM ระบุ ได้แก่ วัดอินทราวาส (วัดต้นเกว๋น) และโรงเรียนนานาชาติปัญญาเด่น

หน้า SAM ระบุเขตสีเขียว และระบุว่าทรัพย์อยู่ในย่านที่อยู่อาศัยและอุตสาหกรรมพร้อมสาธารณูปโภค อย่างไรก็ตาม ทรัพย์ต้นทางเป็นอาคารสำนักงาน ไม่ได้ระบุว่าเป็นบ้านหรือ Mixed Use MapxProp จึงจัดไว้ในหมวดธุรกิจเท่านั้น ผู้ซื้อต้องตรวจผังเมืองปัจจุบัน การใช้อาคาร กฎหมายโรงงานหรือธุรกิจ ทางเข้าออก ที่จอดรถ ระบบดับเพลิง สาธารณูปโภค และใบอนุญาตสำหรับกิจการที่ต้องการ

หน้า SAM แสดงสถานะ “ซื้อตรง” ไม่ใช่การประมูลในสถานะที่ตรวจสอบเมื่อวันที่ 10 กันยายน 2569 ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะการครอบครอง และวิธีจำหน่ายล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ BL0098 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM

ภาพสภาพทรัพย์บนหน้าต้นทางแสดงวันที่ 13 ตุลาคม 2568 สภาพจริงอาจเปลี่ยนแปลง ผู้ซื้อควรนัดตรวจโครงสร้าง หลังคา รอยร้าว ความชื้น ปลวก ระบบไฟฟ้า ประปา ห้องน้ำ ชั้นลอย โรงจอดรถ รั้ว ลำเหมือง ทางเข้าออกถาวร การระบายน้ำ น้ำท่วม ภาระผูกพัน ภาษี ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        11993000,
        false,
        732,
        2,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'อาคารสำนักงาน ถนนสายหางดง-สะเมิง (ทล.1269)',
        'ใกล้แยกสะเมิง ตำบลหนองควาย',
        'ถนนสายหางดง-สะเมิง (ทล.1269)',
        NULL,
        18.72666232,
        98.91588907,
        'เชียงใหม่',
        'หางดง',
        'หนองควาย',
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
        'sam-direct-sale-office-building-highway-1269-hang-dong-bl0098'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'office')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 11993000, 'total', 'THB', false
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
        'office',
        1,
        jsonb_build_object(
            'source_property_category', 'อาคารสำนักงาน',
            'title_document_type', 'chanote',
            'title_deed_numbers', jsonb_build_array('52563'),
            'title_document_count', 1,
            'land_area_rai', 0,
            'land_area_ngan', 1,
            'land_area_square_wah_remainder', 83,
            'land_area_square_wah', 183,
            'land_area_sqm', 732,
            'plot_count', 1,
            'plot_shape', 'irregular_quadrilateral',
            'road_frontage_side_count_reported', 2,
            'west_boundary_width_m_approx', 21.5,
            'north_maximum_depth_m_approx', 40,
            'south_public_irrigation_canal_boundary_m_approx', 34,
            'public_irrigation_canal_separates_property_from_highway', true,
            'registered_structure_count', 3,
            'registered_office_storeys', 2.5,
            'surveyed_office_storeys', 2,
            'mezzanine_reported_by_survey', true,
            'building_number_status', 'unnumbered',
            'carports', jsonb_build_array(
                jsonb_build_object('width_m', 4.5, 'length_m', 16.6),
                jsonb_build_object('width_m', 27, 'length_m', 4)
            ),
            'structure_transfer_basis', 'sam_registered_acquisition_record_only',
            'office_usable_area_not_published', true,
            'bathroom_count_not_published', true,
            'parking_space_count_not_published', true
        ) || jsonb_build_object(
            'front_road_name', 'ถนนสายหางดง-สะเมิง (ทล.1269)',
            'front_road_legal_status_th', 'ทางสาธารณประโยชน์',
            'front_road_surface', 'asphalt',
            'front_road_width_m_approx', 6,
            'front_right_of_way_width_m_approx', 8,
            'highway_access_application_reference', 'คค.0615.2/บ.4/1708 ลงวันที่ 18 กันยายน 2549',
            'permanent_highway_access_approval_not_issued', true,
            'access_follow_up_office_th', 'หมวดทางหลวงสารภี',
            'zoning_color_th', 'เขตสีเขียว ตามหน้า SAM',
            'surrounding_area_use_th', 'ย่านที่อยู่อาศัยและอุตสาหกรรม',
            'utilities_reported_available', true,
            'mixed_use_classification', false,
            'mixed_use_exclusion_basis', 'SAM ระบุประเภททรัพย์เป็นอาคารสำนักงานและไม่ได้ระบุว่าสามารถใช้เป็นที่อยู่อาศัยได้',
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_information_date_not_published', true,
            'source_property_photo_dates_displayed', jsonb_build_array('2025-10-13'),
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '18.726662,98.915888',
            'administrator_coordinate_distance_from_source_m_approx', 0.12
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for BL0098. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนสายหางดง-สะเมิง (ทล.1269)', 'Hang Dong-Samoeng Highway 1269', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'วัดอินทราวาส (วัดต้นเกว๋น)', 'Wat Intharawat (Wat Ton Kwen)', 'landmark', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'โรงเรียนนานาชาติปัญญาเด่น', 'Panyaden International School', 'education', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'วัดวุฑฒิราษฎร์ (วัดบ้านฟ่อน)', 'Wat Wutthi Rat (Wat Ban Fon)', 'landmark', NULL, NULL, NULL, 40, false),
        (property_listing_id, 'โรงเรียนบ้านฟ่อน', 'Ban Fon School', 'education', NULL, NULL, NULL, 50, false)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '11,993,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 11,993,000 — confirm the latest price with SAM', 'unspecified', 11993000, 'THB', 20),
        (property_listing_id, 'registered_structures', 'สิ่งปลูกสร้างตามทะเบียน', 'Registered structures', 'อาคารสำนักงานตึก 2 ชั้นครึ่ง ไม่มีเลขที่ และโรงจอดรถ 2 หลัง ขนาด 4.5 x 16.6 เมตร กับ 27 x 4 เมตร', 'An unnumbered two-and-a-half-storey office building and two carports measuring 4.5 x 16.6 metres and 27 x 4 metres', 'unspecified', 3, 'structures', 30),
        (property_listing_id, 'structure_transfer_scope', 'ขอบเขตสิ่งปลูกสร้างที่จะโอน', 'Structure transfer scope', 'SAM จะโอนตามรายการสิ่งปลูกสร้างที่จดทะเบียนรับโอนทางทะเบียนเท่านั้น ข้อมูลสำรวจอธิบายอาคารเป็น 2 ชั้นพร้อมชั้นลอย', 'SAM will transfer only the structures in its registered acquisition record; the physical survey describes two storeys plus a mezzanine', 'buyer', NULL, '', 40),
        (property_listing_id, 'highway_access', 'สถานะทางเชื่อมทางหลวง', 'Highway access status', 'คำขอทำทางเชื่อมตามหนังสือ คค.0615.2/บ.4/1708 ลงวันที่ 18 กันยายน 2549 ยังไม่ได้รับหนังสือเชื่อมทางเข้าออกถาวร ต้องตรวจและยื่นเรื่องกับหมวดทางหลวงสารภี', 'The access application dated 18 September 2006 has not resulted in permanent highway-access approval; verify and apply with the Saraphi Highway Office', 'buyer', NULL, '', 50),
        (property_listing_id, 'business_use_review', 'ตรวจสอบการใช้เพื่อธุรกิจ', 'Business-use review', 'ทรัพย์เป็นอาคารสำนักงานในเขตสีเขียวตามหน้า SAM ต้องตรวจผังเมือง การใช้อาคาร ระบบดับเพลิง ที่จอดรถ ทางเข้าออก และใบอนุญาตสำหรับกิจการที่ต้องการ', 'The office is shown in a green planning zone; verify planning, building use, fire safety, parking, access and licences for the intended business', 'buyer', NULL, '', 60),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนด รังวัด อาคาร ชั้นลอย โรงจอดรถ แนวเขต ลำเหมือง ทางเข้าออกถาวร ใบอนุญาต โครงสร้าง ระบบไฟฟ้า ประปา ภาระผูกพัน ค่าใช้จ่าย สถานะการครอบครอง และเงื่อนไขล่าสุด', 'Verify title, survey, building, mezzanine, carports, boundaries, canal, permanent access, permits, structure, utilities, encumbrances, costs, possession and current terms', 'buyer', NULL, '', 70)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'อาคารสำนักงานริมถนนหางดง-สะเมิง', 'ด้านหน้าอาคารสำนักงาน SAM รหัส BL0098 ริมถนนสายหางดง-สะเมิง', 'https://npa.sam.or.th/site/images/npa/22643/20260625161538_BL0098P1_69.jpg', '/listing-media/sam/bl0098/01.webp', 'image/webp', 26874, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ด้านหน้าอาคารสำนักงาน', 'ภาพด้านหน้าอาคารสำนักงาน 2 ชั้นพร้อมชั้นลอยและแนวรั้ว', 'https://npa.sam.or.th/site/images/npa/22643/BL0098P2_69.jpg', '/listing-media/sam/bl0098/02.webp', 'image/webp', 60348, 720, 540, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมอาคารและแนวถนน', 'ภาพมุมอาคารสำนักงานและแนวถนนบริเวณหน้าทรัพย์', 'https://npa.sam.or.th/site/images/npa/22643/BL0098P3_69.jpg', '/listing-media/sam/bl0098/03.webp', 'image/webp', 61168, 720, 540, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'อาคารสำนักงานจากฝั่งตรงข้าม', 'ภาพอาคารสำนักงานจากฝั่งตรงข้ามถนนสายหางดง-สะเมิง', 'https://npa.sam.or.th/site/images/npa/22643/BL0098P4_69.jpg', '/listing-media/sam/bl0098/04.webp', 'image/webp', 77138, 720, 540, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ด้านข้างอาคารและทางเข้า', 'ภาพด้านข้างอาคารสำนักงาน แนวรั้ว และบริเวณทางเข้าทรัพย์', 'https://npa.sam.or.th/site/images/npa/22643/BL0098P5_69.jpg', '/listing-media/sam/bl0098/05.webp', 'image/webp', 91142, 720, 540, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวด้านข้างและโรงจอดรถ', 'ภาพแนวด้านข้างอาคารพร้อมหลังคาโรงจอดรถและประตูทางเข้า', 'https://npa.sam.or.th/site/images/npa/22643/BL0098P6_69.jpg', '/listing-media/sam/bl0098/06.webp', 'image/webp', 57728, 720, 540, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ใต้หลังคาโรงจอดรถ', 'ภาพพื้นที่ภายในโรงจอดรถข้างอาคารสำนักงาน', 'https://npa.sam.or.th/site/images/npa/22643/BL0098P7_69.jpg', '/listing-media/sam/bl0098/07.webp', 'image/webp', 66074, 720, 540, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเดินข้างอาคาร', 'ภาพทางเดินด้านข้างอาคารสำนักงานและแนวหน้าต่าง', 'https://npa.sam.or.th/site/images/npa/22643/BL0098P10_69.jpg', '/listing-media/sam/bl0098/08.webp', 'image/webp', 35808, 720, 540, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเดินและประตูภายใน', 'ภาพทางเดินบริการและประตูห้องภายในอาคารสำนักงาน', 'https://npa.sam.or.th/site/images/npa/22643/BL0098P11_69.jpg', '/listing-media/sam/bl0098/09.webp', 'image/webp', 38246, 720, 540, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงภายในอาคาร', 'ภาพโถงภายในอาคารสำนักงานพร้อมช่องติดต่อและประตูห้อง', 'https://npa.sam.or.th/site/images/npa/22643/BL0098P14_69.jpg', '/listing-media/sam/bl0098/10.webp', 'image/webp', 23290, 720, 540, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่โถงชั้นล่าง', 'ภาพพื้นที่โถงขนาดใหญ่ภายในอาคารสำนักงานชั้นล่าง', 'https://npa.sam.or.th/site/images/npa/22643/BL0098P15_69.jpg', '/listing-media/sam/bl0098/11.webp', 'image/webp', 27760, 720, 540, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่สำนักงานแบบเปิด', 'ภาพพื้นที่สำนักงานภายในแบบเปิดและแนวเสาอาคาร', 'https://npa.sam.or.th/site/images/npa/22643/BL0098P16_69.jpg', '/listing-media/sam/bl0098/12.webp', 'image/webp', 30166, 720, 540, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องภายในปูพื้นกระเบื้อง', 'ภาพห้องภายในอาคารสำนักงานพร้อมพื้นกระเบื้องและหน้าต่าง', 'https://npa.sam.or.th/site/images/npa/22643/BL0098P18_69.jpg', '/listing-media/sam/bl0098/13.webp', 'image/webp', 21506, 720, 540, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงพร้อมแนวชั้นลอย', 'ภาพโถงภายในอาคารที่เห็นโครงสร้างและแนวชั้นลอย', 'https://npa.sam.or.th/site/images/npa/22643/BL0098P22_69.jpg', '/listing-media/sam/bl0098/14.webp', 'image/webp', 25836, 720, 540, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องสำนักงานหน้าต่างโค้ง', 'ภาพห้องสำนักงานภายในพร้อมหน้าต่างทรงโค้ง', 'https://npa.sam.or.th/site/images/npa/22643/BL0098P29_69.jpg', '/listing-media/sam/bl0098/15.webp', 'image/webp', 21594, 720, 540, 150, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องสำนักงานขนาดใหญ่', 'ภาพห้องสำนักงานภายในพร้อมแนวเสาและผนังกั้น', 'https://npa.sam.or.th/site/images/npa/22643/BL0098P35_69.jpg', '/listing-media/sam/bl0098/16.webp', 'image/webp', 16534, 720, 540, 160, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องทำงานภายใน', 'ภาพห้องทำงานภายในอาคารสำนักงานพร้อมหน้าต่างรับแสง', 'https://npa.sam.or.th/site/images/npa/22643/BL0098P38_69.jpg', '/listing-media/sam/bl0098/17.webp', 'image/webp', 22504, 720, 540, 170, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำภายในอาคาร', 'ภาพห้องน้ำภายในอาคารสำนักงานพร้อมสุขภัณฑ์', 'https://npa.sam.or.th/site/images/npa/22643/BL0098P39_69.jpg', '/listing-media/sam/bl0098/18.webp', 'image/webp', 24486, 720, 540, 180, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำพร้อมโถปัสสาวะ', 'ภาพห้องน้ำภายในอาคารสำนักงานพร้อมโถสุขภัณฑ์และโถปัสสาวะ', 'https://npa.sam.or.th/site/images/npa/22643/BL0098P34_69.jpg', '/listing-media/sam/bl0098/19.webp', 'image/webp', 26354, 720, 540, 190, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังแปลงที่ดินและแนวลำเหมือง', 'ผังต้นทางแสดงแปลงโฉนด 52563 แนวถนนสองด้าน ลำเหมือง และถนนหางดง-สะเมิง', 'https://npa.sam.or.th/site/images/npa/22643/20250820150751_BL0098C1_68.jpg', '/listing-media/sam/bl0098/20.webp', 'image/webp', 13364, 450, 450, 200, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังตำแหน่งอาคารบนแปลง', 'ผังต้นทางแสดงตำแหน่งอาคารสำนักงาน 2 ชั้นพร้อมชั้นลอยภายในแปลงที่ดิน', 'https://npa.sam.or.th/site/images/npa/22643/20250820150751_BL0098C2_68.jpg', '/listing-media/sam/bl0098/21.webp', 'image/webp', 15690, 450, 450, 210, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปทรัพย์', 'แผนที่ต้นทางแสดงเส้นทางถนนหางดง-สะเมิงไปยังอาคารสำนักงาน SAM BL0098', 'https://npa.sam.or.th/site/images/npa/22643/20250820150751_BL0098M_68 (HL0611).jpg', '/listing-media/sam/bl0098/22.webp', 'image/webp', 50348, 785, 600, 220, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=22643&keyref=6004388',
        'BL0098',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 11,993,000 for an office property on title deed 52563 in Nong Khwai, Hang Dong, Chiang Mai. Announced land area is 1 ngan 83 sq.wah / 183 sq.wah / 732 sq.m. SAM registered an unnumbered two-and-a-half-storey office building and two carports measuring 4.5 by 16.6 metres and 27 by 4 metres; its physical survey describes the office as two storeys plus a mezzanine. SAM says transfer follows only its registered acquisition record. The irregular quadrilateral plot is reported to front two roads, with approximately 21.5 metres on the west, maximum depth approximately 40 metres on the north and approximately 34 metres along a public irrigation canal on the south. The canal separates the property from Highway 1269. SAM says an access application dated 18 September 2006 has not resulted in permanent highway-access approval, requiring verification and an application with the Saraphi Highway Office. The highway is described as a public asphalt road approximately six metres wide within an approximately eight-metre right of way. SAM shows green planning zoning and residential-industrial surroundings. Because the asset is an office and no residential use is stated, MapxProp classifies it only under business, not mixed use. Buyers must independently verify title, survey, structures, mezzanine, permits, canal, permanent access, planning controls and current transaction terms. Source property photos display 13 October 2025. Administrator coordinates are approximately 0.12 metres from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all twenty-two unique source property, interior, plot-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Office Building on Highway 1269, Hang Dong, THB 11.993M',
        E'Office property in Nong Khwai, Hang Dong, Chiang Mai, on title deed 52563. The announced land area is 1 ngan 83 sq.wah, or 183 sq.wah (732 sq.m.), with an announced sale price of THB 11,993,000.

SAM''s registered acquisition record lists an unnumbered two-and-a-half-storey masonry office building, a 4.5 by 16.6 metre carport and a 27 by 4 metre carport. The physical survey instead describes the office as two storeys plus a mezzanine. SAM says the transfer will follow only the structures in its registered acquisition record. Buyers must ask SAM and the Land Office to verify the storey count, mezzanine, carports, plans, permits and every structure included in the transfer.

SAM describes an irregular quadrilateral plot fronting two roads. The western side is approximately 21.5 metres wide, the northern side has a maximum depth of approximately 40 metres and the southern side borders a public irrigation canal for approximately 34 metres. The title plan shows the canal separating the property from Hang Dong-Samoeng Highway 1269. Buyers should verify the title, survey, boundaries, canal and practical access before offering.

Important access issue: SAM says an application for a highway connection was made under Chiang Mai Highway District 2 letter Kor Khor 0615.2/Bor 4/1708 dated 18 September 2006. The Highway District information section later advised that the construction had not been presented for inspection and no permanent highway access approval had been issued. Anyone interested must verify the current status and apply through the Saraphi Highway Office before relying on the access or developing the property.

SAM describes Highway 1269 as a public asphalt road approximately six metres wide within an approximately eight-metre right of way. From Samoeng, travel toward Samoeng Junction, pass Wat Wutthi Rat (Wat Ban Fon) and Ban Fon School; the property is on the left. Nearby places named by SAM include Wat Intharawat (Wat Ton Kwen) and Panyaden International School.

The source shows green planning zoning and describes the surroundings as residential and industrial with utilities. The asset itself is listed as an office building, with no residential use stated. MapxProp therefore classifies it only under business, not mixed use. Buyers must confirm current planning, approved building use, industrial or business rules, fire safety, parking, utilities and licences for the intended operation.

The SAM page listed the property for direct purchase, not auction, when checked on 10 September 2026. Contact SAM directly to confirm availability, the current sale method, offer procedures, price, promotions, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: BL0098. MapxProp does not collect deposits or represent SAM in the transaction.

Source property photos display 13 October 2025, and conditions may have changed. Buyers should inspect the structure, roof, cracks, moisture, termites, electrical and plumbing systems, bathrooms, mezzanine, carports, fence, canal, permanent access, drainage, flooding, encumbrances, taxes, costs and every current term before deciding.',
        'Office building on Hang Dong-Samoeng Highway 1269',
        'Near Samoeng Junction, Nong Khwai',
        'Hang Dong-Samoeng Highway 1269',
        'Nong Khwai',
        'Hang Dong',
        'Chiang Mai',
        'SAM Office Building, Highway 1269, Hang Dong, THB 11.993M',
        'Official SAM NPA asset BL0098: an office building with mezzanine and two carports on 732 sq.m. Direct sale at THB 11.993M; permanent highway access requires verification.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset BL0098 office building mezzanine two carports Nong Khwai Hang Dong Chiang Mai Hang Dong Samoeng Highway 1269 title deed 52563 1 ngan 83 sq.wah 183 sq.wah 732 sq.m. THB 11993000 permanent highway access verification')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=22643&keyref=6004388'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=22643&keyref=6004388',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for BL0098. Specifications, title deed, registered and surveyed structures, images, rounded coordinates, announced price, direct-purchase status, canal boundary, highway-access issue, road measurements and planning-zone wording come from that record.',
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
        '41c036c7-e7d9-4670-93c8-728653ba7d89',
        jsonb_build_object(
            'reference_code', 'BL0098',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'business',
            'discovery_channels', jsonb_build_array('business'),
            'title_document_count', 1,
            'registered_structure_count', 3,
            'mezzanine_review_required', true,
            'permanent_highway_access_approval_not_issued', true,
            'source_image_count', 22
        )
    );
END $$;

COMMIT;
