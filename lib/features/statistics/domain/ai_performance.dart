import 'package:freezed_annotation/freezed_annotation.dart';

import 'type_precision.dart';

part 'ai_performance.freezed.dart';

@freezed
abstract class AiPerformance with _$AiPerformance {
  const factory AiPerformance({
    required int confirmed,

    required int rejected,

    required int reclassified,

    @Default(<TypePrecision>[]) List<TypePrecision> precisionByType,
  }) = _AiPerformance;

  const AiPerformance._();

  int get resolvedCount => confirmed + rejected + reclassified;
}
