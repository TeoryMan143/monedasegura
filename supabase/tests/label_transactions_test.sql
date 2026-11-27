-- label_transactions (HU-04, HU-05) and the label CHECKs behind it: every error key, the
-- count of transactions that already had a label, and the rules the table enforces on its
-- own when a write skips the RPC.
--
-- Runs on the seed (supabase db reset) and rolls back.

begin;
create extension if not exists pgtap with schema extensions;
select plan(26);

-- ---------------------------------------------------------------------------------------
-- Fixtures (as postgres): two labeled and two unlabeled transactions outside any alert
-- ---------------------------------------------------------------------------------------
select set_config('test.analyst_a',
  (select id::text from public.analysts where email = 'demo@monedasegura.test'), true);

create temp table fx_tx on commit drop as
select t.id, t.is_labeled,
       row_number() over (partition by t.is_labeled order by t.id) as n
  from public.transactions t
 where not exists (select 1 from public.ai_alert_transactions aat where aat.transaction_id = t.id)
   and t.id in (
     (select id from public.transactions t2 where t2.is_labeled
        and not exists (select 1 from public.ai_alert_transactions a2 where a2.transaction_id = t2.id)
      order by id limit 2)
     union all
     (select id from public.transactions t3 where not t3.is_labeled
        and not exists (select 1 from public.ai_alert_transactions a3 where a3.transaction_id = t3.id)
      order by id limit 2));

select set_config('test.labeled_1',   (select id::text from fx_tx where is_labeled and n = 1), true);
select set_config('test.labeled_2',   (select id::text from fx_tx where is_labeled and n = 2), true);
select set_config('test.unlabeled',   (select id::text from fx_tx where not is_labeled and n = 1), true);
select set_config('test.unlabeled_2', (select id::text from fx_tx where not is_labeled and n = 2), true);
select set_config('test.type_ato', (select id::text from public.fraud_types where code = 'ATO'), true);
select set_config('test.type_phi', (select id::text from public.fraud_types where code = 'PHI'), true);

-- ---------------------------------------------------------------------------------------
-- Error keys (analyst A)
-- ---------------------------------------------------------------------------------------
select set_config('request.jwt.claims',
  json_build_object('sub', current_setting('test.analyst_a'), 'role', 'authenticated')::text, true);
set local role authenticated;

select throws_ok(
  $$ select public.label_transactions(array[current_setting('test.unlabeled')::bigint], 'fraud', 3,
                                      p_severity => 'high') $$,
  'P0001', 'fraud_type_required', 'fraud without a fraud type: fraud_type_required');

select throws_ok(
  $$ select public.label_transactions(array[current_setting('test.unlabeled')::bigint], 'fraud', 3,
                                      p_fraud_type_ids => null, p_severity => 'high') $$,
  'P0001', 'fraud_type_required', 'fraud with null fraud types: fraud_type_required');

select throws_ok(
  $$ select public.label_transactions(array[current_setting('test.unlabeled')::bigint], 'fraud', 3,
                                      p_fraud_type_ids => array[current_setting('test.type_ato')::int]) $$,
  'P0001', 'severity_required', 'fraud without a severity: severity_required');

select throws_ok(
  $$ select public.label_transactions(array[current_setting('test.unlabeled')::bigint], 'not_fraud', 3,
                                      p_severity => 'low') $$,
  'P0001', 'severity_not_allowed', 'not_fraud with a severity: severity_not_allowed');

select throws_ok(
  $$ select public.label_transactions(array[current_setting('test.unlabeled')::bigint], 'not_fraud', 1) $$,
  'P0001', 'justification_required', 'confidence Baja without a justification: justification_required');

select throws_ok(
  $$ select public.label_transactions(array[current_setting('test.unlabeled')::bigint], 'uncertain', 3) $$,
  'P0001', 'justification_required', 'uncertain without a justification: justification_required');

select throws_ok(
  $$ select public.label_transactions(array[current_setting('test.unlabeled')::bigint], 'uncertain', 3,
                                      p_justification => '   ') $$,
  'P0001', 'justification_required', 'a blank justification does not count');

select throws_ok(
  $$ select public.label_transactions(array[-1]::bigint[], 'not_fraud', 3) $$,
  'P0001', 'transaction_not_found', 'unknown transaction: transaction_not_found');

select throws_ok(
  $$ select public.label_transactions('{}'::bigint[], 'not_fraud', 3) $$,
  'P0001', 'transaction_not_found', 'no transactions: transaction_not_found');

select throws_ok(
  $$ select public.label_transactions(array[current_setting('test.unlabeled')::bigint, -1], 'not_fraud', 3) $$,
  'P0001', 'transaction_not_found', 'one unknown transaction fails the whole batch');

select ok(
  (select not is_labeled from public.transactions where id = current_setting('test.unlabeled')::bigint),
  'failed calls write nothing');

-- ---------------------------------------------------------------------------------------
-- Success: the batch, its count and its fraud types
-- ---------------------------------------------------------------------------------------
select is(
  public.label_transactions(
    array[current_setting('test.labeled_1'), current_setting('test.labeled_2'),
          current_setting('test.unlabeled')]::bigint[],
    'fraud', 3,
    p_fraud_type_ids => array[current_setting('test.type_ato'), current_setting('test.type_phi')]::int[],
    p_severity => 'high'),
  2, 'returns how many transactions already had a label');

