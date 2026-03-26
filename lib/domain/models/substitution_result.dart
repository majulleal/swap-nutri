import 'package:swap_nutri/domain/models/alimento.dart';
import 'package:swap_nutri/domain/models/macros.dart';

class SubstitutionResult {
  const SubstitutionResult({
    required this.origem,
    required this.destino,
    required this.quantidadeOrigem,
    required this.quantidadeDestino,
    required this.criterio,
    required this.macrosOrigem,
    required this.macrosDestino,
  });

  final Alimento origem;
  final Alimento destino;
  final double quantidadeOrigem;
  final double quantidadeDestino;
  final CriterioEquivalencia criterio;
  final Macros macrosOrigem;
  final Macros macrosDestino;
}
