import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text(AppConfig.appName)));
}
