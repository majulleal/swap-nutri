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

  Future<List<Alimento>> buscar(String query) async {
    final alimentos = await carregarAlimentos();
    if (query.isEmpty) return alimentos;

    final queryLower = query.toLowerCase();
    return alimentos
        .where((a) => a.nome.toLowerCase().contains(queryLower))
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
}
