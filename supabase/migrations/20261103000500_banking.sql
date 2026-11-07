-- Baseline 5/14 · simulated banking data: customers, accounts, cards, devices, security events,
-- merchants, transactions, ledger and disputes.

create table public.customers (
  id uuid not null default gen_random_uuid(),
  document_type public.document_type not null,
  document_number text not null,
  first_names text not null,
  last_names text not null,
  birth_date date not null,
  phone text,
  email text,
  country_code char(2) not null,
  city_id integer not null,
  occupation text,
  declared_income numeric(18, 2),
  income_currency char(3) not null,
  customer_since date not null,
  segment public.customer_segment not null,
  risk_level public.risk_level not null,
  created_at timestamptz not null default now(),
  search_vector tsvector generated always as (
    to_tsvector('simple'::regconfig,
      coalesce(first_names, '') || ' ' || coalesce(last_names, '') || ' ' ||
      coalesce(document_number, '') || ' ' || coalesce(email, '') || ' ' || coalesce(phone, ''))
  ) stored,
  constraint customers_pkey primary key (id),
  constraint customers_country_code_document_type_document_number_key unique (country_code, document_type, document_number),
  constraint customers_declared_income_check check (declared_income >= 0),
  constraint customers_city_id_fkey foreign key (city_id) references public.cities (id),
  constraint customers_country_code_fkey foreign key (country_code) references public.countries (code),
  constraint customers_income_currency_fkey foreign key (income_currency) references public.currencies (code)
);

create table public.accounts (
  id uuid not null default gen_random_uuid(),
  number text not null,
  last4 char(4) generated always as ((right(number, 4))::char(4)) stored,
  type public.account_type not null,
  currency_code char(3) not null,
  bank_id integer not null,
  is_external boolean not null default false,
  customer_id uuid,
  holder_name text,
  balance numeric(18, 2),
  credit_limit numeric(18, 2),
  status public.product_status not null default 'active',
  opened_on date,
  closed_on date,
  created_at timestamptz not null default now(),
  constraint accounts_pkey primary key (id),
  constraint accounts_bank_id_number_key unique (bank_id, number),
  constraint accounts_check check (is_external or customer_id is not null),
  constraint accounts_check1 check (closed_on is null or opened_on is null or closed_on >= opened_on),
  constraint accounts_credit_limit_check check (credit_limit >= 0),
  constraint accounts_bank_id_fkey foreign key (bank_id) references public.banks (id),
  constraint accounts_currency_code_fkey foreign key (currency_code) references public.currencies (code),
  constraint accounts_customer_id_fkey foreign key (customer_id) references public.customers (id)
);

create table public.cards (
  id uuid not null default gen_random_uuid(),
  account_id uuid not null,
  customer_id uuid not null,
  type public.card_type not null,
  network text not null,
  bin char(6) not null,
  last4 char(4) not null,
  status public.product_status not null default 'active',
  credit_limit numeric(18, 2),
  issued_on date not null,
  expires_on date not null,
  constraint cards_pkey primary key (id),
  constraint cards_bin_check check (bin ~ '^[0-9]{6}$'),
  constraint cards_check check (expires_on > issued_on),
  constraint cards_credit_limit_check check (credit_limit >= 0),
  constraint cards_last4_check check (last4 ~ '^[0-9]{4}$'),
  constraint cards_account_id_fkey foreign key (account_id) references public.accounts (id),
  constraint cards_customer_id_fkey foreign key (customer_id) references public.customers (id)
);

create table public.devices (
  id uuid not null default gen_random_uuid(),
  fingerprint text not null,
  type public.device_type not null,
  brand text,
  model text,
  os text,
  os_version text,
  created_at timestamptz not null default now(),
  constraint devices_pkey primary key (id),
  constraint devices_fingerprint_key unique (fingerprint)
);

create table public.customer_devices (
  customer_id uuid not null,
  device_id uuid not null,
  first_seen_at timestamptz not null,
  last_seen_at timestamptz not null,
  is_trusted boolean not null default false,
  constraint customer_devices_pkey primary key (customer_id, device_id),
  constraint customer_devices_check check (last_seen_at >= first_seen_at),
  constraint customer_devices_customer_id_fkey foreign key (customer_id) references public.customers (id),
  constraint customer_devices_device_id_fkey foreign key (device_id) references public.devices (id)
);

