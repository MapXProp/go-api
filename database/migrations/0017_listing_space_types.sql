BEGIN;

-- Retail listings keep a single top-level property type (retail_space), while
-- one listing can describe up to three overlapping physical formats. The
-- legacy listings.space_type_code remains the primary value for backwards
-- compatibility with existing cards, exports and older API consumers.
INSERT INTO public.business_space_types (code, name_th, name_en, is_active, sort_order)
VALUES
    ('standalone_shop', 'ร้านค้า / พื้นที่หน้าร้าน', 'Standalone shop', true, 10),
    ('market_stall', 'ล็อกในตลาด / ตลาดนัด', 'Market stall', true, 20),
    ('mall_kiosk', 'ล็อกหรือคีออสในห้าง', 'Mall kiosk', true, 30),
    ('mall_shop', 'ร้านค้าภายในห้าง', 'Mall shop', true, 40),
    ('food_court_counter', 'เคาน์เตอร์ศูนย์อาหาร', 'Food court counter', true, 50),
    ('school_canteen', 'พื้นที่ขายอาหารในโรงเรียน', 'School canteen space', true, 60),
    ('office_canteen', 'พื้นที่ขายอาหารในสำนักงาน', 'Office canteen space', true, 70),
    ('dormitory_shop', 'ร้านค้าในหอพัก / อพาร์ตเมนต์', 'Dormitory shop', true, 80),
    ('street_food_space', 'พื้นที่สตรีทฟู้ด', 'Street food space', true, 90),
    ('shophouse_ground_floor', 'ร้านชั้นล่างตึกแถว / อาคารพาณิชย์', 'Shophouse ground-floor shop', true, 100),
    ('event_booth', 'บูธอีเวนต์ / พื้นที่ชั่วคราว', 'Event booth', true, 110)
ON CONFLICT (code) DO UPDATE SET
    name_th = EXCLUDED.name_th,
    name_en = EXCLUDED.name_en,
    is_active = true,
    sort_order = EXCLUDED.sort_order;

CREATE TABLE IF NOT EXISTS public.listing_space_types (
    listing_id bigint NOT NULL REFERENCES public.listings(id) ON DELETE CASCADE,
    space_type_code text NOT NULL REFERENCES public.business_space_types(code),
    is_primary boolean NOT NULL DEFAULT false,
    sort_order smallint NOT NULL DEFAULT 0,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (listing_id, space_type_code),
    CHECK (sort_order >= 0 AND sort_order <= 2)
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_listing_space_types_primary
    ON public.listing_space_types(listing_id)
    WHERE is_primary = true;

CREATE INDEX IF NOT EXISTS idx_listing_space_types_search
    ON public.listing_space_types(space_type_code, listing_id);

INSERT INTO public.listing_space_types (listing_id, space_type_code, is_primary, sort_order)
SELECT id, space_type_code, true, 0
FROM public.listings
WHERE NULLIF(space_type_code, '') IS NOT NULL
ON CONFLICT (listing_id, space_type_code) DO UPDATE SET
    is_primary = true,
    sort_order = 0,
    updated_at = now();

COMMIT;
