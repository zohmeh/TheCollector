import 'package:flutter/material.dart';

errorWindow({ctx, String title, dynamic content, Function toDo}) {
  return showDialog(
    context: ctx,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Container(
        child: content.runtimeType == String ? Text(content) : content,
      ),
      actions: [
        FlatButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(ctx).pop();
            if (toDo != null) {
              toDo();
            }
          },
        ),
      ],
    ),
  );
}
