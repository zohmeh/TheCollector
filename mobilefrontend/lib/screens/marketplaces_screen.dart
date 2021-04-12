import 'package:flutter/material.dart';
import 'tabscreen2.dart';
import './auctions_screen.dart';

class Marketplaces extends StatefulWidget {
  static const routeName = '/marketplaces';

  @override
  _MarketplacesState createState() => _MarketplacesState();
}

class _MarketplacesState extends State<Marketplaces> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: [
              Tab(text: "All Auctions"),
              Tab(text: "All Sellings"),
              //Tab(text: "Tab 3"),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: TabBarView(
          children: [Auctions(), TabScreen2()],
        ),
      ),
    );
  }
}
