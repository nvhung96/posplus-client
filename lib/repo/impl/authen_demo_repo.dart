import 'package:postplus_client/data/rest_response.dart';
import 'package:postplus_client/model/user.dart';
import 'package:postplus_client/repo/authen_repo.dart';
import 'package:postplus_client/util/network_util.dart';

class AuthenDemoRepo implements AuthenRepo {
  NetworkUtil _networkUtil = new NetworkUtil();
  static final BASE_URL = "https://demo7351156.mockable.io";

//  static final LOGIN_URL = BASE_URL + "/login_error";
  static final LOGIN_URL = BASE_URL + "/login";
  static final _API_KEY = "somerandomkey";

  @override
  Future<RestResponse> login(String username, String password) async {
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

  @override
  Future<User> me(String token) {
    // TODO: implement me
    return null;
  }
}
