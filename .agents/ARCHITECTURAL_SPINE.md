# Architectural spine

How the app is built: the stack, where code goes, how data flows from Supabase to the
screen, and the rules every feature follows. Read [`AGENTS.md`](../AGENTS.md) first for scope
and vocabulary. See [`DESIGN.md`](./DESIGN.md) for anything visual and
[`DATABASE.md`](./DATABASE.md) for the backend contract.

## Stack

| Concern | Choice |
| --- | --- |
| Framework | Flutter (stable), Dart ^3.13, **desktop only**: Windows, macOS, Linux |
| Backend | Supabase via `supabase_flutter`: Auth (email + password), Postgres (tables, views, RPCs), Realtime |
| State | `flutter_riverpod` + `riverpod_annotation` / `riverpod_generator` (code generation, `@riverpod`) |
| Models | `freezed` + `json_serializable` (immutable, `fromJson`, `copyWith`, unions) |
| Code generation | `build_runner` (`dart run build_runner build -d`); generated `*.g.dart` / `*.freezed.dart` are committed |
| Navigation | `go_router`: `StatefulShellRoute.indexedStack`, one branch per side menu destination |
| Formatting | `intl` (`NumberFormat.currency` with the locale and decimals of `currencies`, Spanish dates) |
| Charts | `fl_chart` |
| Map | `flutter_map` + OpenStreetMap tiles (no API key) + `latlong2` |
| PDF | `pdf` (build the document) + `printing` (raster helpers), saved through `file_selector`'s native save dialog |
| Window | `window_manager`: minimum size 1280×720, title "Moneda Segura" |
| Fonts and icons | Plus Jakarta Sans bundled in `assets/fonts/`, line icons as SVG in `assets/icons/` via `flutter_svg` |
| Tests | `flutter_test`, `mocktail` |
| Lint | `flutter_lints` (`analysis_options.yaml`) + `riverpod_lint`, `dart format` |

Add a package only when no listed one covers the need, and say why in the change.

## Layout

```text
lib/
  main.dart              init: env check, Supabase.initialize, window_manager, ProviderScope
  app/
    app.dart             MaterialApp.router, theme, Spanish locale
    router.dart          every route, auth redirect, shell branches
    shell/               AppShell (side nav + top bar + content), user menu, Ctrl/Cmd+K shortcut
  core/                  shared by every feature, depends on no feature
    config/              Env (SUPABASE_URL, SUPABASE_ANON_KEY from --dart-define)
    supabase/            supabaseClientProvider
    errors/              Failure (sealed) + mapping from Supabase exceptions
    domain/              shared enums and catalog models with their Spanish labels, tones, icons:
                         Verdict, Severity, ConfidenceLevel, AlertStatus, FraudType, Channel,
                         Currency, Country, score ranges
    catalogs/            CatalogRepository + keep-alive providers (fraud types, confidence and
                         severity levels, currencies, countries, channels)
    formatting/          money, dates, masked account (•••• 4417), relative time
    realtime/            RealtimeService + connectionStatusProvider
    theme/               tokens (AppColors, AppText, AppSpace, AppRadius, AppShadows) + app_theme.dart
    ui/                  the component kit: AppButton, StatusBadge, ScoreBadge, AppDataTable,
                         FilterPanel, SidePanel, AppDialog, ScreenState, KpiCard… (see DESIGN.md)
  features/
    auth/                HU-01
    transactions/        HU-02
    customer/            HU-03, HU-09, HU-10, HU-11 (customer view + report tabs)
    labeling/            HU-04, HU-05 (classification panel, bulk dialog, label validation)
    alerts/              HU-06, HU-07, HU-08
    statistics/          HU-13
    search/              HU-14
    audit/               HU-15 (label history dialog)
    notifications/       HU-16 (bell, panel, new-alert toast)
    pdf_export/          HU-12
assets/fonts/  assets/icons/  assets/images/   (logos: Moneda Segura, Icesi positive / negative)
test/          mirrors lib/
supabase/      see DATABASE.md
```

### Inside a feature

```text
features/<feature>/
  data/
    <feature>_repository.dart     queries and RPC calls, maps JSON ↔ domain, throws Failure
  domain/
    <entity>.dart                 @freezed models (with fromJson when they come from the API)
    <rule>.dart                   pure logic: validation, aggregation, chart transforms
  presentation/
    <name>_screen.dart            one widget per route
    controllers/<name>_controller.dart   @riverpod providers / Notifiers holding the screen's state
    widgets/                      widgets owned by this feature
```

| Layer | May import | Must not |
| --- | --- | --- |
| `domain` | `core/domain`, Dart, `freezed_annotation` | Flutter widgets, Supabase, Riverpod |
| `data` | `domain`, `core` (supabase, errors, domain) | widgets, controllers |
| `presentation` | `domain`, its controllers, `core/ui`, `core/theme`, other features' public widgets and providers | `supabase_flutter`, another feature's `data` |

