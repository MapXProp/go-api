BEGIN;

-- "Contact organizer" describes how the price is shown, not the legal offer.
-- Keep temporary spaces on the same three offers as other retail spaces and
-- represent private quotes with price_on_request.
ALTER TABLE public.listing_offers
    DROP CONSTRAINT IF EXISTS listing_offers_offer_type_check;

ALTER TABLE public.discovery_channel_property_types
    DROP CONSTRAINT IF EXISTS discovery_channel_property_types_allowed_offer_types_check;

CREATE TEMP TABLE migration_temporary_space_price_on_request
ON COMMIT DROP
AS
SELECT DISTINCT l.id
FROM public.listings l
LEFT JOIN public.listing_offers lo ON lo.listing_id = l.id
WHERE l.listing_type IN ('event_booking', 'contact_organizer')
   OR lo.offer_type IN ('event_booking', 'contact_organizer')
   OR l.slug IN (
        'food-o-clock-the-empire-tower-2026',
        'local-favorites-emsphere-2026'
   );

DELETE FROM public.listing_offers lo
USING migration_temporary_space_price_on_request migrated
WHERE lo.listing_id = migrated.id
  AND lo.offer_type IN ('event_booking', 'contact_organizer');

INSERT INTO public.listing_offers (
    listing_id,
    offer_type,
    amount,
    price_unit,
    currency_code,
    minimum_contract_months,
    service_fee_monthly,
    is_negotiable
)
SELECT id, 'rent', NULL, 'event_period', 'THB', NULL, NULL, false
FROM migration_temporary_space_price_on_request
ON CONFLICT (listing_id, offer_type) DO UPDATE SET
    amount = NULL,
    price_unit = 'event_period',
    minimum_contract_months = NULL,
    service_fee_monthly = NULL,
    is_negotiable = false,
    updated_at = now();

UPDATE public.listings l
SET
    listing_type = 'rent',
    sale_price = NULL,
    rent_price_monthly = NULL,
    rent_price_daily = NULL,
    price_negotiable = false,
    minimum_lease_months = NULL,
    key_money_amount = NULL,
    service_fee_monthly = NULL,
    price_unit = 'event_period',
    title = CASE l.slug
        WHEN 'food-o-clock-the-empire-tower-2026'
            THEN 'เปิดจองบูธงาน FOOD O''CLOCK ที่ The Empire Tower ชั้น M'
        WHEN 'local-favorites-emsphere-2026'
            THEN 'เปิดจองบูธงาน LOCAL FAVORITES ที่ EMSPHERE ชั้น G'
        ELSE l.title
    END,
    description = replace(l.description, 'โดยตรงโดยตรง', 'โดยตรง'),
    updated_at = now()
FROM migration_temporary_space_price_on_request migrated
WHERE l.id = migrated.id;

INSERT INTO public.listing_category_details (
    listing_id,
    category_code,
    schema_version,
    details,
    is_minimum_submission
)
SELECT
    l.id,
    l.property_type_code,
    1,
    jsonb_build_object(
        'price_on_request', true,
        'temporary_space_pricing_mode', 'contact_organizer'
    ),
    true
FROM public.listings l
JOIN migration_temporary_space_price_on_request migrated ON migrated.id = l.id
ON CONFLICT (listing_id) DO UPDATE SET
    details = (public.listing_category_details.details - 'temporary_space_duration_days') || jsonb_build_object(
        'price_on_request', true,
        'temporary_space_pricing_mode', 'contact_organizer'
    ),
    updated_at = now();

UPDATE public.listing_event_details led
SET
    price_on_request = true,
    updated_at = now()
FROM migration_temporary_space_price_on_request migrated
WHERE led.listing_id = migrated.id;

UPDATE public.listing_event_rounds ler
SET
    price_amount = NULL,
    price_unit = 'event_round',
    updated_at = now()
FROM migration_temporary_space_price_on_request migrated
WHERE ler.listing_id = migrated.id;

UPDATE public.discovery_channel_property_types
SET
    allowed_offer_types = array_remove(array_remove(allowed_offer_types, 'contact_organizer'), 'event_booking'),
    updated_at = now()
WHERE allowed_offer_types && ARRAY['contact_organizer', 'event_booking']::text[];

UPDATE public.discovery_channel_property_types
SET
    allowed_offer_types = ARRAY['rent', 'sublease', 'business_transfer'],
    updated_at = now()
WHERE channel_code = 'business'
  AND property_type_code = 'retail_space';

DELETE FROM public.search_aliases
WHERE intent_type = 'offer_type'
  AND intent_value = 'contact_organizer';

ALTER TABLE public.listing_offers
    ADD CONSTRAINT listing_offers_offer_type_check
    CHECK (offer_type IN ('sale', 'rent', 'sublease', 'business_transfer'));

ALTER TABLE public.discovery_channel_property_types
    ADD CONSTRAINT discovery_channel_property_types_allowed_offer_types_check
    CHECK (allowed_offer_types <@ ARRAY['sale', 'rent', 'sublease', 'business_transfer']::text[]);

DO $$
DECLARE
    corrected_count integer;
BEGIN
    SELECT count(*)
    INTO corrected_count
    FROM public.listings l
    JOIN public.listing_offers lo ON lo.listing_id = l.id
    JOIN public.listing_category_details lcd ON lcd.listing_id = l.id
    WHERE l.slug IN (
        'food-o-clock-the-empire-tower-2026',
        'local-favorites-emsphere-2026'
    )
      AND l.listing_type = 'rent'
      AND l.price_unit = 'event_period'
      AND lo.offer_type = 'rent'
      AND lo.amount IS NULL
      AND lo.price_unit = 'event_period'
      AND COALESCE((lcd.details->>'price_on_request')::boolean, false) = true
      AND lcd.details->>'temporary_space_pricing_mode' = 'contact_organizer';

    IF corrected_count <> 2 THEN
        RAISE EXCEPTION 'Expected both imported temporary-space listings to use rent with price on request, got %', corrected_count;
    END IF;

    IF EXISTS (
        SELECT 1 FROM public.listing_offers
        WHERE offer_type IN ('event_booking', 'contact_organizer')
    ) THEN
        RAISE EXCEPTION 'Legacy temporary-space offer types still exist';
    END IF;
END $$;

COMMIT;
