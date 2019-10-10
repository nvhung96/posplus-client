import 'package:postplus_client/ui/base/base_view.dart';
import 'package:postplus_client/ui/home/logout_contract.dart';
import 'package:postplus_client/ui/home/logout_presenter.dart';
import 'package:flutter/material.dart';

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
    );
  }
}
