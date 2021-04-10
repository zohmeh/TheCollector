import 'package:flutter/material.dart';
import '../widgets/inputField.dart';

class Screen2 extends StatefulWidget {
  static const routeName = '/screen2';
  final focusNode1 = FocusNode();
  final focusNode2 = FocusNode();

  final TextEditingController textController1 = TextEditingController();
  final TextEditingController textController2 = TextEditingController();

  @override
  _Screen2State createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  _onSubmitted(_arguments, _value) {
    FocusScope.of(context).requestFocus(_arguments[0]);
    print(_value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          inputField(
              ctx: context,
              controller: widget.textController1,
              labelText: "InputField 1",
              leftMargin: 5,
              topMargin: 5,
              rightMargin: 5,
              bottomMargin: 5,
              node2: widget.focusNode1,
              onSubmitted: _onSubmitted,
              arguments: [widget.focusNode2]),
          inputField(
              ctx: context,
              controller: widget.textController2,
              labelText: "InputField 2",
              leftMargin: 5,
              topMargin: 5,
              rightMargin: 5,
              bottomMargin: 5,
              node2: widget.focusNode2,
              onSubmitted: _onSubmitted,
              arguments: [widget.focusNode2])
        ],
      ),
    );
  }
}
