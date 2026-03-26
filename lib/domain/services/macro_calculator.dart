import 'package:swap_nutri/domain/models/alimento.dart';
import 'package:swap_nutri/domain/models/macros.dart';
import 'package:swap_nutri/domain/models/refeicao.dart';

class MacroCalculator {
  const MacroCalculator();

  /// Calcula os macros de um alimento para uma quantidade especifica.
  Macros calcularPorQuantidade(Alimento alimento, double quantidadeGramas) {
    return alimento.por100g.scale(quantidadeGramas / 100);
  }

  /// Calcula o total de macros de uma lista de alimentos da refeicao.
  Macros calcularTotalRefeicao(List<AlimentoRefeicao> alimentos) {
    var total = Macros.zero();
    for (final alimento in alimentos) {
      total = total +
          Macros(
            calorias: alimento.calorias,
            proteinas: alimento.proteinas,
            carboidratos: alimento.carboidratos,
            gorduras: alimento.gorduras,
            fibras: alimento.fibras,
          );
    }
    return total;
  }

  /// Calcula o total de macros de todas as refeicoes de um dia.
  Macros calcularTotalDiario(List<Refeicao> refeicoes) {
    var total = Macros.zero();
    for (final refeicao in refeicoes) {
      total = total + refeicao.totais;
    }
    return total;
  }

  /// Calcula o saldo calorico (meta - consumido).
  double calcularSaldo(int metaCalorica, Macros totalDiario) {
    return metaCalorica - totalDiario.calorias;
  }
}
