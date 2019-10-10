import 'package:postplus_client/data/dao/impl/user_sqlite_dao.dart';
import 'package:postplus_client/data/dao/user_dao.dart';
import 'package:postplus_client/ui/base/base_presenter.dart';
import 'package:postplus_client/ui/home/logout_contract.dart';

import 'home_drawer.dart';

/// TODO: handle the login logic
/// TODO: defines an interface for LoginScreen view
/// TODO: and a presenter that incorporates all business logic specific to login screen itself

class LogoutPresenter extends BasePresenter {
  LogoutPresenter(HomeDrawerState view) : super(view) {
    _contract = view;
  }

  LogoutContract _contract;

  UserDao _userDao = UserSqliteDao();

  doLogout() async {
    await _userDao.deleteUsers();

    _contract.onLogoutSuccess();
  }
}
