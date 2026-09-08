BEGIN;

-- A login always belongs to a person (or a temporary claim contact). The
-- organization owns its profile and listings independently from employees.
CREATE TABLE IF NOT EXISTS public.organizations (
    id bigserial PRIMARY KEY,
    public_organization_id uuid NOT NULL UNIQUE,
    slug varchar(140) NOT NULL UNIQUE,
    display_name varchar(160) NOT NULL,
    legal_name varchar(240),
    organization_type varchar(40) NOT NULL DEFAULT 'other',
    registration_no varchar(64),
    website_url text,
    verified_domain varchar(255),
    logo_url text,
    description text,
    verification_status varchar(32) NOT NULL DEFAULT 'unverified',
    verification_note text,
    verified_at timestamptz,
    verified_by_user_id bigint REFERENCES public.auth_users(id) ON DELETE SET NULL,
    created_by_user_id bigint REFERENCES public.auth_users(id) ON DELETE SET NULL,
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    deleted_at timestamptz,
    CHECK (organization_type IN (
        'agency',
        'developer',
        'bank_npa',
        'asset_manager',
        'property_company',
        'corporate',
        'team',
        'other'
    )),
    CHECK (verification_status IN ('unverified', 'contact_checked', 'verified', 'rejected')),
    CHECK (slug ~ '^[a-z0-9]+(?:-[a-z0-9]+)*$')
);

CREATE INDEX IF NOT EXISTS idx_organizations_active_verified
    ON public.organizations(verification_status, display_name, id)
    WHERE is_active = true AND deleted_at IS NULL;

CREATE TABLE IF NOT EXISTS public.organization_memberships (
    id bigserial PRIMARY KEY,
    organization_id bigint NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    user_id bigint NOT NULL REFERENCES public.auth_users(id) ON DELETE CASCADE,
    role_code varchar(24) NOT NULL,
    status varchar(24) NOT NULL DEFAULT 'active',
    is_primary_owner boolean NOT NULL DEFAULT false,
    invited_by_user_id bigint REFERENCES public.auth_users(id) ON DELETE SET NULL,
    joined_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (organization_id, user_id),
    CHECK (role_code IN ('owner', 'admin', 'publisher', 'editor', 'viewer')),
    CHECK (status IN ('active', 'suspended', 'removed')),
    CHECK (NOT is_primary_owner OR role_code = 'owner')
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_organization_primary_owner
    ON public.organization_memberships(organization_id)
    WHERE is_primary_owner = true AND status = 'active';

CREATE INDEX IF NOT EXISTS idx_organization_memberships_user
    ON public.organization_memberships(user_id, status, organization_id);

CREATE TABLE IF NOT EXISTS public.organization_invitations (
    id bigserial PRIMARY KEY,
    public_invitation_id uuid NOT NULL UNIQUE,
    organization_id bigint NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    email varchar(320) NOT NULL,
    role_code varchar(24) NOT NULL,
    token_hash varchar(255) NOT NULL UNIQUE,
    status varchar(24) NOT NULL DEFAULT 'pending',
    invited_by_user_id bigint REFERENCES public.auth_users(id) ON DELETE SET NULL,
    accepted_by_user_id bigint REFERENCES public.auth_users(id) ON DELETE SET NULL,
    expires_at timestamptz NOT NULL,
    accepted_at timestamptz,
    revoked_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CHECK (role_code IN ('admin', 'publisher', 'editor', 'viewer')),
    CHECK (status IN ('pending', 'accepted', 'revoked', 'expired'))
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_organization_pending_invitation
    ON public.organization_invitations(organization_id, lower(email))
    WHERE status = 'pending';

CREATE INDEX IF NOT EXISTS idx_organization_invitations_recipient
    ON public.organization_invitations(lower(email), status, expires_at DESC);

CREATE TABLE IF NOT EXISTS public.organization_contacts (
    id bigserial PRIMARY KEY,
    organization_id bigint NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    channel_type varchar(24) NOT NULL,
    channel_value text NOT NULL,
    label varchar(120),
    is_primary boolean NOT NULL DEFAULT false,
    is_public boolean NOT NULL DEFAULT true,
    is_verified boolean NOT NULL DEFAULT false,
    verified_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (organization_id, channel_type, channel_value),
    CHECK (channel_type IN ('phone', 'email', 'line', 'website'))
);

CREATE INDEX IF NOT EXISTS idx_organization_contacts_public
    ON public.organization_contacts(organization_id, channel_type, is_primary DESC)
    WHERE is_public = true;

CREATE TABLE IF NOT EXISTS public.organization_verifications (
    id bigserial PRIMARY KEY,
    organization_id bigint NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    verification_type varchar(24) NOT NULL,
    status varchar(24) NOT NULL,
    source_url text,
    evidence_note text,
    reviewed_by_user_id bigint REFERENCES public.auth_users(id) ON DELETE SET NULL,
    reviewed_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CHECK (verification_type IN ('domain', 'contact', 'legal_entity', 'listing_authority')),
    CHECK (status IN ('pending', 'verified', 'rejected'))
);

CREATE INDEX IF NOT EXISTS idx_organization_verifications_review
    ON public.organization_verifications(organization_id, status, reviewed_at DESC);

CREATE TABLE IF NOT EXISTS public.organization_audit_logs (
    id bigserial PRIMARY KEY,
    organization_id bigint NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    actor_user_id bigint REFERENCES public.auth_users(id) ON DELETE SET NULL,
    action_code varchar(80) NOT NULL,
    entity_type varchar(40),
    entity_public_id varchar(160),
    metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_organization_audit_logs_recent
    ON public.organization_audit_logs(organization_id, created_at DESC, id DESC);

ALTER TABLE public.listings
    ADD COLUMN IF NOT EXISTS organization_id bigint;

ALTER TABLE public.listings
    ADD COLUMN IF NOT EXISTS created_by_user_id bigint;

ALTER TABLE public.listings
    ADD COLUMN IF NOT EXISTS published_by_user_id bigint;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'listings_organization_fkey'
    ) THEN
        ALTER TABLE public.listings
            ADD CONSTRAINT listings_organization_fkey
            FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE SET NULL;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'listings_created_by_user_fkey'
    ) THEN
        ALTER TABLE public.listings
            ADD CONSTRAINT listings_created_by_user_fkey
            FOREIGN KEY (created_by_user_id) REFERENCES public.auth_users(id) ON DELETE SET NULL;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'listings_published_by_user_fkey'
    ) THEN
        ALTER TABLE public.listings
            ADD CONSTRAINT listings_published_by_user_fkey
            FOREIGN KEY (published_by_user_id) REFERENCES public.auth_users(id) ON DELETE SET NULL;
    END IF;
