import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postplus_client/model/checklist.dart';
import 'package:postplus_client/service/auth.dart';
import 'package:postplus_client/ui/base/base_view.dart';
import 'package:postplus_client/ui/checklist/checklist_screen.dart';
import 'package:postplus_client/ui/home/home_presenter.dart';
import 'package:postplus_client/util/constants.dart';

class ChecklistsScreen extends StatefulWidget {
  ChecklistsScreen({Key key, this.timeRange, this.scaffoldKey})
      : super(key: key);

  final String timeRange;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _ChecklistsScreenState createState() =>
      _ChecklistsScreenState(timeRange, scaffoldKey);
}

class _ChecklistsScreenState extends BaseView implements AuthStateListener {
  BuildContext _context;

  String _timeRange;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  HomePresenter _presenter;
  Map _searchCondition = Map();

  _ChecklistsScreenState(
      String timeRange, GlobalKey<ScaffoldState> scaffoldKey) {
    _timeRange = timeRange;
  }

  @override
  void initState() {
    _presenter = new HomePresenter(this);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);

    if (_timeRange != null && _timeRange.isNotEmpty)
      _searchCondition['time_range'] = _timeRange;
    else
      _searchCondition['time_range'] = 'today';

    _presenter.getChecklists(_searchCondition);

    super.initState();
  }

  @override
  void onLogoutError(String errorTxt) {
    // TODO: implement onLogoutError
  }

  @override
  void onLogoutSuccess() {
    print("ChecklistsScreen_context: " + _context.toString());
    Navigator.of(_context).pushNamed("/");
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    return Scaffold(
      key: _scaffoldKey,
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
    );
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
      print("ChecklistsScreen_context: " + _context.toString());
      await _presenter.deleteUsers();
      Navigator.of(_context).pushNamed("/");
    }
  }
}
