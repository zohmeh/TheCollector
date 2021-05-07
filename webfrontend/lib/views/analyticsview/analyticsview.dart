import 'package:flutter/material.dart';
import './analyticsdesktopview.dart';
import '../../responsive.dart';
import './analyticsmobileview.dart';

class AnalyticsView extends StatefulWidget {
  @override
  _AnalyticsViewState createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<AnalyticsView> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: AnalyticsMobileView(),
        tablet: AnalyticsMobileView(),
        desktop: AnalyticsDekstopView());
  }
}

class AnalyticsDesktopView {}
