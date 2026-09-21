import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_dimensions.dart';
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
    context.read<AuthBloc>().add(
      PasswordResetRequested(email: _emailController.text),
    );
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<AuthBloc, AuthState>(
    listener: (context, state) {
      if (state is PasswordResetEmailSent) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset email sent.')),
        );
      } else if (state is AuthFailure) {
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
            'Reset password',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppDimensions.spacingExtraSmall),
          const Text('Enter your email address to receive a reset link.'),
          const SizedBox(height: AppDimensions.spacingLarge),
          AuthEmailField(
            controller: _emailController,
            onFieldSubmitted: (_) => isLoading ? null : _sendResetEmail(),
          ),
          const SizedBox(height: AppDimensions.spacingLarge),
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
