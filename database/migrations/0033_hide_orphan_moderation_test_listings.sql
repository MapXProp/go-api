-- A pair of moderation integration fixtures reached production before the
-- fixture cleanup deleted listings ahead of their synthetic owner. The user
-- foreign key uses ON DELETE SET NULL, leaving those rows public and invisible
-- to owner-aware administration queries. Soft-delete only unmistakable test
-- fixtures; real listings and their media remain untouched.
UPDATE public.listings
SET deleted_at = COALESCE(deleted_at, now()),
    updated_at = now()
WHERE deleted_at IS NULL
  AND user_id IS NULL
  AND title LIKE 'Moderation integration %'
  AND contact_email LIKE 'codex-moderation-%@example.invalid';
