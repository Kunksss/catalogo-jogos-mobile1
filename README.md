# Catálogo Pessoal de Jogos

Aplicativo Flutter para registrar jogos de videogame (título, plataforma, status e descrição opcional), com estado local em memória. Tocar em um jogo da lista abre a tela de detalhes, de onde é possível editar ou remover. Não usa banco de dados, API nem Firebase.

## Como executar

```
flutter pub get
dart format .
flutter analyze
flutter test
flutter run
```

## Estrutura

```
lib/
├── main.dart
├── models/jogo.dart
├── state/jogo_controller.dart
├── theme/app_theme.dart
├── screens/lista_screen.dart
├── screens/detalhe_screen.dart
├── screens/form_screen.dart
├── widgets/jogo_card.dart
├── widgets/status_chip.dart
└── widgets/estado_vazio.dart
test/
└── jogo_lista_test.dart
```
