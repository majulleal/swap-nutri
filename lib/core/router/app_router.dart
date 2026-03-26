import 'package:go_router/go_router.dart';
import 'package:swap_nutri/presentation/auth/login_screen.dart';
import 'package:swap_nutri/presentation/auth/signup_screen.dart';
import 'package:swap_nutri/presentation/dashboard/dashboard_screen.dart';
import 'package:swap_nutri/presentation/onboarding/onboarding_screen.dart';

abstract class AppRoutes {
  static const login = '/login';
  static const signup = '/signup';
  static const onboarding = '/onboarding';
  static const dashboard = '/dashboard';
  static const calculator = '/calculator';
  static const mealRegister = '/meal/:tipo';
  static const profile = '/profile';
}

GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppRoutes.login,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
  );
}
