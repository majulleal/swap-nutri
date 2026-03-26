import 'package:flutter/material.dart';

class MealRegisterScreen extends StatelessWidget {
  const MealRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Refeicao')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Registro de refeicao - em construcao'),
        ),
      ),
    );
  }
}
