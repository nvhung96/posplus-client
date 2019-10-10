import 'package:postplus_client/model/checklist.dart';
import 'package:postplus_client/repo/checklist_repo.dart';
import 'package:postplus_client/repo/impl/checklist_rest_repo.dart';
import 'package:postplus_client/ui/base/base_presenter.dart';
import 'package:postplus_client/ui/base/base_view.dart';

/// TODO: handle the login logic
/// TODO: defines an interface for LoginScreen view
/// TODO: and a presenter that incorporates all business logic specific to login screen itself

class HomePresenter extends BasePresenter {
  HomePresenter(BaseView view) : super(view);

  ChecklistRepo _checklistRepo = ChecklistRestRepo();

  List<Checklist> checklists = <Checklist>[];

  Future<List<Checklist>> getChecklists() async {
    Map cond = Map();

    checklists = await _checklistRepo.getChecklists(cond, 1, 10);
    return checklists;
  }
}
