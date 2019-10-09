

import 'dart:async';
import 'dart:convert';
import 'package:cotizador_agente/modelos_widget/modelo_seccion.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Cotizacion extends StatefulWidget {
  @override
  _CotizacionState createState() => _CotizacionState();
}

class _CotizacionState extends State<Cotizacion> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
        title: Text("Cotización"),
    ),

    body: Column(

      children: <Widget>[

        Container(
          color: new Color(int.parse("F3F4F5", radix: 16)).withOpacity(1.0),
          child: Row(

            children: <Widget>[

                  Expanded(
                    flex: 10,

                    child:  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlineButton(
                        textColor: Colors.orange,
                        child: Text("COMPARAR PLAN"),
                        onPressed: () {},
                        borderSide: BorderSide(
                          color: Colors.orange, //Color of the border
                          style: BorderStyle.solid, //Style of the border
                          width: 0.8, //width of the border
                        ),
                      ),
                    ),

                  ),

                  Expanded(
                    flex: 3,
                    child:  Padding(
                      padding: const EdgeInsets.all(0),
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment(1, 0),
                        child: FlatButton(
                          padding: const EdgeInsets.all(0),
                          textColor: Colors.orange,
                          disabledColor: Colors.orange,
                          disabledTextColor: Colors.orange,
                          // splashColor: Colors.blueAccent,
                          onPressed: () {
                            /*...*/
                          },
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              "MÁS",
                              style: TextStyle(fontSize: 14.0),
                              textAlign: TextAlign.right,

                            ),
                          ),
                        ),
                      ),
                    ),

                  ),

                  Expanded(

                    flex: 1,
                    child: Container(
                      alignment: Alignment(-1, 0),
                      width: double.infinity,
                      child: (
                          PopupMenuButton(

                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: Text(
                                  "Guardar",
                                  style: TextStyle(
                                      color: Colors.orange, fontWeight: FontWeight.w700),
                                ),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: Text(
                                  "Limpiar datos",
                                  style: TextStyle(
                                      color: Colors.orange, fontWeight: FontWeight.w700),
                                ),
                              ),
                              PopupMenuItem(
                                value: 3,
                                child: Text(
                                  "Imprimir",
                                  style: TextStyle(
                                      color: Colors.orange, fontWeight: FontWeight.w700),
                                ),
                              ),
                              PopupMenuItem(
                                value: 4,
                                child: Text(
                                  "Material de apoyo",
                                  style: TextStyle(
                                      color: Colors.orange, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                            initialValue: 2,
                            onCanceled: () {
                              print("You have canceled the menu.");
                            },
                            onSelected: (value) {
                              print("value:$value");
                            },
                            child: Icon(Icons.more_vert, color: Colors.orange,),
                          )

                      ),
                    ),

                  ),

                ],


          ),
        ),

        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  child: Divider( //002e71
                    thickness: 2,
                    color: Color(int.parse("002e71", radix: 16)).withOpacity(1.0),

                    height: 0,
                  )),
            ),
          ],
        ),

        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                ("Cotización"), maxLines: 2, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ],
        ),

        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                          child: Text("hola",
                            textAlign: TextAlign.left,)),
                      Container(
                          width: double.infinity,
                          child: Text("hola",
                            textAlign: TextAlign.left,)),
                      Container(
                          width: double.infinity,
                          child: Text("hola",
                            textAlign: TextAlign.left,)),
                      Container(
                          width: double.infinity,
                          child: Text("hola",
                            textAlign: TextAlign.left,)),

                    ],
                  ),
                )
            ),
            Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    textColor: Colors.orange,
                    disabledColor: Colors.orange,
                    disabledTextColor: Colors.orange,
                    // splashColor: Colors.blueAccent,
                    onPressed: () {
                      /*...*/
                    },
                    child: Container(
                      width: double.infinity,
                      child: Text(
                        "Editar",
                        style: TextStyle(fontSize: 14.0),
                        textAlign: TextAlign.right,

                      ),
                    ),
                  ),

                ))
          ],
        ),



        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Card(
              child: new InkWell(
                onTap: () {
                  print("tapped");
                },
                child: Container(
                  width: 200.0,
                  height: 100.0,
                  color: Colors.indigo,
                  child: Text('Anual\n \n (1500,000)'),
                ),
              ),
            ),

          ],

        )

      ],
    )



    );



  }
}
