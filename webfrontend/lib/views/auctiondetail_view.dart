import 'dart:convert';
import 'dart:js_util';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:web_app_template/widgets/button.dart';
import 'package:web_app_template/widgets/inputField.dart';
import '../widgets/javascript_controller.dart';

class AuctionDetailView extends StatefulWidget {
  final TextEditingController bidamountController = TextEditingController();
  final id;
  var highestBid;
  AuctionDetailView({this.id, this.highestBid});

  @override
  _AuctionDetailViewState createState() => _AuctionDetailViewState();
}

class _AuctionDetailViewState extends State<AuctionDetailView> {
  Future<Map<String, dynamic>> _getNFTData() async {
    var promise = getTokenHash(widget.id.toString());
    var tokenHash = await promiseToFuture(promise);
    var data = await http.get(
      Uri.parse(
        tokenHash.toString(),
      ),
    );
    var tokenData = json.decode(data.body);
    return (tokenData);
  }

  Future _bidForNFT() async {
    print(widget.bidamountController.text);
    String _bidBN = BigInt.from(
            double.parse(widget.bidamountController.text) * 1000000000000000000)
        .toString();
    print(_bidBN);
    var promise = bidForNFT(widget.id.toString(), _bidBN);
    var bid = await promiseToFuture(promise);

    var promise2 = gettingHighestBid(widget.id.toString());
    var _higestbid = await promiseToFuture(promise2);

    setState(() {
      widget.highestBid = _higestbid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 10),
        width: MediaQuery.of(context).size.width - 150,
        child: FutureBuilder(
          future: _getNFTData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Token ID: " + widget.id.toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Image.memory(
                      Uint8List.fromList(snapshot.data["file"].cast<int>())),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    width: 500,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Text("Name: ",
                                  style: TextStyle(fontSize: 20)),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Text(snapshot.data["name"],
                                  style: TextStyle(fontSize: 20)),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Text("Description: ",
                                  style: TextStyle(fontSize: 20)),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Text(snapshot.data["description"],
                                  style: TextStyle(fontSize: 20)),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Text("Highest Bid in Eth: ",
                                  style: TextStyle(fontSize: 20)),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: double.parse(widget.highestBid) != 0
                                  ? Text(
                                      ((double.parse(widget.highestBid) /
                                              1000000000000000000))
                                          .toString(),
                                      style: TextStyle(fontSize: 20))
                                  : Text((widget.highestBid),
                                      style: TextStyle(fontSize: 20)),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: button(
                                  Theme.of(context).buttonColor,
                                  Theme.of(context).backgroundColor,
                                  "Place your bid",
                                  _bidForNFT),
                            ),
                            Container(
                                height: 75,
                                width: 150,
                                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: inputField(
                                    ctx: context,
                                    controller: widget.bidamountController,
                                    labelText: "e.g. 1ETH",
                                    leftMargin: 0,
                                    topMargin: 0,
                                    rightMargin: 0,
                                    bottomMargin: 0,
                                    onSubmitted: (_) {}))
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        button(
                            Theme.of(context).buttonColor,
                            Theme.of(context).backgroundColor,
                            "Buy this NFT after Auction ending"),
                        button(
                            Theme.of(context).buttonColor,
                            Theme.of(context).backgroundColor,
                            "Getting back this NFT after Auction ending"),
                      ],
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
