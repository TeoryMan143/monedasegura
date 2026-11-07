-- Baseline 13/14 · realtime publication (HU-16). Realtime respects RLS.

alter publication supabase_realtime add table
  public.transactions, public.ai_alerts, public.labels, public.notifications;
