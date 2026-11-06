/// A notification of the bell panel (HU-16, C-06). Every notification points to an
/// AI alert.
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
    this.live = false,
  });

  final String id;
  final String alertId;

  /// E.g. «Nueva alerta · score 92».
  final String title;

  /// E.g. «AL-1042 · Juan Pérez · Robo de cuenta».
  final String? body;
  final String? alertCode;
  final int? score;
  final DateTime createdAt;
  final bool read;

  /// Arrived during this session through the realtime service: it gets a toast.
  final bool live;

  AppNotification markRead() => AppNotification(
    id: id,
    alertId: alertId,
    title: title,
    body: body,
    alertCode: alertCode,
    score: score,
    createdAt: createdAt,
    read: true,
    live: live,
  );
}
