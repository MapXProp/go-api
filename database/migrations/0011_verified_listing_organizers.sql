BEGIN;

-- Verification belongs to the organizer, not to every individual event round.
-- A listing can still require the user to reconfirm price and availability even
-- when the organizer's identity and contact channels have been checked.
CREATE TABLE IF NOT EXISTS public.listing_organizers (
    id bigserial PRIMARY KEY,
    slug text NOT NULL UNIQUE,
    display_name text NOT NULL,
    website_url text,
    contact_phone text,
    line_id text,
    verification_status text NOT NULL DEFAULT 'unverified',
    verified_at timestamptz,
    verification_note text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CHECK (verification_status IN ('unverified', 'contact_checked', 'verified'))
);

ALTER TABLE public.listing_event_details
    ADD COLUMN IF NOT EXISTS organizer_id bigint REFERENCES public.listing_organizers(id) ON DELETE SET NULL;

INSERT INTO public.listing_organizers (
    slug,
    display_name,
    website_url,
    contact_phone,
    line_id,
    verification_status,
    verified_at,
    verification_note
) VALUES (
    'hbd-event',
    'HBD Event',
    'https://hbd.co',
    '0992602026',
    '@hbdtalk',
    'verified',
    now(),
    'ผู้ดูแล MapxProp ตรวจสอบชื่อผู้จัดและช่องทางติดต่อแล้ว สถานะนี้ไม่ใช่การรับประกันราคา จำนวนบูธ หรือคิวว่าง'
)
ON CONFLICT (slug) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    website_url = EXCLUDED.website_url,
    contact_phone = EXCLUDED.contact_phone,
    line_id = EXCLUDED.line_id,
    verification_status = EXCLUDED.verification_status,
    verified_at = COALESCE(public.listing_organizers.verified_at, EXCLUDED.verified_at),
    verification_note = EXCLUDED.verification_note,
    updated_at = now();

UPDATE public.listing_event_details led
SET organizer_id = organizer.id,
    updated_at = now()
FROM public.listing_organizers organizer
WHERE organizer.slug = 'hbd-event'
  AND lower(trim(led.organizer_name)) = lower(organizer.display_name);

COMMIT;
