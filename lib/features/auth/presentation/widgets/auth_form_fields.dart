import 'package:flutter/material.dart';

import '../../../../core/utils/validators.dart';

class AuthEmailField extends StatelessWidget {
  const AuthEmailField({
    required this.controller,
    this.onFieldSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    keyboardType: TextInputType.emailAddress,
    autofillHints: const [AutofillHints.email],
    decoration: const InputDecoration(labelText: 'Email'),
    validator: Validators.email,
    onFieldSubmitted: onFieldSubmitted,
  );
}

class AuthPasswordField extends StatelessWidget {
  const AuthPasswordField({
    required this.controller,
    required this.autofillHints,
    this.onFieldSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final Iterable<String> autofillHints;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    obscureText: true,
    autofillHints: autofillHints,
    decoration: const InputDecoration(labelText: 'Password'),
    validator: Validators.password,
    onFieldSubmitted: onFieldSubmitted,
  );
}
