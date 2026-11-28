---
name: explain-code
description: Deep, diagram-rich explanation of any part of Moneda Segura — a file, a folder, a feature (alerts, labeling, customer…), a core module (core/ui, core/realtime…), a user story (HU-08), a provider, widget, repository, or a Supabase object (RPC, view, table, trigger). Walks every layer that builds it (database → repository → domain → Riverpod state → widgets → routing → tests), uses the ownership report to say who built each part, briefly explains the related pieces, and always ends by asking which related piece to explain next. Use when the user asks to explain, walk through, document, onboard onto, or understand how something in this repo works ("explain the alerts feature", "how does resolve_alert work", "walk me through customer_view_controller.dart", "what does HU-04 touch").
argument-hint: <path | feature | HU-xx | symbol | db object>
---

# Explain code

Produce a deep explanation of one piece of the Moneda Segura codebase: every layer that builds it,
with diagrams, file:line evidence, who owns each part, and a short note on each related piece.
Then always ask which related piece to explain next.

The reader is a teammate who knows Flutter but not this part of the code. They should finish able
to change it safely: what each file does, how data and state flow end to end, which rules the
database enforces, where the tests are, and whom to ask.

## Workflow

### 1. Pin down the target

Turn the request (`$ARGUMENTS` or the user's words) into a target kind and a set of paths:

| Request | Target kind | Paths to cover |
| --- | --- | --- |
| `lib/features/<x>` or a feature name ("alerts") | feature | `lib/features/<x>/`, `test/features/<x>/`, the DB objects it reads and writes |
| `HU-xx` | story | the feature folder of the story map in `AGENTS.md`, narrowed to that story's screens and flows |
| a `.dart` file | file | that file, its test, and its direct neighbours (importers and imports) |
| `lib/core/<x>` | core module | the module, its tests, and a sample of the features that use it |
| a provider, class or function name | symbol | the declaring file (find it with Grep) plus its consumers |
| an RPC, view, table, trigger, policy | database object | the latest migration that defines it, `supabase/tests/`, and the Dart repository that calls it |

If the request matches several targets ("labels" could be the table, the feature or the
panel), ask the user which one with AskUserQuestion before reading code. Otherwise go ahead.

### 2. Get the map from the ownership report

Run the ownership script on the target's paths (and their tests) with a JSON output:

```bash
dart run tool/ownership_report.dart <paths...> --out build/explain/<slug>.json
```

`<slug>` is the target in kebab-case (`alerts-feature`, `resolve-alert-rpc`). Read the JSON. For
every file it gives `role` (Repository, Controller, Widget, Migration…), `summary` (from the doc
comment or header), `declares`, `lines`, `commits`, `owner`, `shares` and `lastChange`. Folders
carry the same totals. Use it to:

- list the files of the target, grouped by layer, before reading any of them;
- pick reading order and depth (large files and many-commit files deserve more attention);
- fill the "Who built it" section (owner per layer and per file, shared files, last change).

Treat `summary` as a lead, not a fact: confirm it against the code. A `summaryFromCommit: true`
entry means the file has no doc comment, so the code is the only source.

If the script fails (no Dart SDK, not a git checkout), say so in one line and continue without
ownership data. Do not invent owners.

### 3. Read every layer

Read all the target's files, not samples, and trace outward one hop. Follow
[references/tracing.md](references/tracing.md) for how this codebase connects: imports, providers,
repositories → Supabase views/RPCs → migrations, routes, realtime, fakes, and tests.

Read the project guides that govern what you are explaining. Cite them where the code follows (or
deviates from) them:

- `AGENTS.md`: scope, glossary, label rules, story map, non-negotiable rules.
- `.agents/ARCHITECTURAL_SPINE.md`: layers, data flow, Riverpod conventions, routing, realtime.
- `.agents/DATABASE.md`: for anything that touches `supabase/`.
- `.agents/DESIGN.md`: for widgets and screens (tokens, kit components, states).
- `docs/historias-de-usuario.md`: the acceptance criteria of the stories involved.

Take notes as you read: every public type and member, every provider (kind, autoDispose,
family argument, what it watches), every query (view or RPC, filters, sort, range), every
`Failure` path, and every user action and the code it triggers.

### 4. Write the explanation

Use the structure in [references/template.md](references/template.md). Scale it to the target:
a single file gets every public member explained, and a feature gets every file in the map plus
deep dives on its main flows. Do not skip layers the target has.

Diagrams are required. Follow [references/diagrams.md](references/diagrams.md): at least the
layer map and one sequence diagram for every main flow, plus state, class or ER diagrams when the
target has a lifecycle, a model family or tables.

Rules for the text:

- **Evidence for every claim.** Link `path:line` for each type, provider, query, rule and branch
  you describe. Do not describe behaviour you did not read in the code.
- **Explain why, not only what.** Tie decisions to the project rules ("the database decides",
  "never load everything", `ScreenState`, tokens only…) and to the story's acceptance criteria.
- **Use the project's vocabulary.** Code identifiers in English, UI strings in Spanish as they
  appear, glossary terms from `AGENTS.md` (verdict, label, alert status…).
- **Name the gaps.** Untested branches, TODOs, places where the fake repository and the real
  one differ, and deviations from the architecture spine. State them as findings with evidence,
  not as speculation.
- **Write in the user's language.** English unless the user wrote in Spanish.

Write the full explanation to `docs/explanations/<slug>.md`, creating the folder if needed. That
file is the deliverable. Mermaid renders there on GitHub and in a Markdown preview with Mermaid
support. Inside it, link code relative to the file: `../../lib/...`. If the user asked for the
answer in the chat, or the target is one small file, answer inline instead and skip the file.

### 5. Hand it over and always ask about the related pieces

In the chat, give:

1. the path of the explanation file;
2. a short overview, 5 to 10 lines: what the piece is, its layers, its main flow, and the one or
   two most important findings;
3. a question asking which related piece to explain next. This step is mandatory, even when the
   user asked for a single file.

Ask with AskUserQuestion, `multiSelect: true`. Offer the 2 to 4 most useful related pieces from
the "Related pieces" section, each with a one-line reason ("`core/realtime`: why the inbox
refreshes itself when another analyst resolves an alert"). The user can always pick "Other". If
AskUserQuestion is not available, ask the same question as a numbered list.

When the user picks pieces, run this workflow again for each one. Write each to its own file,
and add a link between the two explanations in both files.

## Quality bar

Before handing over, check:

- [ ] Every file in the target appears in the file map with its layer, role, summary and owner.
- [ ] Each layer the target has is explained: database, data, domain, state, presentation,
      navigation, tests.
- [ ] Diagrams match the code: every node is a real file, provider, view or RPC, with no invented
      boxes.
- [ ] Every main user flow is traced end to end, from click to database and back to the
      re-render, with links.
- [ ] Loading, empty, error and success states are described for each screen involved.
- [ ] Rules enforced by the database and their client-side mirrors are listed together.
- [ ] The related pieces each get 1 to 3 sentences and a link, not a deep dive.
- [ ] The answer ends with the question about which related piece to explain next.
