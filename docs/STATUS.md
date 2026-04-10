# SwapNutri — Status de Implementacao

> Atualizado em: 07/04/2026
> Baseado no [ROADMAP.md](./ROADMAP.md)

---

## Legenda

| Icone | Status | Descricao |
|---|---|---|
| Done | Implementado | Funcionalidade completa e funcional |
| Parcial | Parcialmente implementado | Estrutura existe mas faltam partes |
| Pendente | Nao implementado | Ainda nao iniciado |

---

## Progresso Geral

| Fase | Total | Done | Parcial | Pendente | Progresso |
|---|---|---|---|---|---|
| Fase 1 — MVP | 35 | 16 | 3 | 16 | 46% |
| Fase 2 — Engajamento | 15 | 0 | 0 | 15 | 0% |
| Fase 3 — Escala | 15 | 0 | 0 | 15 | 0% |
| **Total** | **65** | **16** | **3** | **46** | **25%** |

---

## FASE 1 — MVP

### EP01 — Autenticacao e Seguranca

| ID | Funcionalidade | Prioridade | Status | Observacoes |
|---|---|---|---|---|
| EP01-F01 | Cadastro de usuario | Alta | Done | signup_screen.dart com validacao de e-mail e senha (8+ chars, 1 letra, 1 numero), integracao Supabase Auth |
| EP01-F02 | Login | Alta | Done | login_screen.dart com validacao, tratamento de erros, feedback visual |
| EP01-F03 | Logout | Alta | Done | Botao no dashboard com dialog de confirmacao, limpa sessao via Supabase |
| EP01-F04 | Recuperacao de senha | Media | Pendente | — |
| EP01-F05 | Persistencia de sessao | Alta | Done | Supabase SDK gerencia refresh token automaticamente, GoRouter com auth guard |

**Status do epico: 4/5 implementados (80%)**

**Arquivos implementados:**
- `lib/data/repositories/auth_repository.dart`
- `lib/application/auth/auth_provider.dart`
- `lib/presentation/auth/login_screen.dart`
- `lib/presentation/auth/signup_screen.dart`
- `lib/core/router/app_router.dart` (auth guards)

---

### EP02 — Onboarding e Perfil Inicial

| ID | Funcionalidade | Prioridade | Status | Observacoes |
|---|---|---|---|---|
| EP02-F01 | Coleta de dados pessoais | Alta | Done | Nome, idade, sexo biologico com cards selecionaveis (M/F) |
| EP02-F02 | Medidas corporais | Alta | Done | Peso (kg) e altura (cm) com validacao inline e feedback visual |
| EP02-F03 | Nivel de atividade | Alta | Done | 4 cards visuais: sedentario, leve, moderado, intenso com icones e descricoes |
| EP02-F04 | Objetivo nutricional | Alta | Done | Cards para perder/manter/ganhar com recalculo automatico da meta |
| EP02-F05 | Calculo automatico de TMB | Alta | Done | Mifflin-St Jeor integrado na UI, TDEE calculado, meta sugerida com opcao de editar (800-6000 kcal) |
| EP02-F06 | Fluxo em etapas (stepper) | Alta | Done | PageView com 4 etapas, barra de progresso, navegacao anterior/proximo, botao Concluir na ultima etapa. Dados salvos no Supabase via upsert |

**Status do epico: 6/6 implementados (100%)**

**Arquivos implementados:**
- `lib/presentation/onboarding/onboarding_screen.dart` — UI completa com 4 etapas
- `lib/data/repositories/profile_repository.dart` — CRUD da tabela profiles (get + upsert)
- `lib/application/profile/profile_provider.dart` — profileProvider, onboardingCompletoProvider
- `lib/core/router/app_router.dart` — redirect: sem onboarding → /onboarding, com onboarding → /dashboard
- `lib/app.dart` — listener no profileProvider para re-triggar redirects

**Banco de dados:**
- Tabela `profiles` criada no Supabase com RLS (read/insert/update own profile)

---

### EP03 — Base Nutricional (Tabela TACO)

| ID | Funcionalidade | Prioridade | Status | Observacoes |
|---|---|---|---|---|
| EP03-F01 | Asset JSON da Tabela TACO | Alta | Parcial | Arquivo `taco.json` existe mas com apenas 10 alimentos (meta: ~600) |
| EP03-F02 | Datasource de leitura | Alta | Done | `taco_datasource.dart` carrega, parseia e faz cache em memoria |
| EP03-F03 | Busca com autocomplete | Alta | Done | Busca case-insensitive por nome implementada em `taco_datasource.dart` |
| EP03-F04 | Organizacao por categorias | Media | Pendente | — |

**Status do epico: 2/4 implementados, 1 parcial (50%)**

**Pendencia critica:** O `taco.json` tem apenas 10 alimentos de amostra. Precisa ser expandido para ~600 com dados reais da Tabela TACO (UNICAMP).

---

### EP04 — Calculadora de Substituicoes Alimentares

