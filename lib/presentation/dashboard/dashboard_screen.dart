import 'package:flutter/material.dart';
import 'package:swap_nutri/core/theme/app_colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SwapNutri'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumo calorico
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hoje',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    const LinearProgressIndicator(
                      value: 0,
                      minHeight: 12,
                      backgroundColor: Color(0xFFE0E0E0),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '0 / 2000 kcal',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Refeicoes',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            // Cards de refeicao
            ..._buildMealCards(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.swap_horiz),
        label: const Text('Calculadora'),
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
      ),
    );
  }

  List<Widget> _buildMealCards(BuildContext context) {
    final meals = [
      ('Cafe da Manha', Icons.free_breakfast),
      ('Almoco', Icons.lunch_dining),
      ('Lanche', Icons.bakery_dining),
      ('Jantar', Icons.dinner_dining),
    ];

    return meals
        .map(
          (meal) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Card(
              child: ListTile(
                leading: Icon(meal.$2, color: AppColors.primary),
                title: Text(meal.$1),
                subtitle: const Text('Nenhum alimento registrado'),
                trailing: const Icon(Icons.add_circle_outline),
                onTap: () {},
              ),
            ),
          ),
        )
        .toList();
  }
}
