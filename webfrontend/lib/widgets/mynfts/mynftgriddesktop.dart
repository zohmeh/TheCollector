import 'dart:js_util';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../button.dart';
import '../inputField.dart';
import '../javascript_controller.dart';

class MyNFTGridDesktopView extends StatefulWidget {
  final TextEditingController sellpriceamountController =
      TextEditingController();

  final String id;
  final String name;
  final String description;
  final bool isAuction;
  final bool isOffer;
  final List<dynamic> image;
  final String buttonStartOffer;
  final String buttonRemoveOffer;
  final String buttonStartAuction;
  final Function functionStartAuction;
  final String buttonRemoveAuction;
  final Function functionRemoveAuction;
  final Function functionRemoveOffer;

  MyNFTGridDesktopView({
    this.id,
    this.name,
    this.description,
    this.isAuction,
    this.isOffer,
    this.image,
    this.buttonStartAuction,
    this.functionStartAuction,
    this.buttonRemoveAuction,
    this.functionRemoveAuction,
    this.buttonStartOffer,
    this.buttonRemoveOffer,
    this.functionRemoveOffer,
  });

  @override
  _MyNFTGridDesktopViewState createState() => _MyNFTGridDesktopViewState();
}

class _MyNFTGridDesktopViewState extends State<MyNFTGridDesktopView> {
  bool isOffer = false;

  Future _startOffer(List _arguments) async {
    String _tokenId = _arguments[0];
    String _priceBN = BigInt.from(
            double.parse(widget.sellpriceamountController.text) *
                1000000000000000000)
        .toString();
    var promise = startNewOffer(_tokenId, _priceBN);
    await promiseToFuture(promise);
    setState(() {
      isOffer = true;
    });
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
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "Token Id: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                SizedBox(width: 2),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Text(widget.id)),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "Name: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 2),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Text(widget.name)),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.red,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "Description: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 2),
                Container(
                    color: Colors.red,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    width: 275,
                    height: 64,
                    child:
                        SingleChildScrollView(child: Text(widget.description))),
              ],
            ),
            widget.isAuction
                ? Row(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "NFT is in an Auction: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 2),
                      Container(child: Text("Yes")),
                    ],
                  )
                : //SizedBox(height: 25),
                widget.isOffer
                    ? Row(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "Direct offer for NTF: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(width: 2),
                          Container(child: Text("Yes")),
                        ],
                      )
                    : SizedBox(height: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.isOffer || isOffer
                    ? button(
                        Theme.of(context).buttonColor,
                        Theme.of(context).backgroundColor,
                        widget.buttonRemoveOffer,
                        widget.functionRemoveOffer,
                        [widget.id])
                    : Row(children: [
                        Container(
                            height: 75,
                            width: 150,
                            child: inputField(
                                ctx: context,
                                controller: widget.sellpriceamountController,
                                labelText: "Selling Price e.g. 1ETH",
                                leftMargin: 0,
                                topMargin: 0,
                                rightMargin: 0,
                                bottomMargin: 0,
                                onSubmitted: (_) {})),
                        button(
                            Theme.of(context).buttonColor,
                            Theme.of(context).backgroundColor,
                            "Start Offer",
                            _startOffer,
                            [widget.id])
                      ]),
                widget.isAuction
                    ? button(
                        Theme.of(context).buttonColor,
                        Theme.of(context).backgroundColor,
                        widget.buttonRemoveAuction,
                        widget.functionRemoveAuction,
                        [widget.id])
                    : button(
                        Theme.of(context).buttonColor,
                        Theme.of(context).backgroundColor,
                        widget.buttonStartAuction,
                        widget.functionStartAuction,
                        [widget.id, "3"]),
              ],
            )
          ],
        ),
      ),
    );
  }
}
