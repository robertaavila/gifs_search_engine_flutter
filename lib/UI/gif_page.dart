import 'package:flutter/material.dart';

class GifPage extends StatelessWidget {

  final Map _gifdata;

  GifPage(this._gifdata);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifdata["title"]),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(_gifdata["images"]["fixed_height"]["url"]),
      ),
    );
  }
}
