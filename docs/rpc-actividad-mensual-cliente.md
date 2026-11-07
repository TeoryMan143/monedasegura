# RPC `customer_monthly_activity`: actividad por mes en el reporte de cliente

**Fecha:** 2026-11-07 · **Historia:** HU-09 Reporte de cliente · **Migración:**
`supabase/migrations/20261107230000_customer_monthly_activity.sql`

## 1. Resumen

La pestaña Resumen del reporte de cliente (C-08) muestra la actividad por mes: cuántas
transacciones hizo el cliente y cuánto movió. No existía ninguna vista ni función que lo
calculara. Esta migración agrega la función `public.customer_monthly_activity`, que la app
llama como RPC:

```dart
final rows = await client.rpc('customer_monthly_activity', params: {
  'p_customer_id': customerId,
  'p_from': from, // inclusivo, opcional
  'p_to': to,     // exclusivo, opcional
});
```

Devuelve una fila por mes y moneda, del mes más antiguo al más reciente:

| Columna | Tipo | Qué contiene |
| --- | --- | --- |
| `month` | `date` | Primer día del mes (UTC) |
| `currency_code` | `char(3)` | Moneda de las transacciones |
| `transaction_count` | `bigint` | Transacciones del cliente en ese mes y moneda |
| `total_amount` | `numeric` | Suma de sus montos |

## 2. Justificación

1. **Lo exige la task.** La tarjeta de HU-09 pide la actividad por mes «agregada de una vista
   o consulta agregada, no sumando en el cliente».
2. **Una vista no sirve aquí.** El resultado depende del cliente y del rango, y el rango
   tiene que filtrar las transacciones antes de agruparlas. Es el mismo caso de
   `customer_range_totals` (`docs/rpc-totales-cliente.md`).

## 3. Detalles

- **Fuente:** `transactions`. Una transacción es del cliente si una de sus cuentas es el
  origen o el destino, igual que en la vista de cliente (A-02). Una transferencia entre dos
  cuentas del mismo cliente cuenta una sola vez.
- **Qué cuenta:** todos los estados, porque un intento rechazado también es actividad. El
  monto se suma tal como está, en la moneda de la transacción. Montos de monedas distintas
  nunca se suman: la app muestra una moneda a la vez.
- **Meses:** meses calendario en UTC. Una transacción de las últimas horas de un mes, en
  hora de Colombia, puede caer en el mes siguiente.
- **Rango:** `p_from` es inclusivo y `p_to` exclusivo; la app envía el inicio de cada día. Un
  extremo nulo queda abierto.
- **Rendimiento:** los índices existentes `idx_tx_source_time` y `idx_tx_destination_time`
  cubren el filtro por cuenta y rango.
- **Seguridad:** `security invoker` y `stable`, como `customer_range_totals`. `anon` no puede
  ejecutarla y `authenticated` sí.
- **Sin cambios en el MER:** no se tocó ninguna tabla.

## 4. Aplicación (pendiente)

**Todavía no está aplicada en el proyecto de Supabase.** Mientras no lo esté, el gráfico
muestra el error con «Reintentar». Para aplicarla, alguien con acceso al proyecto:

```bash
npx supabase db push
```

O desde el SQL Editor: ejecutar la migración y registrarla después, como se explica en
`docs/vista-transacciones-cliente.md`:

```sql
insert into supabase_migrations.schema_migrations (version, name)
values ('20261107230000', 'customer_monthly_activity');
```

Para probarla:

```sql
select *
from public.customer_monthly_activity(
  'a9b76617-7834-59c4-f259-124b702b77c8', -- Luciana Restrepo Torres (caso de demo HU-10)
  now() - interval '6 months',
  null
);
```

## 5. Uso en la app

`CustomerReportRepository.fetchMonthlyActivity` la llama con el cliente y el rango
compartido de A-02 y el reporte. `ReportActivityChart` dibuja una barra por mes con
`fl_chart`, con el monto o la cantidad (nunca los dos en el mismo eje), y el tooltip de cada
barra muestra ambos.
