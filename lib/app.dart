import 'package:flutter/material.dart';

import 'core/config/app_config.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

class EyeGoApp extends StatelessWidget {
  const EyeGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppConfig.appName,
      theme: AppTheme.light,
      routerConfig: AppRouter.router,
    );
  }
}
