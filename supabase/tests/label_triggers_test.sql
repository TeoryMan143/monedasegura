-- Label triggers (HU-15, HU-16): each save bumps the version and writes audit_log, the
-- database keeps transactions.is_labeled in sync, and a new alert notifies every analyst.
--
-- Runs on the seed (supabase db reset) and rolls back.

begin;
create extension if not exists pgtap with schema extensions;
select plan(13);

-- ---------------------------------------------------------------------------------------
-- Fixtures (as postgres): an unlabeled transaction outside any alert
-- ---------------------------------------------------------------------------------------
select set_config('test.analyst_a',
  (select id::text from public.analysts where email = 'demo@monedasegura.test'), true);
select set_config('test.analyst_b',
  (select id::text from public.analysts where email = 'jonathan.cortes@monedasegura.test'), true);
select set_config('test.tx',
  (select min(t.id)::text from public.transactions t
    where not t.is_labeled
      and not exists (select 1 from public.ai_alert_transactions aat where aat.transaction_id = t.id)), true);

select ok(
  (select not is_labeled from public.transactions where id = current_setting('test.tx')::bigint),
  'precondition: the transaction starts unlabeled');

-- ---------------------------------------------------------------------------------------
-- First save (analyst A)
-- ---------------------------------------------------------------------------------------
select set_config('request.jwt.claims',
  json_build_object('sub', current_setting('test.analyst_a'), 'role', 'authenticated')::text, true);
set local role authenticated;

select public.label_transactions(array[current_setting('test.tx')::bigint], 'not_fraud', 3);

select ok(
  (select is_labeled from public.transactions where id = current_setting('test.tx')::bigint),
  'the first label sets is_labeled');

select is(
  (select version from public.labels where transaction_id = current_setting('test.tx')::bigint),
  1, 'a new label starts at version 1');

select is(
  (select count(*)::int from public.audit_log
    where entity = 'labels' and transaction_id = current_setting('test.tx')::bigint
      and action = 'create_label' and analyst_id = current_setting('test.analyst_a')::uuid
      and old_value is null and new_value ->> 'verdict' = 'not_fraud'),
  1, 'the first save writes a create_label audit row');

-- ---------------------------------------------------------------------------------------
-- Second save by another analyst: last write wins
-- ---------------------------------------------------------------------------------------
select set_config('request.jwt.claims',
  json_build_object('sub', current_setting('test.analyst_b'), 'role', 'authenticated')::text, true);

select public.label_transactions(
  array[current_setting('test.tx')::bigint], 'fraud', 4,
  p_fraud_type_ids => array[(select id from public.fraud_types where code = 'CLO')]::int[],
  p_severity => 'critical');

select is(
  (select version from public.labels where transaction_id = current_setting('test.tx')::bigint),
  2, 'an edit bumps the version');

select is(
  (select analyst_id from public.labels where transaction_id = current_setting('test.tx')::bigint),
  current_setting('test.analyst_b')::uuid, 'the last analyst becomes the author');

select is(
  (select count(*)::int from public.audit_log
    where entity = 'labels' and transaction_id = current_setting('test.tx')::bigint
      and action = 'update_label' and analyst_id = current_setting('test.analyst_b')::uuid
      and old_value ->> 'version' = '1' and old_value ->> 'verdict' = 'not_fraud'
      and new_value ->> 'version' = '2' and new_value ->> 'verdict' = 'fraud'),
  1, 'the edit writes an update_label audit row with the old and new label');

-- A direct update cannot choose the version or the creation date.
update public.labels
   set version = 99, created_at = '2000-01-01', confidence = 3
 where transaction_id = current_setting('test.tx')::bigint;

select is(
  (select version from public.labels where transaction_id = current_setting('test.tx')::bigint),
  3, 'the database sets the version, not the client');

select isnt(
  (select created_at from public.labels where transaction_id = current_setting('test.tx')::bigint),
  '2000-01-01'::timestamptz, 'the client cannot rewrite created_at');

select is(
  (select count(*)::int from public.audit_log
    where entity = 'labels' and transaction_id = current_setting('test.tx')::bigint),
  3, 'one audit row per save');

select is(
  (select count(*)::int from public.transactions
    where id = current_setting('test.tx')::bigint and is_labeled),
  1, 'is_labeled stays set across edits');

-- ---------------------------------------------------------------------------------------
-- Removing the label (only the owner can) clears is_labeled
-- ---------------------------------------------------------------------------------------
reset role;

delete from public.labels where transaction_id = current_setting('test.tx')::bigint;

select ok(
  (select not is_labeled from public.transactions where id = current_setting('test.tx')::bigint),
  'deleting the label clears is_labeled');

-- ---------------------------------------------------------------------------------------
-- A new alert notifies every analyst once
-- ---------------------------------------------------------------------------------------
with a as (
  insert into public.ai_alerts (customer_id, score, suggested_type_id, summary, model_version)
  select c.id, 92, (select id from public.fraud_types where code = 'ATO'), 'Prueba', 'test'
    from public.customers c order by c.id limit 1
  returning id)
select set_config('test.new_alert', (select id::text from a), true);

select is(
  (select count(*)::int from public.notifications
    where alert_id = current_setting('test.new_alert')::uuid and type = 'alert_new'
      and title like 'Nueva alerta % · score 92'),
  (select count(*)::int from public.analysts),
  'a new alert creates one alert_new notification per analyst');

select * from finish();
rollback;
