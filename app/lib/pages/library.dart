import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../partials/game_card.dart';
import '../models/game.dart';
import '../models/library_game.dart';
import '../partials/library_game_card.dart';
import '../partials/login_toggle_button.dart';
import '../utils/app_state.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late final Future<_LibraryData> _library = _loadLibrary();

  Future<_LibraryData> _loadLibrary() async {
    final appState = AppStateScope.of(context);
    final loggedInUser = appState.currentUser;
    if (loggedInUser == null) {
      throw StateError('É necessário estar autenticado para carregar a conta.');
    }

    final files = await Future.wait([
      rootBundle.loadString('resources/jsons/users.json'),
      rootBundle.loadString('resources/jsons/games.json'),
    ]);
    final usersJson = jsonDecode(files[0]) as Map<String, dynamic>;
    final users = usersJson['usuarios'] as List<dynamic>? ??
        [usersJson['usuario']];
    final userEmail = loggedInUser.email.trim().toLowerCase();
    final matchingUser = users
        .whereType<Map<String, dynamic>>()
        .where(
          (user) =>
              (user['email'] as String).trim().toLowerCase() == userEmail,
        );
    if (matchingUser.isEmpty) {
      throw StateError(
        'Não há usuário cadastrado com o e-mail ${loggedInUser.email}.',
      );
    }
    final userJson = matchingUser.first;

    final gamesJson = jsonDecode(files[1]) as List<dynamic>;
    final gamesById = {
      for (final item in gamesJson)
        (item as Map<String, dynamic>)['gameID'] as String: Game.fromJson(item),
    };
    Game gameFromAccountEntry(dynamic item, String collectionName) {
      final entry = item as Map<String, dynamic>;
      final gameId = entry['gameID'] as String;
      final game = gamesById[gameId];
      if (game == null) {
        throw FormatException(
          'O jogo com ID $gameId do $collectionName não existe em games.json.',
        );
      }
      return game;
    }

    final libraryGames = (userJson['biblioteca'] as List<dynamic>).map((item) {
      final game = gameFromAccountEntry(item, 'biblioteca');
      final entry = item as Map<String, dynamic>;
      return LibraryGame(
        game: game,
        activationCode: entry['codigoAtivacao'] as String,
      );
    }).toList();
    final cartGames = (userJson['carrinho'] as List<dynamic>)
        .map((item) => gameFromAccountEntry(item, 'carrinho'))
        .toList();
    final initialized = appState.initializeAccountData(
        email: userEmail,
        libraryGames: libraryGames,
        cartGames: cartGames,
      );
    if (!initialized) {
      throw StateError(
        'O usuário autenticado mudou antes do carregamento da conta terminar.',
      );
    }

    return _LibraryData(user: userJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        foregroundColor: Colors.white,
        title: const Text('Biblioteca'),
        actions: const [LoginToggleButton()],
      ),
      body: FutureBuilder<_LibraryData>(
        future: _library,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.purple),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar a biblioteca:\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
            );
          }

          final library = snapshot.data!;
          final appState = AppStateScope.of(context);
          final user = appState.currentUser;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (user != null)
                Card(
                  color: AppColors.surface,
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.purpleDark,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      user.nome,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(user.email),
                  ),
                ),
              if (user == null)
                Card(
                  color: AppColors.surface,
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.purpleDark,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      library.user['nome'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(library.user['email'] as String),
                  ),
                ),
              const SizedBox(height: 8),
              for (final entry in appState.libraryGames)
                LibraryGameCard(
                  game: entry.game,
                  activationCode: entry.activationCode,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _LibraryData {
  final Map<String, dynamic> user;

  const _LibraryData({required this.user});
}
