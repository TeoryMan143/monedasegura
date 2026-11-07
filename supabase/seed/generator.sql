-- =============================================================================================
-- Moneda Segura · demo data generator
-- =============================================================================================
--
-- Installs seed.reset_demo_data(), which wipes every table in public, reloads the catalogs and
-- rebuilds the whole demo dataset, plus the seed analysts in auth.users:
--
--   select seed.reset_demo_data();                 -- the reference state (anchor 2026-11-07)
--   select seed.reset_demo_data(now());            -- same data, dates moved to end today
--
-- Reproducible: every "random" value comes from md5 of a stable key (seed.h), not from
-- random(), so two runs with the same anchor produce identical rows, ids included.
--
-- Everything lives in the private `seed` schema: it is not exposed through the API and anon /
-- authenticated have no USAGE on it. The injected fraud patterns are recorded in
-- seed.injected_patterns, never in public.
--
-- Volumes (anchor 2026-11-07): 2,000 customers · ~3,500 own accounts + 720 counterparties ·
-- ~80,000 transactions over 6 months · 1,500 AI alerts (1,100 injected frauds + 400 false
-- positives) · ~11,000 labels with edits and audit history · 7 seed analysts.
--
-- See supabase/seed/README.md for how to run it locally and against the hosted project.
-- =============================================================================================

create schema if not exists seed;
revoke all on schema seed from public;
revoke all on schema seed from anon, authenticated;

-- Private record of the injected patterns (already present in the hosted project).
create table if not exists seed.injected_patterns (
  id uuid primary key default gen_random_uuid(),
  fraud_type_id smallint not null references public.fraud_types (id),
  customer_id uuid not null references public.customers (id),
  description text not null,
  is_false_positive boolean not null default false,
  random_seed integer not null,
  created_at timestamptz not null default now()
);

create table if not exists seed.injected_pattern_transactions (
  pattern_id uuid not null references seed.injected_patterns (id) on delete cascade,
  transaction_id bigint not null references public.transactions (id),
  primary key (pattern_id, transaction_id)
);

-- ---------------------------------------------------------------------------------------------
-- Deterministic randomness
-- ---------------------------------------------------------------------------------------------

-- Uniform [0, 1) from a key.
create or replace function seed.h(p_key text) returns double precision
language sql immutable parallel safe
as $$ select (('x' || substr(md5(p_key), 1, 13))::bit(52)::bigint)::double precision / 4503599627370496.0 $$;

-- Integer in [p_lo, p_hi].
create or replace function seed.hi(p_key text, p_lo integer, p_hi integer) returns integer
language sql immutable parallel safe
as $$ select p_lo + least(floor(seed.h(p_key) * (p_hi - p_lo + 1))::integer, p_hi - p_lo) $$;

-- One element of an array.
create or replace function seed.pick(p_values anyarray, p_key text) returns anyelement
language sql immutable parallel safe
as $$ select p_values[1 + floor(seed.h(p_key) * cardinality(p_values))::integer] $$;

-- One element of an array, weighted.
create or replace function seed.wpick(p_values anyarray, p_weights double precision[], p_key text)
returns anyelement
language plpgsql immutable parallel safe
as $$
declare
  v_total double precision := 0;
  v_acc double precision := 0;
  v_x double precision;
  i integer;
begin
  for i in 1 .. cardinality(p_weights) loop
    v_total := v_total + p_weights[i];
  end loop;
  v_x := seed.h(p_key) * v_total;
  for i in 1 .. cardinality(p_weights) loop
    v_acc := v_acc + p_weights[i];
    if v_x < v_acc then
      return p_values[i];
    end if;
  end loop;
  return p_values[cardinality(p_values)];
end;
$$;

-- Standard normal (Box–Muller).
create or replace function seed.gauss(p_key text) returns double precision
language sql immutable parallel safe
as $$
  select sqrt(-2 * ln(greatest(seed.h(p_key || '#u'), 1e-12))) * cos(2 * pi() * seed.h(p_key || '#v'))
$$;

-- Stable uuid from a key.
create or replace function seed.uid(p_key text) returns uuid
language sql immutable parallel safe
as $$ select md5('moneda-segura:' || p_key)::uuid $$;

-- ---------------------------------------------------------------------------------------------
-- Small helpers
-- ---------------------------------------------------------------------------------------------

create or replace function seed.plain(p_text text) returns text
language sql immutable parallel safe
as $$ select translate(p_text, 'áéíóúÁÉÍÓÚñÑçÇãõâêôüÜ', 'aeiouAEIOUnNcCaoaeouU') $$;

-- Rounds to p_digits significant digits.
create or replace function seed.sig(p_x numeric, p_digits integer default 3) returns numeric
language sql immutable parallel safe
as $$
  select case when p_x is null or p_x <= 0 then p_x
              else round(p_x, p_digits - 1 - floor(log(p_x))::integer) end
$$;

-- Great-circle distance in km.
create or replace function seed.km(p_lat1 numeric, p_lon1 numeric, p_lat2 numeric, p_lon2 numeric)
returns integer
language sql immutable parallel safe
as $$
  select round(6371 * 2 * asin(sqrt(
    power(sin(radians((p_lat2 - p_lat1)::double precision) / 2), 2)
    + cos(radians(p_lat1::double precision)) * cos(radians(p_lat2::double precision))
      * power(sin(radians((p_lon2 - p_lon1)::double precision) / 2), 2))))::integer
$$;

-- Countries: index, timezone, IP block and the customer number range of each one.
create or replace view seed.k_country as
select * from (values
  ('CO', 1, 'COP', 'America/Bogota',                 186,  80, 12,    1,  600, 'Colombia'),
  ('MX', 2, 'MXN', 'America/Mexico_City',            187, 128, 32,  601, 1040, 'México'),
  ('PE', 3, 'PEN', 'America/Lima',                   190, 232,  8, 1041, 1320, 'Perú'),
  ('CL', 4, 'CLP', 'America/Santiago',               191, 112, 16, 1321, 1560, 'Chile'),
  ('AR', 5, 'ARS', 'America/Argentina/Buenos_Aires', 181,  44,  4, 1561, 1780, 'Argentina'),
  ('BR', 6, 'BRL', 'America/Sao_Paulo',              177,  32, 64, 1781, 2000, 'Brasil')
) v(code, idx, currency, tz, ip_a, ip_b, ip_span, n_from, n_to, name);

-- Currency constants, refreshed from the catalogs by seed.p_constants().
--   cash_unit: ATM multiples · nice_unit: rounding of transfers
--   report_threshold: cash reporting threshold used by the structuring pattern (~10 M COP)
create unlogged table if not exists seed.k_currency (
  code text primary key,
  decimals integer not null,
  rate double precision not null,
  cash_unit numeric not null,
  nice_unit numeric not null,
  report_threshold numeric not null
);

-- A local amount, rounded the way it would appear.
create or replace function seed.amt_local(p_local numeric, p_currency text, p_mode text default 'exact')
returns numeric
language sql stable
as $$
  select case p_mode
    when 'cash' then greatest(round(p_local / k.cash_unit) * k.cash_unit, k.cash_unit)
    when 'nice' then greatest(round(p_local / k.nice_unit) * k.nice_unit, k.nice_unit)
    else greatest(round(p_local, k.decimals), 1)
  end
  from seed.k_currency k where k.code = p_currency
$$;

-- A COP amount converted to the local currency.
create or replace function seed.amt(p_cop double precision, p_currency text, p_mode text default 'exact')
returns numeric
language sql stable
as $$
  select seed.amt_local((p_cop / k.rate)::numeric, p_currency, p_mode)
  from seed.k_currency k where k.code = p_currency
$$;

-- "$ 4.250.000", "R$ 1.234,56" (used in alert texts).
create or replace function seed.fmt_money(p_amount numeric, p_currency text) returns text
language sql stable
as $$
  select c.symbol || ' ' || translate(to_char(p_amount,
           case when c.decimals = 0 or p_amount = trunc(p_amount)
                then 'FM999,999,999,999,990' else 'FM999,999,999,999,990.00' end), ',.', '.,')
  from public.currencies c where c.code = p_currency
$$;

-- "8,2×"
create or replace function seed.fmt_x(p_value double precision) returns text
language sql immutable
as $$ select replace(to_char(round(p_value::numeric, 1), 'FM999990.0'), '.', ',') || '×' $$;

create or replace function seed.analyst_uuid(p_n integer) returns uuid
language sql immutable
as $$ select ('a0000000-0000-4000-8000-' || lpad(p_n::text, 12, '0'))::uuid $$;

-- Analyst number 1..7 weighted by how much each one labels.
create or replace function seed.analyst_n(p_key text) returns integer
language sql immutable
as $$ select seed.wpick(array[1, 2, 3, 4, 5, 6, 7], array[8, 18, 18, 16, 16, 13, 11]::float8[], p_key) $$;

-- Seed analysts. All share the password MonedaSegura2026! (demo data only).
create or replace view seed.k_analyst as
select n, seed.analyst_uuid(n) as id, email, full_name
from (values
  (1, 'demo@monedasegura.test',            'Analista Demo'),
  (2, 'jonathan.cortes@monedasegura.test', 'Jonathan Cortés'),
  (3, 'andres.martinez@monedasegura.test', 'Andrés Martínez'),
  (4, 'juan.borrero@monedasegura.test',    'Juan Camilo Borrero'),
  (5, 'juan.pelaez@monedasegura.test',     'Juan Camilo Peláez'),
  (6, 'laura.gomez@monedasegura.test',     'Laura Gómez'),
  (7, 'mateo.rojas@monedasegura.test',     'Mateo Rojas')
) v(n, email, full_name);

create or replace function seed.first_names(p_br boolean, p_female boolean) returns text[]
language sql immutable
as $$
  select case
    when p_br and p_female then array['Ana','Maria','Juliana','Fernanda','Camila','Beatriz','Larissa',
      'Mariana','Letícia','Amanda','Bruna','Gabriela','Carolina','Patrícia','Aline','Vanessa','Renata',
      'Isabela','Luana','Débora','Rafaela','Tatiane','Priscila','Natália']
    when p_br then array['João','Pedro','Lucas','Gabriel','Rafael','Gustavo','Felipe','Bruno','Thiago',
      'Matheus','Leonardo','Rodrigo','Eduardo','Vinícius','André','Marcelo','Fernando','Ricardo','Caio',
      'Henrique','Diego','Daniel','Paulo','Leandro']
    when p_female then array['María','Ana','Laura','Valentina','Camila','Daniela','Sofía','Isabella',
      'Mariana','Paula','Carolina','Andrea','Natalia','Gabriela','Lucía','Juliana','Catalina','Fernanda',
      'Alejandra','Diana','Patricia','Claudia','Mónica','Sandra','Verónica','Ximena','Paola','Lorena',
      'Adriana','Rosa','Elena','Sara','Victoria','Antonella','Florencia','Renata','Martina','Josefina',
      'Constanza','Luciana']
    else array['Juan','Carlos','Andrés','Luis','Jorge','Diego','Santiago','Sebastián','Mateo','Alejandro',
      'Felipe','Daniel','David','Miguel','José','Javier','Ricardo','Fernando','Camilo','Nicolás','Julián',
      'Óscar','Martín','Gabriel','Tomás','Emilio','Raúl','Héctor','Eduardo','Manuel','Pablo','Francisco',
      'Rodrigo','Esteban','Mauricio','Iván','Gustavo','Sergio','Álvaro','Cristian']
  end
$$;

create or replace function seed.last_names(p_br boolean) returns text[]
language sql immutable
as $$
  select case when p_br then array['Silva','Santos','Oliveira','Souza','Rodrigues','Ferreira','Alves',
      'Pereira','Lima','Gomes','Costa','Ribeiro','Martins','Carvalho','Almeida','Lopes','Soares',
      'Fernandes','Vieira','Barbosa','Rocha','Dias','Nascimento','Andrade','Moreira','Nunes','Marques',
      'Machado','Mendes','Freitas']
    else array['García','Rodríguez','Martínez','López','González','Hernández','Pérez','Sánchez',
      'Ramírez','Torres','Flores','Rivera','Gómez','Díaz','Reyes','Morales','Cruz','Ortiz','Gutiérrez',
      'Chávez','Ramos','Vargas','Castillo','Jiménez','Moreno','Romero','Herrera','Medina','Aguilar',
      'Castro','Ruiz','Álvarez','Mendoza','Vásquez','Rojas','Muñoz','Ospina','Restrepo','Quispe','Mamani',
      'Fernández','Sosa','Silva','Contreras','Soto','Valenzuela','Cárdenas','Salazar','Navarro','Peña']
  end
$$;

create or replace function seed.device_specs(p_type text) returns text[]
language sql immutable
as $$
  select case p_type
    when 'desktop' then array['Lenovo|ThinkPad E14|Windows|11','HP|Pavilion 15|Windows|11',
      'Dell|Inspiron 14|Windows|10','Apple|MacBook Air M2|macOS|14.6','Asus|VivoBook 15|Windows|11',
      'Acer|Aspire 5|Windows|11']
    when 'tablet' then array['Apple|iPad 10|iPadOS|17.5','Samsung|Galaxy Tab A8|Android|13',
      'Lenovo|Tab M10|Android|13']
    else array['Samsung|Galaxy A54|Android|14','Samsung|Galaxy S23|Android|14',
      'Xiaomi|Redmi Note 13|Android|14','Motorola|Moto G84|Android|14','Apple|iPhone 13|iOS|17.6',
      'Apple|iPhone 15|iOS|18.1','Huawei|P30 Lite|Android|10','Oppo|A78|Android|13',
      'Apple|iPhone 12|iOS|17.5','Samsung|Galaxy A15|Android|14']
  end
$$;

create or replace function seed.merchant_name(p_mcc text, p_br boolean, p_key text) returns text
language sql immutable
as $$
  select seed.pick(case p_mcc
      when '5411' then case when p_br then array['Supermercado','Mercado','Empório'] else array['Supermercado','Minimercado','Autoservicio'] end
      when '5812' then case when p_br then array['Restaurante','Churrascaria','Café','Pizzaria'] else array['Restaurante','Parrilla','Café','Pizzería','Asadero'] end
      when '5541' then case when p_br then array['Posto'] else array['Estación de servicio','Gasolinera'] end
      when '5311' then case when p_br then array['Lojas'] else array['Almacenes','Tiendas'] end
      when '5732' then case when p_br then array['Eletrônicos','Tecno'] else array['Electrónica','Tecno','Digital'] end
      when '5999' then case when p_br then array['Bazar','Loja'] else array['Bazar','Tienda','Variedades'] end
      when '4111' then array['Transporte','Metro','Bus']
      when '4121' then case when p_br then array['Táxi','Mobilidade'] else array['Taxi','Movilidad'] end
      when '4814' then case when p_br then array['Telefonia','Móvel'] else array['Telefonía','Móvil'] end
      when '4900' then case when p_br then array['Energia','Águas','Gás'] else array['Energía','Aguas','Gas'] end
      when '5912' then case when p_br then array['Farmácia','Drogaria'] else array['Droguería','Farmacia'] end
      when '5651' then array['Moda','Boutique']
      when '7011' then case when p_br then array['Hotel','Pousada'] else array['Hotel','Hostal'] end
      when '4511' then case when p_br then array['Linhas Aéreas','Voos'] else array['Aerolínea','Vuelos'] end
      when '5944' then case when p_br then array['Joalheria'] else array['Joyería','Relojería'] end
      when '6051' then case when p_br then array['Cripto','Câmbio'] else array['Cripto','Casa de cambio'] end
      when '7995' then case when p_br then array['Apostas','Cassino'] else array['Apuestas','Casino'] end
      when '4829' then case when p_br then array['Remessas'] else array['Giros','Remesas'] end
      when '5967' then array['Ofertas Online','TeleShop','Compra Fácil']
      when '5815' then array['Stream','Música Digital','Juegos Digitales']
      when '8220' then case when p_br then array['Universidade','Instituto'] else array['Universidad','Instituto'] end
      else case when p_br then array['Casa','Ferragens'] else array['Ferretería','Hogar'] end
    end, p_key || ':a')
    || ' '
    || seed.pick(case when p_br
        then array['Central','do Vale','Paulista','do Porto','Bela Vista','Nova Era','Ipanema',
                   'da Praça','Estrela','Express','Primavera','Horizonte','Aurora','Sol']
        else array['La Esquina','El Centro','Del Valle','San Martín','Los Andes','El Puerto','Central',
                   'Del Parque','La Estación','Express','Plaza','Norte','Sur','Real','Dorado','Del Mar',
                   'Andino','Primavera','Los Pinos','La Colina','Aurora','Sol']
       end, p_key || ':b')
$$;

-- Payment rails per country.
create or replace function seed.rail(p_country text, p_key text) returns text
language sql immutable
as $$
  select case p_country
    when 'CO' then seed.wpick(array['APP','WEB','INTERBANK','PSE'], array[40,15,30,15]::float8[], p_key)
    when 'MX' then seed.wpick(array['SPEI','APP','WEB'], array[60,30,10]::float8[], p_key)
    when 'PE' then seed.wpick(array['YAPE','APP','INTERBANK'], array[45,25,30]::float8[], p_key)
    when 'CL' then seed.wpick(array['INTERBANK','APP','WEB'], array[50,35,15]::float8[], p_key)
    when 'AR' then seed.wpick(array['INTERBANK','APP','WEB'], array[50,40,10]::float8[], p_key)
    else seed.wpick(array['PIX','APP','INTERBANK'], array[70,20,10]::float8[], p_key)
  end
$$;

create or replace function seed.pay_channel(p_country text, p_key text) returns text
language sql immutable
as $$
  select case p_country
    when 'CO' then seed.wpick(array['PSE','APP','WEB'], array[50,30,20]::float8[], p_key)
    when 'MX' then seed.wpick(array['SPEI','APP','WEB'], array[30,50,20]::float8[], p_key)
    when 'BR' then seed.wpick(array['PIX','APP','WEB'], array[50,30,20]::float8[], p_key)
    else seed.wpick(array['APP','WEB'], array[60,40]::float8[], p_key)
  end
$$;

create or replace function seed.ip(p_cidx integer, p_b integer, p_key text) returns inet
language sql stable
as $$
  select (k.ip_a || '.' || coalesce(p_b, k.ip_b + seed.hi(p_key || ':b', 0, k.ip_span - 1))
          || '.' || seed.hi(p_key || ':c', 0, 255) || '.' || seed.hi(p_key || ':d', 1, 254))::inet
  from seed.k_country k where k.idx = p_cidx
$$;

-- Bank account number: bank code + serial (unique per bank) + hashed digits + last 4.
create or replace function seed.account_number(p_cidx integer, p_bank integer, p_serial integer, p_key text)
returns text
language sql immutable
as $$
  select lpad(p_bank::text, 3, '0') || lpad(p_serial::text, 6, '0')
         || substr(translate(md5(p_key || ':f'), 'abcdef', '123456'), 1,
                   case p_cidx when 2 then 5 when 3 then 1 when 5 then 9 else 0 end)
         || lpad(seed.hi(p_key || ':l4', 0, 9999)::text, 4, '0')
