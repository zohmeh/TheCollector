import 'package:flutter/material.dart';
import 'package:js/js_util.dart';
import '../widgets/javascript_controller.dart';

class Contractinteraction with ChangeNotifier {
  var _tx;

  String get tx {
    return _tx;
  }

  Future removeAuction1(List arguments) async {
    _tx = "pending";
    String tokenId = arguments[0];
    var promise = removeAuction(tokenId);
    var remove = await promiseToFuture(promise);
    _tx = remove;
    notifyListeners();
  }

  Future startAuction(List _arguments) async {
    _tx = "pending";
    String _tokenId = _arguments[0];
    String _duration = _arguments[1];
    var promise = startNewAuction(_tokenId, _duration);
    var start = await promiseToFuture(promise);
    _tx = start;
    notifyListeners();
  }
}
