import 'package:flutter/material.dart';
import 'package:js/js_util.dart';
import '../widgets/javascript_controller.dart';

class LoginModel with ChangeNotifier {
  var _user;

  String get user {
    return _user;
  }

  Future logIn() async {
    var promise = login();
    var logIn = await promiseToFuture(promise);
    _user = logIn;
    notifyListeners();
  }

  Future logOut() async {
    var promise = logout();
    var loggedOut = await promiseToFuture(promise);
    _user = loggedOut;
    notifyListeners();
  }

  Future checkforloggedIn() async {
    var promise = loggedIn();
    var loggedin = await promiseToFuture(promise);
    _user = loggedin;
    notifyListeners();
  }
}
