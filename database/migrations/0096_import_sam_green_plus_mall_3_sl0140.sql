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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing SL0140';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing SL0140';
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
        '024f0057-e156-4173-b3c3-8c5e205b4873',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'shophouse',
        'mixed',
        'sale',
        'whole_property',
        'กรีนพลัสมอลล์ 3',
        '161/76',
        'ขายตรง SAM อาคารพาณิชย์หลังมุม 3 ชั้นครึ่ง 2 คูหา กรีนพลัสมอลล์ 3 เชียงใหม่ ราคา 17.181 ล้านบาท',
        E'อาคารพาณิชย์หลังมุม 3 ชั้นครึ่ง จำนวน 2 คูหา เลขที่ 161/76 ในโครงการกรีนพลัสมอลล์ 3 ตำบลหนองป่าครั่ง อำเภอเมืองเชียงใหม่ จังหวัดเชียงใหม่ บนที่ดินโฉนดเลขที่ 125863 จำนวน 1 ฉบับ เนื้อที่ 32 ตร.ว. (128 ตร.ม.) เหมาะสำหรับพิจารณาเป็นที่อยู่อาศัย หน้าร้าน สำนักงาน หรือใช้งานแบบผสม โดยต้องตรวจข้อกำหนดอาคารและกิจการที่ต้องการก่อนซื้อ

ที่ดินเป็นรูปสี่เหลี่ยมผืนผ้าและติดถนน 2 ด้าน ด้านทิศใต้กว้างประมาณ 8 เมตร ด้านทิศตะวันตกกว้างประมาณ 16 เมตร และลึกประมาณ 16 เมตร ถนนหน้าทรัพย์คือซอยกรีนพลัสมอลล์ 3 เป็นถนนภายในโครงการจัดสรรที่ได้รับอนุญาตแล้ว ผิวจราจรคอนกรีตกว้างประมาณ 6 เมตร เขตทางกว้างประมาณ 12 เมตร ผู้ซื้อควรตรวจแนวเขต ทางเข้าออก พื้นที่จอดรถและการขนถ่ายสินค้าจริงให้เหมาะกับการใช้งาน

รายการรับโอนกรรมสิทธิ์ของ SAM ระบุสิ่งปลูกสร้างเป็นตึกแถว 3 ชั้นครึ่ง จำนวน 2 คูหา เลขที่ 161/76 หลังมุม หน้า SAM ไม่ได้เผยแพร่พื้นที่ใช้สอย จำนวนห้องนอน ห้องน้ำ ที่จอดรถ อายุอาคาร สถานะผู้ใช้ประโยชน์ หรือวันที่ของข้อมูลรายละเอียด ผู้ซื้อจึงควรให้ SAM สำนักงานที่ดิน และเทศบาลยืนยันทะเบียนอาคาร แบบแปลน ใบอนุญาต พื้นที่ใช้สอย การเชื่อมต่อของ 2 คูหา ทางหนีไฟ และรายการสิ่งปลูกสร้างที่จะโอน

หน้า SAM ระบุเขตพื้นที่สีส้ม อยู่ในย่านที่อยู่อาศัยและพาณิชยกรรม และมีสาธารณูปโภคครบครัน การจัดเป็น Mixed Use ใน MapxProp จึงหมายถึงค้นพบได้ทั้งหมวดที่อยู่อาศัยและหมวดธุรกิจ แต่ไม่ใช่การรับรองว่าสามารถประกอบธุรกิจทุกประเภทได้ ผู้ซื้อต้องตรวจผังเมือง ข้อบังคับโครงการ นิติบุคคลอาคารหรือโครงการ ใบอนุญาต กฎหมายควบคุมอาคาร ป้าย ที่จอดรถ และข้อกำหนดเฉพาะของกิจการ

