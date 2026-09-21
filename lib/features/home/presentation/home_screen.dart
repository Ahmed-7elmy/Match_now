import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_config.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_logo_background.dart';
import '../../auth/logic/auth_bloc.dart';
import '../../auth/logic/auth_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text(AppConfig.appName)),
    body: AppLogoBackground(
      child: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final greeting =
                state is AuthAuthenticated && state.user.displayName != null
                ? 'Good to see you, ${state.user.displayName}'
                : 'Your football, one place.';

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.large),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: AppSpacing.extraSmall),
                  Text(
                    'Follow fixtures and stay close to the game.',
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.extraLarge),
                  Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(AppSpacing.medium),
                      leading: const Icon(Icons.calendar_today_outlined),
                      title: const Text("Today's matches"),
                      subtitle: const Text(
                        'See fixtures, scores, and details.',
                      ),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () => context.push(RouteConstants.matches),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.extraLarge),
                  Text(
                    'Quick access',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickAccessCard(
                          icon: Icons.sports_soccer_outlined,
                          label: 'Matches',
                          onTap: () => context.push(RouteConstants.matches),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.medium),
                      Expanded(
                        child: _QuickAccessCard(
                          icon: Icons.person_outline,
                          label: 'Profile',
                          onTap: () => context.push(RouteConstants.profile),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}

class _QuickAccessCard extends StatelessWidget {
  const _QuickAccessCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    child: InkWell(
      borderRadius: BorderRadius.circular(AppRadius.small),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: AppSpacing.medium),
            Text(label, style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
      ),
    ),
  );
}
