import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../providers/blockchain_interaction.dart';
import '../widgets/button.dart';

class SellingNFTGridView extends StatefulWidget {
  final String id;
  final List<dynamic> image;

  SellingNFTGridView({this.id, this.image});

  @override
  _SellingNFTGridViewState createState() => _SellingNFTGridViewState();
}

class _SellingNFTGridViewState extends State<SellingNFTGridView> {
  Future _getOfferData() async {
    var offerdata = await BlockchainInteraction().getOfferData(widget.id);
    var _price = offerdata[1];
    return _price;
  }

  Future _buy(List _arguments) async {
    var buy = await BlockchainInteraction().buyNFT(widget.id, _arguments[0]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getOfferData(),
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
                  Container(
                    height: 89,
                    width: 143,
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
                        child: Text(
                          "Price in Eth: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 2),
                      Container(
                        child: Text(
                          (double.parse(snapshot.data.toString()) /
                                  1000000000000000000)
                              .toString(),
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
                      [snapshot.data.toString()],
                    ),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
