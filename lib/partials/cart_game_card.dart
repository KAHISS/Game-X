import 'package:flutter/material.dart';

import '../models/game.dart';
import 'game_card.dart';

class CartGameCard extends StatelessWidget {
  final Game game;
  final VoidCallback onRemove;

  const CartGameCard({
    super.key,
    required this.game,
    required this.onRemove,
  });

  String _money(double value) =>
      'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: AppColors.purple.withValues(alpha: 0.3)),
      ),
      child: SizedBox(
        height: 116,
        child: Row(
          children: [
            SizedBox(
              width: 120,
              height: double.infinity,
              child: Image.asset(
                game.thumb,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: AppColors.purpleDark,
                  child: const Icon(
                    Icons.sports_esports,
                    size: 40,
                    color: AppColors.purpleLight,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          game.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          _money(game.salePrice),
                          style: const TextStyle(
                            color: AppColors.purpleLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            _money(game.normalPrice),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white38,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.delete_outline),
              color: AppColors.purpleLight,
              tooltip: 'Remover do carrinho',
            ),
          ],
        ),
      ),
    );
  }
}
