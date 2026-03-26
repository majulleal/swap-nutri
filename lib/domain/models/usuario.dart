import 'package:freezed_annotation/freezed_annotation.dart';

part 'usuario.freezed.dart';
part 'usuario.g.dart';

enum NivelAtividade {
  sedentario,
  leve,
  moderado,
  intenso;

  double get fator {
    switch (this) {
      case NivelAtividade.sedentario:
        return 1.2;
      case NivelAtividade.leve:
        return 1.375;
      case NivelAtividade.moderado:
        return 1.55;
      case NivelAtividade.intenso:
        return 1.725;
    }
  }
}

enum Objetivo { perder, manter, ganhar }

@freezed
class Usuario with _$Usuario {
  const factory Usuario({
    required String id,
    required String nome,
    required int idade,
    required String sexo,
    required double peso,
    required double altura,
    required NivelAtividade nivelAtividade,
    required int metaCalorica,
    required Objetivo objetivo,
    @Default(false) bool onboardingCompleto,
  }) = _Usuario;

  factory Usuario.fromJson(Map<String, dynamic> json) =>
      _$UsuarioFromJson(json);
}
