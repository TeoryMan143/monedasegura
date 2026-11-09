# Design system

The visual rules of Moneda Segura. The identity comes from the **Universidad Icesi brand manual
(Feb 2026)**: Azul Icesi on white, the complementary palette as support, Plus Jakarta Sans, and
line icons with angular corners. One functional red is added for risk states. Every value
below comes from the Figma file **Moneda Segura — Prototipo - Reducido**, page
*Sistema de diseño*: Fundamentos (`3:2`) and Componentes (`4:3`). When a screen needs
something not covered here, check the screen frame listed in [`AGENTS.md`](../AGENTS.md) and
build it from these tokens and the kit.

## Principles

1. **One main task per screen.** Secondary information goes in tabs, side panels, dialogs or
   tooltips, not on the page. Density is good, clutter is not.
2. **Status is never only colour.** Every verdict, severity, score or alert state combines
   colour, icon and text.
3. **Azul Icesi is the brand and the action colour.** The other palette colours are support
   only and never stand alone as a brand. Red is reserved for risk (fraud, critical, errors).
4. **Tokens, never literals.** Feature code uses `AppColors`, `AppText`, `AppSpace`,
   `AppRadius`, `AppShadows` and the `core/ui` kit. A raw hex, font size, padding or radius in a
   feature is a bug.
5. **Desktop first:** hover states, focus rings, tooltips, keyboard shortcuts, minimum
   window 1280×720.
6. **Light theme only.** There is no dark mode in this version.

## Brand

- **Moneda Segura is the product brand.** Its mark is a white line shield icon (`Escudo`) on a
  32×32 Azul Icesi square with radius `md`, followed by the "Moneda Segura" wordmark in Plus
  Jakarta Sans SemiBold, colour text primary. On Azul Icesi backgrounds (login hero) the square
  turns white with an azul icon and the wordmark white.
- **Icesi is the academic endorsement, never the product logo.** It appears as the Icesi logo +
  "Proyecto académico · Universidad Icesi" in three places only: the side menu footer, the
  login hero footer and the PDF footer.
  - Positive version on white, negative (white) version only on Azul Icesi.
  - Minimum digital height is 32 px.
  - Keep the clear space: the height of the "i" of the logo on every side.
  - Never recolour, stretch, rotate, outline or put the logo on a photo or a non-brand colour.
- Logos live in `assets/images/` as SVG exported from the Figma *Marca* section:
  `moneda_segura_mark.svg`, `icesi_positive.svg`, `icesi_negative.svg`. Do not redraw them.
- The tagline "Llega más lejos" is Icesi's and is **not** used in the app.

## Colour

### Primitives (`AppColors`)

`★` = official colour of the brand manual. The other steps are derived for surfaces, text and
states, with AA contrast.

| Ramp | 0 / 50 | 100 | 200 | 300 | 400 | 500 | 600 | 700 | 800 | 900 | 1000 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `azul` | 50 `#EEEEFD` | `#DDDDFB` | `#BBBBF6` | `#9898F2` | `#7676ED` | **`#5454E9`★** | `#4343C4` | `#33339A` | `#242470` | `#16164A` | |
| `gris` | 0 **`#FFFFFF`★**, 50 `#F6F6F8` | `#EDEEF1` | **`#CECFD4`★** | `#B3B4B9` | **`#88898C`★** | `#6B6C70` | `#4E4F53` | `#36373B` | `#232428` | `#141518` | **`#000000`★** |

| Ramp | 50 | 500 | 700 |
| --- | --- | --- | --- |
| `verde` | `#EAF7EF` | **`#4CB979`★** | `#2B7A4C` |
| `amarillo` | `#FAFCE3` | **`#E4EB60`★** | `#666A0E` |
| `naranja` | `#FDEFE9` | **`#E9683B`★** | `#A3401C` |
| `morado` | `#F2EDFE` | **`#865CF0`★** | `#5A33C2` |
| `rojo` (functional, not brand) | `#FCECEC` | `#D93B3B` | `#A12424` |

### Semantic tokens

