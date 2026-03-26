# SwapNutri — Documento de Arquitetura e Stack Tecnológica

> Versão 2.0 — 25/03/2026
> Contexto: produto solo, objetivo de lançamento no mercado (Play Store + App Store)

---

## 1. Decisões Arquiteturais (ADRs)

### ADR-001: Flutter ao invés de React Native ou nativo

**Contexto:** App de nutrição usado durante refeições — precisa ser rápido, bonito e funcionar em ambas as plataformas. Desenvolvedor solo precisa maximizar produtividade sem sacrificar qualidade.

**Decisão:** Flutter (stable channel) com Dart.

**Justificativa:**
- (+) Compila para código nativo ARM — performance superior ao React Native (sem bridge JS)
- (+) Renderiza cada pixel via Skia/Impeller — UI idêntica em iOS e Android, controle total visual
- (+) Widget system coeso — navegação, animações, estado, tudo do mesmo ecossistema
- (+) Hot reload confiável — iteração rápida em UI (crítico para dev solo)
- (+) Ecossistema maduro para apps de saúde/fitness (Nubank, Google Fit, Fastic usam Flutter)
- (+) Um codebase, dois stores — maximiza produtividade de dev solo
- (-) Dart é menos usado que JS/TS no mercado geral (irrelevante: o objetivo é o produto, não empregabilidade)

**Alternativas descartadas:**
- React Native: bridge JS adiciona latência, ecossistema fragmentado (15+ libs de terceiros para cobrir o que Flutter tem built-in)
- Kotlin/Swift nativo: dois codebases para manter sozinho é inviável
- Web responsiva: experiência inferior no celular, sem acesso a features nativas

---

### ADR-002: Supabase ao invés de Firebase

**Contexto:** O app precisa de auth, banco de dados e storage. Para um produto que vai escalar, preciso de previsibilidade de custo, queries flexíveis e possibilidade de migração futura.

**Decisão:** Supabase (PostgreSQL + Auth + Row Level Security + Edge Functions).

**Justificativa:**
- (+) PostgreSQL real — queries SQL completas, joins, aggregations, full-text search
- (+) Row Level Security (RLS) — segurança no nível do banco, não apenas no client
- (+) Pricing previsível — não cobra por leitura/escrita individual como Firestore
- (+) Self-hostável — se o custo ficar alto ou Supabase sumir, migra para PostgreSQL próprio
- (+) Real-time subscriptions nativo
- (+) Auth completo (e-mail/senha, OAuth, magic link)
- (+) SDK Dart oficial e bem mantido (`supabase_flutter`)
- (-) Requer conhecimento de SQL (positivo a longo prazo)

**Projeção de custo:**

| Fase | Usuários | Plano Supabase | Custo/mês |
|---|---|---|---|
| MVP / Beta | 0-500 | Free | $0 |
| Crescimento | 500-10k | Pro | $25 |
| Escala | 10k-100k | Pro (otimizado) | $25-75 |

Firebase com Firestore em 10k usuários (4 refeições/dia × 5 alimentos × leituras) facilmente ultrapassa $100/mês.

---

### ADR-003: Base nutricional como asset local + tabela remota para expansão

**Contexto:** A calculadora precisa de dados nutricionais. Precisa funcionar offline mas também ser expansível.

**Decisão:** Estratégia híbrida em duas fases.

**Fase 1 (MVP):** Tabela TACO empacotada como asset JSON local no app.
- Zero latência, funciona offline
- ~600 alimentos cobrem o MVP

**Fase 2 (pós-lançamento):** Migrar a base para tabela `alimentos` no Supabase.
- Permite adicionar alimentos sem novo build
- Permite contribuição da comunidade (usuários sugerem alimentos)
- App faz cache local via SQLite (drift) para manter offline

---

### ADR-004: Riverpod para gerenciamento de estado

**Contexto:** Preciso de estado global para: auth, refeições do dia, resultados de cálculos, perfil do usuário.

