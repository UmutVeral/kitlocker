CREATE TABLE locker_entries (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  kit_catalog_id uuid,
  team_name     text NOT NULL,
  league_id     uuid,
  season        text NOT NULL,
  player_name   text,
  number        text,
  condition     text NOT NULL CHECK (condition IN ('mint', 'excellent', 'good', 'worn')),
  notes         text,
  photos        text[] NOT NULL DEFAULT '{}',
  visualization_url text,
  is_favourite  boolean NOT NULL DEFAULT false,
  created_at    timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE locker_entries ENABLE ROW LEVEL SECURITY;

CREATE POLICY locker_entries_select_own
  ON locker_entries FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY locker_entries_insert_own
  ON locker_entries FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY locker_entries_update_own
  ON locker_entries FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY locker_entries_delete_own
  ON locker_entries FOR DELETE
  USING (auth.uid() = user_id);
