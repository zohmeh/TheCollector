import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_app_template/provider/loginprovider.dart';
import 'package:web_app_template/widgets/ibutton.dart';
import '../routing/route_names.dart';
import '../services/navigation_service.dart';
import '../locator.dart';
import './button.dart';

String globalPage;

class Sidebar extends StatefulWidget {
  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  _changeSide(List _arguments) {
    locator<NavigationService>().navigateTo(_arguments[0]);
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
          button(
              Theme.of(context).buttonColor,
              Theme.of(context).highlightColor,
              "LogIn",
              Provider.of<LoginModel>(context).logIn),
          button(
              Theme.of(context).buttonColor,
              Theme.of(context).highlightColor,
              "LogOut",
              Provider.of<LoginModel>(context).logOut),
          SizedBox(height: 100),
          ibutton(
              Icons.gavel_rounded,
              Theme.of(context).primaryColor,
              Theme.of(context).highlightColor,
              "All Auctions",
              _changeSide,
              [HomeRoute, 0]),
          SizedBox(height: 20),
          ibutton(
              Icons.attach_money_rounded,
              Theme.of(context).primaryColor,
              Theme.of(context).highlightColor,
              "All Sellings",
              _changeSide,
              [AllOffersRoute, 1]),
          SizedBox(height: 20),
          ibutton(
              Icons.account_balance_wallet_rounded,
              Theme.of(context).primaryColor,
              Theme.of(context).highlightColor,
              "My Portfolio",
              _changeSide,
              [MyPortfolioRoute, 2]),
          SizedBox(height: 20),
          ibutton(
              Icons.create_rounded,
              Theme.of(context).primaryColor,
              Theme.of(context).highlightColor,
              "Create NFT",
              _changeSide,
              [CreateNewNFTRoute, 3]),
        ],
      ),
    );
  }
}
