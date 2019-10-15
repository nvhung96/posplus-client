import 'package:postplus_client/model/checklist.dart';
import 'package:postplus_client/model/user.dart';
import 'package:postplus_client/repo/checklist_repo.dart';
import 'package:postplus_client/repo/impl/checklist_rest_repo.dart';
import 'package:postplus_client/repo/impl/user_prefs_repo.dart';
import 'package:postplus_client/repo/user_repo.dart';
import 'package:postplus_client/ui/base/base_presenter.dart';
import 'package:postplus_client/ui/base/base_view.dart';

/// TODO: handle the login logic
/// TODO: defines an interface for LoginScreen view
/// TODO: and a presenter that incorporates all business logic specific to login screen itself

class HomePresenter extends BasePresenter {
  HomePresenter(BaseView view) : super(view);

  ChecklistRepo _checklistRepo = ChecklistRestRepo();
  UserRepo _userRepo = UserPrefsRepo();

  List<Checklist> checklists = <Checklist>[];
  User user;

  Future<List<Checklist>> getChecklists(Map cond) async {
    checklists = await _checklistRepo.getChecklists(cond, 1, 50);

    notifyDataChanged();
    return checklists;
  }

  Future<User> getUser() async {
    user = await _userRepo.getUser();
    notifyDataChanged();
  }

  Future deleteUsers() async {
    _userRepo.deleteUsers();
  }
}
