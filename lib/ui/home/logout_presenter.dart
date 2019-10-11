import 'package:postplus_client/repo/impl/user_prefs_repo.dart';
import 'package:postplus_client/repo/user_repo.dart';
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

  UserRepo _userRepo = UserPrefsRepo();

  doLogout() async {
    await _userRepo.deleteUsers();

    _contract.onLogoutSuccess();
  }
}
