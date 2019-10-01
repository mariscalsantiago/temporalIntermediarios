
import 'dart:async';
import 'dart:convert';
import 'package:cotizador_agente/modelos_widget/modelo_seccion.dart';
import 'package:cotizador_agente/vistas/FormularioPaso2.dart';
import 'package:flutter/cupertino.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:http/http.dart' as http;
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:flutter/material.dart';
import 'package:cotizador_agente/modelos/modelos.dart';
import 'package:cotizador_agente/modelos_widget/modelos_widgets.dart';
import 'package:load/load.dart';


void main() {
  runApp(
    LoadingProvider(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GNP',
      theme: ThemeData(primaryColor: Colors.white),
      home: MyHomePage(title: 'GNP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  final colorHex = const Color(0xFFCECFD1);
  final colorLetters = const Color(0xFF002E71);
  bool reNew = false;
  bool isLoading = true;

  Paint _paint;

  Drawhorizontalline() {
    _paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
  }


  refresh() {
    setState(() {});
  }



  Formulario data;

  Future<String> getData() async {
    var response = await http.get(
        Uri.encodeFull("http://35.232.57.52:8008/cotizador/aplicacion?id_aplicacion=1438"),
        headers: {
          "Accept": "application/json"
        }
    );


    if (response.statusCode == 200) {
      //return Formulario.fromJson(json.decode(response.body));
      this.setState(() {
        //data = json.decode(response.body);
        isLoading = false;
        data = Formulario.fromJson(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load post');
    }

    return "Success!";
  }


  @override
  void initState(){
    this.getData();
  }


  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(-90.0, 0.0), Offset(90.0, 0.0), _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  @override
  Widget build(BuildContext context) {




    return Scaffold(
      appBar: AppBar(
        title: Text("Paso 1"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          Expanded(

            child: isLoading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : new ListView.builder
              (
                itemCount: data.secciones.length-1,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (BuildContext ctxt, int index) {

                  return Padding(

                    padding: const EdgeInsets.all(16.0),
                    child: new SeccionDinamica(notifyParent:refresh,secc: data.secciones[index], i:index, end:data.secciones.length-1, cantidad_asegurados: data.cantidad_asegurados, ),

                  );

                }

            ),

          ),


        ]

      ),

    );


  }



}





