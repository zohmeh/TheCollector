import 'package:flutter/material.dart';

raisedButton({BuildContext ctx, String text, Function toDo, List arguments}) {
  return RaisedButton(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25),
    ),
    child: Text(text),
    color: Theme.of(ctx).buttonColor,
    elevation: 10,
    onPressed: () {
      arguments != null ? toDo(arguments) : toDo();
    },
  );
}
