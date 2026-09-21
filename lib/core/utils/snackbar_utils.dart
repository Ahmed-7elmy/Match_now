import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SnackbarUtils {
  const SnackbarUtils._();

  static void showError(BuildContext context, String message) {
    _show(context, message, AppColors.error);
  }

  static void showSuccess(BuildContext context, String message) {
    _show(context, message, AppColors.success);
  }

  static void _show(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(backgroundColor: color, content: Text(message)));
  }
}
