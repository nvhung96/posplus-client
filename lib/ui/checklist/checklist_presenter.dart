import 'package:postplus_client/model/checklist.dart';
import 'package:postplus_client/model/item.dart';
import 'package:postplus_client/repo/checklist_repo.dart';
import 'package:postplus_client/repo/impl/checklist_rest_repo.dart';
import 'package:postplus_client/repo/impl/user_prefs_repo.dart';
import 'package:postplus_client/repo/user_repo.dart';
import 'package:postplus_client/ui/base/base_presenter.dart';
import 'package:postplus_client/ui/base/base_view.dart';

/// TODO: handle the login logic
/// TODO: defines an interface for LoginScreen view
/// TODO: and a presenter that incorporates all business logic specific to login screen itself

class ChecklistPresenter extends BasePresenter {
  ChecklistPresenter(BaseView view) : super(view);

  ChecklistRepo _checklistRepo = ChecklistRestRepo();
  UserRepo _userRepo = UserPrefsRepo();

  List<Item> items = <Item>[];

  Future<List<Item>> getItems(int checklistId) async {
    Map cond = Map();

    items = await _checklistRepo.getItemsByChecklistId(checklistId, 1, 10);
    return items;
  }

  Future deleteUsers() async {
    _userRepo.deleteUsers();
  }
}
