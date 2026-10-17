class GameStore {
  final String name;
  final String icon;

  const GameStore({required this.name, required this.icon});

  factory GameStore.fromJson(Map<String, dynamic> json) =>
      GameStore(name: json['name'] as String, icon: json['icon'] as String);
}

class Game {
  final String id;
  final String title;
  final String description;
  final int metacriticScore;
  final GameStore store;
  final double salePrice;
  final double normalPrice;
  final double savings;
  final String thumb;

  const Game({
    required this.id,
    required this.title,
    required this.description,
    required this.metacriticScore,
    required this.store,
    required this.salePrice,
    required this.normalPrice,
    required this.savings,
    required this.thumb,
  });

  /// Os preços e o desconto vêm como String no JSON, então convertemos aqui.
  factory Game.fromJson(Map<String, dynamic> json) => Game(
    id: json['gameID'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    metacriticScore: json['metacriticScore'] as int,
    store: GameStore.fromJson(json['store'] as Map<String, dynamic>),
    salePrice: double.parse(json['salePrice'] as String),
    normalPrice: double.parse(json['normalPrice'] as String),
    savings: double.parse(json['savings'] as String),
    thumb: json['thumb'] as String,
  );
}
