import 'package:flutter/material.dart';

import '../models/jogo.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final StatusJogo status;

  IconData get _icone => switch (status) {
    StatusJogo.queroJogar => Icons.bookmark_border,
    StatusJogo.jogando => Icons.play_circle_outline,
    StatusJogo.zerado => Icons.emoji_events_outlined,
    StatusJogo.abandonado => Icons.pause_circle_outline,
  };

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(_icone, size: 18, color: tema.colorScheme.primary),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            status.rotulo,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: tema.textTheme.labelLarge?.copyWith(
              color: tema.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
