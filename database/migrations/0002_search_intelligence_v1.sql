BEGIN;

CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE TABLE IF NOT EXISTS public.search_locations (
    id bigserial PRIMARY KEY,
    code text NOT NULL UNIQUE,
    name_th text NOT NULL,
    name_en text NOT NULL,
    location_type text NOT NULL,
    parent_code text REFERENCES public.search_locations(code),
    aliases text[] NOT NULL DEFAULT '{}',
    latitude double precision,
    longitude double precision,
    priority integer NOT NULL DEFAULT 0,
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CHECK (location_type IN ('country','province','district','subdistrict','neighborhood','transit','project'))
);

CREATE INDEX IF NOT EXISTS idx_search_locations_parent
    ON public.search_locations(parent_code, location_type);
CREATE INDEX IF NOT EXISTS idx_search_locations_name_th_trgm
    ON public.search_locations USING gin (name_th gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_search_locations_name_en_trgm
    ON public.search_locations USING gin (lower(name_en) gin_trgm_ops);

INSERT INTO public.search_locations
    (code, name_th, name_en, location_type, aliases, latitude, longitude, priority)
VALUES
    ('province-bangkok', 'กรุงเทพมหานคร', 'Bangkok', 'province', ARRAY['กรุงเทพ','กทม','bangkok','bkk'], 13.7563, 100.5018, 100),
    ('province-chiang-mai', 'เชียงใหม่', 'Chiang Mai', 'province', ARRAY['เชียงใหม่','chiang mai','cnx'], 18.7883, 98.9853, 90),
    ('province-chon-buri', 'ชลบุรี', 'Chon Buri', 'province', ARRAY['ชลบุรี','chonburi','chon buri'], 13.3611, 100.9847, 85),
    ('province-phuket', 'ภูเก็ต', 'Phuket', 'province', ARRAY['ภูเก็ต','phuket','hkt'], 7.8804, 98.3923, 85),
    ('province-samut-prakan', 'สมุทรปราการ', 'Samut Prakan', 'province', ARRAY['สมุทรปราการ','ปากน้ำ','samut prakan'], 13.5991, 100.5998, 80),
    ('province-pathum-thani', 'ปทุมธานี', 'Pathum Thani', 'province', ARRAY['ปทุมธานี','pathum thani'], 14.0208, 100.5250, 70),
    ('province-nonthaburi', 'นนทบุรี', 'Nonthaburi', 'province', ARRAY['นนทบุรี','nonthaburi'], 13.8621, 100.5144, 75),
    ('province-khon-kaen', 'ขอนแก่น', 'Khon Kaen', 'province', ARRAY['ขอนแก่น','khon kaen','ขก'], 16.4322, 102.8236, 65),
    ('province-nakhon-ratchasima', 'นครราชสีมา', 'Nakhon Ratchasima', 'province', ARRAY['นครราชสีมา','โคราช','korat','nakhon ratchasima'], 14.9799, 102.0978, 65),
    ('neighborhood-ari', 'อารีย์', 'Ari', 'neighborhood', ARRAY['อารีย์','อารี','ari'], 13.7798, 100.5441, 95),
    ('neighborhood-bang-na', 'บางนา', 'Bang Na', 'neighborhood', ARRAY['บางนา','bangna','bang na'], 13.6682, 100.6047, 90),
    ('neighborhood-siam', 'สยาม', 'Siam', 'neighborhood', ARRAY['สยาม','siam'], 13.7456, 100.5341, 90),
    ('district-sathon', 'สาทร', 'Sathon', 'district', ARRAY['สาทร','สาธร','sathon','sathorn'], 13.7210, 100.5300, 85),
    ('district-phaya-thai', 'พญาไท', 'Phaya Thai', 'district', ARRAY['พญาไท','phaya thai','พญาไท'], 13.7800, 100.5420, 80)
ON CONFLICT (code) DO UPDATE SET
    name_th = EXCLUDED.name_th,
    name_en = EXCLUDED.name_en,
    location_type = EXCLUDED.location_type,
    aliases = EXCLUDED.aliases,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude,
    priority = EXCLUDED.priority,
    is_active = true,
    updated_at = now();

CREATE TABLE IF NOT EXISTS public.search_aliases (
    id bigserial PRIMARY KEY,
    phrase text NOT NULL,
    normalized_phrase text NOT NULL,
    intent_type text NOT NULL,
    intent_value text NOT NULL,
    locale text NOT NULL DEFAULT 'th',
    priority integer NOT NULL DEFAULT 0,
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (normalized_phrase, intent_type, intent_value),
    CHECK (intent_type IN ('property_type','property_group','use_case','offer_type','feature'))
);

CREATE INDEX IF NOT EXISTS idx_search_aliases_lookup
    ON public.search_aliases(intent_type, normalized_phrase)
    WHERE is_active = true;
CREATE INDEX IF NOT EXISTS idx_search_aliases_phrase_trgm
    ON public.search_aliases USING gin (normalized_phrase gin_trgm_ops);

INSERT INTO public.search_aliases (phrase, normalized_phrase, intent_type, intent_value, locale, priority)
VALUES
    ('คอนโด', 'คอนโด', 'property_type', 'condo', 'th', 100),
    ('คอนโดมิเนียม', 'คอนโดมิเนียม', 'property_type', 'condo', 'th', 90),
    ('condo', 'condo', 'property_type', 'condo', 'en', 100),
    ('บ้าน', 'บ้าน', 'property_group', 'residential', 'th', 60),
    ('บ้านเดี่ยว', 'บ้านเดี่ยว', 'property_type', 'detached_house', 'th', 100),
    ('บ้านแฝด', 'บ้านแฝด', 'property_type', 'semi_detached_house', 'th', 100),
    ('ทาวน์เฮ้าส์', 'ทาวน์เฮ้าส์', 'property_type', 'townhouse', 'th', 100),
    ('ทาวน์โฮม', 'ทาวน์โฮม', 'property_type', 'townhouse', 'th', 100),
    ('หอพัก', 'หอพัก', 'property_type', 'dormitory', 'th', 100),
    ('อพาร์ตเมนต์', 'อพาร์ตเมนต์', 'property_type', 'apartment', 'th', 100),
    ('อะพาร์ตเมนต์', 'อะพาร์ตเมนต์', 'property_type', 'apartment', 'th', 80),
    ('ตึกแถว', 'ตึกแถว', 'property_type', 'shophouse', 'th', 100),
    ('อาคารพาณิชย์', 'อาคารพาณิชย์', 'property_type', 'shophouse', 'th', 100),
    ('โฮมออฟฟิศ', 'โฮมออฟฟิศ', 'property_type', 'home_office', 'th', 100),
    ('สำนักงาน', 'สำนักงาน', 'property_type', 'office', 'th', 100),
    ('ออฟฟิศ', 'ออฟฟิศ', 'property_type', 'office', 'th', 95),
    ('ร้านค้า', 'ร้านค้า', 'property_type', 'retail_space', 'th', 90),
    ('ร้าน', 'ร้าน', 'property_type', 'retail_space', 'th', 70),
    ('พื้นที่ค้าขาย', 'พื้นที่ค้าขาย', 'property_type', 'retail_space', 'th', 100),
    ('โกดัง', 'โกดัง', 'property_type', 'warehouse', 'th', 100),
    ('คลังสินค้า', 'คลังสินค้า', 'property_type', 'warehouse', 'th', 95),
    ('โรงงาน', 'โรงงาน', 'property_type', 'factory', 'th', 100),
    ('ที่ดิน', 'ที่ดิน', 'property_type', 'land', 'th', 100),
    ('ซื้อ', 'ซื้อ', 'offer_type', 'sale', 'th', 100),
    ('ขาย', 'ขาย', 'offer_type', 'sale', 'th', 90),
    ('เช่า', 'เช่า', 'offer_type', 'rent', 'th', 100),
    ('ให้เช่า', 'ให้เช่า', 'offer_type', 'rent', 'th', 90),
    ('เซ้ง', 'เซ้ง', 'offer_type', 'business_transfer', 'th', 100),
    ('โอนกิจการ', 'โอนกิจการ', 'offer_type', 'business_transfer', 'th', 90),
    ('เปิดร้านอาหาร', 'เปิดร้านอาหาร', 'use_case', 'food_service', 'th', 100),
    ('ร้านอาหาร', 'ร้านอาหาร', 'use_case', 'food_service', 'th', 90),
    ('ทำออฟฟิศ', 'ทำออฟฟิศ', 'use_case', 'office', 'th', 90),
    ('เก็บสินค้า', 'เก็บสินค้า', 'use_case', 'storage', 'th', 90),
    ('ทำเกษตร', 'ทำเกษตร', 'use_case', 'agriculture', 'th', 90),
    ('เลี้ยงสัตว์ได้', 'เลี้ยงสัตว์ได้', 'feature', 'pet_allowed', 'th', 100),
    ('pet friendly', 'pet friendly', 'feature', 'pet_allowed', 'en', 100),
    ('ติดทะเล', 'ติดทะเล', 'feature', 'near_sea', 'th', 90),
    ('ใกล้รถไฟฟ้า', 'ใกล้รถไฟฟ้า', 'feature', 'near_transit', 'th', 90)
ON CONFLICT (normalized_phrase, intent_type, intent_value) DO UPDATE SET
    phrase = EXCLUDED.phrase,
    locale = EXCLUDED.locale,
    priority = EXCLUDED.priority,
    is_active = true,
    updated_at = now();

ALTER TABLE public.listings
    ADD COLUMN IF NOT EXISTS location_id bigint REFERENCES public.search_locations(id),
    ADD COLUMN IF NOT EXISTS province_name text,
    ADD COLUMN IF NOT EXISTS district_name text,
    ADD COLUMN IF NOT EXISTS subdistrict_name text,
    ADD COLUMN IF NOT EXISTS search_text text NOT NULL DEFAULT '';

CREATE OR REPLACE FUNCTION public.refresh_listing_search_text()
RETURNS trigger AS $$
BEGIN
    NEW.search_text := lower(concat_ws(' ',
        NEW.title,
        NEW.description,
        NEW.custom_project_name,
        NEW.address_line1,
        NEW.address_line2,
        NEW.province_name,
        NEW.district_name,
        NEW.subdistrict_name,
        NEW.property_type_code,
        NEW.usage_type,
        NEW.listing_type
    ));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_listings_refresh_search_text ON public.listings;
CREATE TRIGGER trg_listings_refresh_search_text
BEFORE INSERT OR UPDATE OF title, description, custom_project_name, address_line1,
    address_line2, province_name, district_name, subdistrict_name,
    property_type_code, usage_type, listing_type
ON public.listings
FOR EACH ROW EXECUTE FUNCTION public.refresh_listing_search_text();

UPDATE public.listings SET search_text = lower(concat_ws(' ',
    title, description, custom_project_name, address_line1, address_line2,
    province_name, district_name, subdistrict_name,
    property_type_code, usage_type, listing_type
));

CREATE INDEX IF NOT EXISTS idx_listings_search_text_trgm
    ON public.listings USING gin (search_text gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_listings_location_status
    ON public.listings(location_id, listing_status, moderation_status);
CREATE INDEX IF NOT EXISTS idx_listings_property_status
    ON public.listings(property_type_code, listing_status, moderation_status);

CREATE TABLE IF NOT EXISTS public.search_query_events (
    id bigserial PRIMARY KEY,
    query_text text NOT NULL,
    normalized_query text NOT NULL,
    parsed_intent jsonb NOT NULL DEFAULT '{}'::jsonb,
    result_count integer,
    session_key text,
    user_id bigint REFERENCES public.auth_users(id) ON DELETE SET NULL,
    source text NOT NULL DEFAULT 'web',
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_search_query_events_created_at
    ON public.search_query_events(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_search_query_events_no_results
    ON public.search_query_events(normalized_query, created_at DESC)
    WHERE result_count = 0;

COMMIT;
