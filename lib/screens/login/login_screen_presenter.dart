import 'package:postplus_client/data/rest_ds.dart';
import 'package:postplus_client/data/rest_response.dart';
import 'package:postplus_client/models/user.dart';

/// TODO: handle the login logic
/// TODO: defines an interface for LoginScreen view
/// TODO: and a presenter that incorporates all business logic specific to login screen itself

abstract class LoginScreenContract {
  void onLoginSuccess(User user);

  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestDatasource api = new RestDatasource();

  LoginScreenPresenter(this._view);

  doLogin(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      _view.onLoginError("Vui lòng điền đầy đủ thông tin đăng nhập");
      return;
    }

    RestResponse res = await api.login2(username, password);
    if (res.status == 0)
      _view.onLoginError(res.message);
    else
      _view.onLoginSuccess(res.data);
  }
}