การเดินทางตาม SAM ใช้ถนนซุปเปอร์ไฮเวย์สายเชียงใหม่-ลำปาง (ทล.11) จากดอยสุเทพมุ่งหน้าอำเภอสารภี ผ่านเซ็นทรัล เชียงใหม่ แยกศาลเด็ก ศาลแขวงจังหวัดเชียงใหม่ และบิ๊กซี เอ็กซ์ตร้า เชียงใหม่ เลี้ยวซ้ายเข้าซอยโครงการเชียงใหม่บิสสิเนสพาร์ค เลี้ยวขวาเข้าซอย 5 แล้วเลี้ยวซ้ายเข้ากรีนพลัสมอลล์ 3 รวมประมาณ 670 เมตร ทรัพย์อยู่ด้านซ้ายมือ ติดถนน 2 ด้านและเป็นหลังมุม สถานที่ใกล้เคียงที่ SAM ระบุ ได้แก่ โรงเรียนวชิรวิทย์ เชียงใหม่ ศาลอุทธรณ์ภาค 5 และสถานีขนส่งผู้โดยสารจังหวัดเชียงใหม่ แห่งที่ 3

หน้า SAM ระบุสถานะ “ซื้อตรง” และราคาประกาศขาย 17,181,000 บาท ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน โปรโมชั่น ค่าใช้จ่าย สถานะการครอบครอง และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ SL0140 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM

