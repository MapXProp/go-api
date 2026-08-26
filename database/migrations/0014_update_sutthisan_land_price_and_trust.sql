BEGIN;

DO $$
DECLARE
    land_listing_id bigint;
BEGIN
    SELECT id INTO land_listing_id
    FROM public.listings
    WHERE slug = 'land-for-sale-sutthisan-700-sq-wah'
    LIMIT 1;

    IF land_listing_id IS NULL THEN
        RAISE EXCEPTION 'Sutthisan 700 square wah listing was not found';
    END IF;

    UPDATE public.listings
    SET sale_price = 315000000,
        is_verified = true,
        updated_at = now()
    WHERE id = land_listing_id;

    UPDATE public.listing_offers
    SET amount = 315000000,
        updated_at = now()
    WHERE listing_id = land_listing_id
      AND offer_type = 'sale';

    UPDATE public.listing_category_details
    SET details = jsonb_set(
            jsonb_set(
                jsonb_set(details, '{price_per_square_wah}', '450000'::jsonb, true),
                '{seller_type}', '"owner_direct"'::jsonb, true
            ),
            '{contact_trust_status}', '"verified"'::jsonb, true
        ),
        updated_at = now()
    WHERE listing_id = land_listing_id;

    UPDATE public.listing_sources
    SET publisher_name = 'MapxProp — เจ้าของขายเอง',
        notes = 'ข้อมูล ราคา พิกัด ภาพถ่าย และข้อมูลติดต่อได้รับโดยตรงจากเจ้าของที่ดิน ผู้ติดต่อได้รับการยืนยันโดย MapxProp ข้อมูลโฉนด แนวเขต และข้อกำหนดการพัฒนาต้องตรวจสอบก่อนทำสัญญา'
    WHERE listing_id = land_listing_id
      AND source_type = 'owner';
END $$;

COMMIT;
