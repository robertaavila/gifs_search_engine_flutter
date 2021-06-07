import 'package:flutter/material.dart';

import 'UI/home_page.dart';
import 'UI/gif_page.dart';

void main() {
  runApp(MaterialApp(
    //funçao main acessa a pagina home_page
    home: HomePage(),
    theme: ThemeData(hintColor: Colors.white),
  ));
}



