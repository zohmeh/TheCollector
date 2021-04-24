import 'dart:convert';
import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';
import '/widgets/auctionnft/auctionnftgridmobileview.dart';
import '/provider/loginprovider.dart';
import '/widgets/javascript_controller.dart';

class AllAuctionsMobileView extends StatefulWidget {
  @override
  _AllAuctionsMobileViewState createState() => _AllAuctionsMobileViewState();
}

class _AllAuctionsMobileViewState extends State<AllAuctionsMobileView> {
  ScrollController _scrollController = ScrollController();
  String addresse;

  Future _getNFTData() async {
    var promise = getItemsForAuction();
    var itemsForAuction = await promiseToFuture(promise);
    var itemsForAuctiondecoded = [];

    for (var i = 0; i < itemsForAuction.length; i++) {
      var forSaleItemsdecoded = json.decode(itemsForAuction[i]);
      itemsForAuctiondecoded.add(forSaleItemsdecoded);
    }
    return (itemsForAuctiondecoded);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<LoginModel>(context).user;
    return Expanded(
      child: user != null
          ? VsScrollbar(
              controller: _scrollController,
              showTrackOnHover: true,
              isAlwaysShown: false,
              scrollbarFadeDuration: Duration(milliseconds: 500),
              scrollbarTimeToFade: Duration(milliseconds: 800),
              style: VsScrollbarStyle(
                hoverThickness: 10.0,
                radius: Radius.circular(10),
                thickness: 10.0,
                color: Theme.of(context).highlightColor,
              ),
              child: FutureBuilder(
                future: _getNFTData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.data.length == 0 || snapshot.data == null) {
                      return Center(
                        child: Text("No active Auctions"),
                      );
                    } else {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            mainAxisExtent: 530,
                            maxCrossAxisExtent: 450),
                        itemCount: snapshot.data.length,
                        itemBuilder: (ctx, idx) {
                          return AuctionNFTGridMobileView(
                              auctionData: snapshot.data[idx]);
                        },
                      );
                    }
                  }
                },
              ),
            )
          : Center(child: Text("Please log in with Metamask")),
    );
  }
}
