import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String TABLE_USER = " TABLE_USER ";
  static const String TABLE_USER_READ = " TABLE_USER_READ ";
  static const String COLUMN_USER_ID = "user_id";
  static const String COLUMN_USER_NAME = "user_name";
  static const String COLUMN_USER_FINISH_DATE = "user_finish_date";
  static const String COLUMN_USER_CURRENTPAGE = "user_currentpage";
  static const String COLUMN_USER_ALLPAGE = "user_allpage";
  static const String COLUMN_USER_AUTODEC = "user_autodec";
  static const String COLUMN_USER_NOTIFY_DATE = "user_notify_date";
  static const String COLUMN_USER_STATUS = "user_status";
  static const String DATABASE_NAME = "IQURAN19";
  static const int DATABASE_VERSION = 2;
  static const int COLUMN_USER_COUNT = 8;
  static const String TABLE_USER_COLUMNS_DATATYPE =
      "($COLUMN_USER_ID INTEGER PRIMARY KEY,$COLUMN_USER_NAME text,$COLUMN_USER_FINISH_DATE text,$COLUMN_USER_AUTODEC INTEGER,$COLUMN_USER_CURRENTPAGE INTEGER,$COLUMN_USER_ALLPAGE INTEGER,$COLUMN_USER_NOTIFY_DATE text,$COLUMN_USER_STATUS text)";
  static const String TABLE_USER_READING_COLUMNS_DATATYPE =
      "(id INTEGER PRIMARY KEY, pages_read INTEGER, reading_date text)";

  static Future<Database> getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), '$DATABASE_NAME.db'),
      onUpgrade: (db, oldVersion, newVersion) {
        db.execute("DROP TABLE IF EXISTS $TABLE_USER");
        db.execute(
          'CREATE TABLE $TABLE_USER$TABLE_USER_COLUMNS_DATATYPE',
        );
        db.execute(
          'CREATE TABLE $TABLE_USER_READ$TABLE_USER_READING_COLUMNS_DATATYPE',
        );
      },
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE $TABLE_USER$TABLE_USER_COLUMNS_DATATYPE',
        );
        db.execute(
          'CREATE TABLE $TABLE_USER_READ$TABLE_USER_READING_COLUMNS_DATATYPE',
        );
      },
      version: DATABASE_VERSION,
    );
  }
}
