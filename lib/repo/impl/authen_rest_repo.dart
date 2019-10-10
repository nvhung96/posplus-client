import 'dart:convert';

import 'package:postplus_client/data/rest_response.dart';
import 'package:postplus_client/model/user.dart';
import 'package:postplus_client/repo/authen_repo.dart';
import 'package:postplus_client/util/constants.dart';
import 'package:postplus_client/util/network_util.dart';

class AuthenRestRepo implements AuthenRepo {
  NetworkUtil _networkUtil = new NetworkUtil();

  @override
  Future<RestResponse> login(String username, String password) async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    String loginInfo = jsonEncode({
      "username": username,
      "password": password,
    });

    var res = await _networkUtil.post(BASE_URL + "/login",
        headers: headers, body: loginInfo);

    print("=====> Login Result: " + res.toString());

    if (res["error"] != null) {
      return RestResponse(0, res["error"]["message"], null);
    } else {

      Map resData = {
        'username': username,
        'token': res["data"]["token"],
      };

      return RestResponse(1, "Đăng nhập thành công", User.map(resData));
    }
  }
}