$$;

-- Chilean RUT check digit.
create or replace function seed.rut_dv(p_body bigint) returns text
language plpgsql immutable
as $$
declare
  v_sum integer := 0;
  v_mul integer := 2;
  v_n bigint := p_body;
  v_r integer;
begin
  while v_n > 0 loop
    v_sum := v_sum + (v_n % 10)::integer * v_mul;
    v_n := v_n / 10;
    v_mul := case when v_mul = 7 then 2 else v_mul + 1 end;
  end loop;
  v_r := 11 - (v_sum % 11);
  return case v_r when 11 then '0' when 10 then 'K' else v_r::text end;
end;
$$;

-- Brazilian CPF with its two check digits, formatted.
create or replace function seed.cpf(p_base bigint) returns text
language plpgsql immutable
as $$
declare
  v_d integer[] := array[]::integer[];
  v_s text := lpad(p_base::text, 9, '0');
  v_sum integer;
  v_dv integer;
  i integer;
begin
  for i in 1 .. 9 loop
    v_d := v_d || substr(v_s, i, 1)::integer;
  end loop;
  v_sum := 0;
  for i in 1 .. 9 loop v_sum := v_sum + v_d[i] * (11 - i); end loop;
  v_dv := (v_sum * 10) % 11; if v_dv = 10 then v_dv := 0; end if;
  v_d := v_d || v_dv;
  v_sum := 0;
  for i in 1 .. 10 loop v_sum := v_sum + v_d[i] * (12 - i); end loop;
  v_dv := (v_sum * 10) % 11; if v_dv = 10 then v_dv := 0; end if;
  return substr(v_s, 1, 3) || '.' || substr(v_s, 4, 3) || '.' || substr(v_s, 7, 3) || '-'
         || v_d[10]::text || v_dv::text;
end;
$$;

-- Identity document per country (unique by construction: the customer number is embedded).
create or replace function seed.document(
  p_country text, p_segment public.customer_segment, p_n integer, p_first text, p_last text,
  p_birth date, p_female boolean,
  out doc_type public.document_type, out doc_number text)
language plpgsql immutable
as $$
declare
  v_business boolean := p_segment in ('small_business', 'corporate');
  v_k text := 'doc:' || p_n;
  v_b36 text := '0123456789ABCDEFGHIJKLMNPQRSTUVWXYZ';
  v_f text := upper(seed.plain(split_part(p_first, ' ', 1)));
  v_l text := upper(seed.plain(split_part(p_last, ' ', 1)));
  v_l2 text := upper(seed.plain(coalesce(nullif(split_part(p_last, ' ', 2), ''), 'X')));
  v_body bigint;
  v_homo text := substr(v_b36, (p_n / 35) % 35 + 1, 1) || substr(v_b36, p_n % 35 + 1, 1);
begin
  case p_country
    when 'CO' then
      if v_business then
        doc_type := 'NIT';
        doc_number := (900000000 + p_n * 211 + seed.hi(v_k, 0, 210))::text || '-' || seed.hi(v_k || ':dv', 0, 9);
      elsif seed.h(v_k || ':ce') < 0.02 then
        doc_type := 'CE';
        doc_number := (100000 + p_n * 97 + seed.hi(v_k, 0, 96))::text;
      else
        doc_type := 'CC';
        doc_number := (1000000000 + p_n * 397 + seed.hi(v_k, 0, 396))::text;
      end if;
    when 'MX' then
      if v_business then
        doc_type := 'RFC';
        doc_number := substr(v_l || 'XX', 1, 2) || substr(v_l2, 1, 1)
          || to_char(p_birth + interval '30 years', 'YYMMDD') || v_homo || seed.hi(v_k, 0, 9);
      else
        doc_type := 'CURP';
        doc_number := substr(v_l, 1, 1)
          || coalesce(substring(substr(v_l, 2) from '[AEIOU]'), 'X')
          || substr(v_l2, 1, 1) || substr(v_f, 1, 1)
          || to_char(p_birth, 'YYMMDD') || case when p_female then 'M' else 'H' end
          || seed.pick(array['DF','JC','NL','PL','BC','QR'], v_k || ':st')
          || coalesce(substring(substr(v_l, 2) from '[B-DF-HJ-NP-TV-Z]'), 'X')
          || coalesce(substring(substr(v_l2, 2) from '[B-DF-HJ-NP-TV-Z]'), 'X')
          || coalesce(substring(substr(v_f, 2) from '[B-DF-HJ-NP-TV-Z]'), 'X')
          || v_homo;
      end if;
    when 'PE' then
      doc_type := 'DNI';
      doc_number := (10000000 + p_n * 29983 + seed.hi(v_k, 0, 29982))::text;
    when 'CL' then
      doc_type := 'RUT';
      v_body := case when v_business then 76000000 + p_n * 1999 + seed.hi(v_k, 0, 1998)
                     else 5000000 + p_n * 9001 + seed.hi(v_k, 0, 9000) end;
      doc_number := translate(to_char(v_body, 'FM99,999,999'), ',', '.') || '-' || seed.rut_dv(v_body);
    when 'AR' then
      doc_type := 'DNI';
      doc_number := (20000000 + p_n * 4999 + seed.hi(v_k, 0, 4998))::text;
    else
      doc_type := 'CPF';
      doc_number := seed.cpf(100000000 + p_n * 99991 + seed.hi(v_k, 0, 99990));
  end case;
end;
$$;

-- ---------------------------------------------------------------------------------------------
-- Staging tables (unlogged, emptied after every run)
-- ---------------------------------------------------------------------------------------------

-- If you change a staging table, drop it by hand once (they only hold data during a run).
create unlogged table if not exists seed.stg_customer (
  n integer primary key,
  id uuid not null,
  country text not null,
  cidx integer not null,
  currency text not null,
  tz text not null,
  city_id integer not null,
  segment public.customer_segment not null,
  role text not null,                 -- normal · MUL (mule) · SIN (synthetic identity)
  ord_role integer,
  female boolean not null,
  first_names text not null,
  last_names text not null,
  full_name text not null,
  birth_date date not null,
  since date not null,
  income numeric not null,            -- monthly, local currency
  sm double precision not null,       -- spending multiplier of the segment
  n_accounts integer not null,
  t2 public.account_type not null,
  n_devices integer not null,
  ip_b integer not null,
  acc1 uuid
);

create unlogged table if not exists seed.stg_account (
  id uuid primary key,
  kind text not null,                 -- normal · mule · external
  customer_n integer,
  j integer,
  type public.account_type not null,
  currency text not null,
  cidx integer not null,
  bank_id integer not null,
  number text not null,
  holder text not null,
  opened_on date not null,
  credit_limit numeric,
  card_id uuid,
  buffer numeric not null default 0   -- opening balance on top of the lowest point
);

create unlogged table if not exists seed.stg_merchant (
  id uuid primary key,
  m integer not null,
  cidx integer not null,
  city_id integer,
  mcc text not null,
  is_online boolean not null,
  name text not null,
  lat numeric(9, 6),
  lng numeric(9, 6),
  grp text not null                   -- retail · util · risk
);

-- Pools to pick ids from inside set-based queries.
create unlogged table if not exists seed.stg_pool (
  scope text not null,
  key integer not null,
  ids uuid[] not null,
  primary key (scope, key)
);

create unlogged table if not exists seed.stg_pattern (
  pk text primary key,
  kind text not null,
  seq integer not null,
  true_type text,
  is_fp boolean not null,
  suggested text not null,
  customer_n integer not null,
  account_id uuid,
  t0 timestamptz not null,
  generated_at timestamptz not null,
  score integer not null,
  status public.alert_status not null,
  resolved_by uuid,
  resolved_at timestamptz,
  final_type text,
  summary text,
  description text,
  ctx jsonb not null default '{}'
);

create unlogged table if not exists seed.stg_tx (
  k text primary key,
  id bigint,
  occurred_at timestamptz not null,
  type public.transaction_type not null,
  channel_code text not null,
  amount numeric(18, 2) not null,
  currency_code text not null,
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
  pattern_k text,
  is_primary boolean not null default false
);
create index if not exists stg_tx_source_account_id_idx on seed.stg_tx (source_account_id);
create index if not exists stg_tx_destination_account_id_idx on seed.stg_tx (destination_account_id);
create index if not exists stg_tx_pattern_k_idx on seed.stg_tx (pattern_k);

create unlogged table if not exists seed.stg_reason (
  pk text not null,
  position integer not null,
  weight numeric not null,
  title text not null,
  evidence text not null,
  metric jsonb,
  primary key (pk, position)
);

create unlogged table if not exists seed.stg_label (
  transaction_id bigint not null,
  step integer not null,              -- orders versions taken at the same instant
  source public.label_source not null,
  alert_id uuid,
  verdict public.verdict not null,
  confidence smallint not null,
  severity public.severity,
  justification text,
  analyst_id uuid not null,
  at timestamptz not null,
  fraud_types smallint[] not null default '{}',
  edits integer not null default 0,
  amount numeric,
  currency text,
  primary key (transaction_id, step)
);

-- ---------------------------------------------------------------------------------------------
-- Phase 0 · wipe
-- ---------------------------------------------------------------------------------------------

create or replace function seed.p_wipe() returns void
language plpgsql
set search_path = public, seed, extensions
as $$
begin
  truncate table
    public.notifications, public.audit_log, public.label_fraud_types, public.labels,
    public.ai_alert_reasons, public.ai_alert_transactions, public.ai_alerts,
    seed.injected_pattern_transactions, seed.injected_patterns,
    public.disputes, public.ledger_entries, public.transactions, public.security_events,
    public.customer_devices, public.devices, public.cards, public.accounts, public.merchants,
    public.customers,
    public.exchange_rates, public.severity_thresholds, public.severity_levels,
    public.confidence_levels, public.fraud_types, public.merchant_categories, public.channels,
    public.banks, public.cities, public.countries, public.currencies
  restart identity;

  -- Seed analysts only. Real sign-ups keep their account (their notifications are rebuilt).
  delete from auth.users where email like '%@monedasegura.test';

  truncate table seed.stg_customer, seed.stg_account, seed.stg_merchant, seed.stg_pool,
    seed.stg_pattern, seed.stg_tx, seed.stg_reason, seed.stg_label;
end;
$$;

create or replace function seed.p_constants() returns void
language plpgsql
set search_path = public, seed, extensions
as $$
begin
  delete from seed.k_currency;
  insert into seed.k_currency (code, decimals, rate, cash_unit, nice_unit, report_threshold)
  select c.code, c.decimals, r.rate_to_cop::double precision, u.cash_unit, u.nice_unit, u.report_threshold
  from public.currencies c
  join public.exchange_rates r on r.currency_code = c.code
  join (values
    ('COP', 10000, 1000, 10000000),
    ('MXN',   100,   10,    50000),
    ('PEN',    10,    1,    10000),
    ('CLP',  5000, 1000,  2500000),
    ('ARS',  1000,  100,  3500000),
    ('BRL',    10,    1,    13000)
  ) u(code, cash_unit, nice_unit, report_threshold) on u.code = c.code;
end;
$$;

-- ---------------------------------------------------------------------------------------------
-- Phase 1 · analysts (auth.users → trigger creates public.analysts)
-- ---------------------------------------------------------------------------------------------

create or replace function seed.p_analysts(p_anchor timestamptz) returns void
language plpgsql
set search_path = public, seed, extensions
as $$
begin
  insert into auth.users (
    instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
    raw_app_meta_data, raw_user_meta_data, created_at, updated_at, last_sign_in_at,
    confirmation_token, recovery_token, email_change_token_new, email_change,
    email_change_token_current, phone_change, phone_change_token, reauthentication_token,
    is_sso_user, is_anonymous)
  select '00000000-0000-0000-0000-000000000000', a.id, 'authenticated', 'authenticated', a.email,
    extensions.crypt('MonedaSegura2026!', extensions.gen_salt('bf')),
    p_anchor - interval '200 days',
    '{"provider": "email", "providers": ["email"]}'::jsonb,
    jsonb_build_object('full_name', a.full_name),
    p_anchor - interval '200 days', p_anchor - interval '200 days',
    p_anchor - make_interval(hours => a.n * 3),
    '', '', '', '', '', '', '', '', false, false
  from seed.k_analyst a;

  insert into auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
  select a.id::text, a.id,
    jsonb_build_object('sub', a.id::text, 'email', a.email, 'email_verified', true, 'phone_verified', false),
    'email', p_anchor - make_interval(hours => a.n * 3),
    p_anchor - interval '200 days', p_anchor - interval '200 days'
  from seed.k_analyst a;

  -- on_auth_user_created already inserted the analysts; date them like the users.
  update public.analysts an
     set full_name = a.full_name,
         created_at = p_anchor - interval '200 days',
         last_seen_at = p_anchor - make_interval(mins => a.n * 37)
    from seed.k_analyst a
   where a.id = an.id;
end;
$$;

-- ---------------------------------------------------------------------------------------------
-- Phase 2 · customers (staged first: the pattern plan adjusts some of them)
-- ---------------------------------------------------------------------------------------------

create or replace function seed.p_customers(p_anchor timestamptz) returns void
language plpgsql
set search_path = public, seed, extensions
as $$
begin
  insert into seed.stg_customer (n, id, country, cidx, currency, tz, city_id, segment, role, female,
    first_names, last_names, full_name, birth_date, since, income, sm, n_accounts, t2, n_devices, ip_b)
  select x.n, seed.uid('customer:' || x.n), k.code, k.idx, k.currency, k.tz,
    (k.idx - 1) * 6 + case when seed.h('city:' || x.n) < 0.42 then 1 else seed.hi('city2:' || x.n, 2, 6) end,
    sg.segment, r.role, s.female,
    nm.first_names, nm.last_names, nm.first_names || ' ' || nm.last_names,
    b.birth_date,
    greatest((b.birth_date + interval '18 years')::date,
             p_anchor::date - (200 + floor(5600 * power(seed.h('since:' || x.n), 1.5)))::integer),
    seed.sig(seed.amt(inc.cop, k.currency, 'exact')),
    sg.sm,
    case when r.role = 'SIN' then greatest(na.n_acc, 2) else na.n_acc end,
    case when r.role = 'SIN' then 'credit'::public.account_type
         else seed.wpick(array['checking','wallet','credit']::public.account_type[], array[30,35,35]::float8[], 't2:' || x.n) end,
    1 + d.desk::integer + (d.desk and seed.h('tab:' || x.n) < 0.25)::integer,
    k.ip_b + seed.hi('ipb:' || x.n, 0, k.ip_span - 1)
  from generate_series(1, 2000) as x(n)
  join seed.k_country k on x.n between k.n_from and k.n_to
  cross join lateral (select case when seed.h('role:' || x.n) < 0.04 then 'SIN'
                                  when seed.h('role:' || x.n) < 0.095 then 'MUL'
                                  else 'normal' end as role) r
  cross join lateral (select seed.h('sex:' || x.n) < 0.5 as female, k.code = 'BR' as br) s
  cross join lateral (select case when r.role <> 'normal' then 'retail'::public.customer_segment
      else seed.wpick(array['retail','retail_mid_income','premium','small_business','corporate']::public.customer_segment[],
                      array[55,25,10,8,2]::float8[], 'seg:' || x.n) end as segment) sg0
  cross join lateral (select sg0.segment,
      (case sg0.segment when 'retail' then 1.0 when 'retail_mid_income' then 1.8 when 'premium' then 4.0
                        when 'small_business' then 6.0 else 15.0 end)::double precision as sm) sg
  cross join lateral (
    select q.g1 || case when seed.h('two:' || x.n) < 0.35 and q.g2 <> q.g1 then ' ' || q.g2 else '' end as first_names,
           case when (k.code = 'AR' and seed.h('one:' || x.n) < 0.7) or q.l2 = q.l1 then q.l1
                else q.l1 || ' ' || q.l2 end as last_names
    from (select seed.pick(seed.first_names(s.br, s.female), 'fn1:' || x.n) as g1,
                 seed.pick(seed.first_names(s.br, s.female), 'fn2:' || x.n) as g2,
                 seed.pick(seed.last_names(s.br), 'ln1:' || x.n) as l1,
                 seed.pick(seed.last_names(s.br), 'ln2:' || x.n) as l2) q
  ) nm
  cross join lateral (select p_anchor::date
      - (365.25 * (18 + 57 * power(seed.h('age:' || x.n), 1.6)))::integer as birth_date) b
  cross join lateral (select (case sg.segment when 'retail' then 1600000 when 'retail_mid_income' then 4200000
                                  when 'premium' then 14000000 when 'small_business' then 35000000
                                  else 400000000 end) * exp(0.35 * seed.gauss('inc:' || x.n)) as cop) inc
  cross join lateral (select seed.wpick(array[1,2,3], array[40,45,15]::float8[], 'nacc:' || x.n) as n_acc) na
  cross join lateral (select seed.h('desk:' || x.n) < 0.45 as desk) d;

  update seed.stg_customer c
     set ord_role = o.rn, acc1 = seed.uid('account:' || c.n || ':1')
    from (select n, row_number() over (partition by role order by n) as rn from seed.stg_customer) o
   where o.n = c.n;
end;
$$;

-- ---------------------------------------------------------------------------------------------
-- Phase 3 · pattern plan: 1,500 alerts (1,100 injected frauds + 400 false positives)
-- ---------------------------------------------------------------------------------------------

create or replace function seed.p_plan(p_anchor timestamptz) returns void
language plpgsql
set search_path = public, seed, extensions
as $$
declare
  v_normal integer;
  v_mul integer;
  v_sin integer;
