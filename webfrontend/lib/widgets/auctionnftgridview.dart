import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:web_app_template/routing/route_names.dart';
import 'package:web_app_template/widgets/button.dart';

class AuctionNFTGridView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.memory(
              Uint8List.fromList(
                image.cast<int>(),
              ),
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
              Container(child: Flexible(child: Text(id))),
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
              Container(child: Flexible(child: Text(name))),
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
              Container(child: Flexible(child: Text(description))),
            ],
          ),
          button(
              Theme.of(context).buttonColor,
              Theme.of(context).backgroundColor,
              button1,
              function1,
              [ButtonListRoute, id, name])
        ],
      ),
    );
  }
}
