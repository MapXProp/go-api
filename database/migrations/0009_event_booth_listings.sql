BEGIN;

-- Temporary booths are booked by an event round, not rented by the month.
ALTER TABLE public.listing_offers
    DROP CONSTRAINT IF EXISTS listing_offers_offer_type_check;

ALTER TABLE public.listing_offers
    ADD CONSTRAINT listing_offers_offer_type_check
    CHECK (offer_type IN ('sale','rent','sublease','business_transfer','event_booking'));

ALTER TABLE public.discovery_channel_property_types
    DROP CONSTRAINT IF EXISTS discovery_channel_property_types_allowed_offer_types_check;

ALTER TABLE public.discovery_channel_property_types
    ADD CONSTRAINT discovery_channel_property_types_allowed_offer_types_check
    CHECK (allowed_offer_types <@ ARRAY['sale','rent','sublease','business_transfer','event_booking']::text[]);

UPDATE public.discovery_channel_property_types
SET allowed_offer_types = ARRAY['sale','rent','sublease','business_transfer','event_booking'],
    updated_at = now()
WHERE channel_code = 'business' AND property_type_code = 'retail_space';

CREATE TABLE IF NOT EXISTS public.listing_event_details (
    listing_id bigint PRIMARY KEY REFERENCES public.listings(id) ON DELETE CASCADE,
    event_name text NOT NULL,
    organizer_name text,
    venue_name text NOT NULL,
    venue_floor_label text,
    audience_segments text[] NOT NULL DEFAULT '{}',
    accepted_product_categories text[] NOT NULL DEFAULT '{}',
    application_instructions text,
    floor_plan_url text,
    price_on_request boolean NOT NULL DEFAULT false,
    booth_size_on_request boolean NOT NULL DEFAULT false,
    source_published_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.listing_event_rounds (
    id bigserial PRIMARY KEY,
    listing_id bigint NOT NULL REFERENCES public.listings(id) ON DELETE CASCADE,
    round_label text,
    starts_on date NOT NULL,
    ends_on date NOT NULL,
    application_deadline date,
    availability_status text NOT NULL DEFAULT 'unknown',
    spaces_remaining integer,
    price_amount numeric(18,2),
    price_unit text NOT NULL DEFAULT 'event_round',
    notes text,
    sort_order integer NOT NULL DEFAULT 0,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (listing_id, starts_on, ends_on),
    CHECK (ends_on >= starts_on),
    CHECK (availability_status IN ('open','limited','waitlist','closed','unknown')),
    CHECK (spaces_remaining IS NULL OR spaces_remaining >= 0),
    CHECK (price_amount IS NULL OR price_amount >= 0)
);

CREATE INDEX IF NOT EXISTS idx_listing_event_rounds_discovery
    ON public.listing_event_rounds(availability_status, starts_on, ends_on, listing_id);

CREATE TABLE IF NOT EXISTS public.listing_sources (
    id bigserial PRIMARY KEY,
    listing_id bigint NOT NULL REFERENCES public.listings(id) ON DELETE CASCADE,
    source_type text NOT NULL,
    publisher_name text,
    source_url text,
    reference_code text,
    captured_at timestamptz NOT NULL DEFAULT now(),
    notes text,
    UNIQUE (listing_id, source_type, reference_code),
    CHECK (source_type IN ('owner','agent','organizer','editorial_import','public_post'))
);

INSERT INTO public.search_aliases
    (phrase, normalized_phrase, intent_type, intent_value, locale, priority)
VALUES
    ('ออกบูธ', 'ออกบูธ', 'space_type', 'event_booth', 'th', 120),
    ('บูธงาน', 'บูธงาน', 'space_type', 'event_booth', 'th', 115),
    ('บูธอีเวนต์', 'บูธอีเวนต์', 'space_type', 'event_booth', 'th', 115),
    ('พื้นที่ออกบูธ', 'พื้นที่ออกบูธ', 'space_type', 'event_booth', 'th', 110),
    ('event booth', 'event booth', 'space_type', 'event_booth', 'en', 110),
    ('pop-up booth', 'pop up booth', 'space_type', 'event_booth', 'en', 105)
ON CONFLICT (normalized_phrase, intent_type, intent_value) DO UPDATE SET
    phrase = EXCLUDED.phrase,
    locale = EXCLUDED.locale,
    priority = EXCLUDED.priority,
    is_active = true,
    updated_at = now();

DO $$
DECLARE
    platform_user_id bigint;
    event_listing_id bigint;
BEGIN
    SELECT id INTO platform_user_id
    FROM public.auth_users
    WHERE lower(email) = lower('mapxprop@gmail.com')
    ORDER BY id
    LIMIT 1;

    IF platform_user_id IS NULL THEN
        RAISE EXCEPTION 'MapxProp platform user is required before importing editorial listings';
    END IF;

    SELECT id INTO event_listing_id
    FROM public.listings
    WHERE slug = 'food-o-clock-the-empire-tower-2026'
    LIMIT 1;

    IF event_listing_id IS NULL THEN
        INSERT INTO public.listings (
            user_id,
            property_type_code,
            usage_type,
            listing_type,
            custom_project_name,
            custom_building_name,
            title,
            description,
            price_negotiable,
            contact_name,
            contact_phone,
            line_id,
            show_phone,
            show_email,
            address_line1,
            address_line2,
            road,
            postal_code,
            latitude,
            longitude,
            province_name,
            district_name,
            subdistrict_name,
            listing_status,
            moderation_status,
            approved_at,
            published_at,
            expires_at,
            is_verified,
            is_active,
            source_channel,
            business_type_code,
            space_type_code,
            target_tenant_type,
            price_unit,
            listing_scope,
            slug
        ) VALUES (
            platform_user_id,
            'retail_space',
            'business',
            'event_booking',
            'The Empire Tower',
            'The Empire Tower',
            'เปิดจองบูธงาน FOOD O''CLOCK ที่ The Empire Tower ชั้น M',
            E'เปิดจองพื้นที่ออกบูธงาน FOOD O''CLOCK จำนวน 5 รอบ บริเวณชั้น M ของ The Empire Tower เหมาะสำหรับอาหาร เครื่องดื่ม และสินค้าไลฟ์สไตล์ กลุ่มลูกค้าหลักเป็นพนักงานออฟฟิศและคนทำงานในอาคาร\n\nราคา ขนาดบูธ เลขบูธ สาธารณูปโภค และแปลนพื้นที่ กรุณาสอบถาม HBD Event โดยตรงก่อนจอง',
            false,
            'HBD Event',
            '0992602026',
            '@hbdtalk',
            true,
            false,
            'The Empire Tower ชั้น M',
            '1 ถนนสาทรใต้ แขวงยานนาวา เขตสาทร กรุงเทพมหานคร',
            'ถนนสาทรใต้',
            '10120',
            13.720534,
            100.530228,
            'กรุงเทพมหานคร',
            'สาทร',
            'ยานนาวา',
            'active',
            'approved',
            now(),
            '2026-08-18 18:16:00+07',
            '2026-10-03 00:00:00+07',
            false,
            true,
            'editorial_import',
            'food_and_lifestyle_event',
            'event_booth',
            'office_workers_and_lifestyle_shoppers',
            'event_round',
            'space_slot',
            'food-o-clock-the-empire-tower-2026'
        )
        RETURNING id INTO event_listing_id;
    END IF;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES
        (event_listing_id, 'retail'),
        (event_listing_id, 'food_service')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (listing_id, offer_type, amount, price_unit, is_negotiable)
    VALUES (event_listing_id, 'event_booking', NULL, 'event_round', false)
    ON CONFLICT (listing_id, offer_type) DO UPDATE SET
        amount = EXCLUDED.amount,
        price_unit = EXCLUDED.price_unit,
        is_negotiable = EXCLUDED.is_negotiable,
        updated_at = now();

    INSERT INTO public.listing_discovery_channels (listing_id, channel_code, source, is_featured)
    VALUES (event_listing_id, 'business', 'editorial', false)
    ON CONFLICT (listing_id, channel_code) DO UPDATE SET
        source = EXCLUDED.source,
        updated_at = now();

    INSERT INTO public.listing_business_details (
        listing_id,
        venue_type_code,
        floor_label,
        allowed_business_types,
        foot_traffic_level,
        cooking_allowed
    ) VALUES (
        event_listing_id,
        'event_booth',
        'M',
        ARRAY['food','beverage','lifestyle_products'],
        'office_crowd',
        false
    )
    ON CONFLICT (listing_id) DO UPDATE SET
        venue_type_code = EXCLUDED.venue_type_code,
        floor_label = EXCLUDED.floor_label,
        allowed_business_types = EXCLUDED.allowed_business_types,
        foot_traffic_level = EXCLUDED.foot_traffic_level,
        updated_at = now();

    INSERT INTO public.listing_event_details (
        listing_id,
        event_name,
        organizer_name,
        venue_name,
        venue_floor_label,
        audience_segments,
        accepted_product_categories,
        application_instructions,
        floor_plan_url,
        price_on_request,
        booth_size_on_request,
        source_published_at
    ) VALUES (
        event_listing_id,
        'FOOD O''CLOCK',
        'HBD Event',
        'The Empire Tower',
        'M',
        ARRAY['พนักงานออฟฟิศ','คนทำงานในอาคาร','ผู้ใช้บริการ The Empire Tower'],
        ARRAY['อาหาร','เครื่องดื่ม','สินค้าไลฟ์สไตล์'],
        'ติดต่อ HBD Event เพื่อสอบถามราคา ขนาดบูธ แปลน และรอบที่ยังว่างก่อนจอง',
        'https://bit.ly/2CgdOmX',
        true,
        true,
        '2026-08-18 18:16:00+07'
    )
    ON CONFLICT (listing_id) DO UPDATE SET
        event_name = EXCLUDED.event_name,
        organizer_name = EXCLUDED.organizer_name,
        venue_name = EXCLUDED.venue_name,
        venue_floor_label = EXCLUDED.venue_floor_label,
        audience_segments = EXCLUDED.audience_segments,
        accepted_product_categories = EXCLUDED.accepted_product_categories,
        application_instructions = EXCLUDED.application_instructions,
        floor_plan_url = EXCLUDED.floor_plan_url,
        price_on_request = EXCLUDED.price_on_request,
        booth_size_on_request = EXCLUDED.booth_size_on_request,
        source_published_at = EXCLUDED.source_published_at,
        updated_at = now();

    INSERT INTO public.listing_event_rounds
        (listing_id, round_label, starts_on, ends_on, availability_status, price_unit, sort_order)
    VALUES
        (event_listing_id, 'รอบที่ 1', '2026-08-31', '2026-09-04', 'open', 'event_round', 10),
        (event_listing_id, 'รอบที่ 2', '2026-09-07', '2026-09-11', 'open', 'event_round', 20),
        (event_listing_id, 'รอบที่ 3', '2026-09-14', '2026-09-18', 'open', 'event_round', 30),
        (event_listing_id, 'รอบที่ 4', '2026-09-21', '2026-09-25', 'open', 'event_round', 40),
        (event_listing_id, 'รอบที่ 5', '2026-09-28', '2026-10-02', 'open', 'event_round', 50)
    ON CONFLICT (listing_id, starts_on, ends_on) DO UPDATE SET
        round_label = EXCLUDED.round_label,
        availability_status = EXCLUDED.availability_status,
        price_unit = EXCLUDED.price_unit,
        sort_order = EXCLUDED.sort_order,
        updated_at = now();

    INSERT INTO public.listing_media (
        listing_id,
        media_type,
        source_type,
        role_code,
        title,
        alt_text,
        original_url,
        file_url,
        mime_type,
        width,
        height,
        sort_order,
        is_primary,
        is_active
    ) VALUES (
        event_listing_id,
        'image',
        'editorial_import',
        'cover',
        'โปสเตอร์ FOOD O''CLOCK',
        'เปิดจองบูธ FOOD O''CLOCK ที่ The Empire Tower ชั้น M จำนวน 5 รอบ',
        'https://www.mapxprop.com/listing-media/hbd/food-o-clock-empire-tower-2026.jpg',
        '/listing-media/hbd/food-o-clock-empire-tower-2026.jpg',
        'image/jpeg',
        1024,
        1536,
        10,
        true,
        true
    )
    ON CONFLICT DO NOTHING;

    INSERT INTO public.listing_sources (
        listing_id,
        source_type,
        publisher_name,
        source_url,
        reference_code,
        captured_at,
        notes
    ) VALUES (
        event_listing_id,
        'public_post',
        'HBD Event',
        NULL,
        'hbd-event-facebook-2026-08-18-empire',
        '2026-08-21 00:00:00+07',
        'นำเข้าจากโพสต์สาธารณะและโปสเตอร์ที่ผู้ดูแล MapxProp ตรวจทาน ข้อมูลราคา ขนาดบูธ และแปลนยังต้องยืนยันกับผู้จัด'
    )
    ON CONFLICT (listing_id, source_type, reference_code) DO UPDATE SET
        publisher_name = EXCLUDED.publisher_name,
        notes = EXCLUDED.notes;
END $$;

COMMIT;