**Decisão:** Riverpod 2 (com code generation).

**Justificativa:**
- (+) Padrão de mercado Flutter em 2026 — ultrapassou Provider, BLoC e GetX
- (+) Compile-safe — erros de dependência são pegos em build time, não em runtime
- (+) Autodispose — providers que não estão sendo observados liberam memória automaticamente
- (+) Testável — cada provider pode ser overridado em testes
- (+) Code generation (`@riverpod`) reduz boilerplate significativamente
- (-) Curva de aprendizado maior que Provider (vale o investimento para produto real)

**Alternativas descartadas:**
- Provider: legado, o próprio criador (Remi Rousselet) recomenda migrar para Riverpod
- BLoC: muito boilerplate para dev solo (events, states, blocs para cada feature)
- GetX: não type-safe, práticas controversas, difícil de testar

---

### ADR-005: GoRouter para navegação

**Decisão:** GoRouter (pacote oficial do Flutter team).

**Justificativa:**
- (+) Declarativo — rotas definidas em um lugar, navegação por path
- (+) Deep linking nativo — essencial para notificações e compartilhamento
- (+) Guards de autenticação — redirect automático para login se não autenticado
- (+) Shell routes — layout persistente com bottom navigation
- (+) Mantido pelo Flutter team

---

### ADR-006: Clean Architecture simplificada

**Contexto:** Dev solo não precisa de Clean Architecture pura (com UseCases, Entities duplicadas, Mappers). Mas precisa de separação suficiente para manter o código testável e organizado à medida que cresce.

**Decisão:** Arquitetura em 4 camadas pragmática.

```
┌─────────────────────────┐
│   Presentation (UI)     │  Widgets, Screens, componentes visuais
├─────────────────────────┤
│   Application (State)   │  Riverpod providers, lógica de orquestração
├─────────────────────────┤
│   Domain (Core)         │  Models, cálculos puros, regras de negócio
├─────────────────────────┤
│   Data (Infra)          │  Supabase client, repositories, cache local
└─────────────────────────┘
```

**Regra:** cada camada só depende da imediatamente abaixo. Domain não importa Flutter, Supabase, ou Riverpod.

---

## 2. Stack Tecnológica Completa

### 2.1 Core

| Tecnologia | Versão | Função |
|---|---|---|
| **Flutter** | 3.27+ (stable) | Framework mobile cross-platform |
| **Dart** | 3.6+ | Linguagem (null-safe, AOT compilation) |
| **GoRouter** | 14+ | Navegação declarativa + deep linking |
| **Riverpod** | 2.6+ | Gerenciamento de estado (com codegen) |

### 2.2 Backend / Serviços

| Tecnologia | Função |
|---|---|
| **Supabase Auth** | Autenticação (e-mail/senha, Google, Apple) |
| **Supabase Database** | PostgreSQL (perfil, refeições, histórico) |
| **Supabase RLS** | Segurança row-level (cada user acessa só seus dados) |
| **Supabase Edge Functions** | Lógica server-side quando necessário (ex: envio de e-mail) |

### 2.3 Dados Locais

| Tecnologia | Função |
|---|---|
| **Tabela TACO (JSON asset)** | Base nutricional (~600 alimentos) — MVP |
| **shared_preferences** | Preferências simples (tema, onboarding visto) |
| **Drift (SQLite)** | Cache local offline (fase 2 — cache de alimentos do Supabase) |

### 2.4 UI / Design

| Tecnologia | Função |
|---|---|
| **Material 3** | Design system base (com tema customizado SwapNutri) |
| **fl_chart** | Gráficos de macros e evolução calórica |
| **flutter_animate** | Animações declarativas de UI |
| **cached_network_image** | Cache de imagens (avatares, alimentos futuros) |
| **Google Fonts** | Tipografia customizada |

### 2.5 Qualidade e DX

