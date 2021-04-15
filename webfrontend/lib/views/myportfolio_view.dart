import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:js/js_util.dart';
import 'package:provider/provider.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';
import 'package:web_app_template/provider/loginprovider.dart';
import 'package:web_app_template/routing/route_names.dart';
import 'package:web_app_template/services/navigation_service.dart';
import 'package:web_app_template/widgets/button.dart';
import 'package:web_app_template/widgets/mynftgridview.dart';
import '../locator.dart';
import '../widgets/javascript_controller.dart';
import 'package:http/http.dart' as http;

class MyPortfolioView extends StatefulWidget {
  const MyPortfolioView({Key key}) : super(key: key);

  @override
  _MyPortfolioViewState createState() => _MyPortfolioViewState();
}

class _MyPortfolioViewState extends State<MyPortfolioView> {
  ScrollController _scrollController = ScrollController();
  String addresse;

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

  Future _startAuction(List _arguments) async {
    String _tokenId = _arguments[0];
    String _duration = _arguments[1];
    var promise = startNewAuction(_tokenId, _duration);
    await promiseToFuture(promise);
    setState(() {});
  }

  Future _removeAuction(List _arguments) async {
    String _tokenId = _arguments[0];
    var promise = removeAuction(_tokenId);
    await promiseToFuture(promise);
    setState(() {});
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
  void initState() {
    super.initState();
    _checkforloggedIn();
  }

  @override
  Widget build(BuildContext context) {
    final test = Provider.of<LoginModel>(context);
    final user = test.user;
    return Row(
      children: [
        Container(
          width: 150,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              button(Colors.blueAccent, Theme.of(context).highlightColor,
                  "All Auctions", _changeGlobalSide, [HomeRoute, 0]),
              SizedBox(height: 20),
              button(Colors.blueAccent, Theme.of(context).highlightColor,
                  "All Sellings", _changeGlobalSide, [AllOffersRoute, 1]),
              SizedBox(height: 20),
              button(Colors.purpleAccent, Theme.of(context).highlightColor,
                  "My Portfolio", _changeGlobalSide, [MyPortfolioRoute, 2]),
              SizedBox(height: 20),
              button(Colors.blueAccent, Theme.of(context).highlightColor,
                  "Create New NFT", _changeGlobalSide, [CreateNewNFTRoute, 3]),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width - 150,
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
                          return Center(
                              child: Text("No NFTs in your Portfolio"));
                        } else {
                          return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    crossAxisSpacing: 50,
                                    mainAxisSpacing: 50,
                                    mainAxisExtent: 501,
                                    maxCrossAxisExtent: 405),
                            itemCount: snapshot.data["tokenId"].length,
                            itemBuilder: (ctx, idx) {
                              return MyNFTGridView(
                                  id: snapshot.data["tokenId"][idx],
                                  name: snapshot.data["tokenData"][idx]["name"],
                                  description: snapshot.data["tokenData"][idx]
                                      ["description"],
                                  isAuction: snapshot.data["isAuction"][idx],
                                  isOffer: snapshot.data["isOffer"][idx],
                                  image: snapshot.data["tokenData"][idx]
                                      ["file"],
                                  buttonStartAuction: "Start Auction",
                                  functionStartAuction: _startAuction,
                                  buttonRemoveAuction: "Delete Auction",
                                  functionRemoveAuction: _removeAuction,
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
        ),
      ],
    );
  }
}
