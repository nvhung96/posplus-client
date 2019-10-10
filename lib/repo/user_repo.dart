import 'package:postplus_client/model/user.dart';

abstract class UserRepo {
  Future<int> saveUser(User user);

  Future<int> deleteUsers();

  Future<bool> isLoggedIn();

  Future<String> getToken();
}
