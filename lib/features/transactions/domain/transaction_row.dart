import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/domain/account_type.dart';
import '../../../core/domain/channel.dart';
import '../../../core/domain/country.dart';
import '../../../core/domain/currency.dart';
import '../../../core/domain/label_status.dart';
import '../../../core/domain/transaction_type.dart';
import '../../../core/domain/verdict.dart';

part 'transaction_row.freezed.dart';
part 'transaction_row.g.dart';

/// One row of the A-01 list, read from `v_transactions_list` (HU-02).
@Freezed(toJson: false)
abstract class TransactionRow with _$TransactionRow {
  @JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
  const factory TransactionRow({
    required int id,

    /// The readable code, e.g. `TX-48219`.
    required String code,
    required DateTime occurredAt,

    /// The customer to open on a click. Null when no account of the bank takes part.
    String? customerId,

    /// First and last names of [customerId].
    String? customerName,

    /// Last four digits of the account of [customerId] in this transaction.
    String? accountLast4,

    /// Type of that same account.
    @JsonKey(fromJson: _accountTypeOrNull) AccountType? accountType,

    /// The account the money leaves. Null for a deposit.
    String? sourceAccountId,

    /// The account the money reaches. Null for a withdrawal or a purchase.
    String? destinationAccountId,
    @JsonKey(fromJson: TransactionType.fromDb) required TransactionType type,
    @JsonKey(name: 'channel_code', fromJson: Channel.fromDb)
    required Channel channel,
    required num amount,
    @JsonKey(name: 'currency_code', fromJson: Currency.fromDb)
    required Currency currency,

    /// Not in the view: the repository reads it from the `countries` catalog, through
    /// the currency (see `transaction_country.dart`).
    @JsonKey(includeFromJson: false, includeToJson: false) Country? country,

    /// Score of its AI alert, 0 to 100. Null without an alert.
    int? alertScore,
    required bool isLabeled,

    /// Verdict of the current label. Null while it is not labeled.
    @JsonKey(fromJson: _verdictOrNull) Verdict? verdict,
  }) = _TransactionRow;

  const TransactionRow._();

  factory TransactionRow.fromJson(Map<String, dynamic> json) =>
      _$TransactionRowFromJson(json);

  LabelStatus get labelStatus => LabelStatus.fromDb(isLabeled);

  bool get hasAiAlert => alertScore != null;
}

AccountType? _accountTypeOrNull(String? value) =>
    value == null ? null : AccountType.fromDb(value);

Verdict? _verdictOrNull(String? value) =>
    value == null ? null : Verdict.fromDb(value);
