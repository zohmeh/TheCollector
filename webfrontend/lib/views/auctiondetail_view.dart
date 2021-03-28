import 'dart:convert';
import 'dart:js_util';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../widgets/javascript_controller.dart';

class AuctionDetailView extends StatefulWidget {
  final id;
  final highestBid;
  AuctionDetailView({this.id, this.highestBid});

  @override
  _AuctionDetailViewState createState() => _AuctionDetailViewState();
}

class _AuctionDetailViewState extends State<AuctionDetailView> {
  Future<Map<String, dynamic>> _getNFTData() async {
    var promise = getTokenHash(widget.id.toString());
    var tokenHash = await promiseToFuture(promise);
    var data = await http.get(
      Uri.parse(
        tokenHash.toString(),
      ),
    );
    var tokenData = json.decode(data.body);
    return (tokenData);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 10),
        width: MediaQuery.of(context).size.width - 150,
        child: FutureBuilder(
          future: _getNFTData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(
                children: [
                  Center(
                    child: Text(
                      snapshot.data["name"],
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Image.memory(
                      Uint8List.fromList(snapshot.data["file"].cast<int>())),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