begin
  select count(*) filter (where role = 'normal'), count(*) filter (where role = 'MUL'),
         count(*) filter (where role = 'SIN')
    into v_normal, v_mul, v_sin
    from seed.stg_customer;

  insert into seed.stg_pattern (pk, kind, seq, true_type, is_fp, suggested, customer_n, t0,
    generated_at, score, status, resolved_by, resolved_at, final_type)
  with kinds(kind, cnt, true_type, is_fp) as (values
    ('ATO', 170, 'ATO', false), ('PHI', 170, 'PHI', false), ('CLO', 170, 'CLO', false),
    ('MUL', 110, 'MUL', false), ('LAV', 110, 'LAV', false), ('SIN',  80, 'SIN', false),
    ('SIM', 110, 'SIM', false), ('CNR', 180, 'CNR', false),
    ('FP_TRAVEL', 110, null, true), ('FP_BIG', 120, null, true),
    ('FP_INCOME',  90, null, true), ('FP_NIGHT', 80, null, true)),
  q as (
    select k.kind, s.seq, k.true_type, k.is_fp, k.kind || '-' || lpad(s.seq::text, 3, '0') as pk
    from kinds k cross join lateral generate_series(1, k.cnt) s(seq)
  )
  select q.pk, q.kind, q.seq, q.true_type, q.is_fp, sg.suggested, c.n, t.t0, g.generated_at,
    case when q.is_fp then 25 + round(55 * power(seed.h('sc:' || q.pk), 1.2))
         when sg.suggested = q.true_type then 62 + round(37 * power(seed.h('sc:' || q.pk), 0.6))
         else 50 + round(40 * seed.h('sc:' || q.pk)) end,
    st.status,
    case when st.status <> 'pending' then seed.analyst_uuid(seed.analyst_n('rb:' || q.pk)) end,
    case when st.status <> 'pending' then r0.resolved_at end,
    case st.status when 'confirmed' then sg.suggested when 'reclassified' then q.true_type end
  from q
  join seed.stg_customer c
    on c.role = case q.kind when 'MUL' then 'MUL' when 'SIN' then 'SIN' else 'normal' end
   and c.ord_role = case q.kind
         when 'MUL' then (q.seq - 1) % v_mul + 1
         when 'SIN' then (q.seq - 1) % v_sin + 1
         else 1 + floor(seed.h('pc:' || q.pk) * v_normal)::integer end
  cross join lateral (select case
      when q.kind = 'FP_TRAVEL' then 'CLO'
      when q.kind = 'FP_BIG' then case when seed.h('sg:' || q.pk) < 0.5 then 'PHI' else 'ATO' end
      when q.kind = 'FP_INCOME' then case when seed.h('sg:' || q.pk) < 0.5 then 'MUL' else 'LAV' end
      when q.kind = 'FP_NIGHT' then 'CNR'
      when seed.h('sg:' || q.pk) < 0.8 then q.true_type
      else case q.true_type when 'ATO' then 'SIM' when 'PHI' then 'ATO' when 'CLO' then 'CNR'
                            when 'MUL' then 'LAV' when 'LAV' then 'MUL' when 'SIN' then 'CNR'
                            when 'SIM' then 'ATO' else 'CLO' end
    end as suggested) sg
  cross join lateral (select (
      ((p_anchor - make_interval(secs => (176 * power(seed.h('t0:' || q.pk), 1.3) + 0.05) * 86400)) at time zone c.tz)::date
      + make_interval(hours => case when q.kind in ('CNR', 'FP_NIGHT') then seed.hi('hr:' || q.pk, 1, 4)
                                    else seed.hi('hr:' || q.pk, 8, 21) end,
                      mins => seed.hi('mi:' || q.pk, 0, 59))
    ) at time zone c.tz as t0r) t1
  cross join lateral (select case when t1.t0r > p_anchor - interval '40 minutes'
                                  then t1.t0r - interval '1 day' else t1.t0r end as t0) t
  cross join lateral (select t.t0 + make_interval(mins => 3 + seed.hi('gen:' || q.pk, 0, 22)) as generated_at) g
  cross join lateral (select
      g.generated_at + make_interval(secs => 60 * least(greatest(exp(ln(150) + 1.4 * seed.gauss('dl:' || q.pk)), 4), 8640)) as resolved_at,
      case when g.generated_at > p_anchor - interval '21 days' then seed.h('pend:' || q.pk) < 0.85
           else seed.h('pend:' || q.pk) < 0.07 end as pend0) r0
  cross join lateral (select seed.h('act:' || q.pk) as u,
      r0.pend0 or r0.resolved_at > p_anchor - interval '10 minutes' as pend) a
  cross join lateral (select (case
      when a.pend then 'pending'
      when q.is_fp then case when a.u < 0.9 then 'rejected' else 'confirmed' end
      when sg.suggested = q.true_type then case when a.u < 0.95 then 'confirmed' else 'rejected' end
      else case when a.u < 0.85 then 'reclassified' when a.u < 0.95 then 'confirmed' else 'rejected' end
    end)::public.alert_status as status) st;

  -- Synthetic identities are recent customers: 20–75 days before their first alert.
  update seed.stg_customer c
     set since = (x.first_t0 at time zone c.tz)::date - seed.hi('sinsince:' || c.n, 20, 75)
    from (select customer_n, min(t0) as first_t0 from seed.stg_pattern where kind = 'SIN' group by customer_n) x
   where x.customer_n = c.n;
end;
$$;

-- ---------------------------------------------------------------------------------------------
-- Phase 4 · customers into public
-- ---------------------------------------------------------------------------------------------

create or replace function seed.p_customers_insert(p_anchor timestamptz) returns void
language plpgsql
set search_path = public, seed, extensions
as $$
begin
  insert into public.customers (id, document_type, document_number, first_names, last_names,
    birth_date, phone, email, country_code, city_id, occupation, declared_income, income_currency,
    customer_since, segment, risk_level, created_at)
  select c.id, doc.doc_type, doc.doc_number, c.first_names, c.last_names, c.birth_date,
    case c.country
      when 'CO' then '+57 3' || seed.hi('ph1:' || c.n, 0, 2) || seed.hi('ph2:' || c.n, 0, 9) || ' '
                     || lpad(seed.hi('ph3:' || c.n, 0, 999)::text, 3, '0') || ' ' || lpad(seed.hi('ph4:' || c.n, 0, 9999)::text, 4, '0')
      when 'MX' then '+52 ' || seed.pick(array['55','33','81'], 'ph1:' || c.n) || ' '
                     || lpad(seed.hi('ph3:' || c.n, 0, 9999)::text, 4, '0') || ' ' || lpad(seed.hi('ph4:' || c.n, 0, 9999)::text, 4, '0')
      when 'PE' then '+51 9' || lpad(seed.hi('ph2:' || c.n, 0, 99)::text, 2, '0') || ' '
                     || lpad(seed.hi('ph3:' || c.n, 0, 999)::text, 3, '0') || ' ' || lpad(seed.hi('ph4:' || c.n, 0, 999)::text, 3, '0')
      when 'CL' then '+56 9 ' || lpad(seed.hi('ph3:' || c.n, 0, 9999)::text, 4, '0') || ' ' || lpad(seed.hi('ph4:' || c.n, 0, 9999)::text, 4, '0')
      when 'AR' then '+54 9 11 ' || lpad(seed.hi('ph3:' || c.n, 0, 9999)::text, 4, '0') || '-' || lpad(seed.hi('ph4:' || c.n, 0, 9999)::text, 4, '0')
      else '+55 11 9' || lpad(seed.hi('ph3:' || c.n, 0, 9999)::text, 4, '0') || '-' || lpad(seed.hi('ph4:' || c.n, 0, 9999)::text, 4, '0')
    end,
    lower(seed.plain(split_part(c.first_names, ' ', 1))) || '.' || lower(seed.plain(split_part(c.last_names, ' ', 1)))
      || (c.n % 89 + 1) || '@'
      || case c.country
           when 'BR' then seed.pick(array['gmail.com','hotmail.com','outlook.com','yahoo.com.br','uol.com.br'], 'em:' || c.n)
           when 'MX' then seed.pick(array['gmail.com','hotmail.com','outlook.com','yahoo.com.mx'], 'em:' || c.n)
           else seed.pick(array['gmail.com','hotmail.com','outlook.com','yahoo.com'], 'em:' || c.n) end,
    c.country, c.city_id,
    case when c.segment in ('small_business', 'corporate')
         then seed.pick(array['Empresario(a)','Comerciante','Representante legal','Gerente general'], 'oc:' || c.n)
         when c.segment = 'premium'
         then seed.pick(array['Médico(a)','Abogado(a)','Ingeniero(a)','Gerente','Arquitecto(a)','Consultor(a)'], 'oc:' || c.n)
         else seed.pick(array['Docente','Vendedor(a)','Conductor(a)','Estudiante','Enfermero(a)','Técnico(a)',
                              'Auxiliar administrativo','Comerciante','Independiente','Operario(a)','Contador(a)',
                              'Diseñador(a)','Mesero(a)','Cajero(a)'], 'oc:' || c.n) end,
    c.income, c.currency, c.since, c.segment,
    case when c.role <> 'normal' then 'high'::public.risk_level
         else seed.wpick(array['low','medium','high']::public.risk_level[], array[72,21,7]::float8[], 'risk:' || c.n) end,
    c.since::timestamptz + interval '10 hours'
  from seed.stg_customer c
  cross join lateral seed.document(c.country, c.segment, c.n, c.first_names, c.last_names,
                                   c.birth_date, c.female) doc
  order by c.n;
end;
$$;

-- ---------------------------------------------------------------------------------------------
-- Phase 5 · accounts and cards
-- ---------------------------------------------------------------------------------------------

create or replace function seed.p_accounts(p_anchor timestamptz) returns void
language plpgsql
set search_path = public, seed, extensions
as $$
begin
  -- Own accounts: 1–3 per customer.
  insert into seed.stg_account (id, kind, customer_n, j, type, currency, cidx, bank_id, number, holder,
    opened_on, credit_limit, buffer)
  select seed.uid('account:' || c.n || ':' || j), 'normal', c.n, j, t.type, c.currency, c.cidx, c.cidx,
    seed.account_number(c.cidx, c.cidx, c.n * 10 + j, 'an:' || c.n || ':' || j),
    c.full_name,
    case when j = 1 then c.since
         when c.role = 'SIN' then c.since + 2 + j
         else c.since + seed.hi('op:' || c.n || ':' || j, 0, greatest((p_anchor::date - 30) - c.since, 0)) end,
    case when t.type = 'credit'
         then seed.sig(c.income * case when c.role = 'SIN' then 3 + 2 * seed.h('cl:' || c.n)
                                       else 1.5 + 2.5 * seed.h('cl:' || c.n) end::numeric) end,
    0
  from seed.stg_customer c
  cross join lateral generate_series(1, c.n_accounts) j
  cross join lateral (select (case j
      when 1 then case when c.segment in ('small_business', 'corporate') then 'checking' else 'savings' end
      when 2 then c.t2::text
      else case when c.t2 = 'credit' then 'wallet' else 'credit' end
    end)::public.account_type as type) t;

  -- Mule accounts: opened 8–45 days before the money starts moving.
  insert into seed.stg_account (id, kind, customer_n, j, type, currency, cidx, bank_id, number, holder,
    opened_on, credit_limit, buffer)
  select seed.uid('mule:' || p.pk), 'mule', c.n, null,
    case when seed.h('mt:' || p.pk) < 0.5 then 'wallet' else 'savings' end::public.account_type,
    c.currency, c.cidx, c.cidx,
    seed.account_number(c.cidx, c.cidx, 500000 + p.seq, 'mule:' || p.pk),
    c.full_name,
    (p.t0 at time zone c.tz)::date - seed.hi('mo:' || p.pk, 8, 45),
    null, 0
  from seed.stg_pattern p join seed.stg_customer c on c.n = p.customer_n
  where p.kind = 'MUL';

  -- Counterparties at other banks: 120 per country, people and companies.
  insert into seed.stg_account (id, kind, customer_n, j, type, currency, cidx, bank_id, number, holder,
    opened_on, credit_limit, buffer)
  select seed.uid('external:' || e), 'external', null, null,
    case when seed.h('et:' || e) < 0.6 then 'savings' else 'checking' end::public.account_type,
    k.currency, k.idx, 6 + (k.idx - 1) * 3 + seed.hi('eb:' || e, 1, 3),
    seed.account_number(k.idx, 6 + (k.idx - 1) * 3 + seed.hi('eb:' || e, 1, 3), 300000 + e, 'ext:' || e),
    case when seed.h('ec:' || e) < 0.25
      then seed.pick(array['Inversiones','Comercializadora','Distribuidora','Servicios','Inmobiliaria',
                           'Importadora','Constructora','Soluciones'], 'ecp:' || e)
           || ' ' || seed.pick(seed.last_names(k.code = 'BR'), 'ecl:' || e) || ' '
           || case k.code when 'CO' then 'S.A.S.' when 'MX' then 'S.A. de C.V.' when 'PE' then 'S.A.C.'
                          when 'CL' then 'SpA' when 'AR' then 'S.R.L.' else 'Ltda.' end
      else seed.pick(seed.first_names(k.code = 'BR', seed.h('es:' || e) < 0.5), 'efn:' || e) || ' '
           || seed.pick(seed.last_names(k.code = 'BR'), 'eln:' || e) || ' '
           || seed.pick(seed.last_names(k.code = 'BR'), 'eln2:' || e) end,
    date '2012-01-01' + seed.hi('eo:' || e, 0, 4500), null, 0
  from generate_series(1, 720) e
  join seed.k_country k on k.idx = (e - 1) / 120 + 1;

  -- Opening balance on top of the lowest point the ledger reaches.
  update seed.stg_account a
     set buffer = seed.sig(case
         when a.kind = 'mule' then c.income * 0.03
         when a.type = 'credit' then a.credit_limit * (0.5 + 0.5 * seed.h('buf:' || a.id))::numeric
         else c.income * (0.3 + 2.5 * seed.h('buf:' || a.id))::numeric end)
    from seed.stg_customer c
   where c.n = a.customer_n;

  -- Which account each alert is about.
  update seed.stg_pattern p
     set account_id = case p.kind
         when 'MUL' then seed.uid('mule:' || p.pk)
         when 'SIN' then (select a.id from seed.stg_account a
                           where a.customer_n = p.customer_n and a.kind = 'normal' and a.type = 'credit'
                           order by a.j limit 1)
         else c.acc1 end
    from seed.stg_customer c
   where c.n = p.customer_n;

  insert into public.accounts (id, number, type, currency_code, bank_id, is_external, customer_id,
    holder_name, balance, credit_limit, status, opened_on, created_at)
  select a.id, a.number, a.type, a.currency, a.bank_id, a.kind = 'external', c.id, a.holder, null,
    a.credit_limit, 'active', a.opened_on, a.opened_on::timestamptz + interval '11 hours'
  from seed.stg_account a
  left join seed.stg_customer c on c.n = a.customer_n
  order by a.kind, a.customer_n, a.j, a.id;

  -- Cards: credit accounts always, savings/checking 80 % (always for card-fraud victims), mules 60 %.
  insert into public.cards (id, account_id, customer_id, type, network, bin, last4, status,
    credit_limit, issued_on, expires_on)
  select seed.uid('card:' || a.id), a.id, c.id,
    case when a.type = 'credit' then 'credit' else 'debit' end::public.card_type,
    nw.network,
    case nw.network
      when 'Visa' then '4' || lpad(seed.hi('bin:' || a.id, 0, 99999)::text, 5, '0')
      when 'Mastercard' then '5' || seed.hi('bin1:' || a.id, 1, 5) || lpad(seed.hi('bin:' || a.id, 0, 9999)::text, 4, '0')
      when 'American Express' then '37' || lpad(seed.hi('bin:' || a.id, 0, 9999)::text, 4, '0')
      else seed.pick(array['636368','504175','509048'], 'bin:' || a.id) end,
    lpad(seed.hi('l4:' || a.id, 0, 9999)::text, 4, '0'),
    'active', a.credit_limit, iss.d, (iss.d + interval '5 years')::date
  from seed.stg_account a
  join seed.stg_customer c on c.n = a.customer_n
  cross join lateral (select case
      when c.country = 'BR' and a.type = 'credit' then seed.wpick(array['Visa','Mastercard','Elo','American Express'], array[35,35,20,10]::float8[], 'nw:' || a.id)
      when c.country = 'BR' then seed.wpick(array['Visa','Mastercard','Elo'], array[35,35,30]::float8[], 'nw:' || a.id)
      when a.type = 'credit' then seed.wpick(array['Visa','Mastercard','American Express'], array[45,40,15]::float8[], 'nw:' || a.id)
      else seed.wpick(array['Visa','Mastercard'], array[55,45]::float8[], 'nw:' || a.id) end as network) nw
  cross join lateral (select least(greatest(a.opened_on, p_anchor::date - 1600 + seed.hi('iss:' || a.id, 0, 1400)),
                                   p_anchor::date - 7) as d) iss
  where a.kind <> 'external'
    and (a.type = 'credit'
         or (a.kind = 'mule' and seed.h('hascard:' || a.id) < 0.6)
         or (a.kind = 'normal' and a.type in ('savings', 'checking')
             and (seed.h('hascard:' || a.id) < 0.8
                  or (a.j = 1 and exists (select 1 from seed.stg_pattern p
                                           where p.customer_n = a.customer_n
                                             and p.kind in ('CLO', 'CNR', 'FP_TRAVEL', 'FP_NIGHT'))))))
  order by a.customer_n, a.j;

  update seed.stg_account a set card_id = cd.id
    from public.cards cd where cd.account_id = a.id;
end;
$$;

-- ---------------------------------------------------------------------------------------------
-- Phase 6 · devices, ATMs, merchants and the pick pools
-- ---------------------------------------------------------------------------------------------

