import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:js/js_util.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';
import 'package:web_app_template/widgets/mynftgridview.dart';
import '../widgets/javascript_controller.dart';
import 'package:http/http.dart' as http;

class MyPortfolioView extends StatefulWidget {
  const MyPortfolioView({Key key}) : super(key: key);

  @override
  _MyPortfolioViewState createState() => _MyPortfolioViewState();
}

class _MyPortfolioViewState extends State<MyPortfolioView> {
  ScrollController _scrollController = ScrollController();

  Future _getMyNFTs() async {
    var promise = getMyTokens();
    var result = await promiseToFuture(promise);
    return (result);
  }

  Future<Map<String, dynamic>> _getNFTData() async {
    var myTokens = await _getMyNFTs();
    var myTokensdecoded = json.decode(myTokens);
    var nftHashes = myTokensdecoded["tokenHash"];
    print(nftHashes);
    List<dynamic> nftData = [];
    List<dynamic> isAuction = [];

    for (var j = 0; j < myTokensdecoded["tokenId"].length; j++) {
      var promise = getAuctionData(myTokensdecoded["tokenId"][j]);
      var auction = await promiseToFuture(promise);
      isAuction.add(auction[0]);
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
      "tokenData": nftData
    };
    return (nftvalues);
    //return (nftData);
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
              if (snapshot.data["tokenId"].length == 0 ||
                  snapshot.data == null) {
                return Center(child: Text("No NFTs in your Portfolio"));
              } else {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      crossAxisSpacing: 50,
                      mainAxisSpacing: 50,
                      mainAxisExtent: 450,
                      maxCrossAxisExtent: 405),
                  itemCount: snapshot.data["tokenData"].length,
                  itemBuilder: (ctx, idx) {
                    return MyNFTGridView(
                        id: snapshot.data["tokenId"][idx],
                        name: snapshot.data["tokenData"][idx]["name"],
                        description: snapshot.data["tokenData"][idx]
                            ["description"],
                        isAuction: snapshot.data["isAuction"][idx],
                        image: snapshot.data["tokenData"][idx]["file"],
                        button1: "Sell NFT",
                        buttonStartAuction: "Start Auction",
                        button3: "Swap NFT",
                        functionStartAuction: _startAuction,
                        buttonRemoveAuction: "Delete Auction",
                        functionRemoveAuction: _removeAuction);
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }
}
