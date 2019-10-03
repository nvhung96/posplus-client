import 'dart:async';

import 'package:postplus_client/data/rest_response.dart';
import 'package:postplus_client/models/user.dart';
import 'package:postplus_client/utils/network_util.dart';

class RestDatasource {
  NetworkUtil _networkUtil = new NetworkUtil();
  static final BASE_URL = "https://demo7351156.mockable.io";
//  static final LOGIN_URL = BASE_URL + "/login_error";
  static final LOGIN_URL = BASE_URL + "/login";
  static final _API_KEY = "somerandomkey";

  Future<User> login(String username, String password) async {
    return _networkUtil.post(LOGIN_URL, body: {
      "token": _API_KEY,
      "username": username,
      "password": password,
    }).then((dynamic res) {
      print("=====> Login Result: " + res.toString());

      if (res["error"]) throw new Exception(res["error_msg"]);

      return new User.map(res["user"]);
    });
  }

  Future<RestResponse> login2(String username, String password) async {
    var res = await _networkUtil.post(LOGIN_URL, body: {
      "token": _API_KEY,
      "username": username,
      "password": password,
    });

    print("=====> Login Result: " + res.toString());

    if (res["error"]) {
      return RestResponse(0, res["error_msg"], null);
    } else {
      return RestResponse(1, "Đăng nhập thành công", User.map(res["user"]));
    }
  }
}
