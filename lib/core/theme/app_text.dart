import 'package:flutter/painting.dart';

import 'app_colors.dart';

/// Typography tokens: Plus Jakarta Sans, fallback Arial (DESIGN.md · Typography).
abstract final class AppText {
  static const fontFamily = 'PlusJakartaSans';
  static const fontFallback = ['Arial'];

  static const _base = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFallback,
    color: AppColors.textPrimary,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const _tabular = [FontFeature.tabularFigures()];

  /// Display/32 · login headline, hero numbers.
  static final display = _style(32, 40, FontWeight.w700, -0.5);

  /// Título/H1 · page titles.
  static final h1 = _style(24, 32, FontWeight.w700, -0.25);

  /// Título/H2 · amount in the classification panel, section headers.
  static final h2 = _style(20, 28, FontWeight.w600);

  /// Título/H3 · card, panel and dialog titles.
  static final h3 = _style(16, 24, FontWeight.w600);

  /// Cuerpo/L · long text, empty-state descriptions.
  static final bodyL = _style(16, 24, FontWeight.w400);

  /// Cuerpo/M · default UI text.
  static final bodyM = _style(14, 20, FontWeight.w400);

  /// Cuerpo/M Medium · names and emphasis.
  static final bodyMMedium = _style(14, 20, FontWeight.w500);

  /// Cuerpo/M SemiBold · buttons and field labels.
  static final bodyMSemiBold = _style(14, 20, FontWeight.w600);

  /// Cuerpo/S · meta, helper text.
  static final bodyS = _style(12, 16, FontWeight.w400);

  /// Cuerpo/S SemiBold · badges, score labels.
  static final bodySSemiBold = _style(12, 16, FontWeight.w600);

  /// Etiqueta/11 · uppercase eyebrows and section labels.
  static final label = _style(11, 16, FontWeight.w600, 0.4);

  /// Dato/KPI · KPI values (tabular figures).
  static final kpi = _style(
    28,
    36,
    FontWeight.w700,
    -0.25,
  ).copyWith(fontFeatures: _tabular);

  /// Dato/Tabla · numbers and amounts in tables (tabular figures).
  static final tableData = _style(
    13,
    20,
    FontWeight.w500,
  ).copyWith(fontFeatures: _tabular);

  static TextStyle _style(
    double size,
    double lineHeight,
    FontWeight weight, [
    double tracking = 0,
  ]) => _base.copyWith(
    fontSize: size,
    height: lineHeight / size,
    fontWeight: weight,
    letterSpacing: tracking,
  );
}
