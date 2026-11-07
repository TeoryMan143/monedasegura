import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../controllers/login_controller.dart';

/// C-01 / C-02 · the white login card: email, password and «Iniciar sesión».
///
/// Field errors are checked on submit and then live. A wrong email or password shows
/// one generic `danger` banner (C-02) that never says which of the two failed.
class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _passwordFocus = FocusNode();
  bool _submitted = false;

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  String? get _emailError {
    if (!_submitted) return null;
    final email = _email.text.trim();
    if (email.isEmpty) return 'Escribe tu correo.';
    if (!_emailPattern.hasMatch(email)) {
      return 'Escribe un correo válido, por ejemplo nombre@monedasegura.co.';
    }
    return null;
  }

  String? get _passwordError =>
      _submitted && _password.text.isEmpty ? 'Escribe tu contraseña.' : null;

  void _onEdited(String _) {
    ref.read(loginControllerProvider.notifier).clearError();
    if (_submitted) setState(() {});
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    if (_emailError != null || _passwordError != null) return;
    await ref
        .read(loginControllerProvider.notifier)
        .signIn(email: _email.text, password: _password.text);
  }

  @override
  Widget build(BuildContext context) {
    final login = ref.watch(loginControllerProvider);
    final loading = login.isLoading;
    final error = login.hasError ? login.error : null;

    return Container(
      width: AppLayout.loginCardWidth,
      padding: const EdgeInsets.all(AppSpace.x4l),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: AppShadows.card,
      ),
      child: AutofillGroup(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Iniciar sesión', style: AppText.h1),
            const SizedBox(height: AppSpace.xs),
            Text(
              'Ingresa con tu cuenta de analista.',
              style: AppText.bodyM.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpace.xxl),
            if (error != null) ...[
              _ErrorBanner(error: error),
              const SizedBox(height: AppSpace.lg),
            ],
            AppTextField(
              label: 'Correo',
              hint: 'nombre@monedasegura.co',
              controller: _email,
              prefixIcon: AppIcons.mail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              autofocus: true,
              required: true,
              enabled: !loading,
              errorText: _emailError,
              onChanged: _onEdited,
              onSubmitted: (_) => _passwordFocus.requestFocus(),
            ),
            const SizedBox(height: AppSpace.lg),
            AppTextField(
              label: 'Contraseña',
              controller: _password,
              focusNode: _passwordFocus,
              variant: AppTextFieldVariant.password,
              prefixIcon: AppIcons.lock,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              required: true,
              enabled: !loading,
              errorText: _passwordError,
              onChanged: _onEdited,
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: AppSpace.xxl),
            AppButton(
              label: loading ? 'Iniciando sesión…' : 'Iniciar sesión',
              onPressed: _submit,
              loading: loading,
              expand: true,
            ),
          ],
        ),
      ),
    );
  }
}

/// C-02 · one generic message: it never reveals whether the email exists.
class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    if (error is InvalidCredentialsFailure) {
      return const InlineBanner(
        tone: StatusTone.danger,
        title: 'Correo o contraseña incorrectos',
        message: 'Revisa los datos e inténtalo de nuevo.',
      );
    }
    final text = failureMessage(error);
    return InlineBanner(
      tone: StatusTone.danger,
      title: text.title,
      message: text.message,
    );
  }
}
