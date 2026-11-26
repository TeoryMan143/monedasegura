-- RPC customer_monthly_activity: how many transactions a customer made each month and how
-- much they moved, per currency, for the «Actividad por mes» chart of the customer report
-- (C-08, HU-09).
--
-- The chart must not add up rows on the client (ARCHITECTURAL_SPINE.md), and a view cannot
-- take the customer and the range as parameters, so the totals come from a function, like
-- customer_range_totals.
--
-- - A transaction belongs to the customer when one of their accounts is its source or its
--   destination, as in the A-02 view. A transfer between two of their own accounts counts
--   once.
-- - It counts every status (declined attempts are activity too) and adds up the amount as
--   written, in the transaction's currency.
-- - Months are calendar months in UTC: a transaction in the last hours of a month, Colombia
--   time, can fall in the next one.
-- - p_from is inclusive and p_to exclusive, as the app sends the start of each day.
--   Null leaves that end open.
-- - security invoker (the default) and stable: the caller's RLS applies and it only reads.
--   idx_tx_source_time and idx_tx_destination_time serve the range.
create or replace function public.customer_monthly_activity(
  p_customer_id uuid,
  p_from timestamptz default null,
  p_to timestamptz default null
)
returns table (
  month date,
  currency_code char(3),
  transaction_count bigint,
  total_amount numeric
)
language sql
stable
set search_path to ''
as $$
  with accounts as (
    select a.id from public.accounts a where a.customer_id = p_customer_id
  ),
  movements as (
    select t.id, t.occurred_at, t.currency_code, t.amount
      from public.transactions t
      join accounts a on a.id = t.source_account_id
     where (p_from is null or t.occurred_at >= p_from)
       and (p_to is null or t.occurred_at < p_to)
    union
    select t.id, t.occurred_at, t.currency_code, t.amount
      from public.transactions t
      join accounts a on a.id = t.destination_account_id
     where (p_from is null or t.occurred_at >= p_from)
       and (p_to is null or t.occurred_at < p_to)
  )
  select date_trunc('month', m.occurred_at at time zone 'UTC')::date,
         m.currency_code,
         count(*),
         sum(m.amount)
    from movements m
   group by 1, 2
   order by 1, 2;
$$;

-- Only analysts call it, like the other RPCs (20261103001200_rls_and_grants.sql).
revoke execute on function public.customer_monthly_activity(uuid, timestamptz, timestamptz)
  from public, anon;
grant execute on function public.customer_monthly_activity(uuid, timestamptz, timestamptz)
  to authenticated;
