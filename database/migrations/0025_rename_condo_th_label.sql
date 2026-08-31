-- Use the concise Thai label throughout the product while preserving
-- "คอนโดมิเนียม" as a backwards-compatible search alias.

UPDATE public.property_types
SET
    name_th = 'คอนโด',
    updated_at = now()
WHERE code = 'condo'
  AND name_th IS DISTINCT FROM 'คอนโด';
