import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_app_template/helpers/dateconverter.dart';
import 'package:web_app_template/provider/contractinteraction.dart';
import '../../routing/route_names.dart';
import '../button.dart';
import 'package:http/http.dart' as http;

import '../inputField.dart';

class AuctionNFTGridView extends StatefulWidget {
  final Map auctionData;
  final String button1;
  final Function function1;
  final TextEditingController bidamountController = TextEditingController();

  AuctionNFTGridView({this.auctionData, this.button1, this.function1});

  @override
  _AuctionNFTGridViewState createState() => _AuctionNFTGridViewState();
}

class _AuctionNFTGridViewState extends State<AuctionNFTGridView> {
  Future _getImage() async {
    var data = await http.get(Uri.parse(widget.auctionData["tokenuri"]));
    var jsonData = json.decode(data.body);
    var image = jsonData["file"];
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.grey,
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: _getImage(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(height: 245, width: double.infinity);
                } else {
                  return Container(
                    height: 245,
                    width: double.infinity,
                    child: Image.memory(
                      Uint8List.fromList(
                        snapshot.data.cast<int>(),
                      ),
                      fit: BoxFit.fill,
                    ),
                  );
                }
              },
            ),
            Row(
              children: [
                Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "Token Id: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                SizedBox(width: 2),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Text(widget.auctionData["tokenId"]),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "Highest Bid in Eth: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 2),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: widget.auctionData["highestBid"] != null
                      ? Text(
                          (double.parse(widget.auctionData["highestBid"]) /
                                  1000000000000000000)
                              .toString(),
                        )
                      : Text(
                          ("0"),
                        ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "Highest Bidder: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 2),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    widget.auctionData["highestBidder"],
                    style: TextStyle(fontSize: 13),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "Auction Ending: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 2),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Text(convertDate(widget.auctionData["ending"])),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: button(
                      Theme.of(context).buttonColor,
                      Theme.of(context).highlightColor,
                      "Place your bid",
                      Provider.of<Contractinteraction>(context).bidForNFT1, [
                    widget.auctionData["tokenId"],
                    widget.bidamountController.text,
                    widget.auctionData["uid"]
                  ]),
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
                        onSubmitted: (_) {
                          setState(() {});
                        }))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
