import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swap_nutri/data/datasources/supabase_client.dart';

class AuthRepository {
  AuthRepository();

  SupabaseClient get _client => AppSupabaseClient.client;
  GoTrueClient get _auth => _client.auth;

  /// Stream de mudancas no estado de autenticacao.
  Stream<AuthState> get onAuthStateChange =>
      _auth.onAuthStateChange;

  /// Sessao atual (null se nao autenticado).
  Session? get currentSession => _auth.currentSession;

  /// Usuario atual (null se nao autenticado).
  User? get currentUser => _auth.currentUser;

  /// Cadastro com e-mail e senha.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return _auth.signUp(email: email, password: password);
  }

  /// Login com e-mail e senha.
  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) async {
    return _auth.signInWithPassword(email: email, password: password);
  }

  /// Logout — encerra sessao e limpa tokens.
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
