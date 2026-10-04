import 'package:flutter/material.dart';

import 'screens/lista_screen.dart';
import 'state/jogo_controller.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const CatalogoJogosApp());
}

class CatalogoJogosApp extends StatefulWidget {
  const CatalogoJogosApp({super.key});

  @override
  State<CatalogoJogosApp> createState() => _CatalogoJogosAppState();
}

class _CatalogoJogosAppState extends State<CatalogoJogosApp> {
  final JogoController _controller = JogoController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Jogos',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.claro,
      darkTheme: AppTheme.escuro,
      home: ListaScreen(controller: _controller),
    );
  }
}
