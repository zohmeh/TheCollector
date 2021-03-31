import 'package:flutter/material.dart';
import '../routing/route_names.dart';
import '../services/navigation_service.dart';
import '../locator.dart';
import 'button.dart';

class Sidebar extends StatefulWidget {
  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  var buttoncolors = {
    0: Colors.purpleAccent,
    1: Colors.blueAccent,
    2: Colors.blueAccent,
  };

  _changeSide(List _arguments) {
    locator<NavigationService>().navigateTo(_arguments[0]);
    setState(() {
      for (var i = 0; i < buttoncolors.length; i++) {
        buttoncolors[i] = Theme.of(context).buttonColor;
      }
      buttoncolors[_arguments[1]] = Theme.of(context).accentColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          button(buttoncolors[0], Theme.of(context).highlightColor, "NFT List",
              _changeSide, [HomeRoute, 0]),
          SizedBox(height: 20),
          button(buttoncolors[1], Theme.of(context).highlightColor,
              "My Portfolio", _changeSide, [MyPortfolioRoute, 1]),
          SizedBox(height: 20),
          button(buttoncolors[2], Theme.of(context).highlightColor,
              "Create New NFT", _changeSide, [CreateNewNFTRoute, 2]),
        ],
      ),
    );
  }
}
