# Cliente, cuenta y país en `v_transactions_list`

**Fecha:** 2026-11-07 · **Historia:** HU-02 Lista de transacciones · **Migración:**
`supabase/migrations/20261107131448_transactions_list_customer.sql`

## 1. Resumen

La vista `v_transactions_list`, de la que lee la lista de transacciones (A-01), no traía el
nombre del cliente, los últimos dígitos de la cuenta ni el país. Esta migración agrega tres
columnas al final de la vista, sin cambiar las que ya existían:

| Columna | Tipo | Qué contiene |
| --- | --- | --- |
| `customer_name` | `text` | Nombres y apellidos del cliente (`first_names || ' ' || last_names`) |
| `account_last4` | `char(4)` | Últimos 4 dígitos de la cuenta de ese mismo cliente |
| `country_code` | `char(2)` | País del cliente (`customers.country_code`) |

## 2. Problema

HU-02 pide que la lista muestre el cliente y la cuenta de cada transacción, que se pueda
buscar «por cliente, cuenta o ID» y filtrar por país. La vista solo tenía el ID de la
transacción y los identificadores (`customer_id`, `source_account_id`,
`destination_account_id`), así que:

- La búsqueda solo funcionaba por código de transacción (`TX-48219`).
- La tabla no podía mostrar «Ana María Rojas · •••• 4417».
- El país se obtenía a partir de la moneda, con el catálogo `countries` (ver la sección 6).

## 3. Justificación

1. **Lo exigen las historias de usuario.** HU-02 pide mostrar cliente y cuenta, buscar por
   ellos y filtrar por país. Las historias son la fuente de verdad de mayor prioridad del
   proyecto.
2. **Ya estaba en el contrato de la vista.** `.agents/DATABASE.md` (sección *Views*) define
   `v_transactions_list` como «transaction + customer + masked account + country + channel +
   …». La vista publicada no cumplía esa definición en cliente, cuenta y país.
3. **Lo pide la arquitectura.** `.agents/ARCHITECTURAL_SPINE.md` indica leer las listas desde
   vistas y no unir datos en el cliente, y hacer filtros, orden y paginación en el servidor.
   `DATABASE.md` añade que las vistas deben tener las columnas que necesitan los filtros.
4. **Las alternativas eran peores** (sección 4).

## 4. Alternativas descartadas

| Alternativa | Por qué no |
| --- | --- |
| Pedir `customers` y `accounts` de las filas de cada página | Una consulta extra por página y unir datos en el cliente, que la arquitectura prohíbe. No resuelve la búsqueda. |
| Buscar primero en `customers` / `accounts` y filtrar la vista por esos IDs | Funciona para los 4 dígitos, pero una búsqueda amplia («ma») devuelve cientos de IDs y la petición puede superar el límite del servidor. También une datos en el cliente. |
| Cargar los clientes y las cuentas como un catálogo | Descarga tablas completas (unos 2.000 clientes y 3.500 cuentas), cuando la arquitectura solo lo permite para los catálogos pequeños y fijos. |
| Derivar el país de la moneda con el catálogo `countries` | Sirve para el país, y es lo que hace la app hoy, pero no resuelve nombre ni cuenta. |

## 5. Detalles de la migración

- **`create or replace view`.** Solo permite agregar columnas al final, sin reordenar ni
  renombrar las existentes. Por eso las 27 columnas y los joins de
  `20261103001100_views.sql` se copiaron sin cambios, y las tres nuevas van al final. Se
  comprobó con un `diff` que la única diferencia son esas columnas y un `left join` a
  `customers`.
- **Una migración nueva, no una edición.** `DATABASE.md` prohíbe editar migraciones ya
  aplicadas; la baseline está registrada en el proyecto de Supabase.
- **Cuenta y cliente coherentes.** `customer_id` es el cliente de la cuenta de origen y, si no
  hay, el de la de destino. `account_last4` sigue la misma regla, así que el nombre y los
  dígitos siempre son del mismo cliente.
- **Búsqueda con índice.** `customer_name` usa la misma expresión que el índice
  `idx_customers_name_trgm`, para que Postgres pueda usarlo al buscar con `ilike`.
- **Seguridad.** Se mantiene `security_invoker = true`, así que la vista sigue aplicando las
  reglas RLS de quien consulta. `create or replace` conserva los permisos existentes.
- **Repetible.** Ejecutarla dos veces no cambia nada. Importa si se aplicó desde el SQL Editor
  y luego un `supabase db push` la vuelve a enviar.
- **Sin cambios en el MER.** `docs/mer.puml` describe tablas, no las columnas de las vistas, y
  no se tocó ninguna tabla.

## 6. Aplicación y verificación

La migración se aplicó en el proyecto de Supabase el 2026-11-07, desde el SQL Editor del
panel. Se verificó en solo lectura con la cuenta `demo@monedasegura.test` del seed:

| Comprobación | Resultado |
| --- | --- |
| La vista responde con las columnas nuevas | Sí: `customer_name`, `account_last4` y `country_code` vienen llenas |
| Total de transacciones | 77.550 |
| Transacciones sin `customer_name` | 0 |
| Muestra de 1.000 filas: país de la vista frente al país de la moneda | 0 diferencias |

La última comprobación confirma que, con el seed actual, el país que la app deriva de la
moneda coincide con el país del cliente.

## 7. Historial de migraciones de Supabase

El SQL Editor ejecuta el SQL pero no registra la migración, así que el proyecto no la tenía
como aplicada. Se registró a mano el 2026-11-07, también desde el SQL Editor y sin volver a
ejecutarla:

```sql
insert into supabase_migrations.schema_migrations (version, name)
values ('20261107131448', 'transactions_list_customer');
```

Con eso, el historial remoto coincide con `supabase/migrations/`, y un `supabase db push`
posterior no la vuelve a enviar.

Para comprobarlo:

```sql
select version, name
from supabase_migrations.schema_migrations
order by version desc
limit 5;
```

Con la CLI, `npx supabase migration list` debe mostrarla como aplicada en local y en remoto.

**Para la próxima migración:** aplicarla con `npx supabase db push`, que la ejecuta y la
registra en un solo paso. Si se usa el SQL Editor, registrarla después como aquí, o con
`npx supabase migration repair --status applied <versión>`.

## 8. Impacto en la app y pendientes

- **Capa de datos de la lista (task 1, rama `feat/transactions-data-layer`).**
  `TransactionRow` debe leer `customer_name` y `account_last4`, y la búsqueda volver a cubrir
  cliente, cuenta e ID en una sola consulta.
- **País.** La app lo deriva hoy de la moneda con el catálogo `countries`. Con
  `country_code` en la vista podría leerse directamente, lo que es más exacto si en el futuro
  hay transacciones en una moneda distinta a la del país del cliente. Es una decisión
  pendiente.
- **Vista de cliente (HU-03).** Usa la misma vista, así que también se beneficia.
