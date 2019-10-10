import 'package:postplus_client/model/checklist.dart';
import 'package:postplus_client/model/item.dart';
import 'package:postplus_client/repo/checklist_repo.dart';
import 'package:postplus_client/repo/impl/user_sqlite_repo.dart';
import 'package:postplus_client/repo/user_repo.dart';
import 'package:postplus_client/util/constants.dart';
import 'package:postplus_client/util/network_util.dart';

class ChecklistRestRepo implements ChecklistRepo {
  UserRepo _userRepo = UserSqliteRepo();
  NetworkUtil _networkUtil = new NetworkUtil();

  @override
  Future<List<Checklist>> getChecklists(
      Map condition, int page, int limit) async {
    String token = await _userRepo.getToken();

    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${token}",
    };

    var res = await _networkUtil.get(BASE_URL + "/checklists", headers: headers);

    print("=====> headers Info: " + headers.toString());
    print("=====> getChecklists Result: " + res.toString());

    if (res["error"] != null) {
      return <Checklist>[];
    } else {
      List<Checklist> checklists = <Checklist>[];
      for (dynamic map in res["data"]) {
        checklists.add(Checklist.map(map));
      }

      return checklists;
    }
  }

  @override
  Future<List<Item>> getItems(Map condition, int page, int limit) async {
    // TODO: implement getItems
    return null;
  }
}
