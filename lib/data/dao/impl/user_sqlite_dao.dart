import 'package:postplus_client/data/dao/user_dao.dart';
import 'package:postplus_client/model/user.dart';
import 'package:postplus_client/util/sqlite_database.dart';
import 'package:sqflite/sqflite.dart';

class UserSqliteDao implements UserDao {
  @override
  Future<int> saveUser(User user) async {
    SqliteDatabase db = new SqliteDatabase();
    Database conn = await db.open();

    int res = await conn.insert("User", user.toMap());

    var userList = await conn.query("User");
    print("=====> User List saveUser: ${userList.toString()}");

    return res;
  }

  @override
  Future<int> deleteUsers() async {
    SqliteDatabase db = new SqliteDatabase();
    Database conn = await db.open();

    int res = await conn.delete("User");

    var userList = await conn.query("User");
    print("=====> User List: ${userList.toString()}");

    return res;
  }

  @override
  Future<bool> isLoggedIn() async {
    SqliteDatabase db = new SqliteDatabase();
    Database conn = await db.open();

    var userList = await conn.query("User");

    print("=====> User List isLoggedIn: ${userList.toString()}");

    return userList.length > 0 ? true : false;
  }
}
