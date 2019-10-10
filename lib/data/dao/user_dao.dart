import 'package:postplus_client/model/user.dart';

abstract class UserDao {
  Future<int> saveUser(User user);

  Future<int> deleteUsers();

  Future<bool> isLoggedIn();
}
