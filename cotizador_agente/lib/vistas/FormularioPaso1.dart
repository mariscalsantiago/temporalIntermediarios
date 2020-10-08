import 'dart:async';
import 'dart:convert';

import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/modelos_widget/modelos_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'FormularioPaso2.dart';

class FormularioPaso1 extends StatefulWidget {
  FormularioPaso1({Key key, this.title}) : super(key: key);
  final String title;


  @override
  _FormularioPaso1State createState() => _FormularioPaso1State();
}

class _FormularioPaso1State extends State<FormularioPaso1> {

  Formulario data;


  Future<String> getData() async {
    var response = await http.get(
        Uri.encodeFull("https://gmm-cotizadores-uat.gnp.com.mx/cotizador/aplicacion?idAplicacion=2343"),
        headers: {
          "Accept": "application/json"
        }
    );


    if (response.statusCode == 200) {
      //return Formulario.fromJson(json.decode(response.body));
      this.setState(() {
        //data = json.decode(response.body);

        data = Formulario.fromJson(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load post');
    }


    print(data.nombre.toString());
    //print(data[1]["title"]);

    return "Success!";
  }


  @override
  void initState(){
    this.getData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data.nombre.toString()),

      ),
      body: Column(
        children: <Widget>[

          ListView.builder
            (
              itemCount: data.secciones.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return new Text(data.secciones[index].seccion);
              }
          )

        ],
      ),
    );
  }


  void _sendDataToSecondScreen(BuildContext context) {
   // String textToSend = textFieldController.text;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FormularioPaso2(text: "hola",),
        ));
  }


}

