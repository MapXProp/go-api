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

    UPDATE public.listing_offers
    SET is_negotiable = true,
        updated_at = now()
    WHERE listing_id = land_listing_id
      AND offer_type = 'sale';

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Sutthisan sale offer was not found';
    END IF;

    -- Keep the legacy listing field aligned with the canonical offer row.
    UPDATE public.listings
    SET price_negotiable = true,
        updated_at = now()
    WHERE id = land_listing_id;
END $$;

COMMIT;
