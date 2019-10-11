import 'package:postplus_client/util/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý Công việc Fullhouse Pizza',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      debugShowCheckedModeBanner: false,
      routes: routes,
    );
  }
}
