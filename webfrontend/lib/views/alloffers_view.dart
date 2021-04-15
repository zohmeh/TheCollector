import 'dart:convert';
import 'dart:js_util';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';
import 'package:web_app_template/routing/route_names.dart';
import 'package:web_app_template/services/navigation_service.dart';
import 'package:web_app_template/widgets/button.dart';
import '../locator.dart';
import '../widgets/javascript_controller.dart';
import '../widgets/sellingnftgrieview.dart';

class AllOffersView extends StatefulWidget {
  @override
  _AllOffersViewState createState() => _AllOffersViewState();
}

class _AllOffersViewState extends State<AllOffersView> {
  ScrollController _scrollController = ScrollController();

  Future _getOfferNFTs() async {
    var promise = getAllActiveOffers();
    var result = await promiseToFuture(promise);
    return (result);
  }

  Future<Map<String, dynamic>> _getNFTData() async {
    var allOffers = await _getOfferNFTs();
    List activeOffers = [];
    List tokenHashes = [];
    List<dynamic> nftData = [];

    for (var i = 0; i < allOffers.length; i++) {
      if (allOffers[i] != "0") {
        activeOffers.add(allOffers[i]);
      }
    }

    for (var i = 0; i < activeOffers.length; i++) {
      var promise = getTokenHash(activeOffers[i]);
      var offerTokenHashes = await promiseToFuture(promise);
      tokenHashes.add(offerTokenHashes);
    }

    for (var i = 0; i < tokenHashes.length; i++) {
      var data = await http.get(
        Uri.parse(
          tokenHashes[i].toString(),
        ),
      );
      var jsonData = json.decode(data.body);
      nftData.add(jsonData);
    }

    Map<String, dynamic> nftvalues = {
      "tokenId": activeOffers,
      "tokenData": nftData
    };
    return (nftvalues);
  }

  _changeGlobalSide(List _arguments) {
    locator<NavigationService>().navigateTo(_arguments[0]);
  }

  @override
  Widget build(BuildContext context) {
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
              button(Colors.purpleAccent, Theme.of(context).highlightColor,
                  "All Sellings", _changeGlobalSide, [AllOffersRoute, 1]),
              SizedBox(height: 20),
              button(Colors.blueAccent, Theme.of(context).highlightColor,
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
              future: _getNFTData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.data["tokenData"].length == 0 ||
                      snapshot.data == null) {
                    return Center(
                      child: Text("No active SellingsAuctions"),
                    );
                  } else {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          crossAxisSpacing: 50,
                          mainAxisSpacing: 50,
                          mainAxisExtent: 375,
                          maxCrossAxisExtent: 405),
                      itemCount: snapshot.data["tokenData"].length,
                      itemBuilder: (ctx, idx) {
                        return SellingNFTGridView(
                            id: snapshot.data["tokenId"][idx],
                            image: snapshot.data["tokenData"][idx]["file"]);
                      },
                    );
                  }
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
