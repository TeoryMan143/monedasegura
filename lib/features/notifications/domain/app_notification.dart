/// A notification of the bell panel (HU-16, C-06): one row of `notifications`. Every
/// notification points to an AI alert.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.alertId,
    required this.title,
    required this.createdAt,
    required this.read,
    this.body,
    this.alertCode,
    this.score,
  });

  final String id;
  final String alertId;

  /// E.g. «Nueva alerta AL-1042 · score 92».
  final String title;

  /// The alert summary.
  final String? body;
  final String? alertCode;
  final int? score;
  final DateTime createdAt;

  /// `read_at` is set.
  final bool read;

  AppNotification markRead() => AppNotification(
    id: id,
    alertId: alertId,
    title: title,
    body: body,
    alertCode: alertCode,
    score: score,
    createdAt: createdAt,
    read: true,
  );
}
