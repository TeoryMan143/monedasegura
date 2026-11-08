-- Catalogs of Moneda Segura. Read only for the app (authenticated only gets SELECT).
--
-- Defines seed.load_catalogs() and runs it. The function upserts every catalog, so this file
-- can run on an empty or a loaded database. seed.reset_demo_data() (generator.sql) calls it
-- again after wiping the data, so catalogs and data always come back together.
--
-- Load order matters: currencies → countries → cities / banks / channels → the rest.

create schema if not exists seed;
revoke all on schema seed from public;
revoke all on schema seed from anon, authenticated;

create or replace function seed.load_catalogs()
returns void
language plpgsql
set search_path = public, seed, extensions
as $$
begin
  insert into public.currencies (code, name, symbol, decimals, locale) values
    ('COP', 'Peso colombiano', '$',  2, 'es-CO'),
    ('MXN', 'Peso mexicano',   '$',  2, 'es-MX'),
    ('PEN', 'Sol peruano',     'S/', 2, 'es-PE'),
    ('CLP', 'Peso chileno',    '$',  0, 'es-CL'),
    ('ARS', 'Peso argentino',  '$',  2, 'es-AR'),
    ('BRL', 'Real brasileño',  'R$', 2, 'pt-BR')
  on conflict (code) do update
    set name = excluded.name, symbol = excluded.symbol,
        decimals = excluded.decimals, locale = excluded.locale;

  insert into public.countries (code, name, currency_code, primary_document_type, phone_prefix, time_zone) values
    ('CO', 'Colombia',  'COP', 'CC',   '+57', 'America/Bogota'),
    ('MX', 'México',    'MXN', 'CURP', '+52', 'America/Mexico_City'),
    ('PE', 'Perú',      'PEN', 'DNI',  '+51', 'America/Lima'),
    ('CL', 'Chile',     'CLP', 'RUT',  '+56', 'America/Santiago'),
    ('AR', 'Argentina', 'ARS', 'DNI',  '+54', 'America/Argentina/Buenos_Aires'),
    ('BR', 'Brasil',    'BRL', 'CPF',  '+55', 'America/Sao_Paulo')
  on conflict (code) do update
    set name = excluded.name, currency_code = excluded.currency_code,
        primary_document_type = excluded.primary_document_type,
        phone_prefix = excluded.phone_prefix, time_zone = excluded.time_zone;

  -- Six cities per country. Ids are fixed: country k owns ids 6k-5 .. 6k and the first one is
  -- the capital (or main city). The generator relies on this layout.
  insert into public.cities (id, country_code, name, region, latitude, longitude) values
    ( 1, 'CO', 'Bogotá',          'Bogotá D.C.',          4.711000,  -74.072100),
    ( 2, 'CO', 'Medellín',        'Antioquia',            6.244200,  -75.581200),
    ( 3, 'CO', 'Cali',            'Valle del Cauca',      3.451600,  -76.532000),
    ( 4, 'CO', 'Barranquilla',    'Atlántico',           10.968500,  -74.781300),
    ( 5, 'CO', 'Cartagena',       'Bolívar',             10.391000,  -75.479400),
    ( 6, 'CO', 'Bucaramanga',     'Santander',            7.119300,  -73.122700),
    ( 7, 'MX', 'Ciudad de México','Ciudad de México',    19.432600,  -99.133200),
    ( 8, 'MX', 'Guadalajara',     'Jalisco',             20.659700, -103.349600),
    ( 9, 'MX', 'Monterrey',       'Nuevo León',          25.686600, -100.316100),
    (10, 'MX', 'Puebla',          'Puebla',              19.041400,  -98.206300),
    (11, 'MX', 'Tijuana',         'Baja California',     32.514900, -117.038200),
    (12, 'MX', 'Cancún',          'Quintana Roo',        21.161900,  -86.851500),
    (13, 'PE', 'Lima',            'Lima',               -12.046400,  -77.042800),
    (14, 'PE', 'Arequipa',        'Arequipa',           -16.409000,  -71.537500),
    (15, 'PE', 'Trujillo',        'La Libertad',         -8.111600,  -79.028800),
    (16, 'PE', 'Cusco',           'Cusco',              -13.532000,  -71.967500),
    (17, 'PE', 'Piura',           'Piura',               -5.194500,  -80.632800),
    (18, 'PE', 'Chiclayo',        'Lambayeque',          -6.771400,  -79.840900),
    (19, 'CL', 'Santiago',        'Región Metropolitana',-33.448900,  -70.669300),
    (20, 'CL', 'Valparaíso',      'Valparaíso',         -33.047200,  -71.612700),
    (21, 'CL', 'Concepción',      'Biobío',             -36.827000,  -73.050300),
    (22, 'CL', 'Antofagasta',     'Antofagasta',        -23.650900,  -70.397500),
    (23, 'CL', 'La Serena',       'Coquimbo',           -29.902700,  -71.251900),
    (24, 'CL', 'Temuco',          'La Araucanía',       -38.735900,  -72.590400),
    (25, 'AR', 'Buenos Aires',    'Ciudad Autónoma de Buenos Aires', -34.603700, -58.381600),
    (26, 'AR', 'Córdoba',         'Córdoba',            -31.420100,  -64.188800),
    (27, 'AR', 'Rosario',         'Santa Fe',           -32.944200,  -60.650500),
    (28, 'AR', 'Mendoza',         'Mendoza',            -32.889500,  -68.845800),
    (29, 'AR', 'La Plata',        'Buenos Aires',       -34.920500,  -57.953600),
    (30, 'AR', 'Mar del Plata',   'Buenos Aires',       -38.005500,  -57.542600),
    (31, 'BR', 'São Paulo',       'São Paulo',          -23.550500,  -46.633300),
    (32, 'BR', 'Rio de Janeiro',  'Rio de Janeiro',     -22.906800,  -43.172900),
    (33, 'BR', 'Belo Horizonte',  'Minas Gerais',       -19.916700,  -43.934500),
    (34, 'BR', 'Brasília',        'Distrito Federal',   -15.797500,  -47.891900),
    (35, 'BR', 'Salvador',        'Bahia',              -12.977700,  -38.501600),
    (36, 'BR', 'Curitiba',        'Paraná',             -25.428400,  -49.273300)
  on conflict (id) do update
    set country_code = excluded.country_code, name = excluded.name, region = excluded.region,
        latitude = excluded.latitude, longitude = excluded.longitude;
  perform setval(pg_get_serial_sequence('public.cities', 'id'), 36);

  -- One own bank per country (ids 1–6, same order as the countries) and three counterparties.
  insert into public.banks (id, name, country_code, swift_code, is_own) values
    ( 1, 'Moneda Segura Colombia',   'CO', 'MSEGCOBB', true),
    ( 2, 'Moneda Segura México',     'MX', 'MSEGMXMM', true),
    ( 3, 'Moneda Segura Perú',       'PE', 'MSEGPEPL', true),
    ( 4, 'Moneda Segura Chile',      'CL', 'MSEGCLRM', true),
    ( 5, 'Moneda Segura Argentina',  'AR', 'MSEGARBA', true),
    ( 6, 'Moneda Segura Brasil',     'BR', 'MSEGBRSP', true),
    ( 7, 'Banco Andino',             'CO', 'BANDCOBB', false),
    ( 8, 'Banco del Café',           'CO', 'BCAFCOBM', false),
    ( 9, 'Cooperativa Cordillera',   'CO', 'COOPCOBC', false),
    (10, 'Banco Nopal',              'MX', 'BNOPMXMM', false),
    (11, 'Banca Sierra Madre',       'MX', 'BSMAMXMT', false),
    (12, 'Financiera Anáhuac',       'MX', 'FANAMXMG', false),
    (13, 'Banco Inca',               'PE', 'BINCPEPL', false),
    (14, 'Caja Andina del Sur',      'PE', 'CANSPEPA', false),
    (15, 'Banco Pacífico Norte',     'PE', 'BPNOPEPT', false),
    (16, 'Banco Austral',            'CL', 'BAUSCLRM', false),
    (17, 'Banco Atacama',            'CL', 'BATACLRA', false),
    (18, 'Banco Cordillera de Chile','CL', 'BCCHCLRC', false),
    (19, 'Banco del Plata',          'AR', 'BPLAARBA', false),
    (20, 'Banco Pampa',              'AR', 'BPAMARBC', false),
    (21, 'Banco Aconcagua',          'AR', 'BACOARBM', false),
    (22, 'Banco Ipê',                'BR', 'BIPEBRSP', false),
    (23, 'Banco Cerrado',            'BR', 'BCERBRBH', false),
    (24, 'Banco Atlântico Sul',      'BR', 'BATSBRRJ', false)
  on conflict (id) do update
    set name = excluded.name, country_code = excluded.country_code,
        swift_code = excluded.swift_code, is_own = excluded.is_own;
  perform setval(pg_get_serial_sequence('public.banks', 'id'), 24);

  -- Codes mirror the Channel enum in lib/core/domain/channel.dart. A null country means the
  -- channel exists in every country.
  insert into public.channels (code, name, country_code, is_digital) values
    ('APP',       'App móvil',                   null, true),
    ('WEB',       'Banca web',                   null, true),
    ('POS',       'POS',                         null, false),
    ('ATM',       'Cajero',                      null, false),
    ('PSE',       'PSE',                         'CO', true),
    ('SPEI',      'SPEI',                        'MX', true),
    ('YAPE',      'Yape',                        'PE', true),
    ('PIX',       'Pix',                         'BR', true),
    ('INTERBANK', 'Transferencia interbancaria', null, true),
    ('PAYROLL',   'Nómina',                      null, false)
  on conflict (code) do update
    set name = excluded.name, country_code = excluded.country_code,
        is_digital = excluded.is_digital;

  insert into public.merchant_categories (mcc, description, is_high_risk) values
    ('5411', 'Supermercados y tiendas de abarrotes',  false),
    ('5812', 'Restaurantes',                          false),
    ('5541', 'Estaciones de servicio',                false),
    ('5311', 'Tiendas por departamento',              false),
    ('5732', 'Tiendas de electrónica',                true),
    ('5999', 'Comercio minorista variado',            false),
    ('4111', 'Transporte público',                    false),
    ('4121', 'Taxis y transporte por aplicación',     false),
    ('4814', 'Telecomunicaciones',                    false),
    ('4900', 'Servicios públicos',                    false),
    ('5912', 'Droguerías y farmacias',                false),
    ('5651', 'Ropa y calzado',                        false),
    ('7011', 'Hoteles y alojamiento',                 false),
    ('4511', 'Aerolíneas',                            false),
    ('5944', 'Joyerías y relojerías',                 true),
    ('6051', 'Cuasi-efectivo y criptoactivos',        true),
    ('7995', 'Apuestas y juegos de azar',             true),
    ('4829', 'Giros y remesas',                       true),
    ('5967', 'Ventas por catálogo y telemercadeo',    true),
    ('5815', 'Contenidos digitales y streaming',      false),
    ('8220', 'Universidades y educación superior',    false),
    ('5200', 'Ferretería y hogar',                    false)
  on conflict (mcc) do update
    set description = excluded.description, is_high_risk = excluded.is_high_risk;

  -- Fixed taxonomy. Ids 1–8 are stable (RPCs take the id), colours match
  -- lib/core/catalogs/fake_catalog_repository.dart.
  insert into public.fraud_types (id, code, name, description, color) values
    (1, 'ATO', 'Robo de cuenta',               'Un tercero toma control de la cuenta del cliente.',           '#D93B3B'),
    (2, 'PHI', 'Phishing / ingeniería social', 'El cliente es engañado para autorizar operaciones.',          '#865CF0'),
    (3, 'CLO', 'Tarjeta clonada',              'Uso de una copia física o de los datos de la tarjeta.',       '#E9683B'),
    (4, 'MUL', 'Cuenta mula',                  'Cuenta usada para recibir y mover dinero ilícito.',           '#5454E9'),
    (5, 'LAV', 'Lavado / fraccionamiento',     'Montos divididos para evadir controles.',                     '#4CB979'),
    (6, 'SIN', 'Identidad sintética',          'Cliente creado con datos falsos o combinados.',               '#E4EB60'),
    (7, 'SIM', 'SIM swap',                     'Duplicado de SIM para interceptar códigos de verificación.',  '#6B6C70'),
    (8, 'CNR', 'Compra no reconocida',         'Compra que el cliente niega haber hecho.',                    '#4343C4')
  on conflict (id) do update
    set code = excluded.code, name = excluded.name,
        description = excluded.description, color = excluded.color;
  perform setval(pg_get_serial_sequence('public.fraud_types', 'id'), 8);

  insert into public.confidence_levels
    (level, name, meaning, criteria, sample_weight, requires_justification) values
    (1, 'Baja',     'Poca certeza: la etiqueta pesa poco en el entrenamiento.',
        'Un solo indicio aislado con posible explicación legítima. Justificación obligatoria.', 0.25, true),
    (2, 'Media',    'Certeza moderada.',
        'Dos o más indicios coinciden, sin evidencia concluyente.', 0.50, false),
    (3, 'Alta',     'Certeza alta.',
        'Patrón claro de un tipo de fraude conocido.', 0.85, false),
    (4, 'Muy alta', 'Certeza total: la etiqueta pesa completo en el entrenamiento.',
        'Evidencia concluyente (reclamo, contracargo o patrón idéntico a un tipo conocido).', 1.00, false)
  on conflict (level) do update
    set name = excluded.name, meaning = excluded.meaning, criteria = excluded.criteria,
        sample_weight = excluded.sample_weight,
        requires_justification = excluded.requires_justification;

  insert into public.severity_levels (level, sort_order, name, criteria) values
    ('low',      1, 'Baja',    'Monto bajo, sin afectación a otros productos.'),
    ('medium',   2, 'Media',   'Monto relevante para el perfil del cliente.'),
    ('high',     3, 'Alta',    'Pérdida significativa o afectación de varias cuentas/productos.'),
    ('critical', 4, 'Crítica', 'Vaciado de cuenta, red de cuentas involucradas o lavado de activos.')
  on conflict (level) do update
    set sort_order = excluded.sort_order, name = excluded.name, criteria = excluded.criteria;

  -- Severity thresholds (open point 1 of the user stories). Same value in every currency:
  -- about 1 M / 5 M / 20 M COP for medium / high / critical, rounded to local figures.
  insert into public.severity_thresholds (currency_code, level, min_amount) values
    ('COP', 'low', 0), ('COP', 'medium',  1000000), ('COP', 'high',  5000000), ('COP', 'critical', 20000000),
    ('MXN', 'low', 0), ('MXN', 'medium',     5000), ('MXN', 'high',    25000), ('MXN', 'critical',   100000),
    ('PEN', 'low', 0), ('PEN', 'medium',     1000), ('PEN', 'high',     5000), ('PEN', 'critical',    20000),
    ('CLP', 'low', 0), ('CLP', 'medium',   250000), ('CLP', 'high',  1200000), ('CLP', 'critical',  5000000),
    ('ARS', 'low', 0), ('ARS', 'medium',   350000), ('ARS', 'high',  1750000), ('ARS', 'critical',  7000000),
    ('BRL', 'low', 0), ('BRL', 'medium',     1500), ('BRL', 'high',     7000), ('BRL', 'critical',    28000)
  on conflict (currency_code, level) do update set min_amount = excluded.min_amount;

  -- Simulated value of 1 unit of each currency in COP (not a live feed).
  insert into public.exchange_rates (currency_code, rate_to_cop, as_of) values
    ('COP',    1.000000, '2026-03-01'),
    ('MXN',  216.000000, '2026-03-01'),
    ('PEN', 1067.000000, '2026-03-01'),
    ('CLP',    4.210000, '2026-03-01'),
    ('ARS',    2.860000, '2026-03-01'),
    ('BRL',  727.000000, '2026-03-01')
  on conflict (currency_code) do update
    set rate_to_cop = excluded.rate_to_cop, as_of = excluded.as_of;
end;
$$;

revoke all on function seed.load_catalogs() from public, anon, authenticated;

select seed.load_catalogs();
