import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/game.dart';
import '../utils/app_toast.dart';
import 'game_card.dart';

class LibraryGameCard extends StatelessWidget {
  final Game game;
  final String activationCode;

  const LibraryGameCard({
    super.key,
    required this.game,
    required this.activationCode,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      color: AppColors.surface,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.purple.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 190,
            width: double.infinity,
            child: Image.asset(
              game.thumb,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: AppColors.purpleDark,
                child: const Icon(
                  Icons.sports_esports,
                  size: 56,
                  color: AppColors.purpleLight,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game.title,
                  style: textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  game.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _InfoChip(icon: Icons.tag, label: 'ID ${game.id}'),
                    _InfoChip(icon: Icons.storefront, label: game.store.name),
                    _InfoChip(
                      icon: Icons.star,
                      label: 'Metacritic ${game.metacriticScore}',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: Colors.white12),
                const SizedBox(height: 12),
                Text(
                  'Na biblioteca',
                  style: textTheme.titleSmall?.copyWith(
                    color: AppColors.purpleLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _LibraryDetail(
                  icon: Icons.vpn_key,
                  label: 'Código de ativação',
                  value: activationCode,
                  onCopy: () => _copyActivationCode(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _copyActivationCode(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: activationCode));
    if (!context.mounted) return;
    AppToast.show(context, 'Código copiado para a área de transferência');
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16, color: AppColors.purpleLight),
      label: Text(label),
      side: BorderSide(color: AppColors.purple.withValues(alpha: 0.3)),
      backgroundColor: AppColors.black,
      labelStyle: const TextStyle(color: Colors.white70, fontSize: 12),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _LibraryDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onCopy;

  const _LibraryDetail({
    required this.icon,
    required this.label,
    required this.value,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.purpleLight),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.white54)),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (onCopy != null)
          IconButton(
            onPressed: onCopy,
            icon: const Icon(Icons.copy),
            color: AppColors.purpleLight,
            tooltip: 'Copiar código de ativação',
          ),
      ],
    );
  }
}
