import 'package:flutter/material.dart';

import '../models/jogo.dart';
import '../state/jogo_controller.dart';
import '../widgets/status_chip.dart';
import 'form_screen.dart';

class DetalheScreen extends StatefulWidget {
  const DetalheScreen({
    super.key,
    required this.controller,
    required this.jogo,
  });

  final JogoController controller;
  final Jogo jogo;

  @override
  State<DetalheScreen> createState() => _DetalheScreenState();
}

class _DetalheScreenState extends State<DetalheScreen> {
  late Jogo _atual = widget.jogo;

  Jogo _buscarAtual() {
    for (final item in widget.controller.jogos) {
      if (item.id == widget.jogo.id) {
        return item;
      }
    }
    return _atual;
  }

  Future<void> _editar(BuildContext context) async {
    final resultado = await Navigator.of(context).push<Jogo>(
      MaterialPageRoute<Jogo>(builder: (_) => FormScreen(jogo: _atual)),
    );
    if (resultado == null || !context.mounted) {
      return;
    }
    widget.controller.salvar(resultado);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Jogo salvo')));
  }

  void _remover(BuildContext context) {
    final mensagens = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    widget.controller.remover(_atual.id);
    mensagens
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Jogo removido')));
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        _atual = _buscarAtual();
        final jogo = _atual;
        final semDescricao = jogo.descricao.isEmpty;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detalhes'),
            actions: [
              IconButton(
                tooltip: 'Editar jogo',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => _editar(context),
              ),
              IconButton(
                tooltip: 'Remover jogo',
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _remover(context),
              ),
            ],
          ),
          body: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(
                        header: true,
                        child: Text(
                          jogo.titulo,
                          style: tema.textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.videogame_asset_outlined,
                            size: 20,
                            color: tema.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              jogo.plataforma,
                              style: tema.textTheme.bodyLarge?.copyWith(
                                color: tema.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      StatusChip(status: jogo.status),
                      const SizedBox(height: 24),
                      Semantics(
                        header: true,
                        child: Text(
                          'Descrição',
                          style: tema.textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        semDescricao ? 'Sem descrição' : jogo.descricao,
                        style: tema.textTheme.bodyLarge?.copyWith(
                          color: semDescricao
                              ? tema.colorScheme.onSurfaceVariant
                              : null,
                          fontStyle: semDescricao
                              ? FontStyle.italic
                              : FontStyle.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
