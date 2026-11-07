-- Baseline 7/14 · labeling. One current label per transaction (last write wins); the history
-- lives in audit_log.

create table public.labels (
  id uuid not null default gen_random_uuid(),
  transaction_id bigint not null,
  source public.label_source not null default 'manual',
  alert_id uuid,
  verdict public.verdict not null,
  confidence smallint not null,
  severity public.severity,
  justification text,
  analyst_id uuid not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  version integer not null default 1,
  constraint labels_pkey primary key (id),
  constraint labels_transaction_id_key unique (transaction_id),
  constraint labels_check check ((source = 'alert') = (alert_id is not null)),
  constraint labels_check1 check (verdict <> 'not_fraud' or severity is null),
  constraint labels_check2 check (verdict <> 'fraud' or severity is not null),
  constraint labels_check3 check ((verdict <> 'uncertain' and confidence > 1) or coalesce(length(btrim(justification)), 0) > 0),
  constraint labels_alert_id_fkey foreign key (alert_id) references public.ai_alerts (id),
  constraint labels_analyst_id_fkey foreign key (analyst_id) references public.analysts (id),
  constraint labels_confidence_fkey foreign key (confidence) references public.confidence_levels (level),
  constraint labels_severity_fkey foreign key (severity) references public.severity_levels (level),
  constraint labels_transaction_id_fkey foreign key (transaction_id) references public.transactions (id)
);

create table public.label_fraud_types (
  label_id uuid not null,
  fraud_type_id smallint not null,
  constraint label_fraud_types_pkey primary key (label_id, fraud_type_id),
  constraint label_fraud_types_fraud_type_id_fkey foreign key (fraud_type_id) references public.fraud_types (id),
  constraint label_fraud_types_label_id_fkey foreign key (label_id) references public.labels (id) on delete cascade
);
