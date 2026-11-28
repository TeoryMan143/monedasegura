import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import 'realtime_session.dart';
import 'router.dart';

/// Root widget: router, theme and Spanish locale. It also keeps the realtime channels
/// open while an analyst is signed in.
class MonedaSeguraApp extends ConsumerWidget {
  const MonedaSeguraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(realtimeSessionProvider);
    return MaterialApp.router(
      title: 'Moneda Segura',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: ref.watch(routerProvider),
      locale: const Locale('es'),
      supportedLocales: const [Locale('es')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
    );
  }
}
