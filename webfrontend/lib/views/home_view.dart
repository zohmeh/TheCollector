import 'dart:convert';
import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';
import 'package:http/http.dart' as http;
import '../widgets/auctionnftgridview.dart';
import '../widgets/javascript_controller.dart';
import '../services/navigation_service.dart';
import '../locator.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  ScrollController _scrollController = ScrollController();

  _changeSide(List _arguments) {
    locator<NavigationService>().navigateTo(_arguments[0], queryParams: {
      "id": _arguments[1].toString(),
      "highestBid": _arguments[2]
    });
  }

  Future _getAuctionNFTs() async {
    var promise = getAuctionTokens();
    var result = await promiseToFuture(promise);
    return (result);
  }

  Future<Map<String, dynamic>> _getNFTData() async {
    var myTokens = await _getAuctionNFTs();
    var myTokensdecoded = json.decode(myTokens);
    var nftHashes = myTokensdecoded["tokenHash"];
    List<dynamic> nftData = [];

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
      "tokenData": nftData
    };
    return (nftvalues);
    //return (nftData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    child: Text("No active Auctions"),
                  );
                } else {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        crossAxisSpacing: 50,
                        mainAxisSpacing: 200,
                        mainAxisExtent: 400,
                        maxCrossAxisExtent: 400),
                    itemCount: snapshot.data["tokenData"].length,
                    itemBuilder: (ctx, idx) {
                      return AuctionNFTGridView(
                          id: snapshot.data["tokenId"][idx],
                          name: snapshot.data["tokenData"][idx]["name"],
                          description: snapshot.data["tokenData"][idx]
                              ["description"],
                          image: snapshot.data["tokenData"][idx]["file"],
                          button1: "Detail View",
                          function1: _changeSide);
                    },
                  );
                }
              }
            }),
      ),
    );
  }
}
