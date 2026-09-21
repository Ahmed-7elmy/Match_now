import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'core/config/app_config.dart';
import 'core/network/api_client.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/auth_remote_data_source.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/logic/auth_bloc.dart';
import 'features/auth/logic/auth_event.dart';
import 'features/matches/data/football_remote_data_source.dart';
import 'features/matches/data/football_repository.dart';

class EyeGoApp extends StatelessWidget {
  const EyeGoApp({super.key, this.authRepository});

  final AuthRepository? authRepository;

  @override
  Widget build(BuildContext context) {
    final AuthRepository resolvedAuthRepository =
        authRepository ??
        AuthRepositoryImpl(
          FirebaseAuthRemoteDataSource(
            firebaseAuth: FirebaseAuth.instance,
            googleSignIn: GoogleSignIn.instance,
          ),
        );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: resolvedAuthRepository),
        RepositoryProvider(create: (_) => ApiClient()),
        RepositoryProvider<FootballRemoteDataSource>(
          create: (context) =>
              FootballRemoteDataSourceImpl(context.read<ApiClient>()),
        ),
        RepositoryProvider<FootballRepository>(
          create: (context) =>
              FootballRepositoryImpl(context.read<FootballRemoteDataSource>()),
        ),
      ],
      child: BlocProvider(
        create: (context) =>
            AuthBloc(repository: context.read<AuthRepository>())
              ..add(const AuthSubscriptionRequested()),
        child: const _RouterApp(),
      ),
    );
  }
}

class _RouterApp extends StatefulWidget {
  const _RouterApp();

  @override
  State<_RouterApp> createState() => _RouterAppState();
}

class _RouterAppState extends State<_RouterApp> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(authBloc: context.read<AuthBloc>());
  }

  @override
  void dispose() {
    _appRouter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    debugShowCheckedModeBanner: false,
    title: AppConfig.appName,
    theme: AppTheme.light,
    routerConfig: _appRouter.router,
  );
}