| Tecnologia | Função |
|---|---|
| **flutter_test** | Testes unitários e de widget (built-in) |
| **integration_test** | Testes E2E (built-in) |
| **mocktail** | Mocks para testes |
| **very_good_analysis** | Lint rules rigorosas (padrão VGV) |
| **build_runner** | Code generation (Riverpod, Freezed) |
| **freezed** | Data classes imutáveis com copyWith, == e toString |

### 2.6 CI/CD e Distribuição

| Tecnologia | Função |
|---|---|
| **GitHub Actions** | CI (lint, test, build em cada PR) |
| **Codemagic** ou **Fastlane** | CD (build + deploy para stores) |
| **Firebase Crashlytics** | Crash reporting em produção |
| **Firebase Analytics** | Telemetria de uso (apenas analytics, não banco) |
| **Sentry** (alternativa) | Error tracking + performance monitoring |

---

## 3. Arquitetura da Aplicação

### 3.1 Visão em Camadas

```
┌──────────────────────────────────────────────────────────────┐
│                      PRESENTATION                             │
│                                                              │
│  Screens/         Widgets/          Theme/                   │
│  ├── auth/        ├── alimento_search.dart  app_theme.dart   │
│  ├── onboarding/  ├── macro_card.dart       colors.dart      │
│  ├── dashboard/   ├── progress_bar.dart     typography.dart  │
│  ├── calculator/  ├── refeicao_card.dart                     │
│  ├── meal/        └── macro_comparativo.dart                 │
│  └── profile/                                                │
├──────────────────────────────────────────────────────────────┤
│                      APPLICATION                              │
│                                                              │
│  Providers/                                                  │
│  ├── auth_provider.dart          (estado de autenticação)    │
│  ├── user_provider.dart          (perfil do usuário)         │
│  ├── meal_provider.dart          (refeições do dia)          │
│  ├── calculator_provider.dart    (estado da calculadora)     │
│  └── daily_summary_provider.dart (resumo calórico diário)   │
├──────────────────────────────────────────────────────────────┤
│                        DOMAIN                                 │
│                                                              │
│  Models/                   Services/                         │
│  ├── alimento.dart         ├── substitution_calculator.dart  │
│  ├── refeicao.dart         ├── bmr_calculator.dart           │
│  ├── usuario.dart          ├── macro_calculator.dart         │
│  ├── macros.dart           └── validators.dart               │
│  └── substitution_result.dart                                │
├──────────────────────────────────────────────────────────────┤
│                         DATA                                  │
│                                                              │
│  Repositories/             Datasources/                      │
│  ├── auth_repository.dart  ├── supabase_client.dart          │
│  ├── user_repository.dart  ├── taco_datasource.dart          │
│  └── meal_repository.dart  └── local_cache.dart              │
└──────────────────────────────────────────────────────────────┘
```

### 3.2 Estrutura de Diretórios

