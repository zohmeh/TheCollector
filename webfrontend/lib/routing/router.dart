import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../views/buttonlist_view.dart';
import '../routing/route_names.dart';
import '../views/button3_view.dart';
import '../views/button4_view.dart';
import '../views/createnft_view.dart';
import '../views/home_view.dart';
import '../widgets/string_extensions.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  var routingData = settings.name.getRoutingData;
  switch (routingData.route) {
    case HomeRoute:
      return _getPageRoute(HomeView(), settings.name);
    case Button3Route:
      return _getPageRoute(Button3View(), settings.name);
    case Button4Route:
      return _getPageRoute(Button4View(), settings.name);
    case Button5Route:
      return _getPageRoute(CreateNFTView(), settings.name);
    case ButtonListRoute:
      var id = int.tryParse(routingData['id']);
      var param = int.tryParse(routingData['param']);
      return _getPageRoute(
          ButtonListView(
            id: id,
            anotherParameter: param,
          ),
          settings.name);
    default:
      return _getPageRoute(HomeView(), settings.name);
  }
}

PageRoute _getPageRoute(Widget child, String routeName) {
  return _FadeRoute(child: child, routeName: routeName);
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  final String routeName;
  _FadeRoute({this.child, this.routeName})
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
