# Moneda Segura — Descripción del proyecto e historias de usuario

> Aplicación de escritorio para el etiquetado (labeling) de datos bancarios orientado a la detección de fraude.
> Proyecto académico enfocado en **frontend**: los datos bancarios y el modelo de IA son **simulados**.
> Versión simplificada: 16 historias (80 puntos), alineadas con el Figma «Moneda Segura — Prototipo - Reducido».
> [Figma](https://www.figma.com/design/rBo6bYtQNXwehQlsejsEaU/Moneda-Segura-%E2%80%94-Prototipo---Reducido?node-id=2-5&t=aqcVQz7RlDgSaMRf-1)

---

## 1. Descripción general

**Moneda Segura** es una plataforma interna de un banco latinoamericano ficticio que está entrenando un modelo de inteligencia artificial para detectar fraude. Para entrenarlo necesita primero un conjunto de datos **revisados y clasificados manualmente** por analistas humanos.

El alcance del proyecto se centra en el trabajo del **analista**: **clasificar transacciones** y **visualizar estadísticas**. La aplicación permite:

- Explorar las transacciones del banco (en una lista global o agrupadas por cliente) y **clasificarlas** como fraude o no, indicando tipo, nivel de confianza, severidad y justificación.
- Verificar alertas generadas por la IA (simuladas): **confirmarlas, rechazarlas o reclasificarlas**.
- Consultar el **reporte del cliente** (resumen, cuentas, línea de tiempo y mapa) y exportarlo a **PDF**.
- Ver **estadísticas** sobre el fraude etiquetado y el desempeño de la IA.

Las etiquetas quedan almacenadas en la base de datos y constituyen el dataset con el que se entrenará el modelo.

### 1.1 Objetivo académico

El proyecto busca evaluar el **frontend**: arquitectura de la app Flutter, gestión de estado, diseño de interfaces densas en datos **sin saturarlas** (información secundaria en pestañas, paneles laterales y ventanas emergentes), visualizaciones (gráficas, mapas y líneas de tiempo), experiencia de usuario y calidad del código. El backend se limita a Supabase (Auth, Postgres, Realtime, Storage) con datos generados por script.

### 1.2 Stack tecnológico

| Capa                 | Tecnología                                                             |
| -------------------- | ---------------------------------------------------------------------- |
| Aplicación           | Flutter Desktop (Windows / macOS / Linux)                              |
| Backend as a Service | Supabase: Auth, PostgreSQL, Realtime, Row Level Security, Storage      |
| Datos simulados      | Script de seed (p. ej. Python + Faker o SQL)                           |
| IA                   | Simulada: alertas pregeneradas en la base de datos con score y razones |
| Reportes PDF         | Paquete `pdf` / `printing` de Flutter                                  |

### 1.3 Contexto de los datos

Banco ficticio con operación en **Latinoamérica**: clientes y transacciones en varios países (p. ej. Colombia, México, Perú, Chile, Argentina y Brasil), con sus monedas (COP, MXN, PEN, CLP, ARS, BRL), ciudades y canales locales (PSE, SPEI, Yape, Pix, transferencias interbancarias, cajero, POS, app móvil, banca web).

Volumen objetivo del seed: **decenas de miles de transacciones** (orientativo: ~2.000 clientes, ~3.500 cuentas, 50.000+ transacciones, ~1.500 alertas de IA), con patrones de fraude **inyectados intencionalmente** para que haya casos que descubrir.

---

## 2. Rol

| Rol          | Descripción                                                                                                                                                                                                                                    |
| ------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Analista** | Explora transacciones y clientes, clasifica transacciones, verifica las alertas de IA, consulta el reporte del cliente y ve estadísticas. Todos los analistas comparten la misma bandeja de alertas y pueden clasificar cualquier transacción. |

---

## 3. Glosario

### Etiqueta (clasificación)

Resultado de la revisión de una **transacción**. Contiene:

- **Veredicto:** `Fraude`, `No fraude` o `Incierto`.
- **Tipo(s) de fraude:** uno o más de la taxonomía (obligatorio si el veredicto es `Fraude`).
- **Nivel de confianza:** ver tabla abajo.
- **Severidad:** ver tabla abajo.
- **Justificación:** texto libre (obligatorio cuando la confianza es Baja o el veredicto es `Incierto`).

**Estado de etiqueta de una transacción:** `Sin etiquetar` o `Etiquetada`.

### Niveles de confianza

| Nivel | Nombre       | Criterio orientativo                                                                 |
| ----- | ------------ | ------------------------------------------------------------------------------------ |
| 1     | **Baja**     | Un solo indicio aislado con posible explicación legítima. Justificación obligatoria. |
| 2     | **Media**    | Dos o más indicios coinciden, sin evidencia concluyente.                             |
| 3     | **Alta**     | Patrón claro de un tipo de fraude conocido.                                          |
| 4     | **Muy alta** | Evidencia concluyente (reclamo, contracargo o patrón idéntico a un tipo conocido).   |

### Severidad

| Nivel       | Criterio orientativo                                                |
| ----------- | ------------------------------------------------------------------- |
| **Baja**    | Monto bajo, sin afectación a otros productos.                       |
| **Media**   | Monto relevante para el perfil del cliente.                         |
| **Alta**    | Pérdida significativa o afectación de varias cuentas/productos.     |
| **Crítica** | Vaciado de cuenta, red de cuentas involucradas o lavado de activos. |

### Taxonomía de fraude (fija)

La taxonomía viene cargada en la base de datos y **no se edita desde la aplicación**.

| Código | Tipo                                | Descripción breve                                          |
| ------ | ----------------------------------- | ---------------------------------------------------------- |
| ATO    | Robo de cuenta (_account takeover_) | Un tercero toma control de la cuenta del cliente.          |
| PHI    | Phishing / ingeniería social        | El cliente es engañado para autorizar operaciones.         |
| CLO    | Tarjeta clonada                     | Uso de una copia física o de los datos de la tarjeta.      |
| MUL    | Cuenta mula                         | Cuenta usada para recibir y mover dinero ilícito.          |
| LAV    | Lavado / fraccionamiento            | Montos divididos para evadir controles.                    |
| SIN    | Identidad sintética                 | Cliente creado con datos falsos o combinados.              |
| SIM    | SIM swap                            | Duplicado de SIM para interceptar códigos de verificación. |
| CNR    | Compra no reconocida                | Compra que el cliente niega haber hecho.                   |

### Alerta de IA (simulada)

Caso marcado automáticamente por el "modelo". Incluye **score de riesgo** (0–100), **tipo de fraude sugerido** y **razones** legibles (p. ej. "Monto 8× mayor al promedio de 90 días").

**Flujo:** la alerta llega a la **bandeja compartida** (en tiempo real) → cualquier analista la abre y la **resuelve** (confirmar, rechazar o reclasificar) → sale de pendientes para todos.

**Estados de una alerta:** `Pendiente` → `Confirmada` / `Rechazada` / `Reclasificada`.

---

## 4. Modelo de datos (resumen)

| Entidad             | Datos principales                                                                                                                     |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| `analistas`         | id (Supabase Auth), nombre, correo                                                                                                    |
| `clientes`          | documento, nombre, fecha de nacimiento, país, ciudad, ocupación, ingresos declarados, fecha de vinculación, segmento, nivel de riesgo |
| `cuentas`           | número, tipo (ahorros/corriente/billetera), moneda, saldo, estado, fecha de apertura, cliente                                         |
| `tarjetas`          | número enmascarado, tipo, estado, cuenta                                                                                              |
| `dispositivos`      | id, tipo, SO, primera vez visto, cliente                                                                                              |
| `eventos_seguridad` | inicios de sesión, cambios de clave, cambio de celular, IP, ubicación                                                                 |
| `transacciones`     | fecha/hora, tipo, canal, monto, moneda, cuenta origen/destino, comercio, ubicación (lat/long, ciudad), dispositivo, estado            |
| `comercios`         | nombre, categoría (MCC), país, ciudad                                                                                                 |
| `etiquetas`         | transacción, veredicto, tipos, confianza, severidad, justificación, analista, fecha                                                   |
| `taxonomia_fraude`  | código, nombre, descripción, color                                                                                                    |
| `alertas_ia`        | transacción(es), cliente, score, tipo sugerido, razones, estado, analista que la resolvió, fechas de creación y resolución            |
| `auditoria`         | analista, acción, entidad, valor anterior, valor nuevo, fecha                                                                         |

---

## 5. Navegación y pantallas

Menú lateral con **3 destinos**: Transacciones · Alertas IA · Estadísticas. La barra superior tiene búsqueda global, campana de notificaciones y menú de usuario; el indicador de conexión solo aparece cuando hay fallos.

| Código           | Pantalla                                               | Historias    |
| ---------------- | ------------------------------------------------------ | ------------ |
| C-01, C-02       | Login · credenciales inválidas                         | HU-01        |
| C-04             | Plantilla del analista (menú lateral + barra superior) | HU-16        |
| C-05             | Búsqueda global (Ctrl+K)                               | HU-14        |
| C-06             | Panel de notificaciones                                | HU-16        |
| C-08             | Reporte de cliente · pestaña Resumen                   | HU-09        |
| C-11             | Reporte de cliente · pestaña Línea de tiempo           | HU-10        |
| C-12             | Reporte de cliente · pestaña Mapa                      | HU-11        |
| C-14             | Exportar reporte a PDF (ventana emergente)             | HU-12        |
| C-15             | Menú de usuario                                        | HU-01        |
| A-01             | Transacciones                                          | HU-02        |
| A-02             | Vista de cliente                                       | HU-03        |
| N-02             | Vista de cliente · panel lateral de clasificación      | HU-04        |
| A-03             | Clasificar varias transacciones (ventana emergente)    | HU-05        |
| A-04             | Bandeja de alertas IA                                  | HU-06        |
| A-05             | Detalle de alerta de IA                                | HU-07        |
| A-06             | Resolver alerta (ventana emergente)                    | HU-08        |
| A-07             | Estadísticas · pestaña Fraude                          | HU-13        |
| A-08             | Estadísticas · pestaña IA                              | HU-13        |
| N-01             | Panel de filtros (Transacciones y Alertas)             | HU-02, HU-06 |
| N-03             | Historial de la etiqueta (ventana emergente)           | HU-15        |
| N-04             | Matriz de confusión (ventana emergente)                | HU-13        |
| E-01, E-02, E-03 | Estados: cargando, sin pendientes, error al guardar    | HU-02, HU-04 |

---

## 6. Historias de usuario

**Formato:** _Como [rol], quiero [acción], para [beneficio]._
**Prioridad (MoSCoW):** **M** = Must, **S** = Should.
**Puntos:** estimación orientativa en puntos de historia (Fibonacci).

### Épica 1 — Acceso

**HU-01 · Acceso** · M · 3 pts
Como analista, quiero iniciar y cerrar sesión, para acceder a la plataforma y proteger la información.
- Login con correo y contraseña (Supabase Auth); las credenciales inválidas muestran un mensaje que no revela si el correo existe.
- La sesión persiste al cerrar y abrir la app hasta que se cierre o expire; las políticas RLS impiden acceder sin sesión.
- Tras el login, el analista llega a la lista de transacciones.
- «Cerrar sesión» está en el menú de usuario, limpia el estado local y vuelve al login.

### Épica 2 — Exploración de transacciones

**HU-02 · Lista de transacciones** · M · 5 pts
Como analista, quiero ver, filtrar y ordenar todas las transacciones, para elegir cuáles revisar y clasificar.
- Columnas: fecha, cliente / cuenta, tipo · canal, monto, alerta IA (score) y etiqueta.
- Búsqueda por cliente, cuenta o ID y orden por fecha, monto o score siempre visibles.
- El botón «Filtros» abre un panel emergente con: rango de fechas, país, canal, estado de etiqueta y «con alerta IA». Los filtros activos se muestran como chips y se pueden quitar uno a uno o todos.
- Paginación; la tabla no bloquea la app con miles de filas.
- Clic en una fila → Vista de cliente con esa transacción seleccionada.

**HU-03 · Vista de cliente** · M · 8 pts
Como analista, quiero ver las transacciones de un cliente en un rango de fechas, para clasificarlas con contexto.
- Encabezado compacto: nombre, avance del etiquetado (etiquetadas / total), alertas pendientes y botón «Ver perfil», que abre el reporte del cliente en Resumen (desde sus pestañas se llega a la línea de tiempo y al mapa).
- Tabla de las transacciones de todas sus cuentas con filtro por cuenta y por rango de fechas.
- Junto al conteo se muestran los totales del rango: entradas, salidas y neto por moneda.
- Las transacciones con alerta de IA se marcan visualmente.
- Se llega desde la lista global, la búsqueda global o una alerta.

### Épica 3 — Clasificación

**HU-04 · Clasificar una transacción** · M · 5 pts
Como analista, quiero clasificar una transacción con veredicto, tipo(s), confianza, severidad y justificación, para generar datos de entrenamiento de calidad.
- Al seleccionar una transacción se abre un **panel lateral** sobre la vista de cliente, con monto, datos básicos y la alerta de IA si existe. Se cierra con la X, al guardar o con «Siguiente».
- `Fraude` exige al menos un tipo; confianza `Baja` o veredicto `Incierto` exige justificación.
- Se muestra la descripción del nivel de confianza y de severidad elegidos.
- Si ya tiene etiqueta, se muestra quién la puso y cuándo, se puede editar y hay un enlace «Ver historial».
- Al guardar se indica el resultado; si falla, se muestra el error dentro del panel con opción de reintentar.

**HU-05 · Clasificar varias transacciones** · S · 3 pts
Como analista, quiero aplicar la misma clasificación a varias transacciones, para agilizar patrones repetidos (p. ej. fraccionamiento).
- Selección múltiple en la lista global y en la vista de cliente; un formulario único en ventana emergente.
- Confirmación que indica cuántas se modificarán y cuántas ya tenían etiqueta.

### Épica 4 — Alertas de IA

**HU-06 · Bandeja de alertas** · M · 3 pts
Como analista, quiero ver las alertas pendientes ordenadas por score, para atender primero las más riesgosas.
- Bandeja compartida con score, tipo sugerido, cliente y fecha.
- Panel «Filtros» (el mismo de HU-02): score, tipo sugerido y estado (incluye resueltas).
- Las alertas que resuelve otro analista salen de pendientes.

**HU-07 · Detalle de una alerta** · M · 3 pts
Como analista, quiero ver el score, el tipo sugerido y las razones de una alerta, para evaluar si es correcta.
- Score con color por rango; razones legibles con el dato que las respalda y su peso.
- Transacciones involucradas.
- Tarjeta resumida del cliente con botón «Ver cliente».
- Si la transacción ya tiene etiqueta, se muestra un aviso.

**HU-08 · Resolver una alerta** · M · 5 pts
Como analista, quiero confirmar, rechazar o reclasificar una alerta, para validar o corregir lo que detecta la IA.
- Botón único «Resolver alerta» que abre una ventana emergente con la acción: Confirmar · Rechazar · Reclasificar.
- **Confirmar:** etiqueta `Fraude` con el tipo sugerido; pide confianza y severidad.
- **Rechazar:** etiqueta `No fraude`; pide justificación.
- **Reclasificar:** etiqueta `Fraude` con otro tipo; pide tipo, confianza, severidad y justificación.
- Se puede desmarcar transacciones involucradas que no correspondan.
- La alerta cambia de estado, registra quién la resolvió y sale de pendientes; la acción queda en auditoría.

### Épica 5 — Reporte del cliente

El reporte es **una sola pantalla con pestañas**: Resumen · Cuentas · Línea de tiempo · Mapa.

**HU-09 · Reporte de cliente** · M · 5 pts
Como analista, quiero consultar el perfil de un cliente, para entenderlo antes de clasificar.
- Pestaña **Resumen**: datos personales, segmento, nivel de riesgo e historial de etiquetas y alertas.
- Pestaña **Cuentas**: cuentas, tarjetas y dispositivos con su estado y saldo.
- El rango de fechas se muestra como chip y aplica a todas las pestañas.

**HU-10 · Línea de tiempo del cliente** · S · 8 pts
Como analista, quiero ver la actividad del cliente en el tiempo, para detectar anomalías temporales.
- Transacciones (tamaño según monto) y eventos de seguridad (login, cambio de clave, dispositivo nuevo) sobre un eje temporal.
- Resaltado de picos de monto, horarios inusuales y ráfagas; zoom y clic para ver el detalle.

**HU-11 · Mapa de transacciones** · S · 8 pts
Como analista, quiero ver las transacciones en un mapa, para detectar ubicaciones imposibles o inusuales.
- Marcadores coloreados por estado de etiqueta o alerta, con líneas entre transacciones consecutivas.
- Se resalta el «viaje imposible» (distancia/tiempo no realista).

**HU-12 · Exportar reporte a PDF** · M · 3 pts
Como analista, quiero exportar el reporte del cliente a PDF, para compartirlo o archivarlo.
- Ventana emergente para elegir las pestañas a incluir.
- El PDF incluye encabezado de Moneda Segura, fecha, analista y rango; las gráficas van como imagen.
- Se elige la ubicación con el diálogo nativo del sistema.

### Épica 6 — Estadísticas

**HU-13 · Estadísticas** · M · 8 pts
Como analista, quiero ver estadísticas del fraude etiquetado y del desempeño de la IA, para entender tendencias y medir la calidad del modelo.
- Una página con dos pestañas y filtros globales de rango de fechas y país.
- Pestaña **Fraude**: indicadores (avance del etiquetado, total de fraudes, monto comprometido), fraudes en el tiempo y una gráfica de barras con selector «Agrupar por: tipo · canal · país».
- Pestaña **IA**: % de alertas confirmadas, rechazadas y reclasificadas, y precisión por tipo. El botón «Ver matriz de confusión» la abre en una ventana emergente.

### Épica 7 — Transversales

**HU-14 · Búsqueda global** · S · 5 pts
Como analista, quiero buscar clientes, cuentas y transacciones desde cualquier pantalla, para llegar rápido a la información.
- Se abre con Ctrl/Cmd + K o desde la barra superior.
- Busca por nombre, documento, últimos dígitos de cuenta e ID de transacción; resultados agrupados por tipo y navegables con teclado.

**HU-15 · Auditoría e historial de etiquetas** · M · 3 pts
Como analista, quiero que los cambios en etiquetas y alertas queden registrados y poder consultarlos desde la transacción, para tener trazabilidad.
- Se registran la creación y edición de etiquetas y las acciones sobre alertas, con analista, acción, valor anterior, valor nuevo y fecha.
- Los registros no se pueden editar ni borrar desde la app.
- «Ver historial» (desde el panel de clasificación) abre una ventana emergente con los cambios (antes → después).

**HU-16 · Tiempo real y notificaciones** · S · 5 pts
Como analista, quiero que las listas se actualicen solas y recibir avisos de nuevas alertas, para trabajar con información al día.
- Supabase Realtime para alertas y etiquetas; las tablas se refrescan sin recargar.
- Nueva alerta de IA: aviso breve con su score y contador en la campana; clic abre la alerta.
- Aviso «Reconectando…» en la barra superior solo cuando se pierde la conexión.

---

## 7. Requerimientos no funcionales (enfoque frontend)

- **Arquitectura:** separación por capas (presentación, estado, datos/repositorios) y por _features_.
- **Gestión de estado:** una solución consistente en todo el proyecto (p. ej. Riverpod o Bloc).
- **Rendimiento:** tablas con paginación; la app no se bloquea al cargar miles de filas.
- **Diseño:** sistema de diseño propio (colores, tipografía, espaciado, componentes reutilizables). Una tarea principal por pantalla; lo secundario va en pestañas, paneles laterales o ventanas emergentes.
- **Escritorio:** se adapta a distintos tamaños de ventana (mínimo 1280×720); atajos y diálogos nativos donde aplique.
- **Estados de UI:** toda pantalla contempla carga, vacío, error y éxito (mismo componente «Estado de pantalla»).
- **Accesibilidad:** contraste adecuado; los estados no se comunican solo con color.
- **Pruebas:** pruebas de widgets y unitarias para validaciones de clasificación y transformación de datos de gráficas.
- **Idioma:** interfaz en español; formatos de moneda y fecha según la moneda de cada transacción.

---

## 8. Distribución sugerida (5 integrantes)

| Integrante | Responsabilidad principal                                              | Historias         | Pts |
| ---------- | ---------------------------------------------------------------------- | ----------------- | --- |
| 1          | Base de la app, sistema de diseño, acceso, búsqueda, tiempo real y PDF | HU-01, 12, 14, 16 | 16  |
| 2          | Lista de transacciones y vista de cliente                              | HU-02, 03         | 13  |
| 3          | Clasificación, reporte de cliente y auditoría                          | HU-04, 05, 09, 15 | 16  |
| 4          | Alertas de IA y estadísticas                                           | HU-06, 07, 08, 13 | 19  |
| 5          | Visualizaciones avanzadas                                              | HU-10, 11         | 16  |

Recomendación: el integrante 1 entrega primero el sistema de diseño y la estructura base. El script de datos simulados debe estar listo desde el inicio.

---

## 9. Resumen de prioridades

| Prioridad  | Historias                                     |
| ---------- | --------------------------------------------- |
| **Must**   | HU-01, 02, 03, 04, 06, 07, 08, 09, 12, 13, 15 |
| **Should** | HU-05, 10, 11, 14, 16                         |

---

## 10. Supuestos y puntos abiertos

**Decisiones tomadas**

- El alcance se limita al **analista**. No existe rol de administrador.
- El analista trabaja sobre la lista global de transacciones o sobre la vista de un cliente; no existen periodos.
- Las alertas de IA llegan a una **bandeja compartida**; la resuelve el primero que la atiende.
- La **taxonomía de fraude es fija** y viene cargada en la base de datos.
- Los **datos simulados** se generan con un script de seed reproducible; no forma parte de las historias.

**Fuera de alcance**

- Rol de administrador, gestión de usuarios y periodos.
- Edición de la taxonomía.
- Grafo de transferencias entre cuentas.
- Reporte de cuenta independiente (se ve en la pestaña Cuentas del reporte de cliente).
- Reporte de movimientos independiente (los totales del rango están en la vista de cliente).
- Página general de auditoría (el historial se consulta desde cada transacción).
- Guardado automático (se guarda con botón).
- Montos comprometidos por moneda y precisión por rango de score en estadísticas.
- Dashboards de inicio y productividad por analista; enmascaramiento de datos; exportación del dataset.

**Puntos abiertos**

1. **Umbrales de severidad** por moneda: definir valores concretos al construir el seed.
2. **Proveedor de mapas** para HU-11 (p. ej. `flutter_map` con OpenStreetMap, sin API key).
3. **Concurrencia entre analistas:** la última etiqueta guardada prevalece y el historial completo queda en auditoría (HU-04, HU-15).