| ID | Funcionalidade | Prioridade | Status | Observacoes |
|---|---|---|---|---|
| EP04-F01 | Selecao de alimento de origem | Alta | Pendente | Tela existe como placeholder ("em construcao") |
| EP04-F02 | Quantidade de origem | Alta | Pendente | — |
| EP04-F03 | Selecao de alimento substituto | Alta | Pendente | — |
| EP04-F04 | Criterio de equivalencia | Alta | Pendente | — |
| EP04-F05 | Calculo de equivalencia | Alta | Parcial | Logica implementada em `substitution_calculator.dart`, falta UI |
| EP04-F06 | Comparativo nutricional | Alta | Pendente | — |
| EP04-F07 | Historico de substituicoes | Baixa | Pendente | — |

**Status do epico: 0/7 implementados, 1 parcial (7%)**

**O que ja existe (domain):**
- `lib/domain/services/substitution_calculator.dart` — calculo completo com tratamento de divisao por zero
- `lib/domain/models/substitution_result.dart` — model com Freezed
- `lib/domain/models/macros.dart` — suporta `scale()`, `getByCriterio()` e operador `+`

**O que falta (presentation/application):**
- calculator_screen.dart (UI completa)
- calculator_provider.dart (Riverpod)
- Campos de busca com autocomplete (reutilizar EP03-F03)
- Tabela comparativa visual
- Rota no GoRouter (definida mas nao conectada)

---

### EP05 — Registro de Refeicoes

| ID | Funcionalidade | Prioridade | Status | Observacoes |
|---|---|---|---|---|
| EP05-F01 | Criar refeicao | Alta | Pendente | Tela existe como placeholder ("em construcao") |
| EP05-F02 | Adicionar alimentos | Alta | Pendente | — |
| EP05-F03 | Calculo automatico da refeicao | Alta | Parcial | Logica em `macro_calculator.dart`, falta UI e provider |
| EP05-F04 | Editar refeicao | Media | Pendente | — |
| EP05-F05 | Excluir refeicao | Media | Pendente | — |
| EP05-F06 | Persistencia no Supabase | Alta | Pendente | Tabelas definidas no ARQUITETURA.md, nao criadas no Supabase |

**Status do epico: 0/6 implementados, 1 parcial (8%)**

**O que ja existe (domain):**
- `lib/domain/services/macro_calculator.dart` — calcula totais por refeicao e por dia
- `lib/domain/models/refeicao.dart` — models Refeicao e AlimentoRefeicao com Freezed

**O que falta:**
- meal_register_screen.dart (UI completa)
- meal_provider.dart (Riverpod)
- meal_repository.dart (Supabase)
- Tabelas `refeicoes` e `refeicao_alimentos` criadas no Supabase
- Rota no GoRouter (definida mas nao conectada)

---

### EP06 — Dashboard Nutricional

| ID | Funcionalidade | Prioridade | Status | Observacoes |
|---|---|---|---|---|
| EP06-F01 | Resumo calorico diario | Alta | Parcial | Barra de progresso existe mas com valores hardcoded (0/2000) |
| EP06-F02 | Saldo calorico | Alta | Pendente | — |
| EP06-F03 | Breakdown por macronutrientes | Alta | Pendente | — |
| EP06-F04 | Resumo por refeicao | Alta | Parcial | Cards das 4 refeicoes existem mas sem dados reais e sem navegacao |
| EP06-F05 | Acesso rapido a calculadora | Alta | Parcial | FAB existe mas onTap vazio |
| EP06-F06 | Selecao de data | Media | Pendente | — |

**Status do epico: 0/6 implementados, 3 parciais (25%)**

**O que ja existe:**
- Layout basico com barra de progresso e cards de refeicao
- Botao de logout funcional
- FAB da calculadora (sem navegacao)

**O que falta:**
- daily_summary_provider.dart (Riverpod)
- Integracao com dados reais de refeicoes
- Navegacao dos cards para registro de refeicao
- Navegacao do FAB para calculadora
- Grafico de macros (fl_chart)
- View `resumo_diario` no Supabase

---

## FASE 2 — Engajamento e Retencao

### EP07 — Historico e Evolucao

| ID | Funcionalidade | Prioridade | Status | Observacoes |
|---|---|---|---|---|
| EP07-F01 | Historico semanal | Alta | Pendente | — |
| EP07-F02 | Historico mensal | Media | Pendente | — |
| EP07-F03 | Grafico de evolucao calorica | Alta | Pendente | — |
| EP07-F04 | Grafico de macros | Media | Pendente | — |
| EP07-F05 | Streak de dias registrados | Baixa | Pendente | — |

**Status do epico: 0/5 (0%)**

---

### EP08 — Favoritos e Templates de Refeicoes

| ID | Funcionalidade | Prioridade | Status | Observacoes |
|---|---|---|---|---|
| EP08-F01 | Favoritar alimentos | Alta | Pendente | — |
| EP08-F02 | Alimentos recentes | Alta | Pendente | — |
| EP08-F03 | Salvar refeicao como template | Media | Pendente | — |
| EP08-F04 | Registrar a partir de template | Media | Pendente | — |
| EP08-F05 | Copiar refeicao de outro dia | Baixa | Pendente | — |

