import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_icon.dart';

/// One entry of an [AppMenu].
sealed class AppMenuEntry {
  const AppMenuEntry();
}

/// A clickable option: Opción de menú (Figma Componentes `4:3`), 36 px tall.
class AppMenuAction extends AppMenuEntry {
  const AppMenuAction({
    required this.label,
    required this.onSelected,
    this.icon,
    this.detail,
    this.selected = false,
    this.destructive = false,
  });

  final String label;

  /// Null disables the option.
  final VoidCallback? onSelected;
  final AppIcons? icon;

  /// Text at the right end (a shortcut, a count…). Hidden while [selected].
  final String? detail;

  /// Shows `bgSelected` and the Check icon.
  final bool selected;

  /// Danger text, for irreversible actions.
  final bool destructive;
}

/// A non-interactive block at the top of a menu, e.g. the analyst's name and email.
class AppMenuHeader extends AppMenuEntry {
  const AppMenuHeader(this.child);

  final Widget child;
}

/// A divider between groups of options.
class AppMenuDivider extends AppMenuEntry {
  const AppMenuDivider();
}

/// Menú desplegable · a popup menu anchored to [builder]'s trigger (DESIGN.md · AppMenu).
///
/// White surface, radius `md`, `menu` shadow. Keyboard: arrows move, Enter selects, Esc
/// closes. The trigger calls `controller.open()` / `close()`:
///
/// ```dart
/// AppMenu(
///   entries: [AppMenuAction(label: 'Cerrar sesión', icon: AppIcons.logout, onSelected: signOut)],
///   builder: (context, controller) => AppButton(label: 'Más', onPressed: controller.toggle),
/// )
/// ```
class AppMenu extends StatefulWidget {
  const AppMenu({
    required this.entries,
    required this.builder,
    this.minWidth = AppSizes.menuMinWidth,
    this.alignmentOffset,
    this.alignEnd = false,
    super.key,
  });

  final List<AppMenuEntry> entries;
  final Widget Function(BuildContext context, AppMenuController controller)
  builder;

  /// Minimum menu width. Dropdowns pass the width of their field.
  final double minWidth;

  /// Offset from the trigger's bottom left corner.
  final Offset? alignmentOffset;

  /// Aligns the menu's right edge with the trigger's right edge, for triggers at the
  /// right end of the window (user menu, bell). The menu is then exactly [minWidth].
  final bool alignEnd;

  @override
  State<AppMenu> createState() => _AppMenuState();

  /// Offset that puts a [menuStyle] `alignEnd` menu of [width] under its trigger, right
  /// edges aligned.
  static Offset alignEndOffset(double width) => Offset(-width, AppSpace.xs);

  /// Surface of every menu and popover of the kit: white, radius `md`, subtle border and
  /// shadow. Use it in a `MenuAnchor` that needs custom content (e.g. the C-06
  /// notifications panel) so it looks like an [AppMenu].
  ///
  /// With [alignEnd] the menu is exactly [minWidth] wide and hangs from the trigger's
  /// bottom right corner; pair it with [alignEndOffset].
  static MenuStyle menuStyle({
    double minWidth = AppSizes.menuMinWidth,
    bool alignEnd = false,
  }) {
    return MenuStyle(
      alignment: alignEnd
          ? AlignmentDirectional.bottomEnd
          : AlignmentDirectional.bottomStart,
      maximumSize: alignEnd
          ? WidgetStatePropertyAll(Size(minWidth, double.infinity))
          : null,
      backgroundColor: const WidgetStatePropertyAll(AppColors.bgSurface),
      surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
      shadowColor: const WidgetStatePropertyAll(AppColors.gris900),
      elevation: const WidgetStatePropertyAll(4),
      padding: const WidgetStatePropertyAll(EdgeInsets.all(AppSpace.xs)),
      minimumSize: WidgetStatePropertyAll(Size(minWidth, 0)),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
          side: BorderSide(color: AppColors.borderSubtle),
        ),
      ),
    );
  }
}

/// Opens and closes an [AppMenu] from its trigger.
class AppMenuController {
  AppMenuController._(this._controller);

  final MenuController _controller;

  bool get isOpen => _controller.isOpen;

  void open() => _controller.open();

  void close() => _controller.close();

  void toggle() => isOpen ? close() : open();
}

class _AppMenuState extends State<AppMenu> {
  final _menuController = MenuController();
  late final _controller = AppMenuController._(_menuController);

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      controller: _menuController,
      alignmentOffset:
          widget.alignmentOffset ??
          (widget.alignEnd
              ? AppMenu.alignEndOffset(widget.minWidth)
              : const Offset(0, AppSpace.xs)),
      style: AppMenu.menuStyle(
        minWidth: widget.minWidth,
        alignEnd: widget.alignEnd,
      ),
      menuChildren: [for (final entry in widget.entries) _buildEntry(entry)],
      builder: (context, controller, child) =>
          widget.builder(context, _controller),
    );
  }

  Widget _buildEntry(AppMenuEntry entry) {
    return switch (entry) {
      AppMenuHeader(:final child) => Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpace.md,
          AppSpace.sm,
          AppSpace.md,
          AppSpace.sm,
        ),
        child: child,
      ),
      AppMenuDivider() => const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpace.xs),
        child: Divider(),
      ),
      AppMenuAction() => _MenuOption(action: entry),
    };
  }
}

class _MenuOption extends StatelessWidget {
  const _MenuOption({required this.action});

  final AppMenuAction action;

  @override
  Widget build(BuildContext context) {
    final enabled = action.onSelected != null;
    final foreground = !enabled
        ? AppColors.textDisabled
        : action.destructive
        ? StatusTone.danger.text
        : AppColors.textPrimary;
    final iconColor = !enabled
        ? AppColors.textDisabled
        : action.destructive
        ? StatusTone.danger.text
        : AppColors.iconPrimary;

    return MenuItemButton(
      onPressed: action.onSelected,
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size(0, AppSizes.menuItem)),
        maximumSize: const WidgetStatePropertyAll(
          Size(double.infinity, AppSizes.menuItem),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: AppSpace.md),
        ),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
          ),
        ),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (action.selected) return AppColors.bgSelected;
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return AppColors.bgRowHover;
          }
          return null;
        }),
        foregroundColor: WidgetStatePropertyAll(foreground),
        textStyle: WidgetStatePropertyAll(
          action.selected ? AppText.bodyMMedium : AppText.bodyM,
        ),
      ),
      leadingIcon: action.icon == null
          ? null
          : AppIcon(action.icon!, size: AppIconSize.md, color: iconColor),
      trailingIcon: action.selected
          ? const AppIcon(
              AppIcons.check,
              size: AppIconSize.sm,
              color: AppColors.iconBrand,
            )
          : action.detail == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: AppSpace.lg),
              child: Text(
                action.detail!,
                style: AppText.bodyS.copyWith(color: AppColors.textTertiary),
              ),
            ),
      child: Text(action.label, style: TextStyle(color: foreground)),
    );
  }
}
