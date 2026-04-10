# SwapNutri — Roadmap de Produto

> Versão 1.0 — 27/03/2026
> Visão estratégica de evolução do produto organizada por épicos

---

## Visão de Releases

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        SWAPNUTRI ROADMAP                                │
│                                                                         │
│  FASE 1 — MVP                FASE 2 — Engajamento    FASE 3 — Escala   │
│  ┌───────────────────┐       ┌──────────────────┐    ┌───────────────┐  │
│  │ EP01 Autenticação │       │ EP07 Histórico   │    │ EP10 Base     │  │
│  │ EP02 Onboarding   │       │ EP08 Favoritos & │    │     Expandida │  │
│  │ EP03 Base TACO    │       │      Templates   │    │ EP11 UX &     │  │
│  │ EP04 Calculadora  │       │ EP09 Calculadora │    │  Personaliz.  │  │
│  │ EP05 Refeições    │       │      Inteligente │    │ EP12 Social & │  │
│  │ EP06 Dashboard    │       │                  │    │  Integrações  │  │
│  └───────────────────┘       └──────────────────┘    └───────────────┘  │
│                                                                         │
│  Objetivo: validar         Objetivo: reter          Objetivo: crescer   │
│  proposta de valor         e engajar usuários       base de usuários    │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## FASE 1 — MVP

> **Objetivo estratégico:** Validar a proposta de valor central — substituição alimentar instantânea + controle nutricional básico.
>
> **Critério de sucesso:** Usuário consegue calcular uma substituição em < 30s e registrar uma refeição em < 2min após onboarding.

---

### EP01 — Autenticação e Segurança

**Objetivo do épico:** Permitir que o usuário crie uma conta, acesse de forma segura e tenha seus dados protegidos.

**Justificativa de negócio:** Sem autenticação não há persistência de dados nem personalização. É pré-requisito para qualquer funcionalidade que salve informações do usuário.

| ID | Funcionalidade | Descrição | Critério de aceite | Prioridade |
|---|---|---|---|---|
| EP01-F01 | Cadastro de usuário | Registro com e-mail e senha | E-mail validado (formato), senha com 8+ caracteres (1 letra + 1 número), e-mail único no sistema. Após cadastro, sessão iniciada automaticamente | Alta |
| EP01-F02 | Login | Autenticação com e-mail e senha | Login bem-sucedido redireciona para dashboard (se onboarding completo) ou onboarding (se não). Credenciais inválidas exibem feedback inline | Alta |
| EP01-F03 | Logout | Encerramento seguro da sessão | Token JWT invalidado, redirecionamento para tela de login, dados locais de sessão limpos | Alta |
| EP01-F04 | Recuperação de senha | Envio de link de redefinição por e-mail | E-mail enviado via Supabase Auth, link expira em 1h, nova senha segue mesmas regras de validação | Média |
| EP01-F05 | Persistência de sessão | Manter usuário logado entre sessões | Refresh token gerenciado pelo SDK Supabase, sessão restaurada automaticamente ao abrir o app | Alta |

**Dependências técnicas:** Supabase Auth configurado, RLS habilitado na tabela `profiles`.

**Riscos:**
- Deliverability de e-mails de recuperação (mitigação: configurar domínio customizado no Supabase)

---

### EP02 — Onboarding e Perfil Inicial

**Objetivo do épico:** Coletar informações essenciais do usuário para calcular sua meta calórica e personalizar a experiência.

**Justificativa de negócio:** O onboarding transforma um cadastro genérico em um perfil nutricional personalizado. Sem ele, o dashboard e o saldo calórico não funcionam. A taxa de conclusão do onboarding (meta: > 80%) é um indicador direto de ativação.

