# Tracing a piece through Moneda Segura

How the layers connect in this repository, and how to follow each link with Grep and Read.
Trace one hop out from the target. The pieces you reach are the **related pieces**: explain them
in 1 to 3 sentences and offer to explain them in depth.

## Layer order

```text
Supabase (tables, views, RPCs, triggers, RLS)   supabase/migrations/*.sql
  → Repository (data)                            lib/features/<f>/data/*_repository.dart
  → Domain models and rules (domain)             lib/features/<f>/domain/*.dart, lib/core/domain/
  → Providers / Notifiers (state)                lib/features/<f>/presentation/controllers/
  → Screen and widgets (presentation)            lib/features/<f>/presentation/{*_screen.dart,widgets/}
  → Route / shell (navigation)                   lib/app/router.dart, lib/app/shell/
  ↺ Realtime invalidation                        lib/core/realtime/
  ✓ Tests                                        test/ mirrors lib/, supabase/tests/ for the database
```

Explain bottom-up (database → widgets), then trace each user flow top-down (click → database →
re-render).

## Links to follow

### Imports: who depends on whom

- What the target uses: read its `import` lines. Relative imports (`../../domain/x.dart`) stay in
  the feature. `core/...` imports are shared infrastructure. `features/<other>/...` imports are
  cross-feature links, which the spine only allows for public widgets and providers.
- Who uses the target: Grep the file name over `lib/` and `test/`, for example
  `alerts_repository.dart`. Both relative and `package:monedasegura/...` imports end with the file
  name.

### Providers: the state graph

- Providers are hand-written top-level `final xxxProvider = …Provider…<T>(…, name: 'xxxProvider')`.
  For each one, record:
  - the kind (`Provider`, `FutureProvider`, `NotifierProvider`, `AsyncNotifierProvider`,
    `StreamProvider`);
  - `.autoDispose` and `.family` (and the family argument type);
  - what it `ref.watch`es: these are its edges in the state diagram;
  - what invalidates it (`ref.invalidate(xxxProvider)`), and who does that.
- Consumers: Grep `xxxProvider` over `lib/`. `ref.watch` in `build` re-renders, `ref.read` in
  callbacks triggers actions, and `ref.listen` drives side effects such as toasts or navigation.
- Query objects (`TransactionsQuery`, `AlertsQuery`…) are freezed family arguments. Changing a
  filter resets the page to 1. Find the Notifier that owns the query.

### Repository → database

- A repository receives `SupabaseClient` and is exposed through a `xxxRepositoryProvider`.
- Find its calls: Grep `.from('` and `rpc(` in `lib/features/<f>/data/`. Note each table or view,
  the selected columns, filters (`.eq`, `.in_`, `.gte`, `.ilike`…), `.order`, `.range` and
  `count`.
- Find the definition in `supabase/migrations/`: Grep
  `create (or replace )?(view|function) public.<name>` or `create table public.<name>`. Several
  migrations can redefine the same object, so **the file with the latest timestamp wins**. Read
  that one, and mention the earlier ones only for history.
- For RPCs, read the parameters, the checks, the error keys it raises (`raise exception
  '<key>'`), the rows it writes, and the triggers those writes fire (`*_triggers.sql`,
  `audit_log`, `is_labeled`, notifications).
- For RLS: Grep `create policy` with the table name. For grants: `*_rls_and_grants.sql`.
- Errors: repositories map exceptions with `lib/core/errors/failure_mapper.dart` into `Failure`
  variants. Show which variants the target can produce and how presentation words each one.
- Database tests: `supabase/tests/*_test.sql` (pgTAP). Grep the RPC or table name there.
- Schema reference: `docs/mer.puml` (ERD source) and `.agents/DATABASE.md`.

### Real, fake and prototype paths

The app can run without a backend, and some writes are still prototypes. Always check which path
the target really uses, and say so explicitly:

- `Env.useFakeData` (`--dart-define=USE_FAKE_DATA=true`) swaps a repository provider for its
  `fake_*_repository.dart`. Grep `Env.useFakeData` to see which providers switch.
- `LocalWritesStore` (`lib/core/local_writes/`) keeps prototype writes in memory until the RPCs
  exist. Grep `localWritesStoreProvider` to see which features write through it instead of
  Supabase.
- `lib/core/realtime/realtime_service.dart`: check whether the provider returns the real service
  or `FakeRealtimeService` before describing realtime behaviour.
- `lib/core/demo/` and `lib/app/demo_fail_once.dart`: scripted demo failures, for example the
  save error E-03.

A difference between the fake and the real path (filters applied in memory, missing error
cases…) is a finding: report it.

### Navigation

- Routes are in `lib/app/router.dart`. Find the `GoRoute` whose builder creates the target screen.
  Note its path, its parameters (`:customerId`, `?tx=`), its shell branch, and the `redirect`
  auth guard.
- Overlays are not routes. Grep `showAppDialog` / `showSidePanel` to find what opens a dialog or
  panel.
- Shell: side nav, top bar, Ctrl/Cmd+K and the bell are in `lib/app/shell/`.

### Presentation

- Screens render `AsyncValue` through `ScreenState` (`lib/core/ui/screen_state.dart`). For each
  screen, list the loading skeleton, the empty state, the error with retry, and the data
  rendering.
- Kit components come from `lib/core/ui/kit.dart`, tokens from `lib/core/theme/`. Domain labels,
  tones and icons come from `lib/core/domain/` enum extensions. Point out any raw colour, size or
  retyped label as a deviation.
- Figma frame codes (A-04, N-02, C-14…) appear in doc comments. Map them through the story map in
  `AGENTS.md`.

### Stories and rules

- `docs/historias-de-usuario.md`: find the `HU-xx` sections and their acceptance criteria. For
  each criterion, say where the code satisfies it, or that it does not.
- Label rules (fraud needs types and severity, not_fraud has neither, low confidence or uncertain
  needs a justification): the database enforces them, and
  `lib/features/labeling/domain/label_validator.dart` mirrors them.

### Tests

- The mirror path: `lib/a/b/c.dart` → `test/a/b/c_test.dart`. Also Grep the class or provider
  name over `test/`, because widget tests often cover several files.
- Helpers: `test/helpers/` (`kit_harness.dart`, `shell_overrides.dart`…).
- For each test file, summarise what it proves. List the important behaviour no test covers.

### History and owners

- The ownership JSON gives the owner, shares and last change per file and folder.
- For "why is it like this" questions, `git log --oneline -- <path>` and `git log -L` on a
  function give the commits that introduced the code. Quote commit subjects, not guesses.
