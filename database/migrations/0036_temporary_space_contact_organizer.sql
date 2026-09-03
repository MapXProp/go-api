BEGIN;

-- Temporary spaces keep the normal priced offers (rent, sublease and
-- business transfer) and add a contact-only alternative. The retired
-- event_booking code is migrated to contact_organizer because it did not
-- distinguish a published fixed price from a private quote.
ALTER TABLE public.listing_offers
    DROP CONSTRAINT IF EXISTS listing_offers_offer_type_check;

ALTER TABLE public.discovery_channel_property_types
    DROP CONSTRAINT IF EXISTS discovery_channel_property_types_allowed_offer_types_check;

CREATE TEMP TABLE migration_contact_organizer_listings
ON COMMIT DROP
AS
SELECT DISTINCT l.id
FROM public.listings l
LEFT JOIN public.listing_offers lo ON lo.listing_id = l.id
WHERE l.listing_type = 'event_booking'
   OR lo.offer_type = 'event_booking'
   OR l.slug IN (
        'food-o-clock-the-empire-tower-2026',
        'local-favorites-emsphere-2026'
   );

DELETE FROM public.listing_offers lo
USING migration_contact_organizer_listings migrated
WHERE lo.listing_id = migrated.id;

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
SELECT id, 'contact_organizer', NULL, 'contact', 'THB', NULL, NULL, false
FROM migration_contact_organizer_listings
ON CONFLICT (listing_id, offer_type) DO UPDATE SET
    amount = NULL,
    price_unit = 'contact',
    minimum_contract_months = NULL,
    service_fee_monthly = NULL,
    is_negotiable = false,
    updated_at = now();

UPDATE public.listings l
SET
    listing_type = 'contact_organizer',
    sale_price = NULL,
    rent_price_monthly = NULL,
    rent_price_daily = NULL,
    price_negotiable = false,
    minimum_lease_months = NULL,
    key_money_amount = NULL,
    service_fee_monthly = NULL,
    price_unit = 'contact',
    title = CASE l.slug
        WHEN 'food-o-clock-the-empire-tower-2026'
            THEN 'ติดต่อผู้จัดงาน FOOD O''CLOCK ที่ The Empire Tower ชั้น M'
        WHEN 'local-favorites-emsphere-2026'
            THEN 'ติดต่อผู้จัดงาน LOCAL FAVORITES ที่ EMSPHERE ชั้น G'
        ELSE l.title
    END,
    description = replace(l.description, 'ก่อนจอง', 'โดยตรง'),
    updated_at = now()
FROM migration_contact_organizer_listings migrated
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
JOIN migration_contact_organizer_listings migrated ON migrated.id = l.id
ON CONFLICT (listing_id) DO UPDATE SET
    details = public.listing_category_details.details || jsonb_build_object(
        'price_on_request', true,
        'temporary_space_pricing_mode', 'contact_organizer'
    ),
    updated_at = now();

UPDATE public.listing_event_details led
SET
    price_on_request = true,
    application_instructions = replace(led.application_instructions, 'ก่อนจอง', 'โดยตรง'),
    updated_at = now()
FROM migration_contact_organizer_listings migrated
WHERE led.listing_id = migrated.id;

UPDATE public.listing_event_rounds ler
SET
    price_amount = NULL,
    price_unit = 'contact',
    updated_at = now()
FROM migration_contact_organizer_listings migrated
WHERE ler.listing_id = migrated.id;

UPDATE public.discovery_channel_property_types
SET
    allowed_offer_types = ARRAY['rent','sublease','business_transfer','contact_organizer'],
    updated_at = now()
WHERE channel_code = 'business'
  AND property_type_code = 'retail_space';

INSERT INTO public.search_aliases
    (phrase, normalized_phrase, intent_type, intent_value, locale, priority)
VALUES
    ('ติดต่อผู้จัดงาน', 'ติดต่อผู้จัดงาน', 'offer_type', 'contact_organizer', 'th', 120),
    ('สอบถามผู้จัดงาน', 'สอบถามผู้จัดงาน', 'offer_type', 'contact_organizer', 'th', 110),
    ('contact organizer', 'contact organizer', 'offer_type', 'contact_organizer', 'en', 120)
ON CONFLICT (normalized_phrase, intent_type, intent_value) DO UPDATE SET
    phrase = EXCLUDED.phrase,
    locale = EXCLUDED.locale,
    priority = EXCLUDED.priority,
    is_active = true,
    updated_at = now();

ALTER TABLE public.listing_offers
    ADD CONSTRAINT listing_offers_offer_type_check
    CHECK (offer_type IN ('sale','rent','sublease','business_transfer','contact_organizer'));

ALTER TABLE public.discovery_channel_property_types
    ADD CONSTRAINT discovery_channel_property_types_allowed_offer_types_check
    CHECK (allowed_offer_types <@ ARRAY['sale','rent','sublease','business_transfer','contact_organizer']::text[]);

DO $$
DECLARE
    corrected_count integer;
BEGIN
    SELECT count(*)
    INTO corrected_count
    FROM public.listings l
    JOIN public.listing_offers lo ON lo.listing_id = l.id
    WHERE l.slug IN (
        'food-o-clock-the-empire-tower-2026',
        'local-favorites-emsphere-2026'
    )
      AND l.listing_type = 'contact_organizer'
      AND l.price_unit = 'contact'
      AND lo.offer_type = 'contact_organizer'
      AND lo.amount IS NULL
      AND lo.price_unit = 'contact';

    IF corrected_count <> 2 THEN
        RAISE EXCEPTION 'Expected both imported temporary-space listings to use contact_organizer, got %', corrected_count;
    END IF;
END $$;

COMMIT;
