# Database (Supabase)

The backend is Supabase only: Auth, Postgres 15+, Row Level Security and Realtime. There is no
custom server. The schema contract is the ERM in [`docs/mer.puml`](../docs/mer.puml) (rendered
as `docs/mer.svg`). This file says how to implement and change it. App-side access rules are in
[`ARCHITECTURAL_SPINE.md`](./ARCHITECTURAL_SPINE.md).

## Layout

```text
supabase/
  config.toml                 supabase init; seed paths point at seed/*.sql
  migrations/                 <timestamp>_<what>.sql, applied in order, never edited once merged
  seed/
    catalogs.sql              currencies, countries, cities, banks, channels, MCCs, fraud_types,
                              confidence_levels, severity_levels, severity_thresholds, exchange_rates
    generator/                Python + Faker script that writes data.sql (customers, accounts,
                              transactions, alerts, sample labels)
    data.sql                  generated, git-ignored (too large to commit)
  tests/                      pgTAP tests (supabase test db)
```

Suggested first migrations, one concern each:

1. extensions (`citext`, `pg_trgm`)
2. enums
3. catalogs
4. analysts and the trigger on `auth.users`
5. banking tables
6. labeling
7. AI alerts
8. notifications and audit
9. triggers
10. RPCs
11. views
12. RLS and grants
13. realtime publication
14. indexes

## Rules

1. **The ERM is the contract.** Any schema change updates, in the same change:
   - `docs/mer.puml` (and the re-rendered `mer.svg`)
   - a **new** migration
   - the affected Dart models and their tests
   - the seed, if it is affected

   Never edit a migration that others may have applied.
2. **Naming:**
   - English, `snake_case`, plural table names, enum values as in the ERM.
   - `timestamptz` for instants, `date` for days.
   - Money is `numeric(18,2)` with its `currency_code` next to it. Never floats.
   - Coordinates are `numeric(9,6)`.
3. **The database enforces the business rules.** CHECKs, triggers and RPCs implement every rule
   in the ERM notes. The app's checks are only a convenience. If a rule can be broken by a
   direct API call, it is not implemented.
4. **Catalogs are read only for the app.** This covers `fraud_types`, `confidence_levels`,
   `severity_levels`, `severity_thresholds`, `currencies`, `countries`, `cities`, `banks`,
   `channels`, `merchant_categories` and `exchange_rates`. The seed loads them and `authenticated`
   only gets `SELECT`.
5. **One current label per transaction, last write wins.** `labels.transaction_id` is unique.
   Each save bumps `version` and sets `analyst_id = auth.uid()` and `updated_at` **in the
   database** (default / trigger), never from client input. The history lives in `audit_log`.
6. **Audit is append only.** AFTER INSERT/UPDATE triggers on `labels` (with its fraud types) and
   `ai_alerts` write `audit_log` (analyst, action, entity, entity id, transaction id, old and new
   JSON). `authenticated` has no `INSERT`, `UPDATE` or `DELETE` on `audit_log`. The trigger is
   `security definer`.
7. **`transactions.is_labeled`** is maintained by a trigger on `labels`. Never set it from the app.
8. **Notifications:** an AFTER INSERT trigger on `ai_alerts` creates one `alert_new` row per
   analyst ("Nueva alerta · score 92"). Analysts can only read and mark as read (`read_at`)
   their own rows.

## RLS and grants

- RLS is **enabled on every table in `public`**. The `anon` role gets nothing.
- `authenticated` can `SELECT` all banking data, catalogs, alerts, labels and audit. There is no
  per-customer restriction and no masking.
- Writes allowed to `authenticated`:
  - `labels` / `label_fraud_types`: through `save_label` and `label_transactions` (direct
    `INSERT`/`UPDATE` policies may exist, but the app uses the RPCs).
  - `ai_alerts`: **only** through `resolve_alert` (`security definer`). No direct `UPDATE`.
  - `notifications`: `UPDATE (read_at)` where `analyst_id = auth.uid()`.
- Views are created with `security_invoker = true` so the caller's RLS applies.
- The service-role key is used only by the local seed script. It never goes in the app or in
  git.

## RPCs

All RPCs:

- run in one transaction
- validate their input
- raise errors with a stable **key** in the message, which the app maps to Spanish text in
  `core/errors`: `raise exception 'alert_already_resolved' using errcode = 'P0001'`

