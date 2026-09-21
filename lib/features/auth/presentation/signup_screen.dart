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

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signUp() {
    if (!_formKey.currentState!.validate()) return;
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
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.failure.message)));
      }
    },
    builder: (context, state) {
      final bool isLoading = state is AuthLoading;
      return AuthFormScaffold(
        formKey: _formKey,
        showAppBar: true,
        children: [
          Text(
            'Create account',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppDimensions.spacingLarge),
          AuthEmailField(controller: _emailController),
          const SizedBox(height: AppDimensions.spacingMedium),
          AuthPasswordField(
            controller: _passwordController,
            autofillHints: const [AutofillHints.newPassword],
            onFieldSubmitted: (_) => isLoading ? null : _signUp(),
          ),
          const SizedBox(height: AppDimensions.spacingLarge),
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
