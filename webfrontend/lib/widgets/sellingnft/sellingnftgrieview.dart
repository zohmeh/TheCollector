import 'dart:convert';
import 'dart:typed_data';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_app_template/widgets/charts/linechart.dart';
import 'package:web_app_template/widgets/useravatar.dart';
import '/provider/contractinteraction.dart';
import '../buttons/button.dart';
import 'package:http/http.dart' as http;

class SellingNFTGridView extends StatefulWidget {
  Map itemdata;

  SellingNFTGridView({this.itemdata});

  @override
  _SellingNFTGridViewState createState() => _SellingNFTGridViewState();
}

class _SellingNFTGridViewState extends State<SellingNFTGridView> {
  Future image;
  Future tokenData;

  Future _getImage() async {
    var data = await http.get(Uri.parse(widget.itemdata["tokenuri"]));
    var jsonData = json.decode(data.body);
    var image = jsonData["file"];
    return image;
  }

  Future _getTokenData() async {
    Map tokenData;
    var data = await http.get(Uri.parse(widget.itemdata["tokenuri"]));
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
        shadowColor: Colors.grey,
        elevation: 10,
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
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Token Id: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  SizedBox(width: 2),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Text(widget.itemdata["tokenId"])),
                ],
              ),
              Row(
                children: [
                  Container(
                    child: Text(
                      "Price in Eth: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 2),
                  Container(
                    child: Text(
                      (double.parse(widget.itemdata["price"]) /
                              1000000000000000000)
                          .toString(),
                    ),
                  ),
                ],
              ),
              Center(
                child: button(
                    Theme.of(context).buttonColor,
                    Theme.of(context).highlightColor,
                    "Buy NFT",
                    Provider.of<Contractinteraction>(context).buyNFT,
                    [widget.itemdata["tokenId"], widget.itemdata["price"]]),
              )
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
                              "Current Owner: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(width: 2),
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Text(
                                    widget.itemdata["userName"],
                                  ),
                                  SizedBox(width: 10),
                                  Useravatar(
                                      image: widget.itemdata["userAvatar"],
                                      width: 25,
                                      height: 25),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "Pricehistory: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 15),
                      widget.itemdata["priceHistory"].length != 0
                          ? Container(
                              height: 200,
                              width: double.infinity,
                              child: LineChartWidget(
                                  prices: widget.itemdata["priceHistory"]))
                          : Container(
                              child: Text("No Pricehistory for this NFT yet")),
                    ]),
              ),
            );
          }
        },
      ),
    );
  }
}
