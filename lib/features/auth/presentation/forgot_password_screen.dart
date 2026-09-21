import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../logic/auth_bloc.dart';
import '../logic/auth_event.dart';
import '../logic/auth_state.dart';
import 'widgets/auth_form_fields.dart';
import 'widgets/auth_form_scaffold.dart';
import 'widgets/auth_submit_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetEmail() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<AuthBloc>().add(
      PasswordResetRequested(email: _emailController.text),
    );
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<AuthBloc, AuthState>(
    listener: (context, state) {
      if (state is PasswordResetEmailSent) {
        SnackbarUtils.showSuccess(context, 'Password reset email sent.');
      } else if (state is AuthFailure) {
        SnackbarUtils.showError(context, state.failure.message);
      }
    },
    builder: (context, state) {
      final bool isLoading = state is AuthLoading;
      return AuthFormScaffold(
        formKey: _formKey,
        showAppBar: true,
        children: [
          Text(
            'Reset password',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.extraSmall),
          Text(
            'Enter the email associated with your account and we will send a reset link.',
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.large),
          AuthEmailField(
            controller: _emailController,
            onFieldSubmitted: (_) => isLoading ? null : _sendResetEmail(),
          ),
          const SizedBox(height: AppSpacing.large),
          AuthSubmitButton(
            label: 'Send reset email',
            isLoading: isLoading,
            onPressed: _sendResetEmail,
          ),
        ],
      );
    },
  );
}
