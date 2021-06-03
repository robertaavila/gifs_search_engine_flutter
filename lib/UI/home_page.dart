import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _search;

  int _offset;

  _getGifs() async {
    http.Response response;

    if(_search == null) {
      response = await http.get("https://api.giphy.com/v1/gifs/trending?api_key=1MlveLa9mPVcUtjwM7yvB0Q1bnYSxYY6&limit=25&rating=g");
    } else {
      response = await http.get("https://api.giphy.com/v1/gifs/search?api_key=1MlveLa9mPVcUtjwM7yvB0Q1bnYSxYY6&q=$_search&limit=25&offset=$_offset&rating=g&lang=pt");
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
