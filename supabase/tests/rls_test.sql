-- RLS and grants (cross-cutting): analysts read everything but cannot write audit_log,
-- ai_alerts or catalogs directly, cannot write labels as someone else, and only see their
-- own notifications. anon gets nothing.
--
-- Runs on the seed (supabase db reset) and rolls back.

begin;
create extension if not exists pgtap with schema extensions;
select plan(21);

-- ---------------------------------------------------------------------------------------
-- Fixtures (as postgres)
-- ---------------------------------------------------------------------------------------
select set_config('test.analyst_a',
  (select id::text from public.analysts where email = 'demo@monedasegura.test'), true);
select set_config('test.analyst_b',
  (select id::text from public.analysts where email = 'jonathan.cortes@monedasegura.test'), true);
select set_config('test.alert',
  (select id::text from public.ai_alerts where status = 'pending' order by code limit 1), true);
select set_config('test.audit_id', (select min(id)::text from public.audit_log), true);
select set_config('test.free_tx',
  (select min(t.id)::text from public.transactions t where not t.is_labeled), true);
select set_config('test.labeled_tx',
  (select min(t.id)::text from public.transactions t
    where t.is_labeled
      and not exists (select 1 from public.ai_alert_transactions aat where aat.transaction_id = t.id)), true);

-- Analyst B owns the manual label of labeled_tx.
select set_config('request.jwt.claims',
  json_build_object('sub', current_setting('test.analyst_b'), 'role', 'authenticated')::text, true);
set local role authenticated;
select public.label_transactions(array[current_setting('test.labeled_tx')::bigint], 'not_fraud', 3);

-- ---------------------------------------------------------------------------------------
-- Analyst A
-- ---------------------------------------------------------------------------------------
select set_config('request.jwt.claims',
  json_build_object('sub', current_setting('test.analyst_a'), 'role', 'authenticated')::text, true);

-- audit_log: read only
select isnt_empty($$ select 1 from public.audit_log limit 1 $$, 'an analyst can read audit_log');

select throws_ok(
  $$ insert into public.audit_log (analyst_id, action, entity, entity_id)
     values (auth.uid(), 'create_label', 'labels', 'x') $$,
  '42501', null, 'an analyst cannot insert into audit_log');

select throws_ok(
  $$ update public.audit_log set action = 'update_label' where id = current_setting('test.audit_id')::bigint $$,
  '42501', null, 'an analyst cannot update audit_log');

select throws_ok(
  $$ delete from public.audit_log where id = current_setting('test.audit_id')::bigint $$,
  '42501', null, 'an analyst cannot delete from audit_log');

select throws_ok(
  $$ truncate public.audit_log $$,
  '42501', null, 'an analyst cannot truncate audit_log');

-- ai_alerts: read only, resolve_alert is the only way to change them
select isnt_empty($$ select 1 from public.ai_alerts limit 1 $$, 'an analyst can read ai_alerts');

select throws_ok(
  $$ update public.ai_alerts
        set status = 'rejected', resolved_by = auth.uid(), resolved_at = now()
      where id = current_setting('test.alert')::uuid $$,
  '42501', null, 'an analyst cannot update ai_alerts directly');

select throws_ok(
  $$ insert into public.ai_alerts (customer_id, score, suggested_type_id, summary, model_version)
     select customer_id, 50, suggested_type_id, 'x', 'x'
       from public.ai_alerts where id = current_setting('test.alert')::uuid $$,
  '42501', null, 'an analyst cannot insert ai_alerts');

select throws_ok(
  $$ delete from public.ai_alerts where id = current_setting('test.alert')::uuid $$,
  '42501', null, 'an analyst cannot delete ai_alerts');

select is(
  (select status from public.ai_alerts where id = current_setting('test.alert')::uuid),
  'pending'::public.alert_status, 'the alert is still pending');

-- catalogs: read only
select throws_ok(
  $$ insert into public.fraud_types (code, name, description, color)
     values ('XXX', 'x', 'x', '#000000') $$,
  '42501', null, 'an analyst cannot add fraud types');

-- labels: only manual labels, only as yourself, never deleted
select throws_ok(
  $$ insert into public.labels (transaction_id, verdict, confidence, analyst_id)
     values (current_setting('test.free_tx')::bigint, 'not_fraud', 3, current_setting('test.analyst_b')::uuid) $$,
  '42501', null, 'an analyst cannot write a label as another analyst');

select throws_ok(
  $$ insert into public.labels (transaction_id, source, alert_id, verdict, confidence)
     values (current_setting('test.free_tx')::bigint, 'alert', current_setting('test.alert')::uuid,
             'not_fraud', 3) $$,
  '42501', null, 'an analyst cannot write an alert label directly');

select throws_ok(
  $$ update public.labels set verdict = 'uncertain', justification = 'x'
      where transaction_id = current_setting('test.labeled_tx')::bigint $$,
  '42501', null, 'an edit cannot keep another analyst as the author');

select throws_ok(
  $$ delete from public.labels where transaction_id = current_setting('test.labeled_tx')::bigint $$,
  '42501', null, 'an analyst cannot delete labels');

select throws_ok(
  $$ insert into public.label_fraud_types (label_id, fraud_type_id)
     select id, (select id from public.fraud_types where code = 'ATO')
       from public.labels where transaction_id = current_setting('test.labeled_tx')::bigint $$,
  '42501', null, 'an analyst cannot add fraud types to another analyst''s label');

-- notifications: own rows only, read_at only
select is(
  (select count(*)::int from public.notifications where analyst_id = current_setting('test.analyst_b')::uuid),
  0, 'an analyst cannot see another analyst''s notifications');

select throws_ok(
  $$ update public.notifications set title = 'x' where analyst_id = auth.uid() $$,
  '42501', null, 'an analyst can only change read_at on notifications');

select lives_ok(
  $$ update public.notifications set read_at = now()
      where analyst_id = auth.uid() and alert_id = current_setting('test.alert')::uuid $$,
  'an analyst can mark their notification as read');

-- ---------------------------------------------------------------------------------------
-- anon
-- ---------------------------------------------------------------------------------------
set local role anon;

select throws_ok($$ select 1 from public.ai_alerts limit 1 $$, '42501', null, 'anon cannot read ai_alerts');

select throws_ok(
  $$ select public.label_transactions(array[1]::bigint[], 'not_fraud', 3) $$,
  '42501', null, 'anon cannot call label_transactions');

select * from finish();
rollback;
