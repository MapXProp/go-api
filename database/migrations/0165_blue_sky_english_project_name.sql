BEGIN;

-- Imported while the English-name rollout was in progress.
UPDATE public.listings
SET custom_project_name_en = 'Blue Sky Patong Hotel'
WHERE slug = 'sam-blue-sky-patong-hotel-105-rooms-3a1407'
  AND custom_project_name = 'โรงแรมบลูสกาย ป่าตอง'
  AND trim(custom_project_name_en) = '';

COMMIT;
