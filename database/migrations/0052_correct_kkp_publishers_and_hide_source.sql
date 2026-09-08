BEGIN;

-- KKPPropify is the import platform, not the publisher organization for every
-- listing carried by that platform. Keep provenance in listing_sources, while
-- assigning each listing to the company named as its property consultant.
DO $$
DECLARE
    admin_user_id bigint;
    kkp_user_id bigint;
    kkp_organization_id bigint;
    juzzmatch_organization_id bigint;
    aspire_organization_id bigint;
    b0783_listing_id bigint;
    tp2206058_listing_id bigint;
BEGIN
    SELECT id INTO admin_user_id
    FROM public.auth_users
    WHERE lower(email) = 'mapxprop@gmail.com'
      AND deleted_at IS NULL
    ORDER BY id
    LIMIT 1;

    IF admin_user_id IS NULL THEN
        RAISE EXCEPTION 'MapxProp super admin is required to verify imported publishers';
    END IF;

    SELECT id INTO kkp_user_id
    FROM public.auth_users
    WHERE public_user_id = '045c139d-06e3-456a-b81d-12246745193b'
    LIMIT 1;

    SELECT id INTO kkp_organization_id
    FROM public.organizations
    WHERE slug = 'kkppropify'
    LIMIT 1;

    INSERT INTO public.organizations (
        public_organization_id,
        slug,
        display_name,
        legal_name,
        organization_type,
        verification_status,
        verification_note,
        verified_at,
        verified_by_user_id,
        created_by_user_id,
        is_active
    ) VALUES (
        '21d3a5f7-0a40-4b75-a338-5d8c07edc077',
        'juzzmatch',
        'บริษัท จัซแมทช์ จำกัด',
        'บริษัท จัซแมทช์ จำกัด',
        'agency',
        'verified',
        'MapxProp administrator verified the publisher shown for listing B-0783.',
        now(),
        admin_user_id,
        admin_user_id,
        true
    )
    ON CONFLICT (slug) DO UPDATE SET
        display_name = EXCLUDED.display_name,
        legal_name = EXCLUDED.legal_name,
        organization_type = EXCLUDED.organization_type,
        verification_status = 'verified',
        verification_note = EXCLUDED.verification_note,
        verified_at = COALESCE(public.organizations.verified_at, now()),
        verified_by_user_id = EXCLUDED.verified_by_user_id,
        is_active = true,
        deleted_at = NULL,
        updated_at = now()
    RETURNING id INTO juzzmatch_organization_id;

    INSERT INTO public.organizations (
        public_organization_id,
        slug,
        display_name,
        organization_type,
        verification_status,
        verification_note,
        verified_at,
        verified_by_user_id,
        created_by_user_id,
        is_active
    ) VALUES (
        '02f53f37-a92e-491c-b8b8-d8fc6a998d8f',
        'aspire-real-estate-agency',
        'Aspire Real Estate Agency',
        'agency',
        'verified',
        'MapxProp administrator verified the publisher shown for listing TP2206058.',
        now(),
        admin_user_id,
        admin_user_id,
        true
    )
    ON CONFLICT (slug) DO UPDATE SET
        display_name = EXCLUDED.display_name,
        organization_type = EXCLUDED.organization_type,
        verification_status = 'verified',
        verification_note = EXCLUDED.verification_note,
        verified_at = COALESCE(public.organizations.verified_at, now()),
        verified_by_user_id = EXCLUDED.verified_by_user_id,
        is_active = true,
        deleted_at = NULL,
        updated_at = now()
    RETURNING id INTO aspire_organization_id;

    INSERT INTO public.organization_specialties (organization_id, specialty_code)
    VALUES
        (juzzmatch_organization_id, 'sale'),
        (juzzmatch_organization_id, 'house'),
        (aspire_organization_id, 'sale'),
        (aspire_organization_id, 'house')
    ON CONFLICT (organization_id, specialty_code) DO NOTHING;

    INSERT INTO public.organization_contacts (
        organization_id, channel_type, channel_value, label,
        is_primary, is_public, is_verified, verified_at
    ) VALUES (
        juzzmatch_organization_id,
        'phone',
        '024954506',
        'ติดต่อบริษัท',
        true,
        true,
        true,
        now()
    )
    ON CONFLICT (organization_id, channel_type, channel_value) DO UPDATE SET
        label = EXCLUDED.label,
        is_primary = true,
        is_public = true,
        is_verified = true,
        verified_at = COALESCE(public.organization_contacts.verified_at, now()),
        updated_at = now();

    SELECT id INTO b0783_listing_id
    FROM public.listings
    WHERE slug = 'townhouse-the-connect-wongwaen-rama-9-b-0783'
    LIMIT 1;

    SELECT id INTO tp2206058_listing_id
    FROM public.listings
    WHERE slug = 'house-casa-legend-ratchapruek-tp2206058'
    LIMIT 1;

    IF b0783_listing_id IS NULL OR tp2206058_listing_id IS NULL THEN
        RAISE EXCEPTION 'Both imported KKP listings are required before correcting their publishers';
    END IF;

    UPDATE public.listings
    SET user_id = admin_user_id,
        organization_id = juzzmatch_organization_id,
        created_by_user_id = admin_user_id,
        published_by_user_id = admin_user_id,
        contact_name = 'บริษัท จัซแมทช์ จำกัด',
        description = E'ทาวน์โฮมในโครงการเดอะ คอนเนค วงแหวน-พระราม 9 เนื้อที่ 18.2 ตร.ว. 3 ห้องนอน 3 ห้องน้ำ\n\nบ้านว่าง ภายในโทนสว่าง มีพื้นที่จอดรถหน้าบ้าน เหมาะสำหรับอยู่อาศัย ใกล้เส้นทางวงแหวนและพระราม 9\n\nราคาพิเศษ 3,168,000 บาท จากราคาประกาศเดิม 3,300,000 บาท\n\nติดต่อบริษัท จัซแมทช์ จำกัด โทร. 02-495-4506 รหัสทรัพย์ B-0783\n\nผู้ซื้อควรตรวจสอบสภาพทรัพย์ เอกสารสิทธิ์ ค่าใช้จ่าย และเงื่อนไขกับผู้ดูแลก่อนตัดสินใจ',
        is_verified = true,
        updated_at = now()
    WHERE id = b0783_listing_id;

    UPDATE public.listings
    SET user_id = admin_user_id,
        organization_id = aspire_organization_id,
        created_by_user_id = admin_user_id,
        published_by_user_id = admin_user_id,
        contact_name = 'Aspire Real Estate Agency',
        description = E'บ้านเดี่ยวในโครงการคาซ่า เลเจ้นด์ ราชพฤกษ์-ปิ่นเกล้า บ้านเลขที่ 189/10 ซอย 1\n\nเนื้อที่ 50.6 ตร.ว. 3 ห้องนอน 3 ห้องน้ำ มีพื้นที่สำหรับสัตว์เลี้ยง ทำเลถนนราชพฤกษ์–พระราม 5 เขตตลิ่งชัน\n\nราคา 8,900,000 บาท\n\nเสนอขายโดย Aspire Real Estate Agency รหัสทรัพย์ TP2206058\n\nผู้ซื้อควรตรวจสอบสภาพทรัพย์ เอกสารสิทธิ์ ค่าใช้จ่าย และเงื่อนไขกับผู้ดูแลก่อนตัดสินใจ',
        is_verified = true,
        updated_at = now()
    WHERE id = tp2206058_listing_id;

    UPDATE public.listing_contact_profiles
    SET organization_name = 'บริษัท จัซแมทช์ จำกัด',
        verification_status = 'authority_verified',
        verification_note = 'MapxProp administrator verified this company as the publisher for listing B-0783.',
        verified_at = now(),
        verified_by_user_id = admin_user_id,
        organization_id = juzzmatch_organization_id,
        contact_user_id = NULL,
        updated_at = now()
    WHERE listing_id = b0783_listing_id;

    UPDATE public.listing_contact_profiles
    SET organization_name = 'Aspire Real Estate Agency',
        verification_status = 'authority_verified',
        verification_note = 'MapxProp administrator verified this company as the publisher for listing TP2206058.',
        verified_at = now(),
        verified_by_user_id = admin_user_id,
        organization_id = aspire_organization_id,
        contact_user_id = NULL,
        updated_at = now()
    WHERE listing_id = tp2206058_listing_id;

    UPDATE public.listing_category_details
    SET details = details - ARRAY[
            'source_property_id',
            'source_posted_on',
            'source_content_id',
            'source_agent_code',
            'source_agent_name',
            'source_agent_verified',
            'source_is_npa',
            'data_provenance'
        ]::text[],
        updated_at = now()
    WHERE listing_id IN (b0783_listing_id, tp2206058_listing_id);

    UPDATE public.property_projects
    SET metadata = metadata - 'source_reference',
        updated_at = now()
    WHERE slug IN (
        'the-connect-wongwaen-rama-9',
        'casa-legend-ratchaphruek-pinklao'
    );

    IF NOT EXISTS (
        SELECT 1
        FROM public.organization_verifications
        WHERE organization_id = juzzmatch_organization_id
          AND verification_type = 'listing_authority'
          AND status = 'verified'
          AND source_url = 'https://kkppropify.kkpfg.com/th/products/b-0783'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            juzzmatch_organization_id,
            'listing_authority',
            'verified',
            'https://kkppropify.kkpfg.com/th/products/b-0783',
            'The listing identifies Juzzmatch Co., Ltd. as its verified property consultant; MapxProp administrator approved the publisher.',
            admin_user_id,
            now()
        );
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM public.organization_verifications
        WHERE organization_id = aspire_organization_id
          AND verification_type = 'listing_authority'
          AND status = 'verified'
          AND source_url = 'https://kkppropify.kkpfg.com/th/products/tp2206058'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id, verification_type, status, source_url,
            evidence_note, reviewed_by_user_id, reviewed_at
        ) VALUES (
            aspire_organization_id,
            'listing_authority',
            'verified',
            'https://kkppropify.kkpfg.com/th/products/tp2206058',
            'The listing identifies Aspire Real Estate Agency as its verified property consultant; MapxProp administrator approved the publisher.',
            admin_user_id,
            now()
        );
    END IF;

    INSERT INTO public.organization_audit_logs (
        organization_id, actor_user_id, action_code,
        entity_type, entity_public_id, metadata
    ) VALUES
        (
            juzzmatch_organization_id,
            admin_user_id,
            'listing.publisher_verified',
            'listing',
            '48fcbf20-7187-4a32-b683-c50f40db7f4d',
            jsonb_build_object('reference_code', 'B-0783')
        ),
        (
            aspire_organization_id,
            admin_user_id,
            'listing.publisher_verified',
            'listing',
            'cf1948bc-c487-4ffe-9b76-b39a2951b69c',
            jsonb_build_object('reference_code', 'TP2206058')
        );

    -- The mistaken KKPPropify organization and claim account were created by
    -- MapxProp migrations. Retire them after the affected listings have moved;
    -- provenance remains in listing_sources for administrators.
    IF kkp_organization_id IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM public.listings WHERE organization_id = kkp_organization_id
    ) THEN
        UPDATE public.organizations
        SET is_active = false,
            deleted_at = COALESCE(deleted_at, now()),
            updated_at = now()
        WHERE id = kkp_organization_id;
    END IF;

    IF kkp_user_id IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM public.listings WHERE user_id = kkp_user_id
    ) THEN
        UPDATE public.auth_users
        SET is_active = false,
            deleted_at = COALESCE(deleted_at, now()),
            updated_at = now()
        WHERE id = kkp_user_id;
    END IF;
END $$;

COMMIT;
