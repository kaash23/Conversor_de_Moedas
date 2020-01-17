import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=72c40828 ";

void main() async {
  print(await getData());

  runApp(MaterialApp(home: Home(),
  theme: ThemeData(
    hintColor: Colors.amber,
    primaryColor: Colors.white
  )));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return jsonDecode(response.body);
} //Busca informação de json da API

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

final realController = TextEditingController();
final dolarController = TextEditingController();
final euroController = TextEditingController();

double dolarfora;
double eurofora;

void _realChanged(String text){
  double real = double.parse(text);
  dolarController.text = (real / dolarfora).toStringAsPrecision(2);
  euroController.text = (real / eurofora).toStringAsPrecision(2);
} // Função de calculo Reais

void _dolarChanged(String text){
  double dolar = double.parse(text);
  realController.text = (dolar * dolarfora).toStringAsPrecision(2);
  euroController.text = (dolar * dolarfora / eurofora).toStringAsPrecision(2);
} //Função de Calculo Dolares

void _euroChanged(String text){
  double euro = double.parse(text);
  realController.text = (euro * eurofora).toStringAsPrecision(2);
  dolarController.text = (euro * eurofora / dolarfora).toStringAsPrecision(2);
} // Função de calculo Euros

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("\$ Conversor \$"),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child: Text(
                  "Carregando dados...",
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  textAlign: TextAlign.center,
                )); //Carregando dados da API
              default:
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    "Erro ao carregar dados...",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  )); //Dados carregados com Erro
                } else {
                  dolarfora = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  eurofora = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on, size: 150.0, color: Colors.amber), //Icone do Topo
                        buildTextField("Reais", "R\$", realController, _realChanged), // Campo Reais
                        Divider(), //Espaço entre campos
                        buildTextField("Dólares", "US\$", dolarController, _dolarChanged), //Campo Dolar
                        Divider(), //Espaço entre campos
                        buildTextField("Euro", "€", euroController, _euroChanged), //Campo Euro €
                      ],
                    )
                  ); //Corpo do App
                }
            }
          },
        ));
  }
}

Widget buildTextField( String label, String prefix, TextEditingController control,
    Function f){
  return TextField(
    controller: control,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
          color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: TextStyle(
      color: Colors.amber, fontSize: 25.0,
    ),
    onChanged: f,
    keyboardType: TextInputType.number,
  ); //Fução de montagem dos campos
}