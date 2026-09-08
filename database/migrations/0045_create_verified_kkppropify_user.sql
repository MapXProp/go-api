BEGIN;

DO $$
DECLARE
    kkp_user_id bigint;
BEGIN
    SELECT id INTO kkp_user_id
    FROM public.auth_users
    WHERE lower(email) = 'kkpcontactcenter@kkpfg.com'
      AND deleted_at IS NULL
    ORDER BY id
    LIMIT 1;

    IF kkp_user_id IS NULL THEN
        INSERT INTO public.auth_users (
            public_user_id,
            email,
            name,
            surname,
            provider,
            is_active,
            is_verified,
            email_verified_at,
            role_code,
            updated_at
        ) VALUES (
            '045c139d-06e3-456a-b81d-12246745193b',
            'kkpcontactcenter@kkpfg.com',
            'KKPPropify',
            NULL,
            'email',
            true,
            true,
            now(),
            'member',
            now()
        )
        RETURNING id INTO kkp_user_id;
    ELSE
        UPDATE public.auth_users
        SET name = 'KKPPropify',
            is_active = true,
            is_verified = true,
            email_verified_at = COALESCE(email_verified_at, now()),
            updated_at = now()
        WHERE id = kkp_user_id;
    END IF;

    INSERT INTO public.user_listing_contact_profiles (
        user_id,
        contact_name,
        contact_phone,
        contact_phone_secondary,
        contact_email,
        line_id,
        instagram_handle,
        role_code,
        authority_source_code,
        organization_name,
        organization_registration_no
    ) VALUES (
        kkp_user_id,
        'KKPPropify',
        '021655577',
        '021655555',
        'kkpcontactcenter@kkpfg.com',
        '@kkpbank',
        NULL,
        'developer_investor_representative',
        'investor_asset_holder',
        'ธนาคารเกียรตินาคินภัทร จำกัด (มหาชน)',
        NULL
    )
    ON CONFLICT (user_id) DO UPDATE SET
        contact_name = EXCLUDED.contact_name,
        contact_phone = EXCLUDED.contact_phone,
        contact_phone_secondary = EXCLUDED.contact_phone_secondary,
        contact_email = EXCLUDED.contact_email,
        line_id = EXCLUDED.line_id,
        role_code = EXCLUDED.role_code,
        authority_source_code = EXCLUDED.authority_source_code,
        organization_name = EXCLUDED.organization_name,
        updated_at = now();
END $$;

COMMIT;
