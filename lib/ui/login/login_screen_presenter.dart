import 'package:postplus_client/data/rest_response.dart';
import 'package:postplus_client/model/user.dart';
import 'package:postplus_client/repo/authen_repo.dart';
import 'package:postplus_client/repo/impl/authen_demo_repo.dart';

/// TODO: handle the login logic
/// TODO: defines an interface for LoginScreen view
/// TODO: and a presenter that incorporates all business logic specific to login screen itself

abstract class LoginScreenContract {
  void onLoginSuccess(User user);

  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  AuthenRepo authenRepo = new AuthenDemoRepo();

  LoginScreenPresenter(this._view);

  doLogin(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      _view.onLoginError("Vui lòng điền đầy đủ thông tin đăng nhập");
      return;
    }

    RestResponse res = await authenRepo.login(username, password);
    if (res.status == 0)
      _view.onLoginError(res.message);
    else
      _view.onLoginSuccess(res.data);
  }
}
