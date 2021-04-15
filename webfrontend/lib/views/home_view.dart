import 'dart:convert';
import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';
import 'package:http/http.dart' as http;
import 'package:web_app_template/provider/loginprovider.dart';
import 'package:web_app_template/routing/route_names.dart';
import 'package:web_app_template/widgets/button.dart';
import 'package:web_app_template/widgets/sidebar.dart';
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
  }

  _changeGlobalSide(List _arguments) {
    locator<NavigationService>().navigateTo(_arguments[0]);
  }

  //@override
  //void initState() {
  //  super.initState();
  //  _checkforloggedIn();
  //}

  @override
  Widget build(BuildContext context) {
    final test = Provider.of<LoginModel>(context);
    final user = test.user;
    print(user);
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
              button(Colors.purpleAccent, Theme.of(context).highlightColor,
                  "All Auctions", _changeGlobalSide, [HomeRoute, 0]),
              SizedBox(height: 20),
              button(Colors.blueAccent, Theme.of(context).highlightColor,
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
                                  image: snapshot.data["tokenData"][idx]
                                      ["file"],
                                  button1: "Detail View",
                                  function1: _changeSide);
                            },
                          );
                        }
                      }
                    },
                  ),
                )
              : Center(child: Text("Please log in with Metamask")),
        )
      ],
    );
  }
}
