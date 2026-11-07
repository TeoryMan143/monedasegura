# Seed

Demo data for Moneda Segura: catalogs, a simulated bank with six countries, injected fraud
patterns, AI alerts, labels with history and the analyst accounts.

| File | What it does |
| --- | --- |
| `catalogs.sql` | Defines `seed.load_catalogs()` and loads currencies, countries, cities, banks, channels, MCCs, fraud types, confidence and severity levels, severity thresholds and exchange rates. |
| `generator.sql` | Installs the generator in the private `seed` schema: `seed.reset_demo_data()`, `seed.populate()` and one function per phase. Only defines functions. |
| `reset.sql` | Runs `seed.reset_demo_data()`: wipes `public` (and the seed users in `auth.users`) and rebuilds everything. |
| `reset.sh` / `reset.ps1` | Run the three files in order against a database with `psql`. |

## Reset the database

Every way below leaves the database in the **same state** (same rows, same ids). It takes 2–3
minutes.

**Hosted project, with psql.** Get the connection string from Dashboard → Connect → *Session
pooler*, then:

```bash
SUPABASE_DB_URL='postgresql://postgres.<ref>:<db-password>@<pooler-host>:5432/postgres' ./supabase/seed/reset.sh
```

```powershell
$env:SUPABASE_DB_URL = 'postgresql://postgres.<ref>:<db-password>@<pooler-host>:5432/postgres'
./supabase/seed/reset.ps1
```

**Hosted project, without psql.** In the dashboard SQL editor, run `catalogs.sql`, then
`generator.sql`, then `reset.sql`. Once the first two are installed, later resets only need:

```sql
set statement_timeout = '15min';
select seed.reset_demo_data();
```

**Local stack.** `supabase db reset` runs the three files as the seed (see `config.toml`). The
local migrations must create the schema first.

To keep the same data but move every date so it ends today:
`select seed.reset_demo_data(now());`.

## Analyst accounts

All seed accounts share the password **`MonedaSegura2026!`**. It is demo data only, so never use it
anywhere real.

| Email | Name |
| --- | --- |
| `demo@monedasegura.test` | Analista Demo |
| `jonathan.cortes@monedasegura.test` | Jonathan Cortés |
| `andres.martinez@monedasegura.test` | Andrés Martínez |
| `juan.borrero@monedasegura.test` | Juan Camilo Borrero |
| `juan.pelaez@monedasegura.test` | Juan Camilo Peláez |
| `laura.gomez@monedasegura.test` | Laura Gómez |
| `mateo.rojas@monedasegura.test` | Mateo Rojas |

A reset only deletes users whose email ends in `@monedasegura.test`. Real sign-ups keep their
account and get their notifications rebuilt, but their own labels are wiped with the rest of the
data.

## What gets generated (anchor 2026-11-07)

| Table | Rows |
| --- | --- |
| customers | 2,000 (CO 600 · MX 440 · PE 280 · CL 240 · AR 220 · BR 220) |
| accounts | 3,674 own + 720 counterparties at other banks |
| cards · devices · merchants | 2,716 · 3,464 · 720 |
| transactions | 77,550 over six months, ids in time order (`TX-1` is the oldest) |
| ledger_entries | 83,325, with running balances that never go negative |
| security_events | 29,211 |
| ai_alerts | 1,500 (317 pending · 690 confirmed · 339 rejected · 154 reclassified) |
| ai_alert_reasons | 4,571 (2–5 per alert, Spanish text with the metric behind it) |
| labels | 13,694 (17.7 % of transactions; 550 edited once, 152 twice) |
| audit_log · notifications · disputes | 15,731 · one per alert and analyst · 947 |

**Injected patterns.** These are 1,100 frauds and 400 false positives, recorded in
`seed.injected_patterns` (not exposed through the API):

| Code | Pattern |
| --- | --- |
| `ATO` | Failed logins, new device, password change, then a burst of transfers to new beneficiaries |
| `PHI` | The customer sends 1–3 large transfers to a new beneficiary from their own phone |
| `CLO` | A purchase at home, then card-present purchases in another city or country minutes later |
| `MUL` | A recently opened account takes money from many senders and empties it within hours |
| `LAV` | Deposits just under the reporting threshold, then one consolidated transfer |
| `SIN` | A brand-new customer maxes out the credit line within days |
| `SIM` | SIM change, then a phone change, then transfers from a new device |
| `CNR` | Card-not-present purchases at night from a foreign IP, followed by customer claims |
| False positives | A customer travelling (ticket bought weeks before), a big legitimate payment, a seller paid by several clients, late-night streaming |

About 20 % of the alerts suggest the wrong type, and analysts reclassify most of them. Some
analysts also make mistakes, which gives the confusion matrix and the AI statistics real
content. Some pending alerts already have a manual label on their main transaction.

To see what is behind an alert:

```sql
select a.code, p.description, p.is_false_positive
from seed.injected_patterns p
join seed.injected_pattern_transactions pt on pt.pattern_id = p.id
join public.ai_alert_transactions at on at.transaction_id = pt.transaction_id
join public.ai_alerts a on a.id = at.alert_id
where a.code = 'AL-1777';
```

## How it works

- **Reproducible.** Every value comes from `seed.h(key)`, the md5 of a stable key, never from
  `random()`. The same anchor always gives the same data, including the uuids.
- **History.** Audit rows, label versions and notifications are written by the generator with
  past dates, in the same shape the triggers produce. The triggers that stamp `now()` are off
  during the load and back on at the end. The deferred check "fraud needs a fraud type" stays on.
- **Severity thresholds** (open point 1 of the user stories): about 1 M / 5 M / 20 M COP for
  medium / high / critical in every currency, defined in `catalogs.sql`.
- To change the data, edit `generator.sql` and reset. If you change a staging table
  (`seed.stg_*`), drop it once by hand: `generator.sql` only creates the ones that are missing.
