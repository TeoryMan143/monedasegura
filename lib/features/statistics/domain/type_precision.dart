import 'package:freezed_annotation/freezed_annotation.dart';

part 'type_precision.freezed.dart';

/// How often the AI is right when it suggests one fraud type (HU-13, A-08).
///
/// Precision is the alerts of that type an analyst confirmed over all the alerts of that
/// type already resolved. It has no `fromJson`: the repository computes it from the rows of
/// `v_ai_performance`.
@freezed
abstract class TypePrecision with _$TypePrecision {
  const factory TypePrecision({
    /// The code of the suggested type: the key of a `FraudType`.
    required String typeCode,

    /// From 0 to 1.
    required double precision,

    /// Resolved alerts the precision is measured on. A precision over three alerts is
    /// not worth the same as one over three hundred.
    required int alerts,
  }) = _TypePrecision;
}
