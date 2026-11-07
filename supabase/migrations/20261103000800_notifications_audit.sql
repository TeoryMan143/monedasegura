-- Baseline 8/14 · notifications (one per analyst and alert) and the append-only audit log.

create table public.notifications (
  id uuid not null default gen_random_uuid(),
  analyst_id uuid not null,
  type public.notification_type not null,
  alert_id uuid not null,
  title text not null,
  body text,
  created_at timestamptz not null default now(),
  read_at timestamptz,
  constraint notifications_pkey primary key (id),
  constraint notifications_analyst_id_alert_id_key unique (analyst_id, alert_id),
  constraint notifications_alert_id_fkey foreign key (alert_id) references public.ai_alerts (id) on delete cascade,
  constraint notifications_analyst_id_fkey foreign key (analyst_id) references public.analysts (id) on delete cascade
);

create table public.audit_log (
  id bigint generated always as identity not null,
  analyst_id uuid not null,
  action public.audit_action not null,
  entity text not null,
  entity_id text not null,
  transaction_id bigint,
  old_value jsonb,
  new_value jsonb,
  created_at timestamptz not null default now(),
  constraint audit_log_pkey primary key (id),
  constraint audit_log_entity_check check (entity = any (array['labels', 'ai_alerts'])),
  constraint audit_log_analyst_id_fkey foreign key (analyst_id) references public.analysts (id),
  constraint audit_log_transaction_id_fkey foreign key (transaction_id) references public.transactions (id)
);
