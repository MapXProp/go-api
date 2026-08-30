BEGIN;

ALTER TABLE public.listings
    ADD COLUMN IF NOT EXISTS contact_phone_secondary text,
    ADD COLUMN IF NOT EXISTS instagram_handle varchar(30);

COMMENT ON COLUMN public.listings.contact_phone_secondary IS
    'Optional backup phone number supplied by the listing contact.';

COMMENT ON COLUMN public.listings.instagram_handle IS
    'Optional normalized Instagram username without the leading @ sign.';

COMMIT;