```
swap_nutri/
├── lib/
│   ├── main.dart                          # Entry point
│   ├── app.dart                           # MaterialApp + GoRouter + Providers
│   │
│   ├── core/                              # Compartilhado entre features
│   │   ├── theme/
│   │   │   ├── app_theme.dart             # ThemeData customizado
│   │   │   ├── app_colors.dart            # Paleta de cores SwapNutri
│   │   │   └── app_typography.dart        # Text styles
│   │   ├── constants/
│   │   │   └── app_constants.dart         # Limites, valores padrão
│   │   ├── router/
│   │   │   └── app_router.dart            # GoRouter config + guards
│   │   ├── extensions/
│   │   │   └── num_extensions.dart        # Formatação de macros/calorias
│   │   └── widgets/                       # Widgets genéricos reutilizáveis
│   │       ├── app_button.dart
│   │       ├── app_text_field.dart
│   │       ├── app_card.dart
│   │       └── loading_overlay.dart
│   │
│   ├── data/                              # Camada de dados (infra)
│   │   ├── datasources/
│   │   │   ├── supabase_client.dart       # Inicialização Supabase
│   │   │   └── taco_datasource.dart       # Leitura do JSON TACO
│   │   └── repositories/
│   │       ├── auth_repository.dart       # Supabase Auth wrapper
│   │       ├── user_repository.dart       # CRUD perfil (Supabase)
│   │       └── meal_repository.dart       # CRUD refeições (Supabase)
│   │
│   ├── domain/                            # Lógica pura (sem Flutter, sem Supabase)
│   │   ├── models/
│   │   │   ├── alimento.dart              # Modelo + Freezed
│   │   │   ├── refeicao.dart
│   │   │   ├── usuario.dart
│   │   │   ├── macros.dart
│   │   │   └── substitution_result.dart
│   │   └── services/
│   │       ├── substitution_calculator.dart  # Core: cálculo de substituição
│   │       ├── bmr_calculator.dart           # TMB (Mifflin-St Jeor)
│   │       ├── macro_calculator.dart         # Totais de refeição/dia
│   │       └── validators.dart               # Validações de input
│   │
│   ├── application/                       # Estado (Riverpod providers)
│   │   ├── auth/
│   │   │   └── auth_provider.dart
│   │   ├── user/
│   │   │   └── user_provider.dart
│   │   ├── meal/
│   │   │   └── meal_provider.dart
│   │   ├── calculator/
│   │   │   └── calculator_provider.dart
│   │   └── dashboard/
│   │       └── daily_summary_provider.dart
│   │
│   └── presentation/                      # UI
│       ├── auth/
│       │   ├── login_screen.dart
│       │   └── signup_screen.dart
│       ├── onboarding/
│       │   ├── onboarding_screen.dart     # PageView com steps
│       │   └── widgets/
│       │       ├── personal_data_step.dart
│       │       ├── measurements_step.dart
│       │       ├── activity_step.dart
│       │       └── goal_step.dart
│       ├── dashboard/
│       │   ├── dashboard_screen.dart
│       │   └── widgets/
│       │       ├── calorie_progress.dart
│       │       ├── macro_breakdown.dart
│       │       └── meal_summary_card.dart
│       ├── calculator/
│       │   ├── calculator_screen.dart
│       │   └── widgets/
│       │       ├── food_search_field.dart
│       │       └── comparison_table.dart
│       ├── meal/
│       │   ├── meal_register_screen.dart
│       │   └── widgets/
│       │       └── food_item_row.dart
│       └── profile/
│           └── profile_screen.dart
│
├── assets/
│   ├── data/
│   │   └── taco.json                      # Tabela TACO
│   ├── images/
│   │   ├── logo.svg
│   │   └── onboarding/
│   └── fonts/                             # Se não usar Google Fonts package
│
├── test/
│   ├── domain/
│   │   └── services/
│   │       ├── substitution_calculator_test.dart
│   │       ├── bmr_calculator_test.dart
│   │       └── macro_calculator_test.dart
│   ├── data/
│   │   └── repositories/
│   └── application/
│       └── providers/
│
├── integration_test/
│   └── app_test.dart
│
├── pubspec.yaml                           # Dependências
├── analysis_options.yaml                  # Lint rules (very_good_analysis)
├── .gitignore
├── .env.example                           # Template de variáveis de ambiente
└── README.md
```

---

## 4. Modelos de Dados

### 4.1 Supabase (PostgreSQL) — Schema

