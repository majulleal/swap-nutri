# SwapNutri

Calculadora de substituicoes alimentares e controle nutricional.

## Stack

- **Flutter** + **Dart**
- **Supabase** (Auth + PostgreSQL + RLS)
- **Riverpod** (estado)
- **GoRouter** (navegacao)
- **Freezed** (models)

## Setup

```bash
# Instalar dependencias
flutter pub get

# Gerar codigo (Freezed, Riverpod, JSON)
dart run build_runner build --delete-conflicting-outputs

# Rodar o app
flutter run
```

## Documentacao

- [Documento de Produto](docs/PRODUTO.md)
- [Arquitetura e Stack](docs/ARQUITETURA.md)
