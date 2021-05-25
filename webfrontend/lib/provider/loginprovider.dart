import 'package:flutter/material.dart';
import 'package:js/js_util.dart';
import '../widgets/javascript_controller.dart';

class LoginModel with ChangeNotifier {
  var user;
  var image;

  Future logIn() async {
    var promise = login();
    var logIn = await promiseToFuture(promise);
    user = logIn[0];
    image = logIn[1];
    notifyListeners();
  }

  Future logOut() async {
    var promise = logout();
    var loggedOut = await promiseToFuture(promise);
    user = loggedOut;
    notifyListeners();
  }

  Future checkforloggedIn() async {
    var promise = loggedIn();
    var loggedin = await promiseToFuture(promise);
    user = loggedin;
    notifyListeners();
  }

  Future setMyData(List _arguments) async {
    var promise = setUserData(_arguments[0], _arguments[1]);
    await promiseToFuture(promise);
    user = _arguments[1];
    image = _arguments[0];
    await logOut();
    await logIn();
    notifyListeners();
  }
}
