-- Keep a signed-in user's preferred listing contact details separate from
-- public account identity data. These values are private defaults and are
-- copied into a listing only when the user submits that listing.

CREATE TABLE IF NOT EXISTS public.user_listing_contact_profiles (
    user_id bigint PRIMARY KEY REFERENCES public.auth_users(id) ON DELETE CASCADE,
    contact_name text NOT NULL,
    contact_phone varchar(64) NOT NULL,
    contact_phone_secondary varchar(64),
    contact_email varchar(320),
    line_id varchar(160),
    instagram_handle varchar(64),
    role_code text NOT NULL,
    authority_source_code text NOT NULL,
    organization_name varchar(160),
    organization_registration_no varchar(64),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CHECK (role_code IN (
        'owner',
        'owner_representative',
        'independent_broker',
        'agency_broker',
        'developer_investor_representative',
        'property_manager'
    )),
    CHECK (authority_source_code IN (
        'self',
        'property_owner',
        'brokerage_company',
        'developer_project',
        'investor_asset_holder',
        'co_broker',
        'property_management_company'
    )),
    CHECK (role_code <> 'owner' OR authority_source_code = 'self'),
    CHECK (role_code = 'owner' OR authority_source_code <> 'self'),
    CHECK (
        role_code NOT IN ('agency_broker', 'developer_investor_representative')
        OR NULLIF(btrim(organization_name), '') IS NOT NULL
    ),
    CHECK (
        NULLIF(btrim(organization_registration_no), '') IS NULL
        OR NULLIF(btrim(organization_name), '') IS NOT NULL
    )
);

COMMENT ON TABLE public.user_listing_contact_profiles IS
    'Private reusable defaults for the owner contact section of new listings';

COMMENT ON COLUMN public.user_listing_contact_profiles.organization_registration_no IS
    'Private verification data; never expose through public listing or profile endpoints';
