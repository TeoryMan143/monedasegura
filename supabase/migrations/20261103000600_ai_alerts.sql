-- Baseline 6/14 · AI alerts (simulated model): alert, its transactions and its reasons.

create sequence public.ai_alerts_code_seq start with 1000;

create table public.ai_alerts (
  id uuid not null default gen_random_uuid(),
  code text not null default ('AL-' || nextval('public.ai_alerts_code_seq'::regclass)::text),
  customer_id uuid not null,
  account_id uuid,
  score smallint not null,
  suggested_type_id smallint not null,
  summary text not null,
  model_version text not null,
  generated_at timestamptz not null default now(),
  status public.alert_status not null default 'pending',
  resolved_by uuid,
  resolved_at timestamptz,
  final_type_id smallint,
  constraint ai_alerts_pkey primary key (id),
  constraint ai_alerts_code_key unique (code),
  constraint ai_alerts_check check ((status = 'pending') = (resolved_by is null and resolved_at is null)),
  constraint ai_alerts_check1 check (status <> 'pending' or final_type_id is null),
  constraint ai_alerts_check2 check (status <> 'confirmed' or (final_type_id is not null and final_type_id = suggested_type_id)),
  constraint ai_alerts_check3 check (status <> 'reclassified' or (final_type_id is not null and final_type_id <> suggested_type_id)),
  constraint ai_alerts_check4 check (status <> 'rejected' or final_type_id is null),
  constraint ai_alerts_score_check check (score >= 0 and score <= 100),
  constraint ai_alerts_account_id_fkey foreign key (account_id) references public.accounts (id),
  constraint ai_alerts_customer_id_fkey foreign key (customer_id) references public.customers (id),
  constraint ai_alerts_final_type_id_fkey foreign key (final_type_id) references public.fraud_types (id),
  constraint ai_alerts_resolved_by_fkey foreign key (resolved_by) references public.analysts (id),
  constraint ai_alerts_suggested_type_id_fkey foreign key (suggested_type_id) references public.fraud_types (id)
);

alter sequence public.ai_alerts_code_seq owned by public.ai_alerts.code;

create table public.ai_alert_transactions (
  alert_id uuid not null,
  transaction_id bigint not null,
  is_primary boolean not null default false,
  constraint ai_alert_transactions_pkey primary key (alert_id, transaction_id),
  constraint ai_alert_transactions_alert_id_fkey foreign key (alert_id) references public.ai_alerts (id) on delete cascade,
  constraint ai_alert_transactions_transaction_id_fkey foreign key (transaction_id) references public.transactions (id)
);

create table public.ai_alert_reasons (
  id uuid not null default gen_random_uuid(),
  alert_id uuid not null,
  position smallint not null,
  weight numeric(4, 3) not null,
  title text not null,
  evidence text not null,
  metric jsonb,
  constraint ai_alert_reasons_pkey primary key (id),
  constraint ai_alert_reasons_alert_id_position_key unique (alert_id, position),
  constraint ai_alert_reasons_position_check check (position > 0),
  constraint ai_alert_reasons_weight_check check (weight >= 0 and weight <= 1),
  constraint ai_alert_reasons_alert_id_fkey foreign key (alert_id) references public.ai_alerts (id) on delete cascade
);
