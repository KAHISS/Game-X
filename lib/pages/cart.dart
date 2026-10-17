import 'package:flutter/material.dart';

import '../partials/cart_game_card.dart';
import '../partials/game_card.dart';
import '../utils/app_state.dart';
import '../utils/app_toast.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  String _money(double value) =>
      'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final cart = appState.cart;
    final regularTotal = cart.fold<double>(
      0,
      (total, game) => total + game.normalPrice,
    );
    final purchaseTotal = cart.fold<double>(
      0,
      (total, game) => total + game.salePrice,
    );
    final savings = regularTotal - purchaseTotal;

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        foregroundColor: Colors.white,
        title: const Text('Carrinho'),
      ),
      body: cart.isEmpty
          ? const Center(
              child: Text(
                'Seu carrinho está vazio',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final game = cart[index];
                      return CartGameCard(
                        game: game,
                        onRemove: () => appState.removeFromCart(game),
                      );
                    },
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Card(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    color: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: AppColors.purple.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Resumo da compra',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 12),
                          _SummaryRow(
                            label: 'Jogos (${cart.length})',
                            value: _money(regularTotal),
                          ),
                          const SizedBox(height: 6),
                          _SummaryRow(
                            label: 'Descontos',
                            value: '- ${_money(savings)}',
                            valueColor: AppColors.purpleLight,
                          ),
                          const Divider(height: 20, color: Colors.white12),
                          _SummaryRow(
                            label: 'Total',
                            value: _money(purchaseTotal),
                            emphasize: true,
                          ),
                          const SizedBox(height: 12),
                          FilledButton.icon(
                            onPressed: () {
                              final purchasedCount = appState
                                  .completePurchase();
                              AppToast.show(
                                context,
                                purchasedCount > 0
                                    ? 'Compra finalizada; jogos adicionados à biblioteca'
                                    : 'Os jogos do carrinho já estão na biblioteca',
                              );
                            },
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('Finalizar compra'),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.purple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final bool emphasize;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor = Colors.white70,
    this.emphasize = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: emphasize ? Colors.white : valueColor,
      fontSize: emphasize ? 18 : 14,
      fontWeight: emphasize ? FontWeight.bold : FontWeight.normal,
    );

    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text(value, style: style),
      ],
    );
  }
}
