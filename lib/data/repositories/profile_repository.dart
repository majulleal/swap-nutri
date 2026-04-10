import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swap_nutri/data/datasources/supabase_client.dart';
import 'package:swap_nutri/domain/models/usuario.dart';

class ProfileRepository {
  ProfileRepository();

  SupabaseClient get _client => AppSupabaseClient.client;

  /// Busca o perfil do usuario autenticado.
  /// Retorna null se o perfil ainda nao foi criado.
  Future<Usuario?> getProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final data = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (data == null) return null;

    return Usuario(
      id: data['id'] as String,
      nome: data['nome'] as String,
      idade: data['idade'] as int,
      sexo: data['sexo'] as String,
      peso: (data['peso'] as num).toDouble(),
      altura: (data['altura'] as num).toDouble(),
      nivelAtividade: NivelAtividade.values.firstWhere(
        (e) => e.name == data['nivel_atividade'],
      ),
      metaCalorica: data['meta_calorica'] as int,
      objetivo: Objetivo.values.firstWhere((e) => e.name == data['objetivo']),
      onboardingCompleto: data['onboarding_completo'] as bool? ?? false,
    );
  }

  /// Salva o perfil do usuario (insert ou update via upsert).
  Future<void> saveProfile(Usuario usuario) async {
    await _client.from('profiles').upsert({
      'id': usuario.id,
      'nome': usuario.nome,
      'idade': usuario.idade,
      'sexo': usuario.sexo,
      'peso': usuario.peso,
      'altura': usuario.altura,
      'nivel_atividade': usuario.nivelAtividade.name,
      'meta_calorica': usuario.metaCalorica,
      'objetivo': usuario.objetivo.name,
      'onboarding_completo': usuario.onboardingCompleto,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }
}
