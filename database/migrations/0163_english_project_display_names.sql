BEGIN;

-- Registered projects already have name_en. Preserve the original Thai names
-- on older, unregistered listings and store their English display names separately.
ALTER TABLE public.listings ADD COLUMN IF NOT EXISTS custom_project_name_en text NOT NULL DEFAULT '';

WITH names(name_th, name_en) AS (VALUES
    ('บิ๊กแลนด์ แฟคตอรี่', 'Bigland Factory'),
    ('โรงแรมแสงรุ้ง อินเตอร์ปาร์ค', 'Saeng Rung Interpark Hotel'),
    ('วังทองธานี', 'Wang Thong Thani'),
    ('เดอะบูเลอวาร์ด ศรีราชา', 'The Boulevard Si Racha'),
    ('บุญรักษา', 'Boon Raksa'),
    ('สุเจริญป่าตอง', 'Su Charoen Patong'),
    ('บ้านสวนสุวัฒนา เฟส 1', 'Ban Suan Suwattana Phase 1'),
    ('ทรัพย์แสนล้าน', 'Sap Saen Lan'),
    ('ศรีราชานคร', 'Si Racha Nakhon'),
    ('ไออุ่นเพลส', 'Ai Oon Place'),
    ('กาญจน์กนกทาวน์ 1', 'Karnkanok Town 1'),
    ('กาญจน์กนกวิลล์ 4', 'Karnkanok Ville 4'),
    ('เดอะเซลิโอ', 'The Celio'),
    ('บุญฟ้าแกรนด์โฮม', 'Boonfa Grand Home'),
    ('กรีนวิวโฮม', 'Greenview Home'),
    ('อรสิริน 11', 'Ornsirin 11'),
    ('บ้านไทย', 'Baan Thai'),
    ('บ้านโนนสะอาด', 'Ban Non Sa-at'),
    ('เดอะ เอสบล็อค คอนโดมิเนียม', 'The S Block Condominium'),
    ('สีวลี', 'Siwalee'),
    ('ภิรมย์สุข', 'Phirom Suk'),
    ('วี พร็อพเพอร์ตี้ ร.8', 'V Property R.8'),
    ('หมู่บ้านพรทวีวัฒน์', 'Phon Thawi Wat'),
    ('ลัดดารมย์ อิลิแกนซ์', 'Laddarom Elegance'),
    ('กรีนพลัสมอลล์ 3', 'Green Plus Mall 3'),
    ('พรรณทิวาวิลล่า', 'Phantiva Villa'),
    ('หมู่บ้านอยู่เจริญ', 'Yoo Charoen'),
    ('โรงแรมเซาท์เทอร์นสตาร์', 'Southern Star Hotel'),
    ('ศุภาลัย การ์เด้นวิลล์', 'Supalai Garden Ville'),
    ('บ้านสวย-แยกป่าไม้', 'Baan Suay-Yak Pa Mai'),
    ('บ้านสวยพารากอน', 'Baan Suay Paragon'),
    ('เดอะ เนจอร์ ลิฟวิ่งโฮม', 'The Nature Living Home'),
    ('กุลพันธ์วิลล์ 8', 'Kulphan Ville 8')
)
UPDATE public.listings listing
SET custom_project_name_en = names.name_en
FROM names
WHERE trim(listing.custom_project_name) = names.name_th
  AND trim(listing.custom_project_name_en) = '';

COMMIT;
