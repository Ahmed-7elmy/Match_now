import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_config.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../logic/auth_bloc.dart';
import '../logic/auth_event.dart';
import '../logic/auth_state.dart';
import 'widgets/auth_form_fields.dart';
import 'widgets/auth_form_scaffold.dart';
import 'widgets/auth_submit_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUp() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<AuthBloc>().add(
      SignupSubmitted(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<AuthBloc, AuthState>(
    listener: (context, state) {
      if (state is AuthFailure) {
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
            AppConfig.appName,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.small),
          Text(
            'Create account',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.extraSmall),
          Text(
            'Create an account to keep your football in one place.',
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.large),
          AuthEmailField(controller: _emailController),
          const SizedBox(height: AppSpacing.medium),
          AuthPasswordField(
            controller: _passwordController,
            autofillHints: const [AutofillHints.newPassword],
            onFieldSubmitted: (_) => isLoading ? null : _signUp(),
          ),
          const SizedBox(height: AppSpacing.medium),
          AuthPasswordField(
            controller: _confirmPasswordController,
            label: 'Confirm password',
            autofillHints: const [AutofillHints.newPassword],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Confirm your password.';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match.';
              }
              return null;
            },
            onFieldSubmitted: (_) => isLoading ? null : _signUp(),
          ),
          const SizedBox(height: AppSpacing.large),
          AuthSubmitButton(
            label: 'Create account',
            isLoading: isLoading,
            onPressed: _signUp,
          ),
          TextButton(
            onPressed: isLoading
                ? null
                : () => context.go(RouteConstants.login),
            child: const Text('Already have an account? Log in'),
          ),
        ],
      );
    },
  );
}
