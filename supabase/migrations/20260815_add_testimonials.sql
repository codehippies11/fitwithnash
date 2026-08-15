create table if not exists public.testimonials (
  id uuid primary key default gen_random_uuid(),
  client_name text not null,
  quote text not null,
  image_url text,
  sort_order integer not null default 0,
  is_published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.testimonials enable row level security;

do $$ begin
  if not exists (select 1 from pg_policies where schemaname = 'public' and tablename = 'testimonials' and policyname = 'published testimonials are public') then
    create policy "published testimonials are public" on public.testimonials for select using (is_published or public.is_cms_editor());
  end if;
  if not exists (select 1 from pg_policies where schemaname = 'public' and tablename = 'testimonials' and policyname = 'editors manage testimonials') then
    create policy "editors manage testimonials" on public.testimonials for all using (public.is_cms_editor()) with check (public.is_cms_editor());
  end if;
end $$;
