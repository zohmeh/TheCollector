import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mobile_app_template/providers/blockchain_interaction.dart';
import '../widgets/button.dart';

class AuctionNFTGridView extends StatefulWidget {
  final String id;
  final List<dynamic> image;
  final String button1;
  final Function function1;

  AuctionNFTGridView({this.id, this.image, this.button1, this.function1});

  @override
  _AuctionNFTGridViewState createState() => _AuctionNFTGridViewState();
}

class _AuctionNFTGridViewState extends State<AuctionNFTGridView> {
  double highestBid;

  Future _getAuctionData() async {
    var auctionData =
        await BlockchainInteraction().getAuctionData(widget.id.toString());
    setState(() {
      highestBid = double.parse(auctionData[2].toString());
    });
  }

  @override
  void initState() {
    super.initState();
    _getAuctionData();
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
            Center(
              child: Container(
                height: 89,
                width: 143,
                child: Image.memory(
                  Uint8List.fromList(
                    widget.image.cast<int>(),
                  ),
                  fit: BoxFit.fill,
                ),
              ),
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
                  child: Flexible(
                    child: Text(widget.id.toString()),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  child: Flexible(
                    child: Text(
                      "Highest Bid in Eth: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(width: 2),
                Container(
                    child: Flexible(
                  child: highestBid != null
                      ? Text(
                          (highestBid / 1000000000000000000).toString(),
                        )
                      : Text(
                          ("0"),
                        ),
                )),
              ],
            ),
            Center(
                child: button(
                    Theme.of(context).buttonColor,
                    Theme.of(context).backgroundColor,
                    widget.button1,
                    widget.function1,
                    [widget.id.toString()]))
          ],
        ),
      ),
    );
  }
}
