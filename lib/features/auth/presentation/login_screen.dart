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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<AuthBloc>().add(
      LoginSubmitted(
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
            'Welcome back',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.extraSmall),
          Text(
            'Sign in to follow the football that matters to you.',
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.large),
          AuthEmailField(controller: _emailController),
          const SizedBox(height: AppSpacing.medium),
          AuthPasswordField(
            controller: _passwordController,
            autofillHints: const [AutofillHints.password],
            onFieldSubmitted: (_) => isLoading ? null : _login(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: isLoading
                  ? null
                  : () => context.push(RouteConstants.forgotPassword),
              child: const Text('Forgot password?'),
            ),
          ),
          AuthSubmitButton(
            label: 'Log in',
            isLoading: isLoading,
            onPressed: _login,
          ),
          const SizedBox(height: AppSpacing.small),
          OutlinedButton(
            onPressed: isLoading
                ? null
                : () => context.read<AuthBloc>().add(
                    const GoogleLoginRequested(),
                  ),
            child: const Text('Continue with Google'),
          ),
          const SizedBox(height: AppSpacing.small),
          TextButton(
            onPressed: isLoading
                ? null
                : () => context.push(RouteConstants.signUp),
            child: const Text('Create an account'),
          ),
        ],
      );
    },
  );
}
