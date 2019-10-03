import 'package:postplus_client/auth.dart';
import 'package:postplus_client/data/database_helper.dart';
import 'package:postplus_client/data/rest_ds.dart';
import 'package:postplus_client/models/user.dart';


/// TODO: handle the login logic
/// TODO: defines an interface for LoginScreen view
/// TODO: and a presenter that incorporates all business logic specific to login screen itself

abstract class LogoutContract {
  void onLogoutSuccess();

  void onLogoutError(String errorTxt);
}

class LogoutPresenter {
  LogoutContract _view;
  RestDatasource api = new RestDatasource();

  LogoutPresenter(this._view);

  doLogout() async {
    var db = new DatabaseHelper();
    await db.deleteUsers();

    _view.onLogoutSuccess();
  }
}
