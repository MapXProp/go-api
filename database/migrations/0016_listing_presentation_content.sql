BEGIN;

-- Category-specific facts remain in listing_category_details.details.  These
-- tables hold the editorial and relationship data that must be rendered from
-- the database, without hard-coding one listing's copy in a React page.
CREATE TABLE IF NOT EXISTS public.property_category_schemas (
    category_code varchar(80) PRIMARY KEY,
    schema_version integer NOT NULL DEFAULT 1 CHECK (schema_version > 0),
    display_name_th text NOT NULL,
    display_name_en text NOT NULL DEFAULT '',
    definition jsonb NOT NULL DEFAULT '{}'::jsonb,
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.listing_content_blocks (
    id bigserial PRIMARY KEY,
    listing_id bigint NOT NULL REFERENCES public.listings(id) ON DELETE CASCADE,
    block_code varchar(80) NOT NULL,
    block_type varchar(40) NOT NULL,
    heading_th text NOT NULL DEFAULT '',
    heading_en text NOT NULL DEFAULT '',
    body_th text NOT NULL DEFAULT '',
    body_en text NOT NULL DEFAULT '',
    content jsonb NOT NULL DEFAULT '[]'::jsonb,
    sort_order integer NOT NULL DEFAULT 0,
    is_visible boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (listing_id, block_code),
    CHECK (block_type IN ('rich_text', 'feature_cards', 'bullet_list', 'notice', 'faq'))
);

CREATE INDEX IF NOT EXISTS idx_listing_content_blocks_listing_sort
    ON public.listing_content_blocks(listing_id, sort_order, id);

CREATE TABLE IF NOT EXISTS public.listing_nearby_places (
    id bigserial PRIMARY KEY,
    listing_id bigint NOT NULL REFERENCES public.listings(id) ON DELETE CASCADE,
    place_name_th text NOT NULL,
    place_name_en text NOT NULL DEFAULT '',
    place_type_code varchar(40) NOT NULL DEFAULT 'landmark',
    distance_meters integer,
    travel_time_minutes integer,
    latitude numeric(10,7),
    longitude numeric(10,7),
    sort_order integer NOT NULL DEFAULT 0,
    is_highlight boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (listing_id, place_name_th),
    CHECK (place_type_code IN ('transit', 'road', 'landmark', 'shopping', 'education', 'healthcare', 'government', 'other')),
    CHECK (distance_meters IS NULL OR distance_meters >= 0),
    CHECK (travel_time_minutes IS NULL OR travel_time_minutes >= 0)
);

CREATE INDEX IF NOT EXISTS idx_listing_nearby_places_listing_sort
    ON public.listing_nearby_places(listing_id, sort_order, id);

CREATE TABLE IF NOT EXISTS public.listing_transaction_terms (
    id bigserial PRIMARY KEY,
    listing_id bigint NOT NULL REFERENCES public.listings(id) ON DELETE CASCADE,
    term_code varchar(80) NOT NULL,
    label_th text NOT NULL,
    label_en text NOT NULL DEFAULT '',
    value_th text NOT NULL,
    value_en text NOT NULL DEFAULT '',
    payer_code varchar(32) NOT NULL DEFAULT 'unspecified',
    numeric_value numeric(18,4),
    unit_code varchar(32) NOT NULL DEFAULT '',
    sort_order integer NOT NULL DEFAULT 0,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (listing_id, term_code),
    CHECK (payer_code IN ('buyer', 'seller', 'split', 'broker', 'unspecified'))
);

CREATE INDEX IF NOT EXISTS idx_listing_transaction_terms_listing_sort
    ON public.listing_transaction_terms(listing_id, sort_order, id);

-- This definition is the source of truth for a future schema-driven listing
-- form.  It deliberately lists field keys already stored in listing columns or
-- listing_category_details so the form and detail page use the same data.
INSERT INTO public.property_category_schemas (
    category_code, schema_version, display_name_th, display_name_en, definition, is_active
) VALUES (
    'land',
    1,
    'ที่ดิน',
    'Land',
    jsonb_build_object(
        'groups', jsonb_build_array(
            jsonb_build_object('code', 'land_size', 'label_th', 'ขนาดและแนวแปลง'),
            jsonb_build_object('code', 'land_condition', 'label_th', 'สภาพที่ดินและการเข้าถึง'),
            jsonb_build_object('code', 'sale_terms', 'label_th', 'ราคาและเงื่อนไขการขาย')
        ),
        'fields', jsonb_build_array(
            jsonb_build_object('key', 'land_area_square_wah', 'group', 'land_size', 'type', 'number', 'label_th', 'เนื้อที่ (ตร.ว.)', 'required', true),
            jsonb_build_object('key', 'plot_count', 'group', 'land_size', 'type', 'number', 'label_th', 'จำนวนแปลง', 'required', true),
            jsonb_build_object('key', 'plot_areas_square_wah', 'group', 'land_size', 'type', 'number_list', 'label_th', 'เนื้อที่แต่ละแปลง (ตร.ว.)'),
            jsonb_build_object('key', 'road_frontage_meters', 'group', 'land_size', 'type', 'number', 'label_th', 'หน้ากว้างติดถนนรวม (เมตร)'),
            jsonb_build_object('key', 'plot_frontages_meters', 'group', 'land_size', 'type', 'number_list', 'label_th', 'หน้ากว้างแต่ละแปลง (เมตร)'),
            jsonb_build_object('key', 'vacant_land', 'group', 'land_condition', 'type', 'boolean', 'label_th', 'เป็นที่ดินเปล่า'),
            jsonb_build_object('key', 'structures_present', 'group', 'land_condition', 'type', 'boolean', 'label_th', 'มีสิ่งปลูกสร้าง'),
            jsonb_build_object('key', 'vegetation_present', 'group', 'land_condition', 'type', 'boolean', 'label_th', 'มีต้นไม้หรือพืชพรรณ'),
            jsonb_build_object('key', 'road_access', 'group', 'land_condition', 'type', 'select', 'label_th', 'ลักษณะทางเข้า'),
            jsonb_build_object('key', 'price_per_square_wah', 'group', 'sale_terms', 'type', 'currency', 'label_th', 'ราคาต่อตารางวา'),
            jsonb_build_object('key', 'sale_together_only', 'group', 'sale_terms', 'type', 'boolean', 'label_th', 'ขายรวมทุกแปลง'),
            jsonb_build_object('key', 'seller_type', 'group', 'sale_terms', 'type', 'select', 'label_th', 'ผู้ลงประกาศ'),
            jsonb_build_object('key', 'contact_trust_status', 'group', 'sale_terms', 'type', 'select', 'label_th', 'สถานะผู้ติดต่อ')
        )
    ),
    true
)
ON CONFLICT (category_code) DO UPDATE SET
    schema_version = EXCLUDED.schema_version,
    display_name_th = EXCLUDED.display_name_th,
    display_name_en = EXCLUDED.display_name_en,
    definition = EXCLUDED.definition,
    is_active = EXCLUDED.is_active,
    updated_at = now();

DO $$
DECLARE
    land_listing_id bigint;
BEGIN
    SELECT id INTO land_listing_id
    FROM public.listings
    WHERE slug = 'land-for-sale-sutthisan-700-sq-wah'
    LIMIT 1;

    IF land_listing_id IS NULL THEN
        RAISE EXCEPTION 'Sutthisan land listing is required before seeding presentation content';
    END IF;

    INSERT INTO public.listing_content_blocks (
        listing_id, block_code, block_type, heading_th, content, sort_order, is_visible
    ) VALUES (
        land_listing_id,
        'land_highlights',
        'feature_cards',
        'จุดเด่นของแปลง',
        jsonb_build_array(
            jsonb_build_object(
                'title_th', 'ที่ดินแปลงใหญ่ใจกลางเมือง',
                'body_th', 'เนื้อที่รวม 700 ตารางวา เป็น 2 แปลงติดกัน และขายพร้อมกัน'
            ),
            jsonb_build_object(
                'title_th', 'หน้ากว้างติดถนนรวมประมาณ 87 เมตร',
                'body_th', 'ทั้งสองแปลงมีแนวหน้าติดถนนภายในซอย เห็นลักษณะแปลงได้จากภาพประกอบ'
            ),
            jsonb_build_object(
                'title_th', 'บรรยากาศเงียบสงบ เป็นส่วนตัว',
                'body_th', 'รายล้อมด้วยบ้านพักอาศัยและบ้านขนาดใหญ่ เหมาะกับผู้ที่เดินทางด้วยรถยนต์'
            ),
            jsonb_build_object(
                'title_th', 'เชื่อมต่อหลายย่านสะดวก',
                'body_th', 'เดินทางไปสุทธิสาร รัชดาภิเษก ลาดพร้าว และพระราม 9 ได้สะดวก'
            )
        ),
        10,
        true
    )
    ON CONFLICT (listing_id, block_code) DO UPDATE SET
        block_type = EXCLUDED.block_type,
        heading_th = EXCLUDED.heading_th,
        content = EXCLUDED.content,
        sort_order = EXCLUDED.sort_order,
        is_visible = EXCLUDED.is_visible,
        updated_at = now();

    INSERT INTO public.listing_nearby_places (
        listing_id, place_name_th, place_name_en, place_type_code, sort_order, is_highlight
    ) VALUES
        (land_listing_id, 'MRT สุทธิสาร', 'MRT Sutthisan', 'transit', 10, true),
        (land_listing_id, 'ถนนสุทธิสารวินิจฉัย', 'Sutthisan Winitchai Road', 'road', 20, true),
        (land_listing_id, 'ถนนรัชดาภิเษกและย่านลาดพร้าว', 'Ratchadaphisek Road and Lat Phrao area', 'road', 30, true),
        (land_listing_id, 'สถานเอกอัครราชทูตตุรกี', 'Embassy of Türkiye', 'government', 40, true),
        (land_listing_id, 'ศูนย์วัฒนธรรมแห่งประเทศไทย', 'Thailand Cultural Centre', 'landmark', 50, true),
        (land_listing_id, 'Central Rama 9', 'Central Rama 9', 'shopping', 60, true)
    ON CONFLICT (listing_id, place_name_th) DO UPDATE SET
        place_name_en = EXCLUDED.place_name_en,
        place_type_code = EXCLUDED.place_type_code,
        sort_order = EXCLUDED.sort_order,
        is_highlight = EXCLUDED.is_highlight,
        updated_at = now();

    INSERT INTO public.listing_transaction_terms (
        listing_id, term_code, label_th, label_en, value_th, value_en, payer_code, numeric_value, unit_code, sort_order
    ) VALUES
        (land_listing_id, 'transfer_fee', 'ค่าธรรมเนียมการโอน', 'Transfer fee', 'ผู้ซื้อและผู้ขายออกคนละครึ่ง', 'Buyer and seller split equally', 'split', NULL, '', 10),
        (land_listing_id, 'other_transfer_expenses', 'ค่าใช้จ่ายและค่าธรรมเนียมอื่น', 'Other transfer expenses', 'ผู้ซื้อเป็นผู้รับผิดชอบตามเงื่อนไขการซื้อขาย', 'Buyer is responsible subject to sale terms', 'buyer', NULL, '', 20),
        (land_listing_id, 'broker_commission', 'ค่านายหน้า', 'Broker commission', '2%', '2%', 'broker', 2, 'percent', 30)
    ON CONFLICT (listing_id, term_code) DO UPDATE SET
        label_th = EXCLUDED.label_th,
        label_en = EXCLUDED.label_en,
        value_th = EXCLUDED.value_th,
        value_en = EXCLUDED.value_en,
        payer_code = EXCLUDED.payer_code,
        numeric_value = EXCLUDED.numeric_value,
        unit_code = EXCLUDED.unit_code,
        sort_order = EXCLUDED.sort_order,
        updated_at = now();
END $$;

COMMIT;