END $$;

UPDATE public.listings listing
SET created_by_user_id = CASE
        WHEN account.id IS NOT NULL THEN listing.user_id
        ELSE NULL
    END,
    published_by_user_id = CASE
        WHEN listing.published_at IS NOT NULL AND account.id IS NOT NULL THEN listing.user_id
        ELSE listing.published_by_user_id
    END
FROM (SELECT id FROM public.auth_users) account
WHERE account.id = listing.user_id
  AND listing.created_by_user_id IS NULL;

CREATE INDEX IF NOT EXISTS idx_listings_organization_active
    ON public.listings(organization_id, updated_at DESC, id DESC)
    WHERE organization_id IS NOT NULL AND deleted_at IS NULL;

CREATE INDEX IF NOT EXISTS idx_listings_created_by_user
    ON public.listings(created_by_user_id, updated_at DESC, id DESC)
    WHERE created_by_user_id IS NOT NULL;

ALTER TABLE public.listing_contact_profiles
    ADD COLUMN IF NOT EXISTS organization_id bigint REFERENCES public.organizations(id) ON DELETE SET NULL;

ALTER TABLE public.listing_contact_profiles
    ADD COLUMN IF NOT EXISTS contact_user_id bigint REFERENCES public.auth_users(id) ON DELETE SET NULL;

UPDATE public.listing_contact_profiles profile
SET contact_user_id = listing.user_id
FROM public.listings listing
JOIN public.auth_users account ON account.id = listing.user_id
WHERE listing.id = profile.listing_id
  AND profile.contact_user_id IS NULL;

-- Seed KKPPropify as a verified organization. The existing account remains a
-- temporary claim contact until KKP names a real employee to receive ownership.
DO $$
DECLARE
    kkp_user_id bigint;
    kkp_organization_id bigint;
