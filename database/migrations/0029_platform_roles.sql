BEGIN;

CREATE TABLE IF NOT EXISTS public.platform_roles (
    code text PRIMARY KEY,
    name_th text NOT NULL,
    name_en text NOT NULL,
    description_th text NOT NULL,
    description_en text NOT NULL,
    permission_level smallint NOT NULL UNIQUE,
    is_assignable boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CHECK (code IN ('super_admin', 'admin', 'moderator', 'support', 'member')),
    CHECK (permission_level BETWEEN 1 AND 100)
);

INSERT INTO public.platform_roles (
    code, name_th, name_en, description_th, description_en, permission_level, is_assignable
) VALUES
    ('super_admin', 'ผู้ดูแลระบบสูงสุด', 'Super admin', 'ควบคุมระบบและจัดการสิทธิ์ผู้ใช้ทั้งหมด', 'Full platform control, including user role management', 100, false),
    ('admin', 'ผู้ดูแลระบบ', 'Admin', 'ดูแลผู้ใช้ ประกาศ และการทำงานของแพลตฟอร์ม', 'Manage users, listings, and platform operations', 80, true),
    ('moderator', 'ผู้ตรวจสอบประกาศ', 'Moderator', 'ตรวจสอบ อนุมัติ หรือส่งประกาศกลับไปแก้ไข', 'Review, approve, or return listings for changes', 60, true),
    ('support', 'ทีมช่วยเหลือ', 'Support', 'ช่วยตรวจสอบปัญหาบัญชีและให้บริการผู้ใช้', 'Assist users and investigate account issues', 40, true),
    ('member', 'สมาชิก', 'Member', 'ใช้งานทั่วไป ลงประกาศ และจัดการข้อมูลของตนเอง', 'Standard account for creating and managing personal listings', 10, true)
ON CONFLICT (code) DO UPDATE SET
    name_th = EXCLUDED.name_th,
    name_en = EXCLUDED.name_en,
    description_th = EXCLUDED.description_th,
    description_en = EXCLUDED.description_en,
    permission_level = EXCLUDED.permission_level,
    is_assignable = EXCLUDED.is_assignable,
    updated_at = now();

ALTER TABLE public.auth_users
    ADD COLUMN IF NOT EXISTS role_code text;

ALTER TABLE public.auth_users
    ADD COLUMN IF NOT EXISTS role_updated_at timestamptz;

ALTER TABLE public.auth_users
    ADD COLUMN IF NOT EXISTS role_updated_by_user_id bigint;

UPDATE public.auth_users
SET role_code = 'member'
WHERE role_code IS NULL
   OR role_code NOT IN ('super_admin', 'admin', 'moderator', 'support', 'member');

UPDATE public.auth_users
SET role_code = 'super_admin',
    role_updated_at = COALESCE(role_updated_at, now())
WHERE lower(email) = 'mapxprop@gmail.com';

ALTER TABLE public.auth_users
    ALTER COLUMN role_code SET DEFAULT 'member';

ALTER TABLE public.auth_users
    ALTER COLUMN role_code SET NOT NULL;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'auth_users_role_code_fkey'
    ) THEN
        ALTER TABLE public.auth_users
            ADD CONSTRAINT auth_users_role_code_fkey
            FOREIGN KEY (role_code) REFERENCES public.platform_roles(code);
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'auth_users_role_updated_by_fkey'
    ) THEN
        ALTER TABLE public.auth_users
            ADD CONSTRAINT auth_users_role_updated_by_fkey
            FOREIGN KEY (role_updated_by_user_id) REFERENCES public.auth_users(id) ON DELETE SET NULL;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'auth_users_primary_super_admin_role_check'
    ) THEN
        ALTER TABLE public.auth_users
            ADD CONSTRAINT auth_users_primary_super_admin_role_check
            CHECK (lower(email) <> 'mapxprop@gmail.com' OR role_code = 'super_admin');
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'auth_users_super_admin_email_check'
    ) THEN
        ALTER TABLE public.auth_users
            ADD CONSTRAINT auth_users_super_admin_email_check
            CHECK (role_code <> 'super_admin' OR lower(email) = 'mapxprop@gmail.com');
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_auth_users_role_code
    ON public.auth_users(role_code, created_at DESC)
    WHERE deleted_at IS NULL;

CREATE TABLE IF NOT EXISTS public.auth_user_role_audit (
    id bigserial PRIMARY KEY,
    user_id bigint NOT NULL REFERENCES public.auth_users(id) ON DELETE CASCADE,
    previous_role_code text NOT NULL REFERENCES public.platform_roles(code),
    new_role_code text NOT NULL REFERENCES public.platform_roles(code),
    changed_by_user_id bigint REFERENCES public.auth_users(id) ON DELETE SET NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    CHECK (previous_role_code <> new_role_code)
);

CREATE INDEX IF NOT EXISTS idx_auth_user_role_audit_user
    ON public.auth_user_role_audit(user_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_auth_user_role_audit_changed_by
    ON public.auth_user_role_audit(changed_by_user_id, created_at DESC);

COMMIT;
