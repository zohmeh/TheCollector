import 'package:flutter/material.dart';
import 'createnftmobileview.dart';
import '../../responsive.dart';
import 'createnftdektopview.dart';

class CreateNFTView extends StatefulWidget {
  @override
  _CreateNFTViewState createState() => _CreateNFTViewState();
}

class _CreateNFTViewState extends State<CreateNFTView> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: CreateNFTMobileView(),
        tablet: CreateNFTMobileView(),
        desktop: CreateNFTDesktopView());
  }
}
