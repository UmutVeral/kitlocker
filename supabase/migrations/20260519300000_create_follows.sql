-- follows: yönlü takip grafiği
CREATE TABLE public.follows (
  id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  follower_id uuid        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  followee_id uuid        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at  timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT follows_unique UNIQUE (follower_id, followee_id),
  CONSTRAINT no_self_follow CHECK  (follower_id <> followee_id)
);

ALTER TABLE public.follows ENABLE ROW LEVEL SECURITY;

-- herkes takip listelerini okuyabilir (public follow graph)
CREATE POLICY "follows_select" ON public.follows
  FOR SELECT TO authenticated USING (true);

-- sadece kendi adına takip ekleyebilirsin
CREATE POLICY "follows_insert" ON public.follows
  FOR INSERT TO authenticated WITH CHECK (follower_id = auth.uid());

-- sadece kendi takibini silebilirsin
CREATE POLICY "follows_delete" ON public.follows
  FOR DELETE TO authenticated USING (follower_id = auth.uid());

GRANT SELECT, INSERT, DELETE ON public.follows TO authenticated;

-- FCM token: notify-new-follower Edge Function için (#14 tamamlandığında aktif olacak)
ALTER TABLE public.profiles ADD COLUMN fcm_token text;
