import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimensions.dart';

class AuthSubmitButton extends StatelessWidget {
  const AuthSubmitButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
    super.key,
  });

  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: isLoading ? null : onPressed,
    child: isLoading
        ? const SizedBox(
            width: AppDimensions.loadingIndicatorSize,
            height: AppDimensions.loadingIndicatorSize,
            child: CircularProgressIndicator(
              strokeWidth: AppDimensions.loadingIndicatorStrokeWidth,
            ),
          )
        : Text(label),
  );
}
