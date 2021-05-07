import 'dart:convert';
import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_app_template/provider/contractinteraction.dart';
import 'package:web_app_template/provider/loginprovider.dart';
import 'package:web_app_template/widgets/javascript_controller.dart';
import 'package:web_app_template/widgets/sidebar/sidebardesktop.dart';

class AnalyticsDekstopView extends StatefulWidget {
  @override
  _AnalyticsDekstopViewState createState() => _AnalyticsDekstopViewState();
}

class _AnalyticsDekstopViewState extends State<AnalyticsDekstopView> {
  Future _getSoldItems() async {
    var promise = getSoldItems();
    var result = await promiseToFuture(promise);
    var items = json.decode(result);
    print(items);
    return (result);
  }

  @override
  Widget build(BuildContext context) {
    _getSoldItems();
    final user = Provider.of<LoginModel>(context).user;
    Provider.of<Contractinteraction>(context);
    return Row(
      children: [
        SidebarDesktop(5),
        user != null
            ? Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    //height: double.infinity,
                    width: (MediaQuery.of(context).size.width - 150),
                  ),
                ],
              )
            : Container(
                width: (MediaQuery.of(context).size.width - 150),
                child: Center(child: Text("Please log in with Metamask"))),
      ],
    );
  }
}
