import 'package:flutter/material.dart';
import 'package:web_app_template/views/allauctionsview/allauctionsmobileview.dart';
import '../../responsive.dart';
import 'allauctionsdesktopview.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: AllAuctionsMobileView(),
      tablet: AllAuctionsMobileView(),
      desktop: AllAuctionsDesktopView(),
    );
  }
}
