-- Add whole-property hospitality assets to the business discovery channel.
-- Monthly room rentals remain under monthly_hotel in the rooms channel.

INSERT INTO public.property_types
    (code, name_th, name_en, usage_type, description, is_active, sort_order, group_code, aliases)
VALUES
    (
        'hotel_resort',
        'โรงแรม / รีสอร์ต / กิจการที่พัก',
        'Hotel / resort property',
        'business',
        'ขายหรือให้เช่าทั้งอาคารและกิจการที่พัก ไม่ใช่การปล่อยห้องรายเดือน',
        true,
        125,
        'commercial',
        ARRAY['hotel_property','resort_property','hostel_property','hospitality_property']
    )
ON CONFLICT (code) DO UPDATE SET
    name_th = EXCLUDED.name_th,
    name_en = EXCLUDED.name_en,
    usage_type = EXCLUDED.usage_type,
    description = EXCLUDED.description,
    is_active = EXCLUDED.is_active,
    sort_order = EXCLUDED.sort_order,
    group_code = EXCLUDED.group_code,
    aliases = EXCLUDED.aliases,
    updated_at = now();

INSERT INTO public.property_type_use_cases (property_type_code, use_case_code, is_default)
VALUES ('hotel_resort', 'hospitality', true)
ON CONFLICT (property_type_code, use_case_code) DO UPDATE SET
    is_default = EXCLUDED.is_default;

INSERT INTO public.discovery_channel_property_types
    (channel_code, property_type_code, allowed_offer_types, priority)
VALUES
    ('business', 'hotel_resort', ARRAY['sale','rent','sublease','business_transfer'], 85)
ON CONFLICT (channel_code, property_type_code) DO UPDATE SET
    allowed_offer_types = EXCLUDED.allowed_offer_types,
    priority = EXCLUDED.priority,
    updated_at = now();

UPDATE public.discovery_channels
SET
    description_th = 'ร้านค้า ออฟฟิศ โกดัง โรงงาน โรงแรม รีสอร์ต และพื้นที่ชั่วคราว',
    description_en = 'Shops, offices, warehouses, factories, hotels, resorts and temporary spaces',
    updated_at = now()
WHERE code = 'business';

INSERT INTO public.search_aliases (phrase, normalized_phrase, intent_type, intent_value, locale, priority)
VALUES
    ('โรงแรม รีสอร์ต', 'โรงแรม รีสอร์ต', 'property_type', 'hotel_resort', 'th', 120),
    ('ขายโรงแรม', 'ขายโรงแรม', 'property_type', 'hotel_resort', 'th', 120),
    ('ขายรีสอร์ต', 'ขายรีสอร์ต', 'property_type', 'hotel_resort', 'th', 120),
    ('กิจการที่พัก', 'กิจการที่พัก', 'property_type', 'hotel_resort', 'th', 110),
    ('hotel property', 'hotel property', 'property_type', 'hotel_resort', 'en', 120),
    ('resort property', 'resort property', 'property_type', 'hotel_resort', 'en', 120),
    ('hospitality property', 'hospitality property', 'property_type', 'hotel_resort', 'en', 110)
ON CONFLICT (normalized_phrase, intent_type, intent_value) DO UPDATE SET
    phrase = EXCLUDED.phrase,
    locale = EXCLUDED.locale,
    priority = EXCLUDED.priority,
    updated_at = now();
