import 'package:flutter/material.dart';
import './auctiondetailview/auctiondetailmobileview.dart';
import '../responsive.dart';
import './auctiondetailview/auctiondetaildesktopview.dart';

class AuctionDetailView extends StatefulWidget {
  final TextEditingController bidamountController = TextEditingController();
  final id;
  AuctionDetailView({this.id});

  @override
  _AuctionDetailViewState createState() => _AuctionDetailViewState();
}

class _AuctionDetailViewState extends State<AuctionDetailView> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: AuctionDetailMobileView(id: widget.id),
      tablet: AuctionDetailMobileView(id: widget.id),
      desktop: AuctionDetailDesktopView(id: widget.id),
    );
  }
}
