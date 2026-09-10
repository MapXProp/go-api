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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing 2T0012';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing 2T0012';
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
        '88e685fe-6045-4834-b2e8-2d71bdd5e0cb',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'land',
        'residence',
        'sale',
        'land_plot',
        'ขายตรง SAM ที่ดินเปล่า 3 แปลง ติดถนนเชียงใหม่-ฝาง แม่แตง เชียงใหม่ 5-0-67 ไร่ ราคา 14.469 ล้านบาท',
        E'ที่ดินเปล่าจำนวน 3 แปลง ตำบลขี้เหล็ก อำเภอแม่แตง จังหวัดเชียงใหม่ เอกสารสิทธิ์เป็นโฉนดที่ดินเลขที่ 19756, 19911 และ 19917 จำนวน 3 ฉบับ เนื้อที่รวม 5 ไร่ 67 ตร.ว. หรือ 2,067 ตร.ว. (8,268 ตร.ม.)

สำคัญ: SAM ระบุว่าที่ดินทั้ง 3 แปลงไม่ติดต่อกัน โดยมีลำเหมืองซึ่งปัจจุบันไม่มีสภาพคั่นกลาง แปลงเป็นรูปหลายเหลี่ยม ด้านทิศตะวันตกติดถนนกว้างประมาณ 10 เมตร ลึกสุดประมาณ 268 เมตร บางส่วนติดเหมืองสาธารณประโยชน์ประมาณ 84 เมตร และด้านทิศตะวันออกติดเหมืองสาธารณประโยชน์ประมาณ 32 เมตร ผู้ซื้อต้องตรวจโฉนด รังวัด แนวเขต ตำแหน่งแยกของแต่ละแปลง สภาพลำเหมือง และสิทธิการใช้ทางจริงก่อนเสนอซื้อ

SAM เคยได้รับโอนกรรมสิทธิ์สิ่งปลูกสร้างเป็นโรงงานบรรจุแก๊ส 1 ชั้นและอาคารสำนักงาน 1 ชั้น แต่หน้า SAM ระบุว่าสิ่งปลูกสร้างดังกล่าวถูกรื้อถอนและไม่มีสภาพอาคารแล้ว SAM จะโอนกรรมสิทธิ์เฉพาะที่ดินเปล่าเท่านั้น ประกาศนี้จึงไม่รวมพื้นที่โรงงาน สำนักงาน หรืออาคารสำหรับใช้งาน ผู้ซื้อควรให้ SAM และสำนักงานที่ดินยืนยันรายการทรัพย์ที่จะโอนและตรวจสภาพพื้นที่จริง

ถนนผ่านหน้าทรัพย์คือถนนเชียงใหม่-ฝาง (ทล.107) เป็นทางสาธารณประโยชน์ ผิวจราจรลาดยางกว้างประมาณ 12 เมตร เขตทางกว้างประมาณ 40 เมตร ตามข้อมูลของ SAM การเดินทางจากแม่ริมมุ่งหน้าเชียงดาว ผ่านโรงเรียนเมฆขจรเชียงใหม่ สถานีอนามัยบ้านรำเปิง และวัดหนองโค้ง ถึงบริเวณหลัก กม.33+300 จะพบทรัพย์อยู่ด้านขวามือ เยื้องเทศบาลตำบลจอมแจ้ง

หน้า SAM ระบุเขตพื้นที่สีขาวมีกรอบและเส้นทแยงสีเขียว พร้อมหมายเหตุว่าทรัพย์อยู่ในย่านที่อยู่อาศัยและมีสาธารณูปโภคครบครัน MapxProp จึงจัดไว้ในหมวดที่อยู่อาศัย ไม่ได้จัดเป็น Mixed Use หรือทรัพย์โรงงาน อย่างไรก็ตาม สีผังเมืองและข้อความเรื่องสภาพแวดล้อมไม่ใช่การรับรองว่าสามารถก่อสร้างหรือใช้ประโยชน์ตามแผนของผู้ซื้อได้ ผู้ซื้อต้องตรวจผังเมือง ข้อกำหนดการใช้ประโยชน์ กฎหมายอาคาร ทางเข้าออก การระบายน้ำ และใบอนุญาตกับหน่วยงานที่เกี่ยวข้องโดยตรง

