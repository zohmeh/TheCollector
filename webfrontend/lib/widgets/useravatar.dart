import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class Useravatar extends StatelessWidget {
  final image;

  Useravatar(this.image);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      //radius: 20,
      borderRadius: BorderRadius.circular(80),
      child: Image.memory(
        Uint8List.fromList(
          image.cast<int>(),
        ),
        height: 80,
        width: 80,
        fit: BoxFit.fill,
      ),
    );
  }
}
