import 'package:flutter/cupertino.dart';
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

    _presenter.getChecklists();

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
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            title: Text("$TITLE_CHECKLISTS"),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.sync, semanticLabel: 'Reload'),
                onPressed: () => _presenter.getChecklists(),
              ),
            ],
          ),
          drawer: HomeDrawer(),
          body: _presenter.checklists.isNotEmpty
              ? Scrollbar(
                  child: ListView.builder(
                    itemCount: _presenter.checklists.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildItem(_presenter.checklists[index]);
                    },
                  ),
                )
              : Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
          /*body: FutureBuilder(
              future: _presenter.getChecklists(),
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
                  return Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );
                }
              }),*/
        ));
  }

  Widget buildItem(Checklist checklist) {
    String createdAt = DateFormat("dd-MM-yyyy").format(checklist.createdAt);
    String completedRate = "${checklist.completedCount}/${checklist.allCount}";

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
                          buildItemDetail(
                              Icons.check, "Hoàn thành: ${completedRate}"),
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
            builder: (BuildContext context) => ChecklistScreen(
                  id: checklist.id,
                  name: checklist.name,
                )));
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
