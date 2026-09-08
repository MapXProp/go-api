BEGIN;

-- Promotion is time-bound campaign data, not a permanent listing attribute.
-- priority_weight is assigned by the billing/admin service from the purchased
-- package, so public ranking never needs to expose or compare payment amounts.
CREATE TABLE IF NOT EXISTS public.listing_promotion_campaigns (
    id bigserial PRIMARY KEY,
    listing_id bigint NOT NULL REFERENCES public.listings(id) ON DELETE CASCADE,
    organization_id bigint REFERENCES public.organizations(id) ON DELETE SET NULL,
    campaign_key varchar(120) UNIQUE,
    placement varchar(24) NOT NULL DEFAULT 'map',
    tier varchar(24) NOT NULL,
    priority_weight integer NOT NULL DEFAULT 0,
    amount_paid_minor bigint NOT NULL DEFAULT 0,
    currency_code varchar(3) NOT NULL DEFAULT 'THB',
    status varchar(24) NOT NULL DEFAULT 'active',
    starts_at timestamptz NOT NULL DEFAULT now(),
    ends_at timestamptz,
    impression_count bigint NOT NULL DEFAULT 0,
    hover_count bigint NOT NULL DEFAULT 0,
    click_count bigint NOT NULL DEFAULT 0,
    created_by_user_id bigint REFERENCES public.auth_users(id) ON DELETE SET NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CHECK (placement IN ('map', 'search', 'home')),
    CHECK (tier IN ('premium', 'boosted')),
    CHECK (priority_weight >= 0),
    CHECK (amount_paid_minor >= 0),
    CHECK (currency_code ~ '^[A-Z]{3}$'),
    CHECK (status IN ('draft', 'active', 'paused', 'cancelled', 'completed')),
    CHECK (ends_at IS NULL OR ends_at > starts_at),
    CHECK (impression_count >= 0 AND hover_count >= 0 AND click_count >= 0)
);

COMMENT ON COLUMN public.listing_promotion_campaigns.priority_weight IS
    'Normalized package weight assigned by billing/admin. Higher wins within the same tier.';

CREATE INDEX IF NOT EXISTS idx_listing_promotion_campaigns_active_placement
    ON public.listing_promotion_campaigns(placement, tier, priority_weight DESC, listing_id)
    WHERE status = 'active';

CREATE INDEX IF NOT EXISTS idx_listing_promotion_campaigns_listing_history
    ON public.listing_promotion_campaigns(listing_id, starts_at DESC, id DESC);

CREATE INDEX IF NOT EXISTS idx_listing_promotion_campaigns_organization
    ON public.listing_promotion_campaigns(organization_id, status, starts_at DESC)
    WHERE organization_id IS NOT NULL;

COMMIT;
