import 'package:flutter/material.dart';
import 'package:web_app_template/responsive.dart';
import 'myportfoliomobileview.dart';
import 'myportfoliodesktopview.dart';

class MyPortfolioView extends StatefulWidget {
  const MyPortfolioView({Key key}) : super(key: key);

  @override
  _MyPortfolioViewState createState() => _MyPortfolioViewState();
}

class _MyPortfolioViewState extends State<MyPortfolioView> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: MyPortfolioMobileView(),
      tablet: MyPortfolioMobileView(),
      desktop: MyPortfolioDesktopView(),
    );
  }
}
