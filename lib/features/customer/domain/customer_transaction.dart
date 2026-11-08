import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/domain/channel.dart';
import '../../../core/domain/currency.dart';
import '../../../core/domain/label_status.dart';
import '../../../core/domain/transaction_type.dart';
import '../../../core/domain/verdict.dart';

part 'customer_transaction.freezed.dart';
part 'customer_transaction.g.dart';

/// One row of the A-02 table, read from `v_transactions_list` (HU-03).
///
/// Seen from the customer: [accountOf] is the customer's account in the transaction and
/// [isIncomingFor] tells whether the money came in.
@Freezed(toJson: false)
abstract class CustomerTransaction with _$CustomerTransaction {
  @JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
  const factory CustomerTransaction({
    required int id,

    /// The readable code, e.g. `TX-48219`.
    required String code,
    required DateTime occurredAt,
    @JsonKey(fromJson: TransactionType.fromDb) required TransactionType type,
    @JsonKey(name: 'channel_code', fromJson: Channel.fromDb)
    required Channel channel,
    required num amount,
    @JsonKey(name: 'currency_code', fromJson: Currency.fromDb)
    required Currency currency,
    String? sourceAccountId,
    String? destinationAccountId,

    /// The merchant of a purchase or a payment.
    String? merchantName,

    /// Where it happened, for the timeline and the map (HU-10, HU-11). Null for
    /// operations without a place, such as most online credits.
    double? latitude,
    double? longitude,
    String? cityName,

    /// [occurredAt] on the clock of the customer's country, read as a wall time (no time
    /// zone): its hour is the customer's hour. Unusual hours use it (HU-10).
    @JsonKey(fromJson: _wallTimeOrNull) DateTime? customerLocalAt,

    /// Score of its AI alert, 0 to 100. Null without an alert.
    int? alertScore,
    required bool isLabeled,
    @JsonKey(fromJson: _verdictOrNull) Verdict? verdict,
  }) = _CustomerTransaction;

  const CustomerTransaction._();

  factory CustomerTransaction.fromJson(Map<String, dynamic> json) =>
      _$CustomerTransactionFromJson(json);

  LabelStatus get labelStatus => LabelStatus.fromDb(isLabeled);

  bool get hasAiAlert => alertScore != null;

  /// The id of the customer's account in the transaction: the source if it is theirs,
  /// otherwise the destination.
  String? accountOf(Set<String> customerAccounts) {
    if (customerAccounts.contains(sourceAccountId)) return sourceAccountId;
    if (customerAccounts.contains(destinationAccountId)) {
      return destinationAccountId;
    }
    return null;
  }

  /// Whether the money reached the customer from outside: a credit, a received
  /// transfer. A transfer between two accounts of the customer is not incoming.
  bool isIncomingFor(Set<String> customerAccounts) =>
      customerAccounts.contains(destinationAccountId) &&
      !customerAccounts.contains(sourceAccountId);
}

/// A `timestamp without time zone` as the wall time it is: `DateTime.parse` reads a text
/// without offset as local time and keeps its fields.
DateTime? _wallTimeOrNull(String? value) =>
    value == null ? null : DateTime.parse(value);

Verdict? _verdictOrNull(String? value) =>
    value == null ? null : Verdict.fromDb(value);