```sql
-- ============================================================
-- USUARIOS
-- ============================================================
create table public.profiles (
  id uuid references auth.users on delete cascade primary key,
  nome text not null,
  idade int not null check (idade between 10 and 120),
  sexo text not null check (sexo in ('M', 'F')),
  peso decimal(5,2) not null check (peso between 30 and 300),    -- kg
  altura decimal(5,2) not null check (altura between 100 and 250), -- cm
  nivel_atividade text not null check (
    nivel_atividade in ('sedentario', 'leve', 'moderado', 'intenso')
  ),
  meta_calorica int not null check (meta_calorica between 800 and 6000),
  objetivo text not null check (objetivo in ('perder', 'manter', 'ganhar')),
  onboarding_completo boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- RLS: cada usuário acessa somente seu perfil
alter table public.profiles enable row level security;

create policy "Users can view own profile"
  on public.profiles for select using (auth.uid() = id);

create policy "Users can update own profile"
  on public.profiles for update using (auth.uid() = id);

create policy "Users can insert own profile"
  on public.profiles for insert with check (auth.uid() = id);

-- ============================================================
-- REFEICOES
-- ============================================================
create table public.refeicoes (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  data date not null,
  tipo text not null check (tipo in ('cafe', 'almoco', 'lanche', 'jantar')),
  created_at timestamptz default now(),
  updated_at timestamptz default now(),

  -- Uma refeição por tipo por dia por usuário
  unique (user_id, data, tipo)
);

alter table public.refeicoes enable row level security;

create policy "Users can CRUD own meals"
  on public.refeicoes for all using (auth.uid() = user_id);

-- ============================================================
-- ALIMENTOS DA REFEICAO
-- ============================================================
create table public.refeicao_alimentos (
  id uuid default gen_random_uuid() primary key,
  refeicao_id uuid references public.refeicoes(id) on delete cascade not null,
  taco_id int not null,
  nome text not null,
  quantidade decimal(7,2) not null check (quantidade > 0),  -- gramas
  calorias decimal(8,2) not null,
  proteinas decimal(7,2) not null,
  carboidratos decimal(7,2) not null,
  gorduras decimal(7,2) not null,
  fibras decimal(7,2) not null,
  created_at timestamptz default now()
);

alter table public.refeicao_alimentos enable row level security;

create policy "Users can CRUD own meal foods"
  on public.refeicao_alimentos for all
  using (
    exists (
      select 1 from public.refeicoes
      where refeicoes.id = refeicao_alimentos.refeicao_id
      and refeicoes.user_id = auth.uid()
    )
  );

-- ============================================================
-- VIEWS ÚTEIS
-- ============================================================

-- Totais por refeição
create view public.refeicao_totais as
select
  r.id as refeicao_id,
  r.user_id,
  r.data,
  r.tipo,
  coalesce(sum(ra.calorias), 0) as total_calorias,
  coalesce(sum(ra.proteinas), 0) as total_proteinas,
  coalesce(sum(ra.carboidratos), 0) as total_carboidratos,
  coalesce(sum(ra.gorduras), 0) as total_gorduras,
  coalesce(sum(ra.fibras), 0) as total_fibras
from public.refeicoes r
left join public.refeicao_alimentos ra on ra.refeicao_id = r.id
group by r.id, r.user_id, r.data, r.tipo;

-- Totais diários
create view public.resumo_diario as
select
  user_id,
  data,
  sum(total_calorias) as calorias,
  sum(total_proteinas) as proteinas,
  sum(total_carboidratos) as carboidratos,
  sum(total_gorduras) as gorduras,
  sum(total_fibras) as fibras
from public.refeicao_totais
group by user_id, data;

-- ============================================================
-- INDEXES
-- ============================================================
create index idx_refeicoes_user_data on public.refeicoes(user_id, data);
create index idx_refeicao_alimentos_refeicao on public.refeicao_alimentos(refeicao_id);

-- ============================================================
-- TRIGGERS (updated_at automático)
-- ============================================================
create or replace function update_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger profiles_updated_at
  before update on public.profiles
  for each row execute function update_updated_at();

create trigger refeicoes_updated_at
  before update on public.refeicoes
  for each row execute function update_updated_at();
```

### 4.2 Tabela TACO — Estrutura do JSON local

