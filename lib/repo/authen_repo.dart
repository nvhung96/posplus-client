import 'package:postplus_client/data/rest_response.dart';
import 'package:postplus_client/model/user.dart';

abstract class AuthenRepo {
  Future<RestResponse> login(String username, String password);

  Future<User> me(String token);
}
