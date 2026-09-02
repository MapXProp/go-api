BEGIN;

UPDATE public.platform_roles
SET description_th = 'ช่วยตรวจสอบข้อมูลประกาศเบื้องต้นและส่งประเด็นให้ Super Admin',
    description_en = 'Perform preliminary listing checks and escalate findings to the super admin',
    updated_at = now()
WHERE code = 'moderator';

COMMIT;