create or replace function seed.p_devices_merchants(p_anchor timestamptz) returns void
language plpgsql
set search_path = public, seed, extensions
as $$
begin
  insert into public.devices (id, fingerprint, type, brand, model, os, os_version, created_at)
  select seed.uid('device:' || c.n || ':' || d), md5('fp:' || c.n || ':' || d),
    (case d when 1 then 'mobile' when 2 then 'desktop' else 'tablet' end)::public.device_type,
    split_part(sp.spec, '|', 1), split_part(sp.spec, '|', 2), split_part(sp.spec, '|', 3), split_part(sp.spec, '|', 4),
    greatest(c.since, p_anchor::date - 900)::timestamptz + interval '12 hours'
  from seed.stg_customer c
  cross join lateral generate_series(1, c.n_devices) d
  cross join lateral (select seed.pick(seed.device_specs(case d when 1 then 'mobile' when 2 then 'desktop' else 'tablet' end),
                                       'dm:' || c.n || ':' || d) as spec) sp
  order by c.n, d;

  insert into public.customer_devices (customer_id, device_id, first_seen_at, last_seen_at, is_trusted)
  select c.id, seed.uid('device:' || c.n || ':' || d), f.first_seen,
    greatest(f.first_seen + interval '1 hour', p_anchor - make_interval(hours => seed.hi('ls:' || c.n || ':' || d, 1, 400))),
    true
  from seed.stg_customer c
  cross join lateral generate_series(1, c.n_devices) d
  cross join lateral (select greatest(c.since, p_anchor::date - 900)::timestamptz + interval '12 hours' as first_seen) f;

  -- Two ATMs per city.
  insert into public.devices (id, fingerprint, type, brand, model, os, os_version, created_at)
  select seed.uid('atm:' || ci.id || ':' || k), 'ATM-' || lpad(ci.id::text, 2, '0') || '-' || k, 'atm',
    split_part(sp.spec, '|', 1), split_part(sp.spec, '|', 2), 'Windows', '10 IoT', p_anchor - interval '3 years'
  from public.cities ci
  cross join generate_series(1, 2) k
  cross join lateral (select seed.pick(array['NCR|SelfServ 84','Diebold Nixdorf|DN Series 200','Hyosung|MoniMax 8600'],
                                       'atm:' || ci.id || ':' || k) as spec) sp
  order by ci.id, k;

  -- 720 merchants, spread over the countries like the customers.
  insert into seed.stg_merchant (id, m, cidx, city_id, mcc, is_online, name, lat, lng, grp)
  select seed.uid('merchant:' || x.m), x.m, r.idx,
    case when o.online then null else ci.city end,
    mc.mcc, o.online, seed.merchant_name(mc.mcc, r.idx = 6, 'mn:' || x.m),
    case when o.online then null else round(cy.latitude + (seed.h('mla:' || x.m) - 0.5)::numeric * 0.08, 6) end,
    case when o.online then null else round(cy.longitude + (seed.h('mlo:' || x.m) - 0.5)::numeric * 0.08, 6) end,
    case when mc.mcc in ('4900', '4814', '8220') then 'util'
         when mc.mcc in ('5944', '6051', '7995', '4829', '5967', '5732') then 'risk'
         else 'retail' end
  from generate_series(1, 720) x(m)
  join (values (1, 1, 200), (2, 201, 360), (3, 361, 460), (4, 461, 550), (5, 551, 635), (6, 636, 720))
       r(idx, m_from, m_to) on x.m between r.m_from and r.m_to
  cross join lateral (select seed.wpick(
      array['5411','5812','5541','5311','5732','5999','4111','4121','4814','4900','5912','5651',
            '7011','4511','5944','6051','7995','4829','5967','5815','8220','5200'],
      array[14,14,8,5,5,6,3,5,4,4,6,6,3,2,2,2,2,2,2,3,2,3]::float8[], 'mcc:' || x.m) as mcc) mc
  cross join lateral (select case
      when mc.mcc in ('5967', '5815') then true
      when mc.mcc in ('5732', '4511', '7011', '7995', '6051', '4829') then seed.h('onl:' || x.m) < 0.5
      when mc.mcc in ('4814', '4900', '8220') then seed.h('onl:' || x.m) < 0.3
      else seed.h('onl:' || x.m) < 0.04 end as online) o
  cross join lateral (select (r.idx - 1) * 6 + case when seed.h('mc:' || x.m) < 0.35 then 1 else 1 + x.m % 6 end as city) ci
  join public.cities cy on cy.id = ci.city;

  insert into public.merchants (id, name, mcc, country_code, city_id, is_online, latitude, longitude)
  select m.id, m.name, m.mcc, k.code, m.city_id, m.is_online, m.lat, m.lng
  from seed.stg_merchant m join seed.k_country k on k.idx = m.cidx
  order by m.m;

  insert into seed.stg_pool (scope, key, ids)
  select 'retail_city', city_id, array_agg(id order by m) from seed.stg_merchant where not is_online and grp = 'retail' group by city_id
  union all
  select 'phys_city', city_id, array_agg(id order by m) from seed.stg_merchant where not is_online group by city_id
  union all
  select 'phys_c', cidx, array_agg(id order by m) from seed.stg_merchant where not is_online group by cidx
  union all
  select 'risk_phys_c', cidx, array_agg(id order by m) from seed.stg_merchant where not is_online and grp = 'risk' group by cidx
  union all
  select 'online_c', cidx, array_agg(id order by m) from seed.stg_merchant where is_online group by cidx
  union all
  select 'online_risk_c', cidx, array_agg(id order by m) from seed.stg_merchant
   where is_online and mcc in ('5967', '5732', '7995', '6051', '4511', '4829') group by cidx
  union all
  select 'util_c', cidx, array_agg(id order by m) from seed.stg_merchant where grp = 'util' group by cidx
  union all
  select 'stream_c', cidx, array_agg(id order by m) from seed.stg_merchant where mcc = '5815' group by cidx
  union all
  select 'air_c', cidx, array_agg(id order by m) from seed.stg_merchant where mcc = '4511' group by cidx
  union all
  select 'ext_c', cidx, array_agg(id order by id) from seed.stg_account where kind = 'external' group by cidx
  union all
  select 'prim_c', cidx, array_agg(id order by id) from seed.stg_account where kind = 'normal' and j = 1 group by cidx;
end;
$$;

create or replace function seed.pool_pick(p_scope text, p_key integer, p_seed text) returns uuid
language sql stable
as $$
  select p.ids[1 + floor(seed.h(p_seed) * cardinality(p.ids))::integer]
  from seed.stg_pool p where p.scope = p_scope and p.key = p_key
$$;

-- ---------------------------------------------------------------------------------------------
-- Phase 7 · everyday security events
-- ---------------------------------------------------------------------------------------------

create or replace function seed.p_security_events(p_anchor timestamptz) returns void
language plpgsql
set search_path = public, seed, extensions
as $$
begin
  insert into public.security_events (id, customer_id, type, occurred_at, device_id, channel_code, ip,
    city_id, latitude, longitude, succeeded, details)
  select seed.uid('sec:' || c.n || ':' || i), c.id, ty.t, tm.at,
    seed.uid('device:' || c.n || ':' || dv.d),
    case when dv.d = 1 then 'APP' else 'WEB' end,
    seed.ip(c.cidx, c.ip_b, 'sip:' || c.n || ':' || i),
    c.city_id,
    round(ci.latitude + (seed.h('sla:' || c.n || ':' || i) - 0.5)::numeric * 0.06, 6),
    round(ci.longitude + (seed.h('slo:' || c.n || ':' || i) - 0.5)::numeric * 0.06, 6),
    ty.t <> 'login_failed',
    case when dv.d = 1 then jsonb_build_object('app_version', '5.' || seed.hi('av:' || c.n, 8, 14) || '.' || seed.hi('av2:' || c.n, 0, 9))
         else jsonb_build_object('navegador', seed.pick(array['Chrome 130','Edge 130','Safari 18','Firefox 132'], 'nav:' || c.n)) end
    || case when ty.t = 'login_failed' then jsonb_build_object('motivo', 'Contraseña incorrecta') else '{}'::jsonb end
  from seed.stg_customer c
  join public.cities ci on ci.id = c.city_id
  cross join lateral generate_series(1, seed.hi('nsec:' || c.n, 8, 20)) i
  cross join lateral (select seed.wpick(
      array['login','login_failed','logout','password_change','phone_change','email_change']::public.security_event_type[],
      array[80, 7, 10, 1.5, 0.7, 0.8]::float8[], 'st:' || c.n || ':' || i) as t) ty
  cross join lateral (select greatest(p_anchor - interval '180 days', c.since::timestamptz + interval '1 day') as ws) w
  cross join lateral (select w.ws + (p_anchor - w.ws) * seed.h('sat:' || c.n || ':' || i) as at) tm
  cross join lateral (select case when c.n_devices >= 2 and seed.h('sd:' || c.n || ':' || i) < 0.3 then 2 else 1 end as d) dv
  where w.ws < p_anchor
  order by tm.at;
end;
$$;

create or replace function seed.add_sec(p_key text, p_customer uuid, p_type public.security_event_type,
  p_at timestamptz, p_device uuid, p_channel text, p_ip inet, p_city integer, p_ok boolean, p_details jsonb)
returns void
language sql
as $$
  insert into public.security_events (id, customer_id, type, occurred_at, device_id, channel_code, ip,
    city_id, latitude, longitude, succeeded, details)
  select seed.uid('sec:' || p_key), p_customer, p_type, p_at, p_device, p_channel, p_ip, p_city,
    round(ci.latitude + (seed.h(p_key || ':la') - 0.5)::numeric * 0.06, 6),
    round(ci.longitude + (seed.h(p_key || ':lo') - 0.5)::numeric * 0.06, 6),
    p_ok, p_details
  from (select 1) one left join public.cities ci on ci.id = p_city
$$;

-- ---------------------------------------------------------------------------------------------
-- Phase 8 · everyday transactions (staged; ids are assigned in chronological order later)
-- ---------------------------------------------------------------------------------------------

create or replace function seed.p_transactions(p_anchor timestamptz) returns void
language plpgsql
set search_path = public, seed, extensions
as $$
begin
  insert into seed.stg_tx (k, occurred_at, type, channel_code, amount, currency_code,
    source_account_id, destination_account_id, card_id, merchant_id, device_id, ip, city_id,
    latitude, longitude, status, description)
  select kk.k, tm.at, ty.t, ch.ch, am.amount, a.currency,
    cp.src, cp.dst,
    case when ty.t in ('purchase', 'withdrawal') then a.card_id end,
    mer.merchant_id,
    case when ch.ch in ('POS', 'PAYROLL') or ty.t = 'debit' then null
         when ch.ch = 'ATM' then seed.uid('atm:' || loc.city || ':' || seed.hi(kk.k || ':atm', 1, 2))
         else seed.uid('device:' || c.n || ':' || case when ch.ch in ('WEB', 'PSE') and c.n_devices >= 2 then 2 else 1 end) end,
    case when ch.ch in ('POS', 'ATM', 'PAYROLL') or ty.t = 'debit' then null else seed.ip(c.cidx, c.ip_b, kk.k) end,
    case when ty.t = 'debit' then null else coalesce(m.city_id, loc.city) end,
    case when ty.t = 'debit' then null else coalesce(m.lat, round(ci.latitude + (seed.h(kk.k || ':la') - 0.5)::numeric * 0.06, 6)) end,
    case when ty.t = 'debit' then null else coalesce(m.lng, round(ci.longitude + (seed.h(kk.k || ':lo') - 0.5)::numeric * 0.06, 6)) end,
    st.status,
    case ty.t
      when 'withdrawal' then 'Retiro en cajero'
      when 'purchase' then 'Compra ' || m.name
      when 'payment' then 'Pago ' || m.name
      when 'debit' then case when a.type = 'credit'
          then seed.pick(array['Intereses tarjeta de crédito','Cuota de manejo','Seguro de tarjeta'], kk.k || ':d')
          else seed.pick(array['Cuota de manejo','Comisión por servicio','Débito automático seguro de vida','Comisión transferencia'], kk.k || ':d') end
    end
  from seed.stg_account a
  join seed.stg_customer c on c.n = a.customer_n
  join seed.k_country kc on kc.idx = a.cidx
  cross join lateral (select greatest(p_anchor - interval '180 days', (a.opened_on + 1)::timestamptz) as ws) w
  cross join lateral (select ceil(
      (case a.type when 'credit' then seed.hi('ntx:' || a.id, 5, 14)
                   when 'wallet' then seed.hi('ntx:' || a.id, 6, 18)
                   else seed.hi('ntx:' || a.id, 10, 26) + floor(3 * ln(c.sm))::integer end)
      * least(1.0, extract(epoch from p_anchor - w.ws) / (180 * 86400.0)))::integer as cnt) nc
  cross join lateral generate_series(1, nc.cnt) i
  cross join lateral (select 'tx:' || a.id || ':' || i as k) kk
  cross join lateral (select w.ws + (p_anchor - w.ws) * seed.h(kk.k || ':t') as raw) tr
  cross join lateral (select seed.h(kk.k || ':hh') as u) hh
  cross join lateral (select ((tr.raw at time zone c.tz)::date + make_interval(
      hours => case when hh.u < 0.05 then seed.hi(kk.k || ':h', 0, 5)
                    when hh.u < 0.20 then seed.hi(kk.k || ':h', 6, 8)
                    when hh.u < 0.85 then seed.hi(kk.k || ':h', 9, 19)
                    else seed.hi(kk.k || ':h', 20, 23) end,
      mins => seed.hi(kk.k || ':m', 0, 59), secs => seed.hi(kk.k || ':s', 0, 59))) at time zone c.tz as at0) t0
  cross join lateral (select case when t0.at0 > p_anchor then t0.at0 - interval '1 day' else t0.at0 end as at) tm
  cross join lateral (select case a.type
      when 'credit' then seed.wpick(array['purchase','debit']::public.transaction_type[], array[88,12]::float8[], kk.k || ':ty')
      when 'wallet' then seed.wpick(array['transfer','purchase','payment','credit']::public.transaction_type[],
                                    array[45, case when a.card_id is null then 0 else 25 end, 15, 15]::float8[], kk.k || ':ty')
      else seed.wpick(array['purchase','transfer','withdrawal','payment','credit','debit']::public.transaction_type[],
                      array[case when a.card_id is null then 0 else 38 end, 24, 14, 14,
                            case when c.segment in ('small_business', 'corporate') then 20 else 7 end, 4]::float8[],
                      kk.k || ':ty') end as t) ty
  cross join lateral (select
      case when seed.h(kk.k || ':loc') < 0.85 then c.city_id else (c.cidx - 1) * 6 + seed.hi(kk.k || ':oc', 1, 6) end as city,
      seed.h(kk.k || ':on') < case when a.type = 'credit' then 0.3 else 0.15 end as online) loc
  join public.cities ci on ci.id = loc.city
  cross join lateral (select case
      when ty.t = 'purchase' and loc.online then seed.pool_pick('online_c', c.cidx, kk.k || ':m')
      when ty.t = 'purchase' then coalesce(seed.pool_pick('retail_city', loc.city, kk.k || ':m'),
                                           seed.pool_pick('phys_c', c.cidx, kk.k || ':m'))
      when ty.t = 'payment' then seed.pool_pick('util_c', c.cidx, kk.k || ':m')
    end as merchant_id) mer
  left join seed.stg_merchant m on m.id = mer.merchant_id
  cross join lateral (select case ty.t
      when 'purchase' then case when m.is_online then case when seed.h(kk.k || ':ch') < 0.6 then 'WEB' else 'APP' end else 'POS' end
      when 'withdrawal' then 'ATM'
      when 'transfer' then seed.rail(kc.code, kk.k || ':ch')
      when 'payment' then seed.pay_channel(kc.code, kk.k || ':ch')
      when 'credit' then seed.rail(kc.code, kk.k || ':ch')
      else 'WEB' end as ch) ch
  cross join lateral (select case when seed.h(kk.k || ':cp') < 0.65
                                  then seed.pool_pick('ext_c', c.cidx, kk.k || ':x')
                                  else seed.pool_pick('prim_c', c.cidx, kk.k || ':x') end as other) o0
  cross join lateral (select case when o0.other = a.id then seed.pool_pick('ext_c', c.cidx, kk.k || ':x2')
                                  else o0.other end as other) o
  cross join lateral (select
      case ty.t when 'credit' then case when seed.h(kk.k || ':cs') < 0.85 then o.other end else a.id end as src,
      case ty.t when 'transfer' then o.other when 'credit' then a.id end as dst) cp
  cross join lateral (select seed.gauss(kk.k || ':a') as g) gg
  cross join lateral (select case ty.t
      when 'purchase' then seed.amt(least(28000 * exp(0.85 * gg.g) * sqrt(c.sm), 4500000), a.currency, 'exact')
      when 'transfer' then seed.amt(least(180000 * exp(0.9 * gg.g) * power(c.sm, 0.7), 30000000), a.currency, 'nice')
      when 'withdrawal' then seed.amt((array[50000,100000,150000,200000,300000,400000,500000,700000,1000000])[seed.hi(kk.k || ':w', 1, 9)]
                                      * power(c.sm, 0.3), a.currency, 'cash')
      when 'payment' then seed.amt(70000 * exp(0.6 * gg.g) * power(c.sm, 0.4), a.currency, 'exact')
      when 'credit' then seed.amt(least(220000 * exp(0.9 * gg.g) * power(c.sm, 0.7), 60000000), a.currency, 'nice')
      else seed.amt(9000 + 40000 * seed.h(kk.k || ':f'), a.currency, 'exact') end as amount) am
  cross join lateral (select (case
      when tm.at > p_anchor - interval '2 days' and seed.h(kk.k || ':st') < 0.12 then 'pending'
      else seed.wpick(array['approved','declined','reversed'], array[94.2, 4.6, 1.2]::float8[], kk.k || ':st2') end
    )::public.transaction_status as status) st
  where a.kind in ('normal', 'mule')
    and w.ws < p_anchor - interval '2 days';

  -- Payroll: monthly salary into the main account of people (not companies).
  insert into seed.stg_tx (k, occurred_at, type, channel_code, amount, currency_code,
    source_account_id, destination_account_id, status, description, reference)
  select 'pay:' || c.n || ':' || mo, pt.at, 'credit', 'PAYROLL',
    round(c.income * (0.97 + 0.06 * seed.h('pa:' || c.n || ':' || mo))::numeric, kcur.decimals),
    c.currency, null, c.acc1, 'approved',
    'Abono nómina ' || seed.pick(case when c.country = 'BR'
      then array['Comercial Paulista Ltda.','Construtora Horizonte','Hospital Santa Clara','Tecnologia Araucária',
                 'Transportes União','Alimentos do Vale','Escola São José','Prefeitura Municipal']
      else array['Grupo Andino S.A.','Comercializadora del Valle','Servicios Integrales Atlas','Distribuidora La Montaña',
                 'Constructora Horizonte','Clínica Santa María','Colegio San José','Logística Express','Alimentos del Sur',
                 'Tecnología Cóndor','Transportes Unidos','Hotel Plaza Central','Universidad del Pacífico',
                 'Alcaldía Municipal','Laboratorios Vida'] end, 'emp:' || c.n),
    'NOM-' || upper(substr(md5('pay:' || c.n || ':' || mo), 1, 10))
  from seed.stg_customer c
  join seed.stg_account a on a.id = c.acc1
  join seed.k_currency kcur on kcur.code = c.currency
  cross join generate_series(0, 6) mo
  cross join lateral (select ((date_trunc('month', p_anchor at time zone c.tz) - make_interval(months => mo))::date
      + case when seed.h('pd:' || c.n) < 0.3 then 14 else 27 end
      + make_interval(hours => 6, mins => seed.hi('pm:' || c.n || ':' || mo, 0, 59))) at time zone c.tz as at) pt
  where c.segment in ('retail', 'retail_mid_income', 'premium')
    and c.role = 'normal'
    and pt.at between greatest(p_anchor - interval '180 days', (a.opened_on + 1)::timestamptz) and p_anchor;

  -- Credit card payments from the main account, once a month.
  insert into seed.stg_tx (k, occurred_at, type, channel_code, amount, currency_code,
    source_account_id, destination_account_id, device_id, ip, city_id, latitude, longitude,
    status, description, reference)
  select 'ccp:' || a.id || ':' || mo, pt.at, 'payment', 'APP',
    seed.amt_local(c.income * (0.08 + 0.3 * seed.h('ccp:' || a.id || ':' || mo))::numeric, c.currency, 'exact'),
    c.currency, c.acc1, a.id, seed.uid('device:' || c.n || ':1'),
    seed.ip(c.cidx, c.ip_b, 'ccp:' || a.id || ':' || mo), c.city_id,
    round(ci.latitude + (seed.h('ccpla:' || a.id || mo) - 0.5)::numeric * 0.06, 6),
    round(ci.longitude + (seed.h('ccplo:' || a.id || mo) - 0.5)::numeric * 0.06, 6),
    'approved', 'Pago tarjeta de crédito', 'APP-' || upper(substr(md5('ccp:' || a.id || ':' || mo), 1, 10))
  from seed.stg_account a
  join seed.stg_customer c on c.n = a.customer_n
  join public.cities ci on ci.id = c.city_id
  cross join generate_series(0, 5) mo
  cross join lateral (select ((date_trunc('month', p_anchor at time zone c.tz) - make_interval(months => mo))::date
      + seed.hi('ccd:' || a.id, 4, 11) + make_interval(hours => seed.hi('cch:' || a.id || mo, 8, 21))) at time zone c.tz as at) pt
  where a.kind = 'normal' and a.type = 'credit' and c.acc1 <> a.id and c.role = 'normal'
    and pt.at between greatest(p_anchor - interval '180 days', (a.opened_on + 1)::timestamptz) and p_anchor - interval '1 hour';

  -- Companies receive payments from their clients.
  insert into seed.stg_tx (k, occurred_at, type, channel_code, amount, currency_code,
    source_account_id, destination_account_id, status, description, reference)
  select 'biz:' || c.n || ':' || i, p_anchor - make_interval(secs => 180 * 86400 * seed.h('bt:' || c.n || ':' || i)),
    'credit', seed.rail(c.country, 'bch:' || c.n || ':' || i),
    seed.amt(least(900000 * exp(0.8 * seed.gauss('ba:' || c.n || ':' || i)) * c.sm, 120000000), c.currency, 'nice'),
    c.currency, seed.pool_pick('ext_c', c.cidx, 'bs:' || c.n || ':' || i), c.acc1, 'approved',
    'Pago factura ' || seed.hi('bf:' || c.n || ':' || i, 1000, 9999),
    'FAC-' || upper(substr(md5('biz:' || c.n || ':' || i), 1, 10))
  from seed.stg_customer c
  join seed.stg_account a on a.id = c.acc1
  cross join lateral generate_series(1, seed.hi('nb:' || c.n, 8, 25)) i
  where c.segment in ('small_business', 'corporate')
    and p_anchor - make_interval(secs => 180 * 86400 * seed.h('bt:' || c.n || ':' || i)) > a.opened_on + 1;
