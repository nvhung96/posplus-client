import 'package:postplus_client/screens/home/logout_presenter.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> implements LogoutContract {
  BuildContext _context;
  LogoutPresenter _presenter;

  @override
  void initState() {
    _presenter = new LogoutPresenter(this);
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
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text('Quản lý CCDC'),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                ),
                ListTile(
                  title: Text('Đăng xuất'),
                  onTap: () {
                    _presenter.doLogout();
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
