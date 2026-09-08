BEGIN;

-- A project is the physical development that contains properties. It is not
-- the organization that publishes a listing, and it is not the developer.
-- Thai and English names (plus spelling/transliteration variants) resolve to
-- one project row so every listing and search result shares one identity.
CREATE OR REPLACE FUNCTION public.normalize_project_search_name(value text)
RETURNS text AS $$
    SELECT lower(regexp_replace(COALESCE(value, ''), '[[:space:][:punct:]]+', '', 'g'));
$$ LANGUAGE sql IMMUTABLE PARALLEL SAFE;

CREATE TABLE IF NOT EXISTS public.property_projects (
    id bigserial PRIMARY KEY,
    public_project_id uuid NOT NULL UNIQUE,
    slug varchar(180) NOT NULL UNIQUE,
    project_category varchar(40) NOT NULL,
    name_th varchar(240) NOT NULL,
    name_en varchar(240),
    developer_organization_id bigint REFERENCES public.organizations(id) ON DELETE SET NULL,
    developer_name_th varchar(240),
    developer_name_en varchar(240),
    supported_property_types text[] NOT NULL DEFAULT ARRAY[]::text[],
    description_th text,
    description_en text,
    address_line1 text,
    road text,
    subdistrict_name text,
    district_name text,
    province_name text,
    postal_code varchar(20),
    latitude numeric(10,7),
    longitude numeric(10,7),
    official_website_url text,
    source_url text,
    verification_status varchar(32) NOT NULL DEFAULT 'unverified',
    verification_note text,
    search_text text NOT NULL DEFAULT '',
    metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    deleted_at timestamptz,
    CHECK (project_category IN (
        'housing_estate',
        'condominium',
        'mixed_use',
        'commercial_complex',
        'office_campus',
        'industrial_estate',
        'other'
    )),
    CHECK (verification_status IN ('unverified', 'source_checked', 'verified')),
    CHECK (slug ~ '^[a-z0-9]+(?:-[a-z0-9]+)*$'),
    CHECK (latitude IS NULL OR latitude BETWEEN -90 AND 90),
    CHECK (longitude IS NULL OR longitude BETWEEN -180 AND 180)
);

CREATE OR REPLACE FUNCTION public.refresh_property_project_search_text()
RETURNS trigger AS $$
BEGIN
    NEW.search_text := lower(concat_ws(' ',
        NEW.name_th,
        NEW.name_en,
        NEW.developer_name_th,
        NEW.developer_name_en,
        NEW.address_line1,
        NEW.road,
        NEW.subdistrict_name,
        NEW.district_name,
        NEW.province_name,
        NEW.postal_code
    ));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_property_projects_refresh_search_text ON public.property_projects;
CREATE TRIGGER trg_property_projects_refresh_search_text
BEFORE INSERT OR UPDATE OF name_th, name_en, developer_name_th, developer_name_en,
    address_line1, road, subdistrict_name, district_name, province_name, postal_code
ON public.property_projects
FOR EACH ROW EXECUTE FUNCTION public.refresh_property_project_search_text();

CREATE INDEX IF NOT EXISTS idx_property_projects_search_text_trgm
    ON public.property_projects USING gin (search_text gin_trgm_ops)
    WHERE is_active = true AND deleted_at IS NULL;

CREATE INDEX IF NOT EXISTS idx_property_projects_category_active
    ON public.property_projects(project_category, name_th, id)
    WHERE is_active = true AND deleted_at IS NULL;