end;
$$;

-- Staged transaction helper used by the patterns.
create or replace function seed.add_tx(p_k text, p_at timestamptz, p_type public.transaction_type,
  p_channel text, p_amount numeric, p_currency text, p_src uuid, p_dst uuid, p_card uuid,
  p_merchant uuid, p_device uuid, p_ip inet, p_city integer, p_status public.transaction_status,
  p_description text, p_pattern text)
returns void
language sql
as $$
  insert into seed.stg_tx (k, occurred_at, type, channel_code, amount, currency_code,
    source_account_id, destination_account_id, card_id, merchant_id, device_id, ip, city_id,
    latitude, longitude, status, description, reference, pattern_k)
  select p_k, p_at, p_type, p_channel, p_amount, p_currency, p_src, p_dst, p_card, p_merchant,
    p_device, p_ip, coalesce(m.city_id, p_city),
    coalesce(m.lat, round(ci.latitude + (seed.h(p_k || ':la') - 0.5)::numeric * 0.06, 6)),
    coalesce(m.lng, round(ci.longitude + (seed.h(p_k || ':lo') - 0.5)::numeric * 0.06, 6)),
    p_status, p_description,
    case when p_type in ('transfer', 'payment', 'credit') and p_channel not in ('ATM', 'PAYROLL')
         then p_channel || '-' || upper(substr(md5(p_k), 1, 10)) end,
    p_pattern
  from (select 1) one
  left join seed.stg_merchant m on m.id = p_merchant and not m.is_online
  left join public.cities ci on ci.id = coalesce(m.city_id, p_city)
$$;

-- ---------------------------------------------------------------------------------------------
-- Phase 9 · injected patterns (transactions, security events, fraud devices)
-- ---------------------------------------------------------------------------------------------

create or replace function seed.p_patterns(p_anchor timestamptz) returns void
language plpgsql
set search_path = public, seed, extensions
as $$
declare
  p record;
  c record;
  a record;
  v_k text;
  v_n integer;
  v_out integer;
  v_i integer;
  v_t timestamptz;
  v_start timestamptz;
  v_amt numeric;
  v_sum numeric;
  v_target numeric;
  v_thr numeric;
  v_dev uuid;
  v_home_dev uuid;
  v_spec text;
  v_far integer;
  v_far_c integer;
  v_ext uuid;
  v_merchant uuid;
  v_online boolean;
  v_ctx jsonb;
  v_w double precision[];
  v_wsum double precision;
  v_gap integer;
  v_ch text;
begin
  for p in select * from seed.stg_pattern order by pk loop
    select * into c from seed.stg_customer where n = p.customer_n;
    select * into a from seed.stg_account where id = p.account_id;
    v_k := 'pat:' || p.pk;
    v_ctx := '{}'::jsonb;
    v_home_dev := seed.uid('device:' || c.n || ':1');

    -- Where the anomaly happens: another country for card-present travel, the same country
    -- (another city) otherwise. CNR only uses it for the foreign IP.
    v_far_c := case when (p.kind in ('CLO', 'FP_TRAVEL') and seed.h(v_k || ':fc') < 0.7) or p.kind = 'CNR'
                    then 1 + (c.cidx - 1 + seed.hi(v_k || ':oc', 1, 5)) % 6
                    else c.cidx end;
    v_far := (v_far_c - 1) * 6 + seed.hi(v_k || ':fcity', 1, 6);
    if v_far = c.city_id then
      v_far := (v_far_c - 1) * 6 + c.city_id % 6 + 1;
    end if;

    if p.kind in ('ATO', 'SIM') then
      -- Account takeover / SIM swap: new device, security changes, burst of transfers.
      v_dev := seed.uid('fraud-device:' || p.pk);
      v_spec := seed.pick(seed.device_specs('mobile') || seed.device_specs('desktop'), v_k || ':dev');
      v_n := case p.kind when 'ATO' then seed.hi(v_k || ':n', 3, 6) else seed.hi(v_k || ':n', 2, 4) end;
      v_start := p.t0 - make_interval(mins => (v_n - 1) * 5);

      insert into public.devices (id, fingerprint, type, brand, model, os, os_version, created_at)
      values (v_dev, md5('fraud-fp:' || p.pk),
        (case when split_part(v_spec, '|', 3) in ('Windows', 'macOS') then 'desktop' else 'mobile' end)::public.device_type,
        split_part(v_spec, '|', 1), split_part(v_spec, '|', 2), split_part(v_spec, '|', 3), split_part(v_spec, '|', 4),
        v_start - interval '60 minutes');
      insert into public.customer_devices (customer_id, device_id, first_seen_at, last_seen_at, is_trusted)
      values (c.id, v_dev, v_start - interval '45 minutes', p.t0, false);
      v_ch := case when split_part(v_spec, '|', 3) in ('Windows', 'macOS') then 'WEB' else 'APP' end;

      if p.kind = 'ATO' then
        perform seed.add_sec(v_k || ':s1', c.id, 'login_failed', v_start - interval '38 minutes', v_dev, v_ch,
          seed.ip(v_far_c, null, v_k || ':ip'), v_far, false, '{"motivo": "Contraseña incorrecta"}');
        perform seed.add_sec(v_k || ':s2', c.id, 'login_failed', v_start - interval '36 minutes', v_dev, v_ch,
          seed.ip(v_far_c, null, v_k || ':ip'), v_far, false, '{"motivo": "Contraseña incorrecta"}');
        perform seed.add_sec(v_k || ':s3', c.id, 'login_new_device', v_start - interval '33 minutes', v_dev, v_ch,
          seed.ip(v_far_c, null, v_k || ':ip'), v_far, true, '{"metodo": "Recuperación por correo"}');
        perform seed.add_sec(v_k || ':s4', c.id, 'password_change', v_start - interval '28 minutes', v_dev, v_ch,
          seed.ip(v_far_c, null, v_k || ':ip'), v_far, true, null);
        if seed.h(v_k || ':em') < 0.4 then
          perform seed.add_sec(v_k || ':s5', c.id, 'email_change', v_start - interval '25 minutes', v_dev, v_ch,
            seed.ip(v_far_c, null, v_k || ':ip'), v_far, true, null);
        end if;
        v_ctx := jsonb_build_object('change_at', v_start - interval '28 minutes');
      else
        perform seed.add_sec(v_k || ':s1', c.id, 'sim_change', v_start - interval '55 minutes', null, null, null,
          c.city_id, true, jsonb_build_object('operador', seed.pick(array['Claro','Movistar','Tigo','Entel','Personal','Vivo','Telcel'], v_k || ':op')));
        perform seed.add_sec(v_k || ':s2', c.id, 'phone_change', v_start - interval '47 minutes', v_dev, v_ch,
          seed.ip(v_far_c, null, v_k || ':ip'), v_far, true, null);
        perform seed.add_sec(v_k || ':s3', c.id, 'login_new_device', v_start - interval '40 minutes', v_dev, v_ch,
          seed.ip(v_far_c, null, v_k || ':ip'), v_far, true, '{"metodo": "Código SMS"}');
        v_ctx := jsonb_build_object('change_at', v_start - interval '55 minutes');
      end if;

      for v_i in 1 .. v_n loop
        perform seed.add_tx(v_k || ':' || v_i,
          v_start + make_interval(mins => (v_i - 1) * 5, secs => seed.hi(v_k || ':ts' || v_i, 0, 90)),
          'transfer', case when seed.h(v_k || ':ch' || v_i) < 0.5 then v_ch else seed.rail(c.country, v_k || ':r' || v_i) end,
          seed.amt(1300000 * exp(0.45 * seed.gauss(v_k || ':a' || v_i)) * power(c.sm, 0.6), c.currency, 'nice'),
          c.currency, a.id, seed.pool_pick('ext_c', c.cidx, v_k || ':e' || v_i), null, null, v_dev,
          seed.ip(v_far_c, null, v_k || ':ip'), v_far,
          case when v_i = v_n and seed.h(v_k || ':dec') < 0.35 then 'declined' else 'approved' end::public.transaction_status,
          null, p.pk);
      end loop;
      v_ctx := v_ctx || jsonb_build_object('device', split_part(v_spec, '|', 1) || ' ' || split_part(v_spec, '|', 2),
                                           'far_city', v_far);

    elsif p.kind in ('PHI', 'FP_BIG') then
      -- Phishing: the customer, from their own phone, sends big transfers to a new beneficiary.
      -- FP_BIG: one legitimate big payment that looks the same to the model.
      v_n := case p.kind when 'PHI' then seed.hi(v_k || ':n', 1, 3) else 1 end;
      v_ext := seed.pool_pick('ext_c', c.cidx, v_k || ':e');
      v_start := p.t0 - make_interval(mins => (v_n - 1) * 6);
      perform seed.add_sec(v_k || ':s1', c.id, 'login', v_start - interval '9 minutes', v_home_dev, 'APP',
        seed.ip(c.cidx, c.ip_b, v_k || ':ip'), c.city_id, true, null);
      for v_i in 1 .. v_n loop
        perform seed.add_tx(v_k || ':' || v_i,
          v_start + make_interval(mins => (v_i - 1) * 6, secs => seed.hi(v_k || ':ts' || v_i, 0, 90)),
          'transfer', case when seed.h(v_k || ':ch' || v_i) < 0.5 then 'APP' else seed.rail(c.country, v_k || ':r' || v_i) end,
          case p.kind
            when 'PHI' then seed.amt(2600000 * exp(0.45 * seed.gauss(v_k || ':a' || v_i)) * power(c.sm, 0.6), c.currency, 'nice')
            else seed.amt(12000000 * exp(0.45 * seed.gauss(v_k || ':a' || v_i)) * sqrt(c.sm), c.currency, 'nice') end,
          c.currency, a.id, v_ext, null, null, v_home_dev, seed.ip(c.cidx, c.ip_b, v_k || ':ip'), c.city_id,
          'approved',
          case when p.kind = 'FP_BIG' then seed.pick(array['Pago cuota inicial vehículo','Pago separación apartamento',
            'Pago matrícula universitaria','Compra de vehículo usado','Pago a contratista por remodelación'], v_k || ':d') end,
          p.pk);
      end loop;

    elsif p.kind in ('CLO', 'FP_TRAVEL') then
      -- Cloned card: a normal purchase at home, then card-present purchases far away.
      -- FP_TRAVEL: the customer bought a plane ticket weeks before and is travelling.
      v_n := case p.kind when 'CLO' then seed.hi(v_k || ':n', 3, 7) else seed.hi(v_k || ':n', 2, 4) end;
      v_gap := case p.kind when 'CLO' then 8 else seed.hi(v_k || ':gap', 25, 90) end;
      v_start := p.t0 - make_interval(mins => (v_n - 1) * v_gap);
      if p.kind = 'CLO' then
        v_t := v_start - make_interval(mins => seed.hi(v_k || ':ctx', 35, 95));
        perform seed.add_tx(v_k || ':ctx', v_t, 'purchase', 'POS',
          seed.amt(45000 * exp(0.5 * seed.gauss(v_k || ':ca')), c.currency, 'exact'), c.currency,
          a.id, null, a.card_id,
          coalesce(seed.pool_pick('retail_city', c.city_id, v_k || ':cm'), seed.pool_pick('phys_c', c.cidx, v_k || ':cm')),
          null, null, c.city_id, 'approved', null, null);
        v_ctx := jsonb_build_object('home_at', v_t);
      else
        v_t := p.t0 - make_interval(days => seed.hi(v_k || ':air', 10, 40), hours => seed.hi(v_k || ':airh', 0, 10));
        perform seed.add_tx(v_k || ':air', v_t, 'purchase', 'WEB',
          seed.amt(1800000 * exp(0.3 * seed.gauss(v_k || ':aa')) * sqrt(c.sm), c.currency, 'exact'), c.currency,
          a.id, null, a.card_id,
          coalesce(seed.pool_pick('air_c', c.cidx, v_k || ':am'), seed.pool_pick('online_c', c.cidx, v_k || ':am')),
          v_home_dev, seed.ip(c.cidx, c.ip_b, v_k || ':ip'), c.city_id, 'approved', null, null);
      end if;
      for v_i in 1 .. v_n loop
        perform seed.add_tx(v_k || ':' || v_i,
          v_start + make_interval(mins => (v_i - 1) * v_gap, secs => seed.hi(v_k || ':ts' || v_i, 0, 240)),
          'purchase', 'POS',
          case p.kind
            when 'CLO' then seed.amt(550000 * exp(0.6 * seed.gauss(v_k || ':a' || v_i)) * power(c.sm, 0.4), c.currency, 'exact')
            else seed.amt(110000 * exp(0.6 * seed.gauss(v_k || ':a' || v_i)) * sqrt(c.sm), c.currency, 'exact') end,
          c.currency, a.id, null, a.card_id,
          coalesce(seed.pool_pick('phys_city', v_far, v_k || ':m' || v_i), seed.pool_pick('phys_c', v_far_c, v_k || ':m' || v_i)),
          null, null, v_far,
          case when p.kind = 'CLO' and v_i >= v_n - 1 and seed.h(v_k || ':d' || v_i) < 0.45 then 'declined'
               else 'approved' end::public.transaction_status,
          null, p.pk);
      end loop;
      v_ctx := v_ctx || jsonb_build_object('far_city', v_far);

    elsif p.kind in ('MUL', 'FP_INCOME') then
      -- Mule: many senders in a few days, then most of the money leaves in hours.
      -- FP_INCOME: a seller paid by several clients who then pays a supplier.
      v_n := case p.kind when 'MUL' then seed.hi(v_k || ':n', 5, 12) else seed.hi(v_k || ':n', 4, 8) end;
      v_start := p.t0 - interval '3 hours' - make_interval(days => seed.hi(v_k || ':days', 1, 3));
      v_sum := 0;
      for v_i in 1 .. v_n loop
        v_t := v_start + (p.t0 - interval '3 hours' - v_start) * ((v_i - 1)::double precision / v_n)
               + make_interval(mins => seed.hi(v_k || ':ti' || v_i, 0, 50));
        v_amt := case p.kind
          when 'MUL' then seed.amt(950000 * exp(0.45 * seed.gauss(v_k || ':a' || v_i)), c.currency, 'nice')
          else seed.amt(800000 * exp(0.4 * seed.gauss(v_k || ':a' || v_i)) * sqrt(c.sm), c.currency, 'nice') end;
        perform seed.add_tx(v_k || ':i' || v_i, v_t, 'transfer', seed.rail(c.country, v_k || ':ri' || v_i),
          v_amt, c.currency,
          case when p.kind = 'MUL' and seed.h(v_k || ':src' || v_i) >= 0.7
               then seed.pool_pick('prim_c', c.cidx, v_k || ':s' || v_i)
               else seed.pool_pick('ext_c', c.cidx, v_k || ':s' || v_i) end,
          a.id, null, null, null, null, null, 'approved',
          case when p.kind = 'FP_INCOME' then 'Pago factura ' || seed.hi(v_k || ':f' || v_i, 1000, 9999) end,
          p.pk);
        v_sum := v_sum + v_amt;
      end loop;
      v_out := case p.kind when 'MUL' then seed.hi(v_k || ':out', 1, 3) else 1 end;
      v_target := v_sum * case p.kind when 'MUL' then 0.85 + 0.1 * seed.h(v_k || ':pct')
                                      else 0.4 + 0.2 * seed.h(v_k || ':pct') end::numeric;
      for v_i in 1 .. v_out loop
        v_t := p.t0 - make_interval(mins => (v_out - v_i) * seed.hi(v_k || ':og' || v_i, 15, 40));
        if p.kind = 'MUL' and seed.h(v_k || ':ow' || v_i) < 0.5 then
          perform seed.add_tx(v_k || ':o' || v_i, v_t, 'withdrawal', 'ATM',
            seed.amt_local(v_target / v_out, c.currency, 'cash'), c.currency, a.id, null, a.card_id, null,
            seed.uid('atm:' || c.city_id || ':1'), null, c.city_id, 'approved', 'Retiro en cajero', p.pk);
        else
          perform seed.add_tx(v_k || ':o' || v_i, v_t, 'transfer', seed.rail(c.country, v_k || ':ro' || v_i),
            seed.amt_local(v_target / v_out, c.currency, 'nice'), c.currency, a.id,
            seed.pool_pick('ext_c', c.cidx, v_k || ':oe' || v_i), null, null, v_home_dev,
            seed.ip(c.cidx, c.ip_b, v_k || ':ip'), c.city_id, 'approved',
            case when p.kind = 'FP_INCOME' then 'Pago a proveedor' end, p.pk);
        end if;
      end loop;

    elsif p.kind = 'LAV' then
      -- Structuring: deposits just under the reporting threshold, then one consolidated transfer.
      select report_threshold into v_thr from seed.k_currency where code = c.currency;
      v_n := seed.hi(v_k || ':n', 6, 14);
      v_start := p.t0 - interval '2 hours' - make_interval(days => seed.hi(v_k || ':days', 2, 7));
      v_sum := 0;
      for v_i in 1 .. v_n loop
        v_t := v_start + (p.t0 - interval '2 hours' - v_start) * ((v_i - 1)::double precision / v_n)
               + make_interval(mins => seed.hi(v_k || ':ti' || v_i, 0, 90));
        v_amt := seed.amt_local(v_thr * (0.9 + 0.09 * seed.h(v_k || ':a' || v_i))::numeric, c.currency, 'nice');
        if seed.h(v_k || ':cash' || v_i) < 0.6 then
          perform seed.add_tx(v_k || ':i' || v_i, v_t, 'credit', 'ATM', v_amt, c.currency, null, a.id, a.card_id,
            null, seed.uid('atm:' || c.city_id || ':' || seed.hi(v_k || ':atm' || v_i, 1, 2)), null, c.city_id,
            'approved', 'Depósito en efectivo', p.pk);
        else
          perform seed.add_tx(v_k || ':i' || v_i, v_t, 'credit', seed.rail(c.country, v_k || ':ri' || v_i), v_amt,
            c.currency, seed.pool_pick('ext_c', c.cidx, v_k || ':s' || v_i), a.id, null, null, null, null, null,
            'approved', null, p.pk);
        end if;
        v_sum := v_sum + v_amt;
      end loop;
      perform seed.add_tx(v_k || ':o1', p.t0, 'transfer', seed.rail(c.country, v_k || ':ro'),
        seed.amt_local(v_sum * (0.8 + 0.15 * seed.h(v_k || ':pct'))::numeric, c.currency, 'nice'), c.currency,
        a.id, seed.pool_pick('ext_c', c.cidx, v_k || ':oe'), null, null, v_home_dev,
        seed.ip(c.cidx, c.ip_b, v_k || ':ip'), c.city_id, 'approved', null, p.pk);
      v_ctx := jsonb_build_object('threshold', v_thr);

    elsif p.kind = 'SIN' then
      -- Synthetic identity: a brand-new customer maxes out the credit line in days (bust-out).
      v_n := seed.hi(v_k || ':n', 5, 10);
      v_target := a.credit_limit * (0.92 + 0.07 * seed.h(v_k || ':pct'))::numeric;
      v_w := array(select 0.3 + seed.h(v_k || ':w' || g) from generate_series(1, v_n) g);
      select sum(x) into v_wsum from unnest(v_w) x;
      v_start := p.t0 - make_interval(days => seed.hi(v_k || ':days', 4, 12));
      for v_i in 1 .. v_n loop
        v_t := v_start + (p.t0 - v_start) * ((v_i - 1)::double precision / greatest(v_n - 1, 1));
        if v_i in (2, v_n - 1) and seed.h(v_k || ':cash' || v_i) < 0.6 then
          perform seed.add_tx(v_k || ':' || v_i, v_t, 'withdrawal', 'ATM',
            seed.amt_local(v_target * (v_w[v_i] / v_wsum)::numeric, c.currency, 'cash'), c.currency,
            a.id, null, a.card_id, null, seed.uid('atm:' || c.city_id || ':2'), null, c.city_id,
            'approved', 'Avance en efectivo', p.pk);
        else
          v_merchant := coalesce(
            seed.pool_pick(case when seed.h(v_k || ':mo' || v_i) < 0.5 then 'risk_phys_c' else 'online_risk_c' end,
                           c.cidx, v_k || ':m' || v_i),
            seed.pool_pick('phys_c', c.cidx, v_k || ':m' || v_i));
          select is_online into v_online from seed.stg_merchant where id = v_merchant;
          perform seed.add_tx(v_k || ':' || v_i, v_t, 'purchase', case when v_online then 'WEB' else 'POS' end,
            seed.amt_local(v_target * (v_w[v_i] / v_wsum)::numeric, c.currency, 'exact'), c.currency,
            a.id, null, a.card_id, v_merchant,
            case when v_online then v_home_dev end,
            case when v_online then seed.ip(c.cidx, c.ip_b, v_k || ':ip') end,
            c.city_id, 'approved', null, p.pk);
        end if;
      end loop;

    elsif p.kind in ('CNR', 'FP_NIGHT') then
      -- Unrecognised card-not-present purchases at night from a foreign IP.
      -- FP_NIGHT: the customer's own late-night streaming and gaming purchases.
      v_n := case p.kind when 'CNR' then seed.hi(v_k || ':n', 2, 6) else seed.hi(v_k || ':n', 2, 4) end;
      v_gap := case p.kind when 'CNR' then 4 else seed.hi(v_k || ':gap', 3, 12) end;
      v_start := p.t0 - make_interval(mins => (v_n - 1) * v_gap);
      for v_i in 1 .. v_n loop
        v_merchant := case p.kind
          when 'CNR' then coalesce(seed.pool_pick('online_risk_c', c.cidx, v_k || ':m' || v_i),
                                   seed.pool_pick('online_c', c.cidx, v_k || ':m' || v_i))
          else coalesce(seed.pool_pick('stream_c', c.cidx, v_k || ':m'), seed.pool_pick('online_c', c.cidx, v_k || ':m')) end;
        perform seed.add_tx(v_k || ':' || v_i,
          v_start + make_interval(mins => (v_i - 1) * v_gap, secs => seed.hi(v_k || ':ts' || v_i, 0, 100)),
          'purchase', 'WEB',
          case p.kind
            when 'CNR' then seed.amt(380000 * exp(0.6 * seed.gauss(v_k || ':a' || v_i)) * power(c.sm, 0.3), c.currency, 'exact')
            else seed.amt(28000 * exp(0.5 * seed.gauss(v_k || ':a' || v_i)), c.currency, 'exact') end,
          c.currency, a.id, null, a.card_id, v_merchant,
          case when p.kind = 'FP_NIGHT' then v_home_dev end,
          case when p.kind = 'CNR' then seed.ip(v_far_c, null, v_k || ':ip') else seed.ip(c.cidx, c.ip_b, v_k || ':ip') end,
          case when p.kind = 'FP_NIGHT' then c.city_id end,
          case when p.kind = 'CNR' and v_i = v_n and seed.h(v_k || ':dec') < 0.3 then 'declined'
               else 'approved' end::public.transaction_status,
          null, p.pk);
      end loop;
      v_ctx := jsonb_build_object('ip_country', v_far_c);
    end if;

    update seed.stg_tx set is_primary = true
     where k = (select t.k from seed.stg_tx t where t.pattern_k = p.pk
                 order by (t.status = 'approved') desc, t.amount desc, t.k limit 1);
    update seed.stg_pattern set ctx = v_ctx where pk = p.pk;
  end loop;
