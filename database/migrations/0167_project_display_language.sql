BEGIN;

-- Choose the familiar public name without overwriting either searchable name.
ALTER TABLE public.property_projects
    ADD COLUMN IF NOT EXISTS display_name_language text NOT NULL DEFAULT 'en'
    CHECK (display_name_language IN ('th', 'en'));
ALTER TABLE public.listings
    ADD COLUMN IF NOT EXISTS custom_project_name_language text NOT NULL DEFAULT 'en'
    CHECK (custom_project_name_language IN ('th', 'en'));

CREATE OR REPLACE FUNCTION public.project_display_name(name_th text, name_en text, preferred_language text)
RETURNS text LANGUAGE sql IMMUTABLE PARALLEL SAFE AS $$
    SELECT CASE WHEN preferred_language = 'th'
        THEN COALESCE(NULLIF(trim(name_th), ''), NULLIF(trim(name_en), ''), '')
        ELSE COALESCE(NULLIF(trim(name_en), ''), NULLIF(trim(name_th), ''), '')
    END;
$$;

-- Local village names; developer brands, condos, malls and offices keep English.
UPDATE public.property_projects
SET display_name_language = 'th'
WHERE slug IN ('nimittra-bang-kruai', 'prathana-pluak-daeng', 'saptawee-village-pracha-uthit-90');

UPDATE public.listings
SET custom_project_name_language = 'th'
WHERE trim(custom_project_name) IN (
    'วังทองธานี', 'บ้านสวนสุวัฒนา เฟส 1', 'บ้านไทย', 'บ้านโนนสะอาด',
    'ภิรมย์สุข', 'หมู่บ้านพรทวีวัฒน์', 'หมู่บ้านอยู่เจริญ', 'พรรณทิวาวิลล่า',
    'บุญรักษา', 'สุเจริญป่าตอง', 'ทรัพย์แสนล้าน', 'ศรีราชานคร'
);

COMMIT;
