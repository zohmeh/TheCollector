import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:js/js_util.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';
import 'package:web_app_template/widgets/MyNFTGridView.dart';
import '../widgets/javascript_controller.dart';
import 'package:http/http.dart' as http;

class Button4View extends StatefulWidget {
  const Button4View({Key key}) : super(key: key);

  @override
  _Button4ViewState createState() => _Button4ViewState();
}

class _Button4ViewState extends State<Button4View> {
  ScrollController _scrollController = ScrollController();

  Future _getMyNFTs() async {
    var promise = getMyTokens();
    var result = await promiseToFuture(promise);
    return (result);
  }

  Future<List> _getNFTData() async {
    var nftHashes = await _getMyNFTs();
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
    return (nftData);
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
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    crossAxisSpacing: 50,
                    mainAxisSpacing: 200,
                    mainAxisExtent: 175,
                    maxCrossAxisExtent: 400),
                itemCount: snapshot.data.length,
                itemBuilder: (ctx, idx) {
                  return MyNFTGridView(
                      name: snapshot.data[idx]["name"],
                      description: snapshot.data[idx]["description"],
                      image: snapshot.data[idx]["file"],
                      button1: "Sell NFT",
                      button2: "Start Auction",
                      button3: "Swap NFT");
                },
              );
            }
          },
        ),
      ),
    );
  }
}
