class BazarItem {
  final int? id;
  final String name;
  final String quantity;

  /// Price paid the last time this item was bought (0 = never bought).
  final int lastPrice;

  /// The price before [lastPrice], to show the change.
  final int previousPrice;

  /// Price entered for the current trip; null until the item is ticked.
  final int? currentPrice;
  final DateTime updatedAt;

  const BazarItem({
    this.id,
    required this.name,
    this.quantity = '',
    this.lastPrice = 0,
    this.previousPrice = 0,
    this.currentPrice,
    required this.updatedAt,
  });

  bool get isBought => currentPrice != null;

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'name': name,
    'quantity': quantity,
    'last_price': lastPrice,
    'previous_price': previousPrice,
    'current_price': currentPrice,
    'updated_at': updatedAt.toIso8601String(),
  };

  factory BazarItem.fromMap(Map<String, dynamic> map) => BazarItem(
    id: map['id'] as int?,
    name: map['name'] as String,
    quantity: map['quantity'] as String? ?? '',
    lastPrice: map['last_price'] as int? ?? 0,
    previousPrice: map['previous_price'] as int? ?? 0,
    currentPrice: map['current_price'] as int?,
    updatedAt: DateTime.parse(map['updated_at'] as String),
  );
}
