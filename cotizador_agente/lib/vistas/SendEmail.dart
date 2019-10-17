

import 'package:cotizador_agente/utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SendEmail extends StatefulWidget {
  @override
  _SendEmailState createState() => _SendEmailState();

}

class _SendEmailState extends State<SendEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF"),

      ),
      body: Column(
        children: <Widget>[

        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Row(
            children: <Widget>[

              Expanded(
               flex: 1,
                child: Text("Escoge la opción para envair la cotizacion"),

              ),

              Expanded(flex: 1,
              child: FloatingActionButton(
                //onPressed: (),
                heroTag: "btn1",
                tooltip: "agrega beneficiario",
                child: const Icon(Icons.clear),
                backgroundColor: Utilidades.color_primario,

                ),
              ),


            ],

          ),

        ),

          Row(
            children: <Widget>[
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: new Text("Mail"),
             ),

            ],

          ),
           Row(
            children: <Widget>[
               Flexible(
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: new TextFormField(
                     decoration: new InputDecoration(
                       labelText: "Enter Email",
                       fillColor: Colors.white,
                       border: new OutlineInputBorder(
                         borderRadius: new BorderRadius.circular(0.0),
                         borderSide: new BorderSide(
                         ),
                       ),

                       icon: Icon(Icons.email),
                       //fillColor: Colors.green
                     ),
                     validator: (val) {
                       if(val.length==0) {
                         return "Email cannot be empty";
                       }else{
                         return null;
                       }
                     },
                     keyboardType: TextInputType.emailAddress,
                     style: new TextStyle(
                       fontFamily: "Poppins",
                     ),
                   ),
                 ),
              ),

            ],
          ),

          Row(
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text("Mensaje"),
              ),
            ],

          ),

          Row(
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new TextFormField(
                  keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: 100,

                    decoration: new InputDecoration(
                      labelText: "Escribe tu mensaje",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(0.0),
                        borderSide: new BorderSide(
                        ),
                      ),
                    ),

                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
              ),

            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              FlatButton(
                color: Utilidades.color_primario,
                textColor: Colors.white,
                disabledColor: Utilidades.color_primario,
                disabledTextColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                splashColor: Utilidades.color_titulo,
                //onPressed: (),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "ENVIAR",
                    style: TextStyle(fontSize: 16.0, letterSpacing: 1),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
