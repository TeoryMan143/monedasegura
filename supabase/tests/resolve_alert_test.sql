-- resolve_alert (HU-08): confirm, reject and reclassify; excluded transactions keep their
-- label; the second analyst gets alert_already_resolved; every error key.
--
-- Runs on the seed (supabase db reset) and rolls back. Fixtures are kept in `test.*`
-- settings so they stay readable after switching to the authenticated role.

begin;
create extension if not exists pgtap with schema extensions;
select plan(27);

-- ---------------------------------------------------------------------------------------
-- Fixtures (as postgres)
-- ---------------------------------------------------------------------------------------
select set_config('test.analyst_a',
  (select id::text from public.analysts where email = 'demo@monedasegura.test'), true);
select set_config('test.analyst_b',
  (select id::text from public.analysts where email = 'jonathan.cortes@monedasegura.test'), true);

-- Three pending alerts with 2+ transactions that belong to no other alert, so each action's
-- labels can be checked on their own.
create temp table fx_alerts on commit drop as
select a.id, a.suggested_type_id, row_number() over (order by a.code) as n
  from public.ai_alerts a
  join public.ai_alert_transactions aat on aat.alert_id = a.id
 where a.status = 'pending'
 group by a.id, a.code, a.suggested_type_id
having count(*) >= 2
   and bool_and(not exists (select 1 from public.ai_alert_transactions o
                             where o.transaction_id = aat.transaction_id
                               and o.alert_id <> a.id))
 order by a.code
 limit 3;

select set_config('test.alert_confirm',  (select id::text from fx_alerts where n = 1), true);
select set_config('test.alert_reject',   (select id::text from fx_alerts where n = 2), true);
select set_config('test.alert_reclass',  (select id::text from fx_alerts where n = 3), true);

-- The transaction the analyst unchecks in each of the first two alerts.
select set_config('test.excluded_confirm',
  (select max(transaction_id)::text from public.ai_alert_transactions
    where alert_id = current_setting('test.alert_confirm')::uuid), true);
select set_config('test.excluded_reject',
  (select max(transaction_id)::text from public.ai_alert_transactions
    where alert_id = current_setting('test.alert_reject')::uuid), true);

-- The excluded transaction of the rejected alert starts without a label.
delete from public.labels where transaction_id = current_setting('test.excluded_reject')::bigint;

-- A fraud type other than the one the reclassified alert suggests.
select set_config('test.other_type',
  (select min(ft.id)::text from public.fraud_types ft
    where ft.id <> (select suggested_type_id from fx_alerts where n = 3)), true);

-- ---------------------------------------------------------------------------------------
-- Analyst A: error keys first, nothing changes
-- ---------------------------------------------------------------------------------------
select set_config('request.jwt.claims',
  json_build_object('sub', current_setting('test.analyst_a'), 'role', 'authenticated')::text, true);
set local role authenticated;

select throws_ok(
  $$ select public.resolve_alert(current_setting('test.alert_confirm')::uuid, 'pending', 3) $$,
  'P0001', 'invalid_action', 'pending is not an action: invalid_action');

select throws_ok(
  $$ select public.resolve_alert(gen_random_uuid(), 'confirmed', 3) $$,
  'P0001', 'alert_not_found', 'unknown alert: alert_not_found');

select throws_ok(
  $$ select public.resolve_alert(current_setting('test.alert_confirm')::uuid, 'confirmed', 1,
                                 p_justification => '   ') $$,
  'P0001', 'justification_required', 'confidence Baja without a justification: justification_required');

select throws_ok(
  $$ select public.resolve_alert(current_setting('test.alert_reject')::uuid, 'rejected', 3,
                                 p_severity => 'high') $$,
  'P0001', 'severity_not_allowed', 'rejecting with a severity: severity_not_allowed');

select throws_ok(
  $$ select public.resolve_alert(current_setting('test.alert_reclass')::uuid, 'reclassified', 3,
                                 p_final_type_id => (select suggested_type_id from public.ai_alerts
                                                      where id = current_setting('test.alert_reclass')::uuid)) $$,
  'P0001', 'final_type_must_differ', 'reclassifying with the suggested type: final_type_must_differ');

