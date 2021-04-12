import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../providers/blockchain_interaction.dart';
import '../screens/auctiondetail_screen.dart';
import '../widgets/auctiongridview.dart';
import 'package:provider/provider.dart';

class Auctions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _changeSide(_arguments) {
      Navigator.of(context)
          .pushNamed(Auctiondetail.routeName, arguments: [_arguments[0]]);
    }

    Future _getAllAuctions() async {
      var allAuctions =
          await Provider.of<BlockchainInteraction>(context, listen: false)
              .getallAuctions();
      List activeAuctions = [];
      List tokenHashes = [];
      List nftData = [];

      for (var i = 0; i < allAuctions.length; i++) {
        if (allAuctions[i].toString() != "0") {
          activeAuctions.add(allAuctions[i]);
        }
      }
      for (var i = 0; i < activeAuctions.length; i++) {
        var hash =
            await Provider.of<BlockchainInteraction>(context, listen: false)
                .getTokenHash(activeAuctions[i].toString());
        tokenHashes.add(hash);
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
        "tokenId": activeAuctions,
        "tokenData": nftData
      };
      return (nftvalues);
    }

    return FutureBuilder(
      future: _getAllAuctions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.data["tokenData"].length == 0 || snapshot.data == null) {
            return Center(
              child: Text("No active Auctions"),
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
                return AuctionNFTGridView(
                  id: snapshot.data["tokenId"][idx].toString(),
                  image: snapshot.data["tokenData"][idx]["file"],
                  button1: "Detail View",
                  function1: _changeSide,
                );
              },
            );
          }
        }
      },
    );
  }
}
