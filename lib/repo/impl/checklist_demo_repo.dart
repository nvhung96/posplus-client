
import 'package:postplus_client/model/checklist.dart';
import 'package:postplus_client/model/item.dart';
import 'package:postplus_client/repo/checklist_repo.dart';

class ChecklistImplRepo implements ChecklistRepo {
  @override
  Future<List<Checklist>> getChecklists(Map condition, int page, int limit) {
    // TODO: implement getChecklists
    return null;
  }

  @override
  Future<List<Item>> getItems(Map condition, int page, int limit) {
    // TODO: implement getItems
    return null;
  }

  @override
  Future<List<Item>> getItemsByChecklistId(int checklistId, int page, int limit) {
    // TODO: implement getItemsByChecklistId
    return null;
  }

}