- A model or widget used by two features moves to `core/domain` or `core/ui`. Feature-to-feature
  imports are allowed only for public widgets and providers, for example the customer view
  embedding `labeling`'s `ClassificationPanel`, and never in a cycle.
- Files and folders are `snake_case`, types `PascalCase`, members `camelCase`. Identifiers are
  English. One public widget per file, with that file's private widgets (`_Row`) below it.

## Data flow

```text
Supabase (RLS, views, RPCs) → Repository (data) → @riverpod provider / Notifier → Widget
                                                  ↑ RealtimeService invalidates
```

1. **Only repositories talk to Supabase.** A repository is a plain class that receives the
   `SupabaseClient` and is exposed as `@Riverpod(keepAlive: true) XRepository xRepository(Ref ref)`.
   Widgets and controllers never build queries.
2. **Read from views, write through the narrowest path** (names in DATABASE.md):
   - Lists read `v_transactions_list` and the other views. Do not stitch joins on the client.
   - One label is an upsert on `labels` + `label_fraud_types` through an RPC (`save_label`).
   - Bulk labels go through `label_transactions`, alerts through `resolve_alert`, search
     through `global_search`.
   - The client never writes `audit_log`, `notifications.created_at`, `is_labeled` or alert
     status directly. Triggers do that.
3. **The database is the authority.** RLS decides access. CHECKs, triggers and RPCs decide
   validity and the alert workflow. The client repeats the label rules in
   `labeling/domain/label_validator.dart` only for instant field errors, and must still handle
   a server rejection.
4. **Repositories return domain models or throw a `Failure`** (`core/errors`):
   `network`, `unauthorized` (expired session → sign out), `forbidden` (RLS),
   `conflict` (for example `alert_already_resolved`), `validation(fieldErrors)`,
   `notFound`, `unknown`. Map `PostgrestException.code` / `AuthException` in one place
   (`failure_mapper.dart`). UI text for each failure is decided in presentation.
5. **Server-side pagination.** Queries use `.range(from, to)` with
   `count: CountOption.exact`. Filters and sort go in the query, never on a downloaded list.
   Page sizes are 25, 50 or 100. Nothing downloads a whole table, except the small catalogs.
6. **Heavy work stays off the UI thread.** Building the PDF and any transform over thousands of
   points (timeline, map) run in `Isolate.run`. Charts receive pre-aggregated data from views
   whenever possible.

## State (Riverpod)

- Use the generator for everything: `@riverpod` functions for derived and read-only data,
  `@riverpod class X extends _$X` Notifiers for state with operations. Do not write providers
  by hand.
- Providers auto-dispose by default. `keepAlive: true` only for app-wide state: the auth
  session, current analyst, catalogs, repositories, realtime service and connection status.
- Parameters are family arguments (`transactionsPage(query)`, `customerView(customerId)`).
  Query objects are `@freezed` so equality works.
- Filter, sort and page state lives in a Notifier per list (`TransactionsQuery`,
  `AlertsQuery`). The page provider watches it. Changing a filter resets the page to 1.
- Widgets read `AsyncValue` and render it through `ScreenState` (loading skeleton, error with
  retry, empty, data). Do not hand-roll `CircularProgressIndicator` / error text per screen.
- Mutations are Notifier methods returning `Future`. While saving, the controller exposes a
  saving state. On success it `ref.invalidate`s the affected providers. On failure it keeps the
  form data and exposes the `Failure`. The classification panel shows it inline with "Reintentar"
  (E-03). Other actions show a toast.
- `ref.watch` in `build`, `ref.read` in callbacks, `ref.listen` for side effects (toasts,
  navigation). Never call `ref.read` in `build` to avoid rebuilds.
- Signing out invalidates every keep-alive user provider and returns to `/login`.

## Realtime (HU-16)

- One `RealtimeService` (keep-alive) opens the channels after sign in and closes them on sign
  out:
  - `ai_alerts` insert / update: the inbox, the alert detail and the pending counters.
  - `labels` insert / update and `transactions.is_labeled`: lists, customer view and progress.
  - `notifications` insert for `analyst_id = auth.uid()`: the bell counter and the toast.
- Features never subscribe directly. They watch typed streams or "changed" signals from the
  service and invalidate their providers. Debounce bursts (about 500 ms) so a bulk label does
  not refetch 100 times.
- `connectionStatusProvider` (`connected`, `reconnecting`, `offline`) comes from the channel
  status. The top bar shows "Reconectando…" only when it is not `connected`.
- An alert resolved by someone else leaves the pending list for everyone. If the current
  analyst has it open, show an inline banner and disable "Resolver alerta".

## Navigation

Routes are English. Screens, dialogs and panels keep the Figma screen codes in their doc
comments.

