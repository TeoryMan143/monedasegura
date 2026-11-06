# Migración de Riverpod: de generación de código a providers escritos a mano

**Fecha:** 2026-11-05 · **Alcance:** `lib/`, `pubspec.yaml`, documentación de arquitectura

## 1. Resumen

Moneda Segura usa Riverpod para compartir estado entre widgets sin pasar datos de padre a hijo
por constructores (*prop drilling*). Hasta ahora los providers se declaraban con anotaciones
(`@riverpod` / `@Riverpod(keepAlive: true)`) y el paquete `riverpod_generator` escribía, vía
`build_runner`, los archivos `*.g.dart` con las clases reales de los providers.

Ahora **los providers se escriben a mano** con la API "pura" de `flutter_riverpod`
(`Provider`, `StreamProvider`, `NotifierProvider`…). El problema que resuelve Riverpod sigue
resuelto exactamente igual: los widgets siguen haciendo `ref.watch(algoProvider)` y los
tests siguen usando `ProviderScope(overrides: [...])`. Lo que cambia es **cómo se declara** cada
provider: más código, pero todo visible y sin un paso de generación de por medio.

## 2. Qué cambió

### 2.1 Dependencias (`pubspec.yaml`)

| Paquete | Antes | Ahora | Motivo |
| --- | --- | --- | --- |
| `flutter_riverpod` | ✔ | ✔ | Es Riverpod en sí; no cambia. |
| `riverpod_annotation` | ✔ | ✘ eliminado | Solo aportaba las anotaciones `@riverpod`. |
| `riverpod_generator` | ✔ (dev) | ✘ eliminado | Era el generador de `*.g.dart` de providers. |
| `riverpod_lint` | ✔ (dev) | ✔ | Funciona igual con providers manuales (detecta `ref.read` en `build`, falta de `ProviderScope`, etc.). |
| `build_runner`, `freezed`, `json_serializable` | ✔ | ✔ | **Se conservan**: generan los modelos (`*.freezed.dart`, `*.g.dart` de JSON), no los providers. |

Se eliminaron también del `pubspec.lock` las dependencias transitivas que solo traía el
generador (`code_builder`, `mockito`).

### 2.2 Archivos de código

| Archivo | Cambio |
| --- | --- |
| `lib/core/supabase/supabase_client_provider.dart` | Los tres providers (`supabaseClientProvider`, `authStateProvider`, `isSignedInProvider`) pasan a ser variables `final` escritas a mano. |
| `lib/core/supabase/supabase_client_provider.g.dart` | **Eliminado** (139 líneas generadas). |
| `lib/app/router.dart` | `routerProvider` pasa a ser `Provider<GoRouter>(_buildRouter)`; se quitan `part 'router.g.dart'` y el import de `riverpod_annotation`. |
| `lib/app/router.g.dart` | **Eliminado** (55 líneas generadas). |
| `lib/app/app.dart`, `lib/main.dart`, `test/app/router_test.dart` | Sin cambios: el nombre público de cada provider (`routerProvider`, `isSignedInProvider`…) se mantuvo igual, así que nadie que los consume se enteró. |

### 2.3 Antes y después

**Antes** (con generación):

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'supabase_client_provider.g.dart';

@Riverpod(keepAlive: true)
SupabaseClient supabaseClient(Ref ref) => Supabase.instance.client;

@Riverpod(keepAlive: true)
Stream<AuthState> authState(Ref ref) =>
    ref.watch(supabaseClientProvider).auth.onAuthStateChange;
```

`supabaseClientProvider` y `authStateProvider` **no existían en el código fuente**: aparecían
en el `.g.dart` después de correr `dart run build_runner build`.

**Después** (manual):

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final supabaseClientProvider = Provider<SupabaseClient>(
  (ref) => Supabase.instance.client,
  name: 'supabaseClientProvider',
);

final authStateProvider = StreamProvider<AuthState>(
  (ref) => ref.watch(supabaseClientProvider).auth.onAuthStateChange,
  name: 'authStateProvider',
);
```

