import 'package:flutter/material.dart';

import '../models/jogo.dart';
import 'status_chip.dart';

class JogoCard extends StatelessWidget {
  const JogoCard({
    super.key,
    required this.jogo,
    required this.onAbrir,
    required this.onEditar,
    required this.onRemover,
  });

  final Jogo jogo;
  final VoidCallback onAbrir;
  final VoidCallback onEditar;
  final VoidCallback onRemover;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Semantics(
      container: true,
      label: '${jogo.titulo}, ${jogo.plataforma}, ${jogo.status.rotulo}',
      hint: 'Toque para ver os detalhes',
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onAbrir,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
            child: Row(
              children: [
                Expanded(
                  child: ExcludeSemantics(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          jogo.titulo,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: tema.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          jogo.plataforma,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: tema.textTheme.bodyMedium?.copyWith(
                            color: tema.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        StatusChip(status: jogo.status),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Editar ${jogo.titulo}',
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: onEditar,
                ),
                IconButton(
                  tooltip: 'Remover ${jogo.titulo}',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: onRemover,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
