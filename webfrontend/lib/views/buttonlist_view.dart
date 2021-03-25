import 'package:flutter/material.dart';

class ButtonListView extends StatelessWidget {
  var id;
  var anotherParameter;
  ButtonListView({this.id, this.anotherParameter});
  //const ButtonListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('ButtonListView ${id} und ${anotherParameter}'),
    );
  }
}
