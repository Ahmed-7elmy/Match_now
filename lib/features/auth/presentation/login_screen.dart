import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/route_constants.dart';
import '../../../core/theme/app_dimensions.dart';
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
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.failure.message)));
      }
    },
    builder: (context, state) {
      final bool isLoading = state is AuthLoading;
      return AuthFormScaffold(
        formKey: _formKey,
        children: [
          Text(
            'Welcome back',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppDimensions.spacingLarge),
          AuthEmailField(controller: _emailController),
          const SizedBox(height: AppDimensions.spacingMedium),
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
          const SizedBox(height: AppDimensions.spacingSmall),
          OutlinedButton(
            onPressed: isLoading
                ? null
                : () => context.read<AuthBloc>().add(
                    const GoogleLoginRequested(),
                  ),
            child: const Text('Continue with Google'),
          ),
          const SizedBox(height: AppDimensions.spacingSmall),
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
