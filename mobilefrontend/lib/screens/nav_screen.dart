import 'package:flutter/material.dart';

class NavScreen extends StatelessWidget {
  static const routeName = '/navscreen';

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context).settings.arguments as List;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          "NavScreen",
          style: TextStyle(color: Theme.of(context).highlightColor),
        ),
      ),
      body: Center(
        child: Text(routeArgs[0]),
      ),
    );
  }
}
