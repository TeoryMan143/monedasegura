-- The customer's local time of each transaction, for «Horario inusual» on the timeline
-- (HU-10).
--
-- A purchase at 02:45 in Bogotá is unusual; the same instant seen from another time zone
-- is not. The analysts decided that unusual hours are judged on the customer's clock, so
-- each country gets its IANA time zone and Postgres does the conversion, daylight saving
-- included (Chile).
--
-- - countries.time_zone: an IANA name. The same zones the seed generates the data with
--   (seed.k_country).
-- - v_transactions_list.customer_local_at: occurred_at on the clock of the customer's
--   country, a timestamp without time zone. Same view as
--   20261108002134_transactions_list_location.sql plus this column at the end (create or
--   replace view only adds columns at the end). It keeps the grants.
--
-- Running it twice is harmless.
alter table public.countries add column if not exists time_zone text;

update public.countries set time_zone = v.time_zone
from (values
  ('CO', 'America/Bogota'),
  ('MX', 'America/Mexico_City'),
  ('PE', 'America/Lima'),
  ('CL', 'America/Santiago'),
  ('AR', 'America/Argentina/Buenos_Aires'),
  ('BR', 'America/Sao_Paulo')
) v(code, time_zone)
where countries.code = v.code and countries.time_zone is distinct from v.time_zone;

alter table public.countries alter column time_zone set not null;

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
  case when sa.customer_id is not null then sa.type else da.type end as account_type,
  t.latitude,
  t.longitude,
  ci.name as city_name,
  t.occurred_at at time zone co.time_zone as customer_local_at
from public.transactions t
left join public.accounts sa on sa.id = t.source_account_id
left join public.accounts da on da.id = t.destination_account_id
left join public.customers c on c.id = coalesce(sa.customer_id, da.customer_id)
left join public.countries co on co.code = c.country_code
left join public.merchants m on m.id = t.merchant_id
left join public.cities ci on ci.id = t.city_id
left join public.labels l on l.transaction_id = t.id
left join lateral (
  select max(a.score) as max_score, count(*) as alert_count
  from public.ai_alert_transactions aat
  join public.ai_alerts a on a.id = aat.alert_id
  where aat.transaction_id = t.id
) al on true;
