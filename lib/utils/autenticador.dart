import '../models/usuario.dart';

class Autenticador {
  static Future<Usuario?> login() async {
    return Usuario('Mario da Silva', 'mariosilva@gmail.com');
  }

  static Future<Usuario?> recuperarUsuario() async {
    return Usuario('Mario da Silva', 'mariosilva@gmail.com');
  }

  static Future<void> logout() async {}
}
