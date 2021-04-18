import 'package:flutter/material.dart';
import 'package:js/js_util.dart';
import '../widgets/javascript_controller.dart';

class Contractinteraction with ChangeNotifier {
  var _tx;

  String get tx {
    return _tx;
  }

  setTxHash() {
    _tx = "pending";
    notifyListeners();
  }

  Future removeAuction1(List arguments) async {
    setTxHash();
    String tokenId = arguments[0];
    var promise = removeAuction(tokenId);
    var remove = await promiseToFuture(promise);
    _tx = remove.toString();
    notifyListeners();
  }

  Future startAuction(List _arguments) async {
    setTxHash();
    String _tokenId = _arguments[0];
    String _duration = _arguments[1];
    var promise = startNewAuction(_tokenId, _duration);
    var start = await promiseToFuture(promise);
    _tx = start.toString();
    notifyListeners();
  }

  Future removeOffer1(List _arguments) async {
    setTxHash();
    String _tokenId = _arguments[0];
    var promise = removeOffer(_tokenId);
    var remove = await promiseToFuture(promise);
    _tx = remove.toString();
    notifyListeners();
  }

  Future startOffer(List _arguments) async {
    setTxHash();
    String _tokenId = _arguments[0];
    String _priceBN =
        BigInt.from(double.parse(_arguments[1]) * 1000000000000000000)
            .toString();
    var promise = startNewOffer(_tokenId, _priceBN);
    var start = await promiseToFuture(promise);
    _tx = start.toString();
    notifyListeners();
  }

  Future buyNFT(List _arguments) async {
    setTxHash();
    var promise = buy(_arguments[0], _arguments[1]);
    var buyNFT = await promiseToFuture(promise);
    _tx = buyNFT.toString();
    notifyListeners();
  }

  Future bidForNFT1(List _arguments) async {
    setTxHash();
    String _bidBN =
        BigInt.from(double.parse(_arguments[1]) * 1000000000000000000)
            .toString();
    var promise = bidForNFT(_arguments[0], _bidBN);
    var bid = await promiseToFuture(promise);
    _tx = bid.toString();
    notifyListeners();
  }

  Future sellNFT1(List _arguments) async {
    setTxHash();
    var promise = sellNFT(_arguments[0], _arguments[1]);
    var sell = await promiseToFuture(promise);
    _tx = sell.toString();
    notifyListeners();
  }
}
