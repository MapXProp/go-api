BEGIN;

-- Link the Empire Tower and Emsphere event listings to their venues. Project identity
-- is checked against each venue's official website; coordinates and address
-- come from the existing event listing. Event rounds, prices and expiry stay
-- listing-level data and are not changed by this migration.
DO $$
DECLARE
    venue record;
    event_listing record;
    venue_project_id bigint;
BEGIN
    FOR venue IN
        SELECT * FROM (VALUES
            (
                'dedfa51f-0c9c-4279-bdf1-6ebdee2db211',
                'the-empire-tower', 'office_campus',
                'เอ็มไพร์ ทาวเวอร์', 'The Empire Tower',
                ARRAY['office', 'retail_space'],
                'อาคารสำนักงานและพื้นที่ค้าปลีกบนถนนสาทรใต้ รวมประกาศพื้นที่ภายในโครงการ',
                'Office towers and retail spaces on South Sathorn Road, with listings inside the development.',
                'https://www.empirebuilding.co/en/home',
                'food-o-clock-the-empire-tower-2026',
                'aeea1ff0-a2a3-4544-ae1f-930fb53b6cb9',
                ARRAY['อาคารเอ็มไพร์ ทาวเวอร์', 'ดิ เอ็มไพร์', 'เอ็มไพร์', 'เอ็มไพร์ สาทร'],
                ARRAY['The Empire', 'Empire Tower', 'The Empire Tower', 'Empire Tower Sathorn']
            ),
            (
                '8150b057-e70b-422e-9574-4aa6c0de9e9c',
                'emsphere', 'commercial_complex',
                'เอ็มสเฟียร์', 'Emsphere',
                ARRAY['retail_space'],
                'ศูนย์การค้าเอ็มสเฟียร์ ถนนสุขุมวิท รวมประกาศพื้นที่ค้าขายและพื้นที่ออกบูธภายในโครงการ',
                'Emsphere shopping mall on Sukhumvit Road, with retail and event booth listings inside the mall.',
                'https://emsphere.co.th/en/',
                'local-favorites-emsphere-2026',
                '47f922c7-e2b1-489f-b7be-bdf44ddc3b0a',
                ARRAY['ห้างเอ็มสเฟียร์', 'ศูนย์การค้าเอ็มสเฟียร์', 'เอ็ม สเฟียร์'],
                ARRAY['Em Sphere', 'The Emsphere', 'Emsphere Sukhumvit', 'EM MARKET HALL']
            )
        ) AS venues(public_id, slug, category, name_th, name_en, property_types,
                    description_th, description_en, official_url, listing_slug,
                    listing_public_id, aliases_th, aliases_en)
    LOOP
        SELECT id, project_id, latitude, longitude, address_line2, road,
               subdistrict_name, district_name, province_name, postal_code
        INTO event_listing
        FROM public.listings
        WHERE public_listing_id = venue.listing_public_id::uuid
          AND slug = venue.listing_slug
          AND space_type_code = 'event_booth'
          AND deleted_at IS NULL
        FOR UPDATE;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Expected event listing identity is missing: %', venue.listing_slug;
        END IF;

        INSERT INTO public.property_projects (
            public_project_id, slug, project_category, name_th, name_en,
            supported_property_types, description_th, description_en,
            address_line1, road, subdistrict_name, district_name, province_name,
            postal_code, latitude, longitude, official_website_url, source_url,
            verification_status, verification_note, metadata
        ) VALUES (
            venue.public_id::uuid, venue.slug, venue.category, venue.name_th, venue.name_en,
            venue.property_types, venue.description_th, venue.description_en,
            event_listing.address_line2, event_listing.road, event_listing.subdistrict_name,
            event_listing.district_name, event_listing.province_name, event_listing.postal_code,
            event_listing.latitude, event_listing.longitude, venue.official_url, venue.official_url,
            'source_checked',
            'Venue identity and use checked against its official website. Coordinates and address reuse the existing event listing; booth floor and event availability remain listing-level data.',
            jsonb_build_object('location_source', 'existing_event_listing',
                               'location_listing_slug', venue.listing_slug)
        ) ON CONFLICT (slug) DO NOTHING;

        SELECT id INTO venue_project_id
        FROM public.property_projects
        WHERE slug = venue.slug AND public_project_id = venue.public_id::uuid
          AND project_category = venue.category AND is_active = true AND deleted_at IS NULL;

        IF venue_project_id IS NULL THEN
            RAISE EXCEPTION 'Venue project identity conflicts: %', venue.slug;
        END IF;
        IF event_listing.project_id IS NOT NULL AND event_listing.project_id <> venue_project_id THEN
            RAISE EXCEPTION 'Event listing already belongs to another project: %', venue.listing_slug;
        END IF;

        INSERT INTO public.property_project_aliases (project_id, locale, alias_name, alias_type)
        SELECT venue_project_id, 'th', name, 'alternate' FROM unnest(venue.aliases_th) AS name
        UNION ALL
        SELECT venue_project_id, 'en', name, 'alternate' FROM unnest(venue.aliases_en) AS name
        ON CONFLICT (project_id, locale, normalized_alias) DO NOTHING;

        UPDATE public.listings SET project_id = venue_project_id, updated_at = now()
        WHERE id = event_listing.id AND project_id IS DISTINCT FROM venue_project_id;
    END LOOP;
END $$;

COMMIT;
