import 'dart:convert';
import 'dart:js_util';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';
import 'package:http/http.dart' as http;
import 'package:web_app_template/provider/contractinteraction.dart';
import '/provider/loginprovider.dart';
import '/routing/route_names.dart';
import '../../widgets/auctionnft/auctionnftgridview.dart';
import '/widgets/button.dart';
import '/widgets/ibutton.dart';
import '/widgets/javascript_controller.dart';
import '/services/navigation_service.dart';
import '/locator.dart';

class AllAuctionsDesktopView extends StatefulWidget {
  @override
  _AllAuctionsDesktopViewState createState() => _AllAuctionsDesktopViewState();
}

class _AllAuctionsDesktopViewState extends State<AllAuctionsDesktopView> {
  ScrollController _scrollController = ScrollController();
  String addresse;

  _changeSide(List _arguments) {
    locator<NavigationService>().navigateTo(_arguments[0], queryParams: {
      "id": _arguments[1].toString(),
    });
  }

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

  _changeGlobalSide(List _arguments) {
    locator<NavigationService>().navigateTo(_arguments[0]);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<LoginModel>(context).user;
    Provider.of<Contractinteraction>(context).tx;
    return Row(
      children: [
        Container(
          width: 150,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              ibutton(
                  Icons.gavel_rounded,
                  Theme.of(context).primaryColor,
                  Theme.of(context).accentColor,
                  "All Auctions",
                  _changeGlobalSide,
                  [HomeRoute, 0]),
              SizedBox(height: 20),
              ibutton(
                  Icons.attach_money_rounded,
                  Theme.of(context).primaryColor,
                  Theme.of(context).highlightColor,
                  "All Sellings",
                  _changeGlobalSide,
                  [AllOffersRoute, 1]),
              SizedBox(height: 20),
              ibutton(
                  Icons.account_balance_wallet_rounded,
                  Theme.of(context).primaryColor,
                  Theme.of(context).highlightColor,
                  "My Portfolio",
                  _changeGlobalSide,
                  [MyPortfolioRoute, 2]),
              SizedBox(height: 20),
              ibutton(
                  Icons.create_rounded,
                  Theme.of(context).primaryColor,
                  Theme.of(context).highlightColor,
                  "Create NFT",
                  _changeGlobalSide,
                  [CreateNewNFTRoute, 3]),
            ],
          ),
        ),
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
                    future: _getNFTData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (snapshot.data.length == 0 ||
                            snapshot.data == null) {
                          return Center(
                            child: Text("No active Auctions"),
                          );
                        } else {
                          return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    crossAxisSpacing: 50,
                                    mainAxisSpacing: 50,
                                    mainAxisExtent: 500,
                                    maxCrossAxisExtent: 450),
                            itemCount: snapshot.data.length,
                            itemBuilder: (ctx, idx) {
                              return AuctionNFTGridView(
                                  auctionData: snapshot.data[idx],
                                  button1: "Detail View",
                                  function1: _changeSide);
                            },
                          );
                        }
                      }
                    },
                  ),
                )
              : Center(child: Text("Please log in with Metamask")),
        )
      ],
    );
  }
}
