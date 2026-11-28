# Explanation template

Use these sections in this order. Drop a section only when the target has no such layer (a pure
widget has no database section), and say in one line that it is not applicable. Headings can be
translated when writing in Spanish.

```markdown
# <Target name>: how it works

> <One paragraph: what this piece is for, which user stories (HU-xx) and Figma frames it serves,
> and where it sits in the app.>

**Paths:** `<paths covered>` · **Owner(s):** <from the ownership JSON> · **Last change:** <date, author>
· **Generated:** <date> at `<git short sha>`

## At a glance
- 4 to 8 bullets: the main responsibilities, the main flow, and the single most important design
  decision.

## Layer map
<Mermaid layer map, see diagrams.md, and one paragraph reading it top to bottom.>

## File map
| Layer | File | Role | What it does | Owner | Lines |
| --- | --- | --- | --- | --- | --- |
<one row per file in the target, from the ownership JSON, with the description confirmed or
corrected against the code. Group the rows by layer: database, data, domain, state,
presentation, tests.>

## Layer by layer

### Database
Tables, views, RPCs, triggers and RLS involved. For each one: the latest migration that defines it
(link), its columns or parameters, what it checks, the error keys it raises, which triggers fire,
and which pgTAP tests cover it. Include an ER diagram when 2 or more tables are involved.

### Data: repositories
Each repository method: its signature, the exact query (view or RPC, columns, filters, sort,
range, count), the mapping JSON → domain, and the failures it throws. Say whether a fake
repository or `LocalWritesStore` replaces it, and how the two differ.

### Domain: models and rules
Each model: its fields with their meaning, its invariants, freezed or JSON details, and derived
getters. Each pure rule (validators, transforms, aggregations): its inputs, outputs and edge
cases. Include a class diagram when the models are related.

### State: providers and controllers
Each provider: kind, lifetime (autoDispose or keep-alive), family argument, what it watches, who
watches it, and what invalidates it. Each Notifier method: what it changes, its saving and error
states, and its invalidations on success. Include the provider graph and a state diagram when
there is a lifecycle.

### Presentation: screens and widgets
The screen composition (widget tree diagram for big screens), each widget's job, how
loading / empty / error / success render through `ScreenState`, the interactions (buttons,
shortcuts, hover, focus) and the Spanish UI text, the kit components and tokens used, and
accessibility (icon + text + colour, tooltips, focus order).

### Navigation and integration
The route and its parameters, the shell branch, the overlays opened, deep links (`?tx=`), and
realtime refreshes.

## Main flows
One subsection per flow ("Load the inbox", "Change a filter", "Resolve an alert"…):
a sequence diagram, then a numbered walkthrough where every step links `path:line`, from the
user's action down to the database and back to the re-render, including the failure branch.

## Rules and where they live
| Rule | Enforced by (database) | Mirrored by (client) | Test |
| --- | --- | --- | --- |

## Tests
What each test file proves (one line each), how the tests set up providers and fakes, and the
untested behaviour that matters.

## Who built it
The owner per layer and per folder, from the ownership JSON. Shared files (owner under 50 %),
the most recent changes, and who to ask about which part.

## Findings
Gaps, risks and deviations from AGENTS.md or the architecture spine, each with a link as
evidence: fake versus real differences, missing states, TODOs, untested branches, anything
surprising.

## Related pieces
For each related piece reached while tracing: **name** (link), 1 to 3 sentences on what it is and
how it connects to the target. Not a deep dive.

## Glossary
Only the project terms the reader needs for this piece (verdict, label, alert status…), as in
AGENTS.md.
```

End the chat reply, not the file, with the question about which related piece to explain next.
