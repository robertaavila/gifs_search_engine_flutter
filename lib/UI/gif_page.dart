import 'package:flutter/material.dart';
import 'package:share/share.dart';

//pagina de detalhe do gif selecionado pelo usuário
//ela não tem alteraçao de estado, entao é stateless
class GifPage extends StatelessWidget {

  final Map _gifdata;

  //construtor da página
  GifPage(this._gifdata);

  @override
  //build de todo conteúdo da tela
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifdata["title"]),
        backgroundColor: Colors.black,
        actions: [
          //carrega o ícone de compartilhamento
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                Share.share(_gifdata["images"]["fixed_height"]["url"]);
              })
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        //carrega a imagem do gif
        child: Image.network(_gifdata["images"]["fixed_height"]["url"]),
      ),
    );
  }
}
