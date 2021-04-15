import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:js/js_util.dart';
import 'package:provider/provider.dart';
import 'package:web_app_template/provider/loginprovider.dart';
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
    var loggedOut = await promiseToFuture(promise);
    setState(
      () {
        addresse = null;
        print(loggedOut);
      },
    );
  }

  _checkforloggedIn() async {
    var promise = loggedIn();
    var loggedin = await promiseToFuture(promise);
    setState(() {
      addresse = loggedin;
      print("addresse von navbar");
      print(addresse);
    });
  }

  //@override
  //void initState() {
  //  super.initState();
  //  _checkforloggedIn();
  //}

  @override
  Widget build(BuildContext context) {
    final test = Provider.of<LoginModel>(context);
    final user = test.user;
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
          user != null
              ? Row(
                  children: [
                    Container(
                      child: Text(
                        user.toString(),
                        style: TextStyle(
                            color: Theme.of(context).highlightColor,
                            fontSize: 15),
                      ),
                    ),
                    button(
                        Theme.of(context).buttonColor,
                        Theme.of(context).highlightColor,
                        "LogOut",
                        Provider.of<LoginModel>(context).logOut)
                  ],
                )
              : button(
                  Theme.of(context).buttonColor,
                  Theme.of(context).highlightColor,
                  "LogIn",
                  Provider.of<LoginModel>(context).logIn),
        ],
      ),
    );
  }
}
