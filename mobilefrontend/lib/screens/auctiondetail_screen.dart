import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/blockchain_interaction.dart';
import '../widgets/button.dart';
import '../widgets/inputField.dart';
import '../widgets/showupwindow.dart';

class Auctiondetail extends StatefulWidget {
  static const routeName = '/auctiondetail';
  final TextEditingController bidamountController = TextEditingController();

  @override
  _AuctiondetailState createState() => _AuctiondetailState();
}

class _AuctiondetailState extends State<Auctiondetail> {
  var auctionEndingFormated;

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context).settings.arguments as List;
    final _tokenId = routeArgs[0];

    Future<Map<String, dynamic>> _getNFTData() async {
      var tokenHash = await BlockchainInteraction().getTokenHash(_tokenId);
      var data = await http.get(
        Uri.parse(
          tokenHash.toString(),
        ),
      );
      var tokenData = json.decode(data.body);
      var auctionData = await BlockchainInteraction().getAuctionData(_tokenId);

      Map<String, dynamic> auctionvalues = {
        "auctiondata": auctionData,
        "tokenData": tokenData,
      };
      return (auctionvalues);
    }

    Future _bidForNFT() async {
      //var bid = await BlockchainInteraction()
      //    .bidForNFT(_tokenId, widget.bidamountController.text);
      await showUpWindow(
          context,
          BlockchainInteraction()
              .bidForNFT(_tokenId, widget.bidamountController.text),
          "Buying NFT after winning the auction",
          "Your transaction is pending. You can look at it on Etherscan");
      setState(() {});
    }

    Future _sellNFT(List _arguments) async {
      //var sell = await BlockchainInteraction().sellNFT(_tokenId, _arguments[0]);
      await showUpWindow(
          context,
          BlockchainInteraction().sellNFT(_tokenId, _arguments[0]),
          "Buying NFT after winning the auction",
          "Your transaction is pending. You can look at it on Etherscan");
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          "Auctiondetails",
          style: TextStyle(color: Theme.of(context).highlightColor),
        ),
      ),
      body: SingleChildScrollView(
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Token ID: " + _tokenId,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 15),
                    Image.memory(Uint8List.fromList(
                        snapshot.data["tokenData"]["file"].cast<int>())),
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
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    "Name: ",
                                  )),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  snapshot.data["tokenData"]["name"],
                                ),
                              )
                            ]),
                            TableRow(children: [
                              Container(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    "Description: ",
                                  )),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  snapshot.data["tokenData"]["description"],
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
                              double.parse(snapshot.data["auctiondata"][2]
                                          .toString()) !=
                                      0
                                  ? Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: Text(
                                        ((double.parse(snapshot
                                                    .data["auctiondata"][2]
                                                    .toString()) /
                                                1000000000000000000))
                                            .toString(),
                                      ),
                                    )
                                  : Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: Text(
                                        (snapshot.data["auctiondata"][2]
                                            .toString()),
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
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    (snapshot.data["auctiondata"][3]
                                        .toString()),
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
                                  DateFormat('yyyy-MM-dd - kk:mm').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(snapshot.data["auctiondata"]
                                                      [1]
                                                  .toString()) *
                                              1000)),
                                ),
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
                                onSubmitted: null))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        button(
                            Theme.of(context).buttonColor,
                            Theme.of(context).backgroundColor,
                            "Buy this NFT after Auction ending",
                            _sellNFT,
                            [snapshot.data["auctiondata"][2].toString()]),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
