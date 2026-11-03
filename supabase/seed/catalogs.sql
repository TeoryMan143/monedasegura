-- Catalogs loaded by the seed. Read only for the app.
-- Load order matters: currencies must exist before exchange_rates.

-- Exchange rates: simulated value of 1 unit of each currency in COP (not a live feed).
insert into public.exchange_rates (currency_code, rate_to_cop, as_of) values
  ('COP',    1.000000, '2026-03-01'),
  ('MXN',  216.000000, '2026-03-01'),
  ('PEN', 1067.000000, '2026-03-01'),
  ('CLP',    4.210000, '2026-03-01'),
  ('ARS',    2.860000, '2026-03-01'),
  ('BRL',  727.000000, '2026-03-01')
on conflict (currency_code) do update
  set rate_to_cop = excluded.rate_to_cop,
      as_of = excluded.as_of;
