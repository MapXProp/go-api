BEGIN;

CREATE TABLE IF NOT EXISTS public.listing_amenities (
    listing_id bigint NOT NULL REFERENCES public.listings(id) ON DELETE CASCADE,
    amenity_code text NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (listing_id, amenity_code),
    CHECK (amenity_code ~ '^[a-z][a-z0-9_]*$')
);

CREATE INDEX IF NOT EXISTS idx_listing_amenities_search
    ON public.listing_amenities(amenity_code, listing_id);

ALTER TABLE public.listing_offers
    ADD COLUMN IF NOT EXISTS currency_code varchar(3);

UPDATE public.listing_offers
SET currency_code = 'THB'
WHERE currency_code IS NULL OR btrim(currency_code) = '';

ALTER TABLE public.listing_offers
    ALTER COLUMN currency_code SET DEFAULT 'THB',
    ALTER COLUMN currency_code SET NOT NULL;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'listing_offers_currency_code_check'
          AND conrelid = 'public.listing_offers'::regclass
    ) THEN
        ALTER TABLE public.listing_offers
            ADD CONSTRAINT listing_offers_currency_code_check
            CHECK (currency_code ~ '^[A-Z]{3}$');
    END IF;
END $$;

COMMIT;
