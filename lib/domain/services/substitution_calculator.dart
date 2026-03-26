import 'package:swap_nutri/domain/models/alimento.dart';
import 'package:swap_nutri/domain/models/macros.dart';
import 'package:swap_nutri/domain/models/substitution_result.dart';

class SubstitutionCalculator {
  const SubstitutionCalculator();

  SubstitutionResult calculate({
    required Alimento origem,
    required double quantidadeOrigem,
    required Alimento destino,
    required CriterioEquivalencia criterio,
  }) {
    final macrosOrigem = origem.por100g.scale(quantidadeOrigem / 100);
    final valorCriterio = macrosOrigem.getByCriterio(criterio);
    final valorDestino100g = destino.por100g.getByCriterio(criterio);

    if (valorDestino100g == 0) {
      throw ArgumentError(
        'O alimento "${destino.nome}" possui 0 ${criterio.name} por 100g. '
        'Nao e possivel calcular equivalencia por esse criterio.',
      );
    }

    final quantidadeDestino = (valorCriterio / valorDestino100g) * 100;
    final macrosDestino = destino.por100g.scale(quantidadeDestino / 100);

    return SubstitutionResult(
      origem: origem,
      destino: destino,
      quantidadeOrigem: quantidadeOrigem,
      quantidadeDestino: quantidadeDestino,
      criterio: criterio,
      macrosOrigem: macrosOrigem,
      macrosDestino: macrosDestino,
    );
  }
}