| ID | Funcionalidade | Descrição | Critério de aceite | Prioridade |
|---|---|---|---|---|
| EP02-F01 | Coleta de dados pessoais | Nome (ou apelido), idade, sexo | Campos obrigatórios, idade entre 10 e 120 anos, sexo (M/F) para cálculo de TMB | Alta |
| EP02-F02 | Medidas corporais | Peso (kg) e altura (cm) | Peso entre 30-300kg, altura entre 100-250cm, validação inline com feedback visual | Alta |
| EP02-F03 | Nível de atividade | Frequência semanal de exercícios | Seleção entre: sedentário, leve (1-2x), moderado (3-4x), intenso (5-7x). Cards visuais com descrição de cada nível | Alta |
| EP02-F04 | Objetivo nutricional | Seleção entre perder peso, manter peso, ganhar massa | Seleção obrigatória, influencia o cálculo de meta sugerida | Alta |
| EP02-F05 | Cálculo automático de TMB | Calcular TMB via Mifflin-St Jeor e sugerir meta calórica | TMB calculada com base em sexo, peso, altura e idade. TDEE = TMB × fator de atividade. Sugestão: déficit de 500kcal (perder), TDEE (manter), superávit de 300kcal (ganhar). Usuário pode aceitar sugestão ou definir manualmente (800-6000 kcal) | Alta |
| EP02-F06 | Fluxo em etapas (stepper) | Onboarding como PageView com 4 etapas | Indicador de progresso visível, navegação anterior/próximo, botão "Concluir" na última etapa. Dados salvos no Supabase ao concluir | Alta |

**Dependências técnicas:** Tabela `profiles` no Supabase, fórmula de Mifflin-St Jeor implementada em `bmr_calculator.dart`.

**Métricas:**
- Taxa de conclusão do onboarding > 80%
- Tempo médio para concluir < 2 minutos

---

### EP03 — Base Nutricional (Tabela TACO)

**Objetivo do épico:** Disponibilizar uma base confiável de composição nutricional de alimentos brasileiros para alimentar a calculadora e o registro de refeições.

**Justificativa de negócio:** É a infraestrutura invisível que sustenta as duas features principais do app. Sem dados nutricionais confiáveis, o produto inteiro perde credibilidade. A Tabela TACO (UNICAMP) é a referência brasileira com ~600 alimentos.

| ID | Funcionalidade | Descrição | Critério de aceite | Prioridade |
|---|---|---|---|---|
| EP03-F01 | Asset JSON da Tabela TACO | Empacotar a Tabela TACO como JSON local no app | Arquivo `taco.json` com ~600 alimentos. Cada alimento com: id, nome, categoria, macros por 100g (calorias, proteínas, carboidratos, gorduras, fibras) | Alta |
| EP03-F02 | Datasource de leitura | Serviço que carrega e parseia o JSON em memória | Carregamento no startup do app, conversão para lista de `Alimento`, disponível via provider Riverpod | Alta |
| EP03-F03 | Busca com autocomplete | Campo de busca que filtra alimentos por nome | Busca case-insensitive, tolerante a acentos, resultados em tempo real conforme digitação, exibe categoria como subtítulo | Alta |
| EP03-F04 | Organização por categorias | Alimentos agrupados por categoria (Cereais, Carnes, Frutas, etc.) | Categorias vindas da TACO original, possibilidade de filtrar por categoria na busca | Média |

**Dependências técnicas:** Arquivo `assets/data/taco.json`, model `Alimento` com Freezed, `taco_datasource.dart`.

**Riscos:**
- Dados da TACO podem ter campos nulos ou inconsistentes (mitigação: sanitização no build do JSON)

---

### EP04 — Calculadora de Substituições Alimentares

**Objetivo do épico:** Entregar a feature principal do SwapNutri — calcular a equivalência nutricional entre dois alimentos de forma instantânea.

**Justificativa de negócio:** Este é o diferencial competitivo do produto. É o que separa o SwapNutri de qualquer outro app de contagem calórica. A calculadora precisa ser rápida (< 100ms), intuitiva e visualmente clara. Se essa feature não for excelente, o produto não tem razão de existir.

