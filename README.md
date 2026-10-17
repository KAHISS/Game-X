# Game X

Aplicativo móvel de loja de jogos digitais, desenvolvido em **Flutter/Dart** como front-end da **Avaliação I** da disciplina de **Programação Móvel** (IFBA, campus Vitória da Conquista).

O app simula a vitrine de uma loja de jogos: o visitante navega pelo catálogo e, ao entrar com a conta, pode comprar jogos, acompanhar o carrinho e consultar sua biblioteca com os códigos de ativação.

## Funcionalidades

**Sem login (modo visitante)**
- Visualização do catálogo de jogos, com capa, descrição, nota no Metacritic, loja de origem, preço promocional, preço normal e desconto.
- Alternância entre exibição em **grade** e em **lista**.

**Com login**
- Botão **Comprar** em cada jogo, que adiciona ao carrinho (jogos já possuídos aparecem como "na biblioteca").
- **Carrinho** com remoção de itens e resumo da compra (subtotal, descontos e total).
- **Finalizar compra**, que move os jogos para a biblioteca e gera um código de ativação para cada um.
- **Biblioteca** com os jogos do usuário e seus códigos de ativação.
- **Logoff**, que volta ao modo visitante.

## Login (mockado)

Conforme permitido no descritivo da avaliação, a autenticação é simulada. O botão de login na barra superior da tela de Jogos autentica automaticamente o usuário fictício abaixo, definido em `lib/utils/autenticador.dart`:

| Nome | E-mail |
|---|---|
| Mario da Silva | mariosilva@gmail.com |

O botão de saída (no mesmo lugar) faz o logoff.

## Dados (JSON estático)

Os dados são lidos de arquivos JSON locais, carregados com `rootBundle`:

- `resources/jsons/games.json`: catálogo de jogos.
- `resources/jsons/library.json`: biblioteca inicial do usuário (IDs dos jogos e códigos de ativação).

As imagens (capas e logos das lojas) ficam em `resources/images/`.

## Estrutura do projeto

```
lib/
├── main.dart              # entrada do app, tema e navegação
├── models/                # Game, LibraryGame, Usuario
├── pages/                 # telas: games, library, cart
├── partials/              # widgets reutilizáveis (cards, botão de login)
└── utils/                 # estado global, autenticador e toast
resources/
├── jsons/                 # games.json e library.json
└── images/                # capas e logos
```

O estado global (usuário logado, carrinho, biblioteca e modo de exibição) é gerenciado por uma classe `AppState` (`ChangeNotifier`) exposta por um `InheritedNotifier`, sem pacotes externos.

## Como rodar

### Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado (Dart SDK `^3.13.1`, conforme o `pubspec.yaml`).
- Um emulador Android (Android SDK) ou um celular com depuração USB ativada.

Para conferir se o ambiente está pronto:

```bash
flutter doctor
```

### Passo a passo

1. Clone o repositório e entre na pasta:

   ```bash
   git clone <URL-DO-REPOSITORIO>
   cd kahiss-game-x
   ```

2. Instale as dependências:

   ```bash
   flutter pub get
   ```

3. Inicie um emulador Android (ou conecte um dispositivo) e confira se ele aparece:

   ```bash
   flutter devices
   ```

4. Execute o app:

   ```bash
   flutter run
   ```

### Rodar em outra plataforma (opcional)

O projeto também tem suporte para web e desktop:

```bash
flutter run -d chrome   # navegador
flutter run -d linux    # desktop Linux
```

## Roteiro de teste rápido

1. Abra o app: a tela de Jogos aparece em modo visitante, sem barra de navegação.
2. Alterne entre **Grade** e **Lista**.
3. Toque no ícone de login no canto superior direito: aparecem as abas **Jogos**, **Biblioteca** e **Carrinho**.
4. Adicione um jogo ao carrinho, abra **Carrinho** e toque em **Finalizar compra**.
5. Abra **Biblioteca** e confira o jogo comprado com seu código de ativação.
6. Toque no ícone de sair: o app volta ao modo visitante.

## Tecnologias

- Flutter (Material 3, tema escuro)
- Dart