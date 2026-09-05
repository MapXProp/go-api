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

    UPDATE public.listing_contact_profiles
    SET verification_status = 'authority_verified',
        verification_note = 'MapxProp confirmed the contact identity and authority to represent the property owner.',
        verified_at = now(),
        updated_at = now()
    WHERE listing_id = land_listing_id
      AND role_code = 'owner_representative'
      AND authority_source_code = 'property_owner'
      AND organization_name = 'KPG Business Co., Ltd.';

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Expected Sutthisan contact profile was not found';
    END IF;

    UPDATE public.listings
    SET is_verified = true,
        updated_at = now()
    WHERE id = land_listing_id;
END $$;

COMMIT;
