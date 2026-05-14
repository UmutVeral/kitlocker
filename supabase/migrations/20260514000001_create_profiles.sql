-- citext extension: case-insensitive text için (username uniqueness)
create extension if not exists citext;

-- profiles tablosu
create table public.profiles (
  id           uuid        primary key references auth.users(id) on delete cascade,
  username     citext      not null,
  username_updated_at timestamptz not null default now(),
  created_at   timestamptz not null default now(),

  constraint username_length   check (char_length(username) between 3 and 30),
  constraint username_format   check (username ~ '^[a-zA-Z0-9_]+$')
);

-- username benzersizliği (citext olduğu için case-insensitive)
create unique index profiles_username_unique on public.profiles (username);

-- RLS aktif
alter table public.profiles enable row level security;

-- Herkes public profilleri okuyabilir
create policy "profiles_select_public"
  on public.profiles for select
  using (true);

-- Kullanıcı sadece kendi profilini güncelleyebilir
create policy "profiles_update_own"
  on public.profiles for update
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- Insert: sadece kendi kaydını ekleyebilir (trigger ile de yapılır ama direkt insert de açık olsun)
create policy "profiles_insert_own"
  on public.profiles for insert
  with check (auth.uid() = id);
