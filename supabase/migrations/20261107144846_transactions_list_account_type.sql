-- v_transactions_list: type of the account shown in the A-01 list (HU-02).
-- The «Cliente / cuenta» cell shows it before the digits: «Ah •••• 4417 · CO» (Figma A-01).
--
-- Same view as 20261107131448_transactions_list_customer.sql plus account_type at the
-- end (create or replace view only adds columns at the end). It keeps the grants, and
-- running it twice is harmless.
--
-- - account_type is the type of the same account as account_last4: the account of the
--   customer that customer_id points to.
create or replace view public.v_transactions_list with (security_invoker = true) as
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
  coalesce(al.alert_count, 0::bigint) as alert_count,
  c.first_names || ' ' || c.last_names as customer_name,
  case when sa.customer_id is not null then sa.last4 else da.last4 end as account_last4,
  c.country_code,
  case when sa.customer_id is not null then sa.type else da.type end as account_type
from public.transactions t
left join public.accounts sa on sa.id = t.source_account_id
left join public.accounts da on da.id = t.destination_account_id
left join public.customers c on c.id = coalesce(sa.customer_id, da.customer_id)
left join public.merchants m on m.id = t.merchant_id
left join public.labels l on l.transaction_id = t.id
left join lateral (
  select max(a.score) as max_score, count(*) as alert_count
  from public.ai_alert_transactions aat
  join public.ai_alerts a on a.id = aat.alert_id
  where aat.transaction_id = t.id
) al on true;
