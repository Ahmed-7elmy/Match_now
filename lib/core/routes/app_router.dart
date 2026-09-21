import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/logic/auth_bloc.dart';
import '../../features/auth/logic/auth_state.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/matches/presentation/matches_screen.dart';
import '../../features/matches/data/football_repository.dart';
import '../../features/matches/logic/matches_bloc.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../constants/route_constants.dart';

class AppRouter {
  AppRouter({required AuthBloc authBloc})
    : _authRefreshNotifier = _AuthRefreshNotifier(authBloc) {
    router = GoRouter(
      initialLocation: RouteConstants.splash,
      refreshListenable: _authRefreshNotifier,
      redirect: (_, state) => _redirect(state),
      routes: [
        GoRoute(
          path: RouteConstants.splash,
          builder: (_, _) => const SplashScreen(),
        ),
        GoRoute(
          path: RouteConstants.login,
          builder: (_, _) => const LoginScreen(),
        ),
        GoRoute(
          path: RouteConstants.signUp,
          builder: (_, _) => const SignupScreen(),
        ),
        GoRoute(
          path: RouteConstants.forgotPassword,
          builder: (_, _) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: RouteConstants.home,
          builder: (_, _) => const HomeScreen(),
        ),
        GoRoute(
          path: RouteConstants.matches,
          builder: (context, _) => BlocProvider(
            create: (context) =>
                MatchesBloc(repository: context.read<FootballRepository>()),
            child: const MatchesScreen(),
          ),
        ),
        GoRoute(
          path: RouteConstants.profile,
          builder: (_, _) => const ProfileScreen(),
        ),
      ],
    );
  }

  final _AuthRefreshNotifier _authRefreshNotifier;
  late final GoRouter router;

  String? _redirect(GoRouterState state) {
    final String currentPath = state.uri.path;
    final bool isAuthRoute = switch (currentPath) {
      RouteConstants.login ||
      RouteConstants.signUp ||
      RouteConstants.forgotPassword => true,
      _ => false,
    };

    if (!_authRefreshNotifier.isResolved) {
      return currentPath == RouteConstants.splash
          ? null
          : RouteConstants.splash;
    }

    if (!_authRefreshNotifier.isAuthenticated) {
      return isAuthRoute ? null : RouteConstants.login;
    }

    return isAuthRoute || currentPath == RouteConstants.splash
        ? RouteConstants.home
        : null;
  }

  void dispose() {
    router.dispose();
    _authRefreshNotifier.dispose();
  }
}

class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(AuthBloc authBloc) {
    _status = _statusFrom(authBloc.state) ?? _AuthStatus.pending;
    _subscription = authBloc.stream.listen((state) {
      final _AuthStatus? nextStatus = _statusFrom(state);
      if (nextStatus == null || nextStatus == _status) return;

      _status = nextStatus;
      notifyListeners();
    });
  }

  late _AuthStatus _status;
  late final StreamSubscription<AuthState> _subscription;

  bool get isResolved => _status != _AuthStatus.pending;
  bool get isAuthenticated => _status == _AuthStatus.authenticated;

  _AuthStatus? _statusFrom(AuthState state) => switch (state) {
    AuthAuthenticated() => _AuthStatus.authenticated,
    AuthUnauthenticated() => _AuthStatus.unauthenticated,
    _ => null,
  };

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

enum _AuthStatus { pending, authenticated, unauthenticated }
