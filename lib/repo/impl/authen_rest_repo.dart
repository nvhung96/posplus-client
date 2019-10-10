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
      "email": username,
      "password": password,
    });

    var res = await _networkUtil.post(BASE_URL + "/login",
        headers: headers, body: loginInfo);

    print("=====> Login Data: " + loginInfo);
    print("=====> Login Result: " + res.toString());

    if (res["errors"] != null) {
      if (res["errors"]["email"][0] != null)
        return RestResponse(0, res["errors"]["email"][0], null);

      if (res["errors"]["password"][0] != null)
        return RestResponse(0, res["errors"]["password"][0], null);

      return RestResponse(
          0, "Có lỗi xảy ra. Vui lòng thử lại sau (Err: 2)", null);
    } else if (res["error"] != null) {
      String error = res["error"]["message"] != null
          ? res["error"]["message"]
          : "Có lỗi xảy ra. Vui lòng thử lại sau (Err: 1)";

      return RestResponse(0, error, null);
    } else {
      Map resData = {
        'username': username,
        'token': res["data"]["token"],
      };

      return RestResponse(1, "Đăng nhập thành công", User.map(resData));
    }
  }
}
