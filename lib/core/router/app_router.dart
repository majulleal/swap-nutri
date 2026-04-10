import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swap_nutri/application/auth/auth_provider.dart';
import 'package:swap_nutri/application/profile/profile_provider.dart';
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

GoRouter createRouter(WidgetRef ref, AuthNotifier authNotifier) {
  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final isLoading = ref.read(authLoadingProvider);
      if (isLoading) return null;

      final isAuthenticated = ref.read(isAuthenticatedProvider);
      final currentPath = state.matchedLocation;

      final isAuthRoute =
          currentPath == AppRoutes.login || currentPath == AppRoutes.signup;

      // Nao autenticado tentando acessar rota protegida -> login
      if (!isAuthenticated && !isAuthRoute) {
        return AppRoutes.login;
      }

      // Autenticado tentando acessar login/signup
      if (isAuthenticated && isAuthRoute) {
        // Verifica se o onboarding foi concluido
        final profileLoading = ref.read(profileLoadingProvider);
        if (profileLoading) return null;

        final onboardingCompleto = ref.read(onboardingCompletoProvider);
        return onboardingCompleto ? AppRoutes.dashboard : AppRoutes.onboarding;
      }

      // Autenticado acessando dashboard sem onboarding
      if (isAuthenticated && currentPath == AppRoutes.dashboard) {
        final profileLoading = ref.read(profileLoadingProvider);
        if (profileLoading) return null;

        final onboardingCompleto = ref.read(onboardingCompletoProvider);
        if (!onboardingCompleto) {
          return AppRoutes.onboarding;
        }
      }

      return null;
    },
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

/// Notifica o GoRouter quando o estado de autenticacao muda.
class AuthNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}
