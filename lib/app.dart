import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swap_nutri/core/router/app_router.dart';
import 'package:swap_nutri/core/theme/app_theme.dart';

class SwapNutriApp extends ConsumerWidget {
  const SwapNutriApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = createRouter();

    return MaterialApp.router(
      title: 'SwapNutri',
      theme: AppTheme.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
