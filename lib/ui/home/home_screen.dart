import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postplus_client/model/checklist.dart';
import 'package:postplus_client/service/auth.dart';
import 'package:postplus_client/ui/base/base_view.dart';
import 'package:postplus_client/ui/checklist/checklist_screen.dart';
import 'package:postplus_client/ui/home/home_drawer.dart';
import 'package:postplus_client/ui/home/home_presenter.dart';
import 'package:postplus_client/util/constants.dart';

const ShapeBorder shapeBorder = const RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(0.0),
    topRight: Radius.circular(0.0),
    bottomLeft: Radius.circular(0.0),
    bottomRight: Radius.circular(0.0),
  ),
);

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseView implements AuthStateListener {
  BuildContext _context;
  HomePresenter _presenter;

  @override
  void initState() {
    _presenter = new HomePresenter(this);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
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
            title: new Text("$TITLE_CHECKLISTS"),
          ),
          drawer: HomeDrawer(),
          body: FutureBuilder(
              future: _presenter.getChecklists(),
              initialData: _presenter.checklists,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Checklist>> checklists) {
                if (checklists.data != null && checklists.data.length > 0) {
                  return Scrollbar(
                    child: ListView.builder(
                      itemCount: checklists.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return buildItem(checklists.data[index]);
                      },
                    ),
                  );
                } else {
                  return Text("Đang tải dữ liệu...");
                }
              }),
        ));
  }

  Widget buildItem(Checklist checklist) {
    String createdAt = DateFormat("dd-MM-yyyy").format(checklist.createdAt);

    return GestureDetector(
      onTap: () {
        navigateToDetail(checklist);
      },
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          child: SizedBox(
            height: 110.0,
            child: Card(
              // This ensures that the Card's children are clipped correctly.
              clipBehavior: Clip.antiAlias,
              shape: shapeBorder,
              elevation: 8.0,
              color: COLOR_CARD,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 80.0,
                    child: CircleAvatar(
                      child: Icon(
                        checklist.icon,
                      ),
                      foregroundColor: Colors.white,
                      backgroundColor: COLOR_MAIN,
                    ),
                  ),
                  Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          buildItemTitle(checklist.name),
                          buildItemDetail(Icons.date_range, createdAt),
                          buildItemDetail(Icons.check, "Hoàn thành: 15/20"),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItemTitle(String name) {
    return Padding(
      padding: EdgeInsets.only(top: 12.0),
      child: Text(name,
          style: Theme.of(context)
              .textTheme
              .body2
              .merge(TextStyle(color: COLOR_MAIN, fontSize: 18.0))),
    );
  }

  Widget buildItemDetail(IconData iconData, String text) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0),
      child: Row(
        children: <Widget>[
          Icon(
            iconData,
            size: 15.0,
            color: COLOR_MAIN,
          ),
          Text(" ${text}",
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .merge(TextStyle(color: COLOR_MAIN))),
        ],
      ),
    );
  }

  void navigateToDetail(Checklist checklist) {
    Navigator.push(
        _context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                ChecklistScreen(id: checklist.id)));
  }

  @override
  void onAuthStateChanged(AuthState state) async {
    if (state == AuthState.LOGGED_OUT) {
      print("HomeScreen_context: " + _context.toString());
      await _presenter.deleteUsers();
      Navigator.of(_context).pushNamed("/");
    }
  }
}
