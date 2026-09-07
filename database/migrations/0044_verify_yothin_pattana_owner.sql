BEGIN;

DO $$
DECLARE
    land_listing_id bigint;
    verifier_user_id bigint;
BEGIN
    SELECT id INTO land_listing_id
    FROM public.listings
    WHERE public_listing_id::text = '88fde0e9-3634-4223-87b4-dff46fb374d3'
      AND slug = 'land-for-sale-yothin-pattana-11-200-sq-wah'
    LIMIT 1;

    IF land_listing_id IS NULL THEN
        RAISE EXCEPTION 'Yothin Pattana 11 land listing was not found';
    END IF;

    SELECT id INTO verifier_user_id
    FROM public.auth_users
    WHERE lower(email) = 'mapxprop@gmail.com'
    LIMIT 1;

    UPDATE public.listing_contact_profiles
    SET verification_status = 'authority_verified',
        verification_note = 'MapxProp confirmed Khun Tum''s identity and ownership authority for this listing.',
        verified_at = now(),
        verified_by_user_id = verifier_user_id,
        updated_at = now()
    WHERE listing_id = land_listing_id
      AND role_code = 'owner'
      AND authority_source_code = 'self';

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Expected Yothin Pattana 11 owner contact profile was not found';
    END IF;

    UPDATE public.listings
    SET is_verified = true,
        updated_at = now()
    WHERE id = land_listing_id;

    UPDATE public.listing_sources
    SET notes = 'ประกาศเจ้าของขายเอง คุณตุ้มได้รับการยืนยันตัวตนและสิทธิ์ในการลงประกาศโดย MapxProp แล้ว ข้อมูลราคา พิกัด ภาพถ่าย วิดีโอ และเบอร์ติดต่อได้รับจากผู้ใช้เมื่อ 7 กันยายน 2569 ผู้ซื้อยังควรตรวจสอบเอกสารสิทธิ์ แนวเขต สิ่งปลูกสร้าง ผังเมือง และข้อกำหนดการพัฒนาก่อนทำสัญญา'
    WHERE listing_id = land_listing_id
      AND source_type = 'owner'
      AND reference_code = 'mapxprop-owner-yothin-pattana-11-200-square-wah';

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Expected Yothin Pattana 11 listing source was not found';
    END IF;
END $$;

COMMIT;
