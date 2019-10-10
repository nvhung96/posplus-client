import 'package:postplus_client/data/rest_response.dart';

abstract class AuthenRepo {
  Future<RestResponse> login(String username, String password);
}
