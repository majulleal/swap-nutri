import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:swap_nutri/domain/models/alimento.dart';

class TacoDatasource {
  List<Alimento>? _cache;

  Future<List<Alimento>> carregarAlimentos() async {
    if (_cache != null) return _cache!;

    final jsonString = await rootBundle.loadString('assets/data/taco.json');
    final jsonList = json.decode(jsonString) as List<dynamic>;

    _cache = jsonList
        .map(
          (item) => Alimento.fromJson(item as Map<String, dynamic>),
        )
        .toList();

    return _cache!;
  }

  Future<List<Alimento>> buscar(String query, {String? categoria}) async {
    final alimentos = await carregarAlimentos();

    var resultado = alimentos.toList();

    if (categoria != null && categoria.isNotEmpty) {
      resultado = resultado.where((a) => a.categoria == categoria).toList();
    }

    if (query.isEmpty) return resultado;

    final queryNorm = _removerAcentos(query.toLowerCase());
    return resultado
        .where((a) => _removerAcentos(a.nome.toLowerCase()).contains(queryNorm))
        .toList();
  }

  Future<Alimento?> buscarPorId(int id) async {
    final alimentos = await carregarAlimentos();
    try {
      return alimentos.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<String>> listarCategorias() async {
    final alimentos = await carregarAlimentos();
    final categorias = alimentos.map((a) => a.categoria).toSet().toList()
      ..sort();
    return categorias;
  }

  Future<Map<String, List<Alimento>>> agruparPorCategoria() async {
    final alimentos = await carregarAlimentos();
    final mapa = <String, List<Alimento>>{};
    for (final a in alimentos) {
      mapa.putIfAbsent(a.categoria, () => []).add(a);
    }
    return Map.fromEntries(
      mapa.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  static String _removerAcentos(String texto) {
    const acentos =
        'àáâãäåèéêëìíîïòóôõöùúûüýÿñçÀÁÂÃÄÅÈÉÊËÌÍÎÏÒÓÔÕÖÙÚÛÜÝŸÑÇ';
    const semAcentos =
        'aaaaaaeeeeiiiioooooouuuuyynccAAAAAAEEEEIIIIOOOOOUUUUYYNC';

    return texto.split('').map((char) {
      final index = acentos.indexOf(char);
      return index != -1 ? semAcentos[index] : char;
    }).join();
  }
}
