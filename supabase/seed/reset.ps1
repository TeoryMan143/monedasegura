# Resets a Supabase database to the reference demo state (catalogs + generated data + analysts).
#
#   $env:SUPABASE_DB_URL = 'postgresql://postgres.<ref>:<db-password>@<pooler-host>:5432/postgres'
#   ./supabase/seed/reset.ps1
#
# Take the URL from Dashboard → Connect → "Session pooler". Needs psql (PostgreSQL client).
param([string] $DbUrl = $env:SUPABASE_DB_URL)

$ErrorActionPreference = 'Stop'
if (-not $DbUrl) { throw 'Set SUPABASE_DB_URL (Dashboard → Connect → Session pooler).' }

psql $DbUrl -v ON_ERROR_STOP=1 -q `
  -f (Join-Path $PSScriptRoot 'catalogs.sql') `
  -f (Join-Path $PSScriptRoot 'generator.sql') `
  -f (Join-Path $PSScriptRoot 'reset.sql')
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
