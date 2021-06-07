import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gif_search_engine/UI/gif_page.dart';

import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;

  int _offset;

  _getGifs() async {
    http.Response response;
    //se a busca não tiver sido preenchida, a pagina carrega os trending gifs
    if (_search == null) {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=1MlveLa9mPVcUtjwM7yvB0Q1bnYSxYY6&limit=10&rating=g");
    } else {
      //se a busca for preenchida, a pagina usa a string search na busca e exibe o resultado
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=1MlveLa9mPVcUtjwM7yvB0Q1bnYSxYY6&q=$_search&limit=9&offset=$_offset&rating=g&lang=pt");
    }
    //o retorno acessa o json recebido
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        //na barra do topo o app usa a imagem do site giphy
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            //campo para inserção da palavra a ser pesquisada
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquise aqui",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                ),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              //acionado quando o enviar é clicado no teclado
              onSubmitted: (text) {
                setState(() {
                  //ao fazer a busca, o estado é atualizado de acordo com as infos inseridas
                  _search = text;
                  //o offset é zerado quando se faz uma nova busca para mostrar os gifs desde
                  //o começo da lista
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              //chama a função que faz a consulta da URL
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      //indicador de progresso
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    //em caso de erro retorna um container vazio
                    if (snapshot.hasError)
                      return Container();
                    else
                      // se o retorno não der erro e não for waiting, o app chama a funcao
                      //para criar a gifTable, passa o resultado da busca como snapshot e context
                      //para o builder
                      return _createGifTable(context, snapshot);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  //verifica se a busca foi preenchida para definir o numero de gifs exibidos
  int _getCount(List data) {
    if (_search == null || _search.isEmpty) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context, index) {
        if (_search == null || index < snapshot.data["data"].length) {
          //gestureDetector verifica se a imagem foi clicada
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data["data"][index]["images"]["fixed_height"]
                  ["url"],
              height: 300.0,
              fit: BoxFit.cover,
            ),
            onTap: () {
              //se a imagem for clicada, abre o gif selecionado via route
              Navigator.push(
                  context,
                  //cria uma rota para a proxima pagina
                  MaterialPageRoute(
                      builder: (context) =>
                          GifPage(snapshot.data["data"][index])));
            },
            //se apertar e segurar abre o gif selecionado para compartilhar
            onLongPress: () {
              Share.share(snapshot.data["data"][index]["images"]["fixed_height"]
                  ["url"]);
            },
          );
        } else {
          return Container(
              child: GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //inserir o ícone + no carregar mais
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 70.0,
                ),
                Text(
                  "Carregar mais...",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ],
            ),
            onTap: () {
              //cada vez que ele é clicado carrega mais 7 gifs
              setState(() {
                _offset += 7;
              });
            },
          ));
        }
      },
    );
  }
}
