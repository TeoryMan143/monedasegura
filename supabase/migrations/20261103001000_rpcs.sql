-- Baseline 10/14 · RPCs: severity from amount, bulk labeling (HU-05), alert resolution (HU-08)
-- and global search (HU-14).

create or replace function public.severity_for_amount(p_amount numeric, p_currency character)
returns public.severity
language sql
stable
set search_path to ''
as $$
  select coalesce(
    (select st.level
       from public.severity_thresholds st
       join public.severity_levels sl on sl.level = st.level
      where st.currency_code = p_currency
        and st.min_amount   <= p_amount
      order by sl.sort_order desc
      limit 1),
    'low'::public.severity);
$$;

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
  v_uid         uuid := auth.uid();
  v_overwritten integer;
  v_label_ids   uuid[];
begin
  if v_uid is null or not public.is_analyst() then
    raise exception 'Solo los analistas pueden etiquetar' using errcode = '42501';
  end if;
  if p_verdict = 'fraud' and coalesce(cardinality(p_fraud_type_ids), 0) = 0 then
    raise exception 'El veredicto fraud requiere al menos un tipo de fraude' using errcode = '22023';
  end if;

  with up as (
    insert into public.labels as l
      (transaction_id, source, alert_id, verdict, confidence, severity, justification, analyst_id)
    select t.id,
           'manual',
           null,
           p_verdict,
           p_confidence::smallint,
           case p_verdict
             when 'fraud'     then coalesce(p_severity, public.severity_for_amount(t.amount, t.currency_code))
             when 'uncertain' then p_severity
             else null
           end,
           p_justification,
           v_uid
      from public.transactions t
     where t.id = any (p_transaction_ids)
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

-- First analyst wins: locks the alert and fails if it is no longer pending.
create or replace function public.resolve_alert(
  p_alert_id uuid,
  p_action public.alert_status,
  p_final_type_id integer default null::integer,
  p_confidence integer default 3,
  p_justification text default null::text)
returns public.ai_alerts
language plpgsql
security definer
set search_path to ''
as $$
declare
  v_uid      uuid := auth.uid();
  v_alert    public.ai_alerts;
  v_final    smallint;
  v_verdict  public.verdict;
  v_label_id uuid;
  r          record;
begin
  if v_uid is null or not public.is_analyst() then
    raise exception 'Solo los analistas pueden resolver alertas' using errcode = '42501';
  end if;

  select * into v_alert from public.ai_alerts where id = p_alert_id for update;
  if not found then
    raise exception 'Alerta % no encontrada', p_alert_id using errcode = 'P0002';
  end if;
  if v_alert.status <> 'pending' then
    raise exception 'La alerta % ya fue resuelta (%)', v_alert.code, v_alert.status using errcode = 'P0001';
  end if;

  case p_action
    when 'confirmed' then
      v_final := v_alert.suggested_type_id;  v_verdict := 'fraud';
    when 'rejected' then
      v_final := null;                       v_verdict := 'not_fraud';
    when 'reclassified' then
      if p_final_type_id is null or p_final_type_id = v_alert.suggested_type_id then
        raise exception 'Reclasificar requiere un tipo distinto al sugerido' using errcode = '22023';
      end if;
      v_final := p_final_type_id::smallint;  v_verdict := 'fraud';
    else
      raise exception 'Acción inválida: %', p_action using errcode = '22023';
  end case;

  update public.ai_alerts
     set status = p_action, resolved_by = v_uid, resolved_at = now(), final_type_id = v_final
   where id = p_alert_id
  returning * into v_alert;

  for r in
    select t.id, t.amount, t.currency_code
      from public.ai_alert_transactions aat
      join public.transactions t on t.id = aat.transaction_id
     where aat.alert_id = p_alert_id
  loop
    insert into public.labels as l
      (transaction_id, source, alert_id, verdict, confidence, severity, justification, analyst_id)
    values (
      r.id, 'alert', p_alert_id, v_verdict, p_confidence::smallint,
      case when v_verdict = 'fraud' then public.severity_for_amount(r.amount, r.currency_code) end,
      p_justification, v_uid
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

create or replace function public.global_search(q text, max_results integer default 20)
returns table (kind text, ref_id text, title text, subtitle text, score real)
language sql
stable
set search_path to 'public', 'extensions'
as $$
  (select 'customer'::text,
          c.id::text,
          c.first_names || ' ' || c.last_names,
          c.document_type::text || ' ' || c.document_number,
          greatest(ts_rank(c.search_vector, websearch_to_tsquery('simple', q)),
                   similarity(c.first_names || ' ' || c.last_names, q))::real
     from customers c
    where c.search_vector @@ websearch_to_tsquery('simple', q)
       or (c.first_names || ' ' || c.last_names) % q
       or c.document_number = q
    order by 5 desc
    limit max_results)
  union all
  (select 'account'::text,
          a.id::text,
          '•••• ' || a.last4,
          a.type::text || ' · ' || a.currency_code || coalesce(' · ' || a.holder_name, ''),
          1.0::real
     from accounts a
    where q ~ '^[0-9]{4,}$' and a.last4 = right(q, 4)
    limit max_results)
  union all
  (select 'transaction'::text,
          t.id::text,
          t.code,
          t.amount::text || ' ' || t.currency_code || ' · ' || t.type::text,
          1.0::real
     from transactions t
    where t.code like upper(q) || '%'
    order by t.id desc
    limit max_results);
$$;
