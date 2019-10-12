import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postplus_client/model/item.dart';
import 'package:postplus_client/service/auth.dart';
import 'package:postplus_client/ui/base/base_view.dart';
import 'package:postplus_client/ui/checklist/checklist_presenter.dart';
import 'package:postplus_client/util/constants.dart';

const ShapeBorder shapeBorder = const RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(0.0),
    topRight: Radius.circular(0.0),
    bottomLeft: Radius.circular(0.0),
    bottomRight: Radius.circular(0.0),
  ),
);

class ChecklistScreen extends StatefulWidget {
  ChecklistScreen({Key key, this.id, this.name}) : super(key: key);

  final int id;
  final String name;

  @override
  _ChecklistScreenState createState() => _ChecklistScreenState(id, name);
}

class _ChecklistScreenState extends BaseView implements AuthStateListener {
  BuildContext _context;
  ChecklistPresenter _presenter;
  int _id;
  String _name;

  _ChecklistScreenState(int id, String name) {
    _id = id;
    _name = name;
  }

  @override
  void initState() {
    _presenter = new ChecklistPresenter(this);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);

    _presenter.getChecklist(_id);
    _presenter.getItems(_id);

    super.initState();
  }

  @override
  void onLogoutError(String errorTxt) {
    // TODO: implement onLogoutError
  }

  @override
  void onLogoutSuccess() {
    print("ChecklistScreen_context: " + _context.toString());
    Navigator.of(_context).pushNamed("/");
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    _name = _name != null ? _name.trim() : TITLE_CHECKLISTS;

    return Scaffold(
      appBar: AppBar(
        title: Text("${_name}"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.sync, semanticLabel: 'Reload'),
            onPressed: () {
              _presenter.getChecklist(_id);
              _presenter.getItems(_id);
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(38.0),
          child: Container(
            color: Colors.white60,
            height: 38.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                buildBottomAppBarItem(
                    Icons.check, "${_presenter.completedRate}"),
                buildBottomAppBarItem(
                    Icons.date_range, "${_presenter.createdAt}"),
              ],
            ),
          ),
        ),
      ),
      body: _presenter.items.isNotEmpty
          ? Scrollbar(
              child: ListView.builder(
                itemCount: _presenter.items.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildItem(_presenter.items[index]);
                },
              ),
            )
          : Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
      /*body: FutureBuilder(
          future: _presenter.getItems(_id),
          builder:
              (BuildContext context, AsyncSnapshot<List<Item>> checklists) {
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
    );
  }

  Widget buildItem(Item item) {
    String createdAt = DateFormat("dd-MM-yyyy").format(item.checklistCreatedAt);
    String quantity = "Cần mua: ${item.quantity} ${item.unit}";
    Color cardColor = item.checked ? COLOR_CHECK : COLOR_UNCHECK;
    Widget button = !item.checked
        ? RaisedButton.icon(
            icon: const Icon(Icons.check),
            color: COLOR_MAIN,
            textColor: COLOR_CARD,
            label: const Text('Hoàn thành'),
            onPressed: () {},
          )
        : FlatButton.icon(
            icon: const Icon(Icons.check),
            textColor: COLOR_MAIN,
            label: const Text('Đã xong'),
            onPressed: null,
          );

    return GestureDetector(
      onTap: () {},
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          child: SizedBox(
            height: 135.0,
            child: Card(
              // This ensures that the Card's children are clipped correctly.
              clipBehavior: Clip.antiAlias,
              shape: shapeBorder,
              elevation: 8.0,
              color: cardColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 80.0,
                    child: CircleAvatar(
                      child: Icon(Icons.fastfood),
                      foregroundColor: Colors.white,
                      backgroundColor: COLOR_MAIN,
                    ),
                  ),
                  Container(
                    width: 245.0,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          buildItemTitle(item.name),
                          buildItemDetail(Icons.event_available, "${quantity}"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[button],
                          ),
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
      child: Text(name.trim(),
          overflow: TextOverflow.ellipsis,
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
            size: 19.0,
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

  Widget buildBottomAppBarItem(IconData iconData, String text) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Row(
        children: <Widget>[
          Icon(
            iconData,
            size: 18.0,
            color: COLOR_MAIN,
          ),
          Text(" ${text}",
              style: Theme.of(context)
                  .textTheme
                  .body2
                  .merge(TextStyle(color: COLOR_MAIN, fontSize: 18.0))),
        ],
      ),
    );
  }

  @override
  void onAuthStateChanged(AuthState state) async {
    if (state == AuthState.LOGGED_OUT) {
      print("ChecklistScreen_context: " + _context.toString());
      await _presenter.deleteUsers();
      Navigator.of(_context).pushNamed("/");
    }
  }
}
