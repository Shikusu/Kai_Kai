import '../db/database_helper.dart';
import '../models/unit.dart';

class UnitRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<List<Unit>> getAll() async {
    final db = await dbHelper.database;
    final maps = await db.query('units', orderBy: 'name');
    return maps.map((m) => Unit.fromMap(m)).toList();
  }

  Future<Unit> getOrCreate(String name) async {
    final db = await dbHelper.database;
    final trimmed = name.trim();

    final existing = await db.query(
      'units',
      where: 'LOWER(name) = ?',
      whereArgs: [trimmed.toLowerCase()],
      limit: 1,
    );
    if (existing.isNotEmpty) {
      return Unit.fromMap(existing.first);
    }

    final id = await db.insert('units', {'name': trimmed});
    return Unit(id: id, name: trimmed);
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return await db.delete('units', where: 'id = ?', whereArgs: [id]);
  }
}
