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

/// Icon sizes (DESIGN.md · Icons): 20 px in buttons and inputs, 16 px in badges.
abstract final class AppIconSize {
  static const double xs = 12;
  static const double sm = 16;
  static const double md = 20;
  static const double lg = 24;
}

/// Fixed sizes of the kit components (DESIGN.md · Component kit).
abstract final class AppSizes {
  /// Buttons and inputs in forms and bars (size M).
  static const double controlM = 40;

  /// Buttons and inputs in tables and filters (size S).
  static const double controlS = 32;
  static const double iconButton = 36;
  static const double iconButtonS = 28;
  static const double menuItem = 36;
  static const double menuMinWidth = 200;
  static const double checkbox = 20;
  static const double badgeM = 22;
  static const double badgeS = 18;
  static const double chip = 26;
  static const double taxonomyChip = 24;
  static const double tableHeader = 40;
  static const double tableRow = 48;
  static const double tableCheckboxColumn = 48;
  static const double tableAlertBorder = 3;
  static const double paginationBar = 52;
  static const double tabs = 42;
  static const double tabIndicator = 2;
  static const double segmented = 36;
  static const double segmentedS = 28;
  static const double progressBar = 240;
  static const double progressTrack = 6;
  static const double avatarM = 32;
  static const double avatarS = 24;
  static const double scoreBadgeWidth = 40;
  static const double scoreBadgeHeight = 28;
  static const double scoreBadgeLarge = 80;
  static const double scoreMeterTrack = 8;
  static const double kpiIconTile = 28;
  static const double toastWidth = 380;
  static const double tooltipMaxWidth = 260;
  static const double skeletonLine = 12;
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

  /// Side column of a detail screen: the customer card of A-05.
  static const double detailAsideWidth = 360;
  static const double dialogM = 560;
  static const double dialogL = 800;
  static const double brandMarkSize = 32;
  static const double searchFieldWidth = 440;
  static const double loginCardWidth = 420;
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
