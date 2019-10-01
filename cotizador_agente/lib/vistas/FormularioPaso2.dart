

import 'dart:async';
import 'dart:convert';

import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/modelos_widget/modelos_widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class FormularioPaso2 extends StatefulWidget {
  final String text;
  FormularioPaso2({Key key, @required this.text}) : super(key: key);
  @override
  _FormularioPaso2State createState() => _FormularioPaso2State();
}

class _FormularioPaso2State extends State<FormularioPaso2> {
  String something;


  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paso 2"),
      ),

      body: Column(

        children:<Widget>[
          Text(
          widget.text,
          style: TextStyle(fontSize: 24),),
        ]
        ),


      );

  }
}
