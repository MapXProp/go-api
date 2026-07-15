BEGIN;

CREATE TABLE IF NOT EXISTS public.property_groups (
    code text PRIMARY KEY,
    name_th text NOT NULL,
    name_en text NOT NULL,
    description text,
    sort_order integer NOT NULL DEFAULT 0,
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO public.property_groups (code, name_th, name_en, sort_order)
VALUES
    ('residential', 'ที่อยู่อาศัย', 'Residential', 10),
    ('mixed_use', 'อยู่อาศัยและทำธุรกิจ', 'Mixed use', 20),
    ('commercial', 'พื้นที่ธุรกิจ', 'Commercial', 30),
    ('land', 'ที่ดิน', 'Land', 40)
ON CONFLICT (code) DO UPDATE SET
    name_th = EXCLUDED.name_th,
    name_en = EXCLUDED.name_en,
    sort_order = EXCLUDED.sort_order,
    is_active = true,
    updated_at = now();

ALTER TABLE public.property_types
    ADD COLUMN IF NOT EXISTS group_code text,
    ADD COLUMN IF NOT EXISTS aliases text[] NOT NULL DEFAULT '{}';

UPDATE public.property_types
SET group_code = CASE code
    WHEN 'condo' THEN 'residential'
    WHEN 'house' THEN 'residential'
    WHEN 'townhouse' THEN 'residential'
    WHEN 'apartment' THEN 'residential'
    WHEN 'shophouse' THEN 'mixed_use'
    WHEN 'home_office' THEN 'mixed_use'
    WHEN 'office' THEN 'commercial'
    WHEN 'warehouse' THEN 'commercial'
    WHEN 'factory' THEN 'commercial'
    WHEN 'land' THEN 'land'
    ELSE group_code
END
WHERE group_code IS NULL;

INSERT INTO public.property_types
    (code, name_th, name_en, usage_type, description, is_active, sort_order, group_code, aliases)
VALUES
    ('detached_house', 'บ้านเดี่ยว', 'Detached house', 'residence', 'บ้านที่ไม่ใช้ผนังร่วมกับหลังข้างเคียง', true, 10, 'residential', ARRAY['house','single_house']),
    ('semi_detached_house', 'บ้านแฝด', 'Semi-detached house', 'residence', 'บ้านสองหลังที่มีผนังหรือส่วนโครงสร้างเชื่อมกัน', true, 20, 'residential', ARRAY['twin_house','duplex_house']),
    ('townhouse', 'ทาวน์เฮาส์ / ทาวน์โฮม', 'Townhouse', 'mixed', 'บ้านแถวที่ใช้ผนังร่วมกับยูนิตข้างเคียง', true, 30, 'residential', ARRAY['townhome']),
    ('condo', 'คอนโดมิเนียม', 'Condominium', 'residence', 'ห้องชุดในอาคารที่มีกรรมสิทธิ์แยกเป็นยูนิต', true, 40, 'residential', ARRAY['condominium']),
    ('apartment', 'อพาร์ตเมนต์', 'Apartment', 'residence', 'ห้องเช่าหรืออาคารที่มีหลายห้องให้เช่า', true, 50, 'residential', ARRAY['apartment_building']),
    ('dormitory', 'หอพัก', 'Dormitory', 'residence', 'หอพักนักเรียน นักศึกษา หรือคนทำงาน', true, 60, 'residential', ARRAY['dorm','student_accommodation']),
    ('shophouse', 'ตึกแถว / อาคารพาณิชย์', 'Shophouse', 'mixed', 'อาคารแถวที่ใช้พักอาศัยและประกอบธุรกิจได้', true, 70, 'mixed_use', ARRAY['commercial_building','row_building']),
    ('home_office', 'โฮมออฟฟิศ', 'Home office', 'mixed', 'อาคารที่ออกแบบให้พักอาศัยและทำสำนักงาน', true, 80, 'mixed_use', '{}'),
    ('office', 'สำนักงาน / ออฟฟิศ', 'Office', 'business', 'ยูนิตสำนักงาน ชั้นสำนักงาน หรืออาคารสำนักงาน', true, 90, 'commercial', ARRAY['office_unit']),
    ('retail_space', 'พื้นที่ค้าขาย', 'Retail space', 'business', 'ร้านค้า ล็อก คีออส เคาน์เตอร์ หรือพื้นที่ขายสินค้า', true, 100, 'commercial', ARRAY['shop_space','kiosk','stall']),
    ('warehouse', 'โกดัง / คลังสินค้า', 'Warehouse', 'business', 'อาคารสำหรับเก็บสินค้าและงานโลจิสติกส์', true, 110, 'commercial', ARRAY['storage_building']),
    ('factory', 'โรงงาน', 'Factory', 'business', 'อาคารสำหรับการผลิตหรือกิจกรรมอุตสาหกรรม', true, 120, 'commercial', ARRAY['industrial_building']),
    ('land', 'ที่ดิน', 'Land', 'mixed', 'ที่ดินเปล่าหรือที่ดินพร้อมสิ่งปลูกสร้าง', true, 130, 'land', ARRAY['land_plot'])
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

UPDATE public.property_types
SET is_active = false, updated_at = now()
WHERE code = 'house';

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'property_types_group_code_fkey'
    ) THEN
        ALTER TABLE public.property_types
            ADD CONSTRAINT property_types_group_code_fkey
            FOREIGN KEY (group_code) REFERENCES public.property_groups(code);
    END IF;
