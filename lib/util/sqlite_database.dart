import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDatabase {
  static final SqliteDatabase _instance = new SqliteDatabase.internal();

  factory SqliteDatabase() => _instance;

  SqliteDatabase.internal();

  static Database _db;

  Future<Database> open() async {
    if (_db != null) return _db;

    _db = await initDb();
    return _db;
  }

  initDb() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'main.db');

    var theDb = await openDatabase(path,
        version: 3, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return theDb;
  }

  // TODO: Hàm _onCreate đã được định nghĩa các tham số vào với biến onCreate
  void _onCreate(Database db, int version) async {
    // TODO: When creating the db, create the table
    await db.execute(
        "CREATE TABLE User(id INTEGER PRIMARY KEY, username TEXT, password TEXT)");
    print("Created tables");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // TODO: When creating the db, create the table
    await db.execute("DROP TABLE IF EXISTS User");
    await db.execute(
        "CREATE TABLE User(id INTEGER PRIMARY KEY, username TEXT, password TEXT, token TEXT, email TEXT, display_name TEXT, avatar TEXT)");
    print("Upgrade tables");
  }
}
