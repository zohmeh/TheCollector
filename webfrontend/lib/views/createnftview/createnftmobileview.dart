import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:js/js_util.dart';
import 'package:mime_type/mime_type.dart';
import 'package:provider/provider.dart';
import 'package:web_app_template/provider/loginprovider.dart';
import 'package:web_app_template/widgets/button.dart';
import 'package:path/path.dart' as Path;
import 'package:web_app_template/widgets/inputField.dart';
import 'package:web_app_template/widgets/javascript_controller.dart';

class CreateNFTMobileView extends StatefulWidget {
  //const CreateNFTView({Key key}) : super(key: key);
  final TextEditingController nftNameController = TextEditingController();
  final TextEditingController nftDescriptionController =
      TextEditingController();
  final nftName = FocusNode();
  final nftDescription = FocusNode();

  @override
  _CreateNFTMobileViewState createState() => _CreateNFTMobileViewState();
}

class _CreateNFTMobileViewState extends State<CreateNFTMobileView> {
  String _loadedFile;
  var data;
  var _image;

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

  Future _createNewNFT(List _arguments) async {
    var promise = createNewNFT(_arguments[0], widget.nftNameController.text,
        widget.nftDescriptionController.text);
    await promiseToFuture(promise);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<LoginModel>(context).user;
    return user != null
        ? Center(
            child: SingleChildScrollView(
              child: Expanded(
                child: Card(
                  elevation: 10,
                  child: Container(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        button(
                            Theme.of(context).buttonColor,
                            Theme.of(context).highlightColor,
                            "Load Picture",
                            _loadPicture),
                        Container(
                          padding: EdgeInsets.all(2),
                          height: 100,
                          width: 100,
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
                        ),
                        SizedBox(height: 10),
                        Container(
                            width: double.maxFinite,
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
                                  onSubmitted: (_) {}),
                            )),
                        SizedBox(height: 10),
                        Container(
                            width: double.maxFinite,
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
                                  onSubmitted: () {}),
                            )),
                        button(
                          Theme.of(context).buttonColor,
                          Theme.of(context).highlightColor,
                          "Mint your NFT",
                          _createNewNFT,
                          [data],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : Center(child: Text("Please log in with Metamask"));
  }
}
