import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';
import 'package:provider/provider.dart';
import 'package:web_app_template/widgets/sidebar/sidebardesktop.dart';
import '/provider/contractinteraction.dart';
import '/provider/loginprovider.dart';
import '../../widgets/buttons/button.dart';
import 'package:path/path.dart' as Path;
import '/widgets/inputField.dart';

class CreateNFTDesktopView extends StatefulWidget {
  //const CreateNFTView({Key key}) : super(key: key);
  final TextEditingController nftNameController = TextEditingController();
  final TextEditingController nftDescriptionController =
      TextEditingController();

  @override
  _CreateNFTDesktopViewState createState() => _CreateNFTDesktopViewState();
}

class _CreateNFTDesktopViewState extends State<CreateNFTDesktopView> {
  String _loadedFile;
  var data;
  var _image;
  var name;
  var description;
  var txold;

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

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<LoginModel>(context).user;
    var tx = Provider.of<Contractinteraction>(context).tx;

    if (txold != tx) {
      setState(() {
        txold = tx;
      });
    }
    return Row(
      children: [
        SidebarDesktop(4),
        Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width - 150,
          height: MediaQuery.of(context).size.height,
          child: user != null
              ? Center(
                  child: Card(
                    color: Theme.of(context).primaryColor,
                    //elevation: 10,
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
                                      : Text("No Picture",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .highlightColor)),
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
              : Center(
                  child: Text("Please log in with Metamask",
                      style:
                          TextStyle(color: Theme.of(context).highlightColor))),
        ),
      ],
    );
  }
}