| ID | Funcionalidade | Descrição | Critério de aceite | Prioridade |
|---|---|---|---|---|
| EP04-F01 | Seleção de alimento de origem | Campo de busca com autocomplete na base TACO | Busca funcional, seleção exibe nome + categoria do alimento | Alta |
| EP04-F02 | Quantidade de origem | Input numérico para gramas do alimento original | Campo numérico, valor > 0, default sugerido de 100g | Alta |
| EP04-F03 | Seleção de alimento substituto | Campo de busca para o alimento desejado como substituto | Mesmo comportamento de busca do campo de origem, não permitir selecionar o mesmo alimento | Alta |
| EP04-F04 | Critério de equivalência | Seleção de qual macro usar como base da equivalência | Opções: calorias (padrão), proteínas, carboidratos, gorduras. Seleção via chips ou segmented control | Alta |
| EP04-F05 | Cálculo de equivalência | Exibir quantidade em gramas do substituto equivalente | Cálculo local (< 100ms), fórmula: `quantidadeB = (valorA / alimentoB.por100g[criterio]) × 100`. Tratar divisão por zero (alimento com 0 no critério selecionado). Warning se resultado > 2000g | Alta |
| EP04-F06 | Comparativo nutricional | Tabela lado a lado com macros de ambos os alimentos | Exibir: calorias, proteínas, carboidratos, gorduras, fibras. Valores proporcionais às quantidades calculadas. Destaque visual no critério equivalido (valores iguais) e nas diferenças | Alta |
| EP04-F07 | Histórico de substituições | Salvar as últimas substituições realizadas | Últimas 10-20 substituições acessíveis na tela da calculadora para consulta rápida. Dados persistidos localmente | Baixa |

**Dependências técnicas:** EP03 (base TACO), `substitution_calculator.dart` (domain/services), `calculator_provider.dart`.

**Métricas:**
- Tempo para realizar uma substituição < 30 segundos
- Calculadora usada ao menos 1x por sessão (evento `substitution_calculated`)

---

### EP05 — Registro de Refeições

**Objetivo do épico:** Permitir que o usuário registre o que comeu em cada refeição do dia, com cálculo automático de macronutrientes.

**Justificativa de negócio:** O registro é o que transforma o app de uma ferramenta pontual (calculadora) em um companheiro diário de nutrição. Sem ele, não há recorrência de uso. É o pilar que alimenta o dashboard e cria o hábito de retorno.

| ID | Funcionalidade | Descrição | Critério de aceite | Prioridade |
|---|---|---|---|---|
| EP05-F01 | Criar refeição | Selecionar tipo de refeição e data | Tipos: café da manhã, almoço, lanche, jantar. Data padrão: hoje. Regra: máximo 1 registro por tipo por dia (constraint no banco) | Alta |
| EP05-F02 | Adicionar alimentos | Busca de alimentos (TACO) + quantidade em gramas | Autocomplete funcional, campo de gramas obrigatório (> 0). Múltiplos alimentos por refeição. Exibir macros calculados de cada item inline | Alta |
| EP05-F03 | Cálculo automático da refeição | Somatório de macros de todos os alimentos | Total de calorias, proteínas, carboidratos, gorduras e fibras atualizado em tempo real conforme alimentos são adicionados/removidos | Alta |
| EP05-F04 | Editar refeição | Alterar alimentos ou quantidades já registrados | Alterar quantidade, remover alimento, adicionar novo alimento. Totais recalculados. Atualização refletida no dashboard | Média |
| EP05-F05 | Excluir refeição | Remover uma refeição registrada | Confirmação antes de excluir (ação destrutiva). Cascade delete dos alimentos. Dashboard atualizado | Média |
| EP05-F06 | Persistência no Supabase | Salvar refeições e alimentos no banco | INSERT em `refeicoes` + `refeicao_alimentos`. RLS garante isolamento. Sync com dashboard via invalidação de provider | Alta |

**Dependências técnicas:** EP03 (base TACO), tabelas `refeicoes` e `refeicao_alimentos` no Supabase, `meal_repository.dart`, `meal_provider.dart`.

**Métricas:**
- Tempo para primeiro registro de refeição após onboarding < 2 minutos
- Média de refeições registradas por dia por usuário ativo

---

### EP06 — Dashboard Nutricional

