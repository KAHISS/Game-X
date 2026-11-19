import 'package:flutter/material.dart';

import '../utils/app_state.dart';
import '../utils/app_toast.dart';

class LoginToggleButton extends StatelessWidget {
  const LoginToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final isLoggedIn = appState.isLoggedIn;

    return IconButton(
      onPressed: () async {
        final messenger = ScaffoldMessenger.of(context);
        try {
          if (isLoggedIn) {
            await appState.logout();
            if (!context.mounted) return;
            AppToast.show(context, 'Usuário deslogado com sucesso');
          } else {
            final loggedIn = await appState.login();
            if (!context.mounted) return;
            if (loggedIn) {
              AppToast.show(context, 'Usuário logado com sucesso');
            } else {
              messenger.showSnackBar(
                const SnackBar(content: Text('Não foi possível fazer login')),
              );
            }
          }
        } catch (error) {
          if (!context.mounted) return;
          messenger.showSnackBar(
            SnackBar(content: Text('Erro na autenticação: $error')),
          );
        }
      },
      icon: Icon(isLoggedIn ? Icons.logout : Icons.login),
      tooltip: isLoggedIn ? 'Sair' : 'Entrar automaticamente',
    );
  }
}