select is(
  (select count(*)::int from public.labels
    where transaction_id = any (array[current_setting('test.labeled_1'), current_setting('test.labeled_2'),
                                      current_setting('test.unlabeled')]::bigint[])
      and verdict = 'fraud' and severity = 'high' and confidence = 3
      and source = 'manual' and alert_id is null
      and analyst_id = current_setting('test.analyst_a')::uuid),
  3, 'all three get the same manual label by the caller');

select is(
  (select count(*)::int from public.labels l
    where l.transaction_id = any (array[current_setting('test.labeled_1'), current_setting('test.labeled_2'),
                                        current_setting('test.unlabeled')]::bigint[])
      and (select array_agg(fraud_type_id order by fraud_type_id) from public.label_fraud_types
            where label_id = l.id)
          = (select array_agg(id order by id) from public.fraud_types where code in ('ATO', 'PHI'))),
  3, 'each label has exactly the two fraud types');

select is(
  public.label_transactions(
    array[current_setting('test.unlabeled'), current_setting('test.unlabeled')]::bigint[],
    'not_fraud', 4, p_fraud_type_ids => array[current_setting('test.type_ato')::int]),
  1, 'a repeated id counts once');

select is_empty(
  $$ select 1 from public.label_fraud_types lft join public.labels l on l.id = lft.label_id
      where l.transaction_id = current_setting('test.unlabeled')::bigint $$,
  'not_fraud drops the fraud types, including the ones sent');

select is(
  public.label_transactions(array[current_setting('test.unlabeled')::bigint], 'uncertain', 2,
                            p_justification => '  Revisar con el cliente  '),
  1, 'uncertain with a justification is saved');

select is(
  (select justification from public.labels where transaction_id = current_setting('test.unlabeled')::bigint),
  'Revisar con el cliente', 'the justification is trimmed');

-- ---------------------------------------------------------------------------------------
-- Only analysts
-- ---------------------------------------------------------------------------------------
select set_config('request.jwt.claims',
  json_build_object('sub', gen_random_uuid(), 'role', 'authenticated')::text, true);

select throws_ok(
  $$ select public.label_transactions(array[current_setting('test.unlabeled')::bigint], 'not_fraud', 3) $$,
  '42501', null, 'a signed-in user who is not an analyst cannot label');

-- ---------------------------------------------------------------------------------------
-- The table enforces the rules without the RPC (as postgres, bypassing RLS)
-- ---------------------------------------------------------------------------------------
reset role;
select set_config('request.jwt.claims', '', true);  -- auth.uid() is null again

select throws_ok(
  $$ insert into public.labels (transaction_id, verdict, confidence, severity, analyst_id)
     values (current_setting('test.unlabeled_2')::bigint, 'not_fraud', 3, 'low',
             current_setting('test.analyst_a')::uuid) $$,
  '23514', null, 'CHECK: not_fraud cannot have a severity');

select throws_ok(
  $$ insert into public.labels (transaction_id, verdict, confidence, analyst_id)
     values (current_setting('test.unlabeled_2')::bigint, 'fraud', 3, current_setting('test.analyst_a')::uuid) $$,
  '23514', null, 'CHECK: fraud needs a severity');

select throws_ok(
  $$ insert into public.labels (transaction_id, verdict, confidence, analyst_id)
     values (current_setting('test.unlabeled_2')::bigint, 'uncertain', 3, current_setting('test.analyst_a')::uuid) $$,
  '23514', null, 'CHECK: uncertain needs a justification');

select throws_ok(
  $$ insert into public.labels (transaction_id, verdict, confidence, analyst_id)
     values (current_setting('test.unlabeled_2')::bigint, 'not_fraud', 1, current_setting('test.analyst_a')::uuid) $$,
  '23514', null, 'CHECK: confidence Baja needs a justification');

select throws_ok(
  $$ insert into public.labels (transaction_id, source, verdict, confidence, analyst_id)
     values (current_setting('test.unlabeled_2')::bigint, 'alert', 'not_fraud', 3,
             current_setting('test.analyst_a')::uuid) $$,
  '23514', null, 'CHECK: an alert label needs its alert');

-- The fraud-type rule is a deferred constraint trigger; check it now instead of at commit.
set constraints public.trg_labels_require_fraud_type immediate;

select throws_ok(
  $$ insert into public.labels (transaction_id, verdict, confidence, severity, analyst_id)
     values (current_setting('test.unlabeled_2')::bigint, 'fraud', 3, 'high',
             current_setting('test.analyst_a')::uuid) $$,
  '23514', null, 'trigger: a fraud label needs at least one fraud type');

select lives_ok(
  $$ with l as (
       insert into public.labels (transaction_id, verdict, confidence, severity, analyst_id)
       values (current_setting('test.unlabeled_2')::bigint, 'fraud', 3, 'high',
               current_setting('test.analyst_a')::uuid)
       returning id)
     insert into public.label_fraud_types (label_id, fraud_type_id)
     select id, current_setting('test.type_ato')::smallint from l $$,
  'trigger: a fraud label written with its fraud type passes');

set constraints all deferred;

select * from finish();
rollback;
