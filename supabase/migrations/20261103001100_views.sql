-- Baseline 11/14 · read models. security_invoker so the caller's RLS applies.

create view public.v_transactions_list with (security_invoker = true) as
select t.id,
  t.code,
  t.occurred_at,
  t.type,
  t.channel_code,
  t.amount,
  t.currency_code,
  t.status,
  t.source_account_id,
  t.destination_account_id,
  coalesce(sa.customer_id, da.customer_id) as customer_id,
  t.card_id,
  t.merchant_id,
  m.name as merchant_name,
  t.city_id,
  t.description,
  t.is_labeled,
  l.id as label_id,
  l.verdict,
  l.confidence,
  l.severity,
  l.source as label_source,
  l.analyst_id as labeled_by,
  l.updated_at as labeled_at,
  l.version as label_version,
  al.max_score as alert_score,
  coalesce(al.alert_count, 0::bigint) as alert_count
from public.transactions t
left join public.accounts sa on sa.id = t.source_account_id
left join public.accounts da on da.id = t.destination_account_id
left join public.merchants m on m.id = t.merchant_id
left join public.labels l on l.transaction_id = t.id
left join lateral (
  select max(a.score) as max_score, count(*) as alert_count
  from public.ai_alert_transactions aat
  join public.ai_alerts a on a.id = aat.alert_id
  where aat.transaction_id = t.id
) al on true;

create view public.v_customer_label_progress with (security_invoker = true) as
with ct as (
  select distinct a.customer_id, t.id, t.is_labeled
  from public.transactions t
  join public.accounts a on a.id = t.source_account_id or a.id = t.destination_account_id
  where a.customer_id is not null
)
select c.id as customer_id,
  (c.first_names || ' ' || c.last_names) as customer_name,
  count(ct.id) as total_transactions,
  count(ct.id) filter (where ct.is_labeled) as labeled,
  count(ct.id) filter (where not ct.is_labeled) as unlabeled,
  round(100.0 * (count(ct.id) filter (where ct.is_labeled))::numeric / nullif(count(ct.id), 0)::numeric, 2) as pct_labeled
from public.customers c
left join ct on ct.customer_id = c.id
group by c.id, c.first_names, c.last_names;

create view public.v_labeling_progress with (security_invoker = true) as
select
  (select count(*) from public.transactions) as total_transactions,
  (select count(*) from public.transactions where transactions.is_labeled) as labeled,
  (select count(*) from public.transactions where not transactions.is_labeled) as unlabeled,
  (select count(*) from public.labels where labels.verdict = 'fraud') as fraud,
  (select count(*) from public.labels where labels.verdict = 'not_fraud') as not_fraud,
  (select count(*) from public.labels where labels.verdict = 'uncertain') as uncertain,
  (select count(*) from public.labels where labels.source = 'alert') as from_alerts,
  (select count(*) from public.labels where labels.source = 'manual') as manual,
  round(100.0 * ((select count(*) from public.transactions where transactions.is_labeled))::numeric
        / nullif((select count(*) from public.transactions), 0)::numeric, 2) as pct_labeled;

create view public.v_fraud_stats with (security_invoker = true) as
select ft.id as fraud_type_id,
  ft.code as fraud_type_code,
  ft.name as fraud_type_name,
  ft.color,
  t.currency_code,
  count(*) as labeled_transactions,
  sum(t.amount) as total_amount,
  avg(t.amount) as avg_amount,
  count(*) filter (where l.source = 'alert') as from_alerts,
  count(*) filter (where l.severity = 'critical') as critical,
  count(*) filter (where l.severity = 'high') as high,
  count(*) filter (where l.severity = 'medium') as medium,
  count(*) filter (where l.severity = 'low') as low
from public.label_fraud_types lft
join public.labels l on l.id = lft.label_id and l.verdict = 'fraud'
join public.fraud_types ft on ft.id = lft.fraud_type_id
join public.transactions t on t.id = l.transaction_id
group by ft.id, ft.code, ft.name, ft.color, t.currency_code;

create view public.v_ai_performance with (security_invoker = true) as
select a.suggested_type_id,
  st.code as suggested_type_code,
  a.status,
  a.final_type_id,
  coalesce(ft.code, (case a.status when 'rejected' then 'NONE'::text else null::text end)::varchar) as final_type_code,
  (least(a.score::integer, 99) / 10) * 10 as score_bucket,
  count(*) as alerts,
  avg(a.score)::numeric(5, 2) as avg_score,
  avg(extract(epoch from (a.resolved_at - a.generated_at)) / 60::numeric)::numeric(12, 2) as avg_minutes_to_resolve
from public.ai_alerts a
join public.fraud_types st on st.id = a.suggested_type_id
left join public.fraud_types ft on ft.id = a.final_type_id
group by a.suggested_type_id, st.code, a.status, a.final_type_id, ft.code, (least(a.score::integer, 99) / 10) * 10;

create view public.v_account_balance_history with (security_invoker = true) as
select le.account_id,
  le.occurred_at,
  le.transaction_id,
  t.code as transaction_code,
  t.type as transaction_type,
  le.direction,
  le.amount,
  le.balance_after,
  a.currency_code
from public.ledger_entries le
join public.transactions t on t.id = le.transaction_id
join public.accounts a on a.id = le.account_id;

-- Out of scope in this version (transfer graph), kept because the hosted project has it.
create view public.v_transfer_edges with (security_invoker = true) as
select t.source_account_id,
  t.destination_account_id,
  sa.customer_id as source_customer_id,
  da.customer_id as destination_customer_id,
  sa.last4 as source_last4,
  da.last4 as destination_last4,
  da.is_external as destination_is_external,
  t.currency_code,
  count(*) as transfers,
  sum(t.amount) as total_amount,
  min(t.occurred_at) as first_at,
  max(t.occurred_at) as last_at,
  count(*) filter (where l.verdict = 'fraud') as fraud_labeled
from public.transactions t
join public.accounts sa on sa.id = t.source_account_id
join public.accounts da on da.id = t.destination_account_id
left join public.labels l on l.transaction_id = t.id
where t.type = 'transfer'
group by t.source_account_id, t.destination_account_id, sa.customer_id, da.customer_id,
  sa.last4, da.last4, da.is_external, t.currency_code;
