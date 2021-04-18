import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:js/js_util.dart';
import 'package:provider/provider.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';
import '/provider/contractinteraction.dart';
import '/provider/loginprovider.dart';
import '/services/navigation_service.dart';
import '../../widgets/mynfts/mynftgridmobile.dart';
import '../../locator.dart';
import '../../widgets/javascript_controller.dart';
import 'package:http/http.dart' as http;

class MyPortfolioMobileView extends StatefulWidget {
  const MyPortfolioMobileView({Key key}) : super(key: key);

  @override
  _MyPortfolioMobileViewState createState() => _MyPortfolioMobileViewState();
}

class _MyPortfolioMobileViewState extends State<MyPortfolioMobileView> {
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
    return Expanded(
      child: user != null
          ? VsScrollbar(
              controller: _scrollController,
              showTrackOnHover: true,
              isAlwaysShown: false,
              scrollbarFadeDuration: Duration(milliseconds: 500),
              scrollbarTimeToFade: Duration(milliseconds: 800),
              style: VsScrollbarStyle(
                hoverThickness: 10.0,
                radius: Radius.circular(10),
                thickness: 10.0,
                color: Theme.of(context).highlightColor,
              ),
              child: FutureBuilder(
                future: _getNFTData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.data["tokenId"].length == 0 ||
                        snapshot.data == null) {
                      return Center(child: Text("No NFTs in your Portfolio"));
                    } else {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            mainAxisExtent: 400,
                            maxCrossAxisExtent: double.maxFinite),
                        itemCount: snapshot.data["tokenId"].length,
                        itemBuilder: (ctx, idx) {
                          return MyNFTGridMobileView(
                              id: snapshot.data["tokenId"][idx],
                              name: snapshot.data["tokenData"][idx]["name"],
                              description: snapshot.data["tokenData"][idx]
                                  ["description"],
                              isAuction: snapshot.data["isAuction"][idx],
                              isOffer: snapshot.data["isOffer"][idx],
                              image: snapshot.data["tokenData"][idx]["file"],
                              buttonStartAuction: "Start Auction",
                              functionStartAuction:
                                  Provider.of<Contractinteraction>(context)
                                      .startAuction,
                              buttonRemoveAuction: "Delete Auction",
                              functionRemoveAuction:
                                  Provider.of<Contractinteraction>(context)
                                      .removeAuction1,
                              buttonStartOffer: "Sell NFT",
                              buttonRemoveOffer: "Remove Offer",
                              functionRemoveOffer: _removeOffer);
                        },
                      );
                    }
                  }
                },
              ),
            )
          : Center(child: Text("Please log in with Metamask")),
    );
  }
}
