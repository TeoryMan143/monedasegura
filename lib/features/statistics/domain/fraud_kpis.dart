import 'package:freezed_annotation/freezed_annotation.dart';

part 'fraud_kpis.freezed.dart';

@freezed
abstract class FraudKpis with _$FraudKpis {
  const factory FraudKpis({
    required int labeledCount,

    required int totalCount,

    required int fraudCount,

    required double committedAmountCop,
  }) = _FraudKpis;

  const FraudKpis._();

  double get labeledRatio => totalCount == 0 ? 0 : labeledCount / totalCount;
}