Widgets use these, not the primitives.

| Token | Value | Use |
| --- | --- | --- |
| `textPrimary` | gris-900 `#141518` | Titles, body, table values |
| `textSecondary` | gris-600 `#4E4F53` | Supporting text, descriptions |
| `textTertiary` | gris-500 `#6B6C70` | Meta (dates, currency codes, counters), placeholders |
| `textBrand` / `textLink` | azul-600 `#4343C4` | Links, breadcrumbs, brand text on white |
| `textOnBrand` | `#FFFFFF` | Text on Azul Icesi |
| `textDisabled` | gris-300 `#B3B4B9` | Disabled text |
| `iconPrimary` | gris-700 `#36373B` | Default icon |
| `iconSecondary` | gris-500 `#6B6C70` | Field and meta icons |
| `iconBrand` | azul-500 `#5454E9` | Active nav, brand icons |
| `iconOnBrand` | `#FFFFFF` | Icons on Azul Icesi |
| `bgCanvas` | gris-50 `#F6F6F8` | App background behind content |
| `bgSurface` | `#FFFFFF` | Cards, panels, tables, side menu, top bar, dialogs |
| `bgSurfaceSubtle` | gris-100 `#EDEEF1` | Table header, segmented track, skeletons |
| `bgSelected` | azul-50 `#EEEEFD` | Selected row, active nav item, selected option |
| `bgBrand` / `bgBrandHover` | azul-500 / azul-600 | Primary button, brand blocks |
| `bgBrandSubtle` | azul-50 `#EEEEFD` | Brand chips, icon tiles of KPI cards |
| `bgDisabled` | gris-100 `#EDEEF1` | Disabled controls |
| `bgOverlay` | gris-900 at 48 % | Behind dialogs and side panels |
| `borderSubtle` | gris-100 `#EDEEF1` | Row and section dividers |
| `borderDefault` | gris-200 `#CECFD4` | Inputs, cards, secondary buttons |
| `borderStrong` | gris-300 `#B3B4B9` | Hovered inputs |
| `borderBrand` / `borderFocus` | azul-500 `#5454E9` | Focused input (2 px), selected chips |

### Status tones

Each tone has a background (50), text (700) and solid (500) colour. `StatusTone` is an enum in
`core/theme` that the kit components accept.

| Tone | Background | Text | Solid | Meaning |
| --- | --- | --- | --- | --- |
| `success` | `#EAF7EF` | `#2B7A4C` | `#4CB979` | No fraude, saved, score 0–39 |
| `warning` | `#FAFCE3` | `#666A0E` | `#E4EB60` | Incierto, severity Media, score 40–69 |
| `high` | `#FDEFE9` | `#A3401C` | `#E9683B` | Severity Alta, score 70–84, security events |
| `danger` | `#FCECEC` | `#A12424` | `#D93B3B` | Fraude, severity Crítica, errors, score 85–100 |
| `info` | `#F2EDFE` | `#5A33C2` | `#865CF0` | AI alerts and informative notices |
| `neutral` | `#EDEEF1` | `#4E4F53` | `#88898C` | Sin etiquetar, severity Baja, inactive |
| `brand` | `#EEEEFD` | `#4343C4` | `#5454E9` | Filter chips, counters, brand highlights |

**Mappings.** Define them once in `core/domain`, next to each enum's label and icon:

| Domain value | Tone | Icon |
| --- | --- | --- |
| Verdict: No fraude | success | Check |
| Verdict: Incierto | warning | Info / clock |
| Verdict: Fraude | danger | Error (circle ×) |
| Not labeled (Sin etiquetar) | neutral | Reloj (clock) |
| Severity: Baja / Media / Alta / Crítica | neutral / warning / high / danger | — (text carries it) |
| AI score 0–39 / 40–69 / 70–84 / 85–100 (Bajo / Medio / Alto / Crítico) | success / warning / high / danger | number + range text |
| AI alert marker | info | IA (sparkle) |
| Alert: Pendiente / Confirmada / Rechazada / Reclasificada | warning / danger / success / info | — |
| Connection: Conectado / Reconectando / Sin conexión | success / warning / danger | Señal |

