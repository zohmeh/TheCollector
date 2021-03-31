import 'dart:js_util';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../routing/route_names.dart';
import '../widgets/button.dart';
import '../widgets/javascript_controller.dart';

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
    var promise = getAuctionData(widget.id);
    var result = await promiseToFuture(promise);
    setState(() {
      highestBid = double.parse(result[2]);
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
            Container(
              height: 250,
              width: double.infinity,
              child: Image.memory(
                Uint8List.fromList(
                  widget.image.cast<int>(),
                ),
                fit: BoxFit.fill,
              ),
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
                Container(child: Flexible(child: Text(widget.id))),
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
                )),
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
                    [AuctionDetailRoute, widget.id]))
          ],
        ),
      ),
    );
  }
}
