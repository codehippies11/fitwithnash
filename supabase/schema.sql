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

-- Public image overrides used by the website. Editors change these in /studio.
create table if not exists public.site_media (
  key text primary key check (key in ('hero_portrait', 'home_journey_arun', 'home_journey_krisham', 'home_journey_farbeena')),
  image_url text not null,
  updated_at timestamptz not null default now()
);

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

create table if not exists public.transformations (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null check (slug ~ '^[a-z0-9]+(?:-[a-z0-9]+)*$'),
  client_name text not null,
  title text not null,
  story text not null,
  before_image_url text,
  after_image_url text,
  is_published boolean not null default false,
  created_at timestamptz not null default now()
);

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

alter table public.profiles enable row level security;
alter table public.trainers enable row level security;
alter table public.cms_assets enable row level security;
alter table public.site_media enable row level security;
alter table public.programs enable row level security;
alter table public.transformations enable row level security;
alter table public.testimonials enable row level security;

create or replace function public.is_cms_editor() returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.profiles where id = auth.uid() and role in ('admin', 'editor'));
$$;

create policy "published trainers are public" on public.trainers for select using (is_published or public.is_cms_editor());
create policy "editors manage trainers" on public.trainers for all using (public.is_cms_editor()) with check (public.is_cms_editor());
create policy "editors read assets" on public.cms_assets for select using (public.is_cms_editor());
create policy "editors manage assets" on public.cms_assets for all using (public.is_cms_editor()) with check (public.is_cms_editor());
create policy "public can read website media" on public.site_media for select using (true);
create policy "editors manage website media" on public.site_media for all using (public.is_cms_editor()) with check (public.is_cms_editor());
create policy "published programs are public" on public.programs for select using (is_published or public.is_cms_editor());
create policy "editors manage programs" on public.programs for all using (public.is_cms_editor()) with check (public.is_cms_editor());
create policy "published transformations are public" on public.transformations for select using (is_published or public.is_cms_editor());
create policy "editors manage transformations" on public.transformations for all using (public.is_cms_editor()) with check (public.is_cms_editor());
create policy "published testimonials are public" on public.testimonials for select using (is_published or public.is_cms_editor());
create policy "editors manage testimonials" on public.testimonials for all using (public.is_cms_editor()) with check (public.is_cms_editor());

insert into storage.buckets (id, name, public) values ('cms-images', 'cms-images', true) on conflict (id) do nothing;
create policy "public can view CMS images" on storage.objects for select using (bucket_id = 'cms-images');
create policy "editors upload CMS images" on storage.objects for insert with check (bucket_id = 'cms-images' and public.is_cms_editor());
create policy "editors update CMS images" on storage.objects for update using (bucket_id = 'cms-images' and public.is_cms_editor());
create policy "editors delete CMS images" on storage.objects for delete using (bucket_id = 'cms-images' and public.is_cms_editor());

-- After creating your first Supabase Auth user, promote it once:
-- insert into public.profiles (id, role) values ('YOUR_AUTH_USER_UUID', 'admin');
