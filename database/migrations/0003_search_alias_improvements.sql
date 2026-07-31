BEGIN;

INSERT INTO public.search_aliases (phrase, normalized_phrase, intent_type, intent_value, locale, priority)
VALUES ('ร้าน', 'ร้าน', 'property_type', 'retail_space', 'th', 70)
ON CONFLICT (normalized_phrase, intent_type, intent_value) DO UPDATE SET
    phrase = EXCLUDED.phrase,
    locale = EXCLUDED.locale,
    priority = EXCLUDED.priority,
    is_active = true,
    updated_at = now();

COMMIT;
