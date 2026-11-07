# RPC `customer_range_totals`: totales del rango en la vista de cliente

**Fecha:** 2026-11-07 · **Historia:** HU-03 Vista de cliente · **Migración:**
`supabase/migrations/20261107152546_customer_range_totals.sql`

## 1. Resumen

La vista de cliente (A-02) muestra, junto al conteo de transacciones, los totales del rango
por moneda: «Entradas $ 12,4 M · Salidas $ 9,8 M · Neto +$ 2,6 M COP». No existía ninguna
vista ni función que los calculara. Esta migración agrega la función
`public.customer_range_totals`, que la app llama como RPC:

```dart
final rows = await client.rpc('customer_range_totals', params: {
  'p_customer_id': customerId,
  'p_from': from,           // inclusivo, opcional
  'p_to': to,               // exclusivo, opcional
  'p_account_id': accountId, // opcional: null = todas sus cuentas
});
```

Devuelve una fila por moneda:

| Columna | Tipo | Qué contiene |
| --- | --- | --- |
| `currency_code` | `char(3)` | Moneda de las cuentas |
| `total_in` | `numeric` | Suma de las entradas (`credit`) |
| `total_out` | `numeric` | Suma de las salidas (`debit`) |
| `net` | `numeric` | Entradas menos salidas |
| `transaction_count` | `bigint` | Transacciones distintas con movimientos en esa moneda |

## 2. Justificación

1. **Lo exigen la historia y la task.** HU-03 pide «los totales del rango: entradas,
   salidas y neto por moneda», y la task 2 pide que vengan «de una consulta agregada en la
   base (no sumando la página en el cliente)».
2. **Una vista no sirve aquí.** Los totales dependen de tres parámetros: el cliente, el
   rango y, opcionalmente, la cuenta. Una vista no recibe parámetros, y si ya trae las sumas
   el rango no se puede aplicar, porque los movimientos individuales ya están agrupados. El
   rango tiene que filtrar los movimientos antes de sumarlos.
3. **Es la forma del proyecto para consultas con parámetros.** La base ya tiene las RPC
   `global_search`, `resolve_alert` y `label_transactions`, y `.agents/DATABASE.md` las
   describe como uno de los caminos de lectura y escritura de la app.

## 3. Alternativas descartadas

| Alternativa | Por qué no |
| --- | --- |
| Sumar en la app las filas de la página | La página tiene 25 filas de un rango que puede tener cientos; el total sería falso. La task lo prohíbe. |
| Vista con sumas por cliente, cuenta, moneda y día, y la app suma los días del rango | Los totales finales se calcularían en la app, contra lo que pide la task. |
| Vista de movimientos con agregados de PostgREST (`amount.sum()`) | Supabase trae los agregados desactivados; activarlos cambia la configuración de todo el proyecto. |

## 4. Detalles

- **Fuente:** `ledger_entries`, que registra cada movimiento de una cuenta del banco con su
  dirección y monto. `credit` es dinero que entra a la cuenta del cliente y `debit` dinero
  que sale.
- **Transferencias entre cuentas del mismo cliente:** cuentan como entrada en una y salida en
  la otra, tal como las ve cada cuenta. El neto de esa transferencia es cero si ambas cuentas
  tienen la misma moneda.
- **Rango:** `p_from` es inclusivo y `p_to` exclusivo; la app envía el inicio de cada día,
  como hace el filtro de fechas de la lista. Un extremo nulo queda abierto.
- **Rendimiento:** el índice existente `idx_ledger_account_time (account_id, occurred_at)`
  cubre el filtro por cuenta y rango.
- **Seguridad:** la función es `security invoker` (la opción por defecto), así que aplica el
  RLS de quien la llama, y `stable`, porque solo lee. Igual que las demás RPC, `anon` no
  puede ejecutarla y `authenticated` sí.
- **Sin cambios en el MER:** `docs/mer.puml` describe tablas, y no se tocó ninguna.

## 5. Aplicación y verificación

Se aplicó el 2026-11-07 desde el SQL Editor de Supabase, igual que las migraciones de
`v_transactions_list` (`docs/vista-transacciones-cliente.md`, sección 7).

**Verificación** (solo lectura, cuenta `demo@monedasegura.test`):

| Comprobación | Resultado |
| --- | --- |
| Llamada sin sesión (`anon`) | Rechazada: «permission denied for function customer_range_totals» |
| Un cliente, sin rango | Una fila PEN: entradas 17.415,81, salidas 8.898,23, neto 8.517,58, 50 transacciones |
| El mismo cliente, últimos 30 días | Entradas 6.381,48, salidas 2.325,02, neto 4.056,46, 12 transacciones |
| Solo una de sus dos cuentas | Entradas 14.973,13, salidas 8.558,05, 38 transacciones |
| Suma directa de sus filas de `ledger_entries` | Entradas 17.415,81 y salidas 8.898,23: igual a la RPC |

**Registro en el historial.** Se registró el mismo día, también desde el SQL Editor y sin
volver a ejecutarla, para que `supabase db push` no la vuelva a enviar:

```sql
insert into supabase_migrations.schema_migrations (version, name)
values ('20261107152546', 'customer_range_totals');
```

Para probarla con un cliente cualquiera:

```sql
select *
from public.customer_range_totals(
  (select id from public.customers limit 1),
  now() - interval '30 days',
  null
);
```

## 6. Uso en la app

`CustomerRepository` (feature `customer`, task 2) la llama con el cliente, el rango de la
vista y la cuenta elegida en el filtro «Cuenta». Una función pura de `domain` convierte cada
fila al texto de la vista (créditos con «+», CLP sin decimales), con su prueba.
