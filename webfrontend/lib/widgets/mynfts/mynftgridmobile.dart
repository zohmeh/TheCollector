import 'dart:js_util';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../button.dart';
import '../inputField.dart';
import '../javascript_controller.dart';

class MyNFTGridMobileView extends StatefulWidget {
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

  MyNFTGridMobileView({
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
  _MyNFTGridMobileViewState createState() => _MyNFTGridMobileViewState();
}

class _MyNFTGridMobileViewState extends State<MyNFTGridMobileView> {
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        shadowColor: Colors.grey,
        elevation: 10,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Center(
              Container(
                height: 125,
                width: 200,
                child: Image.memory(
                  Uint8List.fromList(
                    widget.image.cast<int>(),
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              //),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        "Token Id: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  SizedBox(width: 2),
                  Container(child: Text(widget.id)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "Name: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 2),
                  Container(child: Flexible(child: Text(widget.name))),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "Description: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 2),
                  Container(
                      width: 234,
                      height: 50,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: SingleChildScrollView(
                          child: Text(widget.description))),
                ],
              ),
              widget.isAuction
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            "NFT is in an Auction: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: 2),
                        Container(child: Flexible(child: Text("Yes"))),
                      ],
                    )
                  : //SizedBox(height: 2),
                  widget.isOffer
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                "Direct offer for NTF: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(width: 2),
                            Container(child: Flexible(child: Text("Yes"))),
                          ],
                        )
                      : SizedBox(height: 2),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.isOffer || isOffer
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(height: 50, width: 150),
                            button(
                                Theme.of(context).buttonColor,
                                Theme.of(context).backgroundColor,
                                widget.buttonRemoveOffer,
                                widget.functionRemoveOffer,
                                [widget.id.toString()])
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                              Container(
                                  height: 50,
                                  width: 150,
                                  child: inputField(
                                      ctx: context,
                                      controller:
                                          widget.sellpriceamountController,
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
                                  [widget.id.toString()])
                            ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(width: 150),
                      widget.isAuction
                          ? button(
                              Theme.of(context).buttonColor,
                              Theme.of(context).backgroundColor,
                              widget.buttonRemoveAuction,
                              widget.functionRemoveAuction,
                              [widget.id.toString()])
                          : button(
                              Theme.of(context).buttonColor,
                              Theme.of(context).backgroundColor,
                              widget.buttonStartAuction,
                              widget.functionStartAuction,
                              [widget.id.toString(), "3"]),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
