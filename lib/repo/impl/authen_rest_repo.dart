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

    var res = await _networkUtil.post("${BASE_URL}/login",
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
      // TODO: Lấy thông tin user
      User user = await me(res["data"]["token"]);

      return RestResponse(1, "Đăng nhập thành công", user);
    }
  }

  @override
  Future<User> me(String token) async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${token}",
    };

    var res = await _networkUtil.post("${BASE_URL}/me", headers: headers);

    print("=====> URL Info: " + "${BASE_URL}/me");
    print("=====> headers Info: " + headers.toString());
    print("=====> me Result: " + res.toString());

    if (res["data"] != null) {
      res["data"]["username"] = res["data"]["email"];
      res["data"]["token"] = token;

      return User.map(res["data"]);
    } else {
      return null;
    }
  }
}
