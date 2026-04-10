import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swap_nutri/data/repositories/auth_repository.dart';

/// Provider do repositorio de autenticacao.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Estado de autenticacao reativo.
///
/// Escuta `onAuthStateChange` do Supabase e expoe a `Session` atual.
/// Retorna `null` quando o usuario nao esta autenticado.
final authStateProvider = StreamProvider<Session?>((ref) {
  final repo = ref.watch(authRepositoryProvider);

  final controller = StreamController<Session?>();

  // Emite a sessao atual e depois escuta mudancas.
  controller
    ..add(repo.currentSession)
    ..addStream(
      repo.onAuthStateChange.map((authState) => authState.session),
    );

  ref.onDispose(controller.close);

  return controller.stream;
});

/// Provider de conveniencia que indica se o usuario esta logado.
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.whenOrNull(data: (session) => session != null) ?? false;
});

/// Provider de conveniencia para acessar o User atual.
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.whenOrNull(data: (session) => session?.user);
});

/// Provider que indica se o estado de auth ainda esta carregando.
final authLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.isLoading;
});
