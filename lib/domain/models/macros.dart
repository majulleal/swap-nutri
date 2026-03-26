import 'package:freezed_annotation/freezed_annotation.dart';

part 'macros.freezed.dart';
part 'macros.g.dart';

@freezed
class Macros with _$Macros {
  const factory Macros({
    required double calorias,
    required double proteinas,
    required double carboidratos,
    required double gorduras,
    required double fibras,
  }) = _Macros;

  const Macros._();

  factory Macros.fromJson(Map<String, dynamic> json) => _$MacrosFromJson(json);

  factory Macros.zero() => const Macros(
        calorias: 0,
        proteinas: 0,
        carboidratos: 0,
        gorduras: 0,
        fibras: 0,
      );

  /// Escala os macros por um fator (ex: quantidade / 100).
  Macros scale(double fator) => Macros(
        calorias: calorias * fator,
        proteinas: proteinas * fator,
        carboidratos: carboidratos * fator,
        gorduras: gorduras * fator,
        fibras: fibras * fator,
      );

  /// Soma dois conjuntos de macros.
  Macros operator +(Macros other) => Macros(
        calorias: calorias + other.calorias,
        proteinas: proteinas + other.proteinas,
        carboidratos: carboidratos + other.carboidratos,
        gorduras: gorduras + other.gorduras,
        fibras: fibras + other.fibras,
      );

  /// Retorna o valor de um macro pelo criterio.
  double getByCriterio(CriterioEquivalencia criterio) {
    switch (criterio) {
      case CriterioEquivalencia.calorias:
        return calorias;
      case CriterioEquivalencia.proteinas:
        return proteinas;
      case CriterioEquivalencia.carboidratos:
        return carboidratos;
      case CriterioEquivalencia.gorduras:
        return gorduras;
    }
  }
}

enum CriterioEquivalencia {
  calorias,
  proteinas,
  carboidratos,
  gorduras,
}
