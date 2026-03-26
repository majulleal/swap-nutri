import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Perfil do usuario - em construcao'),
        ),
      ),
    );
  }
}
