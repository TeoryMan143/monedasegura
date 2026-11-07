-- Baseline 4/14 · analysts. Every authenticated user is an analyst: a trigger on auth.users
-- creates the row.

create table public.analysts (
  id uuid not null,
  full_name text not null,
  email extensions.citext not null,
  last_seen_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint analysts_pkey primary key (id),
  constraint analysts_email_key unique (email),
  constraint analysts_id_fkey foreign key (id) references auth.users (id) on delete cascade
);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path to ''
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

create trigger trg_analysts_updated_at
  before update on public.analysts
  for each row execute function public.set_updated_at();

create or replace function public.handle_new_auth_user()
returns trigger
language plpgsql
security definer
set search_path to ''
as $$
begin
  insert into public.analysts (id, full_name, email)
  values (
    new.id,
    coalesce(nullif(new.raw_user_meta_data ->> 'full_name', ''), split_part(new.email, '@', 1)),
    new.email
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_auth_user();

-- Used by every RLS policy. security definer so it can read analysts under RLS.
create or replace function public.is_analyst()
returns boolean
language sql
stable
security definer
set search_path to ''
as $$
  select exists (select 1 from public.analysts where id = auth.uid());
$$;
