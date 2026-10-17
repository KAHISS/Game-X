import 'package:flutter/material.dart';

import '../models/game.dart';

/// Paleta roxo e preto usada no app.
class AppColors {
  AppColors._();

  static const black = Color(0xFF0A0A0F);
  static const surface = Color(0xFF15111F);
  static const purple = Color(0xFF8B3DFF);
  static const purpleLight = Color(0xFFB794FF);
  static const purpleDark = Color(0xFF4A1D96);
}

/// Card de produto (jogo) reutilizável.
class GameCard extends StatelessWidget {
  final Game game;
  final VoidCallback? onTap;
  final VoidCallback? onBuy;
  final bool isInLibrary;

  const GameCard({
    super.key,
    required this.game,
    this.onTap,
    this.onBuy,
    this.isInLibrary = false,
  });

  String _money(double value) =>
      'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      color: AppColors.surface,
      elevation: 6,
      shadowColor: AppColors.purple.withValues(alpha: 0.35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.purple.withValues(alpha: 0.35)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Thumb(game: game),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      game.store.name,
                      style: textTheme.labelMedium?.copyWith(
                        color: AppColors.purpleLight,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      game.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _money(game.normalPrice),
                                style: textTheme.bodySmall?.copyWith(
                                  color: Colors.white38,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Text(
                                _money(game.salePrice),
                                style: textTheme.titleMedium?.copyWith(
                                  color: AppColors.purpleLight,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isInLibrary)
                          const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: AppColors.purpleLight,
                                size: 20,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Na biblioteca',
                                style: TextStyle(
                                  color: AppColors.purpleLight,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        else if (onBuy != null)
                          IconButton.filled(
                            onPressed: onBuy,
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.purple,
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.add_shopping_cart),
                            tooltip: 'Adicionar ao carrinho',
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  final Game game;

  const _Thumb({required this.game});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4.5 / 3,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // As imagens do mock ainda não existem no projeto, então usamos um
          // placeholder roxo quando o asset não é encontrado.
          Image.asset(
            game.thumb,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.purpleDark, AppColors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(
                Icons.sports_esports,
                size: 48,
                color: AppColors.purpleLight,
              ),
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: _Badge(
              text: '-${game.savings.round()}%',
              background: AppColors.purple,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: _Badge(
              text: 'MC ${game.metacriticScore}',
              background: Colors.black87,
              border: AppColors.purpleLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color background;
  final Color? border;

  const _Badge({required this.text, required this.background, this.border});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
        border: border == null ? null : Border.all(color: border!),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
