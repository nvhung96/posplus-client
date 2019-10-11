import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postplus_client/model/item.dart';
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
  ChecklistScreen({Key key, this.id}) : super(key: key);

  final int id;

  @override
  _ChecklistScreenState createState() => _ChecklistScreenState(id);
}

class _ChecklistScreenState extends BaseView {
  BuildContext _context;
  ChecklistPresenter _presenter;
  int _id;

  _ChecklistScreenState(int id) {
    _id = id;
  }

  @override
  void initState() {
    _presenter = new ChecklistPresenter(this);
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
    return Scaffold(
      appBar: AppBar(
        title: Text("$TITLE_CHECKLISTS"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(38.0),
          child: Container(
            color: Colors.white60,
            height: 38.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                buildBottomAppBarItem(Icons.check, "15/20"),
                buildBottomAppBarItem(Icons.date_range, "15/12/2019"),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder(
          future: _presenter.getItems(_id),
          initialData: _presenter.items,
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
              return Text("Đang tải dữ liệu...");
            }
          }),
    );
  }

  Widget buildItem(Item item) {
    String createdAt = DateFormat("dd-MM-yyyy").format(item.checklistCreatedAt);

    return GestureDetector(
      onTap: () {},
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          child: SizedBox(
            height: 100.0,
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
                      child: Icon(Icons.fastfood),
                      foregroundColor: Colors.white,
                      backgroundColor: COLOR_MAIN,
                    ),
                  ),
                  Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          buildItemTitle(item.name),
                          buildItemDetail(Icons.access_time, createdAt),
                          buildItemDetail(Icons.check, "15/20"),
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
      padding: EdgeInsets.only(top: 15.0),
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
            size: 12.0,
            color: COLOR_MAIN,
          ),
          Text(" ${text}",
              style: Theme.of(context)
                  .textTheme
                  .caption
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
}