end;
$$;

-- ---------------------------------------------------------------------------------------------
-- Phase 10 · alert reasons and summaries (the "dato que las respalda")
-- ---------------------------------------------------------------------------------------------

create or replace function seed.reason_text(p_code text, v jsonb,
  out title text, out evidence text, out metric jsonb)
language plpgsql stable
as $$
declare
  v_cur text := v ->> 'cur';
begin
  case p_code
    when 'AMOUNT_RATIO' then
      title := 'Monto inusual';
      evidence := format('Monto de %s, %s mayor al promedio de 90 días (%s)',
        seed.fmt_money((v ->> 'max_out')::numeric, v_cur), seed.fmt_x((v ->> 'ratio')::float8),
        seed.fmt_money((v ->> 'baseline')::numeric, v_cur));
      metric := jsonb_build_object('observed', (v ->> 'max_out')::numeric, 'baseline', (v ->> 'baseline')::numeric, 'unit', v_cur);
    when 'NEW_DEVICE' then
      title := 'Dispositivo nuevo';
      evidence := format('Sesión desde un %s nunca visto para este cliente', v ->> 'device');
    when 'CHANGE_BURST' then
      title := 'Transferencias tras cambio de contraseña';
      evidence := format('%s transferencias en %s min, la primera %s min después del cambio de contraseña',
        v ->> 'n_out', v ->> 'span_min', v ->> 'gap_change');
      metric := jsonb_build_object('observed', (v ->> 'n_out')::numeric, 'baseline', (v ->> 'daily')::numeric, 'unit', null);
    when 'NEW_BENEFICIARY' then
      title := 'Beneficiario nuevo';
      evidence := case when (v ->> 'n_benef')::integer = 1
        then format('Primera transferencia a %s (%s)', v ->> 'benef', v ->> 'benef_bank')
        else format('%s destinatarios sin transferencias previas del cliente', v ->> 'n_benef') end;
    when 'LOCATION' then
      title := 'Ubicación inusual';
      evidence := format('Actividad en %s, a %s km de %s, su ciudad habitual', v ->> 'far', v ->> 'km', v ->> 'home');
      metric := jsonb_build_object('observed', (v ->> 'km')::numeric, 'baseline', 15, 'unit', 'km');
    when 'IMPOSSIBLE_TRAVEL' then
      title := 'Viaje imposible';
      evidence := format('Compra en %s y %s min después en %s, a %s km', v ->> 'home', v ->> 'travel_min', v ->> 'far', v ->> 'km');
      metric := jsonb_build_object('observed', (v ->> 'speed')::numeric, 'baseline', 900, 'unit', 'km/h');
    when 'HIGH_RISK_MCC' then
      title := 'Comercios de alto riesgo';
      evidence := format('%s de %s compras en comercios de alto riesgo (%s)', v ->> 'n_hr', v ->> 'n', v ->> 'hr_desc');
    when 'DECLINED' then
      title := 'Intentos rechazados';
      evidence := format('%s intentos rechazados en %s min', v ->> 'n_declined', v ->> 'span_min');
      metric := jsonb_build_object('observed', (v ->> 'n_declined')::numeric, 'baseline', 0, 'unit', null);
    when 'BURST' then
      title := 'Operaciones seguidas';
      evidence := format('%s operaciones en %s min', v ->> 'n', v ->> 'span_min');
      metric := jsonb_build_object('observed', (v ->> 'n')::numeric, 'baseline', (v ->> 'daily')::numeric, 'unit', null);
    when 'MANY_SENDERS' then
      title := 'Muchos remitentes';
      evidence := format('%s abonos de %s remitentes distintos en %s h', v ->> 'n_in', v ->> 'n_src', v ->> 'hours_in');
      metric := jsonb_build_object('observed', (v ->> 'n_src')::numeric, 'baseline', 1, 'unit', null);
    when 'FAST_OUT' then
      title := 'Salida rápida de fondos';
      evidence := format('Salió el %s %% de lo recibido en %s min', v ->> 'pct_out', v ->> 'mins_out');
      metric := jsonb_build_object('observed', (v ->> 'pct_out')::numeric, 'baseline', 25, 'unit', '%');
    when 'NEW_ACCOUNT' then
      title := 'Cuenta reciente';
      evidence := format('Cuenta abierta hace %s días', v ->> 'days_open');
    when 'CASH_OUT' then
      title := 'Retiros en efectivo';
      evidence := format('%s retiros en cajero por %s', v ->> 'n_cash', seed.fmt_money((v ->> 'total_cash')::numeric, v_cur));
    when 'INCOME_MISMATCH' then
      title := 'Perfil inconsistente';
      evidence := format('Movimientos por %s frente a ingresos mensuales declarados de %s',
        seed.fmt_money((v ->> 'total_in')::numeric, v_cur), seed.fmt_money((v ->> 'income')::numeric, v_cur));
      metric := jsonb_build_object('observed', (v ->> 'total_in')::numeric, 'baseline', (v ->> 'income')::numeric, 'unit', v_cur);
    when 'STRUCTURING' then
      title := 'Fraccionamiento';
      evidence := format('%s depósitos entre %s y %s, justo por debajo del umbral de reporte de %s', v ->> 'n_in',
        seed.fmt_money((v ->> 'min_in')::numeric, v_cur), seed.fmt_money((v ->> 'max_in')::numeric, v_cur),
        seed.fmt_money((v ->> 'threshold')::numeric, v_cur));
      metric := jsonb_build_object('observed', (v ->> 'n_in')::numeric, 'baseline', 1, 'unit', null);
    when 'NEAR_THRESHOLD' then
      title := 'Montos cercanos al umbral';
      evidence := format('Cada depósito quedó entre el %s %% y el %s %% del umbral de reporte', v ->> 'pmin', v ->> 'pmax');
      metric := jsonb_build_object('observed', (v ->> 'max_in')::numeric, 'baseline', (v ->> 'threshold')::numeric, 'unit', v_cur);
    when 'CREDIT_USAGE' then
      title := 'Uso acelerado del cupo';
      evidence := format('Usó el %s %% del cupo de %s en %s días', v ->> 'pct_limit',
        seed.fmt_money((v ->> 'limit')::numeric, v_cur), v ->> 'days_span');
      metric := jsonb_build_object('observed', (v ->> 'total_out')::numeric, 'baseline', (v ->> 'limit')::numeric, 'unit', v_cur);
    when 'NEW_CUSTOMER' then
      title := 'Cliente reciente';
      evidence := format('Cliente desde hace %s días', v ->> 'days_customer');
    when 'SHARED_CONTACT' then
      title := 'Datos de contacto compartidos';
      evidence := format('El teléfono registrado aparece en %s solicitudes de otros clientes', v ->> 'shared');
      metric := jsonb_build_object('observed', (v ->> 'shared')::numeric, 'baseline', 0, 'unit', null);
    when 'SIM_CHANGE' then
      title := 'Cambio de SIM';
      evidence := format('Cambio de SIM %s min antes de la primera transferencia', v ->> 'gap_change');
    when 'PHONE_CHANGE' then
      title := 'Cambio de número';
      evidence := 'Número de celular actualizado desde un dispositivo nuevo';
    when 'NIGHT' then
      title := 'Compras de madrugada';
      evidence := format('%s compras no presenciales entre las %s y las %s', v ->> 'n', v ->> 'first_hhmi', v ->> 'last_hhmi');
      metric := jsonb_build_object('observed', (v ->> 'n')::numeric, 'baseline', 0, 'unit', null);
    when 'NO_HISTORY_MERCHANT' then
      title := 'Comercio sin historial';
      evidence := format('Sin compras previas en %s', v ->> 'merchant');
    when 'FOREIGN_IP' then
      title := 'IP de otro país';
      evidence := format('Conexión desde una IP de %s', v ->> 'ip_country');
    when 'INCOME_SHARE' then
      title := 'Monto frente a ingresos';
      evidence := format('La operación equivale al %s %% de los ingresos mensuales declarados', v ->> 'pct_income');
      metric := jsonb_build_object('observed', (v ->> 'max_out')::numeric, 'baseline', (v ->> 'income')::numeric, 'unit', v_cur);
    else
      title := 'Patrón atípico';
      evidence := 'Comportamiento distinto al historial del cliente';
  end case;
end;
$$;

create or replace function seed.p_reasons(p_anchor timestamptz) returns void
language plpgsql
set search_path = public, seed, extensions
as $$
declare
  p record;
  c record;
  a record;
  s record;
  v jsonb;
  v_base numeric;
  v_cnt integer;
  v_home record;
  v_far record;
  v_codes text[];
  v_r integer;
  v_w double precision[];
  v_ws double precision;
  v_ratio double precision;
  v_summary text;
  v_desc text;
  r record;
  i integer;