```dart
// domain/models/alimento.dart

@freezed
class Alimento with _$Alimento {
  const factory Alimento({
    required int id,
    required String nome,
    required String categoria,     // "Cereais", "Carnes", "Frutas"
    required Macros por100g,
  }) = _Alimento;

  factory Alimento.fromJson(Map<String, dynamic> json) =>
      _$AlimentoFromJson(json);
}

@freezed
class Macros with _$Macros {
  const factory Macros({
    required double calorias,      // kcal
    required double proteinas,     // g
    required double carboidratos,  // g
    required double gorduras,      // g
    required double fibras,        // g
  }) = _Macros;

  factory Macros.fromJson(Map<String, dynamic> json) =>
      _$MacrosFromJson(json);
}
```

### 4.3 Demais Models

```dart
// domain/models/usuario.dart

enum NivelAtividade { sedentario, leve, moderado, intenso }
enum Objetivo { perder, manter, ganhar }

@freezed
class Usuario with _$Usuario {
  const factory Usuario({
    required String id,
    required String nome,
    required int idade,
    required String sexo,
    required double peso,
    required double altura,
    required NivelAtividade nivelAtividade,
    required int metaCalorica,
    required Objetivo objetivo,
    required bool onboardingCompleto,
  }) = _Usuario;

  factory Usuario.fromJson(Map<String, dynamic> json) =>
      _$UsuarioFromJson(json);
}

// domain/models/refeicao.dart

enum TipoRefeicao { cafe, almoco, lanche, jantar }

@freezed
class AlimentoRefeicao with _$AlimentoRefeicao {
  const factory AlimentoRefeicao({
    required int tacoId,
    required String nome,
    required double quantidade,     // gramas
    required double calorias,
    required double proteinas,
    required double carboidratos,
    required double gorduras,
    required double fibras,
  }) = _AlimentoRefeicao;
}

@freezed
class Refeicao with _$Refeicao {
  const factory Refeicao({
    required String id,
    required String userId,
    required String data,           // "YYYY-MM-DD"
    required TipoRefeicao tipo,
    required List<AlimentoRefeicao> alimentos,
    required Macros totais,
  }) = _Refeicao;
}

// domain/models/substitution_result.dart

enum CriterioEquivalencia { calorias, proteinas, carboidratos, gorduras }

@freezed
class SubstitutionResult with _$SubstitutionResult {
  const factory SubstitutionResult({
    required Alimento origem,
    required Alimento destino,
    required double quantidadeOrigem,
    required double quantidadeDestino,
    required CriterioEquivalencia criterio,
    required Macros macrosOrigem,
    required Macros macrosDestino,
  }) = _SubstitutionResult;
}
```

---

## 5. Fluxos de Dados

### 5.1 Calculadora de Substituição

```
UI: calculator_screen.dart
    │
    │  Usuário seleciona alimento A, quantidade, alimento B, critério
    │
    ▼
Provider: calculator_provider.dart
    │
    │  Chama SubstitutionCalculator.calculate()
    │
    ▼
Service: substitution_calculator.dart (lógica pura)
    │
    │  macrosA = alimento.por100g.scale(quantidadeA / 100)
    │  quantidadeB = (macrosA[criterio] / alimento.por100g[criterio]) * 100
    │  macrosB = alimento.por100g.scale(quantidadeB / 100)
    │
    │  return SubstitutionResult(...)
    │
    ▼
UI: exibe resultado + tabela comparativa
    (nenhuma chamada de rede — tudo local)
```

### 5.2 Registro de Refeição

```
UI: meal_register_screen.dart
    │
    │  Usuário busca alimentos, informa quantidades
    │
    ▼
Provider: meal_provider.dart
    │
    │  1. Calcula macros (MacroCalculator — local)
    │  2. Salva no Supabase (MealRepository)
    │
    ▼
Repository: meal_repository.dart
    │
    │  INSERT INTO refeicoes (...) + INSERT INTO refeicao_alimentos (...)
    │
    ▼
Provider: daily_summary_provider.dart
    │
    │  Invalida cache → refaz query do resumo diário
    │
    ▼
UI: dashboard atualiza automaticamente (Riverpod rebuild)
```

