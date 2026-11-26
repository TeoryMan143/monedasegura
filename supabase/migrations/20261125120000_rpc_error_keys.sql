-- resolve_alert takes what the A-06 dialog sends (severity, confidence, unchecked
-- transactions), and both labeling RPCs raise stable error keys instead of Spanish text
-- (HU-04, HU-05, HU-08).
--
-- Error keys: `raise exception '<key>' using errcode = 'P0001'`, the message is the key
-- itself. core/errors/failure_mapper.dart turns them into Failure.conflict / notFound /
-- validation. A caller that is not an analyst still gets 42501 (Failure.forbidden).

-- ---------------------------------------------------------------------------------------
-- label_transactions (HU-04, HU-05). Same signature and return value as before: how many of
-- the transactions already had a label.
--
-- Keys: transaction_not_found, fraud_type_required, severity_required,
-- severity_not_allowed, justification_required.
--
-- A fraud verdict now needs a severity: the old fallback to severity_for_amount is gone,
-- the form always sends one. Fraud types sent with not_fraud or uncertain are ignored.
-- ---------------------------------------------------------------------------------------
create or replace function public.label_transactions(
  p_transaction_ids bigint[],
  p_verdict public.verdict,
  p_confidence integer,
  p_fraud_type_ids integer[] default '{}'::integer[],
  p_severity public.severity default null::public.severity,
  p_justification text default null::text)
returns integer
language plpgsql
set search_path to ''
as $$
declare
  v_uid           uuid := auth.uid();
  v_justification text := nullif(btrim(p_justification), '');
  v_ids           bigint[];
  v_overwritten   integer;
  v_label_ids     uuid[];
begin
  if v_uid is null or not public.is_analyst() then
    raise exception 'Solo los analistas pueden etiquetar' using errcode = '42501';
  end if;

  select coalesce(array_agg(distinct id), '{}') into v_ids
    from unnest(p_transaction_ids) as t(id)
   where id is not null;
  if cardinality(v_ids) = 0
     or (select count(*) from public.transactions where id = any (v_ids)) <> cardinality(v_ids) then
    raise exception 'transaction_not_found' using errcode = 'P0001';
  end if;

  if p_verdict = 'fraud' and coalesce(cardinality(p_fraud_type_ids), 0) = 0 then
    raise exception 'fraud_type_required' using errcode = 'P0001';
  end if;
  if p_verdict = 'fraud' and p_severity is null then
    raise exception 'severity_required' using errcode = 'P0001';
  end if;
  if p_verdict = 'not_fraud' and p_severity is not null then
    raise exception 'severity_not_allowed' using errcode = 'P0001';
  end if;
  if (p_verdict = 'uncertain' or p_confidence = 1) and v_justification is null then
    raise exception 'justification_required' using errcode = 'P0001';
  end if;

  with up as (
    insert into public.labels as l
      (transaction_id, source, alert_id, verdict, confidence, severity, justification, analyst_id)
    select t.id, 'manual', null, p_verdict, p_confidence::smallint, p_severity,
           v_justification, v_uid
      from public.transactions t
     where t.id = any (v_ids)
    on conflict (transaction_id) do update
      set source        = excluded.source,
          alert_id      = null,
          verdict       = excluded.verdict,
          confidence    = excluded.confidence,
          severity      = excluded.severity,
          justification = excluded.justification,
          analyst_id    = excluded.analyst_id
    returning l.id, (l.xmax <> 0) as was_update
  )
  select count(*) filter (where was_update), array_agg(id)
    into v_overwritten, v_label_ids
    from up;

  delete from public.label_fraud_types where label_id = any (v_label_ids);

  if p_verdict = 'fraud' then
    insert into public.label_fraud_types (label_id, fraud_type_id)
    select l.id, f.id::smallint
      from unnest(v_label_ids) as l(id)
      cross join (select distinct unnest(p_fraud_type_ids) as id) f;
  end if;

  return coalesce(v_overwritten, 0);
end;
$$;

