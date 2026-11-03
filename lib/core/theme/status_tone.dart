import 'package:flutter/painting.dart';

import 'app_colors.dart';

/// Status tones accepted by the kit components (DESIGN.md · Status tones).
///
/// Domain → tone mappings live next to each enum in `core/domain`.
enum StatusTone {
  success(AppColors.verde50, AppColors.verde700, AppColors.verde500),
  warning(AppColors.amarillo50, AppColors.amarillo700, AppColors.amarillo500),
  high(AppColors.naranja50, AppColors.naranja700, AppColors.naranja500),
  danger(AppColors.rojo50, AppColors.rojo700, AppColors.rojo500),
  info(AppColors.morado50, AppColors.morado700, AppColors.morado500),
  neutral(AppColors.gris100, AppColors.gris600, AppColors.gris400),
  brand(AppColors.azul50, AppColors.azul600, AppColors.azul500);

  const StatusTone(this.background, this.text, this.solid);

  /// Badge and banner background.
  final Color background;

  /// Text and icon colour on [background].
  final Color text;

  /// Solid fill (score badge, counters, chart marks).
  final Color solid;

  /// Text colour on a [solid] fill. Yellow never takes white text.
  Color get onSolid =>
      this == warning ? AppColors.amarillo700 : AppColors.gris0;
}
