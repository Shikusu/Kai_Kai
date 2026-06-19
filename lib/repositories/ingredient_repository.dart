import '../db/database_helper.dart';
import '../models/ingredient.dart';

class IngredientRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<List<Ingredient>> getAll() async {
    final db = await dbHelper.database;
    final maps = await db.rawQuery('''
      SELECT ingredients.*, units.name AS unit_name
      FROM ingredients
      JOIN units ON ingredients.unit_id = units.id
      ORDER BY ingredients.name
    ''');
    return maps.map((m) => Ingredient.fromMap(m)).toList();
  }

  Future<int> insert(Ingredient ingredient) async {
    final db = await dbHelper.database;
    return await db.insert('ingredients', ingredient.toMap());
  }

  Future<int> update(Ingredient ingredient) async {
    final db = await dbHelper.database;
    return await db.update(
      'ingredients',
      ingredient.toMap(),
      where: 'id = ?',
      whereArgs: [ingredient.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return await db.delete('ingredients', where: 'id = ?', whereArgs: [id]);
  }
}