| Path | Screen | Branch |
| --- | --- | --- |
| `/login` | C-01 / C-02 Login | outside the shell |
| `/transactions` | A-01 Transaction list | Transacciones |
| `/customers/:customerId?tx=<id>` | A-02 Customer view (`tx` opens the N-02 panel on that transaction) | Transacciones |
| `/customers/:customerId/report/:tab` (`summary`, `accounts`, `timeline`, `map`) | C-08…C-12 Customer report | Transacciones |
| `/alerts` | A-04 Alert inbox | Alertas IA |
| `/alerts/:alertId` | A-05 Alert detail | Alertas IA |
| `/statistics/:tab` (`fraud`, `ai`) | A-07 / A-08 | Estadísticas |

- The router's `redirect` is the only auth guard. It watches the session provider: no session
  goes to `/login`, and a session on `/login` goes to `/transactions`. Screens never navigate
  after sign in or out.
- Overlays are not routes: filter panel (N-01), bulk label (A-03), resolve alert (A-06),
  label history (N-03), confusion matrix (N-04), export PDF (C-14), search (C-05) and
  notifications (C-06). Open them with the kit's `showAppDialog` / `showSidePanel`. Selection
  that should survive back navigation goes in the query string (`?tx=`).
- The customer view and report keep the date range in a provider shared by their tabs (HU-09:
  the range chip applies to every tab).

## Desktop behaviour

- `window_manager` sets the minimum size to 1280×720. Layouts must work from 1280×720 up to
  full HD without horizontal scrolling of the page. Wide tables scroll inside their card.
- Keyboard:
  - Ctrl/Cmd+K opens global search, arrow keys and Enter move through results.
  - Esc closes the top overlay.
  - Enter submits a dialog's primary action.
  - Tab order follows the visual order.
  - Every interactive element shows the focus ring.
  
  Use `Shortcuts` / `Actions` at the shell level, not raw key listeners.
- Native dialogs: saving the PDF uses `file_selector`'s `getSaveLocation` with a default name
  such as `reporte-cliente-<code>-<yyyyMMdd>.pdf`.
- Hover states exist for rows, buttons and menu items. Tooltips are on every icon-only button.

## Text, numbers and dates

- UI text is Spanish and written in the widget. Do not add ARB / l10n files.
- Domain labels are written once, in `core/domain`, as enum extensions (`Verdict.fraud.label`
  → "Fraude") together with their tone and icon. Widgets use `verdict.label`, never a literal
  "Fraude".
- Money: `formatMoney(amount, currency)` in `core/formatting`, using the currency's locale
  and `decimals` from the catalog (e.g. `$ 1.900.000 COP`, `S/ 1.500 PEN`, `R$ 12.400 BRL`).
  Credits show a `+` and the success tone. Never format money with string concatenation.
- Dates: Spanish (`intl` `es`), shown in the analyst's local time zone. Short forms in tables
  (`19 mar` / `22:41`), full in panels (`03 mar 2026 22:41`).
- Account numbers are masked as `•••• 4417` everywhere except where the full number is the
  point of the screen.

## PDF export (HU-12)

- The C-14 dialog chooses the report tabs, then:
  1. Capture the charts and the map as PNGs (`RepaintBoundary.toImage`) on the UI thread.
  2. Build the document with `pdf` in `Isolate.run`.
  3. Save it through the native dialog.
- Every page has the Moneda Segura header, generation date, analyst name and the date range,
  and an Icesi "Proyecto académico" footer (see DESIGN.md). It is generated on the client and
  saved locally, never uploaded.

## Testing

- `test/` mirrors `lib/`. Required:
  - **Unit:**
    - `label_validator` (every rule in AGENTS.md)
    - score → range and severity → tone mappings
    - money and date formatting per currency
    - chart transforms (fraud over time, group by type / channel / country, confusion matrix)
    - impossible-travel detection
    - realtime debounce
  - **Widget:**
    - classification panel (required fields, justification rules, error with retry)
    - `ScreenState` variants
    - one list screen with a fake repository
- Repositories are replaced with fakes via `ProviderScope(overrides: [...])`. Tests never hit
  the network. Database behaviour is tested in `supabase/tests` (DATABASE.md).
- When a view or RPC changes shape, update the model's `fromJson` and its test in the same
  change.

## Code style

- `dart format`. `flutter analyze` is clean, infos included. Generated files are up to date.
- `const` constructors wherever possible. Named parameters for anything with more than two
  arguments. No `dynamic` outside JSON parsing. No `print`: use `debugPrint` or a logger in
  `core`.
- Keep files under about 300 lines. Split widgets before they grow past one screen.
- Put a short doc comment on public classes and on anything non-obvious. Reference the story
  or screen code (`/// N-02 · Classification side panel (HU-04).`). Do not restate the code.
- No secrets in the repo: Supabase keys come from `--dart-define`. Only the anon key ever
  reaches the app, and never the service-role key.