Contrast rules:

- Text on a tone background always uses the tone's *text* colour.
- On a *solid* fill use white text, **except warning (yellow)**, which takes `#666A0E`.
- Never put white on `amarillo-500`.

Fraud types have their own colour in `fraud_types.color`. Use it only for the small square in
the taxonomy chip and for chart series grouped by type, never as a background behind text.

## Typography

**Plus Jakarta Sans**, bundled in `assets/fonts/` (Regular 400, Medium 500, SemiBold 600, Bold
700, Italic). The fallback family is Arial, as the manual allows. Styles live in `AppText` and are
mapped onto the Material `TextTheme` in `app_theme.dart`.

| Token (Figma) | Size / line height | Weight | Tracking | Use |
| --- | --- | --- | --- | --- |
| `display` (Display/32) | 32 / 40 | Bold | −0.5 | Login headline, hero numbers |
| `h1` (Título/H1) | 24 / 32 | Bold | −0.25 | Page title ("Transacciones", "Alerta AL-1042 · Juan Pérez") |
| `h2` (Título/H2) | 20 / 28 | SemiBold | 0 | Amount in the classification panel, section headers |
| `h3` (Título/H3) | 16 / 24 | SemiBold | 0 | Card, panel and dialog titles |
| `bodyL` (Cuerpo/L) | 16 / 24 | Regular | 0 | Long text, empty-state descriptions |
| `bodyM` / `bodyMMedium` / `bodyMSemiBold` (Cuerpo/M) | 14 / 20 | 400 / 500 / 600 | 0 | Default UI text / names and emphasis / buttons and field labels |
| `bodyS` / `bodySSemiBold` (Cuerpo/S) | 12 / 16 | 400 / 600 | 0 | Meta, helper text / badges, score labels |
| `label` (Etiqueta/11) | 11 / 16 | SemiBold | +0.4 | Uppercase eyebrows and section labels ("ANÁLISIS", "SCORE DE RIESGO") |
| `kpi` (Dato/KPI) | 28 / 36 | Bold | −0.25 | KPI values |
| `tableData` (Dato/Tabla) | 13 / 20 | Medium | 0 | Numbers and amounts in tables (tabular figures) |

- Left-aligned text. Centre only in empty states and the score badge.
- Italics only for words in another language.
- All caps only for `label` (eyebrows, section labels, at most three words).
- Hierarchy comes from weight and size, not from colour.
- Numbers in tables and KPIs use tabular figures (`FontFeature.tabularFigures()`) and are
  right-aligned.

## Spacing, radius, elevation

The base grid is 4/8 px. `AppSpace`:

| Token | `none` | `xxs` | `xs` | `sm` | `md` | `lg` | `xl` | `xxl` | `x3l` | `x4l` | `x5l` | `x6l` |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| px | 0 | 2 | 4 | 8 | 12 | 16 | 20 | 24 | 32 | 40 | 48 | 64 |

`AppRadius`:

| Token | px | Use |
| --- | --- | --- |
| `none` | 0 | Table cells, full-bleed areas |
| `sm` | 4 | Small chips, taxonomy chips, checkboxes |
| `md` | 8 | Buttons, inputs, menu items, nav items, segmented control |
| `lg` | 12 | Cards, panels, tables, toasts |
| `xl` | 16 | Dialogs, login card |
| `full` | 999 | Status badges, filter chips, avatars, counters |

`AppShadows`: shadows are soft and neutral. No Material elevation tints.

| Token | Value | Use |
| --- | --- | --- |
| `card` | `0 1 2` gris-900 at 6 % | Cards, panels (optional: cards on canvas can rely on the border) |
| `menu` | `0 4 12` at 10 % + `0 1 3` at 6 % | Dropdowns, menus, popovers, toasts, tooltips |
| `modal` | `0 16 40` at 16 % + `0 2 6` at 6 % | Dialogs, side panels |
| `focusRing` | spread 3, azul-500 at 35 % | Keyboard focus on every interactive element (required) |

