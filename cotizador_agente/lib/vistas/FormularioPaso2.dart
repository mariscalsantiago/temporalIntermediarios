

import 'dart:async';
import 'dart:convert';

import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/modelos_widget/modelos_widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class FormularioPaso2 extends StatefulWidget {
  final String text;
  FormularioPaso2({Key key, @required this.text}) : super(key: key);
  @override
  _FormularioPaso2State createState() => _FormularioPaso2State();
}

class _FormularioPaso2State extends State<FormularioPaso2> {

  String _something ="Cargando... ";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _read();
  }

  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'PASO1';
    final value = prefs.getString(key) ?? "no hay";
    print('read: $value');

    setState(() {
      _something = value;


    });

  }







  @override

  Widget build(BuildContext context) {




    return Scaffold(
      appBar: AppBar(
        title: Text("PASO 2"),
      ),

      body: Column(

        children:<Widget>[
          Text(
          widget.text + _something,
          style: TextStyle(fontSize: 24),),
        ]
        ),


      );

  }
}
