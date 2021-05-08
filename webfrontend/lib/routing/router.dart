import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../views/settingsview/accountsettingsview.dart';
import '../views/analyticsview/analyticsview.dart';
import '../routing/route_names.dart';
import '../views/alloffersview/alloffers_view.dart';
import '../views/myportfolioview/myportfolio_view.dart';
import '../views/createnftview/createnft_view.dart';
import '../views/allauctionsview/home_view.dart';
import '../widgets/string_extensions.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  var routingData = settings.name.getRoutingData;
  switch (routingData.route) {
    case HomeRoute:
      return _getPageRoute(HomeView(), settings.name);
    case AllOffersRoute:
      return _getPageRoute(AllOffersView(), settings.name);
    case MyPortfolioRoute:
      return _getPageRoute(MyPortfolioView(), settings.name);
    case CreateNewNFTRoute:
      return _getPageRoute(CreateNFTView(), settings.name);
    case SettingsRoute:
      return _getPageRoute(AccountSettingsView(), settings.name);
    case AnalyticsRoute:
      return _getPageRoute(AnalyticsView(), settings.name);
    default:
      return _getPageRoute(HomeView(), settings.name);
  }
}

PageRoute _getPageRoute(Widget child, String routeName) {
  return FadeRoute(child: child, routeName: routeName);
}

class FadeRoute extends PageRouteBuilder {
  final Widget child;
  final String routeName;
  FadeRoute({this.child, this.routeName})
      : super(
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                child,
            transitionDuration: Duration(seconds: 0),
            settings: RouteSettings(name: routeName),
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) =>
                FadeTransition(
                  opacity: animation,
                  child: child,
                ));
}
