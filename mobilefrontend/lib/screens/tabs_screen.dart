import '../widgets/appdrawer.dart';
import 'package:flutter/material.dart';
import './marketplaces_screen.dart';
import '../screens/myportfolio_screen.dart';

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
      {"page": Marketplaces(), "title": "Marketplaces"},
      {"page": MyPortfolioScreen(), "title": "My Portfolio"},
      //{"page": Screen3(), "title": "Screen 3"}
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
          "TheCollector",
          style: TextStyle(color: Theme.of(context).highlightColor),
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
            icon: Icon(Icons.shopping_cart_rounded),
            label: "Marketplaces",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket_rounded),
            label: "My Portfolio",
          ),
        ],
      ),
    );
  }
}