ภาพสภาพทรัพย์ในหน้าต้นทางแสดงวันที่ 22 พฤศจิกายน 2567 สภาพจริงอาจเปลี่ยนแปลง ผู้ซื้อควรนัดตรวจอาคารทั้ง 2 คูหา ตรวจโครงสร้าง หลังคา ระบบไฟฟ้าและสาธารณูปโภค ทางหนีไฟ ระบบป้องกันอัคคีภัย การครอบครอง ภาระผูกพัน ค่าใช้จ่ายส่วนกลาง ภาษี การใช้ประโยชน์ และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        17181000,
        false,
        128,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        '161/76 โครงการกรีนพลัสมอลล์ 3',
        'ใกล้เชียงใหม่บิสสิเนสพาร์คและถนนซุปเปอร์ไฮเวย์สายเชียงใหม่-ลำปาง (ทล.11)',
        'ซอยกรีนพลัสมอลล์ 3',
        NULL,
        18.79962970,
        99.02477870,
        'เชียงใหม่',
        'เมืองเชียงใหม่',
        'หนองป่าครั่ง',
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
        'sam-direct-sale-corner-shophouse-green-plus-mall-3-chiang-mai-sl0140'
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
        property_listing_id, 'sale', 17181000, 'total', 'THB', false
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
            'project_name', 'กรีนพลัสมอลล์ 3',
            'listed_unit_number', '161/76',
            'title_document_type', 'chanote',
            'title_deed_number', '125863',
            'title_document_count', 1,
            'land_area_square_wah', 32,
            'land_area_sqm', 128,
            'registered_transfer_description', 'ตึกแถว 3 ชั้นครึ่ง จำนวน 2 คูหา เลขที่ 161/76 (หลังมุม)',
            'registered_floor_count_text', '3 ชั้นครึ่ง',
            'registered_floor_count_numeric', 3.5,
            'unit_count', 2,
            'corner_unit', true,
            'plot_shape', 'rectangle',
            'road_frontage_side_count', 2,
            'south_side_width_m', 8,
            'west_side_width_m', 16,
            'maximum_depth_m', 16,
            'front_road_name', 'ซอยกรีนพลัสมอลล์ 3',
            'front_road_legal_status_th', 'ทางในโครงการจัดสรรที่ได้รับอนุญาตแล้ว',
            'front_road_surface', 'concrete',
            'front_road_width_m', 6,
            'front_right_of_way_width_m', 12,
            'zoning_color_th', 'สีส้ม ตามหน้า SAM',
            'surrounding_area_use_th', 'ย่านที่อยู่อาศัยและพาณิชยกรรม'
        ) || jsonb_build_object(
            'source_states_utilities_available', true,
            'mixed_use_classification', true,
            'mixed_use_basis', 'SAM ระบุเป็นอาคารพาณิชย์ในย่านที่อยู่อาศัยและพาณิชยกรรม ผู้ดูแลระบบจึงกำหนดให้ค้นพบได้ทั้งหมวดที่อยู่อาศัยและธุรกิจ',
            'business_use_requires_independent_verification', true,
            'usable_area_not_published', true,
            'bedroom_count_not_published', true,
            'bathroom_count_not_published', true,
            'parking_information_not_published', true,
            'occupancy_status_not_published', true,
            'building_age_not_published', true,
            'source_information_date_not_published', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'computed_price_per_square_wah', 536906.25,
            'source_does_not_publish_price_per_square_wah', true,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-09',
            'source_property_photo_date_displayed', '2024-11-22',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '18.799629,99.024791',
            'administrator_coordinate_distance_from_source_m_approx', 1.30
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for SL0140. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนซุปเปอร์ไฮเวย์สายเชียงใหม่-ลำปาง (ทล.11)', 'Chiang Mai-Lampang Superhighway 11', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'เซ็นทรัล เชียงใหม่', 'Central Chiang Mai', 'shopping', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'โรงเรียนวชิรวิทย์ เชียงใหม่', 'Wachirawit Chiang Mai School', 'education', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'ศาลอุทธรณ์ภาค 5', 'Court of Appeal Region 5', 'government', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'สถานีขนส่งผู้โดยสารจังหวัดเชียงใหม่ แห่งที่ 3', 'Chiang Mai Bus Terminal 3', 'transit', NULL, NULL, NULL, 50, true),
        (property_listing_id, 'บิ๊กซี เอ็กซ์ตร้า เชียงใหม่', 'Big C Extra Chiang Mai', 'shopping', NULL, NULL, NULL, 60, false)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '17,181,000 บาท — โปรดตรวจสอบราคาล่าสุดและโปรโมชั่นกับ SAM', 'THB 17,181,000 — confirm the latest price and promotions with SAM', 'unspecified', 17181000, 'THB', 20),
        (property_listing_id, 'mixed_use', 'การใช้งานแบบผสม', 'Mixed use', 'ค้นพบได้ทั้งหมวดที่อยู่อาศัยและธุรกิจ แต่ผู้ซื้อต้องตรวจข้อกำหนดของกิจการและอาคารก่อนใช้งานจริง', 'Discoverable in both homes and business categories, but buyers must verify building and business-use requirements', 'buyer', NULL, '', 30),
        (property_listing_id, 'registered_building', 'สิ่งปลูกสร้างตามรายการรับโอน', 'Registered building', 'ตึกแถว 3 ชั้นครึ่ง 2 คูหา เลขที่ 161/76 หลังมุม — ตรวจทะเบียนอาคารและรายการที่จะโอนกับ SAM', 'Three-and-a-half-storey row building with two units, no. 161/76, corner position — verify registration and transfer schedule with SAM', 'buyer', 2, 'units', 40),
        (property_listing_id, 'corner_two_road_frontages', 'หลังมุมติดถนน 2 ด้าน', 'Corner with two road frontages', 'ด้านทิศใต้ประมาณ 8 เมตรและด้านทิศตะวันตกประมาณ 16 เมตร ต้องตรวจแนวเขต ทางเข้าออก และพื้นที่จอดรถจริง', 'Approximately eight metres on the south and sixteen metres on the west; verify boundaries, access and actual parking', 'buyer', 2, 'sides', 50),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนด แนวเขต ทะเบียนและแบบอาคาร พื้นที่ใช้สอย การเชื่อม 2 คูหา ทางหนีไฟ ระบบอัคคีภัย การครอบครอง ภาระผูกพัน ค่าใช้จ่ายส่วนกลาง ผังเมือง และใบอนุญาตกิจการ', 'Verify title, boundaries, building records and plans, usable area, connection between the two units, fire escape and safety systems, possession, encumbrances, common fees, zoning and business licences', 'buyer', NULL, '', 60)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'อาคารพาณิชย์หลังมุม 2 คูหา', 'อาคารพาณิชย์ SAM รหัส SL0140 หลังมุม 3 ชั้นครึ่ง 2 คูหา ในกรีนพลัสมอลล์ 3 เชียงใหม่', 'https://npa.sam.or.th/site/images/npa/22254/20241204161949_SL0140P4_67.jpg', '/listing-media/sam/sl0140/01.webp', 'image/webp', 18864, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ด้านหน้ากระจกของอาคาร', 'ภาพด้านหน้าและด้านข้างของอาคารพาณิชย์หลังมุมเลขที่ 161/76', 'https://npa.sam.or.th/site/images/npa/22254/SL0140P5_67.jpg', '/listing-media/sam/sl0140/02.webp', 'image/webp', 17218, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ด้านข้างอาคารหลังมุม', 'ภาพด้านข้างอาคารพาณิชย์ 3 ชั้นครึ่งติดถนนภายในโครงการ', 'https://npa.sam.or.th/site/images/npa/22254/SL0140P6_67.jpg', '/listing-media/sam/sl0140/03.webp', 'image/webp', 18166, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวร้านค้าและถนนภายใน', 'ภาพอาคารพาณิชย์และแนวถนนภายในกรีนพลัสมอลล์ 3', 'https://npa.sam.or.th/site/images/npa/22254/SL0140P3_67.jpg', '/listing-media/sam/sl0140/04.webp', 'image/webp', 15658, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้าจากถนนซุปเปอร์ไฮเวย์', 'ภาพจุดเลี้ยวจากถนนซุปเปอร์ไฮเวย์สายเชียงใหม่-ลำปางเข้าสู่เชียงใหม่บิสสิเนสพาร์ค', 'https://npa.sam.or.th/site/images/npa/22254/SL0140P1_67.jpg', '/listing-media/sam/sl0140/05.webp', 'image/webp', 18470, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้าซอยกรีนพลัสมอลล์ 3', 'ภาพจุดเลี้ยวจากเชียงใหม่บิสสิเนสพาร์คซอย 5 เข้าสู่กรีนพลัสมอลล์ 3', 'https://npa.sam.or.th/site/images/npa/22254/SL0140P2_67.jpg', '/listing-media/sam/sl0140/06.webp', 'image/webp', 22696, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังแปลงหลังมุมติดถนน 2 ด้าน', 'ผังต้นทางแสดงแปลงที่ดิน 32 ตารางวา ติดถนนด้านทิศใต้และทิศตะวันตก', 'https://npa.sam.or.th/site/images/npa/22254/20241204161949_SL0140C1_67.jpg', '/listing-media/sam/sl0140/07.webp', 'image/webp', 17666, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังอาคารพาณิชย์ 2 คูหา', 'ผังต้นทางแสดงตำแหน่งอาคารพาณิชย์ 3 ชั้นครึ่ง 2 คูหาบนแปลงเลขที่ 161/76', 'https://npa.sam.or.th/site/images/npa/22254/20241204161949_SL0140C2_67.jpg', '/listing-media/sam/sl0140/08.webp', 'image/webp', 17124, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปทรัพย์', 'แผนที่ต้นทางแสดงเส้นทางจากถนนซุปเปอร์ไฮเวย์ผ่านเชียงใหม่บิสสิเนสพาร์คไปกรีนพลัสมอลล์ 3', 'https://npa.sam.or.th/site/images/npa/22254/20241204161949_SL0140M_67.jpg', '/listing-media/sam/sl0140/09.webp', 'image/webp', 35760, 785, 600, 90, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=22254&keyref=6004080',
        'SL0140',
        '2026-09-09 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 17,181,000 for a corner commercial shophouse in Green Plus Mall 3, Nong Pa Khrang, Mueang Chiang Mai. Title deed no. 125863 covers 32 sq.wah / 128 sq.m. SAM identifies the transferred structure as a three-and-a-half-storey row building comprising two units, no. 161/76. The rectangular plot fronts roads on two sides, with an approximately eight-metre southern side, sixteen-metre western side and sixteen-metre depth. Green Plus Mall 3 Soi is described as a concrete internal road in an authorized allocated development, approximately six metres wide within an approximately twelve-metre right of way. The source identifies orange planning zoning, a residential and commercial area and complete utilities. Usable area, bedrooms, bathrooms, parking, occupancy, building age and the date of the detailed information are not published. Source property photos display 22 November 2024. Administrator coordinates are approximately 1.30 metres from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all nine unique source property, access, site-plan and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Corner 3.5-Storey, Two-Unit Shophouse in Green Plus Mall 3, THB 17.181M',
        E'A corner commercial shophouse comprising two units and three and a half storeys, no. 161/76, in Green Plus Mall 3, Nong Pa Khrang, Mueang Chiang Mai. The property stands on title deed no. 125863 with 32 sq.wah (128 sq.m.) of land. It may be considered for residential, retail, office or mixed use, subject to verification of building and business requirements.

