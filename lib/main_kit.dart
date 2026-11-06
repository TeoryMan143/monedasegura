import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'core/theme/app_theme.dart';
import 'dev/kit_gallery/kit_gallery_screen.dart';

/// Dev-only entry point: a gallery of every `core/ui` component with its variants.
///
/// ```bash
/// flutter run -d windows -t lib/main_kit.dart
/// ```
///
/// Use it to check a component against Figma *Componentes* (`4:3`) before using it in a
/// screen. It is not part of the app and never ships.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'es';
  await initializeDateFormatting('es');
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'Moneda Segura · Kit',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const KitGalleryScreen(),
      ),
    ),
  );
}
