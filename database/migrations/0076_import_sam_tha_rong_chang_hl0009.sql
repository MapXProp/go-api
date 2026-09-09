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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing HL0009';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing HL0009';
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
        'ae3e3325-de5d-4c60-bf7c-2e1c09ff1e8a',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'detached_house',
        'residential',
        'sale',
        'whole_property',
        'ขายตรง SAM บ้านเดี่ยวพร้อมบ้านชั้นเดียว 2 หลัง ท่าโรงช้าง พุนพิน 2 งาน 33 ตร.ว. ราคา 1.295 ล้านบาท',
        E'บ้านเดี่ยวในตำบลท่าโรงช้าง อำเภอพุนพิน จังหวัดสุราษฎร์ธานี บนที่ดิน 2 งาน 33 ตร.ว. (233 ตร.ว. หรือ 932 ตร.ม.) โฉนดที่ดินเลขที่ 10728 จำนวน 1 ฉบับ หน้า SAM ระบุรวม 6 ห้องนอน 3 ห้องน้ำ และระบุสิ่งปลูกสร้างที่ SAM รับโอนกรรมสิทธิ์เป็นบ้านพักอาศัยตึกชั้นเดียว ไม่ปรากฏเลขที่ จำนวน 2 หลัง\n\nแปลงที่ดินรูปคล้ายสี่เหลี่ยมผืนผ้า ด้านทิศตะวันออกติดทาง กว้างประมาณ 27 เมตร ลึกสุดประมาณ 33.5 เมตร จุดสำคัญคือถนนผ่านหน้าทรัพย์เป็นที่ดินโฉนดเลขที่ 10729 ซึ่งเป็นทางส่วนบุคคล โดย SAM ระบุว่าได้จดภาระจำยอมเรื่องทางเข้า-ออกและระบบสาธารณูปโภคอื่น ๆ ให้แก่แปลงทรัพย์สินแล้ว ผู้ซื้อควรตรวจสำเนาโฉนดและรายการจดทะเบียนภาระจำยอม ขอบเขตทาง ความกว้าง สภาพทางจริง และสิทธิใช้ทางให้เป็นที่พอใจก่อนเสนอซื้อ\n\nทรัพย์อยู่ในเขตผังเมืองสีเขียว ย่านที่อยู่อาศัยและเกษตรกรรม การเดินทางจากถนนสายแยกทางหลวงหมายเลข 41-วัดถ้ำสิงขร (สฎ.2020) จากท่าข้ามมุ่งหน้าบางมะเดื่อ ผ่านโรงเรียนวัดนาคาวาสและวัดนาคาวาส ตรงจากแยกถนนสายเอเชีย (ทล.41) ประมาณ 2.3 กิโลเมตร เลี้ยวซ้ายเข้าถนนหน้าประปาประมาณ 160 เมตร แล้วเลี้ยวซ้ายเข้าซอยประมาณ 30 เมตร ทรัพย์อยู่ด้านขวามือ สถานที่ใกล้เคียงที่ SAM ระบุ ได้แก่ วัดนาคาวาส โรงเรียนวัดนาคาวาส โรงพยาบาลท่าโรงช้าง และโรงเรียนบ้านนาใหญ่\n\nหน้า SAM ระบุสถานะ “ซื้อตรง” และราคาประกาศขาย 1,295,000 บาท ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อยืนยันว่ายังพร้อมขาย สถานะผู้ครอบครอง สภาพบ้าน ขั้นตอนเสนอซื้อ ราคา ค่าใช้จ่าย และเงื่อนไขล่าสุด โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ HL0009 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nภาพทรัพย์ต้นทางลงวันที่ 19 กันยายน 2566 และมองเห็นฝ้าเพดานบางส่วนหลุดหรือเปิดโล่ง รวมถึงส่วนหลังคาและผิวอาคารที่ควรตรวจสภาพและประเมินค่าซ่อมอีกครั้ง หน้า SAM ไม่ระบุพื้นที่ใช้สอย ที่จอดรถ อายุอาคาร สถานะผู้ครอบครอง ภาระผูกพันอื่น หรือสภาพระบบไฟฟ้าและประปาภายใน ผู้ซื้อควรนัดตรวจบ้าน ตรวจเอกสารสิทธิ์ รายการสิ่งปลูกสร้าง แนวเขต สิทธิทางเข้า-ออก และสภาพปัจจุบันก่อนตัดสินใจ',
        1295000,
        false,
        932,
        6,
        3,
        1,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sales@sam.or.th',
        '@samline',
        true,
        true,
        'บ้านพักอาศัยตึกชั้นเดียว 2 หลัง ไม่ปรากฏเลขที่',
        'ใกล้ถนนหน้าประปา ถนนสายแยก ทล.41-วัดถ้ำสิงขร',
        'ถนนสายแยกทางหลวงหมายเลข 41-วัดถ้ำสิงขร (สฎ.2020)',
        NULL,
        9.06607802,
        99.16305168,
        'สุราษฎร์ธานี',
        'พุนพิน',
        'ท่าโรงช้าง',
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
        'sam-direct-sale-two-single-storey-houses-tha-rong-chang-phunphin-hl0009'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 1295000, 'total', 'THB', false
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
        'detached_house',
        1,
        jsonb_build_object(
            'source_property_category', 'บ้านเดี่ยว',
            'land_area_ngan', 2,
            'land_area_square_wah', 33,
            'land_area_total_square_wah', 233,
            'land_area_sqm', 932,
            'title_deed_number', '10728',
            'title_document_count', 1,
            'floor_count', 1,
            'bedroom_count', 6,
            'bathroom_count', 3,
            'registered_transferred_structure_count', 2,
            'registered_transferred_structures', jsonb_build_array(
                'บ้านพักอาศัยตึกชั้นเดียว ไม่ปรากฏเลขที่ หลังที่ 1',
                'บ้านพักอาศัยตึกชั้นเดียว ไม่ปรากฏเลขที่ หลังที่ 2'
            ),
            'plot_shape', 'near_rectangle',
            'east_road_frontage_m', 27,
            'maximum_depth_m', 33.5,
            'front_access_title_deed_number', '10729',
            'access_type', 'private_road_with_registered_servitude',
            'front_access_road_ownership', 'private',
            'registered_servitude_for_ingress_egress', true,
            'registered_servitude_for_utilities', true,
            'access_rights_require_buyer_verification', true,
            'zoning_color_th', 'สีเขียว',
            'surrounding_area_use_th', 'ที่อยู่อาศัยและเกษตรกรรม',
            'source_images_show_visible_ceiling_openings', true,
            'source_images_show_areas_requiring_condition_review', true,
            'current_repair_scope_requires_inspection', true,
            'usable_area_not_published', true,
            'parking_information_not_published', true,
            'building_age_not_published', true,
            'occupancy_status_not_published', true,
            'other_encumbrances_not_published', true,
            'internal_utilities_condition_not_published', true,
            'purchase_method', 'direct_purchase_from_sam',
            'published_price_kind', 'announced_sale_price',
            'source_status_at_import', 'direct_purchase',
            'status_checked_on', '2026-09-09',
            'source_property_photo_date_displayed', '2023-09-19',
            'administrator_coordinates_used', true,
            'source_coordinates_rounded', '9.066078,99.163052',
            'administrator_coordinate_distance_from_source_m_approx', 0.04
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for HL0009. MapxProp does not collect deposits or represent SAM in the transaction.',
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
        (property_listing_id, 'ถนนสายเอเชีย (ทล.41)', 'Asian Highway 2 / Highway 41', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'วัดนาคาวาส', 'Wat Nakhawat', 'landmark', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'โรงเรียนวัดนาคาวาส', 'Wat Nakhawat School', 'education', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'โรงพยาบาลท่าโรงช้าง', 'Tha Rong Chang Hospital', 'healthcare', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'โรงเรียนบ้านนาใหญ่', 'Ban Na Yai School', 'education', NULL, NULL, NULL, 50, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '1,295,000 บาท — โปรดตรวจสอบราคาล่าสุดกับ SAM', 'THB 1,295,000 — confirm the latest price with SAM', 'unspecified', 1295000, 'THB', 20),
        (property_listing_id, 'title_and_structures', 'เอกสารสิทธิ์และสิ่งปลูกสร้าง', 'Title and structures', 'โฉนดเลขที่ 10728 จำนวน 1 ฉบับ พร้อมบ้านพักอาศัยตึกชั้นเดียวไม่ปรากฏเลขที่ 2 หลัง', 'Title deed no. 10728, one document, with two unnumbered single-storey residences', 'unspecified', NULL, '', 30),
        (property_listing_id, 'private_road_servitude', 'ทางส่วนบุคคลและภาระจำยอม', 'Private road and servitude', 'ทางผ่านหน้าทรัพย์เป็นโฉนดเลขที่ 10729 ซึ่งเป็นทางส่วนบุคคล SAM ระบุว่าจดภาระจำยอมทางเข้า-ออกและสาธารณูปโภคไว้แล้ว ผู้ซื้อต้องตรวจเอกสารและสิทธิใช้ทางก่อนเสนอซื้อ', 'The frontage access crosses private title deed no. 10729. SAM states that ingress, egress and utility servitudes are registered; buyers must verify the documents and access rights before offering', 'buyer', NULL, '', 40),
        (property_listing_id, 'condition_and_due_diligence', 'สภาพทรัพย์และการตรวจสอบก่อนซื้อ', 'Condition and buyer due diligence', 'ภาพวันที่ 19 กันยายน 2566 แสดงบางบริเวณที่ฝ้าและหลังคาควรตรวจสอบ ผู้ซื้อต้องตรวจสภาพปัจจุบัน งานซ่อม พื้นที่ใช้สอย ผู้ครอบครอง เอกสารสิทธิ์ แนวเขต และภาระผูกพันด้วยตนเอง', 'Images dated 19 September 2023 show ceiling and roof areas requiring review; buyers must independently inspect current condition, repairs, usable area, occupancy, title, boundaries and encumbrances', 'buyer', NULL, '', 50)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ภาพรวมบ้านพัก 2 หลัง', 'ภาพรวมบ้านพักอาศัยตึกชั้นเดียว 2 หลังบนแปลงทรัพย์ SAM HL0009', 'https://npa.sam.or.th/site/images/npa/21243/20240227135302_HL0009P4_67.jpg', '/listing-media/sam/hl0009/01.webp', 'image/webp', 45228, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเข้าสู่แปลงทรัพย์', 'ทางส่วนบุคคลเข้าสู่แปลงทรัพย์พร้อมแนวเขตตามภาพต้นทาง', 'https://npa.sam.or.th/site/images/npa/21243/HL0009P3_67.jpg', '/listing-media/sam/hl0009/02.webp', 'image/webp', 38884, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บ้านพักทั้งสองหลัง', 'บ้านพักชั้นเดียวสีชมพูและสีเขียวภายในแปลงทรัพย์', 'https://npa.sam.or.th/site/images/npa/21243/HL0009P5_67.jpg', '/listing-media/sam/hl0009/03.webp', 'image/webp', 40022, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บ้านพักหลังสีเขียว', 'มุมด้านหน้าบ้านพักชั้นเดียวหลังสีเขียว', 'https://npa.sam.or.th/site/images/npa/21243/HL0009P6_67.jpg', '/listing-media/sam/hl0009/04.webp', 'image/webp', 43282, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ลานระหว่างบ้านพัก', 'ลานและพื้นที่ระหว่างบ้านพักชั้นเดียวทั้งสองหลัง', 'https://npa.sam.or.th/site/images/npa/21243/HL0009P7_67.jpg', '/listing-media/sam/hl0009/05.webp', 'image/webp', 40928, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ป้ายขายหน้าบ้านหลังสีเขียว', 'พื้นที่ชายคาและป้ายขาย SAM บริเวณบ้านพักหลังสีเขียว', 'https://npa.sam.or.th/site/images/npa/21243/HL0009P8_67.jpg', '/listing-media/sam/hl0009/06.webp', 'image/webp', 31810, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงภายในบ้านหลังสีเขียว', 'โถงภายในบ้านหลังสีเขียวพร้อมสภาพฝ้าเพดานตามภาพต้นทาง', 'https://npa.sam.or.th/site/images/npa/21243/HL0009P9_67.jpg', '/listing-media/sam/hl0009/07.webp', 'image/webp', 15976, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมโถงภายในอีกด้าน', 'มุมโถงภายในบ้านหลังสีเขียวและประตูทางเข้า', 'https://npa.sam.or.th/site/images/npa/21243/HL0009P10_67.jpg', '/listing-media/sam/hl0009/08.webp', 'image/webp', 15860, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องภายในบ้านหลังสีชมพู', 'ห้องภายในบ้านหลังสีชมพูพร้อมสภาพฝ้าเพดานตามภาพต้นทาง', 'https://npa.sam.or.th/site/images/npa/21243/HL0009P11_67.jpg', '/listing-media/sam/hl0009/09.webp', 'image/webp', 20902, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องภายในที่เห็นแนวหลังคา', 'ห้องภายในพร้อมแนวหลังคาเปิดโล่งตามสภาพในภาพต้นทาง', 'https://npa.sam.or.th/site/images/npa/21243/HL0009P12_67.jpg', '/listing-media/sam/hl0009/10.webp', 'image/webp', 22814, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำ', 'ห้องน้ำภายในทรัพย์พร้อมสภาพเพดานตามภาพต้นทาง', 'https://npa.sam.or.th/site/images/npa/21243/HL0009P13_67.jpg', '/listing-media/sam/hl0009/11.webp', 'image/webp', 17766, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ด้านหน้าบ้านหลังสีชมพู', 'ด้านหน้าบ้านพักชั้นเดียวหลังสีชมพู', 'https://npa.sam.or.th/site/images/npa/21243/HL0009P14_67.jpg', '/listing-media/sam/hl0009/12.webp', 'image/webp', 39166, 450, 450, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บ้านหลังสีชมพูและบ้านหลังสีเขียว', 'มุมด้านข้างบ้านหลังสีชมพูโดยมีบ้านหลังสีเขียวอยู่ด้านหลัง', 'https://npa.sam.or.th/site/images/npa/21243/HL0009P15_67.jpg', '/listing-media/sam/hl0009/13.webp', 'image/webp', 46236, 450, 450, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ลานด้านหน้าบ้านหลังสีชมพู', 'พื้นที่ลานกว้างด้านหน้าบ้านพักหลังสีชมพู', 'https://npa.sam.or.th/site/images/npa/21243/HL0009P16_67.jpg', '/listing-media/sam/hl0009/14.webp', 'image/webp', 47274, 450, 450, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ทางเดินหลังคาคลุมระหว่างอาคาร', 'แนวทางเดินและพื้นที่หลังคาคลุมข้างบ้านพัก', 'https://npa.sam.or.th/site/images/npa/21243/HL0009P17_67.jpg', '/listing-media/sam/hl0009/15.webp', 'image/webp', 37984, 450, 450, 150, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'จุดเลี้ยวจากถนนสายเอเชีย', 'จุดแยกจากถนนสายเอเชีย ทล.41 เข้าถนนสายวัดถ้ำสิงขร สฎ.2020', 'https://npa.sam.or.th/site/images/npa/21243/HL0009P1_67.jpg', '/listing-media/sam/hl0009/16.webp', 'image/webp', 22738, 450, 450, 160, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'จุดเลี้ยวเข้าถนนหน้าประปา', 'จุดเลี้ยวซ้ายจากถนน สฎ.2020 เข้าถนนหน้าประปา', 'https://npa.sam.or.th/site/images/npa/21243/HL0009P2_67.jpg', '/listing-media/sam/hl0009/17.webp', 'image/webp', 23156, 450, 450, 170, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังแปลงและทางภาระจำยอม', 'ผังโฉนดเลขที่ 10728 และทางส่วนบุคคลโฉนดเลขที่ 10729 ซึ่ง SAM ระบุว่าจดภาระจำยอมไว้', 'https://npa.sam.or.th/site/images/npa/21243/20240227135302_HL0009C2_67.jpg', '/listing-media/sam/hl0009/18.webp', 'image/webp', 27474, 450, 450, 180, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังสิ่งปลูกสร้าง 2 หลัง', 'ผังแสดงบ้านพักอาศัยตึกชั้นเดียว 2 หลังและแนวแปลงทรัพย์', 'https://npa.sam.or.th/site/images/npa/21243/20240227135302_HL0009C1_67.jpg', '/listing-media/sam/hl0009/19.webp', 'image/webp', 23114, 450, 450, 190, false, true);

    INSERT INTO public.listing_sources (
        listing_id, source_type, publisher_name, source_url,
        reference_code, captured_at, notes
    ) VALUES (
        property_listing_id,
        'editorial_import',
        'บริษัท บริหารสินทรัพย์สุขุมวิท จำกัด (SAM)',
        'https://www.sam.or.th/site/npa/detail.php?id=21243&keyref=',
        'HL0009',
        '2026-09-09 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed direct-purchase status and an announced sale price of THB 1,295,000 for a detached-house asset with two unnumbered single-storey residences, six bedrooms and three bathrooms on title deed no. 10728 covering 2 ngan 33 sq.wah / 932 sq.m. The near-rectangular plot has approximately 27 meters of east-side access frontage and a maximum depth of approximately 33.5 meters. Frontage access is via private title deed no. 10729; SAM states that ingress, egress and utility servitudes benefiting the subject property are registered and explicitly instructs buyers to verify access rights. Source coordinates are 9.066078,99.163052; administrator-supplied coordinates approximately 0.04 meters away are used. Property and interior photos display 19 September 2023 and visibly show ceiling openings and areas of the roof/buildings requiring current condition review. Usable area, parking, building age, occupancy, other encumbrances and internal utility condition are not published. SAM''s schematic area map was excluded; MapxProp stores optimized copies of fifteen property/interior photos, two route photos and two diagrams without adding a MapxProp watermark.'
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
        'SAM Direct Sale: Two Single-Storey Houses in Tha Rong Chang, Phunphin, THB 1.295M',
        E'Detached-house asset in Tha Rong Chang, Phunphin, Surat Thani, on 2 ngan 33 sq.wah (233 sq.wah or 932 sq.m.) under title deed no. 10728, one document. The SAM page lists six bedrooms and three bathrooms in total and identifies the transferred structures as two unnumbered single-storey masonry residences.\n\nThe near-rectangular plot has approximately 27 meters of east-side access frontage and a maximum depth of approximately 33.5 meters. Important: the road passing the property is private land under title deed no. 10729. SAM states that servitudes for ingress, egress and utilities benefiting the subject property have been registered. Buyers should examine the title copy, registered servitude entries, route boundaries, width, physical condition and legal access rights before submitting an offer.\n\nThe source identifies green zoning in a residential and agricultural area. Access is from Highway 41 via Surat Thani Rural Road 2020 toward Wat Tham Singkhon. From the Highway 41 intersection, continue approximately 2.3 kilometers past Wat Nakhawat School and Wat Nakhawat, turn left onto the road by the waterworks for approximately 160 meters, then left into the lane for approximately 30 meters; the property is on the right. Nearby places listed by SAM include Tha Rong Chang Hospital and Ban Na Yai School.\n\nThe SAM page lists the property for direct purchase at an announced sale price of THB 1,295,000. It is not an auction. Contact SAM directly to confirm availability, current occupancy, house condition, offer procedure, current price, expenses and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: HL0009. MapxProp does not collect deposits or represent SAM in the transaction.\n\nSource images are dated 19 September 2023 and visibly show missing or open ceiling sections and roof/building areas that require current inspection and a repair-cost assessment. The source does not publish usable area, parking, building age, occupancy, other encumbrances or internal electrical and plumbing condition. Buyers should inspect the houses and verify the title, registered structures, boundaries, access servitude and current conditions before deciding.',
        'Two unnumbered single-storey residences',
        'Near the waterworks road off Surat Thani Rural Road 2020',
        'Highway 41-Wat Tham Singkhon Road (Surat Thani Rural Road 2020)',
        'Tha Rong Chang',
        'Phunphin',
        'Surat Thani',
        'SAM Direct-Sale Houses in Tha Rong Chang, Phunphin',
        'Official SAM asset HL0009: two single-storey houses, six bedrooms and three bathrooms on 233 sq.wah in Tha Rong Chang, Phunphin. Direct-sale price THB 1.295M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset HL0009 two single storey detached houses Tha Rong Chang Phunphin Surat Thani 2 ngan 33 sq.wah 233 sq.wah 932 sq.m. 6 bedrooms 3 bathrooms title deed 10728 private road servitude title deed 10729 THB 1295000')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?id=21243&keyref='
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?id=21243&keyref=',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for HL0009. The specifications, images, rounded source coordinates, announced price, direct-purchase status, structure records and private-road servitude warning come from that record.',
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
        'ae3e3325-de5d-4c60-bf7c-2e1c09ff1e8a',
        jsonb_build_object(
            'reference_code', 'HL0009',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase',
            'private_access_title_deed_number', '10729',
            'registered_servitude_warning', true,
            'condition_review_warning', true
        )
    );
END $$;

COMMIT;
