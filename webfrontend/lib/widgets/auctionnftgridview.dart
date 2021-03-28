import 'dart:js_util';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../routing/route_names.dart';
import '../widgets/button.dart';
import '../widgets/javascript_controller.dart';

class AuctionNFTGridView extends StatefulWidget {
  final String id;
  final String name;
  final String description;
  final List<dynamic> image;
  final String button1;
  final Function function1;

  AuctionNFTGridView(
      {this.id,
      this.name,
      this.description,
      this.image,
      this.button1,
      this.function1});

  @override
  _AuctionNFTGridViewState createState() => _AuctionNFTGridViewState();
}

class _AuctionNFTGridViewState extends State<AuctionNFTGridView> {
  var highestBid = "";

  Future _gettingHighestBid() async {
    var promise = gettingHighestBid(widget.id);
    var result = await promiseToFuture(promise);
    setState(() {
      highestBid = result;
    });
  }

  @override
  void initState() {
    super.initState();
    _gettingHighestBid();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.memory(
          Uint8List.fromList(
            widget.image.cast<int>(),
          ),
        ),
        Row(
          children: [
            Container(
                child: Flexible(
              child: Text(
                "Token Id: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
                "Name: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )),
            SizedBox(width: 2),
            Container(child: Flexible(child: Text(widget.name))),
          ],
        ),
        Row(
          children: [
            Container(
                child: Flexible(
              child: Text(
                "Description: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )),
            SizedBox(width: 2),
            Container(child: Flexible(child: Text(widget.description))),
          ],
        ),
        Row(
          children: [
            Container(
                child: Flexible(
              child: Text(
                "Highest Bid: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )),
            SizedBox(width: 2),
            Container(child: Flexible(child: Text(highestBid))),
          ],
        ),
        Row(
          children: [
            Container(
                child: Flexible(
              child: Text(
                "Highest Bidder: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )),
            SizedBox(width: 2),
            Container(child: Flexible(child: Text("Hallo2"))),
          ],
        ),
        Center(
            child: button(
                Theme.of(context).buttonColor,
                Theme.of(context).backgroundColor,
                widget.button1,
                widget.function1, [
          ButtonListRoute,
          widget.id,
          highestBid,
        ]))
      ],
    );
  }
}