The rectangular plot fronts roads on two sides. Its southern side is approximately eight metres wide, western side approximately sixteen metres wide, and depth approximately sixteen metres. Green Plus Mall 3 Soi is an internal concrete road in an authorized allocated development, approximately six metres wide within an approximately twelve-metre right of way. Buyers should verify boundaries, ingress and egress, actual parking and loading arrangements for the intended use.

SAM''s registered acquisition record identifies a three-and-a-half-storey row building comprising two units, numbered 161/76, in a corner position. The source does not publish usable area, bedroom or bathroom counts, parking, building age, occupancy or the date of the detailed information. Buyers should ask SAM, the Land Office and the municipality to confirm building registration, approved plans, permits, usable area, the connection between the two units, fire escape and every structure included in the transfer.

SAM identifies orange planning zoning, a residential and commercial area and complete utilities. MapxProp therefore classifies this as mixed use and makes it discoverable in both homes and business categories. This is not confirmation that every type of business is permitted. Buyers must verify zoning, development rules, building-control requirements, signage, parking, licences and regulations for the intended activity.

SAM''s directions use the Chiang Mai-Lampang Superhighway 11 from Doi Suthep toward Saraphi, passing Central Chiang Mai, the Juvenile Court intersection, Chiang Mai Kwaeng Court and Big C Extra Chiang Mai. Turn into Chiang Mai Business Park, then Soi 5 and Green Plus Mall 3, approximately 670 metres in total. The property is on the left, on a corner with two road frontages. Nearby destinations listed by SAM include Wachirawit Chiang Mai School, Court of Appeal Region 5 and Chiang Mai Bus Terminal 3.