### 5.3 Autenticação e Navegação

```
app.dart → GoRouter
    │
    │  redirect: (context, state) {
    │    final auth = ref.read(authProvider);
    │    final user = ref.read(userProvider);
    │
    │    if (!auth.isLoggedIn) → /login
    │    if (!user.onboardingCompleto) → /onboarding
    │    else → /dashboard
    │  }
    │
    ▼
Supabase.auth.onAuthStateChange
    │
    │  Atualiza authProvider → GoRouter recalcula redirect
```

---

## 6. Fórmulas e Algoritmos

### 6.1 TMB — Mifflin-St Jeor

```
Homens:   TMB = (10 × peso_kg) + (6.25 × altura_cm) - (5 × idade) + 5
Mulheres: TMB = (10 × peso_kg) + (6.25 × altura_cm) - (5 × idade) - 161
```

| Nível de Atividade | Fator Multiplicador |
|---|---|
| Sedentário | 1.2 |
| Leve (1-2x/semana) | 1.375 |
| Moderado (3-4x/semana) | 1.55 |
| Intenso (5-7x/semana) | 1.725 |

**TDEE** (Total Daily Energy Expenditure) = TMB × Fator

**Meta sugerida:**
- Perder peso: TDEE - 500 kcal (déficit seguro)
- Manter peso: TDEE
- Ganhar massa: TDEE + 300 kcal (superávit controlado)

### 6.2 Cálculo de Substituição

```
Entrada:
  alimentoA.por100g, quantidadeA, alimentoB.por100g, criterio

Cálculo:
  valorA = alimentoA.por100g[criterio] × (quantidadeA / 100)
  quantidadeB = (valorA / alimentoB.por100g[criterio]) × 100

Saída:
  quantidadeB gramas de B = quantidadeA gramas de A
  (no critério selecionado)

Validação:
  - Se alimentoB.por100g[criterio] == 0 → erro (divisão por zero)
  - Se quantidadeB > 2000g → warning (quantidade impraticável)
```

### 6.3 Totais de Refeição

```
Para cada alimento na refeição:
  macros = alimento.por100g × (quantidade / 100)

totalRefeicao = sum(macros de todos os alimentos)
totalDia = sum(totais de todas as refeições do dia)
saldo = metaCalorica - totalDia.calorias
```

---

## 7. Segurança

### 7.1 Autenticação
- Supabase Auth com JWT (tokens assinados server-side)
- Access token com expiração de 1 hora (refresh automático pelo SDK)
- Senha mínima: 8 caracteres, ao menos 1 letra e 1 número

### 7.2 Banco de Dados
- RLS (Row Level Security) em todas as tabelas — definido no schema (seção 4.1)
- Nenhuma query direta sem `auth.uid()` — impossível acessar dados de outro usuário
- Constraints no PostgreSQL (CHECK) para validação adicional server-side

### 7.3 Client
- Variáveis sensíveis (Supabase URL, anon key) via `--dart-define` no build
- Arquivo `.env` no `.gitignore` — nunca commitado
- Supabase anon key é pública por design (RLS protege os dados)

---

## 8. CI/CD e Distribuição

### 8.1 Pipeline (GitHub Actions)

```
Push/PR → Lint → Test → Build → (merge em main) → Deploy
```

| Step | Comando | Quando |
|---|---|---|
| Lint | `dart analyze` | Cada push |
| Test | `flutter test` | Cada push |
| Build Android | `flutter build appbundle` | Merge em main |
| Build iOS | `flutter build ipa` | Merge em main |
| Deploy | Codemagic → Play Store / App Store | Tag de release |

### 8.2 Ambientes

