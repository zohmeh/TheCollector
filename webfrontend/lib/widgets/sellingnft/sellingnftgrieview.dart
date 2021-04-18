import 'dart:js_util';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../routing/route_names.dart';
import '../button.dart';
import '../javascript_controller.dart';

class SellingNFTGridView extends StatefulWidget {
  final String id;
  final List<dynamic> image;

  SellingNFTGridView({this.id, this.image});

  @override
  _SellingNFTGridViewState createState() => _SellingNFTGridViewState();
}

class _SellingNFTGridViewState extends State<SellingNFTGridView> {
  var price = "0";

  Future _getOfferData() async {
    var promise = getOfferData(widget.id);
    var result = await promiseToFuture(promise);
    var _price = result[1];
    setState(() {
      price = _price;
    });
  }

  Future _buy() async {
    var promise = buy(widget.id, price);
    await promiseToFuture(promise);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getOfferData();
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
              height: 245,
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
                Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(widget.id)),
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
                    (double.parse(price) / 1000000000000000000).toString(),
                  ),
                ),
              ],
            ),
            Center(
                child: button(
              Theme.of(context).buttonColor,
              Theme.of(context).backgroundColor,
              "Buy NFT",
              _buy,
            ))
          ],
        ),
      ),
    );
  }
}
