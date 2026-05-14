-- profiles tablosuna authenticated kullanıcılar için açık INSERT policy eklendi
-- (profiles_insert_own var ama roles kısıtı yoktu, bu ek policy kesinleştirir)
CREATE POLICY "users can insert own profile"
  ON public.profiles
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);
