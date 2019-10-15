import 'package:postplus_client/model/checklist.dart';
import 'package:postplus_client/model/item.dart';
import 'package:postplus_client/repo/checklist_repo.dart';
import 'package:postplus_client/repo/impl/user_prefs_repo.dart';
import 'package:postplus_client/repo/user_repo.dart';
import 'package:postplus_client/service/auth.dart';
import 'package:postplus_client/util/constants.dart';
import 'package:postplus_client/util/network_util.dart';

class ChecklistRestRepo implements ChecklistRepo {
  UserRepo _userRepo = UserPrefsRepo();
  NetworkUtil _networkUtil = new NetworkUtil();

  @override
  Future<List<Checklist>> getChecklists(
      Map condition, int page, int limit) async {
    String token = await _userRepo.getToken();

    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${token}",
    };

    String url = "${BASE_URL}/checklists";
    if (condition['time_range'] != null)
      url += "?time_range=${condition['time_range']}";
    else
      url += "?time_range=today";

    var res =
        await _networkUtil.get(url, headers: headers);

    //print("=====> headers Info: " + headers.toString());
    print("=====> getChecklists Result: " + res.toString());

    if (res["error"] != null) {
      if (res["error"]["type"] == "TokenExpiredException") {
        var authStateProvider = new AuthStateProvider();
        authStateProvider.notify(AuthState.LOGGED_OUT);
      }
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
  Future<Checklist> getChecklist(int id) async {
    String token = await _userRepo.getToken();

    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${token}",
    };

    var res = await _networkUtil.get("${BASE_URL}/checklist/detail/${id}",
        headers: headers);
    print("=====> getChecklist Detail Result: " + res.toString());

    if (res["error"] != null) {
      if (res["error"]["type"] == "TokenExpiredException") {
        var authStateProvider = new AuthStateProvider();
        authStateProvider.notify(AuthState.LOGGED_OUT);
      }
      return null;
    } else {
      return Checklist.map(res["data"]);
    }
  }

  @override
  Future<List<Item>> getItems(Map condition, int page, int limit) async {
    return <Item>[];
  }

  @override
  Future<List<Item>> getItemsByChecklistId(
      int checklistId, int page, int limit) async {
    String token = await _userRepo.getToken();

    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${token}",
    };

    var res = await _networkUtil.get("${BASE_URL}/checklists/${checklistId}",
        headers: headers);

    //print("=====> headers Info: " + headers.toString());
    print("=====> getItemsByChecklistId Result: " + res.toString());

    if (res["error"] != null) {
      if (res["error"]["type"] == "TokenExpiredException") {
        var authStateProvider = new AuthStateProvider();
        authStateProvider.notify(AuthState.LOGGED_OUT);
      }
      return <Item>[];
    } else {
      List<Item> items = <Item>[];
      for (dynamic map in res["data"]) {
        items.add(Item.map(map));
      }

      return items;
    }
  }
}
