import '../widgets/button.dart';
import '../providers/blockchain_wallet_interaction.dart';
import '../widgets/errorwindow.dart';
import '../screens/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletImportScreen extends StatefulWidget {
  static const routeName = '/wallet-import';

  @override
  _WalletImportScreenState createState() => _WalletImportScreenState();
}

class _WalletImportScreenState extends State<WalletImportScreen> {
  //insertOption(String _inputDescription, int _variant) {
  //  color1 = Colors.grey;
  //  color2 = Colors.grey;
  //  setState(() {
  //    inputDescription = _inputDescription;
  //    _variant == 1 ? color1 = Colors.green : color2 = Colors.green;
  //  });
  //}

  //Color color1 = Colors.grey;
  //Color color2 = Colors.grey;
  //bool isMemomic = false;
  bool isWallet = false;
  //String inputDescription = "Choose your way of importing you wallet";

  setWallet() {
    setState(() {
      isWallet = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future _login() async {
      await BlockchainWalletInteraction().getMyOwnAddress().catchError(
            (error) => errorWindow(
                ctx: context,
                title: "An error occured",
                content: error.message),
          );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => TabsScreen(0),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Import your Wallet"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Row(
            //  children: [
            //Expanded(
            //  child: RaisedButton(
            //    color: color1,
            //    child: Text("Create with Mneomic Phrase"),
            //    onPressed: () => setState(
            //      () {
            //        insertOption("Insert your mnemoic Phrase", 1);
            //        isMemomic = true;
            //      },
            //    ),
            //  ),
            //),
            //Expanded(
            //  child: RaisedButton(
            //    color: color2,
            //    child: Text("Create with private Key"),
            //    onPressed: () => setState(
            //      () => insertOption("Insert your private Key", 2),
            //    ),
            //  ),
            //),
            //],
            //),
            Expanded(
              child: TextFormField(
                decoration:
                    InputDecoration(labelText: "Insert your private Key"),
                onFieldSubmitted: (value) async {
                  final prefs = await SharedPreferences.getInstance();
                  //isMemomic == true
                  //    ? prefs.setString(
                  //        "privateKey",
                  //        BlockchainWalletInteraction().setPrivateKey(value),
                  //      )
                  //    :
                  prefs.setString("privateKey", value);
                  errorWindow(
                      ctx: context,
                      title: "Your wallet was imported succesfully",
                      content: Icon(Icons.check),
                      toDo: setWallet);
                },
              ),
            ),
            isWallet == false
                ? Container()
                : button(
                    Theme.of(context).buttonColor,
                    Theme.of(context).highlightColor,
                    "Go to The Collector Universe",
                    _login,
                  )
          ],
        ),
      ),
    );
  }
}
