# Diagrams

Use Mermaid in fenced ```mermaid blocks. They render on GitHub and in Markdown previews with
Mermaid support, and they stay readable as text. Every node is something real that you read: a
file, provider, class, view, RPC or table. No invented boxes.

## Which diagrams to draw

| Diagram | Draw it when | Required? |
| --- | --- | --- |
| Layer map (`flowchart`) | always | yes |
| Sequence (`sequenceDiagram`) | for each main user flow: load, filter, save, resolve… | yes, one per main flow |
| Provider graph (`flowchart`) | the target has 3 or more providers | when applicable |
| State (`stateDiagram-v2`) | there is a lifecycle: alert status, save status, form steps, connection status | when applicable |
| Class (`classDiagram`) | the domain has 3 or more related models or a sealed hierarchy | when applicable |
| ER (`erDiagram`) | the target reads or writes 2 or more tables | when applicable |
| Widget tree (`flowchart TD`) | a screen or a large widget | when applicable |

Keep each diagram under about 25 nodes. If it grows, split it by layer or by flow. Put a sentence
before each diagram saying what to look at.

The examples below show the shape of each diagram. Their names come from the alerts feature
but are simplified. Do not copy them: rebuild every node from the code you read. In particular,
check whether a write goes through an RPC or through `LocalWritesStore`.

## Layer map

One subgraph per layer, top to bottom. Label the edges with the call or the data that flows.

```mermaid
flowchart TB
  subgraph UI["Presentation"]
    S["AlertsScreen<br/>alerts_screen.dart"]
    W["AlertsFilterBar"]
  end
  subgraph ST["State (Riverpod)"]
    Q["alertsQueryProvider<br/>Notifier · autoDispose"]
    P["alertsPageProvider<br/>FutureProvider.family"]
  end
  subgraph DA["Data"]
    R["AlertsRepository"]
  end
  subgraph DB["Supabase"]
    T[("ai_alerts")]
  end
  S --> W
  W -- "setFilter()" --> Q
  S -- "watch" --> P
  P -- "watch" --> Q
  P -- "fetchPage(query)" --> R
  R -- "select · range · count" --> T
```

## Sequence for a flow

Start at the user, end at the re-render. Show the database's work (RPC, triggers), the failure
branch with `alt`, and invalidation or realtime refreshes.

```mermaid
sequenceDiagram
  actor A as Analyst
  participant D as ResolveAlertDialog
  participant C as ResolveAlertController
  participant R as AlertsRepository
  participant DB as Supabase
  A->>D: Confirm
  D->>C: submit()
  C->>R: resolveAlert(input)
  R->>DB: rpc resolve_alert(...)
  alt ok
    DB-->>R: labels written, audit_log + notifications via triggers
    R-->>C: void
    C->>C: ref.invalidate(alertDetailProvider)
  else alert_already_resolved
    DB-->>R: exception
    R-->>C: Failure.conflict
    C-->>D: inline error
  end
```

## Provider graph

Edges point from the watcher to the provider it watches. Mark the kind and the lifetime.

```mermaid
flowchart LR
  page["alertsPageProvider<br/>FutureProvider.autoDispose.family"] --> query["alertsQueryProvider<br/>NotifierProvider.autoDispose"]
  page --> repo["alertsRepositoryProvider<br/>Provider · keep-alive"]
  repo --> client["supabaseClientProvider"]
```

## State

```mermaid
stateDiagram-v2
  [*] --> pending
  pending --> confirmed: Confirmar
  pending --> rejected: Rechazar
  pending --> reclassified: Reclasificar
  confirmed --> [*]
  rejected --> [*]
  reclassified --> [*]
```

## Class and ER

- `classDiagram`: freezed models with their main fields, sealed hierarchies with `<|--`, and
  composition with `*--`. Include enums from `core/domain` when they matter.
- `erDiagram`: only the tables the target touches, with PK and FK columns and the cardinality
  from `docs/mer.puml`.

## Syntax pitfalls

- Quote labels that contain spaces, parentheses, slashes, dots or `:`: `A["fetchPage(query)"]`.
- Use `<br/>` for line breaks inside labels, never `\n`.
- Never use `end` as a node id, and avoid ids that start with `o` or `x` right after `--`.
- Edge labels with special characters go in quotes: `-- "select · range" -->`.
- In `sequenceDiagram`, avoid `;` and `#` in messages.
- `stateDiagram-v2` state names cannot contain spaces. Use ids with labels if needed.
