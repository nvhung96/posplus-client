import 'package:flutter/material.dart';

class Checklist {
  Checklist({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.creatorId,
    @required this.creator,
    @required this.assigneeId,
    @required this.assignee,
    @required this.createdAt,
    @required this.updatedAt,
    this.icon = Icons.playlist_add_check,
  })  : assert(id != null),
        assert(name != null),
        assert(description != null),
        assert(creatorId != null),
        assert(creator != null),
        assert(assigneeId != null),
        assert(assignee != null),
        assert(createdAt != null),
        assert(updatedAt != null);

  int id;
  String name;
  String description;
  int creatorId;
  String creator;
  int assigneeId;
  String assignee;
  DateTime createdAt;
  DateTime updatedAt;
  IconData icon;

  // TODO: Setter, trả về đối tượng thể hiện của lớp từ map
  Checklist.map(dynamic map) {
    this.id = map["id"];
    this.name = map["name"];
    this.description = map["description"];
    this.creatorId = map["creator_id"];
    this.creator = map["creator"];
    this.assigneeId = map["assignee_id"];
    this.assignee = map["assignee"];
    this.createdAt = DateTime.parse(map["created_at"]);
    this.updatedAt = DateTime.parse(map["updated_at"]);
    this.icon = map["icon"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["description"] = description;
    map["creator_id"] = creatorId;
    map["creator"] = creator;
    map["assignee_id"] = assigneeId;
    map["assignee"] = assignee;
    map["created_at"] = createdAt.toString();
    map["updated_at"] = updatedAt.toString();
    map["icon"] = icon;

    return map;
  }
}
