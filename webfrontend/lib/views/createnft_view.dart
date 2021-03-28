import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:js/js_util.dart';
import 'package:mime_type/mime_type.dart';
import 'package:web_app_template/widgets/button.dart';
import 'package:path/path.dart' as Path;
import 'package:web_app_template/widgets/inputField.dart';
import 'package:web_app_template/widgets/javascript_controller.dart';

class CreateNFTView extends StatefulWidget {
  //const CreateNFTView({Key key}) : super(key: key);
  final TextEditingController nftNameController = TextEditingController();
  final TextEditingController nftDescriptionController =
      TextEditingController();
  final nftName = FocusNode();
  final nftDescription = FocusNode();

  @override
  _CreateNFTViewState createState() => _CreateNFTViewState();
}

class _CreateNFTViewState extends State<CreateNFTView> {
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
    //Putting the file on IPFS
    var promise = createNewNFT(_arguments[0], widget.nftNameController.text,
        widget.nftDescriptionController.text);
    await promiseToFuture(promise);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width - 150,
      height: MediaQuery.of(context).size.height,
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
                //height: 200,
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
                  child: _loadedFile != null ? _image : Text("No Picture"),
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
                      color: Colors.black, width: 1, style: BorderStyle.solid),
                  bottom: BorderSide(
                      color: Colors.black, width: 1, style: BorderStyle.solid),
                  left: BorderSide(
                      color: Colors.black, width: 1, style: BorderStyle.solid),
                  right: BorderSide(
                      color: Colors.black, width: 1, style: BorderStyle.solid),
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
          Container(
              //height: 250,
              width: 250,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: Colors.black, width: 1, style: BorderStyle.solid),
                  bottom: BorderSide(
                      color: Colors.black, width: 1, style: BorderStyle.solid),
                  left: BorderSide(
                      color: Colors.black, width: 1, style: BorderStyle.solid),
                  right: BorderSide(
                      color: Colors.black, width: 1, style: BorderStyle.solid),
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
            "Add to IPFS",
            _createNewNFT,
            [data],
          ),
        ],
      ),
    );
  }
}
