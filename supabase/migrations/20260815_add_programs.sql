create table if not exists public.programs (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null check (slug ~ '^[a-z0-9]+(?:-[a-z0-9]+)*$'),
  label text not null,
  title text not null,
  description text not null,
  price text not null,
  image_url text,
  sort_order integer not null default 0,
  is_published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.programs enable row level security;

do $$
begin
  if not exists (select 1 from pg_policies where schemaname = 'public' and tablename = 'programs' and policyname = 'published programs are public') then
    create policy "published programs are public" on public.programs for select using (is_published or public.is_cms_editor());
  end if;
  if not exists (select 1 from pg_policies where schemaname = 'public' and tablename = 'programs' and policyname = 'editors manage programs') then
    create policy "editors manage programs" on public.programs for all using (public.is_cms_editor()) with check (public.is_cms_editor());
  end if;
end $$;