-- ---------------------------------------------------------------------------------------
-- resolve_alert (HU-08). New signature; the old one is dropped so only one remains.
--
-- - p_confidence has no default: the label always gets the confidence the dialog sends,
--   whatever the action (it used to fall back to 3).
-- - p_severity: required to be null when rejecting; when confirming or reclassifying, a
--   null severity falls back to severity_for_amount of each transaction.
-- - p_excluded_transaction_ids: transactions of the alert the analyst unchecked. They keep
--   their current label (or stay unlabeled). Ids that are not in the alert are ignored.
--
-- Keys: alert_not_found, alert_already_resolved, invalid_action, fraud_type_required
-- (reclassify without a type), final_type_must_differ, severity_not_allowed,
-- justification_required (confidence 1 without a justification).
-- ---------------------------------------------------------------------------------------
drop function public.resolve_alert(uuid, public.alert_status, integer, integer, text);

create function public.resolve_alert(
  p_alert_id uuid,
  p_action public.alert_status,
  p_confidence integer,
  p_final_type_id integer default null::integer,
  p_severity public.severity default null::public.severity,
  p_justification text default null::text,
  p_excluded_transaction_ids bigint[] default '{}'::bigint[])
returns public.ai_alerts
language plpgsql
security definer
set search_path to ''
as $$
declare
  v_uid           uuid := auth.uid();
  v_justification text := nullif(btrim(p_justification), '');
  v_alert         public.ai_alerts;
  v_final         smallint;
  v_verdict       public.verdict;
  v_label_id      uuid;
  r               record;
begin
  if v_uid is null or not public.is_analyst() then
    raise exception 'Solo los analistas pueden resolver alertas' using errcode = '42501';
  end if;

  -- First analyst wins: lock the alert, then check it is still pending.
  select * into v_alert from public.ai_alerts where id = p_alert_id for update;
  if not found then
    raise exception 'alert_not_found' using errcode = 'P0001';
  end if;
  if v_alert.status <> 'pending' then
    raise exception 'alert_already_resolved' using errcode = 'P0001';
  end if;

  case p_action
    when 'confirmed' then
      v_final := v_alert.suggested_type_id;  v_verdict := 'fraud';
    when 'rejected' then
      v_final := null;                       v_verdict := 'not_fraud';
    when 'reclassified' then
      if p_final_type_id is null then
        raise exception 'fraud_type_required' using errcode = 'P0001';
      end if;
      if p_final_type_id = v_alert.suggested_type_id then
        raise exception 'final_type_must_differ' using errcode = 'P0001';
      end if;
      v_final := p_final_type_id::smallint;  v_verdict := 'fraud';
    else
      raise exception 'invalid_action' using errcode = 'P0001';
  end case;

  if v_verdict = 'not_fraud' and p_severity is not null then
    raise exception 'severity_not_allowed' using errcode = 'P0001';
  end if;
  if p_confidence = 1 and v_justification is null then
    raise exception 'justification_required' using errcode = 'P0001';
  end if;

  update public.ai_alerts
     set status = p_action, resolved_by = v_uid, resolved_at = now(), final_type_id = v_final
   where id = p_alert_id
  returning * into v_alert;

  for r in
    select t.id, t.amount, t.currency_code
      from public.ai_alert_transactions aat
      join public.transactions t on t.id = aat.transaction_id
     where aat.alert_id = p_alert_id
       and t.id <> all (array_remove(coalesce(p_excluded_transaction_ids, '{}'), null))
  loop
    insert into public.labels as l
      (transaction_id, source, alert_id, verdict, confidence, severity, justification, analyst_id)
    values (
      r.id, 'alert', p_alert_id, v_verdict, p_confidence::smallint,
      case when v_verdict = 'fraud'
           then coalesce(p_severity, public.severity_for_amount(r.amount, r.currency_code)) end,
      v_justification, v_uid
    )
    on conflict (transaction_id) do update
      set source        = excluded.source,
          alert_id      = excluded.alert_id,
          verdict       = excluded.verdict,
          confidence    = excluded.confidence,
          severity      = excluded.severity,
          justification = excluded.justification,
          analyst_id    = excluded.analyst_id
    returning l.id into v_label_id;

    delete from public.label_fraud_types where label_id = v_label_id;
    if v_verdict = 'fraud' then
      insert into public.label_fraud_types (label_id, fraud_type_id) values (v_label_id, v_final);
    end if;
  end loop;

  return v_alert;
end;
$$;

-- Only analysts call it (20261103001200_rls_and_grants.sql named the old signature).
revoke execute on function public.resolve_alert(
  uuid, public.alert_status, integer, integer, public.severity, text, bigint[]) from public, anon;
grant execute on function public.resolve_alert(
  uuid, public.alert_status, integer, integer, public.severity, text, bigint[]) to authenticated;
