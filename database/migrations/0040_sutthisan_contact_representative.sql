BEGIN;

DO $$
DECLARE
    land_listing_id bigint;
BEGIN
    SELECT id INTO land_listing_id
    FROM public.listings
    WHERE public_listing_id::text = '4eedd824-1c3d-4f39-b076-74ec5d72452b'
      AND slug = 'land-for-sale-sutthisan-700-sq-wah'
    LIMIT 1;

    IF land_listing_id IS NULL THEN
        RAISE EXCEPTION 'Sutthisan 700 square wah listing was not found';
    END IF;

    INSERT INTO public.listing_contact_profiles (
        listing_id,
        role_code,
        authority_source_code,
        organization_name,
        verification_status
    ) VALUES (
        land_listing_id,
        'owner_representative',
        'property_owner',
        'KPG Business Co., Ltd.',
        'unverified'
    )
    ON CONFLICT (listing_id) DO UPDATE SET
        role_code = EXCLUDED.role_code,
        authority_source_code = EXCLUDED.authority_source_code,
        organization_name = EXCLUDED.organization_name,
        updated_at = now();

    UPDATE public.listing_category_details
    SET details = details - 'seller_type' - 'contact_trust_status',
        updated_at = now()
    WHERE listing_id = land_listing_id;

    UPDATE public.listings
    SET updated_at = now()
    WHERE id = land_listing_id;
END $$;

COMMIT;