create table public.security_events (
  id uuid not null default gen_random_uuid(),
  customer_id uuid not null,
  type public.security_event_type not null,
  occurred_at timestamptz not null,
  device_id uuid,
  channel_code text,
  ip inet,
  city_id integer,
  latitude numeric(9, 6),
  longitude numeric(9, 6),
  succeeded boolean not null,
  details jsonb,
  constraint security_events_pkey primary key (id),
  constraint security_events_channel_code_fkey foreign key (channel_code) references public.channels (code),
  constraint security_events_city_id_fkey foreign key (city_id) references public.cities (id),
  constraint security_events_customer_id_fkey foreign key (customer_id) references public.customers (id),
  constraint security_events_device_id_fkey foreign key (device_id) references public.devices (id)
);

create table public.merchants (
  id uuid not null default gen_random_uuid(),
  name text not null,
  mcc char(4) not null,
  country_code char(2) not null,
  city_id integer,
  is_online boolean not null default false,
  latitude numeric(9, 6),
  longitude numeric(9, 6),
  constraint merchants_pkey primary key (id),
  constraint merchants_city_id_fkey foreign key (city_id) references public.cities (id),
  constraint merchants_country_code_fkey foreign key (country_code) references public.countries (code),
  constraint merchants_mcc_fkey foreign key (mcc) references public.merchant_categories (mcc)
);

create table public.transactions (
  id bigint generated always as identity not null,
  code text generated always as ('TX-' || id::text) stored,
  occurred_at timestamptz not null,
  type public.transaction_type not null,
  channel_code text not null,
  amount numeric(18, 2) not null,
  currency_code char(3) not null,
  source_account_id uuid,
  destination_account_id uuid,
  card_id uuid,
  merchant_id uuid,
  device_id uuid,
  ip inet,
  city_id integer,
  latitude numeric(9, 6),
  longitude numeric(9, 6),
  status public.transaction_status not null,
  description text,
  reference text,
  is_labeled boolean not null default false,
  created_at timestamptz not null default now(),
  constraint transactions_pkey primary key (id),
  constraint transactions_code_key unique (code),
  constraint transactions_amount_check check (amount > 0),
  constraint transactions_check check (source_account_id is not null or destination_account_id is not null),
  constraint transactions_check1 check (type <> 'transfer' or (source_account_id is not null and destination_account_id is not null)),
  constraint transactions_check2 check (type <> 'purchase' or merchant_id is not null),
  constraint transactions_card_id_fkey foreign key (card_id) references public.cards (id),
  constraint transactions_channel_code_fkey foreign key (channel_code) references public.channels (code),
  constraint transactions_city_id_fkey foreign key (city_id) references public.cities (id),
  constraint transactions_currency_code_fkey foreign key (currency_code) references public.currencies (code),
  constraint transactions_destination_account_id_fkey foreign key (destination_account_id) references public.accounts (id),
  constraint transactions_device_id_fkey foreign key (device_id) references public.devices (id),
  constraint transactions_merchant_id_fkey foreign key (merchant_id) references public.merchants (id),
  constraint transactions_source_account_id_fkey foreign key (source_account_id) references public.accounts (id)
);

create table public.ledger_entries (
  id bigint generated always as identity not null,
  transaction_id bigint not null,
  account_id uuid not null,
  direction public.entry_direction not null,
  amount numeric(18, 2) not null,
  balance_after numeric(18, 2) not null,
  occurred_at timestamptz not null,
  constraint ledger_entries_pkey primary key (id),
  constraint ledger_entries_transaction_id_account_id_key unique (transaction_id, account_id),
  constraint ledger_entries_amount_check check (amount > 0),
  constraint ledger_entries_account_id_fkey foreign key (account_id) references public.accounts (id),
  constraint ledger_entries_transaction_id_fkey foreign key (transaction_id) references public.transactions (id)
);

create table public.disputes (
  id uuid not null default gen_random_uuid(),
  transaction_id bigint not null,
  type public.dispute_type not null,
  status public.dispute_status not null default 'open',
  filed_at timestamptz not null default now(),
  resolved_at timestamptz,
  description text,
  constraint disputes_pkey primary key (id),
  constraint disputes_check check (resolved_at is null or resolved_at >= filed_at),
  constraint disputes_transaction_id_fkey foreign key (transaction_id) references public.transactions (id)
);