CREATE TABLE IF NOT EXISTS public.property_project_aliases (
    id bigserial PRIMARY KEY,
    project_id bigint NOT NULL REFERENCES public.property_projects(id) ON DELETE CASCADE,
    locale varchar(8) NOT NULL DEFAULT 'und',
    alias_name varchar(240) NOT NULL,
    normalized_alias text GENERATED ALWAYS AS (
        public.normalize_project_search_name(alias_name)
    ) STORED,
    alias_type varchar(24) NOT NULL DEFAULT 'alternate',
    is_searchable boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now(),
    CHECK (locale IN ('th', 'en', 'und')),
    CHECK (alias_type IN ('official', 'alternate', 'transliteration', 'legacy')),
    CHECK (btrim(alias_name) <> '')
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_property_project_alias_normalized
    ON public.property_project_aliases(project_id, locale, normalized_alias);

CREATE INDEX IF NOT EXISTS idx_property_project_alias_name_trgm
    ON public.property_project_aliases USING gin (lower(alias_name) gin_trgm_ops)
    WHERE is_searchable = true;

CREATE INDEX IF NOT EXISTS idx_property_project_alias_normalized_trgm
    ON public.property_project_aliases USING gin (normalized_alias gin_trgm_ops)
    WHERE is_searchable = true;

CREATE TABLE IF NOT EXISTS public.property_project_amenities (
    project_id bigint NOT NULL REFERENCES public.property_projects(id) ON DELETE CASCADE,
    amenity_code varchar(64) NOT NULL,
    label_th varchar(160) NOT NULL,
    label_en varchar(160),
    source_url text,
    created_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (project_id, amenity_code),
    CHECK (amenity_code ~ '^[a-z][a-z0-9_]*$')
);

ALTER TABLE public.listings
    ADD COLUMN IF NOT EXISTS project_id bigint;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'listings_project_fkey'
    ) THEN
        ALTER TABLE public.listings
            ADD CONSTRAINT listings_project_fkey
            FOREIGN KEY (project_id) REFERENCES public.property_projects(id) ON DELETE SET NULL;
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_listings_project_active
    ON public.listings(project_id, published_at DESC, id DESC)
    WHERE project_id IS NOT NULL AND deleted_at IS NULL;

DO $$
DECLARE
    kkp_user_id bigint;
    kkp_organization_id bigint;
    connect_project_id bigint;
    property_listing_id bigint;