begin
  for p in select * from seed.stg_pattern order by pk loop
    select * into c from seed.stg_customer where n = p.customer_n;
    select * into a from seed.stg_account where id = p.account_id;

    select count(*) as n,
      count(*) filter (where t.source_account_id = p.account_id) as n_out,
      count(*) filter (where t.destination_account_id = p.account_id) as n_in,
      coalesce(sum(t.amount) filter (where t.source_account_id = p.account_id), 0) as total_out,
      coalesce(sum(t.amount) filter (where t.destination_account_id = p.account_id), 0) as total_in,
      coalesce(max(t.amount) filter (where t.source_account_id = p.account_id), max(t.amount)) as max_out,
      min(t.amount) filter (where t.destination_account_id = p.account_id) as min_in,
      max(t.amount) filter (where t.destination_account_id = p.account_id) as max_in,
      greatest(round(extract(epoch from max(t.occurred_at) - min(t.occurred_at)) / 60), 1) as span_min,
      min(t.occurred_at) as first_at, max(t.occurred_at) as last_at,
      min(t.occurred_at) filter (where t.destination_account_id = p.account_id) as first_in_at,
      max(t.occurred_at) filter (where t.destination_account_id = p.account_id) as last_in_at,
      count(*) filter (where t.status = 'declined') as n_declined,
      count(distinct t.destination_account_id) filter (where t.source_account_id = p.account_id) as n_benef,
      count(distinct t.source_account_id) filter (where t.destination_account_id = p.account_id) as n_src,
      count(*) filter (where t.type = 'withdrawal') as n_cash,
      coalesce(sum(t.amount) filter (where t.type = 'withdrawal'), 0) as total_cash,
      count(*) filter (where mc.is_high_risk) as n_hr,
      min(mc.description) filter (where mc.is_high_risk) as hr_desc,
      (array_agg(m.name order by t.occurred_at) filter (where m.name is not null))[1] as merchant,
      (array_agg(t.destination_account_id order by t.occurred_at) filter (where t.source_account_id = p.account_id))[1] as benef_id
    into s
    from seed.stg_tx t
    left join seed.stg_merchant m on m.id = t.merchant_id
    left join public.merchant_categories mc on mc.mcc = m.mcc
    where t.pattern_k = p.pk;

    select avg(t.amount), count(*) into v_base, v_cnt
    from seed.stg_tx t
    where t.pattern_k is null and t.status = 'approved'
      and t.occurred_at between p.t0 - interval '90 days' and p.t0 - interval '1 hour'
      and case when p.kind in ('MUL', 'LAV', 'FP_INCOME') then t.destination_account_id = p.account_id
               else t.source_account_id = p.account_id end;
    v_base := round(coalesce(v_base, seed.amt(150000 * sqrt(c.sm), c.currency, 'exact')), 2);
    v_ratio := greatest(s.max_out / nullif(v_base, 0), 1.1);

    select * into v_home from public.cities where id = c.city_id;
    select * into v_far from public.cities
     where id = coalesce((p.ctx ->> 'far_city')::integer, c.city_id);

    v := jsonb_build_object(
      'cur', c.currency, 'n', s.n, 'n_out', s.n_out, 'n_in', s.n_in,
      'total_out', s.total_out, 'total_in', s.total_in, 'max_out', s.max_out,
      'min_in', s.min_in, 'max_in', s.max_in, 'span_min', s.span_min,
      'n_declined', s.n_declined, 'n_benef', s.n_benef, 'n_src', s.n_src,
      'n_cash', s.n_cash, 'total_cash', s.total_cash, 'n_hr', s.n_hr, 'hr_desc', s.hr_desc,
      'merchant', s.merchant, 'baseline', v_base, 'ratio', round(v_ratio::numeric, 2),
      'daily', greatest(round(coalesce(v_cnt, 0) / 90.0, 2), 0.05),
      'income', c.income, 'home', v_home.name, 'far', v_far.name,
      'km', seed.km(v_home.latitude, v_home.longitude, v_far.latitude, v_far.longitude),
      'device', p.ctx ->> 'device',
      'gap_change', round(extract(epoch from s.first_at - (p.ctx ->> 'change_at')::timestamptz) / 60),
      'travel_min', round(extract(epoch from s.first_at - (p.ctx ->> 'home_at')::timestamptz) / 60),
      'hours_in', greatest(round(extract(epoch from s.last_in_at - s.first_in_at) / 3600), 1),
      'pct_out', round(100 * s.total_out / nullif(s.total_in, 0)),
      'mins_out', greatest(round(extract(epoch from s.last_at - s.last_in_at) / 60), 1),
      'days_open', (p.t0 at time zone c.tz)::date - a.opened_on,
      'days_customer', (p.t0 at time zone c.tz)::date - c.since,
      'threshold', (p.ctx ->> 'threshold')::numeric,
      'pmin', round(100 * s.min_in / nullif((p.ctx ->> 'threshold')::numeric, 0)),
      'pmax', round(100 * s.max_in / nullif((p.ctx ->> 'threshold')::numeric, 0)),
      'limit', a.credit_limit,
      'pct_limit', round(100 * s.total_out / nullif(a.credit_limit, 0)),
      'days_span', greatest(ceil(s.span_min / 1440.0), 1),
      'shared', seed.hi('shared:' || p.pk, 2, 6),
      'first_hhmi', to_char(s.first_at at time zone c.tz, 'HH24:MI'),
      'last_hhmi', to_char(s.last_at at time zone c.tz, 'HH24:MI'),
      'ip_country', (select k.name from seed.k_country k where k.idx = (p.ctx ->> 'ip_country')::integer),
      'pct_income', round(100 * s.max_out / nullif(c.income, 0)),
      'benef', (select holder from seed.stg_account where id = s.benef_id),
      'benef_bank', (select b.name from seed.stg_account x join public.banks b on b.id = x.bank_id where x.id = s.benef_id));
    v := v || jsonb_build_object('speed',
      round((v ->> 'km')::numeric / greatest(coalesce((v ->> 'travel_min')::numeric, 60), 1) * 60));

    v_codes := case p.kind
      when 'ATO' then array['CHANGE_BURST','NEW_DEVICE','AMOUNT_RATIO','NEW_BENEFICIARY','LOCATION']
      when 'PHI' then array['AMOUNT_RATIO','NEW_BENEFICIARY','INCOME_SHARE','BURST']
      when 'CLO' then array['IMPOSSIBLE_TRAVEL','HIGH_RISK_MCC','DECLINED','AMOUNT_RATIO','BURST']
      when 'MUL' then array['MANY_SENDERS','FAST_OUT','NEW_ACCOUNT','CASH_OUT','INCOME_MISMATCH']
      when 'LAV' then array['STRUCTURING','NEAR_THRESHOLD','INCOME_MISMATCH','FAST_OUT']
      when 'SIN' then array['CREDIT_USAGE','NEW_CUSTOMER','HIGH_RISK_MCC','CASH_OUT','SHARED_CONTACT']
      when 'SIM' then array['SIM_CHANGE','PHONE_CHANGE','NEW_DEVICE','AMOUNT_RATIO','NEW_BENEFICIARY']
      when 'CNR' then array['NIGHT','NO_HISTORY_MERCHANT','BURST','AMOUNT_RATIO','FOREIGN_IP']
      when 'FP_TRAVEL' then array['LOCATION','BURST','NO_HISTORY_MERCHANT','HIGH_RISK_MCC']
      when 'FP_BIG' then array['AMOUNT_RATIO','NEW_BENEFICIARY','INCOME_SHARE']
      when 'FP_INCOME' then array['MANY_SENDERS','INCOME_MISMATCH','FAST_OUT']
      else array['NIGHT','BURST','NO_HISTORY_MERCHANT'] end;
    -- Drop reasons without data behind them.
    v_codes := array(select x from unnest(v_codes) with ordinality u(x, o)
                     where not (x = 'DECLINED' and s.n_declined = 0)
                       and not (x = 'CASH_OUT' and s.n_cash = 0)
                       and not (x = 'HIGH_RISK_MCC' and s.n_hr = 0)
                       and not (x = 'BURST' and s.n < 2)
                       and not (x = 'NO_HISTORY_MERCHANT' and s.merchant is null)
                     order by o);
    v_r := seed.hi('nr:' || p.pk, 2, least(5, cardinality(v_codes)));
    v_w := array[0.36, 0.25, 0.18, 0.12, 0.09];
    v_ws := 0;
    for i in 1 .. v_r loop
      v_w[i] := v_w[i] * (0.85 + 0.3 * seed.h('rw:' || p.pk || ':' || i));
      v_ws := v_ws + v_w[i];
    end loop;
    for i in 1 .. v_r loop
      select * into r from seed.reason_text(v_codes[i], v);
      insert into seed.stg_reason (pk, position, weight, title, evidence, metric)
      values (p.pk, i, round((v_w[i] / v_ws)::numeric, 2), r.title, r.evidence, r.metric);
    end loop;

    v_summary := case p.kind
      when 'ATO' then format('Cambio de contraseña desde un dispositivo nuevo y %s transferencias por %s en %s min.',
        s.n_out, seed.fmt_money(s.total_out, c.currency), s.span_min)
      when 'SIM' then format('Cambio de SIM y de número seguido de %s transferencias por %s.',
        s.n_out, seed.fmt_money(s.total_out, c.currency))
      when 'PHI' then format('Transferencia de %s a un beneficiario nuevo, %s el promedio de 90 días.',
        seed.fmt_money(s.max_out, c.currency), seed.fmt_x(v_ratio))
      when 'FP_BIG' then format('Transferencia de %s a un beneficiario nuevo, %s el promedio de 90 días.',
        seed.fmt_money(s.max_out, c.currency), seed.fmt_x(v_ratio))
      when 'CLO' then format('Compras con tarjeta en %s %s min después de una compra en %s.',
        v ->> 'far', v ->> 'travel_min', v ->> 'home')
      when 'FP_TRAVEL' then format('%s compras presenciales en %s, a %s km de la ciudad habitual.',
        s.n, v ->> 'far', v ->> 'km')
      when 'MUL' then format('%s abonos de %s remitentes y salida del %s %% de los fondos en pocas horas.',
        s.n_in, s.n_src, v ->> 'pct_out')
      when 'FP_INCOME' then format('%s abonos de %s remitentes distintos y salida del %s %% de lo recibido.',
        s.n_in, s.n_src, v ->> 'pct_out')
      when 'LAV' then format('%s depósitos justo por debajo del umbral de reporte en %s días.',
        s.n_in, v ->> 'days_span')
      when 'SIN' then format('Cliente con %s días de antigüedad usó el %s %% del cupo en %s días.',
        v ->> 'days_customer', v ->> 'pct_limit', v ->> 'days_span')
      when 'CNR' then format('%s compras no presenciales de madrugada por %s en comercios sin historial.',
        s.n, seed.fmt_money(s.total_out, c.currency))
      else format('%s compras no presenciales de madrugada en comercios digitales.', s.n) end;

    v_desc := case p.kind
      when 'ATO' then 'Robo de cuenta: cambio de contraseña desde dispositivo nuevo y ráfaga de transferencias'
      when 'PHI' then 'Phishing: el cliente transfiere montos altos a un beneficiario nuevo'
      when 'CLO' then 'Tarjeta clonada: compras presenciales lejos minutos después de una compra local'
      when 'MUL' then 'Cuenta mula: muchos remitentes y salida rápida de fondos en cuenta reciente'
      when 'LAV' then 'Fraccionamiento: depósitos bajo el umbral de reporte y transferencia consolidada'
      when 'SIN' then 'Identidad sintética: cliente reciente agota el cupo de crédito (bust-out)'
      when 'SIM' then 'SIM swap: cambio de SIM y número seguido de transferencias'
      when 'CNR' then 'Compra no reconocida: compras no presenciales de madrugada desde IP extranjera'
      when 'FP_TRAVEL' then 'Falso positivo: cliente de viaje (compró el tiquete semanas antes)'
      when 'FP_BIG' then 'Falso positivo: pago grande legítimo a un beneficiario nuevo'
      when 'FP_INCOME' then 'Falso positivo: vendedor con varios pagos de clientes y pago a proveedor'
      else 'Falso positivo: suscripciones digitales del propio cliente de madrugada' end;

    update seed.stg_pattern set summary = v_summary, description = v_desc where pk = p.pk;
  end loop;
end;
$$;

-- ---------------------------------------------------------------------------------------------
-- Phase 11 · transactions, ledger and balances into public
-- ---------------------------------------------------------------------------------------------

create or replace function seed.p_finalize_transactions(p_anchor timestamptz) returns void
language plpgsql
set search_path = public, seed, extensions
as $$
begin
  update seed.stg_tx t
     set description = case t.type
         when 'transfer' then 'Transferencia a ' || (select holder from seed.stg_account where id = t.destination_account_id)
         when 'credit' then coalesce('Transferencia de ' || (select holder from seed.stg_account where id = t.source_account_id),
                                     'Consignación')
         when 'purchase' then 'Compra ' || (select name from seed.stg_merchant where id = t.merchant_id)
         when 'payment' then coalesce('Pago ' || (select name from seed.stg_merchant where id = t.merchant_id), 'Pago')
         else t.type::text end
   where t.description is null;

  update seed.stg_tx t
     set reference = t.channel_code || '-' || upper(substr(md5(t.k), 1, 10))
   where t.reference is null and t.type in ('transfer', 'credit', 'payment') and t.channel_code not in ('ATM', 'PAYROLL');

  -- Ids follow time: TX-1 is the oldest transaction.
  update seed.stg_tx t set id = o.rn
    from (select k, row_number() over (order by occurred_at, k) as rn from seed.stg_tx) o
   where o.k = t.k;

  insert into public.transactions (id, occurred_at, type, channel_code, amount, currency_code,
    source_account_id, destination_account_id, card_id, merchant_id, device_id, ip, city_id,
    latitude, longitude, status, description, reference, is_labeled, created_at)
  overriding system value
  select id, occurred_at, type, channel_code, amount, currency_code, source_account_id,
    destination_account_id, card_id, merchant_id, device_id, ip, city_id, latitude, longitude,
    status, description, reference, false, occurred_at + make_interval(secs => seed.hi(k || ':ca', 1, 5))
  from seed.stg_tx
  order by id;
  perform setval(pg_get_serial_sequence('public.transactions', 'id'), (select max(id) from public.transactions));

  -- Ledger: approved movements of own accounts with a running balance.
  insert into public.ledger_entries (transaction_id, account_id, direction, amount, balance_after, occurred_at)
  with e as (
    select t.id as tx, t.source_account_id as acc, 'debit'::public.entry_direction as dir, t.amount,
           -t.amount as signed, t.occurred_at
      from seed.stg_tx t join seed.stg_account a on a.id = t.source_account_id and a.kind <> 'external'
     where t.status = 'approved'
    union all
    select t.id, t.destination_account_id, 'credit'::public.entry_direction, t.amount, t.amount, t.occurred_at
      from seed.stg_tx t join seed.stg_account a on a.id = t.destination_account_id and a.kind <> 'external'
     where t.status = 'approved'
  ), run as (
    select e.*, sum(e.signed) over (partition by e.acc order by e.occurred_at, e.tx, e.dir rows unbounded preceding) as cum
    from e
  ), low as (
    select acc, least(min(cum), 0) as mn from run group by acc
  )
  select r.tx, r.acc, r.dir, r.amount, -l.mn + a.buffer + r.cum, r.occurred_at
  from run r join low l on l.acc = r.acc join seed.stg_account a on a.id = r.acc
  order by r.occurred_at, r.tx, r.dir;

  update public.accounts ac set balance = x.bal
    from (select distinct on (account_id) account_id, balance_after as bal
            from public.ledger_entries order by account_id, occurred_at desc, id desc) x
   where x.account_id = ac.id;
  update public.accounts ac set balance = s.buffer
    from seed.stg_account s
   where s.id = ac.id and s.kind <> 'external' and ac.balance is null;
end;
$$;

-- ---------------------------------------------------------------------------------------------
-- Phase 12 · AI alerts, their transactions and reasons, and the private pattern record
-- ---------------------------------------------------------------------------------------------

create or replace function seed.p_alerts(p_anchor timestamptz) returns void
language plpgsql
set search_path = public, seed, extensions
as $$
declare
  v_count integer;
begin
  insert into public.ai_alerts (id, code, customer_id, account_id, score, suggested_type_id, summary,
    model_version, generated_at, status, resolved_by, resolved_at, final_type_id)
  select seed.uid('alert:' || p.pk), 'AL-' || (1000 + row_number() over (order by p.generated_at, p.pk)),
    c.id, p.account_id, p.score, sft.id, p.summary,
    case when p.generated_at < p_anchor - interval '75 days' then 'ms-fraud-2.3.1' else 'ms-fraud-2.4.0' end,
    p.generated_at, p.status, p.resolved_by, p.resolved_at, fft.id
  from seed.stg_pattern p
  join seed.stg_customer c on c.n = p.customer_n
  join public.fraud_types sft on sft.code = p.suggested
  left join public.fraud_types fft on fft.code = p.final_type
  order by p.generated_at, p.pk;
  get diagnostics v_count = row_count;
  perform setval('public.ai_alerts_code_seq', 1000 + v_count);

  insert into public.ai_alert_transactions (alert_id, transaction_id, is_primary)
  select seed.uid('alert:' || t.pattern_k), t.id, t.is_primary
  from seed.stg_tx t where t.pattern_k is not null
  order by t.pattern_k, t.id;

  insert into public.ai_alert_reasons (id, alert_id, position, weight, title, evidence, metric)
  select seed.uid('reason:' || r.pk || ':' || r.position), seed.uid('alert:' || r.pk), r.position,
    r.weight, r.title, r.evidence, r.metric
  from seed.stg_reason r
  order by r.pk, r.position;

  insert into seed.injected_patterns (id, fraud_type_id, customer_id, description, is_false_positive, random_seed, created_at)
  select seed.uid('pattern:' || p.pk), ft.id, c.id, p.pk || ' · ' || p.description, p.is_fp,
    floor(seed.h('rs:' || p.pk) * 2147483647)::integer, p_anchor
  from seed.stg_pattern p
  join seed.stg_customer c on c.n = p.customer_n
  join public.fraud_types ft on ft.code = coalesce(p.true_type, p.suggested);

  insert into seed.injected_pattern_transactions (pattern_id, transaction_id)
  select seed.uid('pattern:' || t.pattern_k), t.id from seed.stg_tx t where t.pattern_k is not null;

  -- Consequences of confirmed alerts.
  update public.accounts set status = 'blocked'
   where id in (select account_id from seed.stg_pattern where kind = 'MUL' and status in ('confirmed', 'reclassified'));
  update public.cards set status = 'blocked'
   where account_id in (select account_id from seed.stg_pattern
                         where kind in ('CLO', 'CNR') and status in ('confirmed', 'reclassified'));
end;
$$;

-- ---------------------------------------------------------------------------------------------
-- Phase 13 · disputes
-- ---------------------------------------------------------------------------------------------

create or replace function seed.p_disputes(p_anchor timestamptz) returns void
language plpgsql
set search_path = public, seed, extensions
as $$
begin
  -- Claims for unrecognised purchases, chargebacks for cloned cards.
  insert into public.disputes (id, transaction_id, type, status, filed_at, resolved_at, description)
  select seed.uid('dispute:' || t.k), t.id, d.type,
    case when p.status in ('confirmed', 'reclassified') and d.resolved <= p_anchor then 'accepted'
         when p.status = 'rejected' and d.resolved <= p_anchor then 'rejected'
         else 'open' end::public.dispute_status,
    d.filed,
    case when p.status <> 'pending' and d.resolved <= p_anchor then d.resolved end,
    case d.type when 'chargeback' then 'Contracargo por uso de tarjeta clonada en ' || coalesce(m.name, 'comercio')
                else 'El cliente desconoce la compra en ' || coalesce(m.name, 'comercio en línea') end
  from seed.stg_tx t
  join seed.stg_pattern p on p.pk = t.pattern_k
  left join seed.stg_merchant m on m.id = t.merchant_id
  cross join lateral (select
      (case when p.kind = 'CLO' then 'chargeback' else 'customer_claim' end)::public.dispute_type as type,
      p.t0 + make_interval(hours => seed.hi('df:' || t.k, 20, 96)) as filed) d0
  cross join lateral (select d0.type, d0.filed,
      d0.filed + make_interval(days => seed.hi('dr:' || t.k, 3, 20)) as resolved) d
  where t.status = 'approved' and d.filed <= p_anchor
    and (p.kind = 'CNR' or (p.kind = 'CLO' and p.status in ('confirmed', 'reclassified') and seed.h('cb:' || t.k) < 0.5));

  -- Everyday claims on ordinary purchases (duplicated charges, items not received…).
  insert into public.disputes (id, transaction_id, type, status, filed_at, resolved_at, description)
  select seed.uid('dispute:' || t.k), t.id, 'customer_claim', st.status, d.filed,
    case when st.status <> 'open' and d.resolved <= p_anchor then d.resolved end,
    seed.pick(array['Cobro duplicado','Producto no recibido','Monto distinto al autorizado',
                    'Suscripción cancelada que se siguió cobrando','Servicio no prestado'], 'dd:' || t.k)
  from seed.stg_tx t
  cross join lateral (select t.occurred_at + make_interval(days => seed.hi('df:' || t.k, 1, 15)) as filed) d0
  cross join lateral (select d0.filed, d0.filed + make_interval(days => seed.hi('dr:' || t.k, 5, 30)) as resolved) d
  cross join lateral (select (case when d.resolved > p_anchor then 'open'
      else seed.wpick(array['rejected','open','accepted'], array[55,25,20]::float8[], 'ds:' || t.k) end)::public.dispute_status as status) st
  where t.pattern_k is null and t.type = 'purchase' and t.status = 'approved'
    and seed.h('dsp:' || t.k) < 0.003 and d.filed <= p_anchor;
end;
$$;

-- ---------------------------------------------------------------------------------------------
-- Phase 14 · labels with edits, label fraud types and the audit trail
-- ---------------------------------------------------------------------------------------------

create or replace function seed.label_fields(p_verdict public.verdict, p_key text, p_amount numeric,
  p_currency text, p_edit boolean,
  out confidence smallint, out severity public.severity, out justification text, out fraud_types smallint[])
