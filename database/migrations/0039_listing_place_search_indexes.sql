BEGIN;

CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX IF NOT EXISTS idx_listings_custom_project_name_trgm
    ON public.listings USING gin (lower(custom_project_name) gin_trgm_ops)
    WHERE custom_project_name IS NOT NULL AND custom_project_name <> '';

CREATE INDEX IF NOT EXISTS idx_listings_custom_building_name_trgm
    ON public.listings USING gin (lower(custom_building_name) gin_trgm_ops)
    WHERE custom_building_name IS NOT NULL AND custom_building_name <> '';

COMMIT;
