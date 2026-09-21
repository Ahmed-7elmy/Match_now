import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_config.dart';
import '../../../core/constants/route_constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text(AppConfig.appName)),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Your football home'),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.push(RouteConstants.matches),
            icon: const Icon(Icons.sports_soccer_outlined),
            label: const Text('Matches'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => context.push(RouteConstants.profile),
            icon: const Icon(Icons.person_outline),
            label: const Text('Profile'),
          ),
        ],
      ),
    ),
  );
}
