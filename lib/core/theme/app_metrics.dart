import 'package:flutter/painting.dart';

/// Spacing scale on the 4/8 px grid (DESIGN.md · Spacing).
abstract final class AppSpace {
  static const double none = 0;
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double x3l = 32;
  static const double x4l = 40;
  static const double x5l = 48;
  static const double x6l = 64;
}

/// Corner radii (DESIGN.md · Radius).
abstract final class AppRadius {
  static const double none = 0;
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
  static const double full = 999;
}

/// Fixed sizes of the app layout (DESIGN.md · Layout).
abstract final class AppLayout {
  static const double sideMenuWidth = 240;
  static const double sideMenuCollapsedWidth = 72;
  static const double topBarHeight = 56;
  static const double navItemHeight = 40;
  static const double contentPadding = AppSpace.x3l;
  static const double blockGap = AppSpace.xxl;
  static const double sidePanelWidth = 400;
  static const double dialogM = 560;
  static const double dialogL = 800;
  static const double brandMarkSize = 32;
}

/// Soft, neutral shadows. No Material elevation tints (DESIGN.md · Elevation).
abstract final class AppShadows {
  static const card = [
    BoxShadow(color: Color(0x0F141518), offset: Offset(0, 1), blurRadius: 2),
  ];

  static const menu = [
    BoxShadow(color: Color(0x1A141518), offset: Offset(0, 4), blurRadius: 12),
    BoxShadow(color: Color(0x0F141518), offset: Offset(0, 1), blurRadius: 3),
  ];

  static const modal = [
    BoxShadow(color: Color(0x29141518), offset: Offset(0, 16), blurRadius: 40),
    BoxShadow(color: Color(0x0F141518), offset: Offset(0, 2), blurRadius: 6),
  ];

  /// Keyboard focus ring, required on every interactive element.
  static const focusRing = [
    BoxShadow(color: Color(0x595454E9), spreadRadius: 3),
  ];
}
