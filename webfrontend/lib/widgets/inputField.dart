import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

inputField(
    {BuildContext ctx,
    TextEditingController controller,
    String labelText,
    double leftMargin,
    double topMargin,
    double rightMargin,
    double bottomMargin,
    FocusNode node1,
    FocusNode node2,
    Function onSubmitted,
    Function onChanged}) {
  return Container(
    margin:
        EdgeInsets.fromLTRB(leftMargin, topMargin, rightMargin, bottomMargin),
    padding: EdgeInsets.all(3),
    decoration: BoxDecoration(
        color: Theme.of(ctx).primaryColor,
        borderRadius: BorderRadius.circular(10)),
    child: TextFormField(
      style: TextStyle(color: Theme.of(ctx).highlightColor),
      keyboardType: TextInputType.text,
      maxLines: null,
      controller: controller,
      focusNode: node2,
      decoration: InputDecoration(
          labelText: labelText,
          labelStyle:
              TextStyle(fontSize: 12, color: Theme.of(ctx).highlightColor)),
      onChanged: (value) {
        onSubmitted(value);
      },
      onFieldSubmitted: (value) {
        onSubmitted(value);
      },
    ),
  );
}