BEGIN
    SELECT id INTO kkp_user_id
    FROM public.auth_users
    WHERE lower(email) = 'kkpcontactcenter@kkpfg.com'
      AND deleted_at IS NULL
    ORDER BY id
    LIMIT 1;

    IF kkp_user_id IS NULL THEN
        RAISE EXCEPTION 'KKPPropify claim user is required before creating the organization';
    END IF;

    INSERT INTO public.organizations (
        public_organization_id,
        slug,
        display_name,
        legal_name,
        organization_type,
        website_url,
        verified_domain,
        verification_status,
        verification_note,
        verified_at,
        created_by_user_id
    ) VALUES (
        'b84e97c5-f08d-49e7-b87e-3dd454e22a6d',
        'kkppropify',
        'KKPPropify',
        'ธนาคารเกียรตินาคินภัทร จำกัด (มหาชน)',
        'bank_npa',
        'https://kkppropify.kkpfg.com/th/npa',
        'kkpfg.com',
        'verified',
        'MapxProp checked the official KKP Propify and Kiatnakin Phatra Bank websites and contact channels.',
        now(),
        kkp_user_id
    )
    ON CONFLICT (slug) DO UPDATE SET
        display_name = EXCLUDED.display_name,
        legal_name = EXCLUDED.legal_name,
        organization_type = EXCLUDED.organization_type,
        website_url = EXCLUDED.website_url,
        verified_domain = EXCLUDED.verified_domain,
        verification_status = EXCLUDED.verification_status,
        verification_note = EXCLUDED.verification_note,
        verified_at = COALESCE(public.organizations.verified_at, EXCLUDED.verified_at),
        is_active = true,
        deleted_at = NULL,
        updated_at = now()
    RETURNING id INTO kkp_organization_id;

    INSERT INTO public.organization_memberships (
        organization_id,
        user_id,
        role_code,
        status,
        is_primary_owner,
        joined_at
    ) VALUES (
        kkp_organization_id,
        kkp_user_id,
        'owner',
        'active',
        true,
        now()
    )
    ON CONFLICT (organization_id, user_id) DO UPDATE SET
        role_code = 'owner',
        status = 'active',
        is_primary_owner = true,
        joined_at = COALESCE(public.organization_memberships.joined_at, now()),
        updated_at = now();

    UPDATE public.listings
    SET organization_id = kkp_organization_id,
        created_by_user_id = COALESCE(created_by_user_id, user_id),
        published_by_user_id = COALESCE(published_by_user_id, user_id),
        updated_at = now()
    WHERE user_id = kkp_user_id
      AND organization_id IS NULL;

    UPDATE public.listing_contact_profiles profile
    SET organization_id = kkp_organization_id,
        contact_user_id = COALESCE(profile.contact_user_id, kkp_user_id),
        updated_at = now()
    FROM public.listings listing
    WHERE listing.id = profile.listing_id
      AND listing.organization_id = kkp_organization_id;

    INSERT INTO public.organization_contacts (
        organization_id, channel_type, channel_value, label,
        is_primary, is_public, is_verified, verified_at
    ) VALUES
        (kkp_organization_id, 'phone', '021655577', 'KKP Asset Contact Center', true, true, true, now()),
        (kkp_organization_id, 'phone', '021655555', 'KKP Contact Center', false, true, true, now()),
        (kkp_organization_id, 'email', 'kkpcontactcenter@kkpfg.com', 'KKP Contact Center', true, true, true, now()),
        (kkp_organization_id, 'line', '@kkpbank', 'KKP LINE Official Account', true, true, true, now()),
        (kkp_organization_id, 'website', 'https://kkppropify.kkpfg.com/th/npa', 'KKP Propify', true, true, true, now())
    ON CONFLICT (organization_id, channel_type, channel_value) DO UPDATE SET
        label = EXCLUDED.label,
        is_primary = EXCLUDED.is_primary,
        is_public = EXCLUDED.is_public,
        is_verified = EXCLUDED.is_verified,
        verified_at = COALESCE(public.organization_contacts.verified_at, EXCLUDED.verified_at),
        updated_at = now();

    IF NOT EXISTS (
        SELECT 1
        FROM public.organization_verifications
        WHERE organization_id = kkp_organization_id
          AND verification_type = 'domain'
          AND status = 'verified'
          AND source_url = 'https://kkppropify.kkpfg.com/th/npa'
    ) THEN
        INSERT INTO public.organization_verifications (
            organization_id,
            verification_type,
            status,
            source_url,
            evidence_note,
            reviewed_at
        ) VALUES (
            kkp_organization_id,
            'domain',
            'verified',
            'https://kkppropify.kkpfg.com/th/npa',
            'The official site identifies KKP Propify as the Kiatnakin Phatra Bank NPA property platform.',
            now()
        );
    END IF;

    INSERT INTO public.organization_audit_logs (
        organization_id,
        actor_user_id,
        action_code,
        entity_type,
        entity_public_id,
        metadata
    ) VALUES (
        kkp_organization_id,
        kkp_user_id,
        'organization.seeded',
        'organization',
        'b84e97c5-f08d-49e7-b87e-3dd454e22a6d',
        jsonb_build_object('source', 'MapxProp migration', 'claim_contact', 'kkpcontactcenter@kkpfg.com')
    );
END $$;

COMMIT;
