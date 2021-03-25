import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:js/js_util.dart';
import '../widgets/javascript_controller.dart';
import './button.dart';

class Navbar extends StatefulWidget {
  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  String addresse;

  _logIn() async {
    var promise = login();
    var logIn = await promiseToFuture(promise);
    setState(
      () {
        addresse = logIn;
      },
    );
  }

  _logOut() async {
    var promise = logout();
    await promiseToFuture(promise);
    setState(
      () {
        addresse = null;
      },
    );
  }

  _checkforloggedIn() async {
    var promise = loggedIn();
    var loggedin = await promiseToFuture(promise);
    setState(() {
      addresse = loggedin;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkforloggedIn();
  }

  @override
  Widget build(BuildContext context) {
    final buttoncolors = {
      0: Theme.of(context).buttonColor,
      1: Theme.of(context).buttonColor,
    };
    return Container(
      height: 75,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "The Collector",
            style: TextStyle(
                color: Theme.of(context).highlightColor, fontSize: 30),
          ),
          Row(
            children: [
              addresse != null
                  ? Container(
                      child: Text(
                        addresse,
                        style: TextStyle(
                            color: Theme.of(context).highlightColor,
                            fontSize: 15),
                      ),
                    )
                  : button(buttoncolors[0], Theme.of(context).highlightColor,
                      "LogIn", _logIn),
              SizedBox(width: 20),
              button(buttoncolors[1], Theme.of(context).highlightColor,
                  "LogOut", _logOut)
            ],
          )
        ],
      ),
    );
  }
}
