import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/game.dart';
import '../partials/game_card.dart';
import '../partials/login_toggle_button.dart';
import '../utils/app_state.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({super.key});

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  late final Future<List<Game>> _games = _loadGames();

  Future<List<Game>> _loadGames() async {
    final raw = await rootBundle.loadString('resources/jsons/games.json');
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((item) => Game.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sports_esports, color: AppColors.purple),
            SizedBox(width: 8),
            Text('Game X', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: const [LoginToggleButton()],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            height: 2,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.purpleDark,
                  AppColors.purple,
                  AppColors.purpleDark,
                ],
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Game>>(
        future: _games,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.purple),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar os jogos:\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
            );
          }

          final games = snapshot.data!;
          final appState = AppStateScope.of(context);
          return Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: SegmentedButton<GamesViewMode>(
                    segments: const [
                      ButtonSegment(
                        value: GamesViewMode.grid,
                        icon: Icon(Icons.grid_view),
                        label: Text('Grade'),
                      ),
                      ButtonSegment(
                        value: GamesViewMode.list,
                        icon: Icon(Icons.view_list),
                        label: Text('Lista'),
                      ),
                    ],
                    selected: {appState.gamesViewMode},
                    onSelectionChanged: (selection) =>
                        appState.setGamesViewMode(selection.first),
                  ),
                ),
              ),
              Expanded(
                child: appState.gamesViewMode == GamesViewMode.grid
                    ? GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 320,
                              mainAxisExtent: 370,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        itemCount: games.length,
                        itemBuilder: (context, index) =>
                            _buildGameCard(context, games[index]),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: games.length,
                        itemBuilder: (context, index) => SizedBox(
                          height: 430,
                          child: _buildGameCard(context, games[index]),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, Game game) {
    final appState = AppStateScope.of(context);
    return GameCard(
      game: game,
      isInLibrary: appState.isLoggedIn && appState.ownsGame(game.id),
      onBuy: appState.isLoggedIn && !appState.ownsGame(game.id)
          ? () {
              final added = appState.addToCart(game);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.purple,
                  content: Text(
                    added
                        ? '${game.title} adicionado ao carrinho'
                        : '${game.title} já está no carrinho',
                  ),
                ),
              );
            }
          : null,
    );
  }
}
