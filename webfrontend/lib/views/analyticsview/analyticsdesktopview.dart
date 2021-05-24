import 'dart:convert';
import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_app_template/provider/contractinteraction.dart';
import 'package:web_app_template/provider/loginprovider.dart';
import 'package:web_app_template/widgets/javascript_controller.dart';
import 'package:web_app_template/widgets/sidebar/sidebardesktop.dart';
import 'package:web_app_template/widgets/useravatar.dart';

class AnalyticsDekstopView extends StatefulWidget {
  @override
  _AnalyticsDekstopViewState createState() => _AnalyticsDekstopViewState();
}

class _AnalyticsDekstopViewState extends State<AnalyticsDekstopView> {
  Future soldItems;
  List allItems = [];
  int _currentSortColumn = 0;
  bool _isAscending = true;
  var txold;

  Future _getSoldItems() async {
    var promise = getSoldItems();
    var result = await promiseToFuture(promise);
    var items = json.decode(result);
    return (items);
  }

  @override
  void initState() {
    soldItems = _getSoldItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<LoginModel>(context).user;
    var tx = Provider.of<Contractinteraction>(context).tx;

    if (txold != tx) {
      setState(() {
        txold = tx;
        soldItems = _getSoldItems();
      });
    }
    return Row(
      children: [
        SidebarDesktop(5),
        user != null
            ? Container(
                padding: EdgeInsets.all(10),
                height: double.infinity,
                width: (MediaQuery.of(context).size.width - 150),
                child: FutureBuilder(
                    future: soldItems,
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        allItems = snapshot.data;
                        return DataTable(
                          sortColumnIndex: _currentSortColumn,
                          sortAscending: _isAscending,
                          columns: [
                            DataColumn(
                                label: Text("NFT",
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor))),
                            DataColumn(
                                label: Text("Price",
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor)),
                                onSort: (columnIndex, _) {
                                  setState(() {
                                    _currentSortColumn = columnIndex;
                                    if (_isAscending == true) {
                                      _isAscending = false;
                                      allItems.sort((itemA, itemB) =>
                                          itemB["price"]
                                              .compareTo(itemA["price"]));
                                    } else {
                                      _isAscending = true;
                                      allItems.sort((itemA, itemB) =>
                                          itemA["price"]
                                              .compareTo(itemB["price"]));
                                    }
                                  });
                                }),
                            DataColumn(
                                label: Text("Creator",
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor))),
                          ],
                          rows: allItems
                              .map((element) => DataRow(cells: [
                                    DataCell(Text(element["tokenId"],
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .highlightColor))),
                                    DataCell(Text(
                                        (int.parse(element["price"]) /
                                                    1000000000000000000)
                                                .toString() +
                                            " Eth",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .highlightColor))),
                                    DataCell(Row(
                                      children: [
                                        Text(element["creator"]["username"],
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .highlightColor)),
                                        SizedBox(width: 10),
                                        Useravatar(
                                          width: 25,
                                          height: 25,
                                          image: element["creator"]["avatar"],
                                        )
                                      ],
                                    ))
                                  ]))
                              .toList(),
                        );
                      }
                    }),
              )
            : Container(
                width: (MediaQuery.of(context).size.width - 150),
                child: Center(
                    child: Text("Please log in with Metamask",
                        style: TextStyle(
                            color: Theme.of(context).highlightColor)))),
      ],
    );
  }
}
