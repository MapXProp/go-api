BEGIN;

CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX IF NOT EXISTS idx_location_provinces_name_th_trgm
    ON public.location_provinces USING gin (lower(name_th) gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_location_provinces_name_en_trgm
    ON public.location_provinces USING gin (lower(name_en) gin_trgm_ops);

CREATE INDEX IF NOT EXISTS idx_location_districts_name_th_trgm
    ON public.location_districts USING gin (lower(name_th) gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_location_districts_name_en_trgm
    ON public.location_districts USING gin (lower(name_en) gin_trgm_ops);

CREATE INDEX IF NOT EXISTS idx_location_subdistricts_name_th_trgm
    ON public.location_subdistricts USING gin (lower(name_th) gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_location_subdistricts_name_en_trgm
    ON public.location_subdistricts USING gin (lower(name_en) gin_trgm_ops);

COMMIT;
