import 'package:swap_nutri/domain/models/usuario.dart';

class BmrCalculator {
  const BmrCalculator();

  /// Calcula a TMB (Taxa Metabolica Basal) usando Mifflin-St Jeor.
  double calcularTmb({
    required double peso,
    required double altura,
    required int idade,
    required String sexo,
  }) {
    final base = (10 * peso) + (6.25 * altura) - (5 * idade);
    return sexo == 'M' ? base + 5 : base - 161;
  }

  /// Calcula o TDEE (Total Daily Energy Expenditure).
  double calcularTdee({
    required double peso,
    required double altura,
    required int idade,
    required String sexo,
    required NivelAtividade nivelAtividade,
  }) {
    final tmb = calcularTmb(
      peso: peso,
      altura: altura,
      idade: idade,
      sexo: sexo,
    );
    return tmb * nivelAtividade.fator;
  }

  /// Sugere meta calorica com base no objetivo.
  int sugerirMetaCalorica({
    required double tdee,
    required Objetivo objetivo,
  }) {
    switch (objetivo) {
      case Objetivo.perder:
        return (tdee - 500).round();
      case Objetivo.manter:
        return tdee.round();
      case Objetivo.ganhar:
        return (tdee + 300).round();
    }
  }
}
