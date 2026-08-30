BEGIN;

INSERT INTO public.search_aliases
    (phrase, normalized_phrase, intent_type, intent_value, locale, priority)
VALUES
    ('ร้านในห้าง', 'ร้านในห้าง', 'space_type', 'mall_shop', 'th', 115),
    ('ร้านค้าภายในห้าง', 'ร้านค้าภายในห้าง', 'space_type', 'mall_shop', 'th', 115),
    ('mall shop', 'mall shop', 'space_type', 'mall_shop', 'en', 110),

    ('เคาน์เตอร์ศูนย์อาหาร', 'เคาน์เตอร์ศูนย์อาหาร', 'space_type', 'food_court_counter', 'th', 120),
    ('ล็อกศูนย์อาหาร', 'ล็อกศูนย์อาหาร', 'space_type', 'food_court_counter', 'th', 110),
    ('food court counter', 'food court counter', 'space_type', 'food_court_counter', 'en', 115),

    ('พื้นที่ขายอาหารในโรงเรียน', 'พื้นที่ขายอาหารในโรงเรียน', 'space_type', 'school_canteen', 'th', 120),
    ('โรงอาหารโรงเรียน', 'โรงอาหารโรงเรียน', 'space_type', 'school_canteen', 'th', 110),
    ('school canteen', 'school canteen', 'space_type', 'school_canteen', 'en', 110),

    ('พื้นที่ขายอาหารในสำนักงาน', 'พื้นที่ขายอาหารในสำนักงาน', 'space_type', 'office_canteen', 'th', 120),
    ('โรงอาหารสำนักงาน', 'โรงอาหารสำนักงาน', 'space_type', 'office_canteen', 'th', 110),
    ('office canteen', 'office canteen', 'space_type', 'office_canteen', 'en', 110),

    ('ร้านในหอพัก', 'ร้านในหอพัก', 'space_type', 'dormitory_shop', 'th', 115),
    ('ร้านค้าในอพาร์ตเมนต์', 'ร้านค้าในอพาร์ตเมนต์', 'space_type', 'dormitory_shop', 'th', 110),
    ('dormitory shop', 'dormitory shop', 'space_type', 'dormitory_shop', 'en', 110),

    ('พื้นที่สตรีทฟู้ด', 'พื้นที่สตรีทฟู้ด', 'space_type', 'street_food_space', 'th', 120),
    ('ล็อกสตรีทฟู้ด', 'ล็อกสตรีทฟู้ด', 'space_type', 'street_food_space', 'th', 110),
    ('street food space', 'street food space', 'space_type', 'street_food_space', 'en', 110),

    -- One phrase may intentionally resolve to two overlapping space types.
    ('บูธในห้าง', 'บูธในห้าง', 'space_type', 'mall_kiosk', 'th', 125),
    ('บูธในห้าง', 'บูธในห้าง', 'space_type', 'event_booth', 'th', 125),
    ('event booth in mall', 'event booth in mall', 'space_type', 'mall_kiosk', 'en', 120),
    ('event booth in mall', 'event booth in mall', 'space_type', 'event_booth', 'en', 120)
ON CONFLICT (normalized_phrase, intent_type, intent_value) DO UPDATE SET
    phrase = EXCLUDED.phrase,
    locale = EXCLUDED.locale,
    priority = EXCLUDED.priority,
    is_active = true,
    updated_at = now();

COMMIT;
