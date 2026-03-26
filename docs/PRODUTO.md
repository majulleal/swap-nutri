# SwapNutri — Documentação de Produto

## 1. Visão Geral

**SwapNutri** é um aplicativo mobile de nutrição pessoal cujo diferencial é a **calculadora de substituições alimentares**. A plataforma permite que qualquer pessoa — independentemente de ter acompanhamento profissional — controle sua ingestão calórica diária, registre refeições e, principalmente, descubra equivalências nutricionais entre alimentos de forma instantânea.

> *"Quero trocar arroz branco por batata-doce no almoço. Quanto preciso comer para manter os mesmos macros?"*

Essa é a pergunta que o SwapNutri responde em segundos.

---

## 2. Problema

| Dor do usuário | Contexto |
|---|---|
| Dificuldade em manter a dieta por monotonia alimentar | A maioria das pessoas desiste de dietas por enjoar dos mesmos alimentos repetidamente |
| Falta de conhecimento nutricional para fazer substituições seguras | Trocar alimentos sem orientação pode desbalancear a dieta |
| Complexidade no cálculo manual de macronutrientes | Tabelas nutricionais são extensas e de difícil interpretação |
| Ferramentas existentes focam apenas em contagem calórica | Não resolvem o problema de "o que comer no lugar de X" |

---

## 3. Proposta de Valor

O SwapNutri combina **três pilares** em uma única plataforma:

1. **Calculadora de Substituições Alimentares** (diferencial competitivo) — dado um alimento de origem e um alimento de destino, calcula a quantidade equivalente em macronutrientes (proteínas, carboidratos, gorduras) e calorias.

2. **Registro e Controle de Refeições** — o usuário registra o que comeu em cada refeição do dia (café da manhã, almoço, lanche, jantar) e acompanha seus macros e calorias em tempo real.

3. **Dashboard Nutricional Pessoal** — visão consolidada do consumo diário versus a meta calórica definida pelo usuário.

---

## 4. Público-Alvo

| Persona | Descrição |
|---|---|
| **Praticante fitness iniciante** | Começou a treinar, quer controlar a alimentação mas não sabe por onde começar |
| **Pessoa em reeducação alimentar** | Busca variar o cardápio sem sair dos limites calóricos |
| **Estudante universitário** | Orçamento limitado, precisa substituir alimentos por opções mais acessíveis mantendo o valor nutricional |
| **Pessoa com restrições alimentares** | Precisa substituir alimentos por intolerância/alergia e quer manter o equilíbrio nutricional |

---

## 5. Funcionalidades

### 5.1 Autenticação e Conta

| ID | Funcionalidade | Descrição | Prioridade |
|---|---|---|---|
| F01 | Cadastro de usuário | Registro com e-mail e senha. Validação de formato de e-mail e força mínima de senha (8+ caracteres, ao menos 1 número) | Alta |
| F02 | Login | Autenticação com e-mail e senha | Alta |
| F03 | Logout | Encerramento seguro da sessão | Alta |
| F04 | Recuperação de senha | Envio de link de redefinição por e-mail | Média |

### 5.2 Onboarding

| ID | Funcionalidade | Descrição | Prioridade |
|---|---|---|---|
| F05 | Perfil inicial | Coleta de: nome (ou apelido), idade, peso (kg), altura (cm) | Alta |
| F06 | Nível de atividade | Frequência semanal de exercícios (sedentário, leve 1-2x, moderado 3-4x, intenso 5-7x) | Alta |
| F07 | Meta calórica | O usuário define quantas calorias deseja consumir por dia. **Sugestão de melhoria:** calcular automaticamente a TMB (Taxa Metabólica Basal) usando a fórmula de Mifflin-St Jeor e sugerir faixas calóricas para perda, manutenção ou ganho de peso | Alta |
| F08 | Objetivo nutricional | Seleção entre: perder peso, manter peso, ganhar massa. Isso influencia a distribuição sugerida de macros | Média |

### 5.3 Calculadora de Substituições (Core Feature)

| ID | Funcionalidade | Descrição | Prioridade |
|---|---|---|---|
| F09 | Busca de alimento de origem | Campo de busca com autocomplete na base de alimentos (TACO/IBGE) | Alta |
| F10 | Seleção de quantidade de origem | Usuário informa quantos gramas do alimento original ele consome | Alta |
| F11 | Busca de alimento substituto | Campo de busca para o alimento que deseja usar como substituto | Alta |
| F12 | Cálculo de equivalência | Exibe a quantidade (em gramas) do alimento substituto necessária para igualar os macronutrientes do alimento original | Alta |
| F13 | Comparativo nutricional | Tabela lado a lado mostrando: calorias, proteínas, carboidratos, gorduras, fibras de ambos os alimentos | Alta |
| F14 | Critério de equivalência | Permitir que o usuário escolha por qual macro quer equivaler (calorias, proteínas, carboidratos ou gorduras) — já que raramente dois alimentos são idênticos em todos os macros simultaneamente | Alta |
| F15 | Histórico de substituições | Salvar as últimas substituições realizadas para acesso rápido | Baixa |

