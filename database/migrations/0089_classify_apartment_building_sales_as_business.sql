BEGIN;

-- An apartment offered as an entire building is an operating/investment
-- property. Keep monthly room rentals in Rooms, but allow apartment-building
-- sales to be discovered in Business.
INSERT INTO public.property_type_use_cases (property_type_code, use_case_code, is_default)
VALUES ('apartment', 'hospitality', false)
ON CONFLICT (property_type_code, use_case_code) DO UPDATE SET
    is_default = EXCLUDED.is_default;

INSERT INTO public.discovery_channel_property_types (
    channel_code, property_type_code, allowed_offer_types, priority
) VALUES (
    'business', 'apartment', ARRAY['sale'], 92
)
ON CONFLICT (channel_code, property_type_code) DO UPDATE SET
    allowed_offer_types = EXCLUDED.allowed_offer_types,
    priority = EXCLUDED.priority,
    updated_at = now();

DO $$
DECLARE
    property_listing_id bigint;
BEGIN
    SELECT id INTO property_listing_id
    FROM public.listings
    WHERE public_listing_id = 'cc39260f-3146-4138-903b-ea2fdef7ad9a'
      AND deleted_at IS NULL;

    IF property_listing_id IS NULL THEN
        RAISE EXCEPTION 'SAM apartment listing BL0015 is required for business classification';
    END IF;

    UPDATE public.listings
    SET usage_type = 'business',
        listing_scope = 'whole_property',
        updated_at = now()
    WHERE id = property_listing_id;

    DELETE FROM public.listing_use_cases
    WHERE listing_id = property_listing_id;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'hospitality')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    DELETE FROM public.listing_discovery_channels
    WHERE listing_id = property_listing_id
      AND channel_code <> 'business';

    INSERT INTO public.listing_discovery_channels (
        listing_id, channel_code, source, is_featured
    ) VALUES (
        property_listing_id, 'business', 'editorial', false
    )
    ON CONFLICT (listing_id, channel_code) DO UPDATE SET
        source = EXCLUDED.source,
        is_featured = EXCLUDED.is_featured,
        updated_at = now();
END $$;

COMMIT;
