BEGIN;

CREATE TABLE IF NOT EXISTS public.listing_translations (
    id bigserial PRIMARY KEY,
    listing_id bigint NOT NULL REFERENCES public.listings(id) ON DELETE CASCADE,
    language_code text NOT NULL,
    title text NOT NULL,
    description text,
    short_description text,
    seo_title text,
    seo_description text,
    translation_source text NOT NULL DEFAULT 'manual',
    translation_status text NOT NULL DEFAULT 'published',
    translated_by_user_id bigint,
    notes text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    deleted_at timestamptz
);

-- Older environments already have the core translation table. Extend that
-- table in place so its existing audit and soft-delete fields are preserved.
ALTER TABLE public.listing_translations
    ADD COLUMN IF NOT EXISTS address_line1 text NOT NULL DEFAULT '',
    ADD COLUMN IF NOT EXISTS address_line2 text NOT NULL DEFAULT '',
    ADD COLUMN IF NOT EXISTS road text NOT NULL DEFAULT '',
    ADD COLUMN IF NOT EXISTS subdistrict_name text NOT NULL DEFAULT '',
    ADD COLUMN IF NOT EXISTS district_name text NOT NULL DEFAULT '',
    ADD COLUMN IF NOT EXISTS province_name text NOT NULL DEFAULT '',
    ADD COLUMN IF NOT EXISTS reviewed_at timestamptz,
    ADD COLUMN IF NOT EXISTS search_text text NOT NULL DEFAULT '';

CREATE UNIQUE INDEX IF NOT EXISTS uq_listing_translations_active_language
    ON public.listing_translations(listing_id, language_code)
    WHERE deleted_at IS NULL;

CREATE INDEX IF NOT EXISTS idx_listing_translations_language_listing
    ON public.listing_translations(language_code, listing_id)
    WHERE translation_status = 'published' AND deleted_at IS NULL;

