import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:js/js_util.dart';
import 'package:provider/provider.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';
import 'package:web_app_template/widgets/sidebar/sidebardesktop.dart';
import '/widgets/myBids/myBids.dart';
import '/provider/contractinteraction.dart';
import '/provider/loginprovider.dart';
import '../../widgets/mynfts/mynftgriddesktop.dart';
import '../../widgets/javascript_controller.dart';
import 'package:http/http.dart' as http;

class MyPortfolioDesktopView extends StatefulWidget {
  const MyPortfolioDesktopView({Key key}) : super(key: key);

  @override
  _MyPortfolioDesktopViewState createState() => _MyPortfolioDesktopViewState();
}

class _MyPortfolioDesktopViewState extends State<MyPortfolioDesktopView> {
  ScrollController _scrollController = ScrollController();
  var nfts;
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
    List<dynamic> nftData = [];
    List<dynamic> isAuction = [];
    List<dynamic> isOffer = [];
    List<dynamic> tokenIds = [];

    var myItems = await _getMyItems();

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
    nfts = nftvalues;
    return (nftvalues);
  }

  @override
  void initState() {
    super.initState();
    print("Hallo von initState");
    _getNFTData();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<LoginModel>(context).user;
    Provider.of<Contractinteraction>(context);
    return Row(
      children: [
        SidebarDesktop(3),
        user != null
            ? Row(
                children: [
                  Container(
                      padding: EdgeInsets.all(10),
                      //height: double.infinity,
                      width:
                          (MediaQuery.of(context).size.width - 150) * (2 / 3),
                      child:
                          //? nfts != null
                          VsScrollbar(
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
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
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
                                          mainAxisExtent: 530,
                                          maxCrossAxisExtent: 500),
                                  itemCount: nfts["tokenId"].length,
                                  itemBuilder: (ctx, idx) {
                                    return MyNFTGridDesktopView(
                                      id: nfts["tokenId"][idx],
                                      name: nfts["tokenData"][idx]["name"],
                                      description: nfts["tokenData"][idx]
                                          ["description"],
                                      isAuction: nfts["isAuction"][idx],
                                      isOffer: nfts["isOffer"][idx],
                                      image: nfts["tokenData"][idx]["file"],
                                      buttonStartAuction: "Start Auction",
                                      functionStartAuction:
                                          Provider.of<Contractinteraction>(
                                                  context)
                                              .startAuction,
                                      buttonRemoveAuction: "Delete Auction",
                                      functionRemoveAuction:
                                          Provider.of<Contractinteraction>(
                                                  context)
                                              .removeAuction1,
                                      buttonStartOffer: "Sell NFT",
                                      buttonRemoveOffer: "Remove Offer",
                                      functionRemoveOffer:
                                          Provider.of<Contractinteraction>(
                                                  context)
                                              .removeOffer1,
                                    );
                                  },
                                );
                              }
                            }
                          },
                        ),
                      )
                      //: Center(child: Text("No NFT Token in you Portfolio"))
                      ),
                  Container(
                    //height: double.infinity,
                    padding: EdgeInsets.all(10),
                    width: (MediaQuery.of(context).size.width - 150) * (1 / 3),
                    child: VsScrollbar(
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
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            if (snapshot.data.length == 0 ||
                                snapshot.data == null) {
                              return Center(
                                  child:
                                      Text("You have no Bids for NFT Autions"));
                            } else {
                              return ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (ctx, idx) {
                                    return MyBidsList(
                                        mybid: snapshot.data[idx]);
                                  });
                            }
                          }
                        },
                      ),
                    ),
                  )
                ],
              )
            : Container(
                width: (MediaQuery.of(context).size.width - 150),
                child: Center(child: Text("Please log in with Metamask"))),
      ],
    );
  }
}
