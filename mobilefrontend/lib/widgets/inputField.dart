import 'package:flutter/material.dart';

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
    List arguments}) {
  return Container(
    margin:
        EdgeInsets.fromLTRB(leftMargin, topMargin, rightMargin, bottomMargin),
    padding: EdgeInsets.all(0),
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(10)),
    child: TextFormField(
      keyboardType: TextInputType.text,
      maxLines: null,
      controller: controller,
      focusNode: node2,
      decoration: InputDecoration(
          labelText: labelText, labelStyle: TextStyle(fontSize: 10)),
      onFieldSubmitted: (_) {
        onSubmitted(arguments);
      },
    ),
  );
}
