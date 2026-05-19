-- Public showcase: anon kullanıcılar locker_entries okuyabilir
-- #17 gelince is_public filtresi eklenecek
CREATE POLICY locker_entries_select_public
  ON locker_entries FOR SELECT
  TO anon
  USING (true);
