-- The legacy production schema retained dangling user_id values rather than
-- setting them to NULL, so migration 0033 deliberately did not match these
-- rows. Soft-delete the two verified synthetic fixtures by immutable public ID
-- while retaining marker checks that prevent any real listing from changing.
UPDATE public.listings
SET deleted_at = COALESCE(deleted_at, now()),
    updated_at = now()
WHERE deleted_at IS NULL
  AND public_listing_id::text IN (
    '4dca00ea-fe46-4631-8090-470dcc8e3663',
    'e40e4286-65d2-486a-bc68-053def426884'
  )
  AND title LIKE 'Moderation integration %'
  AND contact_email LIKE 'codex-moderation-%@example.invalid';
