import 'package:flutter/material.dart';

class Item {
  Item({
    @required this.id,
    @required this.name,
    @required this.quantity,
    @required this.unit,
    @required this.checklistId,
    @required this.checklist,
    @required this.checklistCreatedAt,
    @required this.checked,
    @required this.updatedAt,
  })  : assert(id != null),
        assert(name != null),
        assert(quantity != null),
        assert(unit != null),
        assert(checklistId != null),
        assert(checklist != null),
        assert(checklistCreatedAt != null),
        assert(checked != null),
        assert(updatedAt != null);

  int id;
  String name;
  int quantity;
  String unit;
  int checklistId;
  String checklist;
  DateTime checklistCreatedAt;
  bool checked;
  DateTime updatedAt;

  // TODO: Setter, trả về đối tượng thể hiện của lớp
  Item.map(dynamic map) {
    this.id = map["id"];
    this.name = map["name"];
    this.quantity = map["quantity"];
    this.unit = map["unit"];
    this.checklistId = map["checklist_id"];
    this.checklist = map["checklist"];
    this.checklistCreatedAt = DateTime.parse(map["checklist_created_at"]);
    this.checked = map["checked"];
    this.updatedAt = DateTime.parse(map["updated_at"]);
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["quantity"] = quantity;
    map["unit"] = unit;
    map["checklist_id"] = checklistId;
    map["checklist"] = checklist;
    map["checklist_created_at"] = checklistCreatedAt.toString();
    map["checked"] = checked;
    map["updated_at"] = updatedAt.toString();

    return map;
  }
}
