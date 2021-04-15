import 'package:flutter/material.dart';
import '../widgets/navbar.dart';

class LayoutTemplate extends StatefulWidget {
  final Widget child;
  const LayoutTemplate({Key key, this.child}) : super(key: key);
  @override
  _LayoutTemplateState createState() => _LayoutTemplateState();
}

class _LayoutTemplateState extends State<LayoutTemplate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Navbar(),
          Expanded(
            child: Row(
              children: [Expanded(child: widget.child)],
            ),
          )
        ],
      ),
    );
  }
}