END $$;

CREATE TABLE IF NOT EXISTS public.use_cases (
    code text PRIMARY KEY,
    name_th text NOT NULL,
    name_en text NOT NULL,
    description text,
    sort_order integer NOT NULL DEFAULT 0,
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO public.use_cases (code, name_th, name_en, sort_order)
VALUES
    ('residential', 'อยู่อาศัย', 'Residential', 10),
    ('office', 'สำนักงาน', 'Office', 20),
    ('retail', 'ร้านค้า', 'Retail', 30),
    ('food_service', 'ร้านอาหารและคาเฟ่', 'Food service', 40),
    ('storage', 'เก็บสินค้า', 'Storage', 50),
    ('industrial', 'อุตสาหกรรม', 'Industrial', 60),
    ('hospitality', 'ธุรกิจที่พัก', 'Hospitality', 70),
    ('agriculture', 'เกษตรกรรม', 'Agriculture', 80)
ON CONFLICT (code) DO UPDATE SET
    name_th = EXCLUDED.name_th,
    name_en = EXCLUDED.name_en,
    sort_order = EXCLUDED.sort_order,
    is_active = true,
    updated_at = now();

CREATE TABLE IF NOT EXISTS public.property_type_use_cases (
    property_type_code text NOT NULL REFERENCES public.property_types(code) ON DELETE CASCADE,
    use_case_code text NOT NULL REFERENCES public.use_cases(code) ON DELETE CASCADE,
    is_default boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (property_type_code, use_case_code)
);

INSERT INTO public.property_type_use_cases (property_type_code, use_case_code, is_default)
VALUES
    ('detached_house', 'residential', true), ('detached_house', 'office', false),
    ('semi_detached_house', 'residential', true), ('semi_detached_house', 'office', false),
    ('townhouse', 'residential', true), ('townhouse', 'office', false), ('townhouse', 'retail', false),
    ('condo', 'residential', true),
    ('apartment', 'residential', true),
    ('dormitory', 'residential', true),
    ('shophouse', 'residential', true), ('shophouse', 'office', false), ('shophouse', 'retail', true), ('shophouse', 'food_service', false), ('shophouse', 'storage', false),
    ('home_office', 'residential', true), ('home_office', 'office', true), ('home_office', 'retail', false),
    ('office', 'office', true),
    ('retail_space', 'retail', true), ('retail_space', 'food_service', false),
    ('warehouse', 'storage', true), ('warehouse', 'industrial', false),
    ('factory', 'industrial', true), ('factory', 'storage', false),
    ('land', 'residential', false), ('land', 'office', false), ('land', 'retail', false), ('land', 'food_service', false),
    ('land', 'storage', false), ('land', 'industrial', false), ('land', 'hospitality', false), ('land', 'agriculture', false)
ON CONFLICT (property_type_code, use_case_code) DO UPDATE SET
    is_default = EXCLUDED.is_default;

ALTER TABLE public.listings
    ADD COLUMN IF NOT EXISTS listing_scope text NOT NULL DEFAULT 'whole_property';

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'listings_listing_scope_check'
    ) THEN
        ALTER TABLE public.listings ADD CONSTRAINT listings_listing_scope_check
            CHECK (listing_scope IN ('single_unit','whole_property','multi_unit','land_plot','space_slot'));
    END IF;
END $$;

CREATE TABLE IF NOT EXISTS public.listing_use_cases (
    listing_id bigint NOT NULL REFERENCES public.listings(id) ON DELETE CASCADE,
    use_case_code text NOT NULL REFERENCES public.use_cases(code),
    created_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (listing_id, use_case_code)
);

CREATE INDEX IF NOT EXISTS idx_listing_use_cases_code_listing
    ON public.listing_use_cases(use_case_code, listing_id);

CREATE TABLE IF NOT EXISTS public.listing_offers (
    id bigserial PRIMARY KEY,
    listing_id bigint NOT NULL REFERENCES public.listings(id) ON DELETE CASCADE,
    offer_type text NOT NULL,
    amount numeric(18,2),
    price_unit text NOT NULL DEFAULT 'total',
    deposit_amount numeric(18,2),
    advance_amount numeric(18,2),
    minimum_contract_months integer,
    service_fee_monthly numeric(18,2),
    is_negotiable boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (listing_id, offer_type),
    CHECK (offer_type IN ('sale','rent','sublease','business_transfer')),
    CHECK (amount IS NULL OR amount >= 0),
    CHECK (minimum_contract_months IS NULL OR minimum_contract_months > 0)
);

CREATE INDEX IF NOT EXISTS idx_listing_offers_search
    ON public.listing_offers(offer_type, amount, listing_id);

INSERT INTO public.business_space_types (code, name_th, name_en, is_active, sort_order)
VALUES
    ('mall_shop', 'ร้านภายในห้าง', 'Mall shop', true, 15),
    ('standalone_shop', 'ร้านค้า Standalone', 'Standalone shop', true, 75)
ON CONFLICT (code) DO UPDATE SET
    name_th = EXCLUDED.name_th,
    name_en = EXCLUDED.name_en,
    is_active = true,
    sort_order = EXCLUDED.sort_order;

COMMIT;