select throws_ok(
  $$ select public.resolve_alert(current_setting('test.alert_reclass')::uuid, 'reclassified', 3) $$,
  'P0001', 'fraud_type_required', 'reclassifying without a type: fraud_type_required');

select is(
  (select count(*)::int from public.ai_alerts
    where id = any (array[current_setting('test.alert_confirm'), current_setting('test.alert_reject'),
                          current_setting('test.alert_reclass')]::uuid[])
      and status = 'pending'),
  3, 'failed calls leave the alerts pending');

-- ---------------------------------------------------------------------------------------
-- Confirm, with one transaction excluded that already has a manual label
-- ---------------------------------------------------------------------------------------
select public.label_transactions(array[current_setting('test.excluded_confirm')::bigint], 'not_fraud', 3);
select set_config('test.excluded_version',
  (select version::text from public.labels
    where transaction_id = current_setting('test.excluded_confirm')::bigint), true);

select lives_ok(
  $$ select public.resolve_alert(current_setting('test.alert_confirm')::uuid, 'confirmed', 3,
                                 p_severity => 'high',
                                 p_excluded_transaction_ids => array[current_setting('test.excluded_confirm')::bigint]) $$,
  'analyst A confirms the alert');

select ok(
  (select status = 'confirmed' and final_type_id = suggested_type_id
          and resolved_by = current_setting('test.analyst_a')::uuid and resolved_at is not null
     from public.ai_alerts where id = current_setting('test.alert_confirm')::uuid),
  'confirm: status, resolver and final type = suggested type');

select is(
  (select count(*)::int from public.labels
    where alert_id = current_setting('test.alert_confirm')::uuid
      and source = 'alert' and verdict = 'fraud' and severity = 'high' and confidence = 3
      and analyst_id = current_setting('test.analyst_a')::uuid),
  (select count(*)::int - 1 from public.ai_alert_transactions
    where alert_id = current_setting('test.alert_confirm')::uuid),
  'confirm: every transaction but the excluded one gets a fraud label from the alert');

select is(
  (select count(*)::int from public.labels l
    where l.alert_id = current_setting('test.alert_confirm')::uuid
      and (select array_agg(fraud_type_id) from public.label_fraud_types where label_id = l.id)
          = array[(select suggested_type_id from public.ai_alerts
                    where id = current_setting('test.alert_confirm')::uuid)]),
  (select count(*)::int - 1 from public.ai_alert_transactions
    where alert_id = current_setting('test.alert_confirm')::uuid),
  'confirm: each label has exactly the suggested fraud type');

select ok(
  (select source = 'manual' and alert_id is null and verdict = 'not_fraud'
          and version = current_setting('test.excluded_version')::int
     from public.labels where transaction_id = current_setting('test.excluded_confirm')::bigint),
  'confirm: the excluded transaction keeps its label untouched');

select is(
  (select count(*)::int from public.audit_log
    where entity = 'ai_alerts' and entity_id = current_setting('test.alert_confirm')
      and action = 'confirm_alert' and analyst_id = current_setting('test.analyst_a')::uuid
      and old_value ->> 'status' = 'pending' and new_value ->> 'status' = 'confirmed'),
  1, 'confirm: one confirm_alert audit row');

-- ---------------------------------------------------------------------------------------
-- Analyst B arrives second
-- ---------------------------------------------------------------------------------------
select set_config('request.jwt.claims',
  json_build_object('sub', current_setting('test.analyst_b'), 'role', 'authenticated')::text, true);

select throws_ok(
  $$ select public.resolve_alert(current_setting('test.alert_confirm')::uuid, 'rejected', 3) $$,
  'P0001', 'alert_already_resolved', 'the second analyst gets alert_already_resolved');

select ok(
  (select status = 'confirmed' and resolved_by = current_setting('test.analyst_a')::uuid
     from public.ai_alerts where id = current_setting('test.alert_confirm')::uuid),
  'the first resolution stands');

