# Moneda Segura

Flutter desktop app (Windows, macOS, Linux) where fraud analysts of a fictional Latin American
bank review banking transactions and **label** them: fraud or not, type, confidence, severity
and justification. The labels form the dataset used to train a fraud detection model.
Analysts also verify alerts raised by a simulated AI, read a customer report (summary,
accounts, timeline, map), export it to PDF and look at statistics.

Academic project for Universidad Icesi. The backend is Supabase (Auth, Postgres, Realtime,
RLS). The bank data and the AI are simulated by a seed script.

- Scope, rules and glossary: [`AGENTS.md`](AGENTS.md)
- Architecture: [`.agents/ARCHITECTURAL_SPINE.md`](.agents/ARCHITECTURAL_SPINE.md)
- Design system: [`.agents/DESIGN.md`](.agents/DESIGN.md)
- Database: [`.agents/DATABASE.md`](.agents/DATABASE.md) and the ERM [`docs/mer.puml`](docs/mer.puml)
- User stories (Spanish): [`docs/historias-de-usuario.md`](docs/historias-de-usuario.md)

## Stack

Flutter (stable, Dart ^3.13) · Riverpod (hand-written providers) · freezed / json_serializable ·
go_router · supabase_flutter · intl · fl_chart · flutter_map · pdf / printing · file_selector ·
window_manager · flutter_svg · mocktail.

## Getting started

Requirements: Flutter stable (3.47+), the desktop toolchain for your OS
(`flutter doctor`), Docker, and the [Supabase CLI](https://supabase.com/docs/guides/local-development)
(or use it through `npx supabase …`).

```bash
flutter pub get
dart run build_runner build -d      # generated files (*.g.dart, *.freezed.dart)
```

### Supabase keys

The app reads `SUPABASE_URL` and `SUPABASE_ANON_KEY` at build time. Without them it opens a
"Falta configuración" screen. Create an `env.json` in the project root (git-ignored):

```json
{
  "SUPABASE_URL": "http://127.0.0.1:54321",
  "SUPABASE_ANON_KEY": "<anon key from `supabase status`>"
}
```

Only the anon (publishable) key goes here. Never the service-role key.

### Run

```bash
flutter run -d linux --dart-define-from-file=env.json     # or -d windows / -d macos
```

Passing the values one by one also works:
`--dart-define=SUPABASE_URL=… --dart-define=SUPABASE_ANON_KEY=…`.

## Commands

| Command | What it does |
| --- | --- |
| `flutter pub get` | Install dependencies |
| `dart run build_runner build -d` | Generate code after changing `@freezed` / `@JsonSerializable` |
| `dart run build_runner watch -d` | Same, continuously while developing |
| `dart format lib test` | Format |
| `flutter analyze` | Lints (must be clean, infos included) |
| `flutter test` | Unit and widget tests |
| `supabase start` | Start the local Supabase stack (Docker) |
| `supabase status` | Show local URLs and keys |
| `supabase db reset` | Re-apply migrations and the seed |
| `supabase migration new <name>` | Create a new migration |
| `supabase test db` | Run the pgTAP database tests |

Before handing work back: generated files are up to date, `dart format`, `flutter analyze` and
`flutter test` are clean, and the screen was checked at 1280×720.

## Project layout

```text
lib/
  main.dart        env check, window (min 1280×720), Supabase.initialize, ProviderScope
  app/             MaterialApp.router, router (auth redirect + shell branches), shell
  core/            config, supabase, errors, theme tokens, ui kit, domain enums, formatting…
  features/<f>/    data → domain → presentation, one folder per feature
assets/            fonts (Plus Jakarta Sans), icons, images
supabase/          config.toml, migrations, seed, tests
test/              mirrors lib/
```

## Progress

### Project setup

- [x] Dependencies, lints (`flutter_lints` + `riverpod_lint`) and code generation (freezed / json)
- [x] Riverpod providers written by hand, without `riverpod_generator` ([why](docs/migracion-riverpod-manual.md))
- [x] Env config from `--dart-define` with a missing-config screen
- [x] Supabase initialisation and client / session providers
- [x] Window: title and minimum size 1280×720
- [x] Router with auth redirect and the three shell branches
- [x] Theme tokens: colours, status tones, typography, spacing, radius, shadows
- [x] `Failure` type and Supabase error mapping
- [x] Plus Jakarta Sans bundled
- [x] Supabase CLI config (`supabase/config.toml`, seed paths, public sign-up off)
- [x] Line icons (`assets/icons/`) exported from Figma, `AppIcon`
- [ ] Logos in `assets/images/` (Moneda Segura, Icesi positive / negative)
- [x] Component kit in `core/ui` (`AppButton`, `ScoreBadge`, `ScreenState`, `AppDataTable`…)
- [x] Domain enums with labels, tones and icons (`core/domain`)
- [x] Catalog repository and providers (`core/catalogs`)
- [x] Money and date formatting (`core/formatting`)
- [ ] Realtime service on Supabase Realtime channels (`core/realtime`; today a simulated service)
- [ ] Remove the in-memory prototype writes (`core/local_writes`): labels and alert
      resolutions saved through `label_transactions` / `resolve_alert`

### Database

- [x] Baseline migrations of the whole schema, tracked in `supabase/migrations`
- [x] Triggers (audit, `is_labeled`, label version, notifications)
- [x] RPCs: `label_transactions`, `resolve_alert` (stable error keys), `global_search`,
      `customer_range_totals`, statistics functions
- [x] Views: `v_transactions_list`, `v_customer_label_progress`, `v_labeling_progress`,
      `v_fraud_stats`, `v_ai_performance`, `v_stats_transactions`, `v_account_balance_history`
- [x] Realtime publication (`REPLICA IDENTITY FULL` on `ai_alerts`, `labels`) and indexes
- [x] Seed: catalogs and the deterministic generator (`supabase/seed/generator.sql`)
- [x] pgTAP tests (`supabase test db`, see [`supabase/README.md`](supabase/README.md))
- [ ] Alert generator for new alerts at runtime (F-10)

### User stories

Every story has its screens. The ones left open still save in memory or use the simulated
realtime service.

- [x] HU-01 Sign in / out
- [x] HU-02 Transaction list
- [x] HU-03 Customer view
- [ ] HU-04 Label one transaction (saves in memory)
- [ ] HU-05 Label many transactions (saves in memory)
- [x] HU-06 Alert inbox
- [x] HU-07 Alert detail
- [ ] HU-08 Resolve an alert (saves in memory)
- [x] HU-09 Customer report: Resumen, Cuentas
- [x] HU-10 Customer timeline
- [x] HU-11 Transaction map
- [x] HU-12 Export report to PDF
- [x] HU-13 Statistics
- [x] HU-14 Global search
- [x] HU-15 Audit and label history
- [ ] HU-16 Realtime and notifications (simulated realtime)