## Layout

| Part | Spec |
| --- | --- |
| Side menu | 240 px wide (collapsible to 72 px), `bgSurface`, right border `borderSubtle`. Brand mark at top. Items 40 px tall, radius `md`, icon 24 + `bodyM`; active item: `bgSelected`, brand text and icon. Count badge (`brand` solid pill) on "Alertas IA". Section label "ANÁLISIS" in `label`. Icesi footer at the bottom. |
| Top bar | 56 px, `bgSurface`, bottom border `borderSubtle`. Global search field (about 440 px, "Buscar clientes, cuentas o transacciones…", `Ctrl K` keycap), connection indicator (only when not connected), bell with `danger` counter, avatar + name + "Analista" + chevron opening the user menu. |
| Content | `bgCanvas`, padding 32 px, gap 24 px between blocks. Usable area at 1440×900 is about 1200×788. |
| Page header | Breadcrumbs (detail pages) → `h1` title → one `bodyM` secondary description line. Primary page action at the top right. |
| Side panel | Slides in from the right over the content, about 400 px wide, `modal` shadow, content dimmed with `bgOverlay`. Header with `h3` title + id + close; scrollable body; sticky footer with the actions (N-02). |
| Dialogs | Centred on `bgOverlay`. **M 560 px** for confirmations and short forms, **L 800 px** for larger forms (A-03, A-06, C-14). Header (title + close) → body → footer with the secondary action left of the primary. |

At 1280×720 the side menu stays expanded. Wide tables scroll horizontally inside their card,
never the page.

## Component kit (`lib/core/ui`)

Build these once and use them everywhere. Names in parentheses are the Figma components.
Import the whole kit with `import '<…>/core/ui/kit.dart';`. Every component has a doc comment
with its variants; see them all running with `flutter run -d windows -t lib/main_kit.dart`
(dev-only gallery in `lib/dev/kit_gallery/`). Clickable pieces are built on `Pressable`
(hover, pressed, keyboard focus ring, Enter / Space), so new components get the desktop
behaviour for free.

