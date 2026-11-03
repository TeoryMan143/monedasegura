-- Exchange rates catalog: fixed, simulated rate of each currency to COP.
-- Used by v_fraud_stats to show the committed amount converted to COP (HU-13).
-- Read only for the app; rows are loaded by supabase/seed/catalogs.sql.
-- See docs/mer.puml and .agents/DATABASE.md.

create table public.exchange_rates (
  currency_code char(3) primary key references public.currencies (code),
  rate_to_cop numeric(18, 6) not null,
  as_of date not null,
  constraint exchange_rates_rate_positive check (rate_to_cop > 0),
  constraint exchange_rates_cop_is_one check (currency_code <> 'COP' or rate_to_cop = 1)
);

comment on table public.exchange_rates is
  'Fixed, simulated rate to COP per currency (COP = 1). Read only from the app.';
comment on column public.exchange_rates.rate_to_cop is
  'Value of 1 unit of currency_code in COP.';

alter table public.exchange_rates enable row level security;

create policy analysts_read_exchange_rates
  on public.exchange_rates
  for select
  to authenticated
  using ((select public.is_analyst()));

revoke all on public.exchange_rates from anon, authenticated;
grant select on public.exchange_rates to authenticated;
