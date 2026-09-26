ALTER TABLE public.auth_users ADD COLUMN IF NOT EXISTS avatar_url text;

COMMENT ON COLUMN public.auth_users.avatar_url IS
    'User-uploaded public profile photo; only server-generated media paths may be stored';
