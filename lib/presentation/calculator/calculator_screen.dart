import 'package:flutter/material.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora de Substituicao')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Calculadora - em construcao'),
        ),
      ),
    );
  }
}
