import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/jogo.dart';
import '../state/jogo_controller.dart';
import '../widgets/estado_vazio.dart';
import '../widgets/jogo_card.dart';
import 'detalhe_screen.dart';
import 'form_screen.dart';

class ListaScreen extends StatelessWidget {
  const ListaScreen({super.key, required this.controller});

  final JogoController controller;

  static const double _larguraMinimaGrade = 600;
  static const EdgeInsets _espacamento = EdgeInsets.fromLTRB(16, 16, 16, 96);

  Future<void> _abrirFormulario(BuildContext context, [Jogo? jogo]) async {
    final resultado = await Navigator.of(context).push<Jogo>(
      MaterialPageRoute<Jogo>(builder: (_) => FormScreen(jogo: jogo)),
    );
    if (resultado == null || !context.mounted) {
      return;
    }
    controller.salvar(resultado);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Jogo salvo')));
  }

  void _abrirDetalhe(BuildContext context, Jogo jogo) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => DetalheScreen(controller: controller, jogo: jogo),
      ),
    );
  }

  void _remover(BuildContext context, Jogo jogo) {
    controller.remover(jogo.id);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Jogo removido')));
  }

  Widget _construirCard(BuildContext context, Jogo jogo) {
    return JogoCard(
      jogo: jogo,
      onAbrir: () => _abrirDetalhe(context, jogo),
      onEditar: () => _abrirFormulario(context, jogo),
      onRemover: () => _remover(context, jogo),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Jogos')),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final jogos = controller.jogos;

          if (jogos.isEmpty) {
            return const EstadoVazio();
          }

          return LayoutBuilder(
            builder: (context, restricoes) {
              if (restricoes.maxWidth < _larguraMinimaGrade) {
                return ListView.separated(
                  padding: _espacamento,
                  itemCount: jogos.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, indice) =>
                      _construirCard(context, jogos[indice]),
                );
              }

              final escala = math.max(
                1.0,
                MediaQuery.textScalerOf(context).scale(1),
              );

              return GridView.builder(
                padding: _espacamento,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 480,
                  mainAxisExtent: 160 * escala,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: jogos.length,
                itemBuilder: (context, indice) =>
                    _construirCard(context, jogos[indice]),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'Adicionar novo jogo',
        icon: const Icon(Icons.add),
        label: const Text('Novo jogo'),
        onPressed: () => _abrirFormulario(context),
      ),
    );
  }
}
