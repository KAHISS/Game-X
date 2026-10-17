import 'package:flutter/material.dart';

import 'pages/games.dart';
import 'pages/library.dart';
import 'pages/cart.dart';
import 'partials/game_card.dart';
import 'utils/app_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppState _appState = AppState();

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      state: _appState,
      child: MaterialApp(
        title: 'Game X',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.black,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.purple,
            brightness: Brightness.dark,
            surface: AppColors.black,
          ),
        ),
        home: const _AppShell(),
      ),
    );
  }
}

class _AppShell extends StatelessWidget {
  const _AppShell();

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

    return Scaffold(
      body: IndexedStack(
        index: appState.currentPageIndex,
        children: appState.isLoggedIn
            ? const [GamesPage(), LibraryPage(), CartPage()]
            : const [GamesPage()],
      ),
      bottomNavigationBar: appState.isLoggedIn
          ? NavigationBar(
              selectedIndex: appState.currentPageIndex,
              onDestinationSelected: appState.setCurrentPage,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.sports_esports_outlined),
                  selectedIcon: Icon(Icons.sports_esports),
                  label: 'Jogos',
                ),
                NavigationDestination(
                  icon: Icon(Icons.video_library_outlined),
                  selectedIcon: Icon(Icons.video_library),
                  label: 'Biblioteca',
                ),
                NavigationDestination(
                  icon: Icon(Icons.shopping_cart_outlined),
                  selectedIcon: Icon(Icons.shopping_cart),
                  label: 'Carrinho',
                ),
              ],
            )
          : null,
    );
  }
}
