-- RPC customer_range_totals: what came in, went out and the net of a customer's accounts in a
-- date range, per currency, for the A-02 customer view (HU-03).
--
-- «Entradas $ 12,4 M · Salidas $ 9,8 M · Neto +$ 2,6 M COP». A view cannot take the customer,
-- the range and the account as parameters, and the range must filter the movements before
-- they are added up, so the totals come from a function.
--
-- - It adds up ledger_entries: every movement of an account of the bank, with its direction.
--   credit = money in, debit = money out, from the point of view of the customer.
-- - A transfer between two accounts of the same customer counts in and out, as each account
--   sees it.
-- - p_from is inclusive and p_to exclusive, as the app sends the start of each day.
--   Null leaves that end open. p_account_id null means every account of the customer.
-- - security invoker (the default) and stable: the caller's RLS applies and it only reads.
--   idx_ledger_account_time (account_id, occurred_at) serves the range.
create or replace function public.customer_range_totals(
  p_customer_id uuid,
  p_from timestamptz default null,
  p_to timestamptz default null,
  p_account_id uuid default null
)
returns table (
  currency_code char(3),
  total_in numeric,
  total_out numeric,
  net numeric,
  transaction_count bigint
)
language sql
stable
set search_path to ''
as $$
  select a.currency_code,
         coalesce(sum(le.amount) filter (where le.direction = 'credit'), 0),
         coalesce(sum(le.amount) filter (where le.direction = 'debit'), 0),
         coalesce(sum(case when le.direction = 'credit' then le.amount
                           else -le.amount end), 0),
         count(distinct le.transaction_id)
    from public.ledger_entries le
    join public.accounts a on a.id = le.account_id
   where a.customer_id = p_customer_id
     and (p_account_id is null or a.id = p_account_id)
     and (p_from is null or le.occurred_at >= p_from)
     and (p_to is null or le.occurred_at < p_to)
   group by a.currency_code
   order by a.currency_code;
$$;

-- Only analysts call it, like the other RPCs (20261103001200_rls_and_grants.sql).
revoke execute on function public.customer_range_totals(uuid, timestamptz, timestamptz, uuid)
  from public, anon;
grant execute on function public.customer_range_totals(uuid, timestamptz, timestamptz, uuid)
  to authenticated;
