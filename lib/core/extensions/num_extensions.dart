extension NumFormatting on double {
  /// Formata para 1 casa decimal (ex: 123.4).
  String toFixed1() => toStringAsFixed(1);

  /// Formata para inteiro (ex: 123).
  String toKcal() => '${round()} kcal';

  /// Formata gramas (ex: 45.2g).
  String toGramas() => '${toStringAsFixed(1)}g';
}
