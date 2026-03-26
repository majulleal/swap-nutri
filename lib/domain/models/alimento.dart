import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:swap_nutri/domain/models/macros.dart';

part 'alimento.freezed.dart';
part 'alimento.g.dart';

@freezed
class Alimento with _$Alimento {
  const factory Alimento({
    required int id,
    required String nome,
    required String categoria,
    required Macros por100g,
  }) = _Alimento;

  factory Alimento.fromJson(Map<String, dynamic> json) =>
      _$AlimentoFromJson(json);
}
