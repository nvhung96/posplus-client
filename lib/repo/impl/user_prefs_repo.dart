import 'dart:convert';

import 'package:postplus_client/model/user.dart';
import 'package:postplus_client/repo/user_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPrefsRepo implements UserRepo {
  @override
  Future<User> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userPrefs = prefs.getString("user");
    if (userPrefs == null || userPrefs.isEmpty) return null;

    //print("=====> User Preference data (getToken): ${userPrefs.toString()}");
    User user = User.map(jsonDecode(userPrefs));

    return user;
  }

  @override
  Future<int> saveUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user", jsonEncode(user.toMap()));
    return 1;
  }

  @override
  Future<int> deleteUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("user");
    return 1;
  }

  @override
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userPrefs = prefs.getString("user");

    //print("=====> User Preference data: ${userPrefs.toString()}");

    if (userPrefs == null || userPrefs.isEmpty) return false;

    return true;
  }

  @override
  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userPrefs = prefs.getString("user");
    if (userPrefs == null || userPrefs.isEmpty) return "";

    //print("=====> User Preference data (getToken): ${userPrefs.toString()}");
    User user = User.map(jsonDecode(userPrefs));

    return user.token;
  }
}
