import 'package:flutter/material.dart';
import '../screens/tabscreen2.dart';
import '../screens/tabscreen3.dart';
import '../screens/tabscreen1.dart';

class Screen1 extends StatefulWidget {
  static const routeName = '/screen1';

  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: [
              Tab(text: "Tab 1"),
              Tab(text: "Tab 2"),
              Tab(text: "Tab 3"),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: TabBarView(
          children: [TabScreen1(), TabScreen2(), TabScreen3()],
        ),
      ),
    );
  }
}