**Objetivo do épico:** Oferecer uma visão consolidada do consumo diário do usuário, tornando o progresso em direção à meta calórica visível e motivador.

**Justificativa de negócio:** O dashboard é a "home" do app — a tela que o usuário vê toda vez que abre. Precisa comunicar em 3 segundos: "como estou indo hoje?". Uma boa visualização de progresso é comprovadamente um dos maiores drivers de retenção em apps de saúde.

| ID | Funcionalidade | Descrição | Critério de aceite | Prioridade |
|---|---|---|---|---|
| EP06-F01 | Resumo calórico diário | Barra de progresso: calorias consumidas vs. meta | Barra visual com percentual, cores indicativas (verde: dentro da meta, amarelo: próximo, vermelho: acima). Valores numéricos: consumido / meta | Alta |
| EP06-F02 | Saldo calórico | Indicação de calorias restantes no dia | "Ainda pode consumir X kcal" ou "Excedeu em X kcal". Não bloqueia registro — apenas alerta visual (RN06) | Alta |
| EP06-F03 | Breakdown por macronutrientes | Exibição de proteínas, carboidratos e gorduras do dia | Valores em gramas e percentual do total calórico. Visualização em gráfico de rosca ou barras horizontais | Alta |
| EP06-F04 | Resumo por refeição | Cards para cada refeição do dia | Cards: café, almoço, lanche, jantar. Cada card mostra total de calorias. Estado: "Registrar" (vazio) ou "Editar" (com dados). Tap leva ao registro/edição | Alta |
| EP06-F05 | Acesso rápido à calculadora | Botão de destaque para a calculadora | FAB ou botão proeminente, sempre visível no dashboard. Atalho direto para EP04 | Alta |
| EP06-F06 | Seleção de data | Navegar entre dias para ver consumo anterior | Seletor de data (date picker ou swipe horizontal). Padrão: hoje. Dados carregados do Supabase (view `resumo_diario`) | Média |

**Dependências técnicas:** EP05 (registro de refeições), `daily_summary_provider.dart`, view `resumo_diario` no Supabase.

**Métricas:**
- Sessões diárias por usuário ativo
- Evento `daily_goal_reached` — taxa de usuários que atingem a meta

---

## FASE 2 — Engajamento e Retenção

> **Objetivo estratégico:** Transformar uso inicial em hábito. Reduzir fricção no registro diário e aumentar o valor percebido ao longo do tempo.
>
> **Critério de sucesso:** Retenção D7 > 40%, retenção D30 > 20%.

---

### EP07 — Histórico e Evolução

**Objetivo do épico:** Dar ao usuário visibilidade sobre seu comportamento alimentar ao longo do tempo, criando senso de progresso e accountability.

**Justificativa de negócio:** Usuários que visualizam progresso têm 2-3x mais retenção em apps de saúde. O histórico transforma dados isolados (refeições diárias) em uma narrativa de evolução pessoal. É o que faz o usuário pensar "não quero quebrar minha sequência".

| ID | Funcionalidade | Descrição | Critério de aceite | Prioridade |
|---|---|---|---|---|
| EP07-F01 | Histórico semanal | Visão dos últimos 7 dias de consumo | Lista ou calendário com total calórico de cada dia. Indicação visual de dias dentro/fora da meta. Tap em um dia abre o dashboard daquele dia | Alta |
| EP07-F02 | Histórico mensal | Visão do mês corrente | Calendário com marcação de cores por dia (verde/amarelo/vermelho). Resumo do mês: média calórica, dias dentro da meta, dias registrados | Média |
| EP07-F03 | Gráfico de evolução calórica | Gráfico de linha: calorias diárias vs. meta | Eixo X: dias (7d / 30d toggle). Eixo Y: calorias. Linha da meta como referência horizontal. Implementado com fl_chart | Alta |
| EP07-F04 | Gráfico de macros | Evolução da distribuição de macros ao longo do tempo | Gráfico de barras empilhadas ou linhas separadas para proteínas, carboidratos e gorduras | Média |
| EP07-F05 | Streak de dias registrados | Contagem de dias consecutivos com refeições registradas | Exibido no dashboard como badge motivacional. Reset ao pular um dia | Baixa |

