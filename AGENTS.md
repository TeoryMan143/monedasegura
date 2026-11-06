# Moneda Segura

Moneda Segura is a **Flutter desktop app** (Windows, macOS, Linux) where fraud analysts of a
fictional Latin American bank review banking transactions and **label** them (fraud or not,
type, confidence, severity, justification). The labels form the dataset used to train a fraud
detection model. Analysts also verify alerts raised by a **simulated AI**, read a customer
report (summary, accounts, timeline, map) and export it to PDF, and look at statistics.

It is an academic project graded on the **frontend**: app architecture, state management, dense
but uncluttered interfaces, data visualisation, UX and code quality. The backend is Supabase
(Auth, Postgres, Realtime, RLS) filled by a seed script. The bank data and the AI are simulated.

Read this file first, then the one for the task at hand:

| File | Read it when you… |
| --- | --- |
| [`.agents/ARCHITECTURAL_SPINE.md`](.agents/ARCHITECTURAL_SPINE.md) | write any Dart code: stack, folders, layers, state, routing, Supabase access, errors, tests, style |
| [`.agents/DESIGN.md`](.agents/DESIGN.md) | build or change anything visible: tokens, typography, layout, components, status colours, charts |
| [`.agents/DATABASE.md`](.agents/DATABASE.md) | touch `supabase/`: migrations, RLS, RPCs, views, realtime, seed |

## Sources of truth

