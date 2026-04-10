SUPABASE_URL=https://qzdylcztarbggwxmiyqr.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF6ZHlsY3p0YXJiZ2d3eG1peXFyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ2NDk4MDEsImV4cCI6MjA5MDIyNTgwMX0.BnUvAA_slI51sMFGxqO0OYkH9VZwXqGtLfww_S9AF5I

DART_DEFINES=--dart-define=SUPABASE_URL=$(SUPABASE_URL) --dart-define=SUPABASE_ANON_KEY=$(SUPABASE_ANON_KEY)

## Rodar no iOS Simulator
ios:
	flutter run $(DART_DEFINES)

## Rodar na web (Chrome)
web:
	flutter run -d chrome $(DART_DEFINES)

## Rodar no macOS (desktop)
macos:
	flutter run -d macos $(DART_DEFINES)

## Rodar no Android Emulator
android:
	flutter emulators --launch Medium_Phone_API_36
	flutter run -d emulator $(DART_DEFINES)

## Analisar codigo
analyze:
	flutter analyze

## Gerar arquivos Freezed/Riverpod
build:
	dart run build_runner build --delete-conflicting-outputs

## Rodar testes
test:
	flutter test