WITH english (
    slug, title, description, address_line1, road,
    subdistrict_name, district_name, province_name
) AS (
    VALUES
    (
        'house-the-city-ratchapruek-suanphak-n0602911',
        $translation$House for Sale or Rent at THE CITY Ratchapruek-Suanphak, 68.5 sq.wah, 4 Bedrooms$translation$,
        $translation$Luxury two-storey detached house at THE CITY Ratchapruek-Suanphak. The property sits on 68.5 sq.wah of land with 309 sq.m. of usable space and faces south.

The house offers 4 bedrooms, 4 bathrooms, 2 living rooms, 1 maid's room, 1 storage room, parking for 3 cars, and 6 air-conditioning units. The bright interior has high ceilings and comes with furniture and built-ins, including a walk-in closet, built-in kitchen, and side garden.

Facilities include a clubhouse, swimming pool, fitness center, children's room, garden, and 24-hour security. Convenient access to Ratchapruek, Pinklao, Sirindhorn Road, and the Si Rat-Outer Ring Road Expressway.

Sale price: THB 11,900,000. Rent: THB 65,000 per month.

Contact Khun Phak at Greatest Property by phone or LINE: 082-394-4659. Property ID: N0602911.

Buyers and tenants should verify the property condition, title documents, expenses, and terms with the representative before making a decision.$translation$,
        'THE CITY Ratchapruek-Suanphak, Ratchapruek-Suanphak area',
        'Bang Kruai-Chong Thanom Road', 'Maha Sawat', 'Bang Kruai', 'Nonthaburi'
    ),
    (
        'condo-the-address-sathorn-s10321',
        $translation$High-Floor 1-Bedroom Condo for Sale at The Address Sathorn, 46 sq.m., THB 7.92M$translation$,
        $translation$Move-in-ready high-floor condominium at The Address Sathorn. The 46 sq.m. unit has 1 bedroom, 1 bathroom, and comes furnished.

The unit features a warm modern interior, wood flooring, a naturally bright living area, and city and green views. It includes a dining area, kitchen, bedroom, and a bathroom with a bathtub and separate shower.

Located on Sathorn Soi 12, approximately 200 meters from BTS Saint Louis, with convenient access to Sathorn and Silom.

Sale price: THB 7,920,000.

Contact PropertySights Real Estate: 095-517-9606. Property ID: S10321.

Buyers should verify the property condition, title documents, expenses, and terms with the representative before making a decision.$translation$,
        '98 Sathorn Soi 12, The Address Sathorn',
        'North Sathorn Road', 'Si Lom', 'Bang Rak', 'Bangkok'
    ),
    (
        'condo-the-address-sathorn-60197196',
        $translation$High-Floor 1-Bedroom Condo for Sale at The Address Sathorn, 55.28 sq.m., THB 13.5M$translation$,
        $translation$High-floor condominium at The Address Sathorn. The 55.28 sq.m. unit has 1 bedroom, 1 bathroom, comes furnished, and offers city views.

The bright, open-plan living area connects to a built-in kitchen and balcony. The bedroom has built-in wardrobes, while the bathroom includes a bathtub and separate shower.

Located on Sathorn Soi 12, approximately 200 meters from BTS Saint Louis, with convenient access to Sathorn and Silom.

Sale price: THB 13,500,000.

Contact PropertySights Real Estate: 095-517-9606. Property ID: 60197196.

Buyers should verify the property condition, title documents, expenses, and terms with the representative before making a decision.$translation$,
        '98 Sathorn Soi 12, The Address Sathorn',
        'North Sathorn Road', 'Si Lom', 'Bang Rak', 'Bangkok'
    ),
    (
        'townhouse-pleno-town-pinklao-sai-5-b-0705',
        $translation$Two-Storey Townhome for Sale at PLENO TOWN Pinklao-Sai 5, 18.1 sq.wah, THB 2.755M$translation$,
        $translation$Two-storey townhome, house no. 119/75, at PLENO TOWN Pinklao-Sai 5 on 18.1 sq.wah of land.

The vacant home has 3 bedrooms and 2 bathrooms, with a bright interior suitable for a family. Convenient access via Phutthamonthon Sai 5 Road and Phet Kasem Road.

Nearby destinations include Don Wai Market, Central Salaya, Vichaivej Nong Khaem Hospital, and Mahidol University.

Special price: THB 2,755,000, reduced from THB 2,900,000.

Contact Juzzmatch Co., Ltd.: 02-495-4506. Property ID: B-0705.

Buyers should verify the property condition, title documents, expenses, and terms with the representative before making a decision.$translation$,
        '119/75 PLENO TOWN Pinklao-Sai 5, Wat Rai Khing Soi 42',
        'Phutthamonthon Sai 5 Road', 'Rai Khing', 'Sam Phran', 'Nakhon Pathom'
    ),
    (
        'house-mind-pinklao-charan-ea0282569',
        $translation$Three-Storey Detached House for Sale at MIND Pinklao-Charan, 64 sq.wah, THB 8.3M$translation$,
        $translation$Three-storey detached house on a corner plot at the end of the soi in MIND Pinklao-Charan. The property sits on 64 sq.wah of land with 250 sq.m. of usable space.

It has 5 bedrooms, 5 bathrooms, covered parking for 3 cars, and faces north. A rear kitchen and an approximately 2.5 x 10 meter multipurpose extension supported by micropiles make it suitable as a residence, home office, or live-streaming studio.

Close to the Si Rat-Outer Ring Road Expressway and Central Pinklao.

Reduced from THB 8,500,000 to THB 8,300,000.

Contact Exclusive Asset, Khun Noon Yonsiri: 082-956-6564. LINE: yolsiri.

Buyers should verify the property condition, title documents, expenses, and terms with the representative before making a decision.$translation$,
        'MIND Pinklao-Charan, Bang Kruai-Sai Noi Soi 17',
        'Bang Kruai-Sai Noi Road', 'Bang Si Thong', 'Bang Kruai', 'Nonthaburi'
    ),
    (
        'house-nimittra-bang-kruai-lv2136230',
        $translation$Two-Storey Detached House for Sale at Nimittra, Bang Kruai, 42 sq.wah, THB 4.2M$translation$,
        $translation$Two-storey detached house in Nimittra Village, Bang Kruai, near the Electricity Generating Authority of Thailand and MRT Bang O.

The property sits on 42 sq.wah of land with approximately 130 sq.m. of usable space and faces north. It has 2 bedrooms, 2 bathrooms, 1 kitchen, 1 living room, and parking for 2 cars.

Included are 3 air-conditioning units and 1 water heater. Conveniently located near the Si Rat Expressway, Yanhee Hospital, Bang Kruai Hospital, KMUTNB, Gateway at Bangsue, and Central Pinklao.

Price: THB 4,200,000.

Contact Nick Property: Khun Nick at 086-846-2666 or Khun Mint at 085-958-2000. LINE: @nickperfect. Property ID: LV2136230.

Buyers should verify the property condition, title documents, expenses, and terms with the representative before making a decision.$translation$,
        'Nimittra Village Soi, near the Electricity Generating Authority of Thailand, Rama VII',
        '', '', 'Bang Kruai', 'Nonthaburi'
    ),
    (
        'condo-life-at-sathorn-10-10024893',
        $translation$Two-Bedroom Condo for Sale at Life @ Sathorn 10, 27th Floor, 65 sq.m., THB 9.5M$translation$,
        $translation$Condominium at Life @ Sathorn 10. The 65 sq.m. unit is on the 27th floor and has 2 bedrooms, 2 bathrooms, and a balcony with city views.

The kitchen includes built-in appliances. The unit also has living and dining areas, a storage room, laundry area, and built-in wardrobes.

Facilities include a fitness center, swimming pool, elevators, parking, and security.

Price: THB 9,500,000.

Contact PropertySights Real Estate: 095-517-9606. Property ID: 10024893.

Buyers should verify the property condition, title documents, expenses, and terms with the representative before making a decision.$translation$,
        '48 Sathorn Soi 10, North Sathorn Road, Life @ Sathorn 10',
        'North Sathorn Road', 'Si Lom', 'Bang Rak', 'Bangkok'
    ),
    (
        'house-casa-legend-ratchapruek-tp2206059',
        $translation$Detached House for Sale at Casa Legend Ratchaphruek-Pinklao, 63.4 sq.wah, THB 9.9M$translation$,
        $translation$Detached house at Casa Legend Ratchaphruek-Pinklao, house no. 189/68, Soi 4.

The property sits on 63.4 sq.wah of land and has 3 bedrooms and 3 bathrooms, with space suitable for pets. Located in the Ratchaphruek-Rama V area of Taling Chan.

Price: THB 9,900,000.

Offered by Aspire Real Estate Agency. Property ID: TP2206059.

Buyers should verify the property condition, title documents, expenses, and terms with the representative before making a decision.$translation$,
        '189/68 Soi 4, Ratchaphruek Road, Casa Legend Ratchaphruek-Pinklao',
        'Ratchaphruek Road', 'Taling Chan', 'Taling Chan', 'Bangkok'
    ),
    (
        'house-casa-legend-ratchapruek-tp2206058',
        $translation$Three-Bedroom Detached House for Sale at Casa Legend Ratchaphruek-Pinklao, THB 8.9M$translation$,
        $translation$Detached house at Casa Legend Ratchaphruek-Pinklao, house no. 189/10, Soi 1.

The property sits on 50.6 sq.wah of land and has 3 bedrooms and 3 bathrooms, with space suitable for pets. Located in the Ratchaphruek-Rama V area of Taling Chan.

Price: THB 8,900,000.

Offered by Aspire Real Estate Agency. Property ID: TP2206058.

Buyers should verify the property condition, title documents, expenses, and terms with the representative before making a decision.$translation$,
        '189/10 Soi 1, Ratchaphruek Road, Casa Legend Ratchaphruek-Pinklao',
        'Ratchaphruek Road', 'Taling Chan', 'Taling Chan', 'Bangkok'
    ),
    (
        'townhouse-the-connect-wongwaen-rama-9-b-0783',
        $translation$Three-Bedroom Townhome for Sale at The Connect Wongwaen-Rama 9, THB 3.168M$translation$,
        $translation$Townhome at The Connect Wongwaen-Rama 9 on 18.2 sq.wah of land, with 3 bedrooms and 3 bathrooms.

The vacant home has a bright interior and a front parking area, making it suitable as a residence. Conveniently located near the Outer Ring Road and Rama IX Road.

Special price: THB 3,168,000, reduced from THB 3,300,000.

Contact Juzzmatch Co., Ltd.: 02-495-4506. Property ID: B-0783.

Buyers should verify the property condition, title documents, expenses, and terms with the representative before making a decision.$translation$,
        '199/129, The Connect Wongwaen-Rama 9',
        '', 'Prawet', 'Prawet', 'Bangkok'
    ),
    (
        'land-for-sale-yothin-pattana-11-200-sq-wah',
        $translation$Urgent Sale: 200 sq.wah Land on Yothin Phatthana Soi 11 near Pradit Manutham Road$translation$,
        $translation$Urgent sale of a 200 sq.wah land plot on Yothin Phatthana Soi 11, close to the entrance of the soi with convenient access to Pradit Manutham Road and the Ram Inthra-At Narong Expressway frontage road.

The property has a wide road frontage and currently contains a usable paved area and structures. It is suitable for a business, office, shop, restaurant, or residential development. Nearby destinations include Central EastVille, CDC, HomePro, Lotus's, and Chic Republic.

Price: THB 50,000,000 (THB 250,000 per sq.wah), negotiable. Direct sale by owner. A 2% commission is offered to agents. Contact Khun Tum to arrange a viewing or request details.

Buyers should verify the title deed, boundaries, structures, zoning, and permitted land use before signing an agreement.$translation$,
        'Yothin Phatthana Soi 11, near the soi entrance and Pradit Manutham Road / Ram Inthra-At Narong Expressway',
        'Yothin Phatthana Soi 11', 'Khlong Chan', 'Bang Kapi', 'Bangkok'
    ),
    (
        'land-for-sale-sutthisan-700-sq-wah',
        $translation$700 sq.wah Land for Sale off Sutthisan Winitchai Road, Two Adjoining Plots, 87 m Frontage$translation$,
        $translation$Two adjoining vacant land plots for sale, totaling 700 sq.wah, in a private soi off Sutthisan Winitchai Road. The plots are offered together.

Each plot is approximately 350 sq.wah. The first has about 45 meters of road frontage and the second about 42 meters, for a combined frontage of approximately 87 meters. There are currently no buildings, and some trees remain on the land in its present condition.

The quiet soi is surrounded by residences and large homes. The property may suit buyers seeking a large central Bangkok site for a private residence or family compound. Buyers should confirm zoning, plot boundaries, and permitted land use with the relevant authorities before making a decision.

Convenient connections to Sutthisan, Ratchadaphisek, Lat Phrao, and Rama IX. Best suited to car travel. Near MRT Sutthisan, the Embassy of Turkiye, Thailand Cultural Centre, and Central Rama 9.$translation$,
        'Private soi off Sutthisan Winitchai Road, Bangkok',
        'Sutthisan Winitchai Road', '', '', 'Bangkok'
    ),
    (
        'food-o-clock-the-empire-tower-2026',
        $translation$Booth Reservations Open for FOOD O'CLOCK at The Empire Tower, M Floor$translation$,
        $translation$Booth reservations are open for five rounds of FOOD O'CLOCK on M Floor at The Empire Tower. The event is suitable for food, beverage, and lifestyle vendors, with office employees and people working in the building as the primary audience.

Please contact HBD Event directly for pricing, booth dimensions, booth numbers, utilities, and the floor plan.$translation$,
        'The Empire Tower, M Floor, 1 South Sathorn Road, Yannawa, Sathon, Bangkok',
        'South Sathorn Road', 'Yannawa', 'Sathon', 'Bangkok'
    ),
    (
        'local-favorites-emsphere-2026',
        $translation$Vendor Applications Open for LOCAL FAVORITES at EMSPHERE, G Floor$translation$,
        $translation$Vendor applications are open for LOCAL FAVORITES from 11-22 September 2026 at EM MARKET HALL on G Floor, EMSPHERE. The event welcomes food, beverage, bakery, and dessert vendors.

The primary audience includes working professionals, mall visitors, tourists, and international visitors. The venue is inside the shopping center, and the organizer states that the event will be promoted through its own channels.

Please contact HBD Event directly for pricing, booth dimensions, booth numbers, remaining availability, sales terms, electrical and water services, and the floor plan.$translation$,
        'EM MARKET HALL, G Floor, EMSPHERE, 628 Sukhumvit Road, Khlong Tan, Khlong Toei, Bangkok',
        'Sukhumvit Road', 'Khlong Tan', 'Khlong Toei', 'Bangkok'
    )
)
INSERT INTO public.listing_translations (
    listing_id, language_code, title, description, address_line1, road,
    subdistrict_name, district_name, province_name,
    seo_title, seo_description, translation_status, translation_source, reviewed_at, search_text
)
SELECT
    listing.id, 'en', english.title, english.description, english.address_line1, english.road,
    english.subdistrict_name, english.district_name, english.province_name,
    english.title, left(regexp_replace(english.description, E'[\\n\\r]+', ' ', 'g'), 320),
    'published', 'ai_assisted', now(),
    lower(concat_ws(' ', english.title, english.description, english.address_line1,
        english.road, english.subdistrict_name, english.district_name, english.province_name))
FROM english
JOIN public.listings listing ON listing.slug = english.slug
ON CONFLICT (listing_id, language_code) WHERE deleted_at IS NULL DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    address_line1 = EXCLUDED.address_line1,
    road = EXCLUDED.road,
    subdistrict_name = EXCLUDED.subdistrict_name,
    district_name = EXCLUDED.district_name,
    province_name = EXCLUDED.province_name,
    seo_title = EXCLUDED.seo_title,
    seo_description = EXCLUDED.seo_description,
    translation_status = EXCLUDED.translation_status,
    translation_source = EXCLUDED.translation_source,
    reviewed_at = EXCLUDED.reviewed_at,
    search_text = EXCLUDED.search_text,
    updated_at = now();

COMMIT;
