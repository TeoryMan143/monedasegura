# Supabase

Schema, seed and database tests for Moneda Segura. The rules for changing them are in
[`.agents/DATABASE.md`](../.agents/DATABASE.md), and the seed is described in
[`seed/README.md`](seed/README.md).

| Folder | What it holds |
| --- | --- |
| `migrations/` | The schema, applied in order. Never edit a merged migration. |
| `seed/` | Catalogs and the deterministic demo data (`supabase db reset` loads it). |
| `tests/` | pgTAP tests: the database enforces the business rules, and these prove it. |

## Database tests

Always run them against the **local** stack, never against the hosted project.

```bash
supabase start        # local stack (Docker)
supabase db reset     # migrations + seed, the tests read the seed data
supabase test db      # runs every file in supabase/tests with pg_prove
```

`supabase test db supabase/tests/resolve_alert_test.sql` runs a single file.

Each file runs inside `begin … rollback`, so a run leaves the database exactly as the reset
left it and the tests can run in any order. They act as a seed analyst by setting
`role authenticated` and `request.jwt.claims` (`demo@` and `jonathan.cortes@monedasegura.test`),
so `auth.uid()`, RLS and the grants behave as they do for the app.

| File | Covers |
| --- | --- |
| `resolve_alert_test.sql` | HU-08: confirm, reject and reclassify; excluded transactions keep their label or stay unlabeled; the second analyst gets `alert_already_resolved`; `final_type_must_differ`, `invalid_action`, `alert_not_found`, `fraud_type_required`, `severity_not_allowed`, `justification_required`; only analysts may call it. |
| `label_transactions_test.sql` | HU-04, HU-05: fraud without a type, not_fraud with a severity, justification required with confidence Baja or Incierto, unknown transactions; returns how many already had a label; fraud types replaced; the label CHECKs and the fraud-type trigger without the RPC. |
| `label_triggers_test.sql` | HU-15, HU-16: version bump, last write wins, `is_labeled` kept in sync, one `audit_log` row per save with old and new values, one notification per analyst for a new alert. |
| `rls_test.sql` | Cross-cutting: analysts cannot write `audit_log`, `ai_alerts` or catalogs, cannot write labels as someone else or delete them, and only see their own notifications; `anon` gets nothing. |

A new rule in a migration comes with its test in the same change.
