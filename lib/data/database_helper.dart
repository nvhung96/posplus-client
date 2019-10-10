import 'dart:async';
import 'dart:io' as io;

import 'package:postplus_client/model/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;

    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "main.db");

    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // TODO: When creating the db, create the table
    await db.execute(
        "CREATE TABLE User(id INTEGER PRIMARY KEY, username TEXT, password TEXT)");
    print("Created tables");
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.insert("User", user.toMap());

    var userList = await dbClient.query("User");
    print("=====> User List saveUser: ${userList.toString()}");

    return res;
  }

  Future<int> deleteUsers() async {
    var dbClient = await db;
    int res = await dbClient.delete("User");

    var userList = await dbClient.query("User");
    print("=====> User List: ${userList.toString()}");

    return res;
  }

  Future<bool> isLoggedIn() async {
    var dbClient = await db;
    var userList = await dbClient.query("User");

    print("=====> User List isLoggedIn: ${userList.toString()}");

    return userList.length > 0 ? true : false;
  }
}
