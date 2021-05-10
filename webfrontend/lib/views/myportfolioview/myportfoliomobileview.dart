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
  Future myNFTs;
  Future myBids;

  Future _getMyTokenBalance() async {
    var promise = getBalance();
    var result = await promiseToFuture(promise);
    return (result);
  }

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

  Future _portfolioData() async {
    var balance = await _getMyTokenBalance();

    List<dynamic> _myNFTs = [];
    var myItems = await _getMyItems();

    for (var i = 0; i < myItems.length; i++) {
      var myItemdecoded = json.decode(myItems[i]);

      var promise0 = getPriceHistory(myItemdecoded["token_id"]);
      var prices = await promiseToFuture(promise0);

      myItemdecoded["priceHistory"] = prices;

      var promise1 = getAuctionItem(myItemdecoded["token_id"]);
      var auction = await promiseToFuture(promise1);

      auction == null
          ? myItemdecoded["isAuction"] = false
          : myItemdecoded["isAuction"] = true;

      var promise2 = getOfferItem(myItemdecoded["token_id"]);
      var offer = await promiseToFuture(promise2);

      offer == null
          ? myItemdecoded["isOffer"] = false
          : myItemdecoded["isOffer"] = true;

      var data = await http.get(Uri.parse(myItemdecoded["token_uri"]));
      var jsonData = json.decode(data.body);

      myItemdecoded["name"] = jsonData["name"];
      myItemdecoded["description"] = jsonData["description"];
      myItemdecoded["file"] = jsonData["file"];

      _myNFTs.add(myItemdecoded);
    }
    return ([_myNFTs, balance]);
  }

  @override
  void initState() {
    myNFTs = _portfolioData();
    myBids = _getMyBids();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<LoginModel>(context).user;
    var tx = Provider.of<Contractinteraction>(context).tx;

    if (tx == "true") {
      setState(() {
        myNFTs = _portfolioData();
        myBids = _getMyBids();
      });
    }
    return user != null
        ? FlipCard(
            front:

                /*VsScrollbar(
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
              child: 
              */
                FutureBuilder(
              future: myNFTs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.data[0].length == 0 ||
                      snapshot.data[0] == null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("CollectorToken Balance: " + snapshot.data[1],
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).highlightColor)),
                        Text("No NFTs in your Portfolio",
                            style: TextStyle(
                                color: Theme.of(context).highlightColor)),
                      ],
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("CollectorToken Balance: " + snapshot.data[1],
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).highlightColor)),
                        SizedBox(height: 10),
                        Flexible(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    crossAxisSpacing: 0,
                                    mainAxisSpacing: 0,
                                    mainAxisExtent: 820,
                                    maxCrossAxisExtent: double.maxFinite),
                            itemCount: snapshot.data[0].length,
                            itemBuilder: (ctx, idx) {
                              return MyNFTGridMobileView(
                                myNFT: snapshot.data[0][idx],
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
                          ),
                        ),
                      ],
                    );
                  }
                }
              },
            ),
            //),
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
                future: myBids,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.data.length == 0 || snapshot.data == null) {
                      return Center(
                          child: Text("You have no Bids for NFT Auctions",
                              style: TextStyle(
                                  color: Theme.of(context).highlightColor)));
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
        : Center(
            child: Text("Please log in with Metamask",
                style: TextStyle(color: Theme.of(context).highlightColor)));
  }
}
