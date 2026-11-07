#!/usr/bin/env bash
# Resets a Supabase database to the reference demo state (catalogs + generated data + analysts).
#
#   SUPABASE_DB_URL='postgresql://postgres.<ref>:<db-password>@<pooler-host>:5432/postgres' \
#     ./supabase/seed/reset.sh
#
# Take the URL from Dashboard → Connect → "Session pooler". Needs psql (PostgreSQL client).
set -euo pipefail

dir="$(cd "$(dirname "$0")" && pwd)"
: "${SUPABASE_DB_URL:?Set SUPABASE_DB_URL (Dashboard → Connect → Session pooler)}"

psql "$SUPABASE_DB_URL" -v ON_ERROR_STOP=1 -q \
  -f "$dir/catalogs.sql" \
  -f "$dir/generator.sql" \
  -f "$dir/reset.sql"
