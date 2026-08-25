BEGIN;

-- Keep retail-space listings under one property type while recording the
-- physical format separately. This makes search/filtering precise without
-- turning each shop format into a top-level property category.
INSERT INTO public.business_space_types (code, name_th, name_en, is_active, sort_order)
VALUES
    ('market_stall', 'ล็อกในตลาด / ตลาดนัด', 'Market stall', true, 10),
    ('mall_kiosk', 'ล็อกหรือคีออสในห้าง', 'Mall kiosk', true, 20),
    ('standalone_shop', 'ร้านค้า Standalone', 'Standalone shop', true, 30),
    ('shophouse_ground_floor', 'ร้านค้าใต้ตึกแถว', 'Shophouse ground-floor shop', true, 40),
    ('event_booth', 'บูธอีเวนต์ / พื้นที่ชั่วคราว', 'Event booth', true, 50)
ON CONFLICT (code) DO UPDATE SET
    name_th = EXCLUDED.name_th,
    name_en = EXCLUDED.name_en,
    is_active = true,
    sort_order = EXCLUDED.sort_order;

INSERT INTO public.search_aliases
    (phrase, normalized_phrase, intent_type, intent_value, locale, priority)
VALUES
    ('ล็อกในห้าง', 'ล็อกในห้าง', 'space_type', 'mall_kiosk', 'th', 115),
    ('ล็อคในห้าง', 'ล็อคในห้าง', 'space_type', 'mall_kiosk', 'th', 110),
    ('คีออสในห้าง', 'คีออสในห้าง', 'space_type', 'mall_kiosk', 'th', 115),
    ('ร้านค้า standalone', 'ร้านค้า standalone', 'space_type', 'standalone_shop', 'th', 110),
    ('ร้านเดี่ยว', 'ร้านเดี่ยว', 'space_type', 'standalone_shop', 'th', 100),
    ('ร้านค้าใต้ตึกแถว', 'ร้านค้าใต้ตึกแถว', 'space_type', 'shophouse_ground_floor', 'th', 115),
    ('ร้านค้าชั้นล่างตึกแถว', 'ร้านค้าชั้นล่างตึกแถว', 'space_type', 'shophouse_ground_floor', 'th', 120),
    ('หน้าร้านตึกแถว', 'หน้าร้านตึกแถว', 'space_type', 'shophouse_ground_floor', 'th', 105),
    ('mall kiosk', 'mall kiosk', 'space_type', 'mall_kiosk', 'en', 110),
    ('standalone shop', 'standalone shop', 'space_type', 'standalone_shop', 'en', 110),
    ('shophouse ground floor', 'shophouse ground floor', 'space_type', 'shophouse_ground_floor', 'en', 110)
ON CONFLICT (normalized_phrase, intent_type, intent_value) DO UPDATE SET
    phrase = EXCLUDED.phrase,
    locale = EXCLUDED.locale,
    priority = EXCLUDED.priority,
    is_active = true,
    updated_at = now();

COMMIT;
