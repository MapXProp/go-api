BEGIN;

-- An apartment can be offered as a standard monthly rental or with
-- hotel-style ongoing services. This is a characteristic of an apartment,
-- not a separate property type.
ALTER TABLE public.listings
    ADD COLUMN IF NOT EXISTS accommodation_model text;

-- Preserve the original category in JSON while consolidating legacy types.
UPDATE public.listing_category_details AS lcd
SET category_code = 'apartment',
    details = COALESCE(lcd.details, '{}'::jsonb) || jsonb_build_object(
        'legacy_property_type', l.property_type_code,
        'accommodation_model', CASE
            WHEN l.property_type_code = 'serviced_apartment' THEN 'serviced'
            ELSE 'standard'
        END
    ),
    updated_at = now()
FROM public.listings AS l
WHERE l.id = lcd.listing_id
  AND l.property_type_code = 'serviced_apartment';

UPDATE public.listings
SET accommodation_model = CASE
        WHEN property_type_code = 'serviced_apartment' THEN 'serviced'
        ELSE 'standard'
    END,
    property_type_code = 'apartment',
    updated_at = now()
WHERE property_type_code = 'serviced_apartment';

UPDATE public.listings
SET accommodation_model = 'standard', updated_at = now()
WHERE property_type_code = 'apartment'
  AND accommodation_model IS NULL;

UPDATE public.listings
SET accommodation_model = NULL, updated_at = now()
WHERE property_type_code <> 'apartment'
  AND accommodation_model IS NOT NULL;

UPDATE public.listing_category_details AS lcd
SET details = COALESCE(lcd.details, '{}'::jsonb) || jsonb_build_object(
        'accommodation_model', l.accommodation_model
    ),
    updated_at = now()
FROM public.listings AS l
WHERE l.id = lcd.listing_id
  AND l.property_type_code = 'apartment';

ALTER TABLE public.listings
    DROP CONSTRAINT IF EXISTS listings_accommodation_model_check;

ALTER TABLE public.listings
    ADD CONSTRAINT listings_accommodation_model_check
    CHECK (
        (property_type_code = 'apartment' AND accommodation_model IN ('standard', 'serviced'))
        OR
        (property_type_code <> 'apartment' AND accommodation_model IS NULL)
    );

UPDATE public.discovery_channels
SET description_th = 'ห้องแบ่งเช่า อพาร์ตเมนต์ แฟลต หอพัก คอนโด และที่พักระยะยาว',
    description_en = 'Rooms in shared properties, apartments, flats, dorms, condos and long-term stays',
    updated_at = now()
WHERE code = 'rooms';

UPDATE public.property_types
SET name_th = 'ห้องแบ่งเช่า',
    name_en = 'Room in a house or building',
    description = 'ห้องที่แบ่งให้เช่าภายในบ้าน ตึกแถว หรืออาคารทั่วไป และอาจใช้พื้นที่บางส่วนร่วมกัน',
    aliases = ARRAY['monthly_room','room_for_rent','shared_room','room_in_house'],
    is_active = true,
    updated_at = now()
WHERE code = 'rental_room';

UPDATE public.property_types
SET description = 'ห้องเช่าหรืออาคารที่มีหลายห้องให้เช่า เลือกรูปแบบบริการทั่วไปหรือเซอร์วิสอพาร์ตเมนต์ในรายละเอียดประกาศ',
    aliases = ARRAY['apartment_building','court','residence','mansion','serviced_apartment','service_apartment','long_stay_apartment'],
    is_active = true,
    updated_at = now()
WHERE code = 'apartment';

UPDATE public.property_types
SET is_active = false, updated_at = now()
WHERE code = 'serviced_apartment';

DELETE FROM public.discovery_channel_property_types
WHERE property_type_code = 'serviced_apartment';

UPDATE public.search_aliases
SET is_active = false, updated_at = now()
WHERE intent_type = 'property_type'
  AND intent_value = 'serviced_apartment';

INSERT INTO public.search_aliases
    (phrase, normalized_phrase, intent_type, intent_value, locale, priority)
VALUES
    ('ห้องแบ่งเช่า', 'ห้องแบ่งเช่า', 'property_type', 'rental_room', 'th', 115),
    ('ห้องในบ้าน', 'ห้องในบ้าน', 'property_type', 'rental_room', 'th', 100),
    ('room in a house', 'room in a house', 'property_type', 'rental_room', 'en', 100),
    ('เซอร์วิสอพาร์ตเมนต์', 'เซอร์วิสอพาร์ตเมนต์', 'property_type', 'apartment', 'th', 115),
    ('เซอร์วิสอพาร์ตเมนต์', 'เซอร์วิสอพาร์ตเมนต์', 'feature', 'serviced', 'th', 115),
    ('serviced apartment', 'serviced apartment', 'property_type', 'apartment', 'en', 115),
    ('serviced apartment', 'serviced apartment', 'feature', 'serviced', 'en', 115),
    ('service apartment', 'service apartment', 'property_type', 'apartment', 'en', 105),
    ('service apartment', 'service apartment', 'feature', 'serviced', 'en', 105)
ON CONFLICT (normalized_phrase, intent_type, intent_value) DO UPDATE SET
    phrase = EXCLUDED.phrase,
    locale = EXCLUDED.locale,
    priority = EXCLUDED.priority,
    is_active = true,
    updated_at = now();

COMMIT;
