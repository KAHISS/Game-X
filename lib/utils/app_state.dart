import 'package:flutter/widgets.dart';

import '../models/game.dart';
import '../models/library_game.dart';
import '../models/usuario.dart';
import 'autenticador.dart';

enum GamesViewMode { grid, list }

class AppState extends ChangeNotifier {
  int _currentPageIndex = 0;
  GamesViewMode _gamesViewMode = GamesViewMode.list;
  Usuario? _currentUser;
  final List<Game> _cart = [];
  final List<LibraryGame> _initialLibraryGames = [];
  final List<LibraryGame> _purchasedGames = [];
  bool _libraryInitialized = false;

  int get currentPageIndex => _currentPageIndex;
  GamesViewMode get gamesViewMode => _gamesViewMode;
  Usuario? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  List<Game> get cart => List.unmodifiable(_cart);
  List<LibraryGame> get libraryGames {
    final gamesById = <String, LibraryGame>{
      for (final entry in _initialLibraryGames) entry.game.id: entry,
      for (final entry in _purchasedGames) entry.game.id: entry,
    };
    return List.unmodifiable(gamesById.values);
  }

  bool ownsGame(String gameId) =>
      libraryGames.any((entry) => entry.game.id == gameId);

  void initializeLibrary(List<LibraryGame> games) {
    if (_libraryInitialized) return;
    _initialLibraryGames.addAll(games);
    _libraryInitialized = true;
    notifyListeners();
  }

  bool addToCart(Game game) {
    if (_cart.any((item) => item.id == game.id)) return false;
    _cart.add(game);
    notifyListeners();
    return true;
  }

  void removeFromCart(Game game) {
    _cart.removeWhere((item) => item.id == game.id);
    notifyListeners();
  }

  void clearCart() {
    if (_cart.isEmpty) return;
    _cart.clear();
    notifyListeners();
  }

  int completePurchase() {
    var addedCount = 0;
    for (final game in _cart) {
      final alreadyOwned = _initialLibraryGames.any(
            (entry) => entry.game.id == game.id,
          ) ||
          _purchasedGames.any((entry) => entry.game.id == game.id);
      if (alreadyOwned) continue;

      final uniquePart = DateTime.now().microsecondsSinceEpoch
          .toRadixString(36)
          .toUpperCase();
      _purchasedGames.add(
        LibraryGame(
          game: game,
          activationCode: 'GAME-${game.id}-$uniquePart',
        ),
      );
      addedCount++;
    }

    _cart.clear();
    notifyListeners();
    return addedCount;
  }

  Future<bool> login() async {
    final user = await Autenticador.login();
    if (user == null) return false;
    _currentUser = user;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    await Autenticador.logout();
    _currentUser = null;
    _currentPageIndex = 0;
    notifyListeners();
  }

  void setCurrentPage(int index) {
    if (index == _currentPageIndex) return;
    _currentPageIndex = index;
    notifyListeners();
  }

  void setGamesViewMode(GamesViewMode mode) {
    if (mode == _gamesViewMode) return;
    _gamesViewMode = mode;
    notifyListeners();
  }
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope não encontrado na árvore de widgets.');
    return scope!.notifier!;
  }
}
