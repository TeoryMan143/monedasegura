import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// Shown instead of the app when required `--dart-define` values are missing.
class ConfigErrorApp extends StatelessWidget {
  const ConfigErrorApp({required this.missingKeys, super.key});

  final List<String> missingKeys;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Falta configuración', style: AppText.h1),
              const SizedBox(height: AppSpace.sm),
              Text(
                'Ejecuta la app con --dart-define para: ${missingKeys.join(', ')}.',
                style: AppText.bodyM.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
