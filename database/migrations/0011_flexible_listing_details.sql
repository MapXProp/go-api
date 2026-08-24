BEGIN;

-- Core listing columns stay stable and searchable.  Fields that differ greatly
-- between a condo, a land plot, a market stall, or an event booth live here and
-- can evolve by schema_version without forcing every category into one form.
CREATE TABLE IF NOT EXISTS public.listing_category_details (
    listing_id bigint PRIMARY KEY REFERENCES public.listings(id) ON DELETE CASCADE,
    category_code varchar(80) NOT NULL,
    schema_version integer NOT NULL DEFAULT 1 CHECK (schema_version > 0),
    details jsonb NOT NULL DEFAULT '{}'::jsonb,
    is_minimum_submission boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_listing_category_details_category
    ON public.listing_category_details(category_code);

CREATE INDEX IF NOT EXISTS idx_listing_category_details_gin
    ON public.listing_category_details USING gin(details);

COMMIT;
