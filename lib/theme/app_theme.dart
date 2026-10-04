import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const Color _semente = Color(0xFF5B3FD1);

  static ThemeData get claro => _construir(Brightness.light);

  static ThemeData get escuro => _construir(Brightness.dark);

  static ThemeData _construir(Brightness brilho) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _semente,
        brightness: brilho,
      ),
    );
  }
}
