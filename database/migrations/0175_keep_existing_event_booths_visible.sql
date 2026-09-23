BEGIN;

-- Temporarily keep the two existing editorial event listings visible, as
-- requested on 2026-09-23. Preserve the actual dates in listing_event_rounds.
-- This changes only their automatic listing expiry, never publication or
-- moderation state, and does not change expiry rules for new event listings.
UPDATE public.listings
SET expires_at = NULL
WHERE slug IN (
    'food-o-clock-the-empire-tower-2026',
    'local-favorites-emsphere-2026'
)
  AND property_type_code = 'retail_space'
  AND space_type_code = 'event_booth'
  AND published_at IS NOT NULL
  AND deleted_at IS NULL
  AND is_active = true
  AND listing_status = 'active'
  AND moderation_status = 'approved'
  AND expires_at IS NOT NULL;

COMMIT;
