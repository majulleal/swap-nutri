import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swap_nutri/application/auth/auth_provider.dart';
import 'package:swap_nutri/application/profile/profile_provider.dart';
import 'package:swap_nutri/core/router/app_router.dart';
import 'package:swap_nutri/core/theme/app_theme.dart';

class SwapNutriApp extends ConsumerStatefulWidget {
  const SwapNutriApp({super.key});

  @override
  ConsumerState<SwapNutriApp> createState() => _SwapNutriAppState();
}

class _SwapNutriAppState extends ConsumerState<SwapNutriApp> {
  late final AuthNotifier _authNotifier;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authNotifier = AuthNotifier();
    _router = createRouter(ref, _authNotifier);
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Escuta o authStateProvider; quando ele muda, notifica o GoRouter.
    // Isso garante que o redirect so roda depois que o provider atualizou.
    // Quando auth ou perfil mudam, notifica o GoRouter
    // para reavaliar os redirects.
    ref.listen(authStateProvider, (_, __) {
      _authNotifier.notify();
    });
    ref.listen(profileProvider, (_, __) {
      _authNotifier.notify();
    });

    return MaterialApp.router(
      title: 'SwapNutri',
      theme: AppTheme.light,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
