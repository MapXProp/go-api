BEGIN;

-- An organization type answers "what kind of company is this?" while
-- specialties describe the inventory and transactions it focuses on. An
-- organization can have several specialties without being forced into one
-- category.
CREATE TABLE IF NOT EXISTS public.organization_specialties (
    organization_id bigint NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    specialty_code varchar(40) NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (organization_id, specialty_code),
    CHECK (specialty_code IN (
        'sale',
        'rent',
        'npa',
        'condo',
        'house',
        'land',
        'commercial',
        'warehouse_factory',
        'hotel_resort',
        'beachfront',
        'investment'
    ))
);

CREATE INDEX IF NOT EXISTS idx_organization_specialties_directory
    ON public.organization_specialties(specialty_code, organization_id);

INSERT INTO public.organization_specialties (organization_id, specialty_code)
SELECT organization.id, specialty.code
FROM public.organizations organization
CROSS JOIN (VALUES
    ('sale'),
    ('npa'),
    ('condo'),
    ('house'),
    ('land'),
    ('commercial'),
    ('investment')
) AS specialty(code)
WHERE organization.slug = 'kkppropify'
ON CONFLICT (organization_id, specialty_code) DO NOTHING;

UPDATE public.organizations
SET description = COALESCE(
        NULLIF(description, ''),
        'แพลตฟอร์มรวมทรัพย์สินรอการขาย (NPA) ของธนาคารเกียรตินาคินภัทร'
    ),
    updated_at = now()
WHERE slug = 'kkppropify';

COMMIT;