| Source | What it decides |
| --- | --- |
| [`docs/historias-de-usuario.md`](docs/historias-de-usuario.md) | Scope, behaviour, acceptance criteria (Spanish) |
| [`docs/mer.puml`](docs/mer.puml) (rendered: `docs/mer.svg`) | Database schema and the business rules the database enforces |
| Figma [Moneda Segura — Prototipo - Reducido](https://www.figma.com/design/rBo6bYtQNXwehQlsejsEaU/Moneda-Segura-%E2%80%94-Prototipo---Reducido?node-id=2-5) | Screens, design tokens, components |
| [`docs/Manual-de-marca-2026-2.pdf`](docs/Manual-de-marca-2026-2.pdf) | Universidad Icesi brand manual the visual identity is based on |

When they disagree, the order is **user stories > ERM > Figma > brand manual**. The Figma file
was drawn for a larger version of the project. Ignore anything in it about **review periods,
an admin role, user management, the transfer graph, auto-save, data masking, or a "Movimientos"
report tab**. None of these exist in this version.

## Scope

- **One role: analyst.** Every signed-in user is an analyst. All analysts share the same alert
  inbox and can label any transaction.
- **Navigation:** a side menu with three destinations, Transacciones · Alertas IA ·
  Estadísticas. A top bar holds global search (Ctrl/Cmd+K), the notification bell and the user
  menu. A connection indicator appears only when the connection is failing.
- **Out of scope:** admin role, user management, review periods, editing the fraud taxonomy,
  transfer graph, stand-alone account or movements reports, a global audit page, auto-save,
  home and productivity dashboards, data masking, dataset export, per-currency committed amounts
  and precision by score range in statistics.
- **Platforms:** desktop only. The `android/`, `ios/` and `web/` folders come from
  `flutter create`. Leave them alone, but never build for them or add code for them.

## Glossary

The code, the database and these rules use English. The UI is Spanish.

| Concept | UI (Spanish) | Code / ERM |
| --- | --- | --- |
| Label: the review result of one transaction | Etiqueta / clasificación | `labels` (one current label per transaction) |
| Verdict | Fraude · No fraude · Incierto | `verdict`: `fraud`, `not_fraud`, `uncertain` |
| Labeling status of a transaction | Sin etiquetar · Etiquetada | `transactions.is_labeled` |
| Confidence (1–4) | Baja · Media · Alta · Muy alta | `confidence_levels.level` 1..4 |
| Severity | Baja · Media · Alta · Crítica | `severity`: `low`, `medium`, `high`, `critical` |
| Fraud type (fixed taxonomy) | Tipo de fraude | `fraud_types`, read only |
| AI alert | Alerta de IA | `ai_alerts` (score 0–100, suggested type, reasons) |
| Alert status | Pendiente · Confirmada · Rechazada · Reclasificada | `alert_status`: `pending`, `confirmed`, `rejected`, `reclassified` |
| Resolve an alert | Resolver alerta: Confirmar · Rechazar · Reclasificar | RPC `resolve_alert` |
| Audit trail | Historial / auditoría | `audit_log` (insert only) |

Fraud taxonomy codes: `ATO` account takeover · `PHI` phishing / social engineering ·
`CLO` cloned card · `MUL` money mule · `LAV` laundering / structuring · `SIN` synthetic
identity · `SIM` SIM swap · `CNR` unrecognised purchase.

**Label rules** (the database enforces them, the form mirrors them):

- `fraud` needs at least one fraud type and a severity.
- `not_fraud` has no fraud types and no severity, so hide those fields.
- Confidence `1` (Baja) or verdict `uncertain` needs a justification.
- Last write wins. `labels.version` counts the edits, and `audit_log` keeps every change.

## Story map

| Story | Feature folder | Figma frames (node id) |
| --- | --- | --- |
| HU-01 Sign in / out (M) | `auth` | C-01 Login `14:3`, C-02 invalid credentials `2013:6046`, C-15 user menu `98:7172` |
| HU-02 Transaction list (M) | `transactions` | A-01 `15:1191`, N-01 filter panel `2009:5907`, E-01 loading `45:12387`, E-02 empty `45:12736` |
| HU-03 Customer view (M) | `customer` | A-02 `19:1566` |
| HU-04 Label one transaction (M) | `labeling` | N-02 side panel `2003:5180`, E-03 save error `2009:8316` |
| HU-05 Label many transactions (S) | `labeling` | A-03 `22:1927` |
| HU-06 Alert inbox (M) | `alerts` | A-04 `15:1660`, N-01 |
| HU-07 Alert detail (M) | `alerts` | A-05 `25:3055` |
| HU-08 Resolve an alert (M) | `alerts` | A-06 `27:3295` |
| HU-09 Customer report: Resumen, Cuentas (M) | `customer` | C-08 `41:10433` (Cuentas has no frame: build it from the kit) |
| HU-10 Customer timeline (S) | `customer` | C-11 `42:11405` |
| HU-11 Transaction map (S) | `customer` | C-12 `43:11375` |
| HU-12 Export report to PDF (M) | `pdf_export` | C-14 `44:11788` |
| HU-13 Statistics (M) | `statistics` | A-07 `37:8901`, A-08 `37:9317`, N-04 confusion matrix `2009:5573` |
| HU-14 Global search (S) | `search` | C-05 `40:9578` |
| HU-15 Audit and label history (M) | `audit` | N-03 `2009:6567` |
| HU-16 Realtime and notifications (S) | `notifications`, `core/realtime` | C-04 shell `14:610`, C-06 bell panel `40:9772` |

Design system in Figma: Fundamentos `3:2`, Componentes `4:3`.

## Non-negotiable rules

1. **Layers per feature:** `data` → `domain` → `presentation`. Widgets never import
   `supabase_flutter`, and every query runs in a repository.
2. **One state solution:** Riverpod with hand-written providers (`Provider`, `NotifierProvider`…,
   no `@riverpod` code generation, see [`docs/migracion-riverpod-manual.md`](docs/migracion-riverpod-manual.md)). No `setState` except
   for purely local, ephemeral widget state (hover, a text controller, an animation).
3. **The database decides.** Permissions, validation and the alert workflow live in RLS,
   CHECKs and RPCs. The client mirrors validation only to give feedback before sending.
4. **Never load everything.** Lists are paginated, filtered and sorted on the server.
5. **Every screen handles loading, empty, error and success** through the shared `ScreenState`
   widget, plus the row skeleton for tables.
6. **Design tokens only.** No raw `Color(0x…)`, font sizes, paddings or radii in feature code.
   Use `core/theme` and the `core/ui` kit (see DESIGN.md).
7. **Status is never only colour:** always icon + text + colour.
8. **UI text is Spanish and written in the widget.** Domain labels (verdict, severity,
   confidence, alert status, fraud type, channel…) are defined once as enum extensions in
   `core/domain` and never retyped.
9. **Money and dates use the transaction's currency:** `intl`, with locale and decimals from
   the `currencies` catalog (CLP has 0 decimals).
10. **Keep the contract in sync:** a schema change updates `docs/mer.puml`, the migration and
    the Dart models in the same change.

## Commands

```bash
flutter pub get
dart run build_runner build -d          # after changing @freezed / @JsonSerializable code
dart run build_runner watch -d          # while developing
dart format lib test
flutter analyze                         # must be clean, infos included
flutter test
flutter run -d linux \
  --dart-define=SUPABASE_URL=http://127.0.0.1:54321 \
  --dart-define=SUPABASE_ANON_KEY=<anon key from `supabase status`>   # -d windows / macos too

supabase start                          # local stack (Docker)
supabase db reset                       # re-apply migrations + seed
```

Before handing work back: generated files are up to date, `dart format`, `flutter analyze` and
`flutter test` are clean, and the screen was checked at 1280×720.
