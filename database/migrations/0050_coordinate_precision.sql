BEGIN;

-- Eight decimal places are already finer than consumer GPS accuracy while
-- preserving coordinates pasted from map providers without visible drift.
ALTER TABLE public.listings
    ALTER COLUMN latitude TYPE numeric(10,8) USING latitude::numeric(10,8),
    ALTER COLUMN longitude TYPE numeric(11,8) USING longitude::numeric(11,8);

ALTER TABLE public.property_projects
    ALTER COLUMN latitude TYPE numeric(10,8) USING latitude::numeric(10,8),
    ALTER COLUMN longitude TYPE numeric(11,8) USING longitude::numeric(11,8);

ALTER TABLE public.listing_nearby_places
    ALTER COLUMN latitude TYPE numeric(10,8) USING latitude::numeric(10,8),
    ALTER COLUMN longitude TYPE numeric(11,8) USING longitude::numeric(11,8);

UPDATE public.listings
SET latitude = 13.73575135,
    longitude = 100.70620729,
    updated_at = now()
WHERE public_listing_id = '48fcbf20-7187-4a32-b683-c50f40db7f4d';

UPDATE public.property_projects
SET latitude = 13.73575135,
    longitude = 100.70620729,
    updated_at = now()
WHERE slug = 'the-connect-wongwaen-rama-9';

COMMENT ON COLUMN public.listings.latitude IS
    'WGS84 latitude rounded to 8 decimal places when persisted.';
COMMENT ON COLUMN public.listings.longitude IS
    'WGS84 longitude rounded to 8 decimal places when persisted.';

COMMIT;
