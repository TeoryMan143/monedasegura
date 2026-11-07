-- Baseline 1/14 · extensions.
-- The baseline (20261103000100–20261103001400) reproduces the schema that was first built in the
-- hosted project outside migrations. See docs/mer.puml and .agents/DATABASE.md.

create extension if not exists citext with schema extensions;
create extension if not exists pg_trgm with schema extensions;
create extension if not exists pgcrypto with schema extensions;
