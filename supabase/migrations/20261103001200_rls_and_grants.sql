-- Baseline 12/14 · RLS and grants. anon gets nothing; analysts read everything; writes go
-- through the RPCs (direct label policies exist but the app uses the RPCs).

-- Every analyst can read the shared data.
do $$
declare
  t text;
begin
  foreach t in array array[
    'currencies', 'countries', 'cities', 'banks', 'channels', 'merchant_categories',
    'fraud_types', 'confidence_levels', 'severity_levels', 'severity_thresholds',
    'analysts', 'customers', 'accounts', 'cards', 'devices', 'customer_devices',
    'security_events', 'merchants', 'transactions', 'ledger_entries', 'disputes',
    'ai_alerts', 'ai_alert_transactions', 'ai_alert_reasons', 'labels', 'label_fraud_types',
    'audit_log']
  loop
    execute format('alter table public.%I enable row level security', t);
    execute format(
      'create policy %I on public.%I for select to authenticated using ((select public.is_analyst()))',
      'analysts_read_' || t, t);
  end loop;
end;
$$;

-- Analysts: each one can update their own row (name, last seen).
create policy analysts_update_self on public.analysts
  for update to authenticated
  using (id = (select auth.uid()))
  with check (id = (select auth.uid()));

-- Labels: direct writes only as yourself and only manual labels.
create policy labels_insert on public.labels
  for insert to authenticated
  with check ((select public.is_analyst()) and analyst_id = (select auth.uid())
              and source = 'manual' and alert_id is null);

create policy labels_update on public.labels
  for update to authenticated
  using ((select public.is_analyst()))
  with check (analyst_id = (select auth.uid()) and source = 'manual' and alert_id is null);

create policy lft_insert on public.label_fraud_types
  for insert to authenticated
  with check ((select public.is_analyst()));

create policy lft_delete on public.label_fraud_types
  for delete to authenticated
  using ((select public.is_analyst()));

-- Notifications: each analyst sees and marks as read only their own.
alter table public.notifications enable row level security;

create policy notifications_select_own on public.notifications
  for select to authenticated
  using (analyst_id = (select auth.uid()));

create policy notifications_update_own on public.notifications
  for update to authenticated
  using (analyst_id = (select auth.uid()))
  with check (analyst_id = (select auth.uid()));

-- Table grants (on top of Supabase's default privileges).
revoke all on all tables in schema public from anon;
revoke all on all sequences in schema public from anon;

revoke insert, update, delete, truncate on public.audit_log from authenticated;

revoke insert, update, delete on public.notifications from authenticated;
grant update (read_at) on public.notifications to authenticated;

revoke update on public.analysts from authenticated;
grant update (full_name, last_seen_at) on public.analysts to authenticated;

-- Function grants: trigger functions are not callable by clients; RPCs only by analysts.
revoke execute on function public.audit_labels() from public, anon, authenticated;
revoke execute on function public.audit_ai_alerts() from public, anon, authenticated;
revoke execute on function public.notify_new_alert() from public, anon, authenticated;
revoke execute on function public.handle_new_auth_user() from public, anon, authenticated;
revoke execute on function public.sync_transaction_is_labeled() from public, anon, authenticated;

revoke execute on function public.global_search(text, integer) from public, anon;
revoke execute on function public.resolve_alert(uuid, public.alert_status, integer, integer, text) from public, anon;
revoke execute on function public.label_transactions(bigint[], public.verdict, integer, integer[], public.severity, text) from public, anon;
grant execute on function public.global_search(text, integer) to authenticated;
grant execute on function public.resolve_alert(uuid, public.alert_status, integer, integer, text) to authenticated;
grant execute on function public.label_transactions(bigint[], public.verdict, integer, integer[], public.severity, text) to authenticated;
