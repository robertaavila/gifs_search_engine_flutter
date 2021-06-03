import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GifPage extends StatelessWidget {

  final Map _gifdata;

  GifPage(this._gifdata);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifdata["title"]),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                Share.share(_gifdata["images"]["fixed_height"]["url"]);
              })
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(_gifdata["images"]["fixed_height"]["url"]),
      ),
    );
  }
}
