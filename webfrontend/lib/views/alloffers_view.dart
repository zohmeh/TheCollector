import 'package:flutter/material.dart';
import './alloffersview/alloffersmobileview.dart';
import '../responsive.dart';
import './alloffersview/alloffersdesktopview.dart';

class AllOffersView extends StatefulWidget {
  @override
  _AllOffersViewState createState() => _AllOffersViewState();
}

class _AllOffersViewState extends State<AllOffersView> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: AllOffersMobileView(),
      tablet: AllOffersMobileView(),
      desktop: AllOffersDesktopView(),
    );
  }
}