**Dependências técnicas:** Queries agregadas no Supabase (views), `fl_chart`, novo provider de histórico.

---

### EP08 — Favoritos e Templates de Refeições

**Objetivo do épico:** Reduzir drasticamente o tempo de registro para refeições recorrentes, eliminando a principal fricção de uso diário.

**Justificativa de negócio:** Pesquisas de comportamento alimentar mostram que a maioria das pessoas come os mesmos 15-20 alimentos regularmente e repete refeições inteiras 3-4x por semana. Cada segundo economizado no registro diário é um multiplicador de retenção. Se registrar uma refeição que o usuário já comeu antes leva mais de 10 segundos, estamos falhando.

| ID | Funcionalidade | Descrição | Critério de aceite | Prioridade |
|---|---|---|---|---|
| EP08-F01 | Favoritar alimentos | Marcar alimentos da TACO como favoritos | Ícone de favorito na busca e no detalhe do alimento. Favoritos aparecem no topo da busca. Persistência local (shared_preferences) ou Supabase | Alta |
| EP08-F02 | Alimentos recentes | Mostrar últimos alimentos usados na busca | Seção "Recentes" acima dos resultados de busca. Últimos 10-15 alimentos. Atualizado automaticamente | Alta |
| EP08-F03 | Salvar refeição como template | Transformar uma refeição registrada em template reutilizável | Botão "Salvar como template" na refeição. Nome customizável (ex: "Meu café padrão"). Persiste a lista de alimentos e quantidades | Média |
| EP08-F04 | Registrar a partir de template | Usar template para registrar refeição com um toque | Seletor de templates no registro de refeição. Carrega alimentos e quantidades. Permite editar antes de salvar | Média |
| EP08-F05 | Copiar refeição de outro dia | Duplicar uma refeição de data anterior | Na tela de registro, opção "Copiar de outro dia". Seleciona data e tipo de refeição. Carrega alimentos para edição | Baixa |

**Dependências técnicas:** Nova tabela `refeicao_templates` no Supabase (ou storage local), extensão da busca de alimentos.

---

### EP09 — Calculadora Inteligente

**Objetivo do épico:** Evoluir a calculadora de uma ferramenta manual para um assistente proativo que sugere substituições de forma inteligente.

**Justificativa de negócio:** O MVP exige que o usuário já saiba o que quer comer no lugar. A versão inteligente responde "não sei o que comer no lugar de arroz — me sugira". Isso amplia o público-alvo de entusiastas de nutrição para qualquer pessoa que quer variar a dieta.

| ID | Funcionalidade | Descrição | Critério de aceite | Prioridade |
|---|---|---|---|---|
| EP09-F01 | Sugestão automática de substitutos | Dado um alimento, sugerir os 3-5 melhores substitutos | Algoritmo: ordenar alimentos da mesma categoria por proximidade do perfil de macros (distância euclidiana normalizada). Exibir % de similaridade | Alta |
| EP09-F02 | Filtro por categoria | Filtrar substitutos por grupo alimentar | "Substituir arroz por outro cereal" ou "por qualquer alimento". Categorias da TACO como filtro | Alta |
| EP09-F03 | Filtro por faixa calórica | Filtrar substitutos por range de calorias | Slider para definir faixa (ex: 50-150 kcal por 100g). Combinável com filtro de categoria | Média |
| EP09-F04 | Substituição dentro da refeição | Trocar um alimento diretamente na refeição registrada | Na edição da refeição, botão "Substituir" ao lado de cada alimento. Abre calculadora pré-preenchida com o alimento de origem e a quantidade | Média |
| EP09-F05 | Explicação nutricional | Texto explicativo sobre a substituição realizada | "200g de batata-doce tem as mesmas calorias que 150g de arroz, mas 2x mais fibras e 30% menos carboidratos". Gerado automaticamente a partir dos dados | Baixa |