| Widget | Spec |
| --- | --- |
| `AppButton` (Botón) | Variants `primary` (azul fill, white text, hover azul-600), `secondary` (white, `borderDefault`, text primary), `tertiary` (no border, brand text: low emphasis and links), `danger` (rojo fill: destructive or irreversible, e.g. "Rechazar"). Sizes **M 40 px** (forms, bars) and **S 32 px** (tables, filters). Radius `md`, `bodyMSemiBold`, optional leading 20 px icon, loading state. **One primary per view.** No ripple: hover and pressed are colour changes. |
| `AppIconButton` (Botón ícono) | 36×36, tertiary or secondary, **always with a tooltip**. |
| `AppTextField` (Campo de texto) | Label always visible above (`bodyMSemiBold`, required = red `*`), 40 px field, radius `md`, `borderDefault`. Focus: 2 px `borderFocus` + focus ring. Error: red border + message **in text** below. States: disabled, read-only. Variants: search (Buscar icon), date (Calendario icon), amount. |
| `AppDropdown` + `AppMenu` (Desplegable, Opción de menú) | Field like the text field with a chevron. Menu items 36 px with hover / selected (`bgSelected` + check) and optional right detail. Menu uses `menu` shadow, radius `md`. |
| `AppTextArea` (Área de texto) | Multi-line field with a character counter at the bottom right (`0/500`) and a helper line. |
| `AppCheckbox`, `AppRadio`, `AppSwitch` (Selección) | 20 px controls. The checkbox supports the indeterminate state for "select all". Radios only for few visible options. A switch is only for an immediate setting. |
| `AppSegmented` (Control segmentado) | Exclusive choice between 2–4 always-visible options: verdict, confidence, severity, chart group-by, timeline zoom. `bgSurfaceSubtle` track, active segment white with `card` shadow. Under confidence and severity, show the selected level's description in `bodyS`. |
| `StatusBadge` (Insignia) | Pill, tone background + tone text + 12 px icon + text. **M 22 px**, **S 18 px** tall. |
| `TaxonomyChip` (Chip taxonomía) | 24 px, radius `sm`, `borderDefault`: a colour square from `fraud_types.color` + bold code + name ("ATO · Robo de cuenta"). Removable variant with ×. |
| `AppFilterChip` (Chip de filtro; named so it does not clash with Material's `FilterChip`) | 26 px pill, `brand` tone, "Etiqueta: **Todas**" + × to remove. Shown next to the "Filtros" button, plus a "Limpiar filtros" action when more than one is active. |
| `ScoreBadge` | Number on the solid tone of its range (white text, dark text on warning), radius `sm`. Table size about 40×28. Large variant (alert detail) 80×80, radius `lg`, "de 100" under the number. |
| `ScoreMeter` (Barra de avance y score) | Four-segment 0–100 bar coloured by range + a `StatusBadge` with the range text ("Riesgo crítico (85–100)"). |
| `ProgressBar` | Labeled progress: "42/60 etiquetadas" + "70 %" always visible as text, azul fill on gris-100, 240 px. |
| `AppAvatar` | Initials on `bgBrandSubtle`, brand text. M 32, S 24. |
| `KpiCard` | `bgSurface` card, radius `lg`. Title `bodyM` secondary, icon tile 28 px `bgBrandSubtle` top right, value in `kpi`, a detail or trend line in `bodyS` (trend up: success text + Tendencia icon). |
| `AppToast` | Bottom right, 380 px, `menu` shadow, auto-dismiss after 5 s, closable, optional "Abrir" action. Types: success, error, info, AI alert (score + "Abrir"), warning. |
| `InlineBanner` (Aviso en línea) | Full width in the content, tone background + border, icon + bold first line + explanation. For persistent notices: "TX-77120 ya tiene una etiqueta…", impossible travel, alert resolved by someone else. |
| `ConnectionIndicator` | Señal icon + "Reconectando…" / "Sin conexión" in the top bar, hidden while connected. |
| `SaveStatus` | "Guardando…" / "Guardado" / "Error · Reintentar" next to the panel actions. |
| `AppTooltip` | Dark (gris-900) with white `bodyS`, max 260 px. Required on icon buttons and on confidence and severity help. |
| `AppTabs` (Pestañas) | 42 px tabs, `bodyMMedium`. Active: brand text + 2 px azul underline. Optional counter. |
| `Breadcrumbs` (Migas de pan) | `bodyS`, links in `textLink`, chevron separators, current page in primary. |
| `AppDataTable` (Tablas) | See [Tables](#tables). |
| `Pagination` | 52 px footer: "Mostrando 1–25 de 50.312 transacciones" left, "Filas por página" dropdown (25/50/100) and page controls right. |
| `AppDialog` / `showAppDialog` (Modal) | M 560 / L 800, radius `xl`, `modal` shadow. |
| `SidePanel` / `showSidePanel` | See Layout. Closes with ×, Esc, after saving, or on "Siguiente". |
| `NotificationItem` | 380 px row in the bell panel: AI icon, title with score, client, relative time, unread dot and bold title until read. |
| `ScreenState` (Estados de pantalla) | One widget for: **loading** (skeletons shaped like the content: `SkeletonRow` 48 px for tables), **empty** (icon, `h3` title, explanation, next action), **no results** (suggests "Limpiar filtros"), **error** (describes the problem, "Reintentar" button). Used by every screen. |
| `AppPanel` (Panel) | Card container: `bgSurface`, `borderDefault` 1 px, radius `lg`. Header row with `h3` title, optional subtitle and right action, divider, content padding 20. |

### Tables

- Card container (radius `lg`, border), toolbar on top: "Filtros" button + active filter chips
  + count text ("50.312 transacciones · 3.906 sin etiquetar").
- Header 40 px on `bgSurfaceSubtle`, `bodySSemiBold`, sortable columns show the Ordenar icon
  and the direction arrow. Rows 48 px minimum, divider `borderSubtle`, hover `gris-50`,
  selected `bgSelected`.
- Two-line cells: value (`bodyM` / `tableData`) and meta below (`bodyS`, tertiary). Examples:
  date / time, customer / masked account · country, type / channel, amount / currency.
- Amounts right-aligned in `tableData`. Credits get `+` and success text.
- **Rows with an AI alert:** 3 px `info` solid left border, IA (sparkle) icon before the type,
  `ScoreBadge` in the "Alerta IA" column. No alert shows "—".
- Multi-select with checkboxes (header checkbox with the indeterminate state). Selecting rows
  shows a bulk action bar ("Clasificar 3 transacciones").
- Click on a row opens it (A-01 → A-02 with the transaction selected). The checkbox does not
  trigger navigation.
- Loading: `SkeletonRow`s, never a spinner over an empty table. Pagination footer always visible.

## Icons

- **Functional line icons:** 24×24 grid, 1.5 px uniform stroke, **angular corners and straight
  ends**, no fills (brand manual *Iconografía*). Default colour `iconPrimary`, overridable with
  icon or tone tokens. Use 20 px in buttons and inputs, 16 px in badges.
- Export them as SVG from the Figma *Iconografía* grid into `assets/icons/` and expose them
  through one `AppIcons` class + `AppIcon` widget. Do not mix in Material Icons or other sets.
  `AppIcons` is an enum in `core/theme/app_icons.dart` (so `core/domain` can name icons) and
  `AppIcon` renders it. The current SVGs were drawn following these rules; when the Figma
  grid is exported, replace the files keeping the same names.
- Set used by the app: Inicio, Calendario, IA, Estadísticas, Descargar, Auditoría, Bandeja,
  Buscar, Campana, Usuario, Salir, Menú, Chevrons (4), Cerrar, Check, Más, Filtro, Ordenar,
  Reloj, Ojo, Editar, Ubicación, Línea de tiempo, Documento, Info, Advertencia, Error, Escudo,
  Dispositivo, Tarjeta, Banco, Transferencia, Refrescar, Señal, Más opciones, Lista,
  Tendencia arriba / abajo, Moneda, Panel lateral, Cargando, Comentario, Teclado, Enlace
  externo, Bloqueo. (Taxonomía, Usuarios, Grafo, Reabrir, Asignar, Subir belong to features out
  of scope.)

## Data visualisation

Use the same rules for statistics (A-07, A-08, N-04), the customer summary chart, the timeline
(C-11) and the map (C-12).

- Every chart sits in an `AppPanel` with an `h3` title and a `bodyS` subtitle stating what is
  measured ("Transacciones con veredicto Fraude por semana").
- **Single series** use azul-500 (line 2 px, points on hover). **Categorical series** use the
  fraud type colour or tone mappings above. Never more than 8 colours.
- Grid lines gris-100, axes and tick labels `bodyS` tertiary, no chart borders, no 3D, no
  gradients, no pie charts.
- Tooltip: gris-900 background, white `bodyS`, value + context ("Semana del 3 mar · 41
  fraudes · +8 % vs. semana anterior"), with a vertical crosshair on line charts.
- **Group-by** (Tipo · Canal · País) uses an `AppSegmented` above **horizontal bars**: label left,
  azul bar, value right, sorted descending.
- **Confusion matrix** (N-04): suggested type rows × final result columns (including "No
  fraude" = rejected). Cell shade on the azul ramp by count, value always printed, diagonal
  marked as correct.
- Legends use shapes and text, not only colour swatches.
- **Timeline** (C-11):
  - Two lanes, "Eventos de seguridad" (high-tone diamonds, each named with its type's icon
    and label where it fits) and "Transacciones" (circles sized by amount, coloured and
    iconed by status: Fraude danger, No fraude success, Incierto warning, unlabeled with an
    AI alert info + IA icon, Sin etiquetar neutral; the selected one gets an azul outline).
    Marks that would overlap spread up and down their lane, so a burst stays clickable.
  - Zoom with `AppSegmented` Día · Semana · Mes · Rango completo (calendar windows, the
    week from Monday) and prev / next, disabled at the ends of the range.
  - Overview strip at the bottom: azul-200 bars, the selected window azul-500.
  - Bursts are highlighted with a `danger` 50 band + text ("Ráfaga · 3 en 10 min"), unusual
    hours with a `warning` bar + text, and up to a week the customer's nights
    (00:00–05:00 on their clock) are shaded `bgSurfaceSubtle`. A line of badges sums them up
    in text above the chart, and the legend names every shape.
  - The detail of the clicked point goes in a side card (amount, date, type · channel,
    label and AI alert badges) with "Abrir en la vista de cliente".
- **Map** (C-12): OpenStreetMap tiles. Markers coloured by label or alert state with an icon,
  and lines between consecutive transactions labelled with the elapsed time. Impossible travel
  is drawn in `danger` and explained in an `InlineBanner` above the map ("Viaje imposible:
  Bogotá → Ciudad de México en 40 min (≈ 3.200 km)"). The camera fits every marker; + / − and
  "Encuadrar transacciones" sit top left. Zooming out stops when one world fills the map:
  the tiles never repeat side by side and no grey band shows above or below them.
- Every chart has its loading skeleton, empty and error state through `ScreenState`.

## Screen patterns

- **Login (C-01 / C-02):**
  - Left: Azul Icesi hero with the brand mark, an eyebrow ("MESA DE ETIQUETADO"), a `display`
    headline, an illustrative preview and three key numbers, plus the Icesi footer.
  - Right: a white card (radius `xl`) with the email and password fields and the primary
    "Iniciar sesión" button.
  - Invalid credentials show one generic `danger` banner that never reveals whether the email
    exists.
- **List pages (A-01, A-04):** header → search field + "Ordenar por" dropdown (always visible)
  → table card with "Filtros", chips, count → pagination.
- **Customer view (A-02 + N-02):**
  - Compact header: breadcrumbs, name, progress bar, pending-alerts chip and the "Ver perfil"
    button (it opens the report on "Resumen"; its tabs lead to the timeline and the map).
  - Then the table card with the account filter, date range and in / out / net totals per
    currency.
  - The classification panel opens over it. Inside the panel: amount (`h2`), meta, "Etiquetada
    por … · Ver historial", the AI alert box (`info`), then Veredicto (segmented), Tipo(s) de
    fraude (chips + "Agregar"), Nivel de confianza (segmented + description), Severidad
    (segmented + description; hidden for No fraude), Justificación (textarea + rule hint) and
    the footer with "Siguiente" (secondary) and "Guardar etiqueta" / "Actualizar etiqueta"
    (primary).
- **Detail page (A-05):** breadcrumbs, `h1` + status badge, primary action top right
  ("Resolver alerta"), warning banner if a label exists, then a 2-column grid (main column of
  panels + a narrower context card such as "Cliente" with "Ver cliente").
- **Report (C-08…C-12):** header with the name, the range chip and "Exportar PDF" (secondary)
  → `AppTabs` Resumen · Cuentas · Línea de tiempo · Mapa.
- **Statistics (A-07 / A-08):** header with the date range and country filters on the right →
  tabs Fraude · Desempeño de la IA → KPI row (3 cards) → charts in a 2:1 grid.

## PDF

- A4. The Moneda Segura mark and the report title make the header. Below them: customer name,
  generation date and time, analyst name and the date range.
- Content: the chosen tabs in order, with charts and map as images. Tables in `tableData`
  size with the same status texts (no colour-only meaning). Plus Jakarta Sans is embedded.
- Footer: Icesi positive logo + "Proyecto académico · Universidad Icesi" and the page numbers.

## Accessibility

- AA contrast for all text (the semantic tokens already meet it). No white text on yellow.
- Never rely on colour alone (icon + text in every status, shapes in legends).
- Every interactive element is reachable by keyboard and shows the focus ring. Esc closes
  overlays. Tab order follows reading order.
- Icon-only buttons have tooltips and a `Semantics` label.
- Click targets are at least 32 px tall (table and filter sizes), 40 px in forms.
