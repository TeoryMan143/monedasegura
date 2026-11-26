-- Labeling, alerts and notifications: close the gaps found when checking the hosted schema
-- against the baseline (HU-04, HU-05, HU-08, HU-15, HU-16). Both sides already matched; these
-- are rules from .agents/DATABASE.md that neither side implemented.

-- 1. Realtime (HU-16): updates must carry the old row, so the app can tell
--    pending → resolved and see the previous verdict.
alter table public.ai_alerts replica identity full;
alter table public.labels replica identity full;

-- 2. labels.analyst_id is set by the database. The insert policy still requires
--    analyst_id = auth.uid(), so a client cannot pass someone else's id.
alter table public.labels alter column analyst_id set default auth.uid();

-- 3. ai_alerts only changes through resolve_alert (security definer). RLS already denies
--    writes (no policy), but TRUNCATE skips RLS, so drop the table privileges too.
revoke insert, update, delete, truncate on public.ai_alerts from authenticated;

-- 4. TRUNCATE skips RLS: nobody but the owner may empty the labeling tables or the
--    notifications. labels has no delete policy, so drop DELETE as well.
revoke truncate on public.labels, public.label_fraud_types, public.notifications from authenticated;
revoke delete on public.labels from authenticated;

-- 5. Manual labels only as yourself, fraud types included. Before, any analyst could add or
--    remove fraud types on any label (alert labels and other analysts' labels too) without
--    becoming its author and without an audit row. Now the parent label must be a manual
--    label whose current author is the caller. label_transactions (security invoker) upserts
--    the label with analyst_id = auth.uid() first, so its own fraud-type writes still pass;
--    resolve_alert is security definer and is not affected.
drop policy lft_insert on public.label_fraud_types;
drop policy lft_delete on public.label_fraud_types;

create policy lft_insert on public.label_fraud_types
  for insert to authenticated
  with check (
    (select public.is_analyst())
    and exists (select 1 from public.labels l
                 where l.id = label_id
                   and l.analyst_id = (select auth.uid())
                   and l.source = 'manual'));

create policy lft_delete on public.label_fraud_types
  for delete to authenticated
  using (
    (select public.is_analyst())
    and exists (select 1 from public.labels l
                 where l.id = label_id
                   and l.analyst_id = (select auth.uid())
                   and l.source = 'manual'));

-- No UPDATE policy on label_fraud_types: changing types means delete + insert.
revoke update on public.label_fraud_types from authenticated;