หน้า SAM แสดงสถานะ “ซื้อตรง” ราคาประกาศขาย 14,469,000 บาท หรือ 7,000 บาทต่อตารางวา ไม่ใช่การประมูลในสถานะที่ตรวจสอบเมื่อวันที่ 10 กันยายน 2569 ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย ขั้นตอนเสนอซื้อ ราคาปัจจุบัน เงื่อนไข ค่าใช้จ่าย สถานะการครอบครอง และวิธีจำหน่ายล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ 2T0012 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM

ภาพสภาพทรัพย์บนหน้าต้นทางแสดงวันที่ 8 กุมภาพันธ์ 2565 และ 21 พฤศจิกายน 2565 สภาพจริงอาจเปลี่ยนแปลง ผู้ซื้อควรนัดตรวจพื้นที่ วัชพืช ซากสิ่งปลูกสร้าง ดิน การระบายน้ำ น้ำท่วม แนวเขต ลำเหมือง ทางเข้าออก สาธารณูปโภค ภาระผูกพัน ภาษี ค่าใช้จ่าย และเงื่อนไขทั้งหมดก่อนตัดสินใจ',
        14469000,
        false,
        8268,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'ที่ดินเปล่า 3 แปลง ถนนเชียงใหม่-ฝาง (ทล.107)',
        'บริเวณหลัก กม.33+300 เยื้องเทศบาลตำบลจอมแจ้ง',
        'ถนนเชียงใหม่-ฝาง (ทล.107)',
        NULL,
        19.06293079,
        98.94131304,
        'เชียงใหม่',
        'แม่แตง',
        'ขี้เหล็ก',
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
        'sam-direct-sale-three-land-plots-khi-lek-mae-taeng-2t0012'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 14469000, 'total', 'THB', false
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
        'land',
        1,
        jsonb_build_object(
            'source_property_category', 'ที่ดินเปล่า',
            'title_document_type', 'chanote',
            'title_deed_numbers', jsonb_build_array('19756', '19911', '19917'),
            'title_document_count', 3,
            'land_area_rai', 5,
            'land_area_ngan', 0,
            'land_area_square_wah_remainder', 67,
            'land_area_square_wah', 2067,
            'land_area_sqm', 8268,
            'plot_count', 3,
            'plots_contiguous', false,
            'plots_separated_by', 'ลำเหมืองซึ่งปัจจุบันไม่มีสภาพ',
            'vacant_land', true,
            'structures_present', false,
            'former_structure_1', 'โรงงานบรรจุแก๊ส 1 ชั้น',
            'former_structure_2', 'อาคารสำนักงาน 1 ชั้น',
            'former_structures_demolished', true,
            'transfer_scope', 'land_only',
            'plot_shape', 'polygon',
            'road_frontage_side_count', 1,
            'west_road_frontage_m', 10,
            'maximum_depth_m', 268,
            'public_irrigation_canal_boundary_m_approx', 84,
            'east_public_irrigation_canal_boundary_m_approx', 32,
            'front_road_name', 'ถนนเชียงใหม่-ฝาง (ทล.107)',
            'front_road_legal_status_th', 'ทางสาธารณประโยชน์',
            'front_road_surface', 'asphalt',
            'front_road_width_m', 12,
            'front_right_of_way_width_m', 40
        ) || jsonb_build_object(
            'zoning_color_th', 'สีขาวมีกรอบมีเส้นทะแยงสีเขียว ตามหน้า SAM',
            'surrounding_area_use_th', 'ย่านที่อยู่อาศัย',
            'utilities_reported_available', true,
            'mixed_use_classification', false,
            'mixed_use_exclusion_basis', 'SAM ระบุเป็นที่ดินเปล่าในย่านที่อยู่อาศัยและไม่ได้ระบุว่าเป็น Mixed Use',
            'commercial_or_industrial_use_requires_independent_verification', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'price_per_square_wah', 7000,
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-10',
            'source_information_date_not_published', true,
            'source_property_photo_dates_displayed', jsonb_build_array('2022-02-08', '2022-11-21'),
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '19.062892,98.941361',
            'administrator_coordinate_distance_from_source_m_approx', 6.63
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 2T0012. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนเชียงใหม่-ฝาง (ทล.107)', 'Chiang Mai-Fang Highway 107', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'โรงเรียนเมฆขจรเชียงใหม่', 'Mek Khachon Chiang Mai School', 'education', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'สถานีอนามัยบ้านรำเปิง', 'Ban Ram Poeng Health Center', 'healthcare', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'วัดหนองโค้ง', 'Wat Nong Khong', 'landmark', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'เทศบาลตำบลจอมแจ้ง', 'Chom Chaeng Subdistrict Municipality', 'government', NULL, NULL, NULL, 50, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '14,469,000 บาท หรือ 7,000 บาท/ตร.ว. — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 14,469,000 or THB 7,000 per sq.wah — confirm the latest price with SAM', 'unspecified', 14469000, 'THB', 20),
        (property_listing_id, 'land_only_transfer', 'ขอบเขตทรัพย์ที่จะโอน', 'Transfer scope', 'SAM ระบุว่าโรงงานบรรจุแก๊สและสำนักงานเดิมถูกรื้อถอนแล้ว และจะโอนเฉพาะที่ดินเปล่า', 'SAM says the former gas-filling factory and office were demolished and only the vacant land will be transferred', 'unspecified', NULL, '', 30),
        (property_listing_id, 'noncontiguous_plots', 'แปลงไม่ติดต่อกัน', 'Non-contiguous plots', 'ที่ดิน 3 แปลงไม่ติดต่อกัน มีแนวลำเหมืองเดิมคั่นกลาง ต้องตรวจตำแหน่งและแนวเขตแต่ละแปลง', 'The three plots are non-contiguous and separated by a former irrigation canal; verify each plot location and boundary', 'buyer', 3, 'plots', 40),
        (property_listing_id, 'highway_frontage', 'ถนนหน้าทรัพย์', 'Road frontage', 'ติดถนนเชียงใหม่-ฝาง (ทล.107) ทางสาธารณะ ผิวลาดยางกว้างประมาณ 12 เมตร เขตทางประมาณ 40 เมตร', 'Fronts public Chiang Mai-Fang Highway 107, with approximately twelve-metre asphalt carriageway and forty-metre right of way', 'unspecified', 12, 'metres', 50),
        (property_listing_id, 'zoning_review', 'ตรวจสอบผังเมืองและการใช้ประโยชน์', 'Zoning and use review', 'หน้า SAM แสดงสีขาวมีกรอบมีเส้นทแยงสีเขียว ต้องยืนยันผังเมืองปัจจุบันและการใช้ประโยชน์ที่ต้องการกับหน่วยงานท้องถิ่น', 'SAM shows a white zone with green diagonal border; confirm current planning controls and intended use with local authorities', 'buyer', NULL, '', 60),
        (property_listing_id, 'buyer_due_diligence', 'การตรวจสอบก่อนซื้อ', 'Buyer due diligence', 'ตรวจโฉนด รังวัด พื้นที่จริง แนวเขต ลำเหมือง ทางเข้าออก สาธารณูปโภค ซากสิ่งปลูกสร้าง น้ำท่วม ดิน ภาระผูกพัน ค่าใช้จ่าย สถานะการครอบครอง และเงื่อนไขล่าสุด', 'Verify title deeds, survey, actual area, boundaries, canal, access, utilities, demolition remnants, flooding, soil, encumbrances, costs, possession and current terms', 'buyer', NULL, '', 70)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'หน้าที่ดินติดถนนเชียงใหม่-ฝาง', 'หน้าที่ดิน SAM รหัส 2T0012 ติดถนนเชียงใหม่-ฝาง พร้อมป้ายประกาศขาย', 'https://npa.sam.or.th/site/images/npa/5583/20260106101203_2T0012P9_65.jpg', '/listing-media/sam/2t0012/01.webp', 'image/webp', 38996, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้าบริเวณที่ดินจากทางหลวง 107', 'ภาพทางเข้าบริเวณที่ดินเปล่าจากถนนเชียงใหม่-ฝาง พร้อมป้าย SAM', 'https://npa.sam.or.th/site/images/npa/5583/2T0012P8_65.jpg', '/listing-media/sam/2t0012/02.webp', 'image/webp', 29868, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวที่ดินติดถนนภายใน', 'ภาพแนวที่ดินเปล่าและถนนบริเวณแปลง SAM 2T0012', 'https://npa.sam.or.th/site/images/npa/5583/2T0012P3_65.jpg', '/listing-media/sam/2t0012/03.webp', 'image/webp', 33242, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวแปลงและทางเข้าด้านใน', 'ภาพแนวแปลงที่ดินและทางสัญจรด้านในของทรัพย์ 3 แปลงที่ไม่ติดต่อกัน', 'https://npa.sam.or.th/site/images/npa/5583/2T0012P4_65.jpg', '/listing-media/sam/2t0012/04.webp', 'image/webp', 28946, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ภายในแปลง', 'ภาพพื้นที่ภายในที่ดินเปล่าซึ่งมีวัชพืชและแนวทางเดิม', 'https://npa.sam.or.th/site/images/npa/5583/2T0012P5_65.jpg', '/listing-media/sam/2t0012/05.webp', 'image/webp', 48932, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บริเวณสิ่งปลูกสร้างเดิมที่ถูกรื้อถอน', 'ภาพบริเวณซากฐานและผนังบางส่วนในพื้นที่ซึ่ง SAM ระบุว่าอาคารเดิมถูกรื้อถอนแล้ว', 'https://npa.sam.or.th/site/images/npa/5583/2T0012P6_65.jpg', '/listing-media/sam/2t0012/06.webp', 'image/webp', 35892, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'แนวหน้าทรัพย์และพื้นที่เดิม', 'ภาพแนวถนนและพื้นที่สิ่งปลูกสร้างเดิมของทรัพย์ SAM 2T0012', 'https://npa.sam.or.th/site/images/npa/5583/2T0012P7_65.jpg', '/listing-media/sam/2t0012/07.webp', 'image/webp', 27134, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'site_plan', 'ผังที่ดิน 3 แปลงไม่ติดต่อกัน', 'ผังต้นทางแสดงโฉนด 3 แปลง รูปแปลงหลายเหลี่ยม แนวถนนและแนวลำเหมืองที่คั่นพื้นที่', 'https://npa.sam.or.th/site/images/npa/5583/20211119103802_2T0012C1_63.jpg', '/listing-media/sam/2t0012/08.webp', 'image/webp', 12252, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'map', 'แผนที่การเดินทางไปทรัพย์', 'แผนที่ต้นทางแสดงเส้นทางถนนเชียงใหม่-ฝางไปยังที่ดิน SAM 2T0012 ตำบลขี้เหล็ก แม่แตง', 'https://npa.sam.or.th/site/images/npa/5583/20170622103902_2T0012M1_59.jpg', '/listing-media/sam/2t0012/09.webp', 'image/webp', 30214, 785, 600, 90, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?id=5583&keyref=6004388',
        '2T0012',
        '2026-09-10 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 14,469,000, or THB 7,000 per sq.wah, for three non-contiguous vacant-land plots under title deeds 19756, 19911 and 19917. Announced total area is 5 rai 67 sq.wah / 2,067 sq.wah / 8,268 sq.m. SAM says a former irrigation canal separates the plots. The polygonal land has approximately ten metres of frontage on its western road side and a maximum depth of approximately 268 metres; portions border a public irrigation canal for approximately 84 and 32 metres. SAM states that a former one-storey gas-filling factory and one-storey office were demolished and that only vacant land will be transferred. Chiang Mai-Fang Highway 107 is described as a public asphalt road approximately twelve metres wide within an approximately forty-metre right of way. The source shows white planning zoning with a green diagonal border and describes the surroundings as residential with utilities; MapxProp therefore classifies the listing only under homes, not mixed use or industrial use. Buyers must independently verify title documents, plot separation, surveyed area, boundaries, canal, road access, planning controls, construction feasibility and current transaction terms. Source property photos display 8 February 2022 and 21 November 2022. Administrator coordinates are approximately 6.63 metres from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all nine unique source property, plot and navigation images without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Three Vacant-Land Plots on Highway 107, Mae Taeng, THB 14.469M',
        E'Three vacant-land plots in Khi Lek, Mae Taeng, Chiang Mai, under title deeds 19756, 19911 and 19917. The announced combined area is 5 rai 67 sq.wah, or 2,067 sq.wah (8,268 sq.m.).

Important: SAM says the three plots are not contiguous and are separated by a former irrigation canal that no longer has a visible physical condition. The polygonal land has approximately ten metres of road frontage on its western side and a maximum depth of approximately 268 metres. Parts of the property border a public irrigation canal for approximately 84 metres and 32 metres. Buyers should verify every title deed, survey, boundary, plot location, canal and actual access before offering.

SAM previously acquired a one-storey gas-filling factory and a one-storey office with the land, but says those structures were demolished and no longer exist. SAM will transfer only the vacant land. This listing therefore does not include usable factory, office or building space. Buyers should ask SAM and the Land Office to confirm the exact assets included in the transfer and inspect the site for any remaining structures or demolition material.

The property fronts Chiang Mai-Fang Highway 107, described by SAM as a public asphalt road approximately twelve metres wide within an approximately forty-metre right of way. SAM''s directions approach from Mae Rim toward Chiang Dao, passing Mek Khachon Chiang Mai School, Ban Ram Poeng Health Center and Wat Nong Khong. At kilometre 33+300 the property is on the right, opposite Chom Chaeng Subdistrict Municipality.

The source shows a white planning zone with a green diagonal border and describes the surroundings as residential with utilities. MapxProp therefore lists the property only under homes, not mixed use or industrial use. Planning colour and surrounding-area wording do not guarantee any intended development. Buyers must confirm current planning and land-use controls, building rules, access, drainage and permits directly with the relevant authorities.

The SAM page listed the property for direct purchase at an announced THB 14,469,000, or THB 7,000 per sq.wah, when checked on 10 September 2026. It was not shown as an auction. Contact SAM directly to confirm availability, the current sale method, offer procedures, price, costs, possession and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: 2T0012. MapxProp does not collect deposits or represent SAM in the transaction.

Source property photos display 8 February 2022 and 21 November 2022, and conditions may have changed. Buyers should arrange an inspection and verify vegetation, demolition remnants, soil, drainage, flooding, boundaries, canal, access, utilities, encumbrances, taxes, costs and every current term before deciding.',
        'Three non-contiguous vacant-land plots on Chiang Mai-Fang Highway 107',
        'Near kilometre 33+300, opposite Chom Chaeng Subdistrict Municipality',
        'Chiang Mai-Fang Highway 107',
        'Khi Lek',
        'Mae Taeng',
        'Chiang Mai',
        'SAM Vacant Land on Highway 107, Mae Taeng, THB 14.469M',
        'Official SAM NPA asset 2T0012: three non-contiguous vacant-land plots totalling 8,268 sq.m. on Highway 107. Direct-sale price THB 14.469M; land-only transfer.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset 2T0012 three non contiguous vacant land plots Khi Lek Mae Taeng Chiang Mai Chiang Mai Fang Highway 107 5 rai 67 sq.wah 2067 sq.wah 8268 sq.m. title deeds 19756 19911 19917 THB 14469000 land only former gas filling factory demolished')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=5583&keyref=6004388'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=5583&keyref=6004388',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 2T0012. Specifications, title deeds, images, rounded coordinates, announced price, direct-purchase status, land-only transfer, road measurements and planning-zone wording come from that record.',
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
        '88e685fe-6045-4834-b2e8-2d71bdd5e0cb',
        jsonb_build_object(
            'reference_code', '2T0012',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'usage_type', 'residence',
            'discovery_channels', jsonb_build_array('homes'),
            'title_document_count', 3,
            'plots_contiguous', false,
            'land_only_transfer', true,
            'zoning_review_required', true,
            'source_image_count', 9
        )
    );
END $$;

COMMIT;
