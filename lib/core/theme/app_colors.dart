import 'package:flutter/painting.dart';

/// Colour tokens from the Figma "Fundamentos" page (DESIGN.md · Colour).
///
/// Feature code uses the semantic tokens at the bottom, not the primitive ramps.
abstract final class AppColors {
  // --- Primitives: azul (Azul Icesi = azul500) ---
  static const azul50 = Color(0xFFEEEEFD);
  static const azul100 = Color(0xFFDDDDFB);
  static const azul200 = Color(0xFFBBBBF6);
  static const azul300 = Color(0xFF9898F2);
  static const azul400 = Color(0xFF7676ED);
  static const azul500 = Color(0xFF5454E9);
  static const azul600 = Color(0xFF4343C4);
  static const azul700 = Color(0xFF33339A);
  static const azul800 = Color(0xFF242470);
  static const azul900 = Color(0xFF16164A);

  // --- Primitives: gris ---
  static const gris0 = Color(0xFFFFFFFF);
  static const gris50 = Color(0xFFF6F6F8);
  static const gris100 = Color(0xFFEDEEF1);
  static const gris200 = Color(0xFFCECFD4);
  static const gris300 = Color(0xFFB3B4B9);
  static const gris400 = Color(0xFF88898C);
  static const gris500 = Color(0xFF6B6C70);
  static const gris600 = Color(0xFF4E4F53);
  static const gris700 = Color(0xFF36373B);
  static const gris800 = Color(0xFF232428);
  static const gris900 = Color(0xFF141518);
  static const gris1000 = Color(0xFF000000);

  // --- Primitives: support palette + functional red ---
  static const verde50 = Color(0xFFEAF7EF);
  static const verde500 = Color(0xFF4CB979);
  static const verde700 = Color(0xFF2B7A4C);
  static const amarillo50 = Color(0xFFFAFCE3);
  static const amarillo500 = Color(0xFFE4EB60);
  static const amarillo700 = Color(0xFF666A0E);
  static const naranja50 = Color(0xFFFDEFE9);
  static const naranja500 = Color(0xFFE9683B);
  static const naranja700 = Color(0xFFA3401C);
  static const morado50 = Color(0xFFF2EDFE);
  static const morado500 = Color(0xFF865CF0);
  static const morado700 = Color(0xFF5A33C2);
  static const rojo50 = Color(0xFFFCECEC);
  static const rojo500 = Color(0xFFD93B3B);
  static const rojo700 = Color(0xFFA12424);

  // --- Semantic: text ---
  static const textPrimary = gris900;
  static const textSecondary = gris600;
  static const textTertiary = gris500;
  static const textBrand = azul600;
  static const textLink = azul600;
  static const textOnBrand = gris0;
  static const textDisabled = gris300;

  // --- Semantic: icons ---
  static const iconPrimary = gris700;
  static const iconSecondary = gris500;
  static const iconBrand = azul500;
  static const iconOnBrand = gris0;

  // --- Semantic: backgrounds ---
  static const bgCanvas = gris50;
  static const bgSurface = gris0;
  static const bgSurfaceSubtle = gris100;
  static const bgRowHover = gris50;
  static const bgSelected = azul50;
  static const bgBrand = azul500;
  static const bgBrandHover = azul600;
  static const bgBrandSubtle = azul50;
  static const bgDisabled = gris100;
  static const bgOverlay = Color(0x7A141518); // gris900 at 48 %

  // --- Semantic: borders ---
  static const borderSubtle = gris100;
  static const borderDefault = gris200;
  static const borderStrong = gris300;
  static const borderBrand = azul500;
  static const borderFocus = azul500;
  static const borderDanger = rojo500;
}
