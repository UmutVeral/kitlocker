-- username değiştirme: 30 günlük cooldown enforce eden fonksiyon
create or replace function public.update_username(new_username citext)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  last_change timestamptz;
begin
  select username_updated_at
    into last_change
    from public.profiles
   where id = auth.uid();

  if last_change is null then
    raise exception 'Profil bulunamadı';
  end if;

  if now() - last_change < interval '30 days' then
    raise exception 'Kullanıcı adını değiştirmek için % gün beklemelisiniz',
      30 - extract(day from now() - last_change)::int;
  end if;

  update public.profiles
     set username            = new_username,
         username_updated_at = now()
   where id = auth.uid();
end;
$$;

-- Fonksiyona erişim: sadece authenticated kullanıcılar
revoke all on function public.update_username(citext) from public;
grant execute on function public.update_username(citext) to authenticated;