BEGIN
    SELECT id INTO kkp_user_id
    FROM public.auth_users
    WHERE lower(email) = 'kkpcontactcenter@kkpfg.com'
      AND deleted_at IS NULL
    ORDER BY id
    LIMIT 1;

    SELECT id INTO kkp_organization_id
    FROM public.organizations
    WHERE slug = 'kkppropify'
      AND is_active = true
      AND deleted_at IS NULL
    LIMIT 1;

    IF kkp_user_id IS NULL OR kkp_organization_id IS NULL THEN
        RAISE EXCEPTION 'Verified KKPPropify user and organization are required before importing B-0783';
    END IF;

    INSERT INTO public.property_projects (
        public_project_id,
        slug,
        project_category,
        name_th,
        name_en,
        developer_name_th,
        developer_name_en,
        supported_property_types,
        description_th,
        description_en,
        subdistrict_name,
        district_name,
        province_name,
        postal_code,
        latitude,
        longitude,
        official_website_url,
        source_url,
        verification_status,
        verification_note,
        metadata
    ) VALUES (
        '0c5c87df-b52a-4af0-83c0-71b338898e75',
        'the-connect-wongwaen-rama-9',
        'housing_estate',
        'เดอะ คอนเนค วงแหวน-พระราม 9',
        'The Connect Wongwaen-Rama 9',
        'บริษัท พฤกษา เรียลเอสเตท จำกัด (มหาชน)',
        'Pruksa Real Estate Public Company Limited',
        ARRAY['townhouse'],
        'โครงการทาวน์โฮมแบรนด์เดอะ คอนเนค บนทำเลวงแหวน-พระราม 9',
        'A The Connect townhouse development in the Wongwaen–Rama 9 area.',
        'ประเวศ',
        'ประเวศ',
        'กรุงเทพมหานคร',
        '10250',
        13.6999565,
        100.6754809,
        'https://www.pruksa.com/about-pruksa/press/news168',
        'https://kkppropify.kkpfg.com/th/products/b-0783',
        'source_checked',
        'Project identity and developer were cross-checked against the KKPPropify asset page and Pruksa public information. Exact house details remain listing-level data.',
        jsonb_build_object(
            'brand', 'The Connect',
            'source_reference', 'B-0783',
            'location_precision', 'project_and_listing_coordinates'
        )
    )
    ON CONFLICT (slug) DO UPDATE SET
        project_category = EXCLUDED.project_category,
        name_th = EXCLUDED.name_th,
        name_en = EXCLUDED.name_en,
        developer_name_th = EXCLUDED.developer_name_th,
        developer_name_en = EXCLUDED.developer_name_en,
        supported_property_types = EXCLUDED.supported_property_types,
        description_th = EXCLUDED.description_th,
        description_en = EXCLUDED.description_en,
        subdistrict_name = EXCLUDED.subdistrict_name,
        district_name = EXCLUDED.district_name,
        province_name = EXCLUDED.province_name,
        postal_code = EXCLUDED.postal_code,
        latitude = EXCLUDED.latitude,
        longitude = EXCLUDED.longitude,
        official_website_url = EXCLUDED.official_website_url,
        source_url = EXCLUDED.source_url,
        verification_status = EXCLUDED.verification_status,
        verification_note = EXCLUDED.verification_note,
        metadata = EXCLUDED.metadata,
        is_active = true,
        deleted_at = NULL,
        updated_at = now()
    RETURNING id INTO connect_project_id;

    INSERT INTO public.property_project_aliases (
        project_id, locale, alias_name, alias_type
    ) VALUES
        (connect_project_id, 'th', 'เดอะ คอนเนค วงแหวน-พระราม 9', 'official'),
        (connect_project_id, 'th', 'เดอะ คอนเน็ค วงแหวน-พระราม 9', 'alternate'),
        (connect_project_id, 'th', 'หมู่บ้านเดอะ คอนเนค วงแหวน-พระราม 9', 'alternate'),
        (connect_project_id, 'th', 'เดอะ คอนเนค วงแหวน-พระรามเก้า', 'alternate'),
        (connect_project_id, 'en', 'The Connect Wongwaen-Rama 9', 'official'),
        (connect_project_id, 'en', 'The Connect Wongwaen-Rama IX', 'alternate')
    ON CONFLICT (project_id, locale, normalized_alias) DO NOTHING;

    INSERT INTO public.property_project_amenities (
        project_id, amenity_code, label_th, label_en, source_url
    ) VALUES
        (connect_project_id, 'fitness', 'ฟิตเนส', 'Fitness', 'https://kkppropify.kkpfg.com/th/products/b-0783'),
        (connect_project_id, 'pet_area', 'พื้นที่สำหรับสัตว์เลี้ยง', 'Pet area', 'https://kkppropify.kkpfg.com/th/products/b-0783'),
        (connect_project_id, 'swimming_pool', 'สระว่ายน้ำ', 'Swimming pool', 'https://kkppropify.kkpfg.com/th/products/b-0783'),
        (connect_project_id, 'parking', 'ที่จอดรถ', 'Parking', 'https://kkppropify.kkpfg.com/th/products/b-0783')
    ON CONFLICT (project_id, amenity_code) DO UPDATE SET
        label_th = EXCLUDED.label_th,
        label_en = EXCLUDED.label_en,
        source_url = EXCLUDED.source_url;

    SELECT id INTO property_listing_id
    FROM public.listings
    WHERE slug = 'townhouse-the-connect-wongwaen-rama-9-b-0783'
    LIMIT 1;

    IF property_listing_id IS NULL THEN
        INSERT INTO public.listings (
            public_listing_id,
            user_id,
            organization_id,
            created_by_user_id,
            published_by_user_id,
            project_id,
            property_type_code,
            usage_type,
            listing_type,
            listing_scope,
            custom_project_name,
            custom_unit_number,
            title,
            description,
            sale_price,
            price_negotiable,
            land_area_sqm,
            bedroom_count,
            bathroom_count,
            pet_allowed,
            contact_name,
            contact_phone,
            show_phone,
            show_email,
            address_line1,
            address_line2,
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
            moderation_submitted_at,
            moderated_at,
            is_verified,
            is_active,
            source_channel,
            price_unit,
            slug
        ) VALUES (
            '48fcbf20-7187-4a32-b683-c50f40db7f4d',
            kkp_user_id,
            kkp_organization_id,
            kkp_user_id,
            kkp_user_id,
            connect_project_id,
            'townhouse',
            'residence',
            'sale',
            'whole_property',
            'เดอะ คอนเนค วงแหวน-พระราม 9',
            '199/129',
            'ขายทาวน์โฮม 3 ห้องนอน เดอะ คอนเนค วงแหวน-พระราม 9 ราคา 3.168 ล้านบาท',
            E'ทาวน์โฮมในโครงการเดอะ คอนเนค วงแหวน-พระราม 9 เนื้อที่ 18.2 ตร.ว. 3 ห้องนอน 3 ห้องน้ำ\n\nบ้านว่าง ภายในโทนสว่าง มีพื้นที่จอดรถหน้าบ้าน เหมาะสำหรับอยู่อาศัย ใกล้เส้นทางวงแหวนและพระราม 9\n\nราคาพิเศษ 3,168,000 บาท จากราคาประกาศเดิม 3,300,000 บาท\n\nติดต่อบริษัท จัซแมทช์ จำกัด โทร. 02-495-4506 รหัสทรัพย์ B-0783\n\nข้อมูลและรูปภาพนำเข้าจาก KKPPropify เมื่อวันที่ 8 กันยายน 2569 ผู้ซื้อควรตรวจสอบสภาพทรัพย์ เอกสารสิทธิ์ ค่าใช้จ่าย และเงื่อนไขกับผู้ดูแลก่อนตัดสินใจ',
            3168000,
            false,
            72.8,
            3,
            3,
            false,
            'บริษัท จัซแมทช์ จำกัด',
            '024954506',
            true,
            false,
            '199/129',
            'โครงการเดอะ คอนเนค วงแหวน-พระราม 9',
            '10250',
            13.6999565,
            100.6754809,
            'กรุงเทพมหานคร',
            'ประเวศ',
            'ประเวศ',
            'active',
            'approved',
            now(),
            now(),
            now(),
            now(),
            true,
            true,
            'editorial_import',
            'total',
            'townhouse-the-connect-wongwaen-rama-9-b-0783'
        )
        RETURNING id INTO property_listing_id;
    ELSE
        UPDATE public.listings
        SET organization_id = kkp_organization_id,
            created_by_user_id = COALESCE(created_by_user_id, kkp_user_id),
            published_by_user_id = COALESCE(published_by_user_id, kkp_user_id),
            project_id = connect_project_id,
            custom_project_name = 'เดอะ คอนเนค วงแหวน-พระราม 9',
            sale_price = 3168000,
            land_area_sqm = 72.8,
            bedroom_count = 3,
            bathroom_count = 3,
            contact_name = 'บริษัท จัซแมทช์ จำกัด',
            contact_phone = '024954506',
            latitude = 13.6999565,
            longitude = 100.6754809,
            is_verified = true,
            is_active = true,
            deleted_at = NULL,
            updated_at = now()
        WHERE id = property_listing_id;
    END IF;

    INSERT INTO public.listing_use_cases (listing_id, use_case_code)
    VALUES (property_listing_id, 'residential')
    ON CONFLICT (listing_id, use_case_code) DO NOTHING;

    INSERT INTO public.listing_offers (
        listing_id, offer_type, amount, price_unit, currency_code, is_negotiable
    ) VALUES (
        property_listing_id, 'sale', 3168000, 'total', 'THB', false
    )
    ON CONFLICT (listing_id, offer_type) DO UPDATE SET
        amount = EXCLUDED.amount,
        price_unit = EXCLUDED.price_unit,
        currency_code = EXCLUDED.currency_code,
        is_negotiable = EXCLUDED.is_negotiable,
        updated_at = now();

    INSERT INTO public.listing_discovery_channels (
        listing_id, channel_code, source, is_featured
    ) VALUES (
        property_listing_id, 'homes', 'editorial', false
    )
    ON CONFLICT (listing_id, channel_code) DO UPDATE SET
        source = EXCLUDED.source,
        is_featured = EXCLUDED.is_featured,
        updated_at = now();

    INSERT INTO public.listing_category_details (
        listing_id, category_code, schema_version, details, is_minimum_submission
    ) VALUES (
        property_listing_id,
        'townhouse',
        1,
        jsonb_build_object(
            'land_area_square_wah', 18.2,
            'original_price', 3300000,
            'special_price', 3168000,
            'source_property_id', 'B-0783',
            'source_posted_on', '2026-05-11',
            'source_content_id', 35391,
            'source_agent_code', 'JZM001',
            'source_agent_verified', true,
            'source_is_npa', false,
            'data_provenance', 'KKPPropify public asset page'
        ),
        true
    )
    ON CONFLICT (listing_id) DO UPDATE SET
        category_code = EXCLUDED.category_code,
        schema_version = EXCLUDED.schema_version,
        details = EXCLUDED.details,
        is_minimum_submission = EXCLUDED.is_minimum_submission,
        updated_at = now();

    INSERT INTO public.listing_contact_profiles (
        listing_id,
        role_code,
        authority_source_code,
        organization_name,
        verification_status,
        verification_note,
        verified_at,
        organization_id,
        contact_user_id
    ) VALUES (
        property_listing_id,
        'agency_broker',
        'brokerage_company',
        'บริษัท จัซแมทช์ จำกัด',
        'identity_verified',
        'KKPPropify marks the property consultant profile as Verified; MapxProp has not independently verified listing authority.',
        now(),
        NULL,
        NULL
    )
    ON CONFLICT (listing_id) DO UPDATE SET
        role_code = EXCLUDED.role_code,
        authority_source_code = EXCLUDED.authority_source_code,
        organization_name = EXCLUDED.organization_name,
        verification_status = EXCLUDED.verification_status,
        verification_note = EXCLUDED.verification_note,
        verified_at = EXCLUDED.verified_at,
        organization_id = EXCLUDED.organization_id,
        contact_user_id = EXCLUDED.contact_user_id,
        updated_at = now();

    INSERT INTO public.listing_amenities (listing_id, amenity_code)
    VALUES
        (property_listing_id, 'fitness'),
        (property_listing_id, 'pet_area'),
        (property_listing_id, 'swimming_pool'),
        (property_listing_id, 'parking')
    ON CONFLICT (listing_id, amenity_code) DO NOTHING;

    INSERT INTO public.listing_media (
        listing_id, media_type, source_type, role_code, title, alt_text,
        original_url, file_url, mime_type, file_size_bytes, width, height,
        sort_order, is_primary, is_active
    ) VALUES
        (property_listing_id, 'image', 'editorial_import', 'cover', 'หน้าบ้าน', 'หน้าทาวน์โฮมเลขที่ 199/129 ในโครงการเดอะ คอนเนค วงแหวน-พระราม 9', 'https://media.kkpfg.com/npa/property/B-0783/1.jpeg', '/listing-media/kkppropify/b-0783/01.webp', 'image/webp', 517254, 1894, 2400, 10, true, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ที่จอดรถหน้าบ้าน', 'พื้นที่จอดรถและทางเข้าหน้าทาวน์โฮม', 'https://media.kkpfg.com/npa/property/B-0783/2.jpeg', '/listing-media/kkppropify/b-0783/02.webp', 'image/webp', 577468, 1800, 2400, 20, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงชั้นล่าง', 'โถงภายในชั้นล่างของทาวน์โฮม', 'https://media.kkpfg.com/npa/property/B-0783/3.jpeg', '/listing-media/kkppropify/b-0783/03.webp', 'image/webp', 79560, 1800, 2400, 30, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่ชั้นล่าง', 'พื้นที่ใช้สอยภายในชั้นล่าง', 'https://media.kkpfg.com/npa/property/B-0783/4.jpeg', '/listing-media/kkppropify/b-0783/04.webp', 'image/webp', 294204, 1800, 2400, 40, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องโถง', 'ห้องโถงภายในบ้านมุมที่หนึ่ง', 'https://media.kkpfg.com/npa/property/B-0783/5.jpeg', '/listing-media/kkppropify/b-0783/05.webp', 'image/webp', 65782, 1800, 2400, 50, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องโถงอีกมุม', 'ห้องโถงภายในบ้านมุมที่สอง', 'https://media.kkpfg.com/npa/property/B-0783/6.jpeg', '/listing-media/kkppropify/b-0783/06.webp', 'image/webp', 104202, 1800, 2400, 60, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'บันไดภายในบ้าน', 'บันไดเชื่อมระหว่างชั้นของทาวน์โฮม', 'https://media.kkpfg.com/npa/property/B-0783/8.jpeg', '/listing-media/kkppropify/b-0783/08.webp', 'image/webp', 124644, 1800, 2400, 80, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'โถงชั้นบน', 'โถงทางเดินภายในชั้นบน', 'https://media.kkpfg.com/npa/property/B-0783/9.jpeg', '/listing-media/kkppropify/b-0783/09.webp', 'image/webp', 130876, 1800, 2400, 90, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอน', 'ห้องนอนภายในทาวน์โฮม', 'https://media.kkpfg.com/npa/property/B-0783/10.jpeg', '/listing-media/kkppropify/b-0783/10.webp', 'image/webp', 227430, 1800, 2400, 100, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนมุมหน้าต่าง', 'ห้องนอนพร้อมหน้าต่างรับแสง', 'https://media.kkpfg.com/npa/property/B-0783/11.jpeg', '/listing-media/kkppropify/b-0783/11.webp', 'image/webp', 266154, 1800, 2400, 110, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนอีกห้อง', 'ห้องนอนอีกห้องภายในบ้าน', 'https://media.kkpfg.com/npa/property/B-0783/12.jpeg', '/listing-media/kkppropify/b-0783/12.webp', 'image/webp', 305612, 1800, 2400, 120, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่อาบน้ำ', 'พื้นที่อาบน้ำภายในห้องน้ำ', 'https://media.kkpfg.com/npa/property/B-0783/13.jpeg', '/listing-media/kkppropify/b-0783/13.webp', 'image/webp', 218562, 1800, 2400, 130, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำ', 'ห้องน้ำพร้อมสุขภัณฑ์และชั้นวาง', 'https://media.kkpfg.com/npa/property/B-0783/14.jpeg', '/listing-media/kkppropify/b-0783/14.webp', 'image/webp', 149504, 1800, 2400, 140, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำอีกมุม', 'ห้องน้ำภายในบ้านมุมที่สอง', 'https://media.kkpfg.com/npa/property/B-0783/15.jpeg', '/listing-media/kkppropify/b-0783/15.webp', 'image/webp', 152188, 1800, 2400, 150, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำพร้อมส่วนอาบน้ำ', 'ห้องน้ำพร้อมฉากกั้นพื้นที่อาบน้ำ', 'https://media.kkpfg.com/npa/property/B-0783/16.jpeg', '/listing-media/kkppropify/b-0783/16.webp', 'image/webp', 225430, 1800, 2400, 160, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องนอนมุมที่สอง', 'ห้องนอนภายในบ้านพร้อมพื้นลายไม้', 'https://media.kkpfg.com/npa/property/B-0783/17.jpeg', '/listing-media/kkppropify/b-0783/17.webp', 'image/webp', 175614, 1800, 2400, 170, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำพร้อมฉากกั้น', 'ห้องน้ำพร้อมพื้นที่อาบน้ำแบบมีฉากกั้น', 'https://media.kkpfg.com/npa/property/B-0783/18.jpeg', '/listing-media/kkppropify/b-0783/18.webp', 'image/webp', 241998, 1800, 2400, 180, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'ห้องน้ำชั้นล่าง', 'ห้องน้ำขนาดกะทัดรัดภายในบ้าน', 'https://media.kkpfg.com/npa/property/B-0783/19.jpeg', '/listing-media/kkppropify/b-0783/19.webp', 'image/webp', 288680, 1800, 2400, 190, false, true),
        (property_listing_id, 'image', 'editorial_import', 'gallery', 'พื้นที่บริการหลังบ้าน', 'พื้นที่ซักล้างและถังเก็บน้ำหลังบ้าน', 'https://media.kkpfg.com/npa/property/B-0783/20.jpeg', '/listing-media/kkppropify/b-0783/20.webp', 'image/webp', 274378, 1800, 2400, 200, false, true)
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
        property_listing_id,
        'editorial_import',
        'KKPPropify',
        'https://kkppropify.kkpfg.com/th/products/b-0783',
        'B-0783',
        '2026-09-08 00:00:00+07',
        'Imported from the public KKPPropify asset page. The page names Juzzmatch Co., Ltd. as the verified property consultant, code JZM001, and reports isNPA=false. Images are preserved without a MapxProp watermark; MapxProp stores optimized copies and retains each original source URL.'
    )
    ON CONFLICT (listing_id, source_type, reference_code) DO UPDATE SET
        publisher_name = EXCLUDED.publisher_name,
        source_url = EXCLUDED.source_url,
        captured_at = EXCLUDED.captured_at,
        notes = EXCLUDED.notes;
END $$;

COMMIT;