| Ambiente | Supabase Project | Uso |
|---|---|---|
| **dev** | swap-nutri-dev | Desenvolvimento local |
| **staging** | swap-nutri-staging | Testes pré-release |
| **prod** | swap-nutri-prod | Usuários reais |

### 8.3 Publicação nas Stores

| Store | Requisito | Custo |
|---|---|---|
| Google Play Store | Conta de desenvolvedor | $25 (único) |
| Apple App Store | Apple Developer Program | $99/ano |

---

## 9. Métricas e Monitoramento (Produção)

| Ferramenta | Função |
|---|---|
| **Firebase Analytics** | Eventos de uso (telas visitadas, substituições calculadas, refeições registradas) |
| **Firebase Crashlytics** | Crashes e ANRs em tempo real |
| **Supabase Dashboard** | Queries, conexões, storage |

### Eventos-chave para rastrear

| Evento | Significado |
|---|---|
| `onboarding_completed` | Usuário terminou setup |
| `meal_registered` | Refeição salva |
| `substitution_calculated` | Calculadora usada |
| `daily_goal_reached` | Usuário bateu meta calórica |
| `d7_retention` | Usuário voltou após 7 dias |

---

## 10. Roadmap Técnico

| Fase | Escopo | Dependências técnicas |
|---|---|---|
| **MVP** | Auth + Onboarding + Dashboard + Calculadora + Registro de refeições | Supabase, TACO JSON, Flutter base |
| **v1.1** | Histórico semanal, favoritos de alimentos, gráficos de evolução | fl_chart, queries agregadas |
| **v1.2** | Refeições salvas (templates), sugestão automática de substitutos | Algoritmo de similaridade nutricional |
| **v2.0** | Base de alimentos expandida (Supabase), contribuição de usuários, offline-first com Drift | Drift (SQLite), sync strategy |
| **v2.1** | Notificações de lembrete de refeição, dark mode | firebase_messaging, ThemeMode |
| **v3.0** | Social (compartilhar substituições), integração com wearables | Deep links, Health Connect API |

---

## 11. Dependências (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Backend
  supabase_flutter: ^2.0.0

  # Estado
  flutter_riverpod: ^2.6.0
  riverpod_annotation: ^2.6.0

  # Navegação
  go_router: ^14.0.0

  # Models
  freezed_annotation: ^2.4.0
  json_annotation: ^4.9.0

  # UI
  fl_chart: ^0.70.0
  flutter_animate: ^4.5.0
  google_fonts: ^6.2.0
  cached_network_image: ^3.4.0
  flutter_svg: ^2.0.0

  # Utilidades
  intl: ^0.19.0
  shared_preferences: ^2.3.0

dev_dependencies:
  flutter_test:
    sdk: flutter

  # Code generation
  build_runner: ^2.4.0
  freezed: ^2.5.0
  json_serializable: ^6.8.0
  riverpod_generator: ^2.6.0

  # Lint
  very_good_analysis: ^6.0.0

  # Testing
  mocktail: ^1.0.0
```

---

## 12. Diagrama de Dependências entre Módulos

```
presentation/ (UI)
 ├── importa → core/widgets/
 ├── importa → core/theme/
 ├── importa → application/ (providers)
 └── importa → domain/models/

application/ (providers)
 ├── importa → domain/models/
 ├── importa → domain/services/
 └── importa → data/repositories/

data/ (infra)
 ├── importa → domain/models/
 └── NÃO importa application/ ou presentation/

domain/ (lógica pura)
 ├── importa → NADA externo ao domain
 └── NÃO importa Flutter, Supabase, Riverpod, GoRouter

core/ (compartilhado)
 ├── importa → domain/models/ (apenas para tipos em widgets genéricos)
 └── NÃO importa application/ ou data/
```

**Regra de ouro:** `domain/` é 100% puro Dart. Pode ser extraído para um package separado e rodar sem Flutter.

---

*Documento criado em 25/03/2026 — SwapNutri v2.0*
