//import './providers/markets.dart';
import '../screens/nav_screen.dart';
import './screens/screen1_screen.dart';
import './screens/screen3_screen.dart';
import './screens/screen2_screen.dart';
import './screens/tabs_screen.dart';
//import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return //MultiProvider(
        //providers: [
        //  ChangeNotifierProvider.value(
        //    value: ExampleProvider(),
        //  ),
        //],
        //child:
        MaterialApp(
      title: 'moile_app_template',
      theme: ThemeData(
          errorColor: Colors.red,
          primaryColor: Colors.black,
          backgroundColor: Colors.grey,
          accentColor: Colors.orange,
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
        "/": (ctx) => TabsScreen(0),
        Screen1.routeName: (ctx) => Screen1(),
        Screen2.routeName: (ctx) => Screen2(),
        Screen3.routeName: (ctx) => Screen3(),
        NavScreen.routeName: (ctx) => NavScreen()
      },
      //),
    );
  }
}
