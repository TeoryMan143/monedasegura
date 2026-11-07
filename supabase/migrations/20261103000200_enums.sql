-- Baseline 2/14 · enums. Values as in docs/mer.puml.

create type public.document_type as enum ('CC', 'CE', 'NIT', 'CURP', 'RFC', 'DNI', 'RUT', 'CPF', 'PASSPORT');
create type public.customer_segment as enum ('retail', 'retail_mid_income', 'premium', 'small_business', 'corporate');
create type public.risk_level as enum ('low', 'medium', 'high');
create type public.account_type as enum ('savings', 'checking', 'wallet', 'credit');
create type public.card_type as enum ('debit', 'credit');
create type public.product_status as enum ('active', 'blocked', 'inactive', 'closed');
create type public.device_type as enum ('mobile', 'tablet', 'desktop', 'atm', 'pos');
create type public.security_event_type as enum (
  'login', 'login_failed', 'login_new_device', 'password_change', 'phone_change', 'sim_change',
  'email_change', 'logout');
create type public.transaction_type as enum ('debit', 'credit', 'transfer', 'withdrawal', 'payment', 'purchase');
create type public.transaction_status as enum ('approved', 'declined', 'pending', 'reversed');
create type public.entry_direction as enum ('debit', 'credit');
create type public.dispute_type as enum ('customer_claim', 'chargeback');
create type public.dispute_status as enum ('open', 'accepted', 'rejected');
create type public.verdict as enum ('fraud', 'not_fraud', 'uncertain');
create type public.severity as enum ('low', 'medium', 'high', 'critical');
create type public.label_source as enum ('manual', 'alert');
create type public.alert_status as enum ('pending', 'confirmed', 'rejected', 'reclassified');
create type public.notification_type as enum ('alert_new');
create type public.audit_action as enum (
  'create_label', 'update_label', 'confirm_alert', 'reject_alert', 'reclassify_alert');
