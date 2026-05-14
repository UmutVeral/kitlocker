-- GRANT: locker_entries tablosuna authenticated rol erişimi
-- RLS policy'ler zaten var (select/insert/update/delete own), bu GRANT onları aktif kılar
GRANT SELECT, INSERT, UPDATE, DELETE ON public.locker_entries TO authenticated;
