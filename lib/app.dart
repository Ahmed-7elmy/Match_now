import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/config/app_config.dart';
import 'core/network/api_client.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/matches/data/football_remote_data_source.dart';
import 'features/matches/data/football_repository.dart';

class EyeGoApp extends StatelessWidget {
  const EyeGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
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
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: AppConfig.appName,
        theme: AppTheme.light,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
