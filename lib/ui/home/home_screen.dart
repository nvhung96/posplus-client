import 'package:flutter/material.dart';
import 'package:postplus_client/ui/base/base_view.dart';
import 'package:postplus_client/ui/home/home_drawer.dart';
import 'package:postplus_client/ui/home/home_presenter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseView {
  BuildContext _context;
  HomePresenter _presenter;

  @override
  void initState() {
    _presenter = new HomePresenter(this);
    super.initState();
  }

  @override
  void onLogoutError(String errorTxt) {
    // TODO: implement onLogoutError
  }

  @override
  void onLogoutSuccess() {
    print("HomeScreen_context: " + _context.toString());
    Navigator.of(_context).pushNamed("/");
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return new WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
          appBar: new AppBar(
            title: new Text("Home"),
          ),
          body: new Center(
            child: new Text("Welcome home!"),
          ),
          drawer: HomeDrawer(),
        ));
  }
}
