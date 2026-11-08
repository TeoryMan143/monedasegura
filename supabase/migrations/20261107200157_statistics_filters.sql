-- Statistics with filters (HU-13, A-07, A-08, N-04).
--
-- v_fraud_stats and v_ai_performance have no date and no country, and nothing groups by
-- week, channel or country, so the app could not filter the statistics or draw the line
-- and the bars. This migration adds:
--
--   v_stats_transactions  one row per transaction with the columns the statistics filter on
--   fraud_stats_kpis      the three cards of the «Fraude» tab
--   fraud_over_time       frauds per week
--   fraud_grouped         frauds per type, channel or country
--   ai_performance        alerts per suggested type, status and final type
--
-- All the functions take the same filters: a date range (inclusive, as dates of the
-- session time zone, UTC in Supabase) and a country.
-- A null filter means "no filter". They are `security invoker`, so RLS decides who reads
-- (analysts only), and they only add up rows: the app receives a few dozen.
-- Nothing existing changes, and running it twice is harmless.

-- One row per transaction. The country is the one of the customer who owns the account,
-- found the same way as in v_transactions_list. amount_cop is null for a currency without
-- an exchange rate.
create or replace view public.v_stats_transactions with (security_invoker = true) as
select t.id,
  t.occurred_at,
  t.channel_code,
  c.country_code,
  t.currency_code,
  t.amount,
  t.amount * er.rate_to_cop as amount_cop,
  t.is_labeled,
  l.verdict
from public.transactions t
left join public.accounts sa on sa.id = t.source_account_id
left join public.accounts da on da.id = t.destination_account_id
left join public.customers c on c.id = coalesce(sa.customer_id, da.customer_id)
left join public.labels l on l.transaction_id = t.id
left join public.exchange_rates er on er.currency_code = t.currency_code;

comment on view public.v_stats_transactions is
  'Transactions with channel, country, amount in COP and label verdict. Base of the statistics functions.';

-- «Avance del etiquetado», «Total de fraudes» and «Monto comprometido» (one total in COP).
-- A fraud counts once, even when its label has two fraud types.
create or replace function public.fraud_stats_kpis(
  p_from date default null,
  p_to date default null,
  p_country text default null)
returns table (
  total_transactions bigint,
  labeled bigint,
  fraud bigint,
  committed_amount_cop numeric)
language sql
stable
set search_path to ''
as $$
  select count(*),
    count(*) filter (where s.is_labeled),
    count(*) filter (where s.verdict = 'fraud'),
    coalesce(sum(s.amount_cop) filter (where s.verdict = 'fraud'), 0)
  from public.v_stats_transactions s
  where (p_from is null or s.occurred_at >= p_from)
    and (p_to is null or s.occurred_at < p_to + 1)
    and (p_country is null or s.country_code = p_country);
$$;

-- «Fraudes en el tiempo». Weeks start on Monday (UTC). A week without frauds has no row:
-- the app fills it with 0.
create or replace function public.fraud_over_time(
  p_from date default null,
  p_to date default null,
  p_country text default null)
returns table (period_start date, fraud_count bigint)
language sql
stable
set search_path to ''
as $$
  select date_trunc('week', s.occurred_at at time zone 'UTC')::date,
    count(*)
  from public.v_stats_transactions s
  where s.verdict = 'fraud'
    and (p_from is null or s.occurred_at >= p_from)
    and (p_to is null or s.occurred_at < p_to + 1)
    and (p_country is null or s.country_code = p_country)
  group by 1
  order by 1;
$$;

-- «Agrupar por»: p_by is 'type', 'channel' or 'country'. The key is the code of the group.
-- By type, a fraud with two types counts once in each. Groups without a key (a transaction
-- of an external account has no country) are left out.
create or replace function public.fraud_grouped(
  p_by text,
  p_from date default null,
  p_to date default null,
  p_country text default null)
returns table (key text, count bigint)
language plpgsql
stable
set search_path to ''
as $$
begin
  if p_by = 'type' then
    return query
      select ft.code::text, count(*)
      from public.v_stats_transactions s
      join public.labels l on l.transaction_id = s.id
      join public.label_fraud_types lft on lft.label_id = l.id
      join public.fraud_types ft on ft.id = lft.fraud_type_id
      where s.verdict = 'fraud'
        and (p_from is null or s.occurred_at >= p_from)
        and (p_to is null or s.occurred_at < p_to + 1)
        and (p_country is null or s.country_code = p_country)
      group by ft.code;
  elsif p_by = 'channel' then
    return query
      select s.channel_code::text, count(*)
      from public.v_stats_transactions s
      where s.verdict = 'fraud'
        and (p_from is null or s.occurred_at >= p_from)
        and (p_to is null or s.occurred_at < p_to + 1)
        and (p_country is null or s.country_code = p_country)
      group by s.channel_code;
  elsif p_by = 'country' then
    return query
      select s.country_code::text, count(*)
      from public.v_stats_transactions s
      where s.verdict = 'fraud'
        and s.country_code is not null
        and (p_from is null or s.occurred_at >= p_from)
        and (p_to is null or s.occurred_at < p_to + 1)
        and (p_country is null or s.country_code = p_country)
      group by s.country_code;
  else
    raise exception 'invalid_group_by' using errcode = 'P0001';
  end if;
end;
$$;

-- «Desempeño de la IA» and the confusion matrix (N-04). The same rows as v_ai_performance
-- without the score range, for the alerts generated in the range, of customers of the
-- country. A rejected alert has final_type_code 'NONE' and a pending one has null.
create or replace function public.ai_performance(
  p_from date default null,
  p_to date default null,
  p_country text default null)
returns table (
  suggested_type_code text,
  status public.alert_status,
  final_type_code text,
  alerts bigint)
language sql
stable
set search_path to ''
as $$
  select st.code::text,
    a.status,
    coalesce(ft.code, case a.status when 'rejected' then 'NONE' end)::text,
    count(*)
  from public.ai_alerts a
  join public.fraud_types st on st.id = a.suggested_type_id
  left join public.fraud_types ft on ft.id = a.final_type_id
  join public.customers c on c.id = a.customer_id
  where (p_from is null or a.generated_at >= p_from)
    and (p_to is null or a.generated_at < p_to + 1)
    and (p_country is null or c.country_code = p_country)
  group by st.code, a.status, ft.code;
$$;

-- Only signed-in analysts read them (the same grants as the other views and RPCs).
revoke all on public.v_stats_transactions from anon;
grant select on public.v_stats_transactions to authenticated;

revoke execute on function public.fraud_stats_kpis(date, date, text) from public, anon;
revoke execute on function public.fraud_over_time(date, date, text) from public, anon;
revoke execute on function public.fraud_grouped(text, date, date, text) from public, anon;
revoke execute on function public.ai_performance(date, date, text) from public, anon;
grant execute on function public.fraud_stats_kpis(date, date, text) to authenticated;
grant execute on function public.fraud_over_time(date, date, text) to authenticated;
grant execute on function public.fraud_grouped(text, date, date, text) to authenticated;
grant execute on function public.ai_performance(date, date, text) to authenticated;
