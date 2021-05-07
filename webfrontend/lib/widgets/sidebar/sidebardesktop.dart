import 'package:flutter/material.dart';
import '../../widgets/buttons/ibutton.dart';
import '../../routing/route_names.dart';
import '../../services/navigation_service.dart';
import '../../locator.dart';

class SidebarDesktop extends StatefulWidget {
  final side;

  SidebarDesktop(this.side);

  @override
  _SidebarDesktopState createState() => _SidebarDesktopState();
}

class _SidebarDesktopState extends State<SidebarDesktop> {
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
          ibutton(
              Icons.gavel_rounded,
              Theme.of(context).primaryColor,
              widget.side == 1
                  ? Theme.of(context).accentColor
                  : Theme.of(context).highlightColor,
              "All Auctions",
              _changeSide,
              [HomeRoute]),
          SizedBox(height: 20),
          ibutton(
              Icons.attach_money_rounded,
              Theme.of(context).primaryColor,
              widget.side == 2
                  ? Theme.of(context).accentColor
                  : Theme.of(context).highlightColor,
              "All Sellings",
              _changeSide,
              [AllOffersRoute]),
          SizedBox(height: 20),
          ibutton(
              Icons.account_balance_wallet_rounded,
              Theme.of(context).primaryColor,
              widget.side == 3
                  ? Theme.of(context).accentColor
                  : Theme.of(context).highlightColor,
              "My Portfolio",
              _changeSide,
              [MyPortfolioRoute]),
          SizedBox(height: 20),
          ibutton(
              Icons.create_rounded,
              Theme.of(context).primaryColor,
              widget.side == 4
                  ? Theme.of(context).accentColor
                  : Theme.of(context).highlightColor,
              "Create NFT",
              _changeSide,
              [CreateNewNFTRoute]),
          SizedBox(height: 20),
          ibutton(
              Icons.analytics,
              Theme.of(context).primaryColor,
              widget.side == 5
                  ? Theme.of(context).accentColor
                  : Theme.of(context).highlightColor,
              "Analytics",
              _changeSide,
              [AnalyticsRoute]),
          SizedBox(height: 20),
          ibutton(
              Icons.settings_applications_rounded,
              Theme.of(context).primaryColor,
              widget.side == 6
                  ? Theme.of(context).accentColor
                  : Theme.of(context).highlightColor,
              "Settings",
              _changeSide,
              [SettingsRoute]),
        ],
      ),
    );
  }
}
