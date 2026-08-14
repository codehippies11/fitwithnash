-- Run in Supabase SQL Editor. This is the complete serverless CMS data layer.
create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  role text not null default 'editor' check (role in ('admin', 'editor')),
  created_at timestamptz not null default now()
);

create table if not exists public.trainers (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null check (slug ~ '^[a-z0-9]+(?:-[a-z0-9]+)*$'),
  full_name text not null,
  headline text,
  bio text,
  avatar_url text,
  specialties text[] not null default '{}',
  instagram_url text,
  meta_title text,
  meta_description text,
  is_published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.cms_assets (
  id uuid primary key default gen_random_uuid(),
  alt_text text not null,
  url text not null,
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.trainers enable row level security;
alter table public.cms_assets enable row level security;

create or replace function public.is_cms_editor() returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.profiles where id = auth.uid() and role in ('admin', 'editor'));
$$;

create policy "published trainers are public" on public.trainers for select using (is_published or public.is_cms_editor());
create policy "editors manage trainers" on public.trainers for all using (public.is_cms_editor()) with check (public.is_cms_editor());
create policy "editors read assets" on public.cms_assets for select using (public.is_cms_editor());
create policy "editors manage assets" on public.cms_assets for all using (public.is_cms_editor()) with check (public.is_cms_editor());

insert into storage.buckets (id, name, public) values ('cms-images', 'cms-images', true) on conflict (id) do nothing;
create policy "public can view CMS images" on storage.objects for select using (bucket_id = 'cms-images');
create policy "editors upload CMS images" on storage.objects for insert with check (bucket_id = 'cms-images' and public.is_cms_editor());
create policy "editors update CMS images" on storage.objects for update using (bucket_id = 'cms-images' and public.is_cms_editor());
create policy "editors delete CMS images" on storage.objects for delete using (bucket_id = 'cms-images' and public.is_cms_editor());

-- After creating your first Supabase Auth user, promote it once:
-- insert into public.profiles (id, role) values ('YOUR_AUTH_USER_UUID', 'admin');
