-- Correct the map position for KKPPropify listing B-0783 and its project.
UPDATE public.listings
SET latitude = 13.7357514,
    longitude = 100.7062073,
    updated_at = now()
WHERE public_listing_id = '48fcbf20-7187-4a32-b683-c50f40db7f4d';

UPDATE public.property_projects
SET latitude = 13.7357514,
    longitude = 100.7062073,
    updated_at = now()
WHERE slug = 'the-connect-wongwaen-rama-9';
