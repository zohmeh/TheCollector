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
  String addresse;

  _checkforloggedIn() async {
    var promise = loggedIn();
    var loggedin = await promiseToFuture(promise);
    setState(() {
      addresse = loggedin;
    });
  }

  _changeSide(List _arguments) {
    locator<NavigationService>().navigateTo(_arguments[0],
        queryParams: {"id": _arguments[1].toString()});
  }

  Future _getAuctionNFTs() async {
    var promise = getAllActiveAuctions();
    var result = await promiseToFuture(promise);
    print(result);
    return (result);
  }

  Future<Map<String, dynamic>> _getNFTData() async {
    var allAuctions = await _getAuctionNFTs();
    List activeAuctions = [];
    List tokenHashes = [];
    List<dynamic> nftData = [];

    for (var i = 0; i < allAuctions.length; i++) {
      if (allAuctions[i] != "0") {
        activeAuctions.add(allAuctions[i]);
      }
    }

    for (var i = 0; i < activeAuctions.length; i++) {
      var promise = getTokenHash(activeAuctions[i]);
      var auctionTokenHashes = await promiseToFuture(promise);
      tokenHashes.add(auctionTokenHashes);
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
      "tokenId": activeAuctions,
      "tokenData": nftData
    };
    return (nftvalues);
    //return (nftData);
  }

  @override
  void initState() {
    super.initState();
    _checkforloggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width - 150,
      child: addresse != null
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
                      if (snapshot.data["tokenData"].length == 0 ||
                          snapshot.data == null) {
                        return Center(
                          child: Text("No active Auctions"),
                        );
                      } else {
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  crossAxisSpacing: 50,
                                  mainAxisSpacing: 50,
                                  mainAxisExtent: 375,
                                  maxCrossAxisExtent: 405),
                          itemCount: snapshot.data["tokenData"].length,
                          itemBuilder: (ctx, idx) {
                            return AuctionNFTGridView(
                                id: snapshot.data["tokenId"][idx],
                                image: snapshot.data["tokenData"][idx]["file"],
                                button1: "Detail View",
                                function1: _changeSide);
                          },
                        );
                      }
                    }
                  }),
            )
          : Center(child: Text("Please log in with Metamask")),
    );
  }
}
