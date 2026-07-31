BEGIN;

INSERT INTO public.search_aliases (phrase, normalized_phrase, intent_type, intent_value, locale, priority)
VALUES
    ('house', 'house', 'property_group', 'residential', 'en', 70),
    ('detached house', 'detached house', 'property_type', 'detached_house', 'en', 100),
    ('semi-detached house', 'semi-detached house', 'property_type', 'semi_detached_house', 'en', 100),
    ('townhouse', 'townhouse', 'property_type', 'townhouse', 'en', 100),
    ('townhome', 'townhome', 'property_type', 'townhouse', 'en', 95),
    ('dormitory', 'dormitory', 'property_type', 'dormitory', 'en', 100),
    ('dorm', 'dorm', 'property_type', 'dormitory', 'en', 90),
    ('apartment', 'apartment', 'property_type', 'apartment', 'en', 100),
    ('shophouse', 'shophouse', 'property_type', 'shophouse', 'en', 100),
    ('home office', 'home office', 'property_type', 'home_office', 'en', 100),
    ('office', 'office', 'property_type', 'office', 'en', 100),
    ('retail space', 'retail space', 'property_type', 'retail_space', 'en', 100),
    ('shop', 'shop', 'property_type', 'retail_space', 'en', 80),
    ('warehouse', 'warehouse', 'property_type', 'warehouse', 'en', 100),
    ('factory', 'factory', 'property_type', 'factory', 'en', 100),
    ('land', 'land', 'property_type', 'land', 'en', 100),
    ('buy', 'buy', 'offer_type', 'sale', 'en', 100),
    ('sale', 'sale', 'offer_type', 'sale', 'en', 90),
    ('rent', 'rent', 'offer_type', 'rent', 'en', 100),
    ('business transfer', 'business transfer', 'offer_type', 'business_transfer', 'en', 100),
    ('transfer', 'transfer', 'offer_type', 'business_transfer', 'en', 80)
ON CONFLICT (normalized_phrase, intent_type, intent_value) DO UPDATE SET
    phrase = EXCLUDED.phrase,
    locale = EXCLUDED.locale,
    priority = EXCLUDED.priority,
    is_active = true,
    updated_at = now();

COMMIT;
