BEGIN;

-- Flat remains a useful primary category in Thailand for purpose-built flat
-- blocks and public/organizational housing such as Din Daeng flats.
UPDATE public.property_types
SET name_th = 'แฟลต',
    name_en = 'Flat',
    description = 'อาคารพักอาศัยแบบแฟลต เช่น แฟลตดินแดง แฟลตการเคหะ หรือแฟลตของหน่วยงาน',
    aliases = ARRAY['housing_flat','public_housing_flat'],
    is_active = true,
    updated_at = now()
WHERE code = 'flat';

INSERT INTO public.discovery_channel_property_types
    (channel_code, property_type_code, allowed_offer_types, priority)
VALUES ('rooms', 'flat', ARRAY['rent'], 95)
ON CONFLICT (channel_code, property_type_code) DO UPDATE SET
    allowed_offer_types = EXCLUDED.allowed_offer_types,
    priority = EXCLUDED.priority,
    updated_at = now();

-- Restore rows changed by migration 0021 in environments where that migration
-- was already applied before flat was brought back.
UPDATE public.listings AS l
SET property_type_code = 'flat',
    accommodation_model = NULL,
    updated_at = now()
FROM public.listing_category_details AS lcd
WHERE lcd.listing_id = l.id
  AND l.property_type_code = 'apartment'
  AND lcd.details->>'legacy_property_type' = 'flat';

UPDATE public.listing_category_details
SET category_code = 'flat',
    details = details - 'accommodation_model',
    updated_at = now()
WHERE details->>'legacy_property_type' = 'flat';

UPDATE public.search_aliases
SET is_active = false, updated_at = now()
WHERE intent_type = 'property_type'
  AND intent_value = 'apartment'
  AND normalized_phrase IN ('แฟลต', 'flat');

INSERT INTO public.search_aliases
    (phrase, normalized_phrase, intent_type, intent_value, locale, priority)
VALUES
    ('แฟลต', 'แฟลต', 'property_type', 'flat', 'th', 115),
    ('แฟลตดินแดง', 'แฟลตดินแดง', 'property_type', 'flat', 'th', 120),
    ('แฟลตการเคหะ', 'แฟลตการเคหะ', 'property_type', 'flat', 'th', 115),
    ('flat', 'flat', 'property_type', 'flat', 'en', 110),
    ('คอร์ท', 'คอร์ท', 'property_type', 'apartment', 'th', 90),
    ('คอร์ต', 'คอร์ต', 'property_type', 'apartment', 'th', 85),
    ('court', 'court', 'property_type', 'apartment', 'en', 90),
    ('เรสซิเดนซ์', 'เรสซิเดนซ์', 'property_type', 'apartment', 'th', 80),
    ('แมนชั่น', 'แมนชั่น', 'property_type', 'apartment', 'th', 80)
ON CONFLICT (normalized_phrase, intent_type, intent_value) DO UPDATE SET
    phrase = EXCLUDED.phrase,
    locale = EXCLUDED.locale,
    priority = EXCLUDED.priority,
    is_active = true,
    updated_at = now();

COMMIT;
