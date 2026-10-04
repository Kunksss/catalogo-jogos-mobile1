import 'package:flutter/foundation.dart';

import '../models/jogo.dart';

class JogoController extends ChangeNotifier {
  JogoController({List<Jogo> iniciais = const []}) : _jogos = List.of(iniciais);

  final List<Jogo> _jogos;

  List<Jogo> get jogos => List.unmodifiable(_jogos);

  void salvar(Jogo jogo) {
    final indice = _jogos.indexWhere((item) => item.id == jogo.id);
    if (indice >= 0) {
      _jogos[indice] = jogo;
    } else {
      _jogos.add(jogo);
    }
    notifyListeners();
  }

  void remover(String id) {
    _jogos.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
