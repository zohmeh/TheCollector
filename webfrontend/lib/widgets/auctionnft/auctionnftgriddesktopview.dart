import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_app_template/helpers/dateconverter.dart';
import 'package:web_app_template/provider/contractinteraction.dart';
import 'package:web_app_template/widgets/charts/linechart.dart';
import 'package:web_app_template/widgets/useravatar.dart';
import '../buttons/button.dart';
import 'package:http/http.dart' as http;
import 'package:flip_card/flip_card.dart';
import '../inputField.dart';

class AuctionNFTGridDesktopView extends StatefulWidget {
  final Map auctionData;
  final TextEditingController bidamountController = TextEditingController();

  AuctionNFTGridDesktopView({this.auctionData});

  @override
  _AuctionNFTGridDesktopViewState createState() =>
      _AuctionNFTGridDesktopViewState();
}

class _AuctionNFTGridDesktopViewState extends State<AuctionNFTGridDesktopView> {
  Future image;
  Future tokenData;

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
  void initState() {
    image = _getImage();
    tokenData = _getTokenData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      direction: FlipDirection.HORIZONTAL,
      front: Card(
        color: Theme.of(context).primaryColor,
        //shadowColor: Colors.grey,
        //elevation: 10,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: image,
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(height: 245, width: double.infinity);
                  } else {
                    return Container(
                      height: 250,
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).highlightColor),
                      )),
                  SizedBox(width: 2),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Text(widget.auctionData["tokenId"],
                        style:
                            TextStyle(color: Theme.of(context).highlightColor)),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "Highest Bid in Eth: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).highlightColor),
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
                            style: TextStyle(
                                color: Theme.of(context).highlightColor))
                        : Text("0",
                            style: TextStyle(
                                color: Theme.of(context).highlightColor)),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "Highest Bidder: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).highlightColor),
                    ),
                  ),
                  SizedBox(width: 2),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        widget.auctionData["highestBidder"],
                        style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).highlightColor),
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
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).highlightColor),
                    ),
                  ),
                  SizedBox(width: 2),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Text(convertDate(widget.auctionData["ending"]),
                        style:
                            TextStyle(color: Theme.of(context).highlightColor)),
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
                          onChanged: (_) {
                            setState(() {});
                          },
                          onSubmitted: (_) {
                            setState(() {});
                          }))
                ],
              ),
            ],
          ),
        ),
      ),
      back: FutureBuilder(
        future: tokenData,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else {
            return Card(
              color: Theme.of(context).primaryColor,
              //shadowColor: Colors.grey,
              //elevation: 10,
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
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).highlightColor),
                            )),
                        SizedBox(width: 2),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Text(snapshot.data["name"],
                              style: TextStyle(
                                  color: Theme.of(context).highlightColor)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            "Description: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).highlightColor),
                          ),
                        ),
                        SizedBox(width: 2),
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Text(snapshot.data["description"],
                                style: TextStyle(
                                    color: Theme.of(context).highlightColor)),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            "Current Owner: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).highlightColor),
                          ),
                        ),
                        SizedBox(width: 2),
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                SingleChildScrollView(
                                    child: Text(widget.auctionData["userName"],
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .highlightColor))),
                                SizedBox(width: 10),
                                Useravatar(
                                    image: widget.auctionData["userAvatar"],
                                    width: 25,
                                    height: 25)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        "Pricehistory: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).highlightColor),
                      ),
                    ),
                    SizedBox(height: 15),
                    widget.auctionData["priceHistory"].length != 0
                        ? Container(
                            height: 200,
                            width: double.infinity,
                            child: LineChartWidget(
                                prices: widget.auctionData["priceHistory"]))
                        : Container(
                            child: Text("No Pricehistory for this NFT yet",
                                style: TextStyle(
                                    color: Theme.of(context).highlightColor))),
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
