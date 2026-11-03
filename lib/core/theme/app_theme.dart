import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_metrics.dart';
import 'app_text.dart';

export 'app_colors.dart';
export 'app_metrics.dart';
export 'app_text.dart';
export 'status_tone.dart';

/// Material theme built from the design tokens. Light only (DESIGN.md · Principles).
abstract final class AppTheme {
  static ThemeData light() {
    const colorScheme = ColorScheme.light(
      primary: AppColors.bgBrand,
      onPrimary: AppColors.textOnBrand,
      primaryContainer: AppColors.bgBrandSubtle,
      onPrimaryContainer: AppColors.textBrand,
      secondary: AppColors.morado500,
      onSecondary: AppColors.gris0,
      error: AppColors.rojo500,
      onError: AppColors.gris0,
      errorContainer: AppColors.rojo50,
      onErrorContainer: AppColors.rojo700,
      surface: AppColors.bgSurface,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      surfaceContainerLowest: AppColors.bgSurface,
      surfaceContainerLow: AppColors.bgCanvas,
      surfaceContainer: AppColors.bgCanvas,
      surfaceContainerHigh: AppColors.bgSurfaceSubtle,
      surfaceContainerHighest: AppColors.bgSurfaceSubtle,
      outline: AppColors.borderDefault,
      outlineVariant: AppColors.borderSubtle,
      shadow: AppColors.gris900,
      scrim: AppColors.bgOverlay,
      surfaceTint: Colors.transparent,
    );

    final textTheme = TextTheme(
      displayLarge: AppText.display,
      displayMedium: AppText.display,
      displaySmall: AppText.kpi,
      headlineLarge: AppText.h1,
      headlineMedium: AppText.h1,
      headlineSmall: AppText.h2,
      titleLarge: AppText.h2,
      titleMedium: AppText.h3,
      titleSmall: AppText.bodyMSemiBold,
      bodyLarge: AppText.bodyL,
      bodyMedium: AppText.bodyM,
      bodySmall: AppText.bodyS,
      labelLarge: AppText.bodyMSemiBold,
      labelMedium: AppText.bodySSemiBold,
      labelSmall: AppText.label,
    );

    const inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
      borderSide: BorderSide(color: AppColors.borderDefault),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      fontFamily: AppText.fontFamily,
      fontFamilyFallback: AppText.fontFallback,
      textTheme: textTheme,
      scaffoldBackgroundColor: AppColors.bgCanvas,
      canvasColor: AppColors.bgSurface,
      dividerColor: AppColors.borderSubtle,
      hoverColor: AppColors.bgRowHover,
      focusColor: AppColors.bgSelected,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      visualDensity: VisualDensity.standard,
      dividerTheme: const DividerThemeData(
        color: AppColors.borderSubtle,
        thickness: 1,
        space: 1,
      ),
      tooltipTheme: TooltipThemeData(
        textStyle: AppText.bodyS.copyWith(color: AppColors.gris0),
        decoration: const BoxDecoration(
          color: AppColors.gris900,
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
        ),
        constraints: const BoxConstraints(maxWidth: 260),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.sm,
          vertical: AppSpace.xs,
        ),
        waitDuration: const Duration(milliseconds: 400),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        filled: true,
        fillColor: AppColors.bgSurface,
        hintStyle: AppText.bodyM.copyWith(color: AppColors.textTertiary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpace.md,
          vertical: AppSpace.sm,
        ),
        border: inputBorder,
        enabledBorder: inputBorder,
        hoverColor: Colors.transparent,
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.borderFocus, width: 2),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.borderDanger),
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.borderDanger, width: 2),
        ),
        disabledBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.borderSubtle),
        ),
      ),
      scrollbarTheme: const ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(AppColors.gris300),
        radius: Radius.circular(AppRadius.full),
      ),
    );
  }
}
