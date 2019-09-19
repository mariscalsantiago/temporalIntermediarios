import 'dart:async';
import 'dart:convert';

import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


typedef OnDelete();

class FormularioDinamico extends StatefulWidget {


  Formulario data;
  String nombre;


  Future<String> getData() async {
    var response = await http.get(
        Uri.encodeFull("http://35.232.57.52:8008/cotizador/aplicacion?id_aplicacion=991"),
        headers: {
          "Accept": "application/json"
        }
    );

    if (response.statusCode == 200) {
      //return Formulario.fromJson(json.decode(response.body));

        data = Formulario.fromJson(json.decode(response.body));
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


  final state = _FormularioDinamicoState();


  @override
  _FormularioDinamicoState createState() => state;
}

class _FormularioDinamicoState extends State<FormularioDinamico> {

  final form = GlobalKey <FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding (
      padding: EdgeInsets.all(8.0),
      child: Card(
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              

              AppBar(
                actions: <Widget>[
                  IconButton(icon: Icon(Icons.delete), onPressed: (){})
                ],
              ),

              TextFormField(
                validator: (val)=> val.length>3 ? null : "Full Name",
                onSaved: (val) => widget.nombre = val,
              )






            ],
          ),
        ),
      ),
    );
  }



  bool esValido(){
    var valid  = form.currentState.validate();

  }




}
