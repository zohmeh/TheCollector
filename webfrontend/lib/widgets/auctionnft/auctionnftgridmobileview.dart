import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_app_template/helpers/dateconverter.dart';
import 'package:web_app_template/provider/contractinteraction.dart';
import '../button.dart';
import 'package:http/http.dart' as http;
import 'package:flip_card/flip_card.dart';
import '../inputField.dart';

class AuctionNFTGridMobileView extends StatefulWidget {
  final Map auctionData;
  final TextEditingController bidamountController = TextEditingController();

  AuctionNFTGridMobileView({this.auctionData});

  @override
  _AuctionNFTGridMobileViewState createState() =>
      _AuctionNFTGridMobileViewState();
}

class _AuctionNFTGridMobileViewState extends State<AuctionNFTGridMobileView> {
  Future _getImage() async {
    var data = await http.get(Uri.parse(widget.auctionData["tokenuri"]));
    var jsonData = json.decode(data.body);
    var image = jsonData["file"];
    return image;
  }

  Future _getTokenData() async {
    Map tokenData;
    var data = await http.get(Uri.parse(widget.auctionData["tokenuri"]));
    var jsonData = json.decode(data.body);
    tokenData = {
      "name": jsonData["name"],
      "description": jsonData["description"]
    };
    return tokenData;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.auctionData);
    return FlipCard(
      direction: FlipDirection.HORIZONTAL,
      front: Card(
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
                        //fit: BoxFit.fill,
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "Highest Bidder: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 2),
                  Flexible(
                    child: Container(
                      height: 35,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: SingleChildScrollView(
                        child: Text(
                          widget.auctionData["highestBidder"],
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
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
                  Flexible(
                    child: Container(
                      height: 25,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: SingleChildScrollView(
                          child:
                              Text(convertDate(widget.auctionData["ending"]))),
                    ),
                  )
                ],
              ),
              Center(
                child: Column(
                  children: [
                    Container(
                        height: 75,
                        width: 150,
                        child: inputField(
                            ctx: context,
                            controller: widget.bidamountController,
                            labelText: "e.g. 1ETH",
                            leftMargin: 0,
                            topMargin: 0,
                            rightMargin: 0,
                            bottomMargin: 0,
                            onChanged: (_) {
                              setState(() {});
                            },
                            onSubmitted: (_) {
                              setState(() {});
                            })),
                    Container(
                      child: button(
                          Theme.of(context).buttonColor,
                          Theme.of(context).highlightColor,
                          "Place your bid",
                          Provider.of<Contractinteraction>(context).bidForNFT1,
                          [
                            widget.auctionData["tokenId"],
                            widget.bidamountController.text,
                            widget.auctionData["uid"]
                          ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      back: FutureBuilder(
        future: _getTokenData(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else {
            return Card(
              shadowColor: Colors.grey,
              elevation: 10,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "Token Name: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        SizedBox(width: 2),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Text(snapshot.data["name"]),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            "Description: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: 2),
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Text(snapshot.data["description"]),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            "Current User: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: 2),
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Text(widget.auctionData["userName"]),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}