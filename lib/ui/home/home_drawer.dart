import 'package:flutter/material.dart';
import 'package:postplus_client/ui/base/base_view.dart';
import 'package:postplus_client/ui/home/logout_contract.dart';
import 'package:postplus_client/ui/home/logout_presenter.dart';
import 'package:postplus_client/util/constants.dart';

class HomeDrawer extends StatefulWidget {
  HomeDrawer({Key key}) : super(key: key);

  @override
  HomeDrawerState createState() => HomeDrawerState();
}

class HomeDrawerState extends BaseView implements LogoutContract {
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
    print("HomeDrawer_context: " + _context.toString());
    Navigator.of(_context).pushNamed("/");
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(APP_NAME,
                style: new TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text("Xin chào !",
                style: new TextStyle(fontWeight: FontWeight.bold)),
            currentAccountPicture: new Image(
              image: new AssetImage("assets/logo.jpg"),
            ),
            decoration: BoxDecoration(
                image: new DecorationImage(
                    fit: BoxFit.cover,
                    image: new AssetImage("assets/login_background.jpg"),
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.darken))),
            margin: EdgeInsets.zero,
          ),
          ListTile(
            leading: new Icon(Icons.exit_to_app),
            title: Text('Đăng xuất'),
            onTap: () {
              _presenter.doLogout();
            },
          ),
        ],
      ),
    );
  }
}