### 5.4 Registro de Refeições

| ID | Funcionalidade | Descrição | Prioridade |
|---|---|---|---|
| F16 | Criar refeição | Selecionar tipo (café da manhã, almoço, lanche, jantar) e data | Alta |
| F17 | Adicionar alimentos à refeição | Busca de alimentos com autocomplete + campo de quantidade em gramas | Alta |
| F18 | Cálculo automático por refeição | Somatório de calorias e macros de todos os alimentos da refeição | Alta |
| F19 | Editar refeição | Alterar alimentos ou quantidades de uma refeição já registrada | Média |
| F20 | Excluir refeição | Remover uma refeição registrada | Média |

### 5.5 Dashboard

| ID | Funcionalidade | Descrição | Prioridade |
|---|---|---|---|
| F21 | Resumo calórico diário | Barra de progresso: calorias consumidas vs. meta diária | Alta |
| F22 | Breakdown por macro | Exibição de proteínas, carboidratos e gorduras consumidos no dia (em gramas e percentual) | Alta |
| F23 | Resumo por refeição | Cards para cada refeição do dia com total de calorias e botão de ação (registrar/editar) | Alta |
| F24 | Acesso rápido à calculadora | Botão de destaque para a calculadora de substituições | Alta |
| F25 | Saldo calórico | Indicação de quantas calorias ainda podem ser consumidas no dia | Alta |

### 5.6 Perfil do Usuário

| ID | Funcionalidade | Descrição | Prioridade |
|---|---|---|---|
| F26 | Editar dados pessoais | Atualizar nome, peso, altura, idade, nível de atividade | Média |
| F27 | Alterar meta calórica | Reconfigurar a meta sem refazer o onboarding | Média |
| F28 | Alterar senha | Troca de senha autenticada | Média |

---

## 6. Sugestões de Melhorias e Funcionalidades Adicionais

As funcionalidades abaixo **não foram mencionadas na descrição original**, mas são recomendadas por um olhar de produto:

### 6.1 Essenciais (recomendo incluir no MVP)

| Funcionalidade | Justificativa |
|---|---|
| **Base de dados nutricional robusta (Tabela TACO)** | Sem uma base confiável de composição nutricional dos alimentos, a calculadora de substituições e o registro de refeições não funcionam. A Tabela TACO (UNICAMP) é a referência brasileira e possui dados de ~600 alimentos |
| **Cálculo automático de TMB** | Usar a fórmula de Mifflin-St Jeor (baseada em peso, altura, idade e sexo) para sugerir metas calóricas ao invés de depender apenas do input manual do usuário |
| **Validação e feedback visual nos formulários** | Mensagens inline com animações sutis para guiar o usuário. Sem dialogs bloqueantes |

### 6.2 Importantes (pós-MVP, alto impacto)

| Funcionalidade | Justificativa |
|---|---|
| **Histórico semanal/mensal de consumo** | Permite que o usuário identifique padrões e ajuste a dieta ao longo do tempo |
| **Favoritos de alimentos** | Os usuários comem os mesmos alimentos frequentemente. Uma lista de favoritos acelera o registro |
| **Refeições salvas (templates)** | Salvar combinações de alimentos como "Meu café da manhã padrão" para registro com um clique |
| **Gráficos de evolução** | Gráfico de linha mostrando calorias diárias na semana/mês vs. meta |

### 6.3 Diferenciais (futuro, diferenciação competitiva)

| Funcionalidade | Justificativa |
|---|---|
| **Sugestão automática de substituições** | Ao invés do usuário escolher o substituto, o app sugere os 3-5 melhores substitutos para um alimento com base no perfil de macros mais próximo |
| **Filtro por categoria na substituição** | "Quero substituir arroz por outro carboidrato" — filtrar substitutos por grupo alimentar |
| **Modo escuro** | Padrão em apps de saúde/fitness modernos |
| **Integração com wearables** | Importar dados de saúde do Google Health Connect e Apple HealthKit |

---

## 7. Arquitetura de Telas (Fluxo do Usuário)

