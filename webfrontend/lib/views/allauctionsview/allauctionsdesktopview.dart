import 'dart:convert';
import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';
import 'package:web_app_template/widgets/sidebar/sidebardesktop.dart';
import '/provider/contractinteraction.dart';
import '/provider/loginprovider.dart';
import '../../widgets/auctionnft/auctionnftgriddesktopview.dart';
import '/widgets/javascript_controller.dart';

class AllAuctionsDesktopView extends StatefulWidget {
  @override
  _AllAuctionsDesktopViewState createState() => _AllAuctionsDesktopViewState();
}

class _AllAuctionsDesktopViewState extends State<AllAuctionsDesktopView> {
  ScrollController _scrollController = ScrollController();
  Future auctionNFTs;

  Future _getItemsForAuction() async {
    var promise = getItemsForAuction();
    var result = await promiseToFuture(promise);
    return (result);
  }

  Future _getPriceHistory(String _tokenId) async {
    var promise = getPriceHistory(_tokenId);
    var result = await promiseToFuture(promise);
    return (result);
  }

  Future _getNFTData() async {
    var items = await _getItemsForAuction();
    var itemsdecoded = [];

    for (var i = 0; i < items.length; i++) {
      var forAuctionItemsdecoded = json.decode(items[i]);
      var priceHistory =
          await _getPriceHistory(forAuctionItemsdecoded["tokenId"]);
      forAuctionItemsdecoded["priceHistory"] = priceHistory;
      itemsdecoded.add(forAuctionItemsdecoded);
    }
    return (itemsdecoded);
  }

  @override
  void initState() {
    auctionNFTs = _getNFTData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<LoginModel>(context).user;
    var tx = Provider.of<Contractinteraction>(context).tx;

    if (tx == "true") {
      setState(() {
        auctionNFTs = _getNFTData();
      });
    }
    return Row(
      children: [
        SidebarDesktop(1),
        Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width - 150,
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
                    future: auctionNFTs,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (snapshot.data.length == 0 ||
                            snapshot.data == null) {
                          return Center(
                            child: Text("No active Auctions",
                                style: TextStyle(
                                    color: Theme.of(context).highlightColor)),
                          );
                        } else {
                          return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    crossAxisSpacing: 0,
                                    mainAxisSpacing: 0,
                                    mainAxisExtent: 530,
                                    maxCrossAxisExtent: 500),
                            itemCount: snapshot.data.length,
                            itemBuilder: (ctx, idx) {
                              return AuctionNFTGridDesktopView(
                                  auctionData: snapshot.data[idx]);
                            },
                          );
                        }
                      }
                    },
                  ),
                )
              : Center(
                  child: Text("Please log in with Metamask",
                      style:
                          TextStyle(color: Theme.of(context).highlightColor))),
        )
      ],
    );
  }
}
