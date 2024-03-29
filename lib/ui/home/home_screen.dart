import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postplus_client/model/checklist.dart';
import 'package:postplus_client/service/auth.dart';
import 'package:postplus_client/ui/base/base_view.dart';
import 'package:postplus_client/ui/checklist/checklist_screen.dart';
import 'package:postplus_client/ui/checklist/checklists_screen.dart';
import 'package:postplus_client/ui/home/home_drawer.dart';
import 'package:postplus_client/ui/home/home_presenter.dart';
import 'package:postplus_client/util/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseView
    with SingleTickerProviderStateMixin
    implements AuthStateListener {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Widget> _timeRangeTabs = <Tab>[
    Tab(text: "Hôm nay"),
    Tab(text: "Hôm qua"),
    Tab(text: "Tuần này"),
    Tab(text: "Tháng này"),
  ];

  BuildContext _context;
  HomePresenter _presenter;
  TabController _tabController;

  @override
  void initState() {
    _presenter = new HomePresenter(this);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);

    _presenter.getChecklists(Map());

    _tabController = TabController(length: _timeRangeTabs.length, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

    AppBar appBar = AppBar(
      title: Text("$TITLE_CHECKLISTS"),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.sync, semanticLabel: 'Reload'),
          onPressed: () => _presenter.getChecklists(Map()),
        ),
      ],
    );

    Widget tabBars = Container(
      decoration: BoxDecoration(color: Colors.white60),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicator: BoxDecoration(color: COLOR_MAIN),
        unselectedLabelColor: Colors.black,
        tabs: _timeRangeTabs,
      ),
    );

    Widget tabBarViews = Container(
        height:
            MediaQuery.of(context).size.height - appBar.preferredSize.height,
        child: TabBarView(controller: _tabController, children: <Widget>[
          ChecklistsScreen(
            timeRange: "today",
            scaffoldKey: _scaffoldKey,
          ),
          ChecklistsScreen(
            timeRange: "yesterday",
            scaffoldKey: _scaffoldKey,
          ),
          ChecklistsScreen(
            timeRange: "this_week",
            scaffoldKey: _scaffoldKey,
          ),
          ChecklistsScreen(
            timeRange: "this_month",
            scaffoldKey: _scaffoldKey,
          ),
        ]));

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: appBar,
            drawer: HomeDrawer(),
            body: ListView(
              children: <Widget>[tabBars, tabBarViews],
            )));
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
              shape: SHAPE_BORDER,
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
