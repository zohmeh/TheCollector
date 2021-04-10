//import './providers/markets.dart';
import '../providers/blockchain_interaction.dart';
import '../providers/blockchain_wallet_interaction.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/wallet_import_screen.dart';

import '../screens/nav_screen.dart';
import './screens/screen1_screen.dart';
import './screens/screen3_screen.dart';
import 'screens/myportfolio_screen.dart';
import './screens/tabs_screen.dart';
//import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //final test = await BlockchainInteraction().getMyOwnAddress();
  final prefs = await SharedPreferences.getInstance();
  final privateKey = prefs.getString("privateKey") ?? 0;
  runApp(MyApp(privateKey));
}

class MyApp extends StatelessWidget {
  MyApp(this.privateKey);
  final privateKey;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: BlockchainInteraction(),
        ),
        ChangeNotifierProvider.value(
          value: BlockchainWalletInteraction(),
        ),
      ],
      child: MaterialApp(
        title: 'TheCollector',
        theme: ThemeData(
            errorColor: Colors.red,
            buttonColor: Colors.blueAccent,
            highlightColor: Colors.white,
            primaryColor: Colors.grey[850],
            backgroundColor: Colors.white,
            accentColor: Colors.purpleAccent,
            textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                headline5: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white),
                headline4: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold))),
        routes: {
          "/": (ctx) => privateKey == 0 ? WalletImportScreen() : TabsScreen(1),
          Screen1.routeName: (ctx) => Screen1(),
          MyPortfolioScreen.routeName: (ctx) => MyPortfolioScreen(),
          Screen3.routeName: (ctx) => Screen3(),
          NavScreen.routeName: (ctx) => NavScreen()
        },
      ),
    );
  }
}
