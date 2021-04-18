import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:js/js_util.dart';
import 'package:provider/provider.dart';
import '../provider/contractinteraction.dart';
import '../provider/loginprovider.dart';
import 'package:web_app_template/responsive.dart';
import '../services/navigation_service.dart';
import '../views/myportfolioview/myportfoliomobileview.dart';
import '../locator.dart';
import '../widgets/javascript_controller.dart';
import 'package:http/http.dart' as http;
import './myportfolioview/myportfoliodesktopview.dart';

class MyPortfolioView extends StatefulWidget {
  const MyPortfolioView({Key key}) : super(key: key);

  @override
  _MyPortfolioViewState createState() => _MyPortfolioViewState();
}

class _MyPortfolioViewState extends State<MyPortfolioView> {
  ScrollController _scrollController = ScrollController();
  String addresse;
  var user;

  Future _getMyNFTs() async {
    var promise = getMyTokens();
    var result = await promiseToFuture(promise);
    return (result);
  }

  Future<Map<String, dynamic>> _getNFTData() async {
    var myTokens = await _getMyNFTs();
    var myTokensdecoded = json.decode(myTokens);
    var nftHashes = myTokensdecoded["tokenHash"];
    List<dynamic> nftData = [];
    List<dynamic> isAuction = [];
    List<dynamic> isOffer = [];

    for (var j = 0; j < myTokensdecoded["tokenId"].length; j++) {
      var promise1 = getAuctionData(myTokensdecoded["tokenId"][j]);
      var auction = await promiseToFuture(promise1);
      isAuction.add(auction[0]);

      var promise2 = getOfferData(myTokensdecoded["tokenId"][j]);
      var offer = await promiseToFuture(promise2);
      isOffer.add(offer[0]);
    }
    for (var i = 0; i < nftHashes.length; i++) {
      var data = await http.get(
        Uri.parse(
          nftHashes[i].toString(),
        ),
      );
      var jsonData = json.decode(data.body);
      nftData.add(jsonData);
    }
    Map<String, dynamic> nftvalues = {
      "tokenId": myTokensdecoded["tokenId"],
      "isAuction": isAuction,
      "isOffer": isOffer,
      "tokenData": nftData
    };
    return (nftvalues);
  }

  Future _removeOffer(List _arguments) async {
    String _tokenId = _arguments[0];
    var promise = removeOffer(_tokenId);
    await promiseToFuture(promise);
    setState(() {});
  }

  _changeGlobalSide(List _arguments) {
    locator<NavigationService>().navigateTo(_arguments[0]);
  }

  _checkforloggedIn() async {
    var promise = loggedIn();
    var loggedin = await promiseToFuture(promise);
    setState(() {
      addresse = loggedin;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<LoginModel>(context).user;
    Provider.of<Contractinteraction>(context);
    return Responsive(
      mobile: MyPortfolioMobileView(),
      tablet: MyPortfolioMobileView(),
      desktop: MyPortfolioDesktopView(),
    );
  }
}
