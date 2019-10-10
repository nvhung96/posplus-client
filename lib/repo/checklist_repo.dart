import 'package:postplus_client/model/checklist.dart';
import 'package:postplus_client/model/item.dart';

abstract class ChecklistRepo {
  Future<List<Checklist>> getChecklists(Map condition, int page, int limit);

  Future<List<Item>> getItems(Map condition, int page, int limit);
}
