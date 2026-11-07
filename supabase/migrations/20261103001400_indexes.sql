-- Baseline 14/14 · indexes for the filters, sorts and joins the app uses.

create index idx_customers_name_trgm on public.customers
  using gin ((first_names || ' ' || last_names) extensions.gin_trgm_ops);
create index idx_customers_search on public.customers using gin (search_vector);

create index idx_accounts_customer on public.accounts (customer_id);
create index idx_accounts_last4 on public.accounts (last4);
create index idx_cards_account on public.cards (account_id);
create index idx_cards_customer on public.cards (customer_id);
create index idx_customer_devices_dev on public.customer_devices (device_id);
create index idx_secevents_customer on public.security_events (customer_id, occurred_at);

create index idx_tx_card on public.transactions (card_id);
create index idx_tx_code_pattern on public.transactions (code text_pattern_ops);
create index idx_tx_destination_time on public.transactions (destination_account_id, occurred_at);
create index idx_tx_labeled_time on public.transactions (is_labeled, occurred_at);
create index idx_tx_merchant on public.transactions (merchant_id);
create index idx_tx_occurred on public.transactions (occurred_at desc);
create index idx_tx_source_time on public.transactions (source_account_id, occurred_at);

create index idx_ledger_account_time on public.ledger_entries (account_id, occurred_at);
create index idx_disputes_tx on public.disputes (transaction_id);

create index idx_alerts_customer on public.ai_alerts (customer_id);
create index idx_alerts_status_score on public.ai_alerts (status, score desc);
create index idx_alert_tx_tx on public.ai_alert_transactions (transaction_id);

create index idx_labels_alert on public.labels (alert_id);
create index idx_labels_verdict on public.labels (verdict);
create index idx_lft_type on public.label_fraud_types (fraud_type_id);

create index idx_notifications_unread on public.notifications (analyst_id) where read_at is null;
create index idx_audit_entity on public.audit_log (entity, entity_id);
create index idx_audit_transaction on public.audit_log (transaction_id);
