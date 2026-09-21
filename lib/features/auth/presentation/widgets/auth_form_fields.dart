import 'package:flutter/material.dart';

import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';

class AuthEmailField extends StatelessWidget {
  const AuthEmailField({
    required this.controller,
    this.onFieldSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) => AppTextField(
    controller: controller,
    label: 'Email',
    hint: 'name@example.com',
    prefixIcon: Icons.email_outlined,
    keyboardType: TextInputType.emailAddress,
    textInputAction: TextInputAction.next,
    autofillHints: const [AutofillHints.email],
    validator: Validators.email,
    onFieldSubmitted: onFieldSubmitted,
  );
}

class AuthPasswordField extends StatefulWidget {
  const AuthPasswordField({
    required this.controller,
    required this.autofillHints,
    this.label = 'Password',
    this.validator,
    this.onFieldSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final Iterable<String> autofillHints;
  final String label;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) => AppTextField(
    controller: widget.controller,
    label: widget.label,
    obscureText: _obscurePassword,
    textInputAction: TextInputAction.done,
    autofillHints: widget.autofillHints,
    prefixIcon: Icons.lock_outline,
    suffixIcon: IconButton(
      tooltip: _obscurePassword ? 'Show password' : 'Hide password',
      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
      icon: Icon(
        _obscurePassword
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined,
      ),
    ),
    validator: widget.validator ?? Validators.password,
    onFieldSubmitted: widget.onFieldSubmitted,
  );
}
