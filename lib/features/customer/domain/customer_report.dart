import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/domain/account_type.dart';
import '../../../core/domain/alert_status.dart';
import '../../../core/domain/currency.dart';
import '../../../core/domain/fraud_type.dart';
import '../../../core/domain/verdict.dart';
import 'report_enums.dart';

part 'customer_report.freezed.dart';

/// The customer of the report «Resumen» (C-08, HU-09): personal data, segment and risk.
@freezed
abstract class CustomerProfile with _$CustomerProfile {
  const factory CustomerProfile({
    required String id,
    required String fullName,

    /// Raw `document_type`, e.g. `CC`, `DNI`: the code is how analysts say it.
    required String documentType,
    required String documentNumber,
    required DateTime birthDate,
    required String countryName,
    required String cityName,
    required CustomerSegment segment,
    required RiskLevel riskLevel,
    required DateTime customerSince,
    required Currency incomeCurrency,
    double? declaredIncome,
    String? occupation,
    String? email,
    String? phone,
  }) = _CustomerProfile;
}

/// What the «Cuentas» tab lists (HU-09).
@freezed
abstract class CustomerProducts with _$CustomerProducts {
  const factory CustomerProducts({
    required List<ReportAccount> accounts,
    required List<ReportCard> cards,
    required List<ReportDevice> devices,
  }) = _CustomerProducts;
}

@freezed
abstract class ReportAccount with _$ReportAccount {
  const factory ReportAccount({
    required String id,
    required String last4,
    required AccountType type,
    required Currency currency,
    required String bankName,
    required ProductStatus status,
    double? balance,
    double? creditLimit,
    DateTime? openedOn,
  }) = _ReportAccount;
}

@freezed
abstract class ReportCard with _$ReportCard {
  const factory ReportCard({
    required String id,
    required String last4,
    required String network,
    required CardType type,
    required ProductStatus status,
    required DateTime expiresOn,

    /// The account the card draws on, as its last four digits.
    String? accountLast4,

    /// The currency of that account, for the limit.
    Currency? currency,
    double? creditLimit,
  }) = _ReportCard;
}

@freezed
abstract class ReportDevice with _$ReportDevice {
  const factory ReportDevice({
    required String id,
    required DeviceType type,

    /// Brand and model, e.g. «Samsung Galaxy A54». Null when the bank does not know.
    String? name,

    /// System and version, e.g. «Android 14».
    String? system,
    required DateTime firstSeenAt,
    required DateTime lastSeenAt,
    required bool isTrusted,
  }) = _ReportDevice;
}

/// The latest labels and alerts of the customer in the range (HU-09).
@freezed
abstract class CustomerHistory with _$CustomerHistory {
  const factory CustomerHistory({
    required List<LabelHistoryItem> labels,
    required List<AlertHistoryItem> alerts,
  }) = _CustomerHistory;
}

/// A labeled transaction, from the database or saved in this session.
@freezed
abstract class LabelHistoryItem with _$LabelHistoryItem {
  const factory LabelHistoryItem({
    required int transactionId,
    required String transactionCode,
    required DateTime occurredAt,
    required Verdict verdict,
    String? analystName,
    DateTime? labeledAt,
  }) = _LabelHistoryItem;
}

@freezed
abstract class AlertHistoryItem with _$AlertHistoryItem {
  const factory AlertHistoryItem({
    required String code,
    required int score,
    required AlertStatus status,
    required FraudType suggestedType,
    required DateTime generatedAt,
  }) = _AlertHistoryItem;
}

/// Transactions and amount of the customer in one month and currency, from the
/// `customer_monthly_activity` RPC (HU-09).
@freezed
abstract class MonthlyActivity with _$MonthlyActivity {
  const factory MonthlyActivity({
    /// The first day of the month.
    required DateTime month,
    required Currency currency,
    required int transactionCount,
    required double totalAmount,
  }) = _MonthlyActivity;
}
