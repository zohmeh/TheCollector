import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<Widget> showUpWindow(
    {BuildContext context,
    Future futureFunction,
    String title,
    dynamic content,
    Function toDo}) {
  return showDialog(
      context: context,
      builder: (context) {
        //return FutureBuilder(
        //  future: futureFunction,
        //  builder: (context, response) {
        //    if (response.connectionState == ConnectionState.waiting) {
        //      return Center(
        //        child: CircularProgressIndicator(),
        //      );
        //    } else {
        //      if (response.error != null) {
        //        return AlertDialog(
        //          title: Text("An error occured"),
        //          content: Text(
        //            response.error.toString(),
        //          ),
        //        );
        //      } else {
        return AlertDialog(
          title: Text(title),
          content: content.runtimeType == String
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(content + "\n"),
                    InkWell(
                      child: Text(
                        "https://kovan.etherscan.io/tx/", // + response.data,
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () => launch("https://kovan.etherscan.io/tx/"),

                      ///response.data),
                    )
                  ],
                )
              : content,
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                toDo();
              },
              child: Text("OK"),
            ),
          ],
        );
        //}
      }
      //},
      );
  //},
  //);
}
