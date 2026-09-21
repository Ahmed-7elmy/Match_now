import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/widgets/app_logo_background.dart';
import '../../auth/logic/auth_bloc.dart';
import '../../auth/logic/auth_event.dart';
import '../../auth/logic/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocListener<AuthBloc, AuthState>(
    listener: (context, state) {
      if (state is AuthFailure) {
        SnackbarUtils.showError(context, state.failure.message);
      }
    },
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: () =>
                context.read<AuthBloc>().add(const LogoutRequested()),
          ),
        ],
      ),
      body: AppLogoBackground(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is! AuthAuthenticated) {
              return const SizedBox.shrink();
            }

            final user = state.user;
            final displayName = user.displayName ?? 'Football fan';
            final email = user.email ?? 'No email address available';
            final photoUrl = user.photoURL;

            return SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.large),
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: AppDimensions.profileAvatarRadius,
                      backgroundImage: photoUrl == null
                          ? null
                          : NetworkImage(photoUrl),
                      child: photoUrl == null
                          ? const Icon(Icons.person_outline)
                          : null,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  Text(
                    displayName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: AppSpacing.extraSmall),
                  Text(
                    email,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.extraLarge),
                  const Divider(),
                  const SizedBox(height: AppSpacing.medium),
                  Text(
                    'Account',
                    style: Theme.of(context).textTheme.titleSmall
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.email_outlined),
                    title: const Text('Email'),
                    subtitle: Text(email),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  Text(
                    'About',
                    style: Theme.of(context).textTheme.titleSmall
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.sports_soccer_outlined),
                    title: Text('Match Point'),
                    subtitle: Text('Your football, all in one place.'),
                  ),
                  const SizedBox(height: AppSpacing.extraLarge),
                  OutlinedButton.icon(
                    onPressed: () =>
                        context.read<AuthBloc>().add(const LogoutRequested()),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text('Log out'),
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
