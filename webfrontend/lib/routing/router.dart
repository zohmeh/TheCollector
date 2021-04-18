import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../views/auctiondetail_view.dart';
import '../routing/route_names.dart';
import '../views/alloffers_view.dart';
import '../views/myportfolio_view.dart';
import '../views/createnft_view.dart';
import '../views/home_view.dart';
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
    case AuctionDetailRoute:
      var id = routingData['id'];
      return _getPageRoute(
          AuctionDetailView(
            id: id,
          ),
          settings.name);
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