| Function | Does | Error keys |
| --- | --- | --- |
| `save_label(p_transaction_id, p_verdict, p_fraud_type_ids smallint[], p_confidence, p_severity, p_justification)` | Upserts the label and replaces its fraud types atomically (`source = 'manual'`). Returns the label with analyst and version. | `fraud_type_required`, `severity_required`, `severity_not_allowed`, `justification_required`, `transaction_not_found` |
| `label_transactions(p_transaction_ids bigint[], …same fields)` | Applies one label to many transactions (HU-05). Returns `{updated, overwritten}`. | same |
| `resolve_alert(p_alert_id, p_action, p_final_type_id, p_confidence, p_severity, p_justification, p_excluded_transaction_ids bigint[])` | Locks the alert (`SELECT … FOR UPDATE`) and fails if it is not `pending`, so the first analyst wins. Sets status, `resolved_by`, `resolved_at`, `final_type_id`, then creates or replaces the label of each involved transaction not excluded (`source = 'alert'`): confirm → fraud + suggested type; reject → not_fraud; reclassify → fraud + another type. Excluded transactions keep their current label. | `alert_already_resolved`, `invalid_action`, `final_type_must_differ`, plus the label keys |
| `global_search(p_query text, p_limit int)` | Searches customers (`search_vector`, trigram on names, document number), accounts (`last4`) and transactions (`code`). Returns rows grouped by `kind` (customer, account, transaction). | — |

## Views (read models)

The app reads lists and statistics from views, so it never joins on the client:

| View | Feeds |
| --- | --- |
| `v_transactions_list` | A-01 and the customer view table: transaction + customer + masked account + country + channel + top pending/any alert score + label verdict and status |
| `v_customer_label_progress` | Customer view header: labeled / total, pending alerts |
| `v_labeling_progress` | Statistics KPI "Avance del etiquetado" |
| `v_fraud_stats` | Statistics "Fraude": counts over time, by type / channel / country, and the **committed amount converted to COP** with `exchange_rates` |
| `v_ai_performance` | Statistics "IA": % confirmed / rejected / reclassified, precision by type, confusion matrix (suggested × final) |
| `v_account_balance_history` | Report "Cuentas" and the summary activity chart |

`v_transfer_edges` (transfer graph) and precision by score range are **out of scope**. Do not
build them. Filters (date range, country) must be pushable into the views' `WHERE`, so add the
columns the filters need.

## Realtime

- Add `ai_alerts`, `labels`, `transactions` and `notifications` to the `supabase_realtime`
  publication.
- `REPLICA IDENTITY FULL` on `ai_alerts` and `labels`, so updates carry the old status.
- Realtime respects RLS: the analysts' `SELECT` policies are what let them receive events.

## Indexes

From the ERM:

- `transactions(source_account_id, occurred_at)`, `transactions(destination_account_id, occurred_at)`
- `transactions(is_labeled, occurred_at)`
- `ai_alerts(status, score desc)`
- `security_events(customer_id, occurred_at)`
- `audit_log(entity, entity_id)`, `audit_log(transaction_id)`
- `notifications(analyst_id) where read_at is null`
- `pg_trgm` GIN on customer names, GIN on `customers.search_vector`

Add an index for every new filter or sort the UI offers, and check it with
`explain analyze` against the full seed.

## Seed

- **Reproducible:** a fixed random seed. `supabase db reset` rebuilds the same data every
  time.
- **Target volumes:** about 2,000 customers, 3,500 accounts, 50,000+ transactions over several
  months, and 1,500 AI alerts.
- **Countries and data:**
  - Colombia, Mexico, Peru, Chile, Argentina and Brazil, with their currencies (COP, MXN, PEN,
    CLP, ARS, BRL), real cities and coordinates.
  - Local channels (PSE, SPEI, Yape, Pix, interbank, ATM, POS, app, web, payroll).
  - Faker locales per country and documents per `countries.primary_document_type`.
- **Fraud patterns are injected on purpose** and recorded in the private `seed` schema
  (`seed.injected_patterns`), never exposed through the API:
  - burst after a password change
  - impossible travel
  - structuring
  - new device + SIM change
  - mule accounts
  - and so on
  
  Include **false-positive alerts** (alerts that should be rejected) and alerts whose
  transactions already have a label.
- Alerts carry 2–5 readable reasons with `weight`, `evidence` and `metric` (the "dato que las
  respalda"), in Spanish, e.g. "Monto 8,2× mayor al promedio de 90 días".
- **Labels:** pre-label a share of transactions so progress, statistics and history are not
  empty, with several analysts and edits.
- **Analysts:** one local user per team member plus a demo user, created through the Auth admin
  API from the script. Local passwords only.
- **Severity thresholds per currency:** an open point in the stories. Define them in
  `catalogs.sql` and keep them consistent with the injected amounts.
- **Exchange rates:** fixed `rate_to_cop` per currency in `catalogs.sql`, dated with
  `as_of`. It is simulated data, not a live feed.

## Tests (`supabase/tests`, pgTAP)

Run them with `supabase test db`. They cover:

- `anon` sees nothing.
- `authenticated` can read but not write catalogs, alerts or audit directly.
- Every label CHECK and trigger rule, including at least one fraud type for `fraud`.
- `resolve_alert`: each action, excluded transactions, and the second resolver getting
  `alert_already_resolved`.
- Audit rows are written and cannot be updated or deleted.
- `is_labeled` and notifications triggers.
