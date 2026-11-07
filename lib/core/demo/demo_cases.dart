/// Real cases in the seeded database that the team uses to test and demo each screen.
///
/// They come from `supabase/seed` with its 2026-11-07 anchor. Every reset rebuilds the same
/// IDs, also with `seed.reset_demo_data(now())`, which only moves the dates. The cases are
/// live data: if someone labels or resolves them, a reset puts them back.
abstract final class DemoCases {
  /// HU-11 · impossible travel. Alert AL-1829 (score 94, pending, suggests CLO): a card
  /// purchase in São Paulo and, 95 minutes later, purchases in Cartagena, 4,907 km away.
  /// Customer Felipe Martins Nascimento (BR).
  static const impossibleTravelAlertId = '28a2ab08-10cc-b474-2e14-53c6bd1b6c6d';
  static const impossibleTravelAlertCode = 'AL-1829';
  static const impossibleTravelCustomerId =
      '6a38acd8-f517-8ee1-0736-8285c5cb35dd';

  /// HU-03 · empty state. Sofía Salazar Gómez (CO) became a customer on 2026-11-06 and has
  /// no transactions, so any date range shows the empty list.
  static const emptyCustomerId = '7fb5b3de-850c-99e8-ebbc-95e82c38d92c';

  /// HU-07 and HU-08 · alert another analyst already resolved. AL-2496 (score 92) was
  /// confirmed by Andrés Martínez, so opening it shows «otro analista la resolvió».
  /// Customer Fernando Herrera Chávez (CO).
  static const resolvedAlertId = '1bc220ca-e621-4cd2-451e-ec9bc1728b6c';
  static const resolvedAlertCode = 'AL-2496';

  /// HU-05 · structuring (LAV), to classify several at once. Alert AL-2272 (score 78,
  /// pending): 14 deposits just under the reporting threshold in four days, then one
  /// consolidated transfer of 111,400,000 COP. All 15 are unlabeled.
  /// Customer Elena Contreras Rojas (CO).
  static const structuringAlertId = '6a49e53e-31c0-fc44-de97-e24ecda6029a';
  static const structuringAlertCode = 'AL-2272';
  static const structuringCustomerId = '44a3609a-c682-fdb4-8461-3f7380911cfa';

  /// The transactions of [structuringAlertCode], oldest first. The last one is the
  /// consolidated transfer and the alert's main transaction.
  static const structuringTransactionIds = [
    68285, 68397, 68489, 68512, 68608, 68734, 68839, 68897, //
    68935, 69036, 69155, 69248, 69304, 69385, 69539,
  ];

  /// HU-04 · the save that fails, to show E-03. TX-16427 is an unlabeled transfer of
  /// 10,950 MXN, the main transaction of pending alert AL-1264 (PHI). It belongs to no other
  /// case, so the rest of the demo still saves.
  static const failingTransactionId = 16427;

  /// HU-10 · spikes and bursts on the timeline. Luciana Restrepo Torres (CO) has 62
  /// transactions and three alerts: AL-1400 (rejected), AL-1821 (confirmed) and AL-1773
  /// (pending, three operations in 17 minutes).
  static const burstCustomerId = 'a9b76617-7834-59c4-f259-124b702b77c8';
  static const burstAlertId = '0249810b-43bd-4ddf-5a7d-6aab427e9649';
  static const burstAlertCode = 'AL-1773';
}
