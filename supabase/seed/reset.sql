-- Wipes every table in public (and the seed analysts in auth.users) and rebuilds the reference
-- demo state. Needs catalogs.sql and generator.sql installed first: reset.sh / reset.ps1 and
-- `supabase db reset` run the three files in order. Takes 2–3 minutes.
--
-- The anchor date fixes the state: same anchor, same rows. To move every date so the data ends
-- today, use `select seed.reset_demo_data(now());` instead.

set statement_timeout = '15min';

select seed.reset_demo_data();