**Status do epico: 0/5 (0%)**

---

### EP09 — Calculadora Inteligente

| ID | Funcionalidade | Prioridade | Status | Observacoes |
|---|---|---|---|---|
| EP09-F01 | Sugestao automatica de substitutos | Alta | Pendente | — |
| EP09-F02 | Filtro por categoria | Alta | Pendente | — |
| EP09-F03 | Filtro por faixa calorica | Media | Pendente | — |
| EP09-F04 | Substituicao dentro da refeicao | Media | Pendente | — |
| EP09-F05 | Explicacao nutricional | Baixa | Pendente | — |

**Status do epico: 0/5 (0%)**

---

## FASE 3 — Escala e Diferenciacao

### EP10 — Base de Alimentos Expandida

| ID | Funcionalidade | Prioridade | Status | Observacoes |
|---|---|---|---|---|
| EP10-F01 | Tabela de alimentos no Supabase | Alta | Pendente | — |
| EP10-F02 | Cache local com Drift (SQLite) | Alta | Pendente | — |
| EP10-F03 | Alimentos customizados | Media | Pendente | — |
| EP10-F04 | Sugestao de alimentos pela comunidade | Baixa | Pendente | — |
| EP10-F05 | Busca aprimorada | Media | Pendente | — |

**Status do epico: 0/5 (0%)**

---

### EP11 — Experiencia e Personalizacao

| ID | Funcionalidade | Prioridade | Status | Observacoes |
|---|---|---|---|---|
| EP11-F01 | Modo escuro | Alta | Pendente | — |
| EP11-F02 | Notificacoes de lembrete | Media | Pendente | — |
| EP11-F03 | Editar perfil completo | Media | Pendente | — |
| EP11-F04 | Alterar senha | Media | Pendente | — |
| EP11-F05 | Unidade de medida | Baixa | Pendente | — |

**Status do epico: 0/5 (0%)**

---

### EP12 — Social e Integracoes

| ID | Funcionalidade | Prioridade | Status | Observacoes |
|---|---|---|---|---|
| EP12-F01 | Compartilhar substituicao | Media | Pendente | — |
| EP12-F02 | Integracao com Google Health Connect | Media | Pendente | — |
| EP12-F03 | Integracao com Apple HealthKit | Media | Pendente | — |
| EP12-F04 | Exportar dados | Baixa | Pendente | — |
| EP12-F05 | Perfil publico de substituicoes | Baixa | Pendente | — |

**Status do epico: 0/5 (0%)**

---

## Infraestrutura e Base de Codigo

Componentes transversais que suportam os epicos:

| Componente | Status | Observacoes |
|---|---|---|
| Estrutura de pastas (Clean Architecture) | Done | 4 camadas: presentation, application, domain, data |
| Tema Material 3 | Done | Cores, tipografia, componentes customizados |
| GoRouter + auth guards | Done | Redirect baseado em sessao e status do onboarding |
| Supabase Client | Done | Inicializacao via --dart-define |
| Supabase CLI | Done | Instalado e linkado ao projeto remoto |
| Models Freezed (Alimento, Macros, Usuario, Refeicao) | Done | Codegen configurado e funcional |
| Validators | Done | E-mail, senha, nome, idade, peso, altura, meta |
| BMR Calculator | Done | Mifflin-St Jeor + TDEE + meta sugerida |
| Macro Calculator | Done | Totais por refeicao e por dia |
| Substitution Calculator | Done | Calculo por criterio com tratamento de erros |
| TACO Datasource | Done | Load + busca + cache |
| TACO JSON (dados) | Parcial | 10 alimentos (meta: ~600) |
| Tabela Supabase (profiles) | Done | Criada com RLS (read/insert/update own) |
| Tabelas Supabase (refeicoes) | Pendente | Schema definido em ARQUITETURA.md, nao criado |
| Riverpod Providers (auth) | Done | authState, isAuthenticated, currentUser |
| Riverpod Providers (profile) | Done | profileProvider, onboardingCompletoProvider |
| Riverpod Providers (meal, dashboard, calculator) | Pendente | — |
| Repositories (auth, profile) | Done | auth_repository + profile_repository |
| Repositories (meal) | Pendente | — |
| CI/CD (GitHub Actions) | Pendente | — |
| Testes unitarios | Pendente | — |

---

## Proximo passo recomendado

Seguir o caminho critico do MVP:

```
EP01 (Auth) ---------> CONCLUIDO (80%)
     |
     v
EP02 (Onboarding) ---> CONCLUIDO (100%)
     |
     v
EP03 (Base TACO) ----> PROXIMO — expandir taco.json para ~600 alimentos
     |
     v
EP04 (Calculadora) + EP05 (Refeicoes) -----> features principais
     |
     v
EP06 (Dashboard) -----> integrar tudo
```

---

*Documento atualizado em 07/04/2026 — SwapNutri Status v1.1*
