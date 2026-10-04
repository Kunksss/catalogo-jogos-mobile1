import 'package:flutter/material.dart';

class EstadoVazio extends StatelessWidget {
  const EstadoVazio({
    super.key,
    this.mensagem = 'Nenhum jogo cadastrado',
    this.dica = 'Toque em "Novo jogo" para adicionar o primeiro.',
  });

  final String mensagem;
  final String dica;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Semantics(
      container: true,
      label: '$mensagem. $dica',
      child: ExcludeSemantics(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.sports_esports_outlined,
                  size: 72,
                  color: tema.colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  mensagem,
                  textAlign: TextAlign.center,
                  style: tema.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  dica,
                  textAlign: TextAlign.center,
                  style: tema.textTheme.bodyMedium?.copyWith(
                    color: tema.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
