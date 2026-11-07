-- Baseline 9/14 · business-rule triggers: internal-only ledger, fraud needs a fraud type,
-- label versioning, transactions.is_labeled, audit trail and new-alert notifications.

create or replace function public.check_ledger_internal_account()
returns trigger
language plpgsql
set search_path to ''
as $$
begin
  if exists (select 1 from public.accounts where id = new.account_id and is_external) then
    raise exception 'ledger_entries solo admite cuentas internas (account_id = %)', new.account_id;
  end if;
  return new;
end;
$$;

create trigger trg_ledger_internal_account
  before insert or update of account_id on public.ledger_entries
  for each row execute function public.check_ledger_internal_account();

-- A fraud label needs at least one fraud type. Deferred, so the label and its types can be
-- written in any order inside one transaction.
create or replace function public.check_label_has_fraud_type()
returns trigger
language plpgsql
set search_path to ''
as $$
declare
  v_label_id uuid;
begin
  if tg_table_name = 'labels' then
    v_label_id := new.id;
  else
    v_label_id := old.label_id;
  end if;

  if exists (select 1 from public.labels l
              where l.id = v_label_id and l.verdict = 'fraud')
     and not exists (select 1 from public.label_fraud_types t where t.label_id = v_label_id) then
    raise exception 'Una etiqueta con veredicto fraud debe tener al menos un tipo de fraude (label %)', v_label_id
      using errcode = '23514';
  end if;
  return null;
end;
$$;

create constraint trigger trg_labels_require_fraud_type
  after insert or update on public.labels
  deferrable initially deferred
  for each row execute function public.check_label_has_fraud_type();

create constraint trigger trg_lft_require_fraud_type
  after delete or update on public.label_fraud_types
  deferrable initially deferred
  for each row execute function public.check_label_has_fraud_type();

-- Last write wins: every save bumps the version and stamps updated_at in the database.
create or replace function public.labels_before_update()
returns trigger
language plpgsql
set search_path to ''
as $$
begin
  new.version    := old.version + 1;
  new.updated_at := now();
  new.created_at := old.created_at;
  return new;
end;
$$;

create trigger trg_labels_version
  before update on public.labels
  for each row execute function public.labels_before_update();

create or replace function public.sync_transaction_is_labeled()
returns trigger
language plpgsql
security definer
set search_path to ''
as $$
begin
  if tg_op in ('UPDATE', 'DELETE') then
    update public.transactions set is_labeled = false
     where id = old.transaction_id
       and (tg_op = 'DELETE' or old.transaction_id <> new.transaction_id);
  end if;
  if tg_op in ('INSERT', 'UPDATE') then
    update public.transactions set is_labeled = true
     where id = new.transaction_id and not is_labeled;
  end if;
  return null;
end;
$$;

create trigger trg_labels_is_labeled
  after insert or delete or update of transaction_id on public.labels
  for each row execute function public.sync_transaction_is_labeled();

create or replace function public.audit_labels()
returns trigger
language plpgsql
security definer
set search_path to ''
as $$
begin
  insert into public.audit_log (analyst_id, action, entity, entity_id, transaction_id, old_value, new_value)
  values (
    coalesce(auth.uid(), new.analyst_id),
    case when tg_op = 'INSERT' then 'create_label'::public.audit_action
         else 'update_label'::public.audit_action end,
    'labels',
    new.id::text,
    new.transaction_id,
    case when tg_op = 'UPDATE' then to_jsonb(old) end,
    to_jsonb(new)
  );
  return null;
end;
$$;

create trigger trg_audit_labels
  after insert or update on public.labels
  for each row execute function public.audit_labels();

create or replace function public.audit_ai_alerts()
returns trigger
language plpgsql
security definer
set search_path to ''
as $$
begin
  if old.status = 'pending' and new.status <> 'pending' then
    insert into public.audit_log (analyst_id, action, entity, entity_id, old_value, new_value)
    values (
      coalesce(auth.uid(), new.resolved_by),
      case new.status
        when 'confirmed'    then 'confirm_alert'::public.audit_action
        when 'rejected'     then 'reject_alert'::public.audit_action
        when 'reclassified' then 'reclassify_alert'::public.audit_action
      end,
      'ai_alerts',
      new.id::text,
      to_jsonb(old),
      to_jsonb(new)
    );
  end if;
  return null;
end;
$$;

create trigger trg_audit_ai_alerts
  after update on public.ai_alerts
  for each row execute function public.audit_ai_alerts();

create or replace function public.notify_new_alert()
returns trigger
language plpgsql
security definer
set search_path to ''
as $$
begin
  insert into public.notifications (analyst_id, type, alert_id, title, body)
  select a.id,
         'alert_new',
         new.id,
         format('Nueva alerta %s · score %s', new.code, new.score),
         new.summary
    from public.analysts a
  on conflict (analyst_id, alert_id) do nothing;
  return null;
end;
$$;

create trigger trg_ai_alerts_notify
  after insert on public.ai_alerts
  for each row execute function public.notify_new_alert();
