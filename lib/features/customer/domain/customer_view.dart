import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/domain/account_type.dart';
import '../../../core/domain/currency.dart';

part 'customer_view.freezed.dart';
part 'customer_view.g.dart';

/// An account of the customer: the «Cuenta» filter and column of A-02 (HU-03).
@Freezed(toJson: false)
abstract class CustomerAccount with _$CustomerAccount {
  @JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
  const factory CustomerAccount({
    required String id,
    required String last4,
    @JsonKey(fromJson: AccountType.fromDb) required AccountType type,
    @JsonKey(name: 'currency_code', fromJson: Currency.fromDb)
    required Currency currency,
  }) = _CustomerAccount;

  factory CustomerAccount.fromJson(Map<String, dynamic> json) =>
      _$CustomerAccountFromJson(json);
}

/// The header of A-02 that does not depend on the range (HU-03).
@freezed
abstract class CustomerView with _$CustomerView {
  const factory CustomerView({
    required String id,
    required String fullName,
    required List<CustomerAccount> accounts,

    /// AI alerts of the customer still waiting for an analyst.
    required int pendingAlerts,
  }) = _CustomerView;

  const CustomerView._();

  Set<String> get accountIds => {for (final account in accounts) account.id};
}

/// Labeled and total transactions of the customer in the range (HU-03).
@freezed
abstract class LabelProgress with _$LabelProgress {
  const factory LabelProgress({required int labeled, required int total}) =
      _LabelProgress;
}
