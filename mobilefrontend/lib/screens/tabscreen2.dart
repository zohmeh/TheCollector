import 'package:flutter/material.dart';
import '../widgets/raisedButton.dart';
import '../widgets/showupwindow.dart';

class TabScreen2 extends StatelessWidget {
  _toDo(_arguments) {
    showUpWindow(
        context: _arguments[0],
        title: "Title",
        content: "Content showUpWindow",
        toDo: () {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: raisedButton(
          ctx: context,
          text: "Press Button",
          toDo: _toDo,
          arguments: [context]),
    );
  }
}
