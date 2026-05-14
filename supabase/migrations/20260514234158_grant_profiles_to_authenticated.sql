-- GRANT: RLS policy tek başına yetmez, role bazında tablo erişimi de gerekli
-- Bu olmadan authenticated/anon rolleri "permission denied for table profiles" alır
GRANT SELECT, INSERT, UPDATE ON public.profiles TO authenticated;
GRANT SELECT, INSERT, UPDATE ON public.profiles TO anon;
