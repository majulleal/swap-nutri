import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swap_nutri/data/datasources/taco_datasource.dart';
import 'package:swap_nutri/domain/models/alimento.dart';

/// Provider singleton do datasource TACO.
final tacoDatasourceProvider = Provider<TacoDatasource>((ref) {
  return TacoDatasource();
});

/// Provider que carrega todos os alimentos da base TACO.
final alimentosProvider = FutureProvider<List<Alimento>>((ref) async {
  final datasource = ref.watch(tacoDatasourceProvider);
  return datasource.carregarAlimentos();
});

/// Provider que lista todas as categorias disponíveis.
final categoriasProvider = FutureProvider<List<String>>((ref) async {
  final datasource = ref.watch(tacoDatasourceProvider);
  return datasource.listarCategorias();
});

/// Provider que agrupa alimentos por categoria.
final alimentosPorCategoriaProvider =
    FutureProvider<Map<String, List<Alimento>>>((ref) async {
  final datasource = ref.watch(tacoDatasourceProvider);
  return datasource.agruparPorCategoria();
});

/// Provider da query de busca atual.
final buscaQueryProvider = StateProvider<String>((ref) => '');

/// Provider da categoria selecionada para filtro (null = todas).
final categoriaSelecionadaProvider = StateProvider<String?>((ref) => null);

/// Provider que retorna alimentos filtrados pela busca e categoria.
final alimentosFiltradosProvider = FutureProvider<List<Alimento>>((ref) async {
  final datasource = ref.watch(tacoDatasourceProvider);
  final query = ref.watch(buscaQueryProvider);
  final categoria = ref.watch(categoriaSelecionadaProvider);
  return datasource.buscar(query, categoria: categoria);
});
