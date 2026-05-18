CREATE TABLE kit_catalog (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  fkapi_kit_id  text UNIQUE,
  team_name     text NOT NULL,
  league_id     text NOT NULL,
  season        text NOT NULL,
  kit_type      text NOT NULL CHECK (kit_type IN ('home', 'away', 'third')),
  image_url     text,
  created_at    timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX kit_catalog_team_name_idx ON kit_catalog (lower(team_name));
CREATE INDEX kit_catalog_season_idx ON kit_catalog (season);
CREATE INDEX kit_catalog_league_id_idx ON kit_catalog (league_id);

ALTER TABLE kit_catalog ENABLE ROW LEVEL SECURITY;

CREATE POLICY kit_catalog_select_authenticated
  ON kit_catalog FOR SELECT
  TO authenticated
  USING (true);

ALTER TABLE locker_entries
  ALTER COLUMN league_id TYPE text USING league_id::text;

ALTER TABLE locker_entries
  ADD CONSTRAINT locker_entries_kit_catalog_id_fkey
  FOREIGN KEY (kit_catalog_id) REFERENCES kit_catalog(id)
  ON DELETE SET NULL;

GRANT SELECT ON kit_catalog TO authenticated;