language plpgsql stable
as $$
begin
  confidence := case p_verdict
    when 'not_fraud' then seed.wpick(array[1,2,3,4], array[3,15,45,37]::float8[], p_key || ':c')
    when 'uncertain' then seed.wpick(array[1,2], array[60,40]::float8[], p_key || ':c')
    else seed.wpick(array[2,3,4], array[30,45,25]::float8[], p_key || ':c') end;
  severity := case when p_verdict = 'fraud' then public.severity_for_amount(p_amount, p_currency::char(3)) end;
  if p_verdict = 'fraud' then
    fraud_types := array[seed.wpick(array[8,2,3,1,7,4,5,6]::smallint[], array[30,20,20,10,8,5,4,3]::float8[], p_key || ':t')];
    if seed.h(p_key || ':t2') < 0.15 then
      fraud_types := fraud_types || ((fraud_types[1] + seed.hi(p_key || ':t3', 0, 6)) % 8 + 1)::smallint;
    end if;
  else
    fraud_types := '{}';
  end if;

  if p_edit then
    justification := case p_verdict
      when 'not_fraud' then seed.pick(array['Cliente reconoció la operación en llamada de verificación.',
        'Revisión de segunda línea: operación legítima.', 'Se recibió soporte del cliente.'], p_key || ':j')
      when 'fraud' then seed.pick(array['Nuevo reclamo del cliente: se reclasifica como fraude.',
        'Revisión de segunda línea confirma el patrón.', 'Se encontraron operaciones relacionadas con el mismo destino.'], p_key || ':j')
      else seed.pick(array['Información contradictoria; se deja en revisión.',
        'El cliente no responde; pendiente de confirmar.'], p_key || ':j') end;
  elsif p_verdict = 'uncertain' then
    justification := seed.pick(array['Monto atípico sin otros indicios; pendiente contacto con el cliente.',
      'Dispositivo reciente, pero ubicación habitual.', 'Beneficiario nuevo; no se pudo verificar.',
      'Comercio con reclamos previos.', 'Horario inusual para el cliente.'], p_key || ':j');
  elsif confidence = 1 then
    justification := seed.pick(array['Parece legítima, pero no se pudo contactar al cliente.',
      'Monto algo alto para el perfil; sin otros indicios.', 'Única señal: comercio nuevo para el cliente.'], p_key || ':j');
  elsif seed.h(p_key || ':oj') < 0.25 then
    justification := case p_verdict
      when 'not_fraud' then seed.pick(array['Operación habitual del cliente.', 'Beneficiario frecuente.',
        'Compra recurrente en comercio conocido.', 'Monto y canal consistentes con el historial.',
        'Cliente confirmó la operación.'], p_key || ':j')
      else seed.pick(array['Cliente desconoce la operación.', 'Reclamo presentado por el cliente.',
        'Patrón coincide con fraude conocido.', 'Comercio reportado por fraude.'], p_key || ':j') end;
  end if;
end;
$$;

create or replace function seed.alert_justification(p_kind text, p_status public.alert_status, p_key text)
returns text
language sql immutable
as $$
  select case
    when p_status = 'rejected' then case p_kind
      when 'FP_TRAVEL' then 'El cliente estaba de viaje; compró el tiquete semanas antes.'
      when 'FP_BIG' then 'Cliente confirmó el pago por llamada; beneficiario verificado.'
      when 'FP_INCOME' then 'Ingresos por ventas soportados con facturas.'
      when 'FP_NIGHT' then 'Suscripciones habituales del cliente.'
      else seed.pick(array['Cliente reconoce las operaciones.', 'Sin evidencia suficiente para confirmar.'], p_key) end
    when p_status = 'reclassified' then 'El patrón corresponde a otro tipo de fraude.'
    else case p_kind
      when 'ATO' then 'Cliente reporta que no cambió su contraseña.'
      when 'PHI' then 'Cliente recibió una llamada suplantando al banco.'
      when 'CLO' then 'Cliente tiene la tarjeta física en su poder.'
      when 'MUL' then 'La cuenta recibe y dispersa fondos de víctimas.'
      when 'LAV' then 'Depósitos fraccionados sin soporte de origen.'
      when 'SIN' then 'Documentos inconsistentes; datos compartidos con otros clientes.'
      when 'SIM' then 'El operador confirma un duplicado de SIM no solicitado.'
      when 'CNR' then 'Cliente presentó reclamo por compras no reconocidas.'
      else 'Patrón coincide con el tipo sugerido.' end
  end
$$;

create or replace function seed.p_labels(p_anchor timestamptz) returns void
language plpgsql
set search_path = public, seed, extensions
as $$
begin
  -- (a) Labels created by resolving an alert: same confidence and justification for every
  --     transaction of the alert, severity from the amount (like resolve_alert).
  insert into seed.stg_label (transaction_id, step, source, alert_id, verdict, confidence, severity,
    justification, analyst_id, at, fraud_types, amount, currency)
  select t.id, 2, 'alert', seed.uid('alert:' || p.pk),
    case when p.status = 'rejected' then 'not_fraud' else 'fraud' end::public.verdict,
    case p.status when 'confirmed' then seed.wpick(array[3,4], array[55,45]::float8[], 'ac:' || p.pk)
                  when 'reclassified' then seed.wpick(array[2,3,4], array[20,50,30]::float8[], 'ac:' || p.pk)
                  else seed.wpick(array[2,3,4], array[25,55,20]::float8[], 'ac:' || p.pk) end,
    case when p.status <> 'rejected' then public.severity_for_amount(t.amount, t.currency_code::char(3)) end,
    case when seed.h('aj:' || p.pk) < 0.65 then seed.alert_justification(p.kind, p.status, 'aj:' || p.pk) end,
    p.resolved_by, p.resolved_at,
    case when p.status = 'rejected' then '{}'::smallint[]
         else array[(select ft.id from public.fraud_types ft where ft.code = p.final_type)] end,
    t.amount, t.currency_code
  from seed.stg_tx t join seed.stg_pattern p on p.pk = t.pattern_k
  where p.status <> 'pending';

  -- (b) An earlier manual label on the main transaction of some alerts: overwritten when the
  --     alert was resolved, or still there while the alert is pending.
  insert into seed.stg_label (transaction_id, step, source, alert_id, verdict, confidence, severity,
    justification, analyst_id, at, fraud_types, amount, currency)
  select t.id, 1, 'manual', null, v.verdict,
    case v.verdict when 'uncertain' then 2 else 3 end,
    case when v.verdict = 'fraud' then public.severity_for_amount(t.amount, t.currency_code::char(3)) end,
    case v.verdict when 'uncertain' then 'En revisión: patrón similar a un fraude conocido; se espera confirmación del cliente.'
                   else 'Cliente reportó la operación por la línea de atención.' end,
    seed.analyst_uuid(1 + (seed.analyst_n('pm:' || p.pk) % 7)),
    pm.at,
    case when v.verdict = 'fraud' then array[(select ft.id from public.fraud_types ft where ft.code = p.suggested)]
         else '{}'::smallint[] end,
    t.amount, t.currency_code
  from seed.stg_pattern p
  join seed.stg_tx t on t.pattern_k = p.pk and t.is_primary
  cross join lateral (select (case when p.status = 'pending'
                                  and seed.h('pv:' || p.pk) < 0.4 then 'fraud' else 'uncertain' end)::public.verdict as verdict) v
  cross join lateral (select p.generated_at + make_interval(mins => seed.hi('pa:' || p.pk, 10, 600)) as at) pm
  where (p.status = 'pending' and seed.h('pl:' || p.pk) < 0.15 and pm.at < p_anchor - interval '5 minutes')
     or (p.status <> 'pending' and seed.h('pl:' || p.pk) < 0.12 and pm.at < p.resolved_at);

  -- (c) Manual labels on ~11 % of the everyday transactions.
  insert into seed.stg_label (transaction_id, step, source, alert_id, verdict, confidence, severity,
    justification, analyst_id, at, fraud_types, edits, amount, currency)
  select t.id, 1, 'manual', null, v.verdict, f.confidence, f.severity, f.justification,
    seed.analyst_uuid(seed.analyst_n('la:' || t.k)),
    least(t.occurred_at + make_interval(secs => 3600 * least(exp(ln(48) + 1.2 * seed.gauss('lt:' || t.k)), 2000)),
          p_anchor - make_interval(mins => seed.hi('lm:' || t.k, 5, 300))),
    f.fraud_types,
    case when seed.h('ed:' || t.k) < 0.02 then 2 when seed.h('ed:' || t.k) < 0.09 then 1 else 0 end,
    t.amount, t.currency_code
  from seed.stg_tx t
  cross join lateral (select seed.wpick(array['not_fraud','uncertain','fraud']::public.verdict[],
                                        array[88,8,4]::float8[], 'lv:' || t.k) as verdict) v
  cross join lateral seed.label_fields(v.verdict, 'lf:' || t.k, t.amount, t.currency_code, false) f
  where t.pattern_k is null and t.status <> 'pending'
    and t.occurred_at < p_anchor - interval '1 day'
    and seed.h('lbl:' || t.k) < 0.11;

  -- (d) Edits: a second analyst changes the verdict days later, sometimes twice.
  insert into seed.stg_label (transaction_id, step, source, alert_id, verdict, confidence, severity,
    justification, analyst_id, at, fraud_types, edits, amount, currency)
  select l.transaction_id, 3, 'manual', null, v.verdict, f.confidence, f.severity, f.justification,
    seed.analyst_uuid(1 + (seed.analyst_n('le:' || l.transaction_id) % 7)),
    e.at, f.fraud_types, l.edits, l.amount, l.currency
  from seed.stg_label l
  cross join lateral (select (case l.verdict
      when 'uncertain' then case when seed.h('ev:' || l.transaction_id) < 0.7 then 'not_fraud' else 'fraud' end
      when 'not_fraud' then case when seed.h('ev:' || l.transaction_id) < 0.5 then 'uncertain' else 'fraud' end
      else 'not_fraud' end)::public.verdict as verdict) v
  cross join lateral seed.label_fields(v.verdict, 'le:' || l.transaction_id, l.amount, l.currency, true) f
  cross join lateral (select l.at + make_interval(hours => seed.hi('eh:' || l.transaction_id, 20, 240)) as at) e
  where l.step = 1 and l.source = 'manual' and l.edits >= 1 and e.at < p_anchor - interval '5 minutes'
    and not exists (select 1 from seed.stg_label x where x.transaction_id = l.transaction_id and x.step = 2);

  insert into seed.stg_label (transaction_id, step, source, alert_id, verdict, confidence, severity,
    justification, analyst_id, at, fraud_types, edits, amount, currency)
  select l.transaction_id, 4, 'manual', null, v.verdict, f.confidence, f.severity, f.justification,
    seed.analyst_uuid(1 + (seed.analyst_n('le2:' || l.transaction_id) % 7)),
    e.at, f.fraud_types, l.edits, l.amount, l.currency
  from seed.stg_label l
  cross join lateral (select (case l.verdict when 'uncertain' then 'not_fraud' else 'uncertain' end)::public.verdict as verdict) v
  cross join lateral seed.label_fields(v.verdict, 'le2:' || l.transaction_id, l.amount, l.currency, true) f
  cross join lateral (select l.at + make_interval(hours => seed.hi('eh2:' || l.transaction_id, 20, 200)) as at) e
  where l.step = 3 and l.edits = 2 and e.at < p_anchor - interval '5 minutes';

  -- Current label = last version; created_at = first version; version = number of saves.
  insert into public.labels (id, transaction_id, source, alert_id, verdict, confidence, severity,
    justification, analyst_id, created_at, updated_at, version)
  select seed.uid('label:' || v.transaction_id), v.transaction_id, v.source, v.alert_id, v.verdict,
    v.confidence, v.severity, v.justification, v.analyst_id, v.created, v.at, v.ver
  from (
    select l.*, row_number() over w as ver, count(*) over (partition by l.transaction_id) as nver,
           first_value(l.at) over w as created
    from seed.stg_label l
    window w as (partition by l.transaction_id order by l.at, l.step)
  ) v
  where v.ver = v.nver
  order by v.created, v.transaction_id;

  insert into public.label_fraud_types (label_id, fraud_type_id)
  select distinct seed.uid('label:' || v.transaction_id), u.ft
  from (
    select l.*, row_number() over (partition by l.transaction_id order by l.at desc, l.step desc) as rk
    from seed.stg_label l
  ) v
  cross join lateral unnest(v.fraud_types) as u(ft)
  where v.rk = 1;

  update public.transactions t set is_labeled = true
   where exists (select 1 from public.labels l where l.transaction_id = t.id);

  -- Audit trail, shaped like the triggers write it (to_jsonb of the row).
  insert into public.audit_log (analyst_id, action, entity, entity_id, transaction_id, old_value, new_value, created_at)
  select x.analyst_id, x.action, x.entity, x.entity_id, x.transaction_id, x.old_value, x.new_value, x.created_at
  from (
    select j.analyst_id,
      (case when j.ver = 1 then 'create_label' else 'update_label' end)::public.audit_action as action,
      'labels' as entity, seed.uid('label:' || j.transaction_id)::text as entity_id, j.transaction_id,
      lag(j.js) over (partition by j.transaction_id order by j.ver) as old_value, j.js as new_value,
      j.at as created_at, 1 as ord
    from (
      select v.*, jsonb_build_object(
          'id', seed.uid('label:' || v.transaction_id), 'transaction_id', v.transaction_id,
          'source', v.source, 'alert_id', v.alert_id, 'verdict', v.verdict,
          'confidence', v.confidence, 'severity', v.severity, 'justification', v.justification,
          'analyst_id', v.analyst_id, 'created_at', v.created, 'updated_at', v.at, 'version', v.ver) as js
      from (
        select l.*, row_number() over w as ver, first_value(l.at) over w as created
        from seed.stg_label l
        window w as (partition by l.transaction_id order by l.at, l.step)
      ) v
    ) j
    union all
    select a.resolved_by,
      (case a.status when 'confirmed' then 'confirm_alert' when 'rejected' then 'reject_alert'
                     else 'reclassify_alert' end)::public.audit_action,
      'ai_alerts', a.id::text, null,
      to_jsonb(a) || jsonb_build_object('status', 'pending', 'resolved_by', null, 'resolved_at', null, 'final_type_id', null),
      to_jsonb(a), a.resolved_at, 0
    from public.ai_alerts a
    where a.status <> 'pending'
  ) x
  order by x.created_at, x.ord, x.transaction_id;
end;
$$;

-- ---------------------------------------------------------------------------------------------
-- Phase 15 · notifications (one per alert and analyst, like trg_ai_alerts_notify)
-- ---------------------------------------------------------------------------------------------

create or replace function seed.p_notifications(p_anchor timestamptz) returns void
language plpgsql
set search_path = public, seed, extensions
as $$
begin
  insert into public.notifications (id, analyst_id, type, alert_id, title, body, created_at, read_at)
  select seed.uid('notification:' || a.id || ':' || an.id), an.id, 'alert_new', a.id,
    format('Nueva alerta %s · score %s', a.code, a.score), a.summary, a.generated_at,
    case when r.is_read
         then least(a.generated_at + make_interval(mins => seed.hi('nr:' || a.id || an.id, 1, 900)),
                    p_anchor - interval '1 minute') end
  from public.ai_alerts a
  cross join public.analysts an
  cross join lateral (select case
      when a.status <> 'pending' then seed.h('rd:' || a.id || an.id) < 0.92
      when a.generated_at < p_anchor - interval '2 days' then seed.h('rd:' || a.id || an.id) < 0.6
      else seed.h('rd:' || a.id || an.id) < 0.25 end as is_read) r
  order by a.generated_at, an.id;
end;
$$;


-- ---------------------------------------------------------------------------------------------
-- Entry points
-- ---------------------------------------------------------------------------------------------

-- Loads the whole dataset into an EMPTY public schema (fresh project, or right after p_wipe).
create or replace function seed.populate(p_anchor timestamptz default '2026-11-07 12:00:00-05')
returns jsonb
language plpgsql
set search_path = public, seed, extensions
as $$
declare
  v_result jsonb;
begin
  -- The seed writes history (audit, notifications, versions) itself, with past dates, so the
  -- triggers that would stamp now() are off during the load. The deferred fraud-type check
  -- stays on and validates every fraud label.
  alter table public.ai_alerts disable trigger trg_ai_alerts_notify;
  alter table public.ai_alerts disable trigger trg_audit_ai_alerts;
  alter table public.labels disable trigger trg_audit_labels;
  alter table public.labels disable trigger trg_labels_is_labeled;
  alter table public.labels disable trigger trg_labels_version;
  alter table public.ledger_entries disable trigger trg_ledger_internal_account;

  perform seed.load_catalogs();
  perform seed.p_constants();
  perform seed.p_analysts(p_anchor);
  perform seed.p_customers(p_anchor);
  perform seed.p_plan(p_anchor);
  perform seed.p_customers_insert(p_anchor);
  perform seed.p_accounts(p_anchor);
  perform seed.p_devices_merchants(p_anchor);
  perform seed.p_security_events(p_anchor);
  perform seed.p_transactions(p_anchor);
  perform seed.p_patterns(p_anchor);
  perform seed.p_reasons(p_anchor);
  perform seed.p_finalize_transactions(p_anchor);
  perform seed.p_alerts(p_anchor);
  perform seed.p_disputes(p_anchor);
  perform seed.p_labels(p_anchor);
  perform seed.p_notifications(p_anchor);

  -- Fire the deferred checks now so the tables can be altered again.
  set constraints all immediate;

  alter table public.ai_alerts enable trigger trg_ai_alerts_notify;
  alter table public.ai_alerts enable trigger trg_audit_ai_alerts;
  alter table public.labels enable trigger trg_audit_labels;
  alter table public.labels enable trigger trg_labels_is_labeled;
  alter table public.labels enable trigger trg_labels_version;
  alter table public.ledger_entries enable trigger trg_ledger_internal_account;

  select jsonb_build_object(
    'anchor', p_anchor,
    'analysts', (select count(*) from public.analysts),
    'customers', (select count(*) from public.customers),
    'accounts', (select count(*) from public.accounts where not is_external),
    'external_accounts', (select count(*) from public.accounts where is_external),
    'cards', (select count(*) from public.cards),
    'merchants', (select count(*) from public.merchants),
    'devices', (select count(*) from public.devices),
    'security_events', (select count(*) from public.security_events),
    'transactions', (select count(*) from public.transactions),
    'labeled_transactions', (select count(*) from public.transactions where is_labeled),
    'ledger_entries', (select count(*) from public.ledger_entries),
    'ai_alerts', (select count(*) from public.ai_alerts),
    'pending_alerts', (select count(*) from public.ai_alerts where status = 'pending'),
    'alert_reasons', (select count(*) from public.ai_alert_reasons),
    'labels', (select count(*) from public.labels),
    'audit_log', (select count(*) from public.audit_log),
    'notifications', (select count(*) from public.notifications),
    'disputes', (select count(*) from public.disputes))
  into v_result;

  return v_result;
end;
$$;

-- Wipes everything and rebuilds the reference state. This is what reset.sql runs.
create or replace function seed.reset_demo_data(p_anchor timestamptz default '2026-11-07 12:00:00-05')
returns jsonb
language plpgsql
set search_path = public, seed, extensions
as $$
declare
  v_result jsonb;
begin
  perform seed.p_wipe();
  v_result := seed.populate(p_anchor);
  -- Staging rows are only needed during the run.
  truncate table seed.stg_customer, seed.stg_account, seed.stg_merchant, seed.stg_pool,
    seed.stg_pattern, seed.stg_tx, seed.stg_reason, seed.stg_label;
  return v_result;
end;
$$;

revoke all on all functions in schema seed from public, anon, authenticated;
revoke all on all tables in schema seed from public, anon, authenticated;
