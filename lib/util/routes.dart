import 'package:postplus_client/ui/home/home_screen.dart';
import 'package:postplus_client/ui/login/login_screen.dart';
import 'package:flutter/material.dart';

final routes = {
  '/login': (BuildContext context) => new LoginScreen(),
  '/home': (BuildContext context) => new HomeScreen(),
  '/': (BuildContext context) => new LoginScreen(),
};
