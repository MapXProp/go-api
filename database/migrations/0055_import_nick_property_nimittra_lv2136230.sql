BEGIN;

DO $$
DECLARE
    admin_user_id bigint;
    nick_organization_id bigint;
    nimittra_project_id bigint;
    property_listing_id bigint;
BEGIN
    SELECT id INTO admin_user_id
    FROM public.auth_users
    WHERE lower(email) = 'mapxprop@gmail.com'
      AND deleted_at IS NULL
    ORDER BY id
    LIMIT 1;

    IF admin_user_id IS NULL THEN
        RAISE EXCEPTION 'MapxProp super admin is required to import listing LV2136230';
    END IF;

    -- Nick Property is the verified publisher/agent for this listing. It is
    -- intentionally modeled as an agency brand without claiming a legal entity.
    INSERT INTO public.organizations (
        public_organization_id,
        slug,
        display_name,
        organization_type,
        description,
        verification_status,
        verification_note,
        verified_at,
        verified_by_user_id,
        created_by_user_id,
        is_active
    ) VALUES (
        'e1d00f74-fa64-41f0-ad14-4097770bd03b',
        'nick-property',
        'Nick Property',
        'agency',
        'นายหน้าและที่ปรึกษาด้านอสังหาริมทรัพย์ รับฝากขายและให้เช่าบ้าน คอนโด ที่ดิน และทรัพย์เชิงพาณิชย์',
        'verified',
        'Publisher identity and contact channels were cross-checked against matching public agent profiles and the exact property listing. No legal-entity status is claimed.',
        now(),
        admin_user_id,
        admin_user_id,
        true
    )
    ON CONFLICT (slug) DO UPDATE SET
        display_name = EXCLUDED.display_name,
        organization_type = EXCLUDED.organization_type,
        description = EXCLUDED.description,
        verification_status = 'verified',
        verification_note = EXCLUDED.verification_note,
        verified_at = COALESCE(public.organizations.verified_at, now()),
        verified_by_user_id = admin_user_id,
        is_active = true,
        deleted_at = NULL,
        updated_at = now()
    RETURNING id INTO nick_organization_id;

    INSERT INTO public.organization_specialties (organization_id, specialty_code)
    VALUES
        (nick_organization_id, 'sale'),
        (nick_organization_id, 'house')
    ON CONFLICT (organization_id, specialty_code) DO NOTHING;

    INSERT INTO public.organization_contacts (
        organization_id, channel_type, channel_value, label,
        is_primary, is_public, is_verified, verified_at
    ) VALUES
        (nick_organization_id, 'phone', '0868462666', 'คุณนิค', true, true, true, now()),
        (nick_organization_id, 'phone', '0859582000', 'คุณมิ้น', false, true, true, now()),
        (nick_organization_id, 'line', '@nickperfect', 'LINE', false, true, true, now())
    ON CONFLICT (organization_id, channel_type, channel_value) DO UPDATE SET
        label = EXCLUDED.label,
        is_primary = EXCLUDED.is_primary,
        is_public = true,
        is_verified = true,
        verified_at = COALESCE(public.organization_contacts.verified_at, now()),
        updated_at = now();

    IF NOT EXISTS (
        SELECT 1
        FROM public.organization_verifications
        WHERE organization_id = nick_organization_id
          AND verification_type = 'contact'
          AND status = 'verified'
          AND source_url = 'https://www.thaihometown.com/home/4453376'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            nick_organization_id,
            'contact',
            'verified',
            'https://www.thaihometown.com/home/4453376',
            'The exact matching property advertisement publishes Nick Property contacts 086-846-2666, 085-958-2000, and LINE @nickperfect.',
            admin_user_id,
            now()
        );
    END IF;

    -- Nimittra is an established housing estate. Developer and completion
    -- details are left blank because no reliable public evidence was found.
    INSERT INTO public.property_projects (
        public_project_id,
        slug,
        project_category,
        name_th,
        name_en,
        supported_property_types,
        description_th,
        description_en,
        address_line1,
        subdistrict_name,
        district_name,
        province_name,
        postal_code,
        latitude,
        longitude,
        source_url,
        verification_status,
        verification_note,
        metadata
    ) VALUES (
        '8287e18d-9821-42da-806e-b5ebdcb62b9e',
        'nimittra-bang-kruai',
        'housing_estate',
        'หมู่บ้านนิมิตรา',
        'Nimittra',
        ARRAY['detached_house'],
        'หมู่บ้านจัดสรรเดิมในตำบลบางกรวย อำเภอบางกรวย จังหวัดนนทบุรี ใกล้การไฟฟ้าฝ่ายผลิตแห่งประเทศไทยและ MRT บางอ้อ',
        'An established housing estate in Bang Kruai, Nonthaburi, near EGAT headquarters and MRT Bang O.',
        'ซอยหมู่บ้านนิมิตรา',
        'บางกรวย',
        'บางกรวย',
        'นนทบุรี',
        '11130',
        13.81060000,
        100.50315000,
        'https://www.yellowpages.co.th/profile/หมู่บ้านนิมิตรา-nagy4m',
        'source_checked',
        'The housing-estate identity and approximate estate center were cross-checked against public project and map directories. Developer and completion details remain unknown.',
        jsonb_build_object(
            'project_kind', 'legacy_housing_estate',
            'developer_known', false
        )
    )
    ON CONFLICT (slug) DO UPDATE SET
        project_category = EXCLUDED.project_category,
        name_th = EXCLUDED.name_th,
        name_en = EXCLUDED.name_en,
        supported_property_types = EXCLUDED.supported_property_types,
        description_th = EXCLUDED.description_th,
        description_en = EXCLUDED.description_en,
        address_line1 = EXCLUDED.address_line1,
        subdistrict_name = EXCLUDED.subdistrict_name,
        district_name = EXCLUDED.district_name,
        province_name = EXCLUDED.province_name,
        postal_code = EXCLUDED.postal_code,
        latitude = EXCLUDED.latitude,
        longitude = EXCLUDED.longitude,
        source_url = EXCLUDED.source_url,
        verification_status = EXCLUDED.verification_status,
        verification_note = EXCLUDED.verification_note,
        metadata = EXCLUDED.metadata,
        is_active = true,
        deleted_at = NULL,
        updated_at = now()
    RETURNING id INTO nimittra_project_id;

    INSERT INTO public.property_project_aliases (
        project_id, locale, alias_name, alias_type
    ) VALUES
        (nimittra_project_id, 'th', 'หมู่บ้านนิมิตรา', 'official'),
        (nimittra_project_id, 'th', 'นิมิตรา', 'alternate'),
        (nimittra_project_id, 'th', 'ม.นิมิตรา', 'alternate'),
        (nimittra_project_id, 'en', 'Nimittra', 'official'),
        (nimittra_project_id, 'en', 'Baan Nimittra', 'alternate'),
        (nimittra_project_id, 'en', 'Nimittra Village', 'alternate')
    ON CONFLICT (project_id, locale, normalized_alias) DO NOTHING;

    INSERT INTO public.listings (
        public_listing_id,
        user_id,
        organization_id,
        created_by_user_id,
        published_by_user_id,
        project_id,
        property_type_code,
        usage_type,
        listing_type,
        listing_scope,
        custom_project_name,
        title,
        description,
        sale_price,
        price_negotiable,
        land_area_sqm,
        usable_area_sqm,
        bedroom_count,
        bathroom_count,
        parking_count,
        total_floors,
        furnishing_status,
        contact_name,
        contact_phone,
        contact_phone_secondary,
        line_id,
        show_phone,
        show_email,
        address_line1,
        address_line2,
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
        '7cf34aa7-5381-4233-8fac-712e74b3f8c6',
        admin_user_id,
        nick_organization_id,
        admin_user_id,
        admin_user_id,
        nimittra_project_id,
        'detached_house',
        'residence',
        'sale',
        'whole_property',
        'หมู่บ้านนิมิตรา',
        'ขายบ้านเดี่ยว 2 ชั้น หมู่บ้านนิมิตรา บางกรวย 42 ตร.ว. ราคา 4.2 ล้านบาท',
        E'บ้านเดี่ยว 2 ชั้น ในหมู่บ้านนิมิตรา บางกรวย ใกล้การไฟฟ้าฝ่ายผลิตฯ และ MRT บางอ้อ\n\nที่ดิน 42 ตร.ว. พื้นที่ใช้สอยประมาณ 130 ตร.ม. หน้าบ้านหันทิศเหนือ มี 2 ห้องนอน 2 ห้องน้ำ 1 ห้องครัว 1 ห้องนั่งเล่น และจอดรถได้ 2 คัน\n\nพร้อมแอร์ 3 เครื่อง และเครื่องทำน้ำอุ่น 1 เครื่อง เดินทางสะดวก ใกล้ทางด่วนศรีรัช โรงพยาบาลยันฮี โรงพยาบาลบางกรวย มจพ. เกทเวย์ แอท บางซื่อ และเซ็นทรัล ปิ่นเกล้า\n\nราคา 4,200,000 บาท\n\nติดต่อ Nick Property คุณนิค 086-846-2666 หรือคุณมิ้น 085-958-2000 LINE: @nickperfect รหัสทรัพย์ LV2136230\n\nผู้ซื้อควรตรวจสอบสภาพทรัพย์ เอกสารสิทธิ์ ค่าใช้จ่าย และเงื่อนไขกับผู้ดูแลก่อนตัดสินใจ',
        4200000,
        false,
        168,
        130,
        2,
        2,
        2,
        2,
        'partly_furnished',
        'Nick Property',
        '0868462666',
        '0859582000',
        '@nickperfect',
        true,
        false,
        'ซอยหมู่บ้านนิมิตรา',
        'หมู่บ้านนิมิตรา ใกล้การไฟฟ้าฝ่ายผลิตแห่งประเทศไทย พระราม 7',
        '11130',
        13.81265560,
        100.50317389,
        'นนทบุรี',
        'บางกรวย',
        'บางกรวย',
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
        'house-nimittra-bang-kruai-lv2136230'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 4200000, 'total', 'THB', false
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
            'land_area_square_wah', 42,
            'usable_area_sqm', 130,
            'storey_count', 2,
            'facing_direction', 'north',
            'kitchen_count', 1,
            'living_room_count', 1,
            'air_conditioner_count', 3,
            'water_heater_count', 1,
            'price_per_square_wah', 100000
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
        verification_status,
        verification_note,
        verified_at,
        verified_by_user_id,
        organization_id,
        contact_user_id
    ) VALUES (
        property_listing_id,
        'agency_broker',
        'brokerage_company',
        'Nick Property',
        'authority_verified',
        'The owner-appointed seller representation is identified consistently on the source listing and matching agent advertisements; MapxProp administrator supplied and approved this listing.',
        now(),
        admin_user_id,
        nick_organization_id,
        NULL
    )
    ON CONFLICT (listing_id) DO UPDATE SET
        role_code = EXCLUDED.role_code,
        authority_source_code = EXCLUDED.authority_source_code,
        organization_name = EXCLUDED.organization_name,
        verification_status = EXCLUDED.verification_status,
        verification_note = EXCLUDED.verification_note,
        verified_at = EXCLUDED.verified_at,
        verified_by_user_id = EXCLUDED.verified_by_user_id,
        organization_id = EXCLUDED.organization_id,
        contact_user_id = EXCLUDED.contact_user_id,
        updated_at = now();

    INSERT INTO public.listing_amenities (listing_id, amenity_code)
    VALUES
        (property_listing_id, 'air_conditioning'),
        (property_listing_id, 'parking')
    ON CONFLICT (listing_id, amenity_code) DO NOTHING;

    INSERT INTO public.listing_nearby_places (
        listing_id, place_name_th, place_name_en, place_type_code,
        sort_order, is_highlight
    ) VALUES
        (property_listing_id, 'การไฟฟ้าฝ่ายผลิตแห่งประเทศไทย สำนักงานใหญ่', 'EGAT Headquarters', 'government', 10, true),
        (property_listing_id, 'ทางด่วนศรีรัช', 'Si Rat Expressway', 'road', 20, true),
        (property_listing_id, 'MRT บางอ้อ', 'MRT Bang O', 'transit', 30, true),
        (property_listing_id, 'โรงพยาบาลยันฮี', 'Yanhee Hospital', 'healthcare', 40, true),
        (property_listing_id, 'โรงพยาบาลบางกรวย', 'Bang Kruai Hospital', 'healthcare', 50, true),
        (property_listing_id, 'มหาวิทยาลัยเทคโนโลยีพระจอมเกล้าพระนครเหนือ', 'King Mongkut''s University of Technology North Bangkok', 'education', 60, true),
        (property_listing_id, 'เกทเวย์ แอท บางซื่อ', 'Gateway at Bangsue', 'shopping', 70, true),
        (property_listing_id, 'เซ็นทรัล ปิ่นเกล้า', 'Central Pinklao', 'shopping', 80, true)
    ON CONFLICT (listing_id, place_name_th) DO UPDATE SET
        place_name_en = EXCLUDED.place_name_en,
        place_type_code = EXCLUDED.place_type_code,
        sort_order = EXCLUDED.sort_order,
        is_highlight = EXCLUDED.is_highlight,
        updated_at = now();

    DELETE FROM public.listing_media
    WHERE listing_id = property_listing_id
      AND source_type = 'editorial_import';

    INSERT INTO public.listing_media (
        listing_id, media_type, source_type, role_code, title, alt_text,
        original_url, file_url, mime_type, file_size_bytes, width, height,
        sort_order, is_primary, is_active
    ) VALUES
        (property_listing_id, 'image', 'editorial_import', 'cover', 'หน้าบ้าน', 'บ้านเดี่ยว 2 ชั้น หมู่บ้านนิมิตรา บางกรวย', 'https://media.kkpfg.com/npa/property/LV2136230/001.jpeg', '/listing-media/nick-property/lv2136230/001.webp', 'image/webp', 96076, 1000, 666, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ถนนหน้าบ้าน', 'บ้านเดี่ยวและถนนภายในหมู่บ้านนิมิตรา', 'https://media.kkpfg.com/npa/property/LV2136230/002.jpeg', '/listing-media/nick-property/lv2136230/002.webp', 'image/webp', 94004, 1000, 666, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ที่จอดรถหน้าบ้าน', 'พื้นที่จอดรถในร่มบริเวณหน้าบ้าน', 'https://media.kkpfg.com/npa/property/LV2136230/004.jpeg', '/listing-media/nick-property/lv2136230/004.webp', 'image/webp', 114054, 1000, 666, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ข้างบ้าน', 'พื้นที่พักผ่อนและสวนขนาดเล็กข้างบ้าน', 'https://media.kkpfg.com/npa/property/LV2136230/005.jpeg', '/listing-media/nick-property/lv2136230/005.webp', 'image/webp', 136760, 1000, 666, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'เฉลียงหน้าบ้าน', 'เฉลียงและทางเข้าบ้านพร้อมหลังคาคลุม', 'https://media.kkpfg.com/npa/property/LV2136230/006.jpeg', '/listing-media/nick-property/lv2136230/006.webp', 'image/webp', 102010, 1000, 666, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนั่งเล่น', 'ห้องนั่งเล่นชั้นล่างและบันไดขึ้นชั้นสอง', 'https://media.kkpfg.com/npa/property/LV2136230/007.jpeg', '/listing-media/nick-property/lv2136230/007.webp', 'image/webp', 73724, 1000, 666, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ใช้งานชั้นล่าง', 'พื้นที่อเนกประสงค์ภายในชั้นล่าง', 'https://media.kkpfg.com/npa/property/LV2136230/008.jpeg', '/listing-media/nick-property/lv2136230/008.webp', 'image/webp', 56684, 1000, 666, 70, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำชั้นล่าง', 'ห้องน้ำพร้อมพื้นที่อาบน้ำชั้นล่าง', 'https://media.kkpfg.com/npa/property/LV2136230/009.jpeg', '/listing-media/nick-property/lv2136230/009.webp', 'image/webp', 33702, 1000, 666, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องครัว', 'ห้องครัวแยกพร้อมเคาน์เตอร์และหน้าต่าง', 'https://media.kkpfg.com/npa/property/LV2136230/010.jpeg', '/listing-media/nick-property/lv2136230/010.webp', 'image/webp', 46498, 1000, 666, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงชั้นล่าง', 'โถงภายในบ้านเชื่อมพื้นที่นั่งเล่นและรับประทานอาหาร', 'https://media.kkpfg.com/npa/property/LV2136230/011.jpeg', '/listing-media/nick-property/lv2136230/011.webp', 'image/webp', 59460, 1000, 666, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'มุมรับประทานอาหาร', 'พื้นที่รับประทานอาหารภายในชั้นล่าง', 'https://media.kkpfg.com/npa/property/LV2136230/012.jpeg', '/listing-media/nick-property/lv2136230/012.webp', 'image/webp', 62748, 1000, 666, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนั่งเล่นอีกมุม', 'มุมมองห้องนั่งเล่นและบันไดภายในบ้าน', 'https://media.kkpfg.com/npa/property/LV2136230/013.jpeg', '/listing-media/nick-property/lv2136230/013.webp', 'image/webp', 58196, 1000, 666, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำชั้นสอง', 'ห้องน้ำชั้นสองพร้อมพื้นที่อาบน้ำ', 'https://media.kkpfg.com/npa/property/LV2136230/014.jpeg', '/listing-media/nick-property/lv2136230/014.webp', 'image/webp', 36396, 1000, 666, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำอีกมุม', 'สุขภัณฑ์และหน้าต่างภายในห้องน้ำ', 'https://media.kkpfg.com/npa/property/LV2136230/015.jpeg', '/listing-media/nick-property/lv2136230/015.webp', 'image/webp', 30288, 1000, 666, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอน', 'ห้องนอนพื้นไม้พร้อมหน้าต่างรับแสง', 'https://media.kkpfg.com/npa/property/LV2136230/017.jpeg', '/listing-media/nick-property/lv2136230/017.webp', 'image/webp', 75144, 1000, 666, 150, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนพร้อมตู้บิลต์อิน', 'ห้องนอนติดเครื่องปรับอากาศและตู้เสื้อผ้าบิลต์อิน', 'https://media.kkpfg.com/npa/property/LV2136230/019.jpeg', '/listing-media/nick-property/lv2136230/019.webp', 'image/webp', 57516, 1000, 666, 160, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่แต่งตัว', 'ตู้เสื้อผ้าและพื้นที่แต่งตัวภายในห้องนอน', 'https://media.kkpfg.com/npa/property/LV2136230/020.jpeg', '/listing-media/nick-property/lv2136230/020.webp', 'image/webp', 69420, 1000, 666, 170, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนอีกมุม', 'มุมมองเตียงและตู้เก็บของภายในห้องนอน', 'https://media.kkpfg.com/npa/property/LV2136230/021.jpeg', '/listing-media/nick-property/lv2136230/021.webp', 'image/webp', 54540, 1000, 666, 180, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บันไดภายในบ้าน', 'บันไดเชื่อมระหว่างชั้นของบ้านเดี่ยว', 'https://media.kkpfg.com/npa/property/LV2136230/022.jpeg', '/listing-media/nick-property/lv2136230/022.webp', 'image/webp', 29822, 1000, 666, 190, false, true);

    IF NOT EXISTS (
        SELECT 1
        FROM public.listing_sources
        WHERE listing_id = property_listing_id
          AND source_url = 'https://kkppropify.kkpfg.com/th/products/lv2136230'
    ) THEN
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
            'KKPPropify',
            'https://kkppropify.kkpfg.com/th/products/lv2136230',
            'LV2136230',
            '2026-09-08 00:00:00+07',
            'Imported from the public source listing. Nick Property is the verified publisher and owner-appointed sales representative. Administrator-supplied coordinates override source map coordinates. The listing belongs to the established Nimittra housing estate; no developer is asserted. MapxProp stores optimized copies of the 19 available source images without adding a MapxProp watermark.'
        );
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM public.organization_verifications
        WHERE organization_id = nick_organization_id
          AND verification_type = 'listing_authority'
          AND status = 'verified'
          AND source_url = 'https://kkppropify.kkpfg.com/th/products/lv2136230'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            nick_organization_id,
            'listing_authority',
            'verified',
            'https://kkppropify.kkpfg.com/th/products/lv2136230',
            'The source listing identifies Nick Property as its verified sales representative, consistent with the matching agent advertisement and administrator direction.',
            admin_user_id,
            now()
        );
    END IF;

    INSERT INTO public.organization_audit_logs (
        organization_id, actor_user_id, action_code,
        entity_type, entity_public_id, metadata
    ) VALUES
        (
            nick_organization_id,
            admin_user_id,
            'organization.verified',
            'organization',
            'e1d00f74-fa64-41f0-ad14-4097770bd03b',
            jsonb_build_object('verification_scope', 'publisher_identity_and_contacts')
        ),
        (
            nick_organization_id,
            admin_user_id,
            'listing.publisher_verified',
            'listing',
            '7cf34aa7-5381-4233-8fac-712e74b3f8c6',
            jsonb_build_object('reference_code', 'LV2136230')
        );
END $$;

COMMIT;
