

import 'dart:async';
import 'dart:convert';

import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/modelos_widget/modelos_widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class FormularioPaso2 extends StatefulWidget {

  String something;
  FormularioPaso2(this.something);
  @override
  _FormularioPaso2State createState() => _FormularioPaso2State();
}

class _FormularioPaso2State extends State<FormularioPaso2> {
  String something;


  @override
  Widget build(BuildContext context) {
    return Container(

      child: Text(widget.something),
    );

  }
}
