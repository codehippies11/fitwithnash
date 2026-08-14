create table if not exists public.site_media (
  key text primary key check (key in ('hero_portrait', 'home_journey_arun', 'home_journey_krisham', 'home_journey_farbeena')),
  image_url text not null,
  updated_at timestamptz not null default now()
);

alter table public.site_media enable row level security;

do $$
begin
  if not exists (select 1 from pg_policies where schemaname = 'public' and tablename = 'site_media' and policyname = 'public can read website media') then
    create policy "public can read website media" on public.site_media for select using (true);
  end if;
  if not exists (select 1 from pg_policies where schemaname = 'public' and tablename = 'site_media' and policyname = 'editors manage website media') then
    create policy "editors manage website media" on public.site_media for all using (public.is_cms_editor()) with check (public.is_cms_editor());
  end if;
end $$;
