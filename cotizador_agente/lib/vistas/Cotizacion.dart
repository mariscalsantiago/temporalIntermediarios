

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

        Row(


          children: <Widget>[

                Expanded(

                  child:  OutlineButton(
                    textColor: Colors.orange,
                    child: Text("COMPRAR PLAN"),
                    onPressed: () {},
                    borderSide: BorderSide(
                      color: Colors.orange, //Color of the border
                      style: BorderStyle.solid, //Style of the border
                      width: 0.8, //width of the border
                    ),
                  ),

                ),

                Expanded(

                  child:  FlatButton(
                    textColor: Colors.orange,
                    disabledColor: Colors.orange,
                    disabledTextColor: Colors.orange,
                    padding: EdgeInsets.all(8.0),
                    // splashColor: Colors.blueAccent,
                    onPressed: () {
                      /*...*/
                    },
                    child: Text(
                      "MÁS",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),

                ),

                Expanded(

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
                        child: Icon(Icons.more_vert),
                      )

                  ),

                ),

              ],


        ),

        Row(

        children: <Widget>[

        Container(
        height: 170.0,
        //color: Colors.grey,
          child: Column(
           // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Text(
                    ("Cotización "), maxLines: 2, overflow: TextOverflow.ellipsis,
                ),

              ),
              Expanded(

                flex: 1,
                child: Text(
                  ("Moises Lugo"), maxLines: 2, overflow: TextOverflow.ellipsis,
                ),

              ),

              Expanded(

                flex: 1,
                child: Text(
                  ("C.P 7382 "), maxLines: 2, overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 2,
                child: FlatButton(
                  textColor: Colors.orange,
                  disabledColor: Colors.orange,
                  disabledTextColor: Colors.orange,
                  padding: EdgeInsets.all(8.0),
                  // splashColor: Colors.blueAccent,
                  onPressed: () {
                    /*...*/
                  },
                  child: Text(
                    "Editar",
                    style: TextStyle(fontSize: 20.0),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
              Expanded(

                flex: 1,
                child: Text(
                  ("Hombre 26 años "), maxLines: 2, overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(

               flex: 1,
                child: Text(
                  ("Adicionales 2 "), maxLines: 2, overflow: TextOverflow.ellipsis,
                ),
              )

            ],
          ),


        )
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
