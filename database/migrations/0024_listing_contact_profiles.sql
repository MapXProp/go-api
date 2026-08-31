-- Capture who represents each listing without treating self-declared roles as verification.
-- Organization registration numbers are private review data and must not be exposed publicly.

CREATE TABLE IF NOT EXISTS public.listing_contact_profiles (
    listing_id bigint PRIMARY KEY REFERENCES public.listings(id) ON DELETE CASCADE,
    role_code text NOT NULL,
    authority_source_code text NOT NULL,
    organization_name text,
    organization_registration_no varchar(64),
    verification_status text NOT NULL DEFAULT 'unverified',
    verification_note text,
    verified_at timestamptz,
    verified_by_user_id bigint REFERENCES public.auth_users(id) ON DELETE SET NULL,
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
    CHECK (verification_status IN ('unverified', 'identity_verified', 'authority_verified')),
    CHECK (role_code <> 'owner' OR authority_source_code = 'self'),
    CHECK (
        role_code NOT IN ('agency_broker', 'developer_investor_representative')
        OR NULLIF(btrim(organization_name), '') IS NOT NULL
    )
);

CREATE INDEX IF NOT EXISTS idx_listing_contact_profiles_verification
    ON public.listing_contact_profiles(verification_status, role_code, listing_id);

COMMENT ON COLUMN public.listing_contact_profiles.verification_status IS
    'unverified = self-declared; identity_verified = person checked; authority_verified = identity and authority to represent this listing checked';

COMMENT ON COLUMN public.listing_contact_profiles.organization_registration_no IS
    'Private organization evidence. Never return this value from public listing endpoints.';
