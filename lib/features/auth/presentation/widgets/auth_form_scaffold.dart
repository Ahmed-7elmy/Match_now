import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimensions.dart';

class AuthFormScaffold extends StatelessWidget {
  const AuthFormScaffold({
    required this.formKey,
    required this.children,
    this.showAppBar = false,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final List<Widget> children;
  final bool showAppBar;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: showAppBar ? AppBar() : null,
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppDimensions.authContentMaxWidth,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingLarge),
            child: Form(
              key: formKey,
              child: ListView(shrinkWrap: true, children: children),
            ),
          ),
        ),
      ),
    ),
  );
}
