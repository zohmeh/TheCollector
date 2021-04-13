import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_app_template/widgets/offergridview.dart';
import '../providers/blockchain_interaction.dart';
import 'package:http/http.dart' as http;

class OffersScreen extends StatefulWidget {
  @override
  _OffersScreenState createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  Future<Map<String, dynamic>> _getNFTData() async {
    var allOffers = await BlockchainInteraction().getAllOffers();
    List activeOffers = [];
    List tokenHashes = [];
    List<dynamic> nftData = [];

    for (var i = 0; i < allOffers.length; i++) {
      if (allOffers[i].toString() != "0") {
        activeOffers.add(allOffers[i]);
      }
    }

    for (var i = 0; i < activeOffers.length; i++) {
      var offerTokenHash = await BlockchainInteraction()
          .getTokenHash(activeOffers[i].toString());
      tokenHashes.add(offerTokenHash);
    }

    for (var i = 0; i < tokenHashes.length; i++) {
      var data = await http.get(
        Uri.parse(
          tokenHashes[i].toString(),
        ),
      );
      var jsonData = json.decode(data.body);
      nftData.add(jsonData);
    }

    Map<String, dynamic> nftvalues = {
      "tokenId": activeOffers,
      "tokenData": nftData
    };

    return (nftvalues);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getNFTData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.data["tokenData"].length == 0 || snapshot.data == null) {
            return Center(
              child: Text("No active SellingsAuctions"),
            );
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  mainAxisExtent: 225,
                  maxCrossAxisExtent: (MediaQuery.of(context).size.width) / 2),
              itemCount: snapshot.data["tokenData"].length,
              itemBuilder: (ctx, idx) {
                return SellingNFTGridView(
                    id: snapshot.data["tokenId"][idx].toString(),
                    image: snapshot.data["tokenData"][idx]["file"]);
              },
            );
          }
        }
      },
    );
  }
}