El tipo de provider (`Provider`, `StreamProvider`), su tipo de dato y su ciclo de vida se ven
directamente en la declaración.

### 2.4 Documentación actualizada

- `AGENTS.md`: la regla 2 ahora dice "Riverpod con providers escritos a mano" y el comando de
  `build_runner` ya no menciona `@riverpod`.
- `.agents/ARCHITECTURAL_SPINE.md`: tabla del stack, flujo de datos y la sección **State
  (Riverpod)**, que ahora incluye una tabla de "qué provider usar para qué" y la regla sobre
  `.autoDispose`.
- `README.md`: stack, tabla de comandos y checklist de progreso.

### 2.5 Verificación

- `dart format lib test`: sin cambios.
- `flutter analyze`: *No issues found* (incluye `riverpod_lint`).
- `flutter test`: 12/12 pruebas pasan (incluidas las del router con `isSignedInProvider.overrideWithValue`).
- `dart run build_runner build -d`: sigue funcionando para `freezed` / `json_serializable`.

> Nota de entorno: el Flutter instalado en la máquina donde se hizo el cambio trae Dart 3.13.5
> y el proyecto exige `^3.13.7`. Para verificar se bajó la restricción temporalmente y luego se
> restauró. Conviene que todo el equipo haga `flutter upgrade` (≥ 3.47.9).

## 3. Guía rápida: cómo escribir providers a partir de ahora

| Necesidad | Declaración |
| --- | --- |
| Valor u objeto (repositorio, router) | `final xProvider = Provider<T>((ref) => …);` |
| Lectura async única | `FutureProvider.autoDispose<T>((ref) async => …)` |
| Stream (auth, realtime) | `StreamProvider<T>((ref) => …)` |
| Estado con operaciones | `NotifierProvider.autoDispose<XNotifier, T>(XNotifier.new)` + `class XNotifier extends Notifier<T>` |
| Estado async con operaciones | `AsyncNotifierProvider.autoDispose<XNotifier, T>(XNotifier.new)` + `class XNotifier extends AsyncNotifier<T>` |
| Con parámetro | Añadir `.family<T, Arg>`; en un Notifier el argumento llega por el constructor |

Ejemplo de lo que vendrá en HU-02 (lista de transacciones):

```dart
// Repositorio: app-wide, se queda vivo.
final transactionsRepositoryProvider = Provider<TransactionsRepository>(
  (ref) => TransactionsRepository(ref.watch(supabaseClientProvider)),
  name: 'transactionsRepositoryProvider',
);

// Filtros y orden de la lista: estado con operaciones, se destruye al salir de la pantalla.
class TransactionsQueryNotifier extends Notifier<TransactionsQuery> {
  @override
  TransactionsQuery build() => const TransactionsQuery();

  void setPage(int page) => state = state.copyWith(page: page);
  void setFilter(TransactionsFilter f) => state = state.copyWith(filter: f, page: 1);
}

final transactionsQueryProvider =
    NotifierProvider.autoDispose<TransactionsQueryNotifier, TransactionsQuery>(
      TransactionsQueryNotifier.new,
      name: 'transactionsQueryProvider',
    );

// Página actual: depende del query.
final transactionsPageProvider =
    FutureProvider.autoDispose<Page<TransactionRow>>((ref) {
      final query = ref.watch(transactionsQueryProvider);
      return ref.watch(transactionsRepositoryProvider).fetchPage(query);
    }, name: 'transactionsPageProvider');

// Vista de cliente: un parámetro → family.
final customerViewProvider =
    FutureProvider.autoDispose.family<CustomerView, String>((ref, customerId) {
      return ref.watch(customerRepositoryProvider).fetchCustomer(customerId);
    }, name: 'customerViewProvider');
```

