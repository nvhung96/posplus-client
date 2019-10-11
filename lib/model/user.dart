import 'package:flutter/material.dart';

class User {
  User({
    @required this.id,
    @required this.username,
    @required this.token,
    @required this.email,
    @required this.displayName,
    @required this.avatar,
    @required this.phoneNumber,
    @required this.activated,
    @required this.forbidden,
    @required this.language,
  })  : assert(id != null),
        assert(username != null),
        assert(token != null),
        assert(email != null),
        assert(displayName != null);

  int id;
  String username;
  String token;
  String email;
  String displayName;
  String avatar;
  String phoneNumber;
  int activated;
  int forbidden;
  String language;

  // TODO: Setter, trả về đối tượng thể hiện của lớp
  User.map(dynamic map) {
    this.id = map["id"];
    this.username = map["username"];
    this.token = map["token"];
    this.email = map["email"];
    this.displayName = map["display_name"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["username"] = username;
    map["token"] = token;
    map["email"] = email;
    map["display_name"] = displayName;

    return map;
  }
}
