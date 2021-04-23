import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:js/js_util.dart';
import 'package:provider/provider.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';
import 'package:web_app_template/widgets/ibutton.dart';
import '/provider/contractinteraction.dart';
import '/provider/loginprovider.dart';
import '/routing/route_names.dart';
import '/services/navigation_service.dart';
import '/widgets/button.dart';
import '../../widgets/mynfts/mynftgriddesktop.dart';
import '../../locator.dart';
import '../../widgets/javascript_controller.dart';
import 'package:http/http.dart' as http;

class MyPortfolioDesktopView extends StatefulWidget {
  const MyPortfolioDesktopView({Key key}) : super(key: key);

  @override
  _MyPortfolioDesktopViewState createState() => _MyPortfolioDesktopViewState();
}

class _MyPortfolioDesktopViewState extends State<MyPortfolioDesktopView> {
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
    var result = await promiseToFuture(promise);
    return (result);
  }

  Future<Map<String, dynamic>> _getNFTData() async {
    var myBids = _getMyBids();

    List<dynamic> nftData = [];
    List<dynamic> isAuction = [];
    List<dynamic> isOffer = [];
    List<dynamic> tokenIds = [];

    var myItems = await _getMyItems();

    for (var i = 0; i < myItems.length; i++) {
      var myItemdecoded = json.decode(myItems[i]);
      var promise1 = getAuctionData(myItemdecoded["tokenId"]);
      var auction = await promiseToFuture(promise1);
      isAuction.add(auction[0]);

      var promise2 = getOfferData(myItemdecoded["tokenId"]);
      var offer = await promiseToFuture(promise2);
      isOffer.add(offer[0]);

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

  _changeGlobalSide(List _arguments) {
    locator<NavigationService>().navigateTo(_arguments[0]);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<LoginModel>(context).user;
    Provider.of<Contractinteraction>(context);
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
              ibutton(
                  Icons.gavel_rounded,
                  Theme.of(context).primaryColor,
                  Theme.of(context).highlightColor,
                  "All Auctions",
                  _changeGlobalSide,
                  [HomeRoute, 0]),
              SizedBox(height: 20),
              ibutton(
                  Icons.attach_money_rounded,
                  Theme.of(context).primaryColor,
                  Theme.of(context).highlightColor,
                  "All Sellings",
                  _changeGlobalSide,
                  [AllOffersRoute, 1]),
              SizedBox(height: 20),
              ibutton(
                  Icons.account_balance_wallet_rounded,
                  Theme.of(context).primaryColor,
                  Theme.of(context).accentColor,
                  "My Portfolio",
                  _changeGlobalSide,
                  [MyPortfolioRoute, 2]),
              SizedBox(height: 20),
              ibutton(
                  Icons.create_rounded,
                  Theme.of(context).primaryColor,
                  Theme.of(context).highlightColor,
                  "Create NFT",
                  _changeGlobalSide,
                  [CreateNewNFTRoute, 3]),
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
                                    mainAxisExtent: 510,
                                    maxCrossAxisExtent: 550),
                            itemCount: snapshot.data["tokenId"].length,
                            itemBuilder: (ctx, idx) {
                              return MyNFTGridDesktopView(
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
                )
              : Center(child: Text("Please log in with Metamask")),
        ),
      ],
    );
  }
}
