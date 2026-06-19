class Unit {
  final int? id;
  final String name;

  Unit({this.id, required this.name});

  @override
  bool operator ==(Object other) => other is Unit && other.id == id;

  @override
  int get hashCode => id.hashCode;
  Map<String, dynamic> toMap() => {if (id != null) 'id': id, 'name': name};

  factory Unit.fromMap(Map<String, dynamic> map) =>
      Unit(id: map['id'] as int?, name: map['name'] as String);
}
