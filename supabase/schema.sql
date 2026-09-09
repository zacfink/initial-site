-- zacfinkelstein.ca — editable site content
-- Run this once: Supabase dashboard > SQL Editor > New query > Run.
-- Then run seed.sql to load the content currently shipped in index.html.

create table if not exists site_content (
  id          text primary key,
  data        jsonb not null,
  updated_at  timestamptz not null default now()
);

alter table site_content enable row level security;

-- The only policy on this table. Visitors may read; nothing grants them
-- insert, update or delete, so those are refused. Your own dashboard session
-- is not subject to RLS, which is what lets you edit in the table editor.
drop policy if exists "public read" on site_content;
create policy "public read" on site_content
  for select to anon, authenticated
  using (true);

-- Keep updated_at honest, since the default only applies on insert.
create or replace function site_content_touch()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists site_content_touch on site_content;
create trigger site_content_touch
  before update on site_content
  for each row execute function site_content_touch();
