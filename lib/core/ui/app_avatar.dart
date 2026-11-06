import 'package:flutter/widgets.dart';

import '../theme/app_theme.dart';

/// Avatar · the initials of [name] on `bgBrandSubtle` in brand text. M 32 px, S 24 px.
class AppAvatar extends StatelessWidget {
  const AppAvatar({required this.name, this.small = false, super.key});

  /// Full name; the avatar shows the first letter of its first two words.
  final String name;
  final bool small;

  /// «Laura Gómez Ruiz» → «LG».
  static String initialsOf(String name) {
    final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    final initials = words.take(2).map((w) => w.characters.first).join();
    return initials.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final side = small ? AppSizes.avatarS : AppSizes.avatarM;
    return Semantics(
      label: name,
      child: ExcludeSemantics(
        child: Container(
          width: side,
          height: side,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.bgBrandSubtle,
            shape: BoxShape.circle,
          ),
          child: Text(
            initialsOf(name),
            style: (small ? AppText.label : AppText.bodySSemiBold).copyWith(
              color: AppColors.textBrand,
            ),
          ),
        ),
      ),
    );
  }
}