-- ---------------------------------------------------------------------------------------
-- Reject (analyst B), with an unlabeled transaction excluded
-- ---------------------------------------------------------------------------------------
select lives_ok(
  $$ select public.resolve_alert(current_setting('test.alert_reject')::uuid, 'rejected', 4,
                                 p_excluded_transaction_ids => array[current_setting('test.excluded_reject')::bigint]) $$,
  'analyst B rejects the alert');

select ok(
  (select status = 'rejected' and final_type_id is null
          and resolved_by = current_setting('test.analyst_b')::uuid
     from public.ai_alerts where id = current_setting('test.alert_reject')::uuid),
  'reject: status, resolver and no final type');

select is(
  (select count(*)::int from public.labels
    where alert_id = current_setting('test.alert_reject')::uuid
      and source = 'alert' and verdict = 'not_fraud' and severity is null and confidence = 4
      and analyst_id = current_setting('test.analyst_b')::uuid),
  (select count(*)::int - 1 from public.ai_alert_transactions
    where alert_id = current_setting('test.alert_reject')::uuid),
  'reject: every transaction but the excluded one gets a not_fraud label');

select is_empty(
  $$ select 1 from public.label_fraud_types lft
       join public.labels l on l.id = lft.label_id
      where l.alert_id = current_setting('test.alert_reject')::uuid $$,
  'reject: the labels have no fraud types');

select ok(
  (select not t.is_labeled
          and not exists (select 1 from public.labels l where l.transaction_id = t.id)
     from public.transactions t where t.id = current_setting('test.excluded_reject')::bigint),
  'reject: the excluded transaction stays unlabeled');

select is(
  (select count(*)::int from public.audit_log
    where entity = 'ai_alerts' and entity_id = current_setting('test.alert_reject')
      and action = 'reject_alert' and analyst_id = current_setting('test.analyst_b')::uuid),
  1, 'reject: one reject_alert audit row');

-- ---------------------------------------------------------------------------------------
-- Reclassify (analyst A), no severity: it falls back to severity_for_amount
-- ---------------------------------------------------------------------------------------
select set_config('request.jwt.claims',
  json_build_object('sub', current_setting('test.analyst_a'), 'role', 'authenticated')::text, true);

select lives_ok(
  $$ select public.resolve_alert(current_setting('test.alert_reclass')::uuid, 'reclassified', 2,
                                 p_final_type_id => current_setting('test.other_type')::int) $$,
  'analyst A reclassifies the alert');

select ok(
  (select status = 'reclassified' and final_type_id = current_setting('test.other_type')::smallint
     from public.ai_alerts where id = current_setting('test.alert_reclass')::uuid),
  'reclassify: status and the new final type');

select is(
  (select count(*)::int from public.labels l
    where l.alert_id = current_setting('test.alert_reclass')::uuid
      and l.verdict = 'fraud' and l.severity is not null
      and (select array_agg(fraud_type_id) from public.label_fraud_types where label_id = l.id)
          = array[current_setting('test.other_type')::smallint]),
  (select count(*)::int from public.ai_alert_transactions
    where alert_id = current_setting('test.alert_reclass')::uuid),
  'reclassify: every transaction gets a fraud label with the new type and a severity');

select is(
  (select count(*)::int from public.audit_log
    where entity = 'ai_alerts' and entity_id = current_setting('test.alert_reclass')
      and action = 'reclassify_alert'),
  1, 'reclassify: one reclassify_alert audit row');

-- ---------------------------------------------------------------------------------------
-- Only analysts
-- ---------------------------------------------------------------------------------------
select set_config('request.jwt.claims',
  json_build_object('sub', gen_random_uuid(), 'role', 'authenticated')::text, true);

select throws_ok(
  $$ select public.resolve_alert((select id from public.ai_alerts where status = 'pending' limit 1),
                                 'rejected', 3) $$,
  '42501', null, 'a signed-in user who is not an analyst cannot resolve');

set local role anon;

select throws_ok(
  $$ select public.resolve_alert(gen_random_uuid(), 'rejected', 3) $$,
  '42501', null, 'anon cannot call resolve_alert');

select * from finish();
rollback;
