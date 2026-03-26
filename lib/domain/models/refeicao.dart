import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:swap_nutri/domain/models/macros.dart';

part 'refeicao.freezed.dart';
part 'refeicao.g.dart';

enum TipoRefeicao {
  cafe,
  almoco,
  lanche,
  jantar;

  String get label {
    switch (this) {
      case TipoRefeicao.cafe:
        return 'Cafe da Manha';
      case TipoRefeicao.almoco:
        return 'Almoco';
      case TipoRefeicao.lanche:
        return 'Lanche';
      case TipoRefeicao.jantar:
        return 'Jantar';
    }
  }
}

@freezed
class AlimentoRefeicao with _$AlimentoRefeicao {
  const factory AlimentoRefeicao({
    required int tacoId,
    required String nome,
    required double quantidade,
    required double calorias,
    required double proteinas,
    required double carboidratos,
    required double gorduras,
    required double fibras,
  }) = _AlimentoRefeicao;

  factory AlimentoRefeicao.fromJson(Map<String, dynamic> json) =>
      _$AlimentoRefeicaoFromJson(json);
}

@freezed
class Refeicao with _$Refeicao {
  const factory Refeicao({
    required String id,
    required String userId,
    required String data,
    required TipoRefeicao tipo,
    required List<AlimentoRefeicao> alimentos,
    required Macros totais,
  }) = _Refeicao;

  factory Refeicao.fromJson(Map<String, dynamic> json) =>
      _$RefeicaoFromJson(json);
}
