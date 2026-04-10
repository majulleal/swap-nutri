import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swap_nutri/app.dart';
import 'package:swap_nutri/data/datasources/supabase_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppSupabaseClient.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
  );

  runApp(
    const ProviderScope(
      child: SwapNutriApp(),
    ),
  );
}