The SAM page lists the property for direct purchase at an announced price of THB 17,181,000. It is not an auction. Contact SAM directly to confirm availability, offer procedures, current price, promotions, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: SL0140. MapxProp does not collect deposits or represent SAM in the transaction.

Source property photos display 22 November 2024, and conditions may have changed. Buyers should inspect both units, the structure, roof, electrical and utility systems, fire escape and fire-safety systems, possession, encumbrances, common fees, taxes, permitted use and every current term before deciding.',
        '161/76, Green Plus Mall 3',
        'Near Chiang Mai Business Park and the Chiang Mai-Lampang Superhighway 11',
        'Green Plus Mall 3 Soi',
        'Nong Pa Khrang',
        'Mueang Chiang Mai',
        'Chiang Mai',
        'SAM Mixed-Use Corner Shophouse in Chiang Mai, THB 17.181M',
        'Official SAM NPA asset SL0140: corner 3.5-storey, two-unit shophouse on 128 sq.m. in Green Plus Mall 3. Direct-sale price THB 17.181M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset SL0140 mixed use corner shophouse commercial building two units 161/76 Green Plus Mall 3 Chiang Mai Business Park Nong Pa Khrang Mueang Chiang Mai Highway 11 32 sq.wah 128 sq.m. title deed 125863 three and a half storeys THB 17181000')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=22254&keyref=6004080'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=22254&keyref=6004080',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for SL0140. Specifications, title deed, registered building, images, rounded coordinates, announced price, direct-purchase status, road measurements, planning-zone wording and mixed residential-commercial area description come from that record.',
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
        '024f0057-e156-4173-b3c3-8c5e205b4873',
        jsonb_build_object(
            'reference_code', 'SL0140',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'mixed',
            'discovery_channels', jsonb_build_array('business', 'homes'),
            'title_document_count', 1,
            'registered_unit_count', 2,
            'registered_floor_count', 3.5,
            'corner_two_road_frontages', true,
            'business_use_review_required', true,
            'source_image_count', 9
        )
    );
END $$;

COMMIT;