**Dependências técnicas:** Algoritmo de similaridade nutricional, refatoração do `substitution_calculator.dart`.

---

## FASE 3 — Escala e Diferenciação

> **Objetivo estratégico:** Ampliar a base de dados, expandir a plataforma e criar efeitos de rede que tornem o SwapNutri difícil de replicar.
>
> **Critério de sucesso:** 10k+ usuários ativos, rating 4.5+ nas stores, base de alimentos > 2000 itens.

---

### EP10 — Base de Alimentos Expandida

**Objetivo do épico:** Migrar de uma base estática (JSON local) para uma base dinâmica e expansível no Supabase, permitindo crescimento contínuo sem novos builds.

**Justificativa de negócio:** A TACO tem ~600 alimentos, mas o Brasil consome muito mais. Usuários vão procurar "whey protein", "pasta de amendoim X", "açaí" e não encontrar. Cada busca sem resultado é um momento de frustração. A base expandida resolve isso e abre caminho para contribuição da comunidade (efeito de rede).

| ID | Funcionalidade | Descrição | Critério de aceite | Prioridade |
|---|---|---|---|---|
| EP10-F01 | Tabela de alimentos no Supabase | Migrar base TACO para tabela `alimentos` no Supabase | Schema com mesmos campos do JSON + campos de auditoria. Seed com dados da TACO. RLS para leitura pública | Alta |
| EP10-F02 | Cache local com Drift (SQLite) | Cache offline da base de alimentos | Sync incremental (busca apenas novos/atualizados desde último sync). App funciona offline com cache local | Alta |
| EP10-F03 | Alimentos customizados | Usuário pode cadastrar alimentos não encontrados na base | Formulário com nome, macros por 100g. Marcado como "custom" e visível apenas para o autor. Validação básica de valores | Média |
| EP10-F04 | Sugestão de alimentos pela comunidade | Usuários sugerem alimentos para a base oficial | Formulário de sugestão, fila de moderação (Edge Function ou painel admin). Alimento aprovado fica disponível para todos | Baixa |
| EP10-F05 | Busca aprimorada | Full-text search com sinônimos e tolerância a erros | PostgreSQL `tsvector` para busca textual. Sinônimos: "batata inglesa" = "batata", "frango" = "peito de frango". Typo tolerance via `pg_trgm` | Média |

**Dependências técnicas:** Drift (SQLite), Supabase Edge Functions (moderação), estratégia de sync offline-first.

---

### EP11 — Experiência e Personalização

**Objetivo do épico:** Refinar a experiência do usuário com personalização visual e funcional, elevando a percepção de qualidade do app.

**Justificativa de negócio:** Em um mercado com MyFitnessPal, FatSecret e Yazio, a experiência visual e a atenção ao detalhe são diferenciais reais. Modo escuro é esperado por 80%+ dos usuários de apps fitness. Notificações de lembrete combatem diretamente o esquecimento — principal causa de churn em apps de tracking.

| ID | Funcionalidade | Descrição | Critério de aceite | Prioridade |
|---|---|---|---|---|
| EP11-F01 | Modo escuro | Tema dark completo | Toggle no perfil ou automático (seguir sistema). Todas as telas adaptadas. Persistência da preferência | Alta |
| EP11-F02 | Notificações de lembrete | Lembrar o usuário de registrar refeições | Configurável por tipo de refeição e horário (ex: café às 8h, almoço às 12h). Opt-in no onboarding ou perfil. Push notification local | Média |
| EP11-F03 | Tela de perfil do usuário | Tela dedicada para visualizar e editar todos os dados pessoais e nutricionais | Tela acessível via menu/dashboard. Exibe: foto de perfil, nome, idade, sexo, peso, altura, nível de atividade, objetivo, meta calórica. Todos os campos editáveis inline ou via formulário. Recalcular TMB sugerida ao alterar medidas. Sem refazer onboarding. Dados atualizados na tabela `profiles` do Supabase | Média |
| EP11-F04 | Foto de perfil | Upload e exibição de foto de perfil do usuário | Upload via câmera ou galeria (image_picker). Imagem armazenada no Supabase Storage (bucket `avatars`). Crop/redimensionamento antes do upload (max 512x512). Exibida como avatar circular na tela de perfil e no dashboard. Fallback com iniciais do nome quando sem foto | Média |
| EP11-F05 | Alterar senha | Troca de senha autenticada | Solicitar senha atual + nova senha. Mesmas regras de validação do cadastro | Média |
| EP11-F06 | Unidade de medida | Suporte a medidas caseiras além de gramas | "1 colher de sopa", "1 xícara", "1 unidade" com conversão automática para gramas. Tabela de conversão por alimento | Baixa |

