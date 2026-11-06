import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import 'widgets/login_form.dart';
import 'widgets/login_hero.dart';

/// C-01 / C-02 · Login (HU-01).
///
/// Left: the Azul Icesi hero. Right: the white card with the form. The invalid
/// credentials message (C-02) lives inside [LoginForm].
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: LoginHero()),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSpace.x3l),
                child: LoginForm(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
