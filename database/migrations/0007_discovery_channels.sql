BEGIN;

-- Discovery channels describe how a visitor wants to browse. They are deliberately
-- separate from property type and offer type: one listing may belong to several
-- channels while still carrying sale/rent offers independently.
CREATE TABLE IF NOT EXISTS public.discovery_channels (
    code text PRIMARY KEY,
    name_th text NOT NULL,
    name_en text NOT NULL,
    description_th text,
    description_en text,
    sort_order integer NOT NULL DEFAULT 0,
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO public.discovery_channels
    (code, name_th, name_en, description_th, description_en, sort_order)
VALUES
    ('homes', 'บ้านและที่อยู่อาศัย', 'Homes & residential',
        'บ้าน คอนโด ทาวน์โฮม และที่ดิน ทั้งซื้อและเช่า',
        'Homes, condos, townhouses and land, for sale or rent', 10),
    ('rooms', 'ห้องเช่าและที่พักรายเดือน', 'Rooms & monthly stays',
        'อพาร์ตเมนต์ หอพัก แฟลต และที่พักระยะยาว',
        'Apartments, dorms, flats and long-stay rooms', 20),
    ('business', 'พื้นที่ทำธุรกิจ', 'Business spaces',
        'ร้านค้า ล็อกตลาด ออฟฟิศ โกดัง โรงงาน และพื้นที่ชั่วคราว',
        'Shops, stalls, offices, warehouses, factories and temporary spaces', 30)
ON CONFLICT (code) DO UPDATE SET
    name_th = EXCLUDED.name_th,
    name_en = EXCLUDED.name_en,
    description_th = EXCLUDED.description_th,
    description_en = EXCLUDED.description_en,
    sort_order = EXCLUDED.sort_order,
    is_active = true,
    updated_at = now();

INSERT INTO public.property_types
    (code, name_th, name_en, usage_type, description, is_active, sort_order, group_code, aliases)
VALUES
    ('rental_room', 'ห้องเช่า', 'Rental room', 'residence', 'ห้องเดี่ยวหรือยูนิตสำหรับเช่ารายเดือน', true, 52, 'residential', ARRAY['monthly_room','room_for_rent']),
    ('flat', 'แฟลต', 'Flat', 'residence', 'ห้องพักในอาคารแฟลตหรือโครงการที่พักอาศัย', true, 54, 'residential', ARRAY['แฟลตการเคหะ','housing_flat']),
    ('serviced_apartment', 'เซอร์วิสอพาร์ตเมนต์', 'Serviced apartment', 'residence', 'ที่พักรายเดือนพร้อมบริการส่วนกลาง', true, 56, 'residential', ARRAY['service_apartment','long_stay_apartment']),
    ('monthly_hotel', 'โรงแรมรายเดือน', 'Monthly hotel', 'residence', 'ห้องพักโรงแรมที่เปิดให้เช่าระยะยาวหรือรายเดือน', true, 58, 'residential', ARRAY['long_stay_hotel','hotel_monthly'])
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

CREATE TABLE IF NOT EXISTS public.discovery_channel_property_types (
    channel_code text NOT NULL REFERENCES public.discovery_channels(code) ON DELETE CASCADE,
    property_type_code text NOT NULL REFERENCES public.property_types(code) ON DELETE CASCADE,
    allowed_offer_types text[] NOT NULL DEFAULT '{}',
    priority integer NOT NULL DEFAULT 0,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (channel_code, property_type_code),
    CHECK (allowed_offer_types <@ ARRAY['sale','rent','sublease','business_transfer']::text[])
);

INSERT INTO public.discovery_channel_property_types
    (channel_code, property_type_code, allowed_offer_types, priority)
VALUES
    ('homes', 'detached_house', ARRAY['sale','rent'], 100),
    ('homes', 'semi_detached_house', ARRAY['sale','rent'], 95),
    ('homes', 'townhouse', ARRAY['sale','rent'], 95),
    ('homes', 'condo', ARRAY['sale','rent'], 100),
    ('homes', 'shophouse', ARRAY['sale','rent'], 70),
    ('homes', 'home_office', ARRAY['sale','rent'], 65),
    ('homes', 'land', ARRAY['sale','rent'], 60),
    ('rooms', 'rental_room', ARRAY['rent'], 100),
    ('rooms', 'apartment', ARRAY['rent'], 100),
    ('rooms', 'dormitory', ARRAY['rent'], 100),
    ('rooms', 'condo', ARRAY['rent'], 80),
    ('rooms', 'flat', ARRAY['rent'], 95),
    ('rooms', 'serviced_apartment', ARRAY['rent'], 90),
    ('rooms', 'monthly_hotel', ARRAY['rent'], 85),
    ('business', 'shophouse', ARRAY['sale','rent','sublease','business_transfer'], 100),
    ('business', 'home_office', ARRAY['sale','rent'], 80),
    ('business', 'office', ARRAY['sale','rent','sublease'], 95),
    ('business', 'retail_space', ARRAY['sale','rent','sublease','business_transfer'], 100),
    ('business', 'warehouse', ARRAY['sale','rent'], 90),
    ('business', 'factory', ARRAY['sale','rent'], 90),
    ('business', 'land', ARRAY['sale','rent'], 70)
ON CONFLICT (channel_code, property_type_code) DO UPDATE SET
    allowed_offer_types = EXCLUDED.allowed_offer_types,
    priority = EXCLUDED.priority,
    updated_at = now();

-- Explicit membership is useful for exceptional properties and editorial curation.
-- Derived membership can later be refreshed from the rules above.
CREATE TABLE IF NOT EXISTS public.listing_discovery_channels (
    listing_id bigint NOT NULL REFERENCES public.listings(id) ON DELETE CASCADE,
    channel_code text NOT NULL REFERENCES public.discovery_channels(code) ON DELETE CASCADE,
    source text NOT NULL DEFAULT 'derived',
    is_featured boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (listing_id, channel_code),
    CHECK (source IN ('derived','manual','editorial'))
);

CREATE INDEX IF NOT EXISTS idx_listing_discovery_channels_browse
    ON public.listing_discovery_channels(channel_code, is_featured DESC, listing_id);

-- Preserve compatibility with listings created before listing_offers existed.
INSERT INTO public.listing_offers (listing_id, offer_type, amount, price_unit)
SELECT id, 'sale', sale_price, 'total'
FROM public.listings
WHERE sale_price IS NOT NULL
ON CONFLICT (listing_id, offer_type) DO NOTHING;

INSERT INTO public.listing_offers (listing_id, offer_type, amount, price_unit)
SELECT id, 'rent', rent_price_monthly, 'month'
FROM public.listings
WHERE rent_price_monthly IS NOT NULL
ON CONFLICT (listing_id, offer_type) DO NOTHING;

INSERT INTO public.listing_discovery_channels (listing_id, channel_code, source)
SELECT DISTINCT l.id, dcpt.channel_code, 'derived'
FROM public.listings l
JOIN public.discovery_channel_property_types dcpt
  ON dcpt.property_type_code = l.property_type_code
WHERE cardinality(dcpt.allowed_offer_types) = 0
   OR EXISTS (
      SELECT 1 FROM public.listing_offers lo
      WHERE lo.listing_id = l.id
        AND lo.offer_type = ANY(dcpt.allowed_offer_types)
   )
ON CONFLICT (listing_id, channel_code) DO NOTHING;

ALTER TABLE public.search_aliases
    DROP CONSTRAINT IF EXISTS search_aliases_intent_type_check;

ALTER TABLE public.search_aliases
    ADD CONSTRAINT search_aliases_intent_type_check
    CHECK (intent_type IN ('property_type','property_group','use_case','offer_type','space_type','feature','discovery_channel'));

INSERT INTO public.search_aliases (phrase, normalized_phrase, intent_type, intent_value, locale, priority)
VALUES
    ('บ้านและที่อยู่อาศัย', 'บ้านและที่อยู่อาศัย', 'discovery_channel', 'homes', 'th', 100),
    ('ห้องเช่ารายเดือน', 'ห้องเช่ารายเดือน', 'discovery_channel', 'rooms', 'th', 110),
    ('ที่พักรายเดือน', 'ที่พักรายเดือน', 'discovery_channel', 'rooms', 'th', 105),
    ('โรงแรมรายเดือน', 'โรงแรมรายเดือน', 'property_type', 'monthly_hotel', 'th', 110),
    ('เซอร์วิสอพาร์ตเมนต์', 'เซอร์วิสอพาร์ตเมนต์', 'property_type', 'serviced_apartment', 'th', 110),
    ('แฟลต', 'แฟลต', 'property_type', 'flat', 'th', 100),
    ('พื้นที่ทำธุรกิจ', 'พื้นที่ทำธุรกิจ', 'discovery_channel', 'business', 'th', 110),
    ('monthly rental', 'monthly rental', 'discovery_channel', 'rooms', 'en', 100),
    ('business space', 'business space', 'discovery_channel', 'business', 'en', 100)
ON CONFLICT (normalized_phrase, intent_type, intent_value) DO UPDATE SET
    phrase = EXCLUDED.phrase,
    locale = EXCLUDED.locale,
    priority = EXCLUDED.priority,
    is_active = true,
    updated_at = now();

COMMIT;