**Dependências técnicas:** `ThemeMode` do Flutter, `firebase_messaging` ou notificações locais, `image_picker` + Supabase Storage para foto de perfil, tabela de medidas caseiras.

---

### EP12 — Social e Integrações

**Objetivo do épico:** Criar efeitos de rede e conectar o SwapNutri ao ecossistema de saúde do usuário, aumentando o custo de troca e o valor percebido.

**Justificativa de negócio:** Efeitos de rede (compartilhamento de substituições) criam crescimento orgânico. Integração com wearables posiciona o SwapNutri como parte de um ecossistema de saúde, não um app isolado. Ambos aumentam o LTV e reduzem churn.

| ID | Funcionalidade | Descrição | Critério de aceite | Prioridade |
|---|---|---|---|---|
| EP12-F01 | Compartilhar substituição | Gerar card visual de uma substituição para compartilhar | Imagem gerada no app com os dados da substituição + branding SwapNutri. Compartilhável via WhatsApp, Instagram Stories, etc. Deep link para abrir no app | Média |
| EP12-F02 | Integração com Google Health Connect | Importar dados de peso e atividade física | Leitura de peso (atualizar perfil) e calorias gastas (enriquecer dashboard). Permissão granular. Android apenas | Média |
| EP12-F03 | Integração com Apple HealthKit | Equivalente ao Health Connect para iOS | Mesmas funcionalidades: peso e atividade. iOS apenas | Média |
| EP12-F04 | Exportar dados | Exportar histórico alimentar em CSV/PDF | Seletor de período, formato (CSV ou PDF). Inclui: data, refeição, alimentos, macros, totais diários | Baixa |
| EP12-F05 | Perfil público de substituições | Página pública com substituições mais populares | Ranking das substituições mais feitas pela comunidade. Sem dados pessoais — apenas "arroz → batata-doce" com contagem | Baixa |

**Dependências técnicas:** Share API nativa, Health Connect SDK, HealthKit, deep links, Edge Functions para ranking.

---

## Resumo Executivo

| Fase | Épicos | Funcionalidades | Foco |
|---|---|---|---|
| **Fase 1 — MVP** | 6 épicos (EP01-EP06) | 35 funcionalidades | Validar proposta de valor |
| **Fase 2 — Engajamento** | 3 épicos (EP07-EP09) | 15 funcionalidades | Reter e engajar |
| **Fase 3 — Escala** | 3 épicos (EP10-EP12) | 16 funcionalidades | Crescer e diferenciar |
| **Total** | **12 épicos** | **66 funcionalidades** | — |

---

## Matriz de Dependências entre Épicos

```
EP01 (Auth) ──────────┐
                       ▼
EP02 (Onboarding) ──► EP06 (Dashboard) ◄── EP05 (Refeições)
                                │                  │
EP03 (Base TACO) ──► EP04 (Calculadora)            │
       │                  │                        │
       │                  ▼                        ▼
       │            EP09 (Calc. Intel.)      EP08 (Favoritos)
       │                                           │
       ▼                                           ▼
EP10 (Base Expandida)                   EP07 (Histórico)
       │
       ▼
EP11 (UX/Personalização) ──► EP12 (Social/Integrações)
```

**Caminho crítico do MVP:** EP01 → EP02 → EP03 → EP04 + EP05 → EP06

---

*Documento criado em 27/03/2026 — SwapNutri Product Roadmap v1.0*
