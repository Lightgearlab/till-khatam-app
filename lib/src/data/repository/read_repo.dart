import 'package:sqflite/sqflite.dart';
import 'package:tillkhatam/core/app_database.dart';
import 'package:tillkhatam/src/data/model/read.dart';
import 'package:tillkhatam/src/data/repository/repository.dart';

class ReadRepo extends BaseRepository<Read> {
  @override
  Future<int?> create(Read item) async {
    final db = await DatabaseHelper.getDB();
    return await db.insert(
      DatabaseHelper.TABLE_USER_READ,
      item.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> delete(id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Read> view(id) {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  Future<List<Read>> viewAll() async {
    final db = await DatabaseHelper.getDB();
    try {
      final List<Map<String, Object?>> maps = await db.query(
        DatabaseHelper.TABLE_USER_READ,
      );
      if (maps.isEmpty) {
        return [];
      }

      return List.generate(maps.length, (index) => Read.fromJson(maps[index]));
    } catch (error) {
      return [];
    }
  }

  Future<List<Read>> viewAllToday() async {
    final db = await DatabaseHelper.getDB();
    String todayDate = DateTime.now().toIso8601String();
    try {
      final List<Map<String, Object?>> maps = await db.query(
          DatabaseHelper.TABLE_USER_READ,
          where: "strftime('%w',DATE(reading_date)) = strftime('%w',DATE(?))",
          whereArgs: [todayDate]);
      if (maps.isEmpty) {
        return [];
      }

      return List.generate(maps.length, (index) => Read.fromJson(maps[index]));
    } catch (error) {
      return [];
    }
  }

  @override
  Future<Read> update(Read item) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
