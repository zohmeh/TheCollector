import 'package:flutter/material.dart';

raisedButton({BuildContext ctx, String text, Function toDo, List arguments}) {
  return RaisedButton(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
        side: BorderSide(color: Colors.purple)),
    child: Text(text),
    color: Theme.of(ctx).accentColor,
    elevation: 10,
    onPressed: () {
      arguments != null ? toDo(arguments) : toDo();
    },
  );
}
