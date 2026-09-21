import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_logo_background.dart';

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
    body: AppLogoBackground(
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppDimensions.authContentMaxWidth,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: children,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
