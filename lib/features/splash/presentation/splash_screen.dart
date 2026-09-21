import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_logo_background.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: AppLogoBackground(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppConfig.appName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.medium),
            const SizedBox(
              height: AppDimensions.loadingIndicatorSize,
              width: AppDimensions.loadingIndicatorSize,
              child: CircularProgressIndicator(
                strokeWidth: AppDimensions.loadingIndicatorStrokeWidth,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
