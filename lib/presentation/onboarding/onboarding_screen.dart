import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swap_nutri/application/auth/auth_provider.dart';
import 'package:swap_nutri/application/profile/profile_provider.dart';
import 'package:swap_nutri/core/router/app_router.dart';
import 'package:swap_nutri/core/theme/app_colors.dart';
import 'package:swap_nutri/domain/models/usuario.dart';
import 'package:swap_nutri/domain/services/bmr_calculator.dart';
import 'package:swap_nutri/domain/services/validators.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  final _validators = const Validators();
  final _bmrCalculator = const BmrCalculator();

  // Form keys para cada etapa
  final _formKeys = List.generate(4, (_) => GlobalKey<FormState>());

  int _currentPage = 0;
  bool _isSaving = false;

  // Etapa 1 — Dados pessoais
  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  String? _sexo;

  // Etapa 2 — Medidas corporais
  final _pesoController = TextEditingController();
  final _alturaController = TextEditingController();

  // Etapa 3 — Nivel de atividade
  NivelAtividade? _nivelAtividade;

  // Etapa 4 — Objetivo e meta
  Objetivo? _objetivo;
  final _metaController = TextEditingController();
  int? _metaSugerida;

  @override
  void dispose() {
    _pageController.dispose();
    _nomeController.dispose();
    _idadeController.dispose();
    _pesoController.dispose();
    _alturaController.dispose();
    _metaController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (!_formKeys[_currentPage].currentState!.validate()) return;

    // Validacoes extras que o form nao cobre
    if (_currentPage == 0 && _sexo == null) {
      _showSnackbar('Selecione seu sexo biologico');
      return;
    }
    if (_currentPage == 2 && _nivelAtividade == null) {
      _showSnackbar('Selecione seu nivel de atividade');
      return;
    }

    // Ao entrar na etapa 4, calcula a meta sugerida
    if (_currentPage == 2) {
      _calcularMetaSugerida();
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _calcularMetaSugerida() {
    final peso = double.tryParse(_pesoController.text.replaceAll(',', '.'));
    final altura = double.tryParse(_alturaController.text.replaceAll(',', '.'));
    final idade = int.tryParse(_idadeController.text);

    if (peso == null || altura == null || idade == null || _sexo == null) {
      return;
    }

    final tdee = _bmrCalculator.calcularTdee(
      peso: peso,
      altura: altura,
      idade: idade,
      sexo: _sexo!,
      nivelAtividade: _nivelAtividade!,
    );

    setState(() {
      _metaSugerida = _bmrCalculator.sugerirMetaCalorica(
        tdee: tdee,
        objetivo: _objetivo ?? Objetivo.manter,
      );
      _metaController.text = _metaSugerida.toString();
    });
  }

  Future<void> _concluirOnboarding() async {
    if (!_formKeys[_currentPage].currentState!.validate()) return;
    if (_objetivo == null) {
      _showSnackbar('Selecione seu objetivo');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) throw Exception('Usuario nao autenticado');

      final peso = double.parse(_pesoController.text.replaceAll(',', '.'));
      final altura = double.parse(_alturaController.text.replaceAll(',', '.'));
      final idade = int.parse(_idadeController.text);
      final meta = int.parse(_metaController.text);

      final usuario = Usuario(
        id: user.id,
        nome: _nomeController.text.trim(),
        idade: idade,
        sexo: _sexo!,
        peso: peso,
        altura: altura,
        nivelAtividade: _nivelAtividade!,
        metaCalorica: meta,
        objetivo: _objetivo!,
        onboardingCompleto: true,
      );

      final repo = ref.read(profileRepositoryProvider);
      await repo.saveProfile(usuario);

      // Invalida o provider para recarregar o perfil
      ref.invalidate(profileProvider);

      if (mounted) {
        context.go(AppRoutes.dashboard);
      }
    } catch (e) {
      if (mounted) {
        _showSnackbar('Erro ao salvar perfil. Tente novamente.');
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Indicador de progresso
            _buildProgressIndicator(),
            // Conteudo da etapa
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: [
                  _buildStep1DadosPessoais(),
                  _buildStep2MedidasCorporais(),
                  _buildStep3NivelAtividade(),
                  _buildStep4ObjetivoMeta(),
                ],
              ),
            ),
            // Botoes de navegacao
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Etapa ${_currentPage + 1} de 4',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
              const Spacer(),
              Text(
                _stepTitle(_currentPage),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (_currentPage + 1) / 4,
              minHeight: 6,
              backgroundColor: AppColors.divider.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _stepTitle(int page) {
    switch (page) {
      case 0:
        return 'Dados Pessoais';
      case 1:
        return 'Medidas';
      case 2:
        return 'Atividade';
      case 3:
        return 'Objetivo';
      default:
        return '';
    }
  }

  // ── Etapa 1: Dados pessoais ──────────────────────────────────────────

  Widget _buildStep1DadosPessoais() {
    return Form(
      key: _formKeys[0],
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 8),
          const Icon(Icons.person_outline, size: 56, color: AppColors.primary),
          const SizedBox(height: 16),
          Text(
            'Vamos comecar!',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Conte um pouco sobre voce para personalizarmos sua experiencia.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _nomeController,
            decoration: const InputDecoration(
              labelText: 'Nome ou apelido',
              prefixIcon: Icon(Icons.badge_outlined),
            ),
            textCapitalization: TextCapitalization.words,
            validator: _validators.validarNome,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _idadeController,
            decoration: const InputDecoration(
              labelText: 'Idade',
              prefixIcon: Icon(Icons.cake_outlined),
              suffixText: 'anos',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: _validators.validarIdade,
          ),
          const SizedBox(height: 24),
          Text('Sexo biologico', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(
            'Usado para calcular sua taxa metabolica basal',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SexoCard(
                  label: 'Masculino',
                  icon: Icons.male,
                  selected: _sexo == 'M',
                  onTap: () => setState(() => _sexo = 'M'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SexoCard(
                  label: 'Feminino',
                  icon: Icons.female,
                  selected: _sexo == 'F',
                  onTap: () => setState(() => _sexo = 'F'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Etapa 2: Medidas corporais ───────────────────────────────────────

  Widget _buildStep2MedidasCorporais() {
    return Form(
      key: _formKeys[1],
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 8),
          const Icon(Icons.straighten, size: 56, color: AppColors.primary),
          const SizedBox(height: 16),
          Text(
            'Suas medidas',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Essas informacoes sao essenciais para calcular '
            'sua necessidade calorica diaria.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _pesoController,
            decoration: const InputDecoration(
              labelText: 'Peso',
              prefixIcon: Icon(Icons.monitor_weight_outlined),
              suffixText: 'kg',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d,.]')),
            ],
            validator: _validators.validarPeso,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _alturaController,
            decoration: const InputDecoration(
              labelText: 'Altura',
              prefixIcon: Icon(Icons.height),
              suffixText: 'cm',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d,.]')),
            ],
            validator: _validators.validarAltura,
          ),
          const SizedBox(height: 24),
          Card(
            color: AppColors.primary.withValues(alpha: 0.08),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Voce podera atualizar essas informacoes '
                      'a qualquer momento no seu perfil.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Etapa 3: Nivel de atividade ──────────────────────────────────────

  Widget _buildStep3NivelAtividade() {
    return Form(
      key: _formKeys[2],
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 8),
          const Icon(
            Icons.fitness_center,
            size: 56,
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Nivel de atividade',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Com que frequencia voce pratica exercicios fisicos?',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _AtividadeCard(
            nivel: NivelAtividade.sedentario,
            titulo: 'Sedentario',
            descricao: 'Pouco ou nenhum exercicio. Trabalho de escritorio.',
            icon: Icons.weekend_outlined,
            selected: _nivelAtividade == NivelAtividade.sedentario,
            onTap: () =>
                setState(() => _nivelAtividade = NivelAtividade.sedentario),
          ),
          const SizedBox(height: 12),
          _AtividadeCard(
            nivel: NivelAtividade.leve,
            titulo: 'Levemente ativo',
            descricao: 'Exercicio leve 1 a 2 vezes por semana.',
            icon: Icons.directions_walk,
            selected: _nivelAtividade == NivelAtividade.leve,
            onTap: () => setState(() => _nivelAtividade = NivelAtividade.leve),
          ),
          const SizedBox(height: 12),
          _AtividadeCard(
            nivel: NivelAtividade.moderado,
            titulo: 'Moderadamente ativo',
            descricao: 'Exercicio moderado 3 a 4 vezes por semana.',
            icon: Icons.directions_run,
            selected: _nivelAtividade == NivelAtividade.moderado,
            onTap: () =>
                setState(() => _nivelAtividade = NivelAtividade.moderado),
          ),
          const SizedBox(height: 12),
          _AtividadeCard(
            nivel: NivelAtividade.intenso,
            titulo: 'Muito ativo',
            descricao: 'Exercicio intenso 5 a 7 vezes por semana.',
            icon: Icons.sports_gymnastics,
            selected: _nivelAtividade == NivelAtividade.intenso,
            onTap: () =>
                setState(() => _nivelAtividade = NivelAtividade.intenso),
          ),
        ],
      ),
    );
  }

  // ── Etapa 4: Objetivo e meta calorica ────────────────────────────────

  Widget _buildStep4ObjetivoMeta() {
    return Form(
      key: _formKeys[3],
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 8),
          const Icon(
            Icons.flag_outlined,
            size: 56,
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Seu objetivo',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Qual e o seu objetivo nutricional?',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _ObjetivoCard(
                  objetivo: Objetivo.perder,
                  titulo: 'Perder\npeso',
                  icon: Icons.trending_down,
                  selected: _objetivo == Objetivo.perder,
                  onTap: () {
                    setState(() => _objetivo = Objetivo.perder);
                    _calcularMetaSugerida();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ObjetivoCard(
                  objetivo: Objetivo.manter,
                  titulo: 'Manter\npeso',
                  icon: Icons.balance,
                  selected: _objetivo == Objetivo.manter,
                  onTap: () {
                    setState(() => _objetivo = Objetivo.manter);
                    _calcularMetaSugerida();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ObjetivoCard(
                  objetivo: Objetivo.ganhar,
                  titulo: 'Ganhar\nmassa',
                  icon: Icons.trending_up,
                  selected: _objetivo == Objetivo.ganhar,
                  onTap: () {
                    setState(() => _objetivo = Objetivo.ganhar);
                    _calcularMetaSugerida();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_metaSugerida != null) ...[
            Card(
              color: AppColors.primary.withValues(alpha: 0.08),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Meta calorica sugerida',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$_metaSugerida kcal/dia',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Calculada com base nos seus dados '
                      'via formula de Mifflin-St Jeor',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _metaController,
              decoration: const InputDecoration(
                labelText: 'Meta calorica diaria',
                prefixIcon: Icon(Icons.local_fire_department_outlined),
                suffixText: 'kcal',
                helperText:
                    'Voce pode aceitar a sugestao ou definir sua propria meta',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: _validators.validarMetaCalorica,
            ),
          ],
        ],
      ),
    );
  }

  // ── Botoes de navegacao ──────────────────────────────────────────────

  Widget _buildNavigationButtons() {
    final isLastPage = _currentPage == 3;
    final isFirstPage = _currentPage == 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Row(
        children: [
          if (!isFirstPage)
            TextButton.icon(
              onPressed: _previousPage,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Voltar'),
            ),
          const Spacer(),
          if (isLastPage)
            ElevatedButton(
              onPressed: _isSaving ? null : _concluirOnboarding,
              style: ElevatedButton.styleFrom(minimumSize: const Size(160, 48)),
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Concluir'),
            )
          else
            ElevatedButton.icon(
              onPressed: _nextPage,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Proximo'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(140, 48)),
            ),
        ],
      ),
    );
  }
}

// ── Widgets auxiliares ────────────────────────────────────────────────────

class _SexoCard extends StatelessWidget {
  const _SexoCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                color: selected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AtividadeCard extends StatelessWidget {
  const _AtividadeCard({
    required this.nivel,
    required this.titulo,
    required this.descricao,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final NivelAtividade nivel;
  final String titulo;
  final String descricao;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      color: selected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    descricao,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

class _ObjetivoCard extends StatelessWidget {
  const _ObjetivoCard({
    required this.objetivo,
    required this.titulo,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final Objetivo objetivo;
  final String titulo;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                color: selected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
