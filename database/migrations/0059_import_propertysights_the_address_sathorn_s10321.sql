BEGIN;

DO $$
DECLARE
    admin_user_id bigint;
    propertysights_organization_id bigint;
    address_sathorn_project_id bigint;
    property_listing_id bigint;
BEGIN
    SELECT id INTO admin_user_id
    FROM public.auth_users
    WHERE lower(email) = 'mapxprop@gmail.com'
      AND deleted_at IS NULL
    ORDER BY id
    LIMIT 1;

    IF admin_user_id IS NULL THEN
        RAISE EXCEPTION 'MapxProp super admin is required to import listing S10321';
    END IF;

    SELECT id INTO propertysights_organization_id
    FROM public.organizations
    WHERE slug = 'propertysights-real-estate'
      AND deleted_at IS NULL
    ORDER BY id
    LIMIT 1;

    IF propertysights_organization_id IS NULL THEN
        RAISE EXCEPTION 'Verified PropertySights Real Estate organization is required to import listing S10321';
    END IF;

    SELECT id INTO address_sathorn_project_id
    FROM public.property_projects
    WHERE slug = 'the-address-sathorn'
      AND deleted_at IS NULL
    ORDER BY id
    LIMIT 1;

    IF address_sathorn_project_id IS NULL THEN
        RAISE EXCEPTION 'The Address Sathorn project is required to import listing S10321';
    END IF;

    UPDATE public.organizations
    SET verification_status = 'verified',
        verification_note = 'MapxProp administrator verified PropertySights Real Estate and its listing authority for properties 10024893, 60197196, and S10321.',
        verified_at = COALESCE(verified_at, now()),
        verified_by_user_id = admin_user_id,
        is_active = true,
        deleted_at = NULL,
        updated_at = now()
    WHERE id = propertysights_organization_id;

    UPDATE public.property_projects
    SET latitude = 13.72262800,
        longitude = 100.52517653,
        is_active = true,
        deleted_at = NULL,
        updated_at = now()
    WHERE id = address_sathorn_project_id;

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
        usable_area_sqm,
        bedroom_count,
        bathroom_count,
        furnishing_status,
        total_floors,
        contact_name,
        contact_phone,
        contact_email,
        instagram_handle,
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
        '103c0b40-ffb9-4e84-9694-d90874d90cd9',
        admin_user_id,
        propertysights_organization_id,
        admin_user_id,
        admin_user_id,
        address_sathorn_project_id,
        'condo',
        'residence',
        'sale',
        'single_unit',
        'ดิ แอดเดรส สาทร',
        'ขายคอนโด The Address Sathorn ชั้นสูง 1 ห้องนอน 46 ตร.ม. ราคา 7.92 ล้านบาท',
        E'คอนโดพร้อมอยู่ชั้นสูง The Address Sathorn ขนาด 46 ตร.ม. 1 ห้องนอน 1 ห้องน้ำ พร้อมเฟอร์นิเจอร์\n\nห้องตกแต่งสไตล์โมเดิร์นโทนอุ่น พื้นไม้ ห้องนั่งเล่นรับแสงธรรมชาติ พร้อมวิวเมืองและพื้นที่สีเขียว มีมุมรับประทานอาหาร ครัว ห้องนอน และห้องน้ำพร้อมอ่างอาบน้ำกับพื้นที่อาบน้ำแยกส่วน\n\nทำเลซอยสาทร 12 ใกล้ BTS เซนต์หลุยส์ประมาณ 200 เมตร เดินทางสะดวกสู่ย่านสาทร–สีลม\n\nราคาขาย 7,920,000 บาท\n\nติดต่อ PropertySights Real Estate โทร. 095-517-9606 รหัสทรัพย์ S10321\n\nผู้ซื้อควรตรวจสอบสภาพทรัพย์ เอกสารสิทธิ์ ค่าใช้จ่าย และเงื่อนไขกับผู้ดูแลก่อนตัดสินใจ',
        7920000,
        false,
        46,
        1,
        1,
        'fully_furnished',
        40,
        'PropertySights Real Estate',
        '0955179606',
        'hello@propertysights.com',
        'propertysights88',
        true,
        true,
        '98 ซอยสาทร 12',
        'โครงการดิ แอดเดรส สาทร',
        'ถนนสาทรเหนือ',
        '10500',
        13.72262800,
        100.52517653,
        'กรุงเทพมหานคร',
        'บางรัก',
        'สีลม',
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
        'condo-the-address-sathorn-s10321'
    )
    RETURNING id INTO property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 7920000, 'total', 'THB', false
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
        'condo',
        1,
        jsonb_build_object(
            'unit_area_sqm', 46,
            'bedroom_count', 1,
            'bathroom_count', 1,
            'price_per_sqm', 172174,
            'project_completion_year', 2012,
            'project_total_floors', 40,
            'project_total_units', 562,
            'tenure', 'freehold',
            'floor_position', 'high_floor',
            'furnishing_status', 'fully_furnished'
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
        'PropertySights Real Estate',
        'authority_verified',
        'The public property record identifies PropertySights Real Estate as the verified representative for listing S10321.',
        now(),
        admin_user_id,
        propertysights_organization_id,
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
        (property_listing_id, 'elevator'),
        (property_listing_id, 'fitness'),
        (property_listing_id, 'garden'),
        (property_listing_id, 'parking'),
        (property_listing_id, 'sauna'),
        (property_listing_id, 'security'),
        (property_listing_id, 'swimming_pool')
    ON CONFLICT (listing_id, amenity_code) DO NOTHING;

    INSERT INTO public.listing_nearby_places (
        listing_id, place_name_th, place_name_en, place_type_code,
        distance_meters, sort_order, is_highlight
    ) VALUES
        (property_listing_id, 'BTS เซนต์หลุยส์', 'BTS Saint Louis', 'transit', 200, 10, true),
        (property_listing_id, 'ย่านธุรกิจสาทร–สีลม', 'Sathorn–Silom CBD', 'landmark', 300, 20, true)
    ON CONFLICT (listing_id, place_name_th) DO UPDATE SET
        place_name_en = EXCLUDED.place_name_en,
        place_type_code = EXCLUDED.place_type_code,
        distance_meters = EXCLUDED.distance_meters,
        sort_order = EXCLUDED.sort_order,
        is_highlight = EXCLUDED.is_highlight,
        updated_at = now();

    INSERT INTO public.listing_media (
        listing_id, media_type, source_type, role_code, title, alt_text,
        original_url, file_url, mime_type, file_size_bytes, width, height,
        sort_order, is_primary, is_active
    ) VALUES
        (property_listing_id, 'image', 'editorial_import', 'cover', 'ห้องนั่งเล่นและวิวเมือง', 'ห้องนั่งเล่นคอนโด The Address Sathorn พร้อมระเบียงและวิวเมือง', 'https://media.kkpfg.com/npa/property/s10321/01.jpeg', '/listing-media/propertysights/s10321/01.webp', 'image/webp', 75230, 910, 600, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่นั่งเล่นและรับประทานอาหาร', 'พื้นที่นั่งเล่นพร้อมโซฟาและมุมรับประทานอาหาร', 'https://media.kkpfg.com/npa/property/s10321/02.jpeg', '/listing-media/propertysights/s10321/02.webp', 'image/webp', 87280, 910, 600, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ครัวและมุมรับประทานอาหาร', 'ครัวพร้อมตู้บิลต์อินและมุมรับประทานอาหารภายในห้อง', 'https://media.kkpfg.com/npa/property/s10321/03.jpeg', '/listing-media/propertysights/s10321/03.webp', 'image/webp', 47096, 910, 600, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนพร้อมวิวเมือง', 'ห้องนอนคอนโด The Address Sathorn พร้อมหน้าต่างรับวิว', 'https://media.kkpfg.com/npa/property/s10321/04.jpeg', '/listing-media/propertysights/s10321/04.webp', 'image/webp', 93426, 910, 600, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนและห้องน้ำ', 'ห้องนอนเชื่อมต่อห้องน้ำกระจกพร้อมอ่างอาบน้ำ', 'https://media.kkpfg.com/npa/property/s10321/05.jpeg', '/listing-media/propertysights/s10321/05.webp', 'image/webp', 83422, 910, 600, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำพร้อมอ่างอาบน้ำ', 'ห้องน้ำพร้อมอ่างอาบน้ำ อ่างล้างหน้า และพื้นที่อาบน้ำแยกส่วน', 'https://media.kkpfg.com/npa/property/s10321/06.jpeg', '/listing-media/propertysights/s10321/06.webp', 'image/webp', 81626, 910, 600, 60, false, true);

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
        'https://kkppropify.kkpfg.com/th/products/s10321',
        'S10321',
        '2026-09-08 00:00:00+07',
        'Imported from the public KKPPropify property record and cross-checked against the verified publisher listing. This is a separate unit in The Address Sathorn on the same high-floor position as the prior listing. PropertySights Real Estate is the listing representative. The existing project address and administrator-supplied coordinates are authoritative. MapxProp stores optimized copies of all six images available on the KKP property page and does not add an additional watermark.'
    );

    IF NOT EXISTS (
        SELECT 1
        FROM public.organization_verifications
        WHERE organization_id = propertysights_organization_id
          AND verification_type = 'listing_authority'
          AND status = 'verified'
          AND source_url = 'https://kkppropify.kkpfg.com/th/products/s10321'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            propertysights_organization_id,
            'listing_authority',
            'verified',
            'https://kkppropify.kkpfg.com/th/products/s10321',
            'The public property record identifies PropertySights Real Estate as the verified representative for listing S10321.',
            admin_user_id,
            now()
        );
    END IF;

    INSERT INTO public.organization_audit_logs (
        organization_id, actor_user_id, action_code,
        entity_type, entity_public_id, metadata
    ) VALUES (
        propertysights_organization_id,
        admin_user_id,
        'listing.publisher_verified',
        'listing',
        '103c0b40-ffb9-4e84-9694-d90874d90cd9',
        jsonb_build_object('reference_code', 'S10321')
    );
END $$;

COMMIT;
