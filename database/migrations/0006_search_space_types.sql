BEGIN;

ALTER TABLE public.search_aliases
    DROP CONSTRAINT IF EXISTS search_aliases_intent_type_check;

ALTER TABLE public.search_aliases
    ADD CONSTRAINT search_aliases_intent_type_check
    CHECK (intent_type IN ('property_type','property_group','use_case','offer_type','space_type','feature'));

INSERT INTO public.business_space_types (code, name_th, name_en, is_active, sort_order)
VALUES
    ('market_stall', 'ล็อกในตลาด / ตลาดนัด', 'Market stall', true, 45)
ON CONFLICT (code) DO UPDATE SET
    name_th = EXCLUDED.name_th,
    name_en = EXCLUDED.name_en,
    is_active = true,
    sort_order = EXCLUDED.sort_order;

INSERT INTO public.search_aliases (phrase, normalized_phrase, intent_type, intent_value, locale, priority)
VALUES
    ('ล็อกในตลาด', 'ล็อกในตลาด', 'space_type', 'market_stall', 'th', 110),
    ('ล็อคในตลาด', 'ล็อคในตลาด', 'space_type', 'market_stall', 'th', 105),
    ('ล็อกตลาด', 'ล็อกตลาด', 'space_type', 'market_stall', 'th', 100),
    ('แผงในตลาด', 'แผงในตลาด', 'space_type', 'market_stall', 'th', 100),
    ('market stall', 'market stall', 'space_type', 'market_stall', 'en', 110)
ON CONFLICT (normalized_phrase, intent_type, intent_value) DO UPDATE SET
    phrase = EXCLUDED.phrase,
    locale = EXCLUDED.locale,
    priority = EXCLUDED.priority,
    is_active = true,
    updated_at = now();

COMMIT;
