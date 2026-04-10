# SwapNutri — Comandos de Desenvolvimento

> Todos os comandos utilizam o `Makefile` na raiz do projeto.

---

## Rodar o App

| Comando | Descrição |
|---|---|
| `make ios` | Roda no simulador iOS |
| `make web` | Abre no Chrome |
| `make macos` | Roda como app desktop (macOS) |
| `make android` | Lança emulador Android e roda |

---

## Desenvolvimento

| Comando | Descrição |
|---|---|
| `make analyze` | Verifica erros e warnings no código |
| `make build` | Gera arquivos Freezed e Riverpod (build_runner) |
| `make test` | Roda os testes |

---

## Pré-requisitos

- Flutter 3.27+ instalado
- Simulador iOS ou Android configurado
- Credenciais do Supabase definidas no `Makefile`