## 4. Problemas que pueden aparecer a futuro

### 4.1 Fugas de memoria por olvidar `.autoDispose` (el riesgo más importante)

Con el generador, **todo provider era auto-dispose por defecto** y había que pedir
`keepAlive: true` explícitamente. Con providers manuales es **al revés**: si no se escribe
`.autoDispose`, el provider vive para siempre.

Consecuencias si se olvida en un provider de pantalla o en una *family*:

- Cada `customerViewProvider(id)` visitado queda en memoria toda la sesión.
- Los filtros de una lista "recuerdan" el estado anterior al volver a la pantalla.
- Suscripciones de realtime o streams que nunca se cierran.

**Mitigación:** la regla quedó escrita en `ARCHITECTURAL_SPINE.md`; revisarla en cada code
review. Solo los providers app-wide (sesión, analista actual, catálogos, repositorios, router,
realtime, estado de conexión) van sin `.autoDispose`.

### 4.2 Más boilerplate y más lugares donde equivocarse

- Hay que escribir a mano los tipos genéricos (`NotifierProvider.autoDispose<XNotifier, T>`).
  Si no coinciden con la clase, el error del compilador suele ser largo y confuso.
- Al combinar modificadores el orden importa y es fácil confundirse
  (`FutureProvider.autoDispose.family<T, Arg>`).
- Es fácil elegir la clase de provider equivocada (por ejemplo `Provider` en vez de
  `FutureProvider`) y terminar con un `Future<T>` donde se esperaba un `AsyncValue<T>`.

### 4.3 Families con un solo argumento

El generador permitía varios parámetros (`customerView(Ref ref, String id, DateRange range)`).
A mano, una *family* recibe **un único argumento**. Si se necesitan varios hay que agruparlos
en una clase con igualdad por valor (`@freezed` o un *record* de Dart). Si se usa una clase sin
`==`/`hashCode`, cada `ref.watch` crea un provider nuevo y se repiten las consultas a Supabase
infinitamente.

### 4.4 Nombres y depuración

El generador ponía `name:` automáticamente; a mano hay que acordarse (se dejó como convención).
Sin `name`, los `ProviderObserver`, los logs y DevTools muestran nombres genéricos y cuesta
saber qué provider falló.

### 4.5 Funciones nuevas de Riverpod pensadas para el generador

La documentación oficial de Riverpod 3 presenta primero la sintaxis con `@riverpod`, y
algunos lints de `riverpod_lint` solo aplican a providers generados. La API manual está
soportada y no está marcada como obsoleta, pero:

- Muchos ejemplos de internet y respuestas de IA vendrán en formato `@riverpod` y habrá que
  traducirlos.
- Si en una versión futura alguna funcionalidad nueva sale primero (o solo) para el
  generador, habrá que esperar o volver a añadir `riverpod_generator`.

### 4.6 No mezclar con las APIs heredadas

Al escribir a mano es tentador usar `StateProvider`, `StateNotifierProvider` o
`ChangeNotifierProvider` porque aparecen en tutoriales viejos. En Riverpod 3 están en
`package:flutter_riverpod/legacy.dart` y no deben usarse; la convención es `Notifier` /
`AsyncNotifier`.

### 4.7 Consistencia con el resto del proyecto

`build_runner` **sigue siendo necesario** para `freezed` y `json_serializable`. Quien entre al
proyecto podría pensar que, al quitar el generador de Riverpod, ya no hay que correr
`build_runner`. Los modelos (`@freezed`) siguen requiriéndolo.

### 4.8 Volver atrás

Si en algún momento se decide volver a la generación de código, la migración inversa es
mecánica: agregar `riverpod_annotation` y `riverpod_generator`, convertir cada
`final xProvider = …` en una función o clase con `@riverpod` **manteniendo el mismo nombre**
y correr `build_runner`. Como el nombre público de cada provider se conserva, los widgets y
los tests no cambiarían.
