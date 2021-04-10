import '../widgets/appdrawer.dart';
import 'package:flutter/material.dart';
import 'screen1_screen.dart';
import 'screen3_screen.dart';
import 'screen2_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabs-screen';
  int selectedPageIndex = 0;

  TabsScreen(this.selectedPageIndex);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages;
  @override
  void initState() {
    _pages = [
      {"page": Screen1(), "title": "Screen 1"},
      {"page": Screen2(), "title": "Screen 2"},
      {"page": Screen3(), "title": "Screen 3"}
    ];

    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      widget.selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          "MobileApp-Template",
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
      ),
      drawer: AppDrawer(),
      body: _pages[widget.selectedPageIndex]["page"],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        onTap: _selectPage,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: widget.selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Screen 1",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: "Screen 2",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: "Screen 3",
          ),
        ],
      ),
    );
  }
}
