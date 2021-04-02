import 'dart:convert';
import 'package:intl/intl.dart';
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
  AuctionDetailView({this.id});

  @override
  _AuctionDetailViewState createState() => _AuctionDetailViewState();
}

class _AuctionDetailViewState extends State<AuctionDetailView> {
  var highestBid;
  var highestBidder;
  var auctionEndingFormated;

  Future<Map<String, dynamic>> _getNFTData() async {
    var promise = getTokenHash(widget.id);
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
    String _bidBN = BigInt.from(
            double.parse(widget.bidamountController.text) * 1000000000000000000)
        .toString();
    var promise = bidForNFT(widget.id, _bidBN);
    var bid = await promiseToFuture(promise);

    var promise2 = getAuctionData(widget.id);
    var _auctionData = await promiseToFuture(promise2);
    var _highestbid = _auctionData[1];

    setState(() {
      highestBid = _highestbid;
    });
  }

  Future _sellNFT() async {
    var promise = sellNFT(widget.id, highestBid);
    var sell = await promiseToFuture(promise);
    setState(() {});
  }

  Future _getAuctionData() async {
    var promise = getAuctionData(widget.id);
    var result = await promiseToFuture(promise);
    var auctionEnding =
        DateTime.fromMillisecondsSinceEpoch(int.parse(result[1]) * 1000);
    setState(() {
      highestBid = result[2];
      highestBidder = result[3];
      auctionEndingFormated =
          DateFormat('yyyy-MM-dd - kk:mm').format(auctionEnding);
    });
  }

  @override
  void initState() {
    super.initState();
    _getAuctionData();
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "Token ID: " + widget.id,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 15),
                  Image.memory(
                      Uint8List.fromList(snapshot.data["file"].cast<int>())),
                  SizedBox(height: 15),
                  Center(
                    child: Container(
                      width: 600,
                      child: Table(
                        columnWidths: const <int, TableColumnWidth>{
                          0: IntrinsicColumnWidth()
                        },
                        children: [
                          TableRow(children: [
                            Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text("Name: ",
                                    style: TextStyle(fontSize: 20))),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text(snapshot.data["name"],
                                  style: TextStyle(fontSize: 20)),
                            )
                          ]),
                          TableRow(children: [
                            Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text("Description: ",
                                    style: TextStyle(fontSize: 20))),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text(snapshot.data["description"],
                                  style: TextStyle(fontSize: 20)),
                            )
                          ]),
                          TableRow(children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text("Highest bid in Eth: ",
                                  style: TextStyle(fontSize: 20)),
                            ),
                            double.parse(highestBid) != 0
                                ? Container(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                        ((double.parse(highestBid) /
                                                1000000000000000000))
                                            .toString(),
                                        style: TextStyle(fontSize: 20)),
                                  )
                                : Container(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Text((highestBid),
                                        style: TextStyle(fontSize: 20)),
                                  ),
                          ]),
                          TableRow(children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text("Address highest Bidder: ",
                                  style: TextStyle(fontSize: 20)),
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text((highestBidder),
                                    style: TextStyle(fontSize: 20)))
                          ]),
                          TableRow(children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text("Auction Ending: ",
                                  style: TextStyle(fontSize: 20)),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text(auctionEndingFormated,
                                  style: TextStyle(fontSize: 20)),
                            )
                          ]),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      button(
                          Theme.of(context).buttonColor,
                          Theme.of(context).backgroundColor,
                          "Buy this NFT after Auction ending",
                          _sellNFT),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
