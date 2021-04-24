import 'dart:convert';
import 'dart:typed_data';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/contractinteraction.dart';
import '../button.dart';
import 'package:http/http.dart' as http;

class SellingNFTGridView extends StatefulWidget {
  Map itemdata;

  SellingNFTGridView({this.itemdata});

  @override
  _SellingNFTGridViewState createState() => _SellingNFTGridViewState();
}

class _SellingNFTGridViewState extends State<SellingNFTGridView> {
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
  Widget build(BuildContext context) {
    print(widget.itemdata);
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
                        fit: BoxFit.fill,
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
                            child: Text(widget.itemdata["userName"]),
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
