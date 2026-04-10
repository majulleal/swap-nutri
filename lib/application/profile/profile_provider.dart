import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swap_nutri/application/auth/auth_provider.dart';
import 'package:swap_nutri/data/repositories/profile_repository.dart';
import 'package:swap_nutri/domain/models/usuario.dart';

/// Provider do repositorio de perfil.
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});

/// Provider que carrega o perfil do usuario autenticado.
/// Recarrega automaticamente quando o estado de auth muda.
final profileProvider = FutureProvider<Usuario?>((ref) async {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);
  if (!isAuthenticated) return null;

  final repo = ref.watch(profileRepositoryProvider);
  return repo.getProfile();
});

/// Provider de conveniencia: o onboarding foi concluido?
final onboardingCompletoProvider = Provider<bool>((ref) {
  final profile = ref.watch(profileProvider);
  return profile.whenOrNull(data: (user) => user?.onboardingCompleto) ?? false;
});

/// Provider que indica se o perfil ainda esta carregando.
final profileLoadingProvider = Provider<bool>((ref) {
  final profile = ref.watch(profileProvider);
  return profile.isLoading;
});
