import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// C-01 / C-02 · Login (HU-01).
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Moneda Segura', style: AppText.display),
            const SizedBox(height: AppSpace.sm),
            Text(
              'Inicio de sesión en construcción · HU-01',
              style: AppText.bodyM.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
