import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:window_manager/window_manager.dart';

import 'app/app.dart';
import 'app/config_error_app.dart';
import 'core/config/env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setUpWindow();

  Intl.defaultLocale = 'es';
  await initializeDateFormatting('es');

  // The prototype runs on fake repositories and needs no backend.
  if (!Env.useFakeData) {
    final missingKeys = Env.missingKeys;
    if (missingKeys.isNotEmpty) {
      // ignore: riverpod_lint/missing_provider_scope
      runApp(ConfigErrorApp(missingKeys: missingKeys));
      return;
    }
    await Supabase.initialize(
      url: Env.supabaseUrl,
      publishableKey: Env.supabaseAnonKey,
    );
  }

  runApp(const ProviderScope(child: MonedaSeguraApp()));
}

/// Minimum size 1280×720 and the window title (ARCHITECTURAL_SPINE.md · Desktop).
Future<void> _setUpWindow() async {
  await windowManager.ensureInitialized();
  const options = WindowOptions(
    title: 'Moneda Segura',
    size: Size(1440, 900),
    minimumSize: Size(1280, 720),
    center: true,
  );
  await windowManager.waitUntilReadyToShow(options, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}
