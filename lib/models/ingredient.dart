class Ingredient {
  final int? id;
  final String name;
  final String category;
  final double price;
  final int unitId;

  final String? unitName;

  Ingredient({
    this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.unitId,
    this.unitName,
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'name': name,
    'price': price,
    'category': category,
    'unit_id': unitId,
  };

  factory Ingredient.fromMap(Map<String, dynamic> map) => Ingredient(
    id: map['id'] as int?,
    name: map['name'] as String,
    category: map['category'] as String,
    price: map['price'] as double,
    unitId: map['unit_id'] as int,
    unitName: map['unit_name'] as String?,
  );

  Ingredient copyWith({
    int? id,
    String? name,
    String? category,
    double? price,
    int? unitId,
    String? unitName,
  }) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      unitId: unitId ?? this.unitId,
      unitName: unitName ?? this.unitName,
    );
  }
}
