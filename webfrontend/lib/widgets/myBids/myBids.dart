import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:web_app_template/provider/contractinteraction.dart';
import 'package:web_app_template/widgets/button.dart';
import '/helpers/dateconverter.dart';

class MyBidsList extends StatelessWidget {
  final Map mybid;

  MyBidsList({this.mybid});

  Future _getImage() async {
    var data = await http.get(Uri.parse(mybid["tokenuri"]));
    var jsonData = json.decode(data.body);
    var image = jsonData["file"];
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.grey,
      elevation: 10,
      child: ListTile(
        leading: FutureBuilder(
          future: _getImage(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 20,
                width: 20,
              );
            } else {
              return ClipRRect(
                //radius: 20,
                borderRadius: BorderRadius.circular(80),
                child: Image.memory(
                  Uint8List.fromList(
                    snapshot.data.cast<int>(),
                  ),
                  height: 80,
                  width: 80,
                  fit: BoxFit.fill,
                ),
              );
            }
          },
        ),
        title: Row(
          children: [
            Text(
              "Token ID: ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 10),
            Text(mybid["tokenId"]),
          ],
        ),
        subtitle: Column(
          children: [
            Row(
              children: [
                Text(
                  "Auction Ending: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                Text(convertDate(mybid["ending"])),
              ],
            ),
            Row(
              children: [
                Text("Your actual Bid in Eth: ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                Text((int.parse(mybid["highestBid"]) / 1000000000000000000)
                    .toString())
              ],
            ),
          ],
        ),
        trailing: button(
            Theme.of(context).buttonColor,
            Theme.of(context).highlightColor,
            "Buy NFT after Auction",
            Provider.of<Contractinteraction>(context).sellNFT1,
            [mybid["tokenId"], mybid["highestBid"]]),
      ),
    );
  }
}
