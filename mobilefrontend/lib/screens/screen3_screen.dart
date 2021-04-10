import 'package:flutter/material.dart';
import 'package:mobile_app_template/screens/nav_screen.dart';
import '../widgets/raisedButton.dart';

class Screen3 extends StatefulWidget {
  static const routeName = '/screen3';

  @override
  _Screen3State createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  _toDo(_arguments) {
    Navigator.of(_arguments[0])
        .pushNamed(NavScreen.routeName, arguments: [_arguments[1]]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: raisedButton(
            ctx: context,
            text: "Press Button",
            toDo: _toDo,
            arguments: [
              context,
              "Hallo von Screen 3 wird auf NavScreen angezeigt"
            ]),
      ),
    );
  }
}
