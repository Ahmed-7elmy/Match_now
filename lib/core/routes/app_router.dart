import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/matches/presentation/matches_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../constants/route_constants.dart';

class AppRouter {
  const AppRouter._();

  static final router = GoRouter(
    initialLocation: RouteConstants.splash,
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
      GoRoute(path: RouteConstants.home, builder: (_, _) => const HomeScreen()),
      GoRoute(
        path: RouteConstants.matches,
        builder: (_, _) => const MatchesScreen(),
      ),
      GoRoute(
        path: RouteConstants.profile,
        builder: (_, _) => const ProfileScreen(),
      ),
    ],
  );
}
