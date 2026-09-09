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
        RAISE EXCEPTION 'MapxProp super admin is required to import SAM listing 3A1598';
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
        RAISE EXCEPTION 'Verified SAM organization is required to import listing 3A1598';
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
        '9c4d0658-2950-42c6-9b2f-b47738455e75',
        admin_user_id,
        sam_organization_id,
        admin_user_id,
        admin_user_id,
        'townhouse',
        'residence',
        'sale',
        'whole_property',
        '1369',
        'ขายตรง SAM ทาวน์เฮ้าส์ 2 ชั้น ชะอำ ใกล้ปาล์มฮิลส์ 30 ตร.ว. 3 ห้องนอน ราคา 1.843 ล้านบาท',
        E'ทาวน์เฮ้าส์ 2 ชั้น เลขที่ 1369 ถนนเลียบคลองชลประทาน ตำบลชะอำ อำเภอชะอำ จังหวัดเพชรบุรี เนื้อที่ 30 ตร.ว. (120 ตร.ม.) มี 3 ห้องนอน 2 ห้องน้ำ พร้อมพื้นที่จอดรถด้านหน้า\n\nที่ดินโฉนดเลขที่ 36743 จำนวน 1 ฉบับ รูปสี่เหลี่ยมคางหมูและติดถนน 2 ด้าน ด้านทิศตะวันออกกว้างประมาณ 8.5 เมตร ด้านทิศใต้ลึกสุดประมาณ 16.5 เมตร ผิวถนนทางเข้าเป็นคอนกรีตเสริมเหล็กกว้างประมาณ 8 เมตร เขตทางประมาณ 10 เมตร อยู่ในเขตผังเมืองสีชมพู\n\nทางเข้า-ออกผ่านที่ดินโฉนดเลขที่ 29213 และ 29214 เลขที่ดิน 8 และ 27 ซึ่งเป็นทางส่วนบุคคล โดยต้นทางระบุว่าได้จดภาระจำยอมให้แปลงทรัพย์สินแล้ว ผู้สนใจควรตรวจสอบเอกสารและสิทธิการใช้ทางกับ SAM และสำนักงานที่ดินให้เป็นที่พอใจก่อนเสนอซื้อ\n\nเดินทางจากถนนเพชรเกษม (ทล.4) ฝั่งชะอำมุ่งหน้าหัวหิน ผ่านโรงแรมเชอราตัน หัวหิน โรงแรมดุสิตธานี หัวหิน และเดอะเวเนเซีย หัวหิน เลี้ยวเข้าถนนปาล์มฮิลส์ กอล์ฟ คลับ แอนด์ เรสซิเดนซ์ แล้วเข้าถนนเลียบคลองชลประทานตามเส้นทางของ SAM ทรัพย์อยู่ใกล้ปาล์มฮิลส์ มหาวิทยาลัยนานาชาติแสตมฟอร์ด เดอะเวเนเซีย หัวหิน และท่าอากาศยานหัวหิน\n\nทรัพย์ตั้งอยู่ในแนวเขตการบินสนามบินหัวหิน ซึ่งเป็นเขตปลอดภัยในการเดินอากาศตามประกาศปี พ.ศ. 2538 ผู้ซื้อควรตรวจสอบข้อจำกัดที่เกี่ยวข้องกับหน่วยงานราชการก่อนดัดแปลงหรือต่อเติมสิ่งปลูกสร้าง\n\nหน้า SAM ระบุสถานะ “ซื้อตรง” และราคาประกาศขาย 1,843,000 บาท ไม่ใช่การประมูล ผู้สนใจต้องติดต่อ SAM โดยตรงเพื่อตรวจสอบว่ายังพร้อมขาย ราคาปัจจุบัน ขั้นตอนเสนอซื้อ ค่าใช้จ่าย และเงื่อนไขล่าสุด: โทร. 02-686-1888, Call Center 1443, LINE @samline รหัสทรัพย์ 3A1598 ทั้งนี้ MapxProp ไม่ได้รับเงินมัดจำและไม่ได้เป็นตัวแทนของ SAM\n\nผู้ซื้อควรตรวจสอบสภาพทรัพย์ เอกสารสิทธิ์ สิ่งปลูกสร้าง ภาระผูกพัน สิทธิทางเข้า-ออก แนวเขตการบิน ค่าใช้จ่าย และเงื่อนไขทั้งหมดกับ SAM ก่อนตัดสินใจ',
        1843000,
        false,
        120,
        3,
        2,
        2,
        'ฝ่ายขายและส่งเสริมกิจกรรมการขาย — SAM',
        '026861888',
        '1443',
        'sale@sam.or.th',
        '@samline',
        true,
        true,
        '1369 ถนนเลียบคลองชลประทาน',
        'ใกล้ปาล์มฮิลส์ กอล์ฟ คลับ แอนด์ เรสซิเดนซ์',
        'ถนนเลียบคลองชลประทาน',
        '76120',
        12.64746811,
        99.94717561,
        'เพชรบุรี',
        'ชะอำ',
        'ชะอำ',
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
        'sam-direct-sale-townhouse-cha-am-3a1598'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 1843000, 'total', 'THB', false
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
        'townhouse',
        1,
        jsonb_build_object(
            'land_area_square_wah', 30,
            'bedroom_count', 3,
            'bathroom_count', 2,
            'storey_count', 2,
            'source_property_category', 'ทาวน์เฮ้าส์',
            'legal_building_description', 'ทาวน์เฮ้าส์ 2 ชั้น เลขที่ 1369',
            'title_deed_number', '36743',
            'title_document_count', 1,
            'plot_shape', 'trapezoid',
            'road_frontage_sides', 2,
            'east_side_width_m', 8.5,
            'south_side_maximum_depth_m', 16.5,
            'zoning_color_th', 'สีชมพู',
            'access_road_ownership', 'private_road_with_registered_easement',
            'access_easement_title_deed_numbers', jsonb_build_array('29213', '29214'),
            'access_easement_land_numbers', jsonb_build_array('8', '27'),
            'access_road_surface', 'reinforced_concrete',
            'access_road_width_m', 8,
            'access_right_of_way_width_m', 10,
            'within_hua_hin_airport_safety_zone', true,
            'aviation_safety_zone_announcement_year_be', 2538,
            'purchase_method', 'direct_purchase_from_sam',
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
        'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 3A1598. MapxProp does not collect deposits or represent SAM in the transaction.',
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

    INSERT INTO public.listing_amenities (listing_id, amenity_code)
    VALUES (property_listing_id, 'parking')
    ON CONFLICT (listing_id, amenity_code) DO NOTHING;

    INSERT INTO public.listing_nearby_places (
        listing_id, place_name_th, place_name_en, place_type_code,
        distance_meters, latitude, longitude, sort_order, is_highlight
    ) VALUES
        (property_listing_id, 'ถนนเพชรเกษม (ทล.4)', 'Phet Kasem Road (Highway 4)', 'road', NULL, NULL, NULL, 10, true),
        (property_listing_id, 'ปาล์มฮิลส์ กอล์ฟ คลับ แอนด์ เรสซิเดนซ์', 'Palm Hills Golf Club & Residence', 'landmark', NULL, NULL, NULL, 20, true),
        (property_listing_id, 'มหาวิทยาลัยนานาชาติแสตมฟอร์ด', 'Stamford International University', 'education', NULL, NULL, NULL, 30, true),
        (property_listing_id, 'เดอะเวเนเซีย หัวหิน', 'The Venezia Hua Hin', 'shopping', NULL, NULL, NULL, 40, true),
        (property_listing_id, 'ท่าอากาศยานหัวหิน', 'Hua Hin Airport', 'transit', NULL, NULL, NULL, 50, true)
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
        (property_listing_id, 'announced_sale_price', 'ราคาประกาศขาย', 'Announced sale price', '1,843,000 บาท — โปรดตรวจสอบราคาและสถานะล่าสุดกับ SAM', 'THB 1,843,000 — confirm the current price and availability with SAM', 'unspecified', 1843000, 'THB', 20),
        (property_listing_id, 'access_easement', 'สิทธิทางเข้า-ออก', 'Access easement', 'ทางส่วนบุคคลผ่านโฉนด 29213 และ 29214 ซึ่งต้นทางระบุว่าจดภาระจำยอมแล้ว — ผู้ซื้อควรตรวจสอบเอกสาร', 'Private access over title deeds 29213 and 29214; SAM states an easement is registered — buyers should verify the documents', 'unspecified', NULL, '', 30),
        (property_listing_id, 'aviation_safety_zone', 'เขตปลอดภัยการเดินอากาศ', 'Aviation safety zone', 'อยู่ในแนวเขตการบินสนามบินหัวหิน — ตรวจสอบข้อจำกัดก่อนดัดแปลงหรือต่อเติม', 'Within the Hua Hin Airport aviation safety zone — verify restrictions before alteration or extension', 'unspecified', NULL, '', 40)
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
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ด้านหน้าทรัพย์', 'ด้านหน้าทาวน์เฮ้าส์ 2 ชั้น SAM เลขที่ 1369 ชะอำ', 'https://npa.sam.or.th/site/images/npa/20021/20250521161713_3A1598P1_68.jpg', '/listing-media/sam/3a1598/01.webp', 'image/webp', 29518, 450, 450, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมด้านข้างและแนวเขตทรัพย์', 'มุมด้านข้างทาวน์เฮ้าส์และแนวเขตหน้าทรัพย์', 'https://npa.sam.or.th/site/images/npa/20021/3A1598P2_68.jpg', '/listing-media/sam/3a1598/02.webp', 'image/webp', 28574, 450, 450, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่จอดรถและทางเข้าด้านหน้า', 'พื้นที่มีหลังคาด้านหน้าและประตูเข้าสู่ตัวบ้าน', 'https://npa.sam.or.th/site/images/npa/20021/3A1598P3_68.jpg', '/listing-media/sam/3a1598/03.webp', 'image/webp', 18112, 450, 450, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ด้านข้างตัวบ้าน', 'ทางเดินและพื้นที่ด้านข้างทาวน์เฮ้าส์', 'https://npa.sam.or.th/site/images/npa/20021/3A1598P4_68.jpg', '/listing-media/sam/3a1598/04.webp', 'image/webp', 24210, 450, 450, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงชั้นล่าง', 'พื้นที่โถงชั้นล่างภายในทาวน์เฮ้าส์', 'https://npa.sam.or.th/site/images/npa/20021/3A1598P5_68.jpg', '/listing-media/sam/3a1598/05.webp', 'image/webp', 11028, 450, 450, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงชั้นล่างและบันได', 'พื้นที่ชั้นล่างพร้อมบันไดและช่องเตรียมอาหาร', 'https://npa.sam.or.th/site/images/npa/20021/3A1598P6_68.jpg', '/listing-media/sam/3a1598/06.webp', 'image/webp', 11142, 450, 450, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บันไดภายในบ้าน', 'บันไดไม้และพื้นที่เก็บของภายในทาวน์เฮ้าส์', 'https://npa.sam.or.th/site/images/npa/20021/3A1598P7_68.jpg', '/listing-media/sam/3a1598/07.webp', 'image/webp', 15150, 450, 450, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงชั้นบน', 'โถงทางเดินบริเวณชั้นบนของทาวน์เฮ้าส์', 'https://npa.sam.or.th/site/images/npa/20021/3A1598P10_68.jpg', '/listing-media/sam/3a1598/08.webp', 'image/webp', 9958, 450, 450, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องภายในชั้นบน', 'ห้องภายในชั้นบนกั้นด้วยประตูกระจก', 'https://npa.sam.or.th/site/images/npa/20021/3A1598P11_68.jpg', '/listing-media/sam/3a1598/09.webp', 'image/webp', 10200, 450, 450, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนชั้นบน', 'ห้องนอนชั้นบนมีหน้าต่างสองด้าน', 'https://npa.sam.or.th/site/images/npa/20021/3A1598P12_68.jpg', '/listing-media/sam/3a1598/10.webp', 'image/webp', 8648, 450, 450, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนและห้องน้ำ', 'ห้องนอนชั้นบนพร้อมทางเข้าห้องน้ำและประตูด้านนอก', 'https://npa.sam.or.th/site/images/npa/20021/3A1598P13_68.jpg', '/listing-media/sam/3a1598/11.webp', 'image/webp', 11040, 450, 450, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนอีกห้อง', 'ห้องนอนชั้นบนพร้อมหน้าต่างรับแสง', 'https://npa.sam.or.th/site/images/npa/20021/3A1598P14_68.jpg', '/listing-media/sam/3a1598/12.webp', 'image/webp', 7942, 450, 450, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังทางเข้าและภาระจำยอม', 'ผังทางเข้าทรัพย์ผ่านโฉนด 29213 และ 29214 ซึ่งจดภาระจำยอมไว้', 'https://npa.sam.or.th/site/images/npa/20021/3A1598C4_65.jpg', '/listing-media/sam/3a1598/13.webp', 'image/webp', 35120, 450, 450, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังรูปแปลงที่ดิน', 'ผังโฉนดเลขที่ 36743 แสดงรูปแปลงและความยาวแต่ละด้าน', 'https://npa.sam.or.th/site/images/npa/20021/20220923204448_3A1598C1_65.jpg', '/listing-media/sam/3a1598/14.webp', 'image/webp', 11844, 450, 450, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ผังตำแหน่งสิ่งปลูกสร้าง', 'ผังตำแหน่งทาวน์เฮ้าส์ 2 ชั้นภายในแปลงทรัพย์', 'https://npa.sam.or.th/site/images/npa/20021/20220923204448_3A1598C2_65.jpg', '/listing-media/sam/3a1598/15.webp', 'image/webp', 16526, 450, 450, 150, false, true);

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
        'https://www.sam.or.th/site/npa/detail.php?ref=71599105&id=20021',
        '3A1598',
        '2026-09-09 00:00:00+07',
        'Imported from the official SAM NPA record. The source showed a direct-purchase status and an announced sale price of THB 1,843,000 at capture time. SAM states that private access over title deeds 29213 and 29214 has a registered easement, and that the property is within the Hua Hin Airport aviation safety zone; buyers should independently verify both matters before submitting an offer. The page also displayed current promotional links, but eligibility is not asserted by MapxProp and must be confirmed with SAM. Administrator-supplied coordinates are approximately 11 meters from the rounded source coordinates and are used for the listing. MapxProp stores optimized copies of all fifteen source property and diagram images without adding a MapxProp watermark.'
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
        'Direct Sale by SAM: Two-Storey Townhouse in Cha-am, 30 sq.wah, 3 Bedrooms, THB 1.843M',
        E'Two-storey townhouse, house no. 1369, on Liap Khlong Chonlaprathan Road in Cha-am, Phetchaburi. The 30 sq.wah (120 sq.m.) property has 3 bedrooms, 2 bathrooms, and a covered front parking area.\n\nTitle deed no. 36743 covers a trapezoidal plot adjoining roads on two sides. The east side is approximately 8.5 meters wide and the south side has a maximum depth of approximately 16.5 meters. The reinforced-concrete access road is approximately 8 meters wide within a 10-meter right of way. The source identifies the zoning color as pink.\n\nAccess crosses private land under title deeds 29213 and 29214, land parcel nos. 8 and 27. SAM states that an easement has been registered for the property. Buyers should verify the easement documents and access rights with SAM and the Land Office before submitting an offer.\n\nThe property is accessed from Phet Kasem Road (Highway 4) via the Palm Hills Golf Club & Residence road and Liap Khlong Chonlaprathan Road. Nearby destinations listed by SAM include Palm Hills, Stamford International University, The Venezia Hua Hin, and Hua Hin Airport.\n\nThe property is within the Hua Hin Airport aviation safety zone under an announcement dating from 1995. Buyers should check relevant restrictions with the authorities before altering or extending the building.\n\nThe SAM page lists the property as “direct purchase” with an announced sale price of THB 1,843,000; it is not an auction. Contact SAM directly to confirm current availability, price, offer procedure, expenses, and latest terms. SAM Sales: 02-686-1888; Call Center: 1443; LINE: @samline. Property ID: 3A1598. MapxProp does not collect deposits or represent SAM in the transaction.\n\nBuyers should verify the property condition, title documents, structures, encumbrances, access rights, aviation-zone restrictions, expenses, and all terms with SAM before making a decision.',
        '1369 Liap Khlong Chonlaprathan Road',
        'Near Palm Hills Golf Club & Residence',
        'Liap Khlong Chonlaprathan Road',
        'Cha-am',
        'Cha-am',
        'Phetchaburi',
        'SAM Direct-Sale Townhouse in Cha-am, 3 Bedrooms, THB 1.843M',
        'Official SAM NPA asset 3A1598: a direct-sale two-storey townhouse on 30 sq.wah in Cha-am, with 3 bedrooms and 2 bathrooms. Announced price THB 1.843M.',
        'published',
        'ai_assisted',
        now(),
        lower('SAM direct sale asset 3A1598 two-storey townhouse Cha-am Phetchaburi Palm Hills Liap Khlong Chonlaprathan 30 sq.wah 120 sq.m. 3 bedrooms 2 bathrooms THB 1843000')
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
          AND source_url = 'https://www.sam.or.th/site/npa/detail.php?ref=71599105&id=20021'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            sam_organization_id,
            'listing_authority',
            'verified',
            'https://www.sam.or.th/site/npa/detail.php?ref=71599105&id=20021',
            'The official SAM NPA record identifies SAM as the asset holder and direct-sale contact for 3A1598. The property specifications, images, rounded coordinates, announced sale price, and direct-purchase status come from that record.',
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
        '9c4d0658-2950-42c6-9b2f-b47738455e75',
        jsonb_build_object(
            'reference_code', '3A1598',
            'sale_method', 'direct_purchase',
            'source_status_at_import', 'direct_purchase'
        )
    );
END $$;

COMMIT;
