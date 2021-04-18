import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:js_util';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_app_template/provider/contractinteraction.dart';
import '/provider/loginprovider.dart';
import '/widgets/button.dart';
import '/widgets/inputField.dart';
import '/widgets/javascript_controller.dart';

class AuctionDetailMobileView extends StatefulWidget {
  final TextEditingController bidamountController = TextEditingController();
  final id;
  AuctionDetailMobileView({this.id});

  @override
  _AuctionDetailMobileViewState createState() =>
      _AuctionDetailMobileViewState();
}

class _AuctionDetailMobileViewState extends State<AuctionDetailMobileView> {
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
    final user = Provider.of<LoginModel>(context).user;
    final tx = Provider.of<Contractinteraction>(context).tx;
    return user != null
        ? SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10),
              child: FutureBuilder(
                future: _getNFTData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    print(snapshot.data);
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
                        Image.memory(Uint8List.fromList(
                            snapshot.data["file"].cast<int>())),
                        SizedBox(height: 15),
                        Center(
                          child: Container(
                            //width: 600,
                            child: Table(
                              columnWidths: const <int, TableColumnWidth>{
                                0: IntrinsicColumnWidth()
                              },
                              children: [
                                TableRow(children: [
                                  Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: Text(
                                        "Name: ",
                                      )),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      snapshot.data["name"],
                                    ),
                                  )
                                ]),
                                TableRow(children: [
                                  Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: Text(
                                        "Description: ",
                                      )),
                                  Container(
                                    width: 234,
                                    height: 50,
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: SingleChildScrollView(
                                      child: Text(
                                        snapshot.data["description"],
                                      ),
                                    ),
                                  )
                                ]),
                                TableRow(children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      "Highest bid in Eth: ",
                                    ),
                                  ),
                                  double.parse(highestBid) != 0
                                      ? Container(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          child: Text(
                                            ((double.parse(highestBid) /
                                                    1000000000000000000))
                                                .toString(),
                                          ),
                                        )
                                      : Container(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          child: Text(
                                            (highestBid),
                                          ),
                                        ),
                                ]),
                                TableRow(children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      "Address highest Bidder: ",
                                    ),
                                  ),
                                  Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: Text(
                                        (highestBidder),
                                      ))
                                ]),
                                TableRow(children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      "Auction Ending: ",
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      auctionEndingFormated,
                                    ),
                                  )
                                ]),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: 50,
                                width: 150,
                                margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
                                child: inputField(
                                    ctx: context,
                                    controller: widget.bidamountController,
                                    labelText: "e.g. 1ETH",
                                    leftMargin: 0,
                                    topMargin: 0,
                                    rightMargin: 0,
                                    bottomMargin: 0,
                                    onSubmitted: (_) {})),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: button(
                                  Theme.of(context).buttonColor,
                                  Theme.of(context).backgroundColor,
                                  "Place your bid",
                                  Provider.of<Contractinteraction>(context)
                                      .bidForNFT1,
                                  [widget.id, widget.bidamountController.text]),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            button(
                                Theme.of(context).buttonColor,
                                Theme.of(context).backgroundColor,
                                "Buy this NFT after Auction ending",
                                Provider.of<Contractinteraction>(context)
                                    .sellNFT1,
                                [widget.id, highestBid]),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          )
        : Center(child: Text("Please log in with Metamask"));
  }
}
