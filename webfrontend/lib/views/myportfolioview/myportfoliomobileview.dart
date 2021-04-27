import 'dart:convert';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:js/js_util.dart';
import 'package:provider/provider.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';
import '/widgets/myBids/myBids.dart';
import '/provider/contractinteraction.dart';
import '/provider/loginprovider.dart';
import '../../widgets/mynfts/mynftgridmobile.dart';
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

  Future _getMyItems() async {
    var promise = getUserItems();
    var result = await promiseToFuture(promise);
    return (result);
  }

  Future _getMyBids() async {
    var promise = getMyBids();
    var mybids = await promiseToFuture(promise);
    var mybidsdecoded = [];
    for (var i = 0; i < mybids.length; i++) {
      var mybiddecoded = json.decode(mybids[i]);
      mybidsdecoded.add(mybiddecoded);
    }
    return mybidsdecoded;
  }

  Future<Map<String, dynamic>> _getNFTData() async {
    var myItems = await _getMyItems();
    List<dynamic> nftData = [];
    List<dynamic> isAuction = [];
    List<dynamic> isOffer = [];
    List<dynamic> tokenIds = [];

    for (var i = 0; i < myItems.length; i++) {
      var myItemdecoded = json.decode(myItems[i]);
      var promise1 = getAuctionItem(myItemdecoded["tokenId"]);
      var auction = await promiseToFuture(promise1);
      auction != null ? isAuction.add(true) : isAuction.add(false);

      var promise2 = getOfferItem(myItemdecoded["tokenId"]);
      var offer = await promiseToFuture(promise2);
      offer != null ? isOffer.add(true) : isOffer.add(false);

      tokenIds.add(myItemdecoded["tokenId"]);

      var data = await http.get(Uri.parse(myItemdecoded["tokenuri"]));
      var jsonData = json.decode(data.body);
      nftData.add(jsonData);
    }
    Map<String, dynamic> nftvalues = {
      "tokenId": tokenIds,
      "isAuction": isAuction,
      "isOffer": isOffer,
      "tokenData": nftData
    };
    return (nftvalues);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<LoginModel>(context).user;
    Provider.of<Contractinteraction>(context);
    return user != null
        ? FlipCard(
            front: VsScrollbar(
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
                            mainAxisExtent: 540,
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
                            functionRemoveOffer:
                                Provider.of<Contractinteraction>(context)
                                    .removeOffer1,
                          );
                        },
                      );
                    }
                  }
                },
              ),
            ),
            back: VsScrollbar(
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
                future: _getMyBids(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.data.length == 0 || snapshot.data == null) {
                      return Center(
                          child: Text("You have no Bids for NFT Autions"));
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (ctx, idx) {
                            return MyBidsList(mybid: snapshot.data[idx]);
                          });
                    }
                  }
                },
              ),
            ))
        : Center(child: Text("Please log in with Metamask"));
  }
}
