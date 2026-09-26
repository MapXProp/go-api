-- Apartment rooms keep their existing type. Entire buildings belong to hospitality.
CREATE TEMP TABLE hospitality_apartment_moves ON COMMIT DROP AS
SELECT l.id,
       CASE WHEN l.accommodation_model = 'serviced' OR l.property_type_code = 'serviced_apartment'
            THEN 'serviced_residence' ELSE 'apartment' END AS hospitality_type
FROM public.listings l
LEFT JOIN public.listing_category_details lcd ON lcd.listing_id = l.id
WHERE l.property_type_code IN ('apartment', 'serviced_apartment')
  AND (l.listing_scope = 'whole_property' OR lcd.details->>'discovery_channel_code' = 'business');

UPDATE public.listings l
SET property_type_code = 'hotel_resort', accommodation_model = NULL,
    listing_scope = 'whole_property', usage_type = 'business', updated_at = now()
FROM hospitality_apartment_moves moved
WHERE l.id = moved.id;

INSERT INTO public.listing_category_details (listing_id, category_code, details)
SELECT id, 'hotel_resort', jsonb_build_object(
    'hospitality_property_type', hospitality_type, 'discovery_channel_code', 'business'
) FROM hospitality_apartment_moves
ON CONFLICT (listing_id) DO UPDATE SET
    category_code = EXCLUDED.category_code,
    details = (listing_category_details.details - 'accommodation_model') || EXCLUDED.details,
    updated_at = now();

DELETE FROM public.listing_use_cases
WHERE listing_id IN (SELECT id FROM hospitality_apartment_moves);
INSERT INTO public.listing_use_cases (listing_id, use_case_code)
SELECT id, 'hospitality' FROM hospitality_apartment_moves;

DELETE FROM public.listing_discovery_channels
WHERE listing_id IN (SELECT id FROM hospitality_apartment_moves) AND channel_code <> 'business';
INSERT INTO public.listing_discovery_channels (listing_id, channel_code, source, is_featured)
SELECT id, 'business', 'editorial', false FROM hospitality_apartment_moves
ON CONFLICT (listing_id, channel_code) DO NOTHING;

DELETE FROM public.discovery_channel_property_types
WHERE channel_code = 'business' AND property_type_code IN ('apartment', 'serviced_apartment');

UPDATE public.property_types
SET description = 'โรงแรม รีสอร์ต และอพาร์ตเมนต์ทั้งอาคาร ไม่ใช่การปล่อยห้องรายเดือน', updated_at = now()
WHERE code = 'hotel_resort';