```
┌─────────────┐
│  Tela Login  │
└──────┬──────┘
       │ (novo usuário)          (usuário existente)
       ▼                                │
┌─────────────┐                         │
│  Cadastro   │                         │
└──────┬──────┘                         │
       │                                │
       ▼                                │
┌─────────────┐                         │
│  Onboarding │                         │
│  (4 etapas) │                         │
└──────┬──────┘                         │
       │                                │
       ▼                                ▼
┌──────────────────────────────────────────┐
│              DASHBOARD                    │
│                                          │
│  ┌──────────┐  ┌──────────────────────┐  │
│  │ Resumo   │  │ Refeições do dia     │  │
│  │ Calórico │  │ ┌────┐┌────┐┌────┐  │  │
│  │ (barra)  │  │ │Café││Alm.││Jant│  │  │
│  └──────────┘  │ └────┘└────┘└────┘  │  │
│                └──────────────────────┘  │
│  ┌──────────────────┐                    │
│  │ 🔄 Calculadora   │                    │
│  │ de Substituições │                    │
│  └──────────────────┘                    │
└──────────────────────────────────────────┘
       │                    │
       ▼                    ▼
┌─────────────┐    ┌────────────────┐
│  Registro   │    │  Calculadora   │
│  Refeição   │    │  Substituição  │
└─────────────┘    └────────────────┘
```

---

## 8. Regras de Negócio

| ID | Regra |
|---|---|
| RN01 | O cálculo de substituição deve ser baseado em dados nutricionais por 100g do alimento e proporcional à quantidade informada pelo usuário |
| RN02 | O critério padrão de equivalência é por **calorias**, mas o usuário pode selecionar outro macro |
| RN03 | A meta calórica diária deve estar entre 800 e 6000 kcal (limites de segurança) |
| RN04 | O peso deve ser informado em kg (30-300kg) e a altura em cm (100-250cm) |
| RN05 | As refeições são vinculadas a uma data. Cada dia pode ter no máximo 1 registro por tipo de refeição (café, almoço, lanche, jantar) |
| RN06 | O saldo calórico não impede o registro — apenas alerta visualmente quando a meta é ultrapassada |
| RN07 | Senhas devem ter no mínimo 8 caracteres, com pelo menos 1 letra e 1 número |
| RN08 | O e-mail deve ser único no sistema (não permite dois cadastros com o mesmo e-mail) |

---

## 9. Requisitos Não-Funcionais

| ID | Requisito | Especificação |
|---|---|---|
| RNF01 | Plataformas | Android 8+ (API 26) e iOS 14+ |
| RNF02 | Performance | O cálculo de substituição deve retornar em menos de 100ms (local) |
| RNF03 | Acessibilidade | Contraste mínimo AA (WCAG 2.1), suporte a TalkBack/VoiceOver |
| RNF04 | Segurança | Auth via Supabase (JWT), RLS no banco, dados sensíveis nunca em plain text |
| RNF05 | Offline | Base de alimentos disponível offline. Refeições com sync quando reconectar |
| RNF06 | Startup | Cold start do app em menos de 3 segundos |

---

## 10. Stack Tecnológica

| Camada | Tecnologia |
|---|---|
| Mobile | Flutter + Dart |
| Estado | Riverpod 2 |
| Backend | Supabase (PostgreSQL + Auth + RLS) |
| Base nutricional | Tabela TACO (JSON local) |
| Distribuição | Google Play Store + Apple App Store |

> Detalhes completos em [ARQUITETURA.md](./ARQUITETURA.md)

---

## 11. Métricas de Sucesso

| Métrica | Meta |
|---|---|
| Tempo para primeiro registro de refeição (após onboarding) | < 2 minutos |
| Tempo para realizar uma substituição alimentar | < 30 segundos |
| Taxa de conclusão do onboarding | > 80% |
| Retenção D7 (retorno após 7 dias) | > 40% |

---

## 12. Glossário

| Termo | Definição |
|---|---|
| **Macronutrientes (macros)** | Proteínas, carboidratos e gorduras — os três nutrientes que fornecem energia (calorias) |
| **TMB** | Taxa Metabólica Basal — quantidade mínima de calorias que o corpo gasta em repouso |
| **TACO** | Tabela Brasileira de Composição de Alimentos, mantida pela UNICAMP |
| **Substituição alimentar** | Troca de um alimento por outro mantendo equivalência em um ou mais macronutrientes |
| **Saldo calórico** | Diferença entre a meta calórica diária e as calorias já consumidas |

---

*Documento criado em 25/03/2026 — SwapNutri v1.0*
