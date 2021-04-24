import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';
import 'package:provider/provider.dart';
import '/provider/contractinteraction.dart';
import '/provider/loginprovider.dart';
import '/routing/route_names.dart';
import '/services/navigation_service.dart';
import '/widgets/button.dart';
import 'package:path/path.dart' as Path;
import '/widgets/ibutton.dart';
import '/widgets/inputField.dart';
import '/locator.dart';

class CreateNFTDesktopView extends StatefulWidget {
  //const CreateNFTView({Key key}) : super(key: key);
  final TextEditingController nftNameController = TextEditingController();
  final TextEditingController nftDescriptionController =
      TextEditingController();
  final nftName = FocusNode();
  final nftDescription = FocusNode();

  @override
  _CreateNFTDesktopViewState createState() => _CreateNFTDesktopViewState();
}

class _CreateNFTDesktopViewState extends State<CreateNFTDesktopView> {
  String _loadedFile;
  var data;
  var _image;
  var name;
  var description;

  Future _loadPicture() async {
    var mediaData = await ImagePickerWeb.getImageInfo;
    mime(Path.basename(mediaData.fileName));
    setState(
      () {
        if (mediaData.data != null) {
          _image = Image.memory(mediaData.data);
          data = mediaData.data;
          _loadedFile = mediaData.fileName;
        } else {
          print('No image selected.');
        }
      },
    );
  }

  _changeGlobalSide(List _arguments) {
    locator<NavigationService>().navigateTo(_arguments[0]);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<LoginModel>(context).user;
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
                  Theme.of(context).highlightColor,
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
                  Theme.of(context).accentColor,
                  "Create NFT",
                  _changeGlobalSide,
                  [CreateNewNFTRoute, 3]),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width - 150,
          height: MediaQuery.of(context).size.height,
          child: user != null
              ? Center(
                  child: Card(
                    elevation: 10,
                    child: Container(
                      padding: EdgeInsets.all(30),
                      height: 500,
                      width: 500,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              button(
                                  Theme.of(context).buttonColor,
                                  Theme.of(context).highlightColor,
                                  "Load Picture",
                                  _loadPicture),
                              Container(
                                padding: EdgeInsets.all(2),
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                        style: BorderStyle.solid),
                                    bottom: BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                        style: BorderStyle.solid),
                                    left: BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                        style: BorderStyle.solid),
                                    right: BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                        style: BorderStyle.solid),
                                  ),
                                ),
                                child: Center(
                                  child: _loadedFile != null
                                      ? _image
                                      : Text("No Picture"),
                                ),
                              )
                            ],
                          ),
                          Container(
                              //height: 250,
                              width: 250,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      color: Colors.black,
                                      width: 1,
                                      style: BorderStyle.solid),
                                  bottom: BorderSide(
                                      color: Colors.black,
                                      width: 1,
                                      style: BorderStyle.solid),
                                  left: BorderSide(
                                      color: Colors.black,
                                      width: 1,
                                      style: BorderStyle.solid),
                                  right: BorderSide(
                                      color: Colors.black,
                                      width: 1,
                                      style: BorderStyle.solid),
                                ),
                              ),
                              child: Center(
                                child: inputField(
                                    ctx: context,
                                    controller: widget.nftNameController,
                                    labelText: "Give your NFT a Name",
                                    leftMargin: 0,
                                    topMargin: 0,
                                    rightMargin: 0,
                                    bottomMargin: 0,
                                    onChanged: (value) {
                                      setState(() {
                                        name = value;
                                      });
                                    },
                                    onSubmitted: (value) {
                                      setState(() {
                                        name = value;
                                      });
                                    }),
                              )),
                          Container(
                              //height: 250,
                              width: 250,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      color: Colors.black,
                                      width: 1,
                                      style: BorderStyle.solid),
                                  bottom: BorderSide(
                                      color: Colors.black,
                                      width: 1,
                                      style: BorderStyle.solid),
                                  left: BorderSide(
                                      color: Colors.black,
                                      width: 1,
                                      style: BorderStyle.solid),
                                  right: BorderSide(
                                      color: Colors.black,
                                      width: 1,
                                      style: BorderStyle.solid),
                                ),
                              ),
                              child: Center(
                                child: inputField(
                                    ctx: context,
                                    controller: widget.nftDescriptionController,
                                    labelText: "Give your NFT a Description",
                                    leftMargin: 0,
                                    topMargin: 0,
                                    rightMargin: 0,
                                    bottomMargin: 0,
                                    onChanged: (value) {
                                      setState(() {
                                        description = value;
                                      });
                                    },
                                    onSubmitted: (value) {
                                      setState(() {
                                        description = value;
                                      });
                                    }),
                              )),
                          button(
                            Theme.of(context).buttonColor,
                            Theme.of(context).highlightColor,
                            "Mint your NFT",
                            Provider.of<Contractinteraction>(context).createNFT,
                            [data, name, description],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Center(child: Text("Please log in with Metamask")),
        ),
      ],
    );
  }
}
