import 'package:sqflite/sqflite.dart';
import 'package:tillkhatam/core/app_database.dart';
import 'package:tillkhatam/src/data/model/user.dart';
import 'package:tillkhatam/src/data/repository/repository.dart';

class UserRepo extends BaseRepository<User> {
  @override
  Future<int?> create(User item) async {
    final db = await DatabaseHelper.getDB();
    var id = db.insert(
      DatabaseHelper.TABLE_USER,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  @override
  Future<void> delete(id) async {
    final db = await DatabaseHelper.getDB();
    await db.delete(
      DatabaseHelper.TABLE_USER,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<User> view(id) async {
    final db = await DatabaseHelper.getDB();
    final List<Map<String, Object?>> userMaps = await db.query(
      DatabaseHelper.TABLE_USER,
      where: 'id = ?',
      whereArgs: [id],
    );
    return userMaps.map((e) => User.fromMap(e)).toList()[0];
  }

  @override
  Future<List<User>> viewAll() async {
    final db = await DatabaseHelper.getDB();
    final List<Map<String, Object?>> userMaps = await db.query(
        DatabaseHelper.TABLE_USER,
        orderBy: DatabaseHelper.COLUMN_USER_ID);
    return userMaps.map((e) => User.fromMap(e)).toList();
  }

  @override
  Future<int> update(User item) async {
    final db = await DatabaseHelper.getDB();
    var id = db.update(DatabaseHelper.TABLE_USER, item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
        where: "${DatabaseHelper.COLUMN_USER_ID} = ?",
        whereArgs: [item.user_id.toString()]);
    return id;
  }

  Future<User?> getUser() async {
    final db = await DatabaseHelper.getDB();
    try {
      final List<Map<String, Object?>> userMaps = await db.query(
        DatabaseHelper.TABLE_USER,
      );
      return userMaps.map((e) => User.fromMap(e)).toList()[0];
    } catch (error) {
      return null;
    }
  }
}